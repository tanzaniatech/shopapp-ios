//
//  AddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

typealias AddressFormCompletion = (_ address: Address) -> Void

class AddressFormViewModel: BaseViewModel {
    var countryText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var addressOptionalText = Variable<String>("")
    var cityText = Variable<String>("")
    var stateText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    var addressSubmitted = PublishSubject<()>()
    var address: Address?
    var completion: AddressFormCompletion?
    
    private var requiredTextFields: [Observable<String>] {
        return [countryText, firstNameText, lastNameText, addressText, cityText, zipText, phoneText].map({ $0.asObservable() })
    }
    
    var isAddressValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { (textFields) in
            return textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).isEmpty
        })
    }
    var submitTapped: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.submitAction()
        }
    }
    
    func updateFields() {
        guard let address = address else {
            return
        }
        countryText.value = address.country ?? ""
        firstNameText.value = address.firstName ?? ""
        lastNameText.value = address.lastName ?? ""
        addressText.value = address.address ?? ""
        addressOptionalText.value = address.secondAddress ?? ""
        cityText.value = address.city ?? ""
        stateText.value = address.state ?? ""
        zipText.value = address.zip ?? ""
        phoneText.value = address.phone ?? ""
    }
        
    private func submitAction() {
        completion?(getAddress())
        addressSubmitted.onNext()
    }
 
    private func getAddress() -> Address {
        let address = Address()
        address.id = self.address?.id ?? ""
        address.country = countryText.value.trimmingCharacters(in: .whitespaces)
        address.firstName = firstNameText.value.trimmingCharacters(in: .whitespaces)
        address.lastName = lastNameText.value.trimmingCharacters(in: .whitespaces)
        address.address = addressText.value.trimmingCharacters(in: .whitespaces)
        address.secondAddress = addressOptionalText.value.trimmingCharacters(in: .whitespaces)
        address.city = cityText.value.trimmingCharacters(in: .whitespaces)
        address.state = stateText.value.trimmingCharacters(in: .whitespaces)
        address.zip = zipText.value.trimmingCharacters(in: .whitespaces)
        address.phone = phoneText.value.trimmingCharacters(in: .whitespaces)

        return address
    }
}