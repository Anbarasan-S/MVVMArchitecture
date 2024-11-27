//
//  TodoInputViewController.swift
//  MVVMArchitecture
//
//  Created by Anbarasan S on 21/11/24.
//

import UIKit

protocol TodoInputViewDelegate {
    func saveTapped(taskTitle: String, completed: Bool)
}


class TodoInputViewController: UIViewController {

    //MARK: PRIVATE PROPERTIES
    private lazy var bottomLayer: CALayer = {
       let bottomLayer = CALayer()
        bottomLayer.borderColor = UIColor.systemBlue.cgColor
        bottomLayer.borderWidth = 1
        
        return bottomLayer
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        label.text = NSLocalizedString("add_task", comment: "")
        
        return label
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.alpha = 0.5
        button.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        button.setTitle(NSLocalizedString("add", comment: ""), for: .disabled)
        button.addTarget(self, action: #selector(didSaveTaskTapped), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var textField: UITextField = {
       let textField = UITextField()
        textField.layer.addSublayer(bottomLayer)
        textField.placeholder = "Add new task"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .systemBlue
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var completedLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Completed"
        label.font = .systemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var completedSwitch: UISwitch = {
       let aSwitch = UISwitch()
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return aSwitch
    }()
    
    var todoInputViewDelegate: TodoInputViewDelegate?
    
    //MARK: VIEW LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewConfig()
    }
    
    override func viewDidLayoutSubviews() {
        bottomLayer.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
    }
    
    //MARK: PRIVATE METHODS
    private func viewConfig() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(addTaskButton)
        view.addSubview(completedLabel)
        view.addSubview(completedSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            completedLabel.centerYAnchor.constraint(equalTo: completedSwitch.centerYAnchor),
            completedLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            
            completedSwitch.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            completedSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            completedSwitch.widthAnchor.constraint(equalToConstant: 44),
            completedSwitch.heightAnchor.constraint(equalToConstant: 44),
            
            addTaskButton.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            addTaskButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            addTaskButton.topAnchor.constraint(equalTo: completedSwitch.bottomAnchor, constant: 25),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    //MARK: SELECTOR METHODS
    @objc private func didSaveTaskTapped() {
        if let textFieldText = textField.text, !textFieldText.isEmpty {
            todoInputViewDelegate?.saveTapped(taskTitle: textFieldText, completed: completedSwitch.isOn)
            self.dismiss(animated: true)
        }
        else {
            self.dismiss(animated: true)
        }
    }
    
}

extension TodoInputViewController: UITextFieldDelegate {
    // MARK: TextFieldDelegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This is to check if the string is empty and disable the button if empty and vice versa
        //If the range.length is greater than 1 then a text is removed
        if(range.length >= 1) {
            if let textFieldText = textField.text {
                let text = textFieldText.prefix(range.location)
                var replacedString = text.replacingOccurrences(of: " ", with: "")
                replacedString = replacedString.replacingOccurrences(of: " ", with: "")
                if replacedString.isEmpty {
                    addTaskButton.isEnabled = false
                    addTaskButton.alpha = 0.5
                }
                else {
                    addTaskButton.isEnabled = true
                    addTaskButton.alpha = 1
                }
            }
            else {
                var replacedString = string.replacingOccurrences(of: " ", with: "")
                replacedString = replacedString.replacingOccurrences(of: " ", with: "")
                if replacedString.isEmpty {
                    addTaskButton.isEnabled = false
                    addTaskButton.alpha = 0.5
                }
                else {
                    addTaskButton.isEnabled = true
                    addTaskButton.alpha = 1
                }
            }
        }
        else {
            var replacedString = string.replacingOccurrences(of: " ", with: "")
            replacedString = replacedString.replacingOccurrences(of: "\n", with: "")
            var textFieldText = textField.text!.replacingOccurrences(of: " ", with: "")
            textFieldText = textFieldText.replacingOccurrences(of: "\n", with: "")
            if replacedString.isEmpty &&  textFieldText.isEmpty {
                addTaskButton.isEnabled = false
                addTaskButton.alpha = 0.5
            }
            else {
                addTaskButton.isEnabled = true
                addTaskButton.alpha = 1
            }
        }
        return true
    }
}
