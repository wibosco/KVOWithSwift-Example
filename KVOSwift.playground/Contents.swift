import UIKit

class KVOWithMethod: NSObject {
    
    let progress = Progress(totalUnitCount: 5)
    
    override init() {
        super.init()
        progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: .new, context: nil)
    }
    
    deinit {
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
            let change = change,
            let newValue = change[.newKey] as? Double else {
                print("No new value")
                return
        }

        switch keyPath {
        case #keyPath(Progress.fractionCompleted):
            let percentage = String(format: "%.2f", (newValue * 100))
            print("Completed: \(percentage)")
        default:
            break
        }
    }
}

class KVOWithClosure {
    
    let progress = Progress(totalUnitCount: 5)
    private var ob: NSKeyValueObservation?
    
    init() {
        ob = progress.observe(\.fractionCompleted, options: .new, changeHandler: { (progress, change) in
            guard let newValue = change.newValue else {
                print("No new value")
                return
            }
            let percentage = String(format: "%.2f", (newValue * 100))
            print("Completed: \(percentage)")
        })
    }
    
    deinit {
        ob?.invalidate()
    }
}

print("KVO with method")

let a = KVOWithMethod()

for index in 1...5 {
    a.progress.completedUnitCount = Int64(index)
    sleep(1)
}

print("")
print("KVO with closure")

let b = KVOWithClosure()

for index in 1...5 {
    b.progress.completedUnitCount = Int64(index)
    sleep(1)
}
