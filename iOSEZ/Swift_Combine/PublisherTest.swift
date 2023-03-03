//
//  PublisherTest.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/20.
//

import Foundation
import Combine
import UIKit

class PublisherTest {
    private var cancellableList: Set<AnyCancellable> = []
    
    // MARK: - ConnectablePublisher
    func connectPublisherTest() {
        // @ezrealzhang 这里会直接开始请求？
        let dataPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "xxx")!)
            .map(\.data) // @ezrealzhang 这个语法是什么
            .catch({ _ in // @ezrealzhang 逃逸闭包到底是怎么写的
                return Just(Data())
            })
            .makeConnectable() // 先不发布
        
        // 先订阅一个
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                dataPublisher.handleEvents(receiveSubscription: { subscrption in
                    print("1")
                }, receiveRequest: { demand in
                    print("2")
                }).print("ezez").sink { completion in
                    print("completion")
                } receiveValue: { data in
                    print("value count: \(data.count)")
                }.store(in: &self.cancellableList)
        }
        
        // 再订阅一个
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dataPublisher.handleEvents(receiveSubscription: { subscrption in
                print("11")
            }, receiveRequest: { demand in
                print("22")
            }).print("ez").sink { completion in
                print("completion _ 2")
            } receiveValue: { data in
                print("data.count: \(data.count)")
            }.store(in: &self.cancellableList)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 主动发布
            dataPublisher.connect().store(in: &self.cancellableList)
        }
    }
    
    // MARK: - Future
    
    func callbackTest(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completionHandler()
        }
    }
    
    // @ezrealzhang 这个有点 promisekit 的味道了
    // @ezrealzhang 跟写普通的闭包相比，如果我要传很多个参数，那只能把这些封装成一个类型了？
    func futureTest() -> Future<Int, Never> {
        return Future() { promise in
            print("ezez doing")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // @ezrealzhang 这个 Result 可以学下
                promise(Result.success(5))
            }
        }
    }
    
    func futureCallbackTest() {
        print("ezez init")
        futureTest()
        print("ezez done")
        futureTest().sink { value in
            print("task success with value: \(value)")
        }.store(in: &cancellableList)
    }
    
    // MARK: - Subject
    // @ezrealzhang 这些注释整理到文档中，可以作为应用场景来记录
    // @ezrealzhang 使用 Subject 来代替我们平时写的那些 暴露出去的 block，还有一个优势，subject 可以调用 send(completion:) 来告知订阅者：不会再有后续的事件发生，或者发生了一个错误，如果是 block 的话，得把原本的 block 进行一下改造，加个结束的标志
    // @ezrealzhang 感觉 CurrentValueSubject 可以用来代替 kvo？不行，send 的值，只在它自己的缓存中更新了
    // CurrentValueSubject 维护了最近发布元素的缓存
//    let a = CurrentValueSubject
    /**
     暴露出去给外部调用
     let testPubliserIns = PublisherTest()
     func test() {
         testPubliserIns.doSomethingSubject.sink { finished in
             print("finished: \(finished)")
         } receiveValue: { value in
             print("progress: \(value)")
         }
     }
     */
    let doSomethingSubject = PassthroughSubject<Int, Never>()
    
    func callbackSubject() {
        for i in 0...10 {
            doSomethingSubject.send(i)
        }
        doSomethingSubject.send(completion: .finished)
    }
    
    var valueSubject: CurrentValueSubject<Int, Never>?
    
    func currentValueSubject() {
        valueSubject = CurrentValueSubject<Int, Never>(1)
        valueSubject?.send(5)
    }
    
    func asSubscriber() {
        let subject = CurrentValueSubject<Int, Never>(12)
        subject.sink { value in
            print("value \(value)")
        }.store(in: &cancellableList)
        [1, 2, 3, 4, 5].publisher.subscribe(subject).store(in: &cancellableList)
    }
    
    // MARK: - Just/Fail
    func justTest() {
        Just(1).sink { value in
            print("\(value)")
        }.store(in: &cancellableList)
        
        // 错误处理中使用 Just 作为返回值
//        Fail<Int, NSError>(error: NSError(domain: "network error", code: 1))
        Fail(error: NSError(domain: "network error", code: 1))
            .catch { error in
                return Just(1)
            }
            .sink { value in
                print("\(value)")
            }.store(in: &cancellableList)
        
    }
    
    // MARK: - Deferred
    // @ezrealzhang deferred future 代码执行了两次，sink 一次执行一次
    func testDeferred() {
        let deferred = Deferred<AnyPublisher<Int, Never>> {
            return Future<Int, Never> { promise in
                print("deferred future")
                promise(.success(10))
            }.eraseToAnyPublisher()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            deferred.sink { value in
                print("\(value)")
            }.store(in: &self.cancellableList)
            
             deferred.sink { value in
                print("\(value)")
            }.store(in: &self.cancellableList)
        }
    }
    

    // MARK: - Share
    /**
     没有使用 makecontect
     Share 其实是 Multicast 发布者和 PassthroughSubject 发布者的结合，而且它会隐式调用 autoconnect()。
     也就是说，在订阅操作发生后，Share 就会开始发送内容
         receive 1: 10
         completion 1 : finished
         completion 2: finished
     */
    func shareDeferredTest() {
        let deferred = Deferred<AnyPublisher<Int, Never>> {
            return Future<Int, Never> { promise in
                print("wrap future to deferred")
                promise(.success(10))
            }.eraseToAnyPublisher()
        }
        
        let share = deferred.share().makeConnectable()
        
        share.sink { completion in
            print("completion 1 : \(completion)")
        } receiveValue: { value in
            print("receive 1: \(value)")
        }.store(in: &cancellableList)
        
        share.sink { completion in
            print("completion 2: \(completion)")
        } receiveValue: { value in
            print("receive 2: \(value)")
        }.store(in: &cancellableList)
        
        // @ezrealzhang 思考一个问题，订阅完成后，cancellableList 中的元素会被释放掉嘛？
        share.connect().store(in: &cancellableList)
    }
    
    // MARK: - Multicast
   
    func multicaseTest() {
        let deferred = Deferred<AnyPublisher<Int, Never>> {
            return Future<Int, Never> { promise in
                print("wrap future to deferred")
                promise(.success(10))
            }.eraseToAnyPublisher()
        }
        
        let share = deferred.multicast(subject: PassthroughSubject())
        
        share.sink { completion in
            print("completion 1 : \(completion)")
        } receiveValue: { value in
            print("receive 1: \(value)")
        }.store(in: &cancellableList)
        
        share.sink { completion in
            print("completion 2: \(completion)")
        } receiveValue: { value in
            print("receive 2: \(value)")
        }.store(in: &cancellableList)
        
        // @ezrealzhang 思考一个问题，订阅完成后，cancellableList 中的元素会被释放掉嘛？
        share.connect().store(in: &cancellableList)
    }
    
    // MARK: - Empty
    func emptyTest() {
        Empty<NSNull, Never>(completeImmediately: true)
            .sink(receiveCompletion: { completion in
                print("done")
            }, receiveValue: { _ in
                print("no value, statement can not excute")
            }).store(in: &cancellableList)
    }
    
    // MARK: - Sequence
    func sequenceTest() {
        [1, 2, 3, 4].publisher.sink { completion in
            print("\(completion)")
        } receiveValue: { element in
            print("element: \(element)")
        }.store(in: &cancellableList)
    }
    
    // MARK: - Record
    // @ezrealzhang 意义何在呢？应用场景？
    func recordTest() {
        Record<Int, Never> { record in
            record.receive(1)
            record.receive(2)
            record.receive(3)
            record.receive(completion: .finished)
        }.sink { completion in
            print("record \(completion)")
        } receiveValue: { value in
            print("record \(value)")
        }.store(in: &cancellableList)
    }
    
    // MARK: - 背压
    let timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let timerSubscriber = MySubscriber()
    func backPressureTest() {
        // @ezrealzhang 手动 subscribe 没有 cancelable 需要持有
//        timerPublisher.subscribe(timerSubscriber)
        timerPublisher.sink { _ in
            print("sssss")
        }.store(in: &cancellableList)
    }
    
    // MARK: - fundation - 通知
    func notificationTest() {
        // normal
//        NotificationCenter.default.addObserver(forName: .init("checkSubscriptions"), object: nil, queue: .main) { _ in
//            if self.cancellableList.count > 0 {
//                print("subscriptions exist")
//            }
//        }
        // @ezrealzhang 订阅必须存起来，感觉这点不是很方便，连这种通知也需要存起来
        // combine
        NotificationCenter.default.publisher(for: .init("checkSubscriptions"))
            .filter { _ in
                self.cancellableList.count > 1
            }.sink { _ in
                print("subscriptions exist")
            }.store(in: &cancellableList)
    }
    
    // MARK: - fundation - timer
    // 注意这个 timer 的 TimerPublisher : ConnectablePublisher
    func timerTest() {
        // normal
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            print("\(Date())")
//        }
        // combine
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                print("\(Date())")
            }
        // @ezrealzhang 订阅之后，必须存一下 publisher，不然 publiser 销毁了，订阅也就失效了。也可以通过保存订阅得到的 cancelable 引用来保持订阅，publisher 估计也是存在这里面了？
        // @ezrealzhang 那为什么通过 subscribe 的方式建立订阅关系，没有返回一个 cancelable 来给我们存储？那它是怎么保证这个订阅关系一直存在的呢？(即使订阅关系所在的这个对象被销毁了？)
            .store(in: &cancellableList)
    }
    
    let viewModel = RegisterCombineViewModel()
    var observation: NSKeyValueObservation?
    func kvoTest() {
        // normal
        observation = viewModel.observe(\RegisterCombineViewModel.userName, options: [.new]) { (_, value) in
            print("view model username value change: \(value)")
        }
        // combine
        viewModel.publisher(for: \RegisterCombineViewModel.userName).sink { value in
            print("view model username value change: \(String(describing: value))")
        }.store(in: &cancellableList)
    }
    
    // MARK: - Operators
    
    func operatorsTest() {
//        Timer.publish(every: 1, on: .main, in: .default)
        [1, 2, 3, 4, 5].publisher
            .print("ezez", to: nil)
            .breakpoint(receiveOutput: { date in
//                return true
                return false
            })
            .handleEvents(receiveSubscription: { subscription in
                print("subscription")
            }, receiveOutput: {_ in
                print("value")
            }, receiveCompletion: { completion in
                print("completion")
            }, receiveCancel: {
                print("cancel")
            }, receiveRequest: { request in
                print("request")
            })
            .map({ value in
                return value * value
            })
            .flatMap({ value -> Just<Double> in
                return Just(value * 0.1)
            })
            .sink { value in
                print("receive : \(value)")
            }.store(in: &cancellableList)
        
        
        let oddPublisher = PassthroughSubject<Int, Never>()
        let evenPublisher = PassthroughSubject<Int, Never>()
        oddPublisher
            .merge(with: evenPublisher)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                print(value)
            })
            .store(in: &cancellableList)
        oddPublisher.send(1)
        oddPublisher.send(3)
        evenPublisher.send(2)
        evenPublisher.send(4)
    }
    
    // MARK: - switchToLatest
    
    func switchToLatestTest() {
        let subjects = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
        
        subjects.switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("completion: \(completion)")
            } receiveValue: { value in
                print("value: \(value)")
            }.store(in: &cancellableList)
        
        let subject1 = PassthroughSubject<Int, Never>()
        subjects.send(subject1)
        
        subject1.send(1)
        subject1.send(2)
        
        let subject2 = PassthroughSubject<Int, Never>()
        subjects.send(subject2)
        
        subject2.send(3)
        subject2.send(4)
        
        subject1.send(5)    // can not receive
    }
}

// MARK: - 背压
class MySubscriber : Subscriber {
    
    typealias Input = Date
    
    typealias Failure = Never
    
    var subscription: Subscription?
    
    func receive(subscription: Subscription) {
        // 订阅，但延迟请求需求
        self.subscription = subscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.subscription?.request(.max(3))
        }
    }
    func receive(_ input: Date) -> Subscribers.Demand {
        print("receive date: \(input)")
        return Subscribers.Demand.max(2)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("done")
    }
}

// @ezrealzhang 思考一个问题，combine 是 swift 中的框架，那么，能在 oc 中使用吗？






