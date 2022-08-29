import ComposableArchitecture

extension AlertState {
    public static func errorAlert(_ error: String) -> AlertState<Action> {
        .init(
            title: TextState("error_alert_title".localized),
            message: TextState(error),
            dismissButton: .default(TextState("error_alert_cta".localized))
        )
    }
}
