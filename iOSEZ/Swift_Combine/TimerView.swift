//
//  TimerView.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/5/24.
//

import SwiftUI
import ComposableArchitecture

struct TimerEnvFactor {
    var date: () -> Date
    var runLoop: RunLoop
}

extension TimerEnvFactor: DependencyKey {
    static var liveValue: TimerEnvFactor = TimerEnvFactor(date: {
        Date()
    }, runLoop: .main)
}

extension DependencyValues {
    var timerEnvFactor: TimerEnvFactor {
        get { self[TimerEnvFactor.self] }
        set { self[TimerEnvFactor.self] = newValue }
    }
}

struct TimerId: Hashable {}

struct TimerFeature: ReducerProtocol {
    
    // env
    @Dependency(\.timerEnvFactor)
    var timerEnvFactor
    
    struct State: Equatable {
        var start: Date? = nil
        var duration: TimeInterval = 0
    }
    
    enum Action {
        case start
        case stop
        case timeUpdate
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .start:
            if state.start == nil {
                state.start = timerEnvFactor.date()
            }
            // @ezrealzhang 多次点击会不会多次创建？
            return .publisher {
                print("ezez - creaton publisher")
                return Timer.publish(every: 0.01, on: timerEnvFactor.runLoop, in: .default)
                    .autoconnect()
                    .map { _ in
                        TimerFeature.Action.timeUpdate
                    }
            }.cancellable(id: TimerId())
        case .stop:
            return .cancel(id: TimerId())
        case .timeUpdate:
            state.duration += 0.01
            return .none
        }
    }
}

struct TimerView: View {
    let store: Store<TimerFeature.State, TimerFeature.Action>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Label(
                    viewStore.start == nil ? "-" : "\(viewStore.start!.formatted(date: .omitted, time: .standard))",
                    systemImage: "clock"
                )
                Label(
                    "\(viewStore.duration, format: .number)s",
                    systemImage: "timer"
                )
            }
        }

    }
}

struct TimerView_Previews: PreviewProvider {
    static let store = StoreOf<TimerFeature>(initialState: TimerFeature.State(), reducer: TimerFeature())
    static var previews: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TimerView(store: store)
                Button("start") {
                    viewStore.send(.start)
                }
                Button("stop") {
                    viewStore.send(.stop)
                }
            }
        }
    }
}
