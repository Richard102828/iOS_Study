//
//  GameView.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/5/25.
//

import SwiftUI
import ComposableArchitecture

typealias GameResultState = IdentifiedArrayOf<GameResult>

struct GameResult: Equatable, Identifiable {
    var id: UUID = UUID()
    let secret: Int
    let guess: Int
    let timeSpent: TimeInterval
    
    var correct: Bool { secret == guess }
}

struct GameFeature: ReducerProtocol {

    struct State {
        var counter: CounterFeature.State = .init()
        var timer: TimerFeature.State = .init()
        // 公共组件增加的 state
        var results: GameResultState = []
        var lastTimeDuration: TimeInterval = 0
    }
    
    // 枚举 和 ifLetCase 一起使用
//    enum State {
//        case counter(CounterFeature.State)
//        case timer(TimerFeature.State)
//    }
    
    enum Action {
        case counterAction(CounterFeature.Action)
        case timerAction(TimerFeature.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        // 截取 playNext
        Reduce { state, action in
            switch action {
            case Action.counterAction(.playNext):
                let result = GameResult(secret: state.counter.secret, guess: state.counter.count, timeSpent: state.timer.duration - state.lastTimeDuration)
                state.results.append(result)
                state.lastTimeDuration = state.timer.duration
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.timer, action: /Action.timerAction) {
            TimerFeature()
        }
        Scope(state: \.counter, action: /Action.counterAction) {
            CounterFeature()
        }
        
//        Reduce { _, _ in
//            // 有没有 GameFeature 单独 需要处理 的逻辑
//            .none
//        }
//        .ifLet(\.timer, action: /Action.timerAction) {
//            TimerFeature()
//        }
//        .ifLet(\.counter, action: /Action.counterAction) {
//            CounterFeature()
//        }
//        .ifCaseLet(/State.timer, action: /Action.timerAction) {
//            TimerFeature()
//        }
//        .ifCaseLet(/State.counter, action: /Action.counterAction) {
//            CounterFeature()
//        }
    }
}

struct GameView: View {
    let store: Store<GameFeature.State, GameFeature.Action>
    var body: some View {
        WithViewStore(store.scope(state: \.results)) { viewStore in
            // @ezrealzhang 这两个怎么一起工作的？怎么交互的？
            // @ezrealzhang 比如我想要点击这个 playNext 之后，计时器能够重新开始计时，这要怎么实现？
            // @ezrealzhang 这个教程没有这个交互，这里先学着走吧，后面再继续看看
            VStack {
                resultLabel(viewStore.state)
                Divider()
                TimerView(store: store.scope(state: { $0.timer }, action: { action in GameFeature.Action.timerAction(action) }))
                CounterView(store: store.scope(state: { $0.counter }, action: { action in GameFeature.Action.counterAction(action) }))
            }.onAppear {
                viewStore.send(.timerAction(.start))
            }
        }
    }
    
    func resultLabel(_ results: GameResultState) -> some View {
        Text("Result: \(results.filter(\.correct).count)/\(results.count) correct")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(store: StoreOf<GameFeature>(initialState: GameFeature.State(), reducer: GameFeature().body))
    }
}
