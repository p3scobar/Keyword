//
//  AmountController.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase
//import MPNumericTextField

class AmountController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var publicKey: String?
    var amount: Decimal = 0.0
    var username: String?
    
    convenience init(publicKey: String?) {
        self.init()
        self.publicKey = publicKey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Amount"
        view.backgroundColor = Theme.darkBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        setupView()
    }
    
    
    func handleError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleCancel() {
        amountInput.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSubmit() {
        guard let pk = publicKey else { return }
        let rounded = amount.roundedDecimal()
        
        let data: [String:Any] = ["type": PaymentType.send,
                                  "to": pk,
                                  "username": username ?? "",
                                  "amount":rounded]
        print(data)
        
        let vc = ConfirmPaymentController(type: .send, data: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        amountInput.becomeFirstResponder()
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        if let text = textField.text, text.count > 0 {
            amount = Decimal(string: text) ?? 0.0
            print(amount)
        }
    }
    
    
    override var inputAccessoryView: UIView? {
        return confirmButton
    }
    
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        return button
    }()
    
    
    var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    lazy var amountInput: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "0.000", attributes: [NSAttributedStringKey.foregroundColor: Theme.gray])
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        field.keyboardAppearance = UIKeyboardAppearance.dark
        field.font = Theme.bold(36)
        field.textColor = .white
        field.borderStyle = UITextBorderStyle.none
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var captionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = Theme.semibold(24)
        view.textColor = Theme.gray
        view.text = "SGR"
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.border
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(captionLabel)
        
        amountInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        amountInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        amountInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        amountInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: amountInput.bottomAnchor, constant: 0).isActive = true
        captionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //        separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        separatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //        separatorLine.topAnchor.constraint(equalTo: currencyAmountLabel.bottomAnchor, constant: 80).isActive = true
        
    }
    
}

