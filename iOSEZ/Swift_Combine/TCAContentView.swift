//
//  TCAContentView.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/5/15.
//

import SwiftUI
import ComposableArchitecture

// TCA + Swift UI test demo

// 处理外部依赖项
struct CounterFactor {
    var randomNum: Int = 0
    
    func numRandom() -> Int {
        return Int.random(in: -100...100)
    }
}

extension CounterFactor: DependencyKey {
    static var liveValue: CounterFactor = CounterFactor(randomNum: Int.random(in: -100...100))
}

extension DependencyValues {
    var counterFactor: CounterFactor {
        get { self[CounterFactor.self] }
        set { self[CounterFactor.self] = newValue }
    }
}

struct MultiState: Equatable {
    @BindingState var foo: Bool = false
    @BindingState var bar: String = ""
}

enum MultiAction: BindableAction {
    case binding(BindingAction<MultiState>)
}

struct CounterFeature: ReducerProtocol {
    
    @Dependency(\.counterFactor)
    var counterFactor
    
    struct State: Equatable, Identifiable {
        var id: UUID = UUID()
        var count: Int = 0
        var secret: Int = Int.random(in: -100...100)
    }
    
    enum Action {
        case increment
        case decrement
        case playNext
        case setCount(String)
        case changeCount(Double)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .increment:
            state.count += 1
            return .none
        case .decrement:
            state.count -= 1
            return .none
        case .playNext:
            state.count = 0
            // 外部依赖项 - Int.random
//            state.secret = Int.random(in: -100...100)
            state.secret = counterFactor.numRandom()
            return .none
        case let .setCount(text):
            if let value = Int(text) {
                state.count = value
            }
            return .none
        case let .changeCount(value):
            state.count = Int(value)
            return .none
        }
    }
    
}

extension CounterFeature.State {
    enum Result {
        case lower, equal, higher
    }
    
    var checkResult: Result {
        if count > secret {
            return .higher
        } else if count < secret {
            return .lower
        } else {
            return .equal
        }
    }
}

func checkLabel(with checkResult: CounterFeature.State.Result) -> some View {
    switch checkResult {
    case .lower:
        return Label("Lower", systemImage: "lessthan.circle")
            .foregroundColor(.red)
    case .higher:
        return Label("Higher", systemImage: "greaterthan.circle")
            .foregroundColor(.red)
    case .equal:
        return Label("Correct", systemImage: "checkmark.circle")
            .foregroundColor(.green)
    }
}

// @ezrealzhang deprecated
//let reducer = AnyReducer<Counter, CounterAction, CounterEnvironment>({ state, action, _ in
//    switch action {
//    case .increment:
//        state.count += 1
//        return .none
//    case .decrement:
//        state.count -= 1
//        return .none
//    case .resetCount:
//        state.count = 0
//        return .none
//    case let .setCount(text):
//        if let value = Int(text) {
//            state.count = value
//        }
//        return .none
//    }
//}).debug()

struct TCAContentView: View {
    @State var tempText: String = "text"
    // 绑定单个值？
    let store = StoreOf<CounterFeature>(initialState: CounterFeature.State(), reducer: CounterFeature())
    // 绑定多个值 - 确实是一个单向数据流，Reducer 变为了 BindingReducer，执行也是执行 BindingReducer 里面的 reducer 方法
    let multiStore = StoreOf<BindingReducer>(initialState: MultiState(), reducer: BindingReducer<MultiState, MultiAction>())
    var body: some View {
        VStack {
            WithViewStore(multiStore) { viewStore in
                VStack {
                    Toggle("Toggle", isOn: viewStore.binding(\.$foo))
                    TextField("Text Field", text: viewStore.binding(\.$bar))
                }
            }
            
            WithViewStore(store) { viewStore in
                VStack {
                    checkLabel(with: viewStore.checkResult)
                    
                    HStack {
                        
                        Button("-") {
                            viewStore.send(.decrement)
                        }


                        // viewStore 的 binding 实现单向数据流，state 的改变都通过 reducer 来完成
                        let textField = TextField(".\(viewStore.count)", text: viewStore.binding(get: { state in
                            String(describing: state.count)
                        }, send: { value in
                            CounterFeature.Action.setCount(value)
                        }))
                        .frame(width: 40)
                        .multilineTextAlignment(.center)

                        // color change
                        if viewStore.count > 0 {
                            textField.foregroundColor(.green)
                        } else if viewStore.count == 0 {
                            textField.foregroundColor(.black)
                        } else {
                            textField.foregroundColor(.red)
                        }

                        Button("+") {
                            viewStore.send(.increment)
                        }
                    }
                    
                    Slider(value: viewStore.binding(get: { state in
                        Double(state.count)
                    }, send: { value in
                        CounterFeature.Action.changeCount(value)
                    }), in: -100...100)
                    .frame(width: 200)

                    Button("playNext") {
                        viewStore.send(.playNext)
                    }
                    // 双向绑定数据流
                    TextField(".\(tempText)", text: $tempText)
                    .frame(width: 40)
                    .multilineTextAlignment(.center)
                }
            }
        }
    }
}

// 单抽出来一个 CounterView 给外部使用
struct CounterView: View {
    let store: Store<CounterFeature.State, CounterFeature.Action>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                checkLabel(with: viewStore.checkResult)
                HStack {
                    Button("-") {
                        viewStore.send(.decrement)
                    }
                    
                    // viewStore 的 binding 实现单向数据流，state 的改变都通过 reducer 来完成
                    let textField = TextField(".\(viewStore.count)", text: viewStore.binding(get: { state in
                        String(describing: state.count)
                    }, send: { value in
                        CounterFeature.Action.setCount(value)
                    }))
                        .frame(width: 40)
                        .multilineTextAlignment(.center)
                    
                    // color change
                    if viewStore.count > 0 {
                        textField.foregroundColor(.green)
                    } else if viewStore.count == 0 {
                        textField.foregroundColor(.black)
                    } else {
                        textField.foregroundColor(.red)
                    }
                    
                    Button("+") {
                        viewStore.send(.increment)
                    }
                }
                
                Slider(value: viewStore.binding(get: { state in
                    Double(state.count)
                }, send: { value in
                    CounterFeature.Action.changeCount(value)
                }), in: -100...100)
                .frame(width: 200)
                
                Button("playNext") {
                    viewStore.send(.playNext)
                }
            }
        }
    }
}

struct TCAContentView_Previews: PreviewProvider {
    static var previews: some View {
        TCAContentView()
    }
}
