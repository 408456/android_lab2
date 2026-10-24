import 'package:flutter/material.dart';

import '../controller/contacts_controller.dart';
import '../l10n/app_localizations.dart';
import '../model/contact.dart';
import '../model/contacts_state.dart';
import '../service/simulated_contacts_source.dart';
import '../utils/contacts_logger.dart';
import 'app_settings_screen.dart';
import 'contact_details_view.dart';
import 'contact_list_tile.dart';
import 'contacts_state_views.dart';
import 'device_simulator_sheet.dart';

class ContactsScreen extends StatefulWidget {
  final ContactsController controller;
  final Locale locale;
  final VoidCallback onLocaleToggled;

  const ContactsScreen({
    super.key,
    required this.controller,
    required this.locale,
    required this.onLocaleToggled,
  });

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with WidgetsBindingObserver {
  static const double wideLayoutBreakpoint = 760;

  final ContactsLogger logger = const ContactsLogger('UI.ContactsScreen');

  late final TextEditingController searchController;

  Contact? selectedContact;

  ContactsController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    searchController = TextEditingController(text: controller.query);

    logger.logAction('экран списка контактов создан');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize();
    });
  }

  @override
  void dispose() {
    logger.logAction('экран списка контактов уничтожен');

    WidgetsBinding.instance.removeObserver(this);

    searchController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    logger.logState('жизненный цикл приложения: ${state.name}');

    if (state == AppLifecycleState.resumed) {
      controller.synchronizeWithSystem(reason: 'приложение снова активно');
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    logger.logState(
      'изменились размеры окна, поисковый запрос "${controller.query}" '
      'и сортировка ${controller.sortOrder.name} сохранены',
    );
  }

  Future<void> onRequestPermission() async {
    logger.logAction('нажата кнопка запроса разрешения');

    await controller.requestPermission();
  }

  Future<void> onOpenAppSettings() async {
    logger.logAction('нажата кнопка открытия настроек приложения');

    final opened = await controller.openAppSettings();

    if (!mounted) {
      return;
    }

    if (!opened) {
      final source = controller.source;

      if (source is SimulatedContactsSource) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => AppSettingsScreen(source: source),
          ),
        );
      }
    }

    if (!mounted) {
      return;
    }

    await controller.synchronizeWithSystem(reason: 'возврат из настроек');
  }

  Future<void> onOpenSimulator() async {
    final source = controller.source;

    if (source is! SimulatedContactsSource) {
      return;
    }

    logger.logAction('открыта панель эмулятора устройства');

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => DeviceSimulatorSheet(source: source),
    );

    if (!mounted) {
      return;
    }

    await controller.synchronizeWithSystem(
      reason: 'изменено состояние эмулятора устройства',
    );
  }

  Future<void> onContactSelected(Contact contact, bool isWideLayout) async {
    logger.logAction(
      'выбран контакт ${contact.id} (${contact.displayName}), '
      'широкая раскладка: $isWideLayout',
    );

    if (isWideLayout) {
      setState(() {
        selectedContact = contact;
      });

      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ContactDetailsScreen(contact: contact),
      ),
    );

    logger.logState(
      'возврат с экрана деталей: адресная книга повторно не читается, '
      'чтений всего: ${controller.addressBookReadCount}',
    );
  }

  void onSearchChanged(String value) {
    controller.onSearchQueryChanged(value);
  }

  void onSearchCleared() {
    searchController.clear();

    controller.clearSearch();
  }

  void onSortSelected(ContactsSortOrder order) {
    controller.setSortOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appBarTitle),
            actions: buildActions(l10n),
            bottom: buildSearchPanel(l10n),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideLayout =
                    constraints.maxWidth >= wideLayoutBreakpoint;

                if (!isWideLayout) {
                  return buildBody(l10n, isWideLayout);
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 380,
                      child: buildBody(l10n, isWideLayout),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: selectedContact == null
                          ? const ContactDetailsPlaceholder()
                          : ContactDetailsView(contact: selectedContact!),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildActions(AppLocalizations l10n) {
    final actions = <Widget>[
      IconButton(
        tooltip: l10n.refreshTooltip,
        onPressed: controller.isLoading ? null : controller.reload,
        icon: const Icon(Icons.refresh),
      ),
      PopupMenuButton<ContactsSortOrder>(
        tooltip: l10n.sortTooltip,
        icon: Icon(
          controller.sortOrder.isAscending
              ? Icons.arrow_upward
              : Icons.arrow_downward,
        ),
        initialValue: controller.sortOrder,
        onSelected: onSortSelected,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ContactsSortOrder.ascending,
            child: Text(l10n.sortAscending),
          ),
          PopupMenuItem(
            value: ContactsSortOrder.descending,
            child: Text(l10n.sortDescending),
          ),
        ],
      ),
    ];

    if (controller.source is SimulatedContactsSource) {
      actions.add(
        IconButton(
          tooltip: l10n.simulatorTitle,
          onPressed: onOpenSimulator,
          icon: const Icon(Icons.phone_android),
        ),
      );
    }

    actions.add(
      TextButton(
        onPressed: widget.onLocaleToggled,
        child: Text(widget.locale.languageCode.toUpperCase()),
      ),
    );

    return actions;
  }

  PreferredSizeWidget? buildSearchPanel(AppLocalizations l10n) {
    if (controller.status != ContactsStatus.ready) {
      return null;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(104),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: controller.isSearching
                    ? IconButton(
                        tooltip: l10n.searchClear,
                        onPressed: onSearchCleared,
                        icon: const Icon(Icons.close),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            buildStatistics(l10n),
          ],
        ),
      ),
    );
  }

  Widget buildStatistics(AppLocalizations l10n) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall;

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 16,
        runSpacing: 2,
        children: [
          Text(
            l10n.statsFound(controller.foundCount, controller.totalCount),
            style: style?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(l10n.statsReads(controller.addressBookReadCount), style: style),
          Text(
            controller.source.isSimulated
                ? l10n.sourceSimulated
                : l10n.sourceNative,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget buildBody(AppLocalizations l10n, bool isWideLayout) {
    switch (controller.status) {
      case ContactsStatus.initial:
      case ContactsStatus.loading:
        return const ContactsLoadingView();

      case ContactsStatus.permissionDenied:
        return ContactsPermissionDeniedView(onRequest: onRequestPermission);

      case ContactsStatus.permissionPermanentlyDenied:
        return ContactsPermissionPermanentlyDeniedView(
          onOpenSettings: onOpenAppSettings,
        );

      case ContactsStatus.error:
        return ContactsErrorView(
          failure: controller.failure,
          onRetry: controller.reload,
        );

      case ContactsStatus.ready:
        if (controller.addressBookIsEmpty) {
          return const ContactsEmptyAddressBookView();
        }

        if (controller.searchResultIsEmpty) {
          return ContactsEmptySearchView(
            query: controller.query,
            onReset: onSearchCleared,
          );
        }

        return buildContactsList(isWideLayout);
    }
  }

  Widget buildContactsList(bool isWideLayout) {
    final contacts = controller.visibleContacts;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: contacts.length,
      itemExtent: 72,
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return ContactListTile(
          contact: contact,
          selected: isWideLayout && selectedContact?.id == contact.id,
          onTap: () => onContactSelected(contact, isWideLayout),
        );
      },
    );
  }
}
