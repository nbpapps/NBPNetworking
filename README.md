# NBPNetworking
A Swift networking package.

Supports async/await and closure.


## Using it in your project.
```
In Xcode navigate to File -> Add Package Dependencies...
Enter this URL - https://github.com/nbpapps/NBPNetworking
```

**Adding the package:**

In the file that makes network calls, add the following code:
```swift
import Foundation
import NBPNetworking

class MyClass {

  private lazy var networkAccess = newNetworkAccess()

  // Making an async/await request
  private func makeAsyncNetworkRequest() {
    let url = ...
    let request = Request(url: url, method: .get)

    Task {
      do {
        let data = try await self.networkAccess.fetchData(for: request)
        // Do something with the data
      } catch {
        // Handle error
      }
    }
  }

  // Making a closure based request
  private func makeClosureNetworkRequest() {
    let url = ...
    let request = Request(url: url, method: .get)
    self.networkAccess.fetchData(for: request) { result in
      switch result {
        case .success(let data):
          // Do something with the data
        case .failure(let error):
          // Handle error
      }
    }
  }

  private func newNetworkAccess() -> NetworkAccessing {
    return URLSessionNetworkAccess()
  }
}
```
