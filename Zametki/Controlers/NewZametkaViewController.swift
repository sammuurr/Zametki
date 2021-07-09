//
//  NewZametkaViewController.swift
//  Zametki
//
//  Created by ADMIMN on 09.07.2021.
//

import UIKit
import CoreData

class NewZametkaViewController: UIViewController, UITextViewDelegate{

    @IBOutlet var height: NSLayoutConstraint!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    @IBOutlet var bodyTextViewConstraint: NSLayoutConstraint!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var doneAction: UIBarButtonItem!
    var objektId: NSManagedObjectID? = nil
    var groups: Group? = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objektId != nil{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let objekt = context.object(with: objektId!) as! Zametka
            
            titleTextView.text = objekt.contentTitle
            bodyTextView.text = objekt.contentBody
            
        }
        doneAction.isEnabled = false
        
        if !titleTextView.hasText {
            titleTextView.text = "Загаловок"
            titleTextView.textColor = .lightGray
        }
        if !bodyTextView.hasText {
            bodyTextView.text = "Заметка"
            bodyTextView.textColor = .lightGray
        }
        
        textViewHeight.constant = titleTextView.intrinsicContentSize.height
        bodyTextViewConstraint.constant = bodyTextView.intrinsicContentSize.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView{
            textViewHeight.constant = titleTextView.intrinsicContentSize.height
        }else{
            bodyTextViewConstraint.constant = bodyTextView.intrinsicContentSize.height
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == titleTextView{
                textView.text = "Загаловок"
                textView.textColor = UIColor.lightGray
            }else{
                textView.text = "Заметка"
                textView.textColor = UIColor.lightGray
            }
        }
    }

    @IBAction func allTapRecoginazer(_ sender: UITapGestureRecognizer) {
        bodyTextView.becomeFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        doneAction.isEnabled = true
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        height.constant = keyboardSize!.height
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        height.constant = 10
    }

    @IBAction func doneMethod(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if objektId == nil{
            let newZametka = Zametka(context: context)
            newZametka.contentTitle = titleTextView.text
            newZametka.contentBody = bodyTextView.text
            newZametka.id = UUID()
            newZametka.name = titleTextView.text
            objektId = newZametka.objectID
            
            if groups != nil{
                newZametka.addToGroup(groups!)
            }
            newZametka.addToGroup(context.object(with: allZametkiGroup!) as! Group)
            
            
        }else{
            let objekt = context.object(with: objektId!) as! Zametka
            
            objekt.contentTitle = titleTextView.text
            objekt.contentBody = bodyTextView.text
            objekt.name = titleTextView.text
        }
        
        try? context.save()
    }
}
