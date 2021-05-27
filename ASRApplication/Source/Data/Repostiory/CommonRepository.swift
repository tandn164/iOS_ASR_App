//
//  CommonRepository.swift
//

import Foundation
import RxSwift

class CommonRepository: AppRemoteRepository<BaseDto> {
    let commonRequest = RequestFactory.commonRequest
    init() {
        super.init(request: commonRequest)
    }
    
    func getTagsList() -> Observable<TagResultDto> {
        return commonRequest.getTagsList(options: [:])
            .map({(response: HttpResponse) -> TagResultDto in
                let object = TagResultDto(fromJson: response.data)
                return object
            })
    }
}
