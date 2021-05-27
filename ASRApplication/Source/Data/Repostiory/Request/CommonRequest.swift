//CommonRequest.swift

import RxSwift

class CommonRequest: AppRequest<BaseDto> {
    func getTagsList(options: [String: Any]) -> Observable<HttpResponse> {
        let url = AppConfig.server + "tags"
        let params = createRequestParams(options: options)
        return createResponseObservable(method: .GET, url: url, params: params)
    }
}
