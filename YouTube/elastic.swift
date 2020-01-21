




import Logging
import ElasticSwift
import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import ElasticSwiftNetworking

class  elastic{
    var ip:String = "http://120.126.16.88:9200"
    var client:ElasticClient

    init(){
        self.ip = "http://120.126.16.88:9200"
        let cred = BasicClientCredential(username: "elastic", password: "elastic")
        let certPath = "/path/to/certificate.der"
        let sslConfig = SSLConfiguration(certPath: certPath, isSelf: true)
        let adaptorConfig = URLSessionAdaptorConfiguration(sslConfig: sslConfig)
        let settings = Settings(forHosts: [ip], withCredentials: cred, adaptorConfig: adaptorConfig)
        self.client = ElasticClient(settings: settings)
    }
    
    func InitElastic(){
        print("fsd createindexrequest")
        
       
        //let createIndexRequest = CreateIndexRequest(name: "fsd2")
        print("fsd createindexrequest")
        //client.indices.create(createIndexRequest, completionHandler: self.createHandler) // executes request
        
        
        let indexRequest = try! IndexRequestBuilder<ilivenetuser>() { builder in
            _ = builder.set(index: "user")
                .set(type: "ilivnetuser")
                .set(id: ilivenetUser.email)
                .set(source: ilivenetUser)
            }
            .build()
        self.client.index(indexRequest, completionHandler: self.indexHandler)
        print("fsd createindexrequest")
    }
    
    
    func createHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
        switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
        }
    }
    
    // creating index
    // index document
    func indexHandler(_ result: Result<IndexResponse, Error>) -> Void {
        switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
        }
        
    }

//    func handler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
//        switch result {
//        case .failure(let error):
//            print("Error", error)
//        case .success(let response):
//            print("Response", response)
//        }
//    }
//
//    func inithistory(){
//
//        let queryBuilder = QueryBuilders.boolQuery()
//
//        let match = QueryBuilders.matchQuery().match(field: "myField", value: "MySearchValue")
//        queryBuilder.must(query: match)
//
//        let sort =  SortBuilders.fieldSort("msg") // use "msg.keyword" as field name in case of text field
//            .set(order: .asc)
//            .build()
//
//        let request = try! SearchRequestBuilder() { builder in
//            builder.set(indices: "indexName")
//                .set(types: "type")
//                .set(query: queryBuilder.query)
//                .set(sort: sort)
//            } .build()
//
//        self.client.search(request, completionHandler: handler)
//    }
    
    


}

