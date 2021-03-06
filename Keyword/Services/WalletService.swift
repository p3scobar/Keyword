//
//  WalletService.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import stellarsdk
import Alamofire

struct WalletService {
    
    static let mnemonic = Wallet.generate24WordMnemonic()
    static var keyPair: KeyPair?
    
    static func generateKeyPair(mnemonic: String, completion: @escaping (KeyPair) -> Void) {
        print(mnemonic)
        let keyPair = try! Wallet.createKeyPair(mnemonic: mnemonic, passphrase: nil, index: 0)
        completion(keyPair)
    }
    
    
    /// CREATE TEST ACCOUNT
    
    static func createStellarTestAccount(accountID:String, completion: @escaping (Any?) -> Swift.Void) {
        
        Stellar.sdk.accounts.createTestAccount(accountId: accountID) { (response) -> (Void) in
            switch response {
            case .success(let details):
                changeTrust(completion: { (trusted) in
                    print("Trustline set: \(trusted)")
                    completion(details)
                })
            case .failure(let error):
                completion(nil)
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func getAccountDetails(completion: @escaping (String) -> Swift.Void) {
        print("*********** ACCOUNT DETAILS ***********")
        let accountId = KeychainHelper.publicKey
        print("ACCOUNT ID from keychain: \(accountId)")
        Stellar.sdk.accounts.getAccountDetails(accountId: accountId) { (response) -> (Void) in
            switch response {
            case .success(let accountDetails):
                accountDetails.balances.forEach({ (balance) in
                    if balance.assetCode == "KEY" {
                        completion(balance.balance)
                    }
                })
            case .failure(let error):
                completion("")
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func changeTrust(completion: @escaping (Bool) -> Void) {
        guard let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            completion(false)
            return
        }
        
        let issuerAccountID = Assets.KEY.issuerAccountID
        guard let issuerKeyPair = try? KeyPair(accountId: issuerAccountID) else {
            completion(false)
            return
        }
        
        guard let asset = Asset.init(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "KEY", issuer: issuerKeyPair) else {
            completion(false)
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: KeychainHelper.publicKey) { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                do {
                    let changeTrustOperation = ChangeTrustOperation(sourceAccount: sourceKeyPair, asset: asset, limit: 10000000000)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [changeTrustOperation],
                                                      memo: nil,
                                                      timeBounds: nil)
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction, response: { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            completion(true)
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion(false)
                        }
                    })
                    
                }
                catch {
                    completion(false)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    
    static func fetchAssets(completion: @escaping ([String]) -> Swift.Void) {
        Stellar.sdk.assets.getAssets { (response) -> (Void) in
            switch response {
            case .success(let details):
                for asset in details.records {
                    let assetResponse = asset as AssetResponse
                    print("Asset Amount: \(assetResponse.amount)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func fetchSavedPayments(completion: @escaping ([Payment]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var feed = Payment.fetchAll(in: PersistenceService.context)
            feed.sort { (s0, s1) -> Bool in
                s0.timestamp > s1.timestamp
            }
            if feed.count > 0 {
                completion(feed)
            } else {
                completion(nil)
            }
        }
    }
    
    
    static func fetchTransactions(completion: @escaping ([Payment]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/payments"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
            var payments = [Payment]()
            payments = Payment.fetchAll(in: PersistenceService.context)
            Alamofire.request(url, method: .post, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["payments"] as? [[String:Any]] else {
                        completion(nil)
                        return
                }
                results.forEach({ (data) in
                    let id = data["_id"] as? String ?? ""
                    let payment = Payment.findOrCreatePayment(id: id, data: data, in: PersistenceService.context)
                    if !payments.contains(payment) {
                        payments.append(payment)
                    }
                })
                let sorted = payments.sorted(by: { (s0, s1) -> Bool in
                    s0.timestamp > s1.timestamp
                })
                completion(sorted)
            }
        }
    }
    

    
    static func streamPayments(completion: @escaping (Payment) -> Swift.Void) {
        let accountID = KeychainHelper.publicKey
        let issuerID = Assets.KEY.issuerAccountID
        let issuingAccountKeyPair = try? KeyPair(accountId:  issuerID)
        let KEY = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "KEY", issuer: issuingAccountKeyPair)
        
        Stellar.sdk.payments.stream(for: .paymentsForAccount(account: accountID, cursor: "now")).onReceive { (response) -> (Void) in
            switch response {
            case .open:
                break
            case .response(let id, let operationResponse):
                if let paymentResponse = operationResponse as? PaymentOperationResponse {
                    if paymentResponse.assetCode == KEY?.code {
                        let isReceived = paymentResponse.from != accountID ? true : false
                        let date = paymentResponse.createdAt
                        let amount = paymentResponse.amount
                        let data = ["amount":amount,
                                    "id":paymentResponse.id,
                                    "date":date,
                                    "isReceived":isReceived] as [String : Any]
                        let payment = Payment.findOrCreatePayment(id: paymentResponse.id, data: data, in: PersistenceService.context)
                        completion(payment)
                        
                        print("Payment of \(paymentResponse.amount) KEY from \(paymentResponse.sourceAccount) received -  id \(id)" )
                    }
                }
            case .error(let err):
                print(err!.localizedDescription)
            }
        }
    }
    
    
    static func savePayment(to: String, amount: Decimal) {
        let urlString = "\(baseUrl)/payment"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let amountString = amount
        let params: [String:Any] = ["to":to, "amount":amountString]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
            }
        }
    }

    
    static func sendPayment(accountId: String, amount: Decimal, completion: @escaping (Bool) -> Void) {
        
        print("Account ID: \(accountId)")
        print("Amount: \(amount)")
        print("Public Key: \(KeychainHelper.publicKey)")
        print("Private Key: \(KeychainHelper.privateSeed)")
        
        guard KeychainHelper.privateSeed != "",
            let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
                DispatchQueue.main.async {
                    print("NO SOURCE KEYPAIR")
                    completion(false)
                }
                return
        }
        
        let issuerID = Assets.KEY.issuerAccountID
        
        guard let issuerKeyPair = try? KeyPair(accountId: issuerID) else {
            print("NO ISSUER KEYPAIR")
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        guard  let destinationKeyPair = try? KeyPair(publicKey: PublicKey.init(accountId: accountId), privateKey: nil) else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: sourceKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
            case .success(let accountResponse):
                do {
                    let asset = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "KEY", issuer: issuerKeyPair)!
                    
                    let paymentOperation = PaymentOperation(sourceAccount: sourceKeyPair,
                                                            destination: destinationKeyPair,
                                                            asset: asset,
                                                            amount: amount)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [paymentOperation],
                                                      memo: nil,
                                                      timeBounds:nil)
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            savePayment(to: accountId, amount: amount)
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        case .failure(let error):
                            
                            let xdr = try! transaction.getTransactionHash(network: Stellar.network)
                            print(xdr)
                            
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        print("FAILED TO GET ACCOUNT")
                        completion(false)
                    }
                }
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    
}
