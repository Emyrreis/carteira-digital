import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'profile_view_model.dart';

/// "Perfil" tab: who is signed in and the button to leave.
class ProfileView extends StatefulWidget {
  const ProfileView({required this.viewModel, super.key});

  final ProfileViewModel viewModel;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) return const StateView.loading();
        if (viewModel.errorMessage case final message?) {
          return StateView.error(message: message, onRetry: viewModel.start);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap.xxl(),
              Center(
                child: AppAvatar(
                  name: viewModel.name,
                  imageUrl: viewModel.avatarUrl,
                  size: 88,
                ),
              ),
              const Gap.lg(),
              Text(
                viewModel.name,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              const Gap.xs(),
              Text(
                viewModel.email,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: context.semanticColors.muted,
                ),
              ),
              const Gap.xxl(),
              AppButton.secondary(
                key: const Key('profile_logout'),
                label: 'Sair',
                icon: Icons.logout,
                isLoading: viewModel.isLoggingOut,
                onPressed: viewModel.logout,
              ),
            ],
          ),
        );
      },
    );
  }
}
