// ignore_for_file: override_on_non_overriding_member

class SettingsState {
  SettingsState({
    this.loading,
  });

  bool? loading;

  SettingsState copyWith({
    loading,
    contestFeeds,
  }) =>
      SettingsState(
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [
        loading,
      ];
}
