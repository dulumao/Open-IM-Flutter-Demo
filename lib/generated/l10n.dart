// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `EEchat`
  String get login_text1 {
    return Intl.message(
      'EEchat',
      name: 'login_text1',
      desc: '',
      args: [],
    );
  }

  /// `Digital currency address chat`
  String get login_text7 {
    return Intl.message(
      'Digital currency address chat',
      name: 'login_text7',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic login, anonymous identity`
  String get login_text2 {
    return Intl.message(
      'Mnemonic login, anonymous identity',
      name: 'login_text2',
      desc: '',
      args: [],
    );
  }

  /// `End to end encryption, message security`
  String get login_text3 {
    return Intl.message(
      'End to end encryption, message security',
      name: 'login_text3',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mnemonics, separated by spaces`
  String get login_text4 {
    return Intl.message(
      'Enter your mnemonics, separated by spaces',
      name: 'login_text4',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get login_text5 {
    return Intl.message(
      'Sign in',
      name: 'login_text5',
      desc: '',
      args: [],
    );
  }

  /// `Sign up for a new account`
  String get login_text6 {
    return Intl.message(
      'Sign up for a new account',
      name: 'login_text6',
      desc: '',
      args: [],
    );
  }

  /// `Your mnemonics`
  String get register_text1 {
    return Intl.message(
      'Your mnemonics',
      name: 'register_text1',
      desc: '',
      args: [],
    );
  }

  /// `It is the only voucher for your account`
  String get register_text2 {
    return Intl.message(
      'It is the only voucher for your account',
      name: 'register_text2',
      desc: '',
      args: [],
    );
  }

  /// `Eechat will not save your mnemonics. Once lost, it cannot be retrieved`
  String get register_text3 {
    return Intl.message(
      'Eechat will not save your mnemonics. Once lost, it cannot be retrieved',
      name: 'register_text3',
      desc: '',
      args: [],
    );
  }

  /// `Please record your mnemonics and keep them in a safe place`
  String get register_text4 {
    return Intl.message(
      'Please record your mnemonics and keep them in a safe place',
      name: 'register_text4',
      desc: '',
      args: [],
    );
  }

  /// `Copy your mnemonics:`
  String get register_text5 {
    return Intl.message(
      'Copy your mnemonics:',
      name: 'register_text5',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get register_text6 {
    return Intl.message(
      'Next step',
      name: 'register_text6',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copy_success {
    return Intl.message(
      'Copied',
      name: 'copy_success',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation mnemonics`
  String get backup_text1 {
    return Intl.message(
      'Confirmation mnemonics',
      name: 'backup_text1',
      desc: '',
      args: [],
    );
  }

  /// `Please choose the appropriate mnemonic words to ensure the correct order`
  String get backup_text2 {
    return Intl.message(
      'Please choose the appropriate mnemonic words to ensure the correct order',
      name: 'backup_text2',
      desc: '',
      args: [],
    );
  }

  /// `EEchat`
  String get tab1 {
    return Intl.message(
      'EEchat',
      name: 'tab1',
      desc: '',
      args: [],
    );
  }

  /// `Mail list`
  String get tab2 {
    return Intl.message(
      'Mail list',
      name: 'tab2',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get tab3 {
    return Intl.message(
      'My',
      name: 'tab3',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get top {
    return Intl.message(
      'Top',
      name: 'top',
      desc: '',
      args: [],
    );
  }

  /// `Cancel topping`
  String get cancel_top {
    return Intl.message(
      'Cancel topping',
      name: 'cancel_top',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Mark as read`
  String get have_read {
    return Intl.message(
      'Mark as read',
      name: 'have_read',
      desc: '',
      args: [],
    );
  }

  /// `New friends`
  String get new_friend {
    return Intl.message(
      'New friends',
      name: 'new_friend',
      desc: '',
      args: [],
    );
  }

  /// `Change your Avatar`
  String get mine_text1 {
    return Intl.message(
      'Change your Avatar',
      name: 'mine_text1',
      desc: '',
      args: [],
    );
  }

  /// `Change nickname`
  String get mine_text2 {
    return Intl.message(
      'Change nickname',
      name: 'mine_text2',
      desc: '',
      args: [],
    );
  }

  /// `Address book blacklist`
  String get mine_text3 {
    return Intl.message(
      'Address book blacklist',
      name: 'mine_text3',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get mine_text4 {
    return Intl.message(
      'Log out',
      name: 'mine_text4',
      desc: '',
      args: [],
    );
  }

  /// `My Account：%s`
  String get mine_text5 {
    return Intl.message(
      'My Account：%s',
      name: 'mine_text5',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get menu_copy {
    return Intl.message(
      'Copy',
      name: 'menu_copy',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get menu_del {
    return Intl.message(
      'Delete',
      name: 'menu_del',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get menu_forward {
    return Intl.message(
      'Forward',
      name: 'menu_forward',
      desc: '',
      args: [],
    );
  }

  /// `Revoke`
  String get menu_revoke {
    return Intl.message(
      'Revoke',
      name: 'menu_revoke',
      desc: '',
      args: [],
    );
  }

  /// `Shot`
  String get camera {
    return Intl.message(
      'Shot',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get album {
    return Intl.message(
      'Album',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Long press when speaking`
  String get talk_longPress {
    return Intl.message(
      'Long press when speaking',
      name: 'talk_longPress',
      desc: '',
      args: [],
    );
  }

  /// `Friends settings`
  String get friend_set_text1 {
    return Intl.message(
      'Friends settings',
      name: 'friend_set_text1',
      desc: '',
      args: [],
    );
  }

  /// `Set notes`
  String get friend_set_text2 {
    return Intl.message(
      'Set notes',
      name: 'friend_set_text2',
      desc: '',
      args: [],
    );
  }

  /// `Top contact`
  String get friend_set_text3 {
    return Intl.message(
      'Top contact',
      name: 'friend_set_text3',
      desc: '',
      args: [],
    );
  }

  /// `Join the blacklist`
  String get friend_set_text4 {
    return Intl.message(
      'Join the blacklist',
      name: 'friend_set_text4',
      desc: '',
      args: [],
    );
  }

  /// `Empty chat record`
  String get friend_set_text5 {
    return Intl.message(
      'Empty chat record',
      name: 'friend_set_text5',
      desc: '',
      args: [],
    );
  }

  /// `Delete friend`
  String get friend_set_text6 {
    return Intl.message(
      'Delete friend',
      name: 'friend_set_text6',
      desc: '',
      args: [],
    );
  }

  /// `Set notes`
  String get remark_set_text1 {
    return Intl.message(
      'Set notes',
      name: 'remark_set_text1',
      desc: '',
      args: [],
    );
  }

  /// `Preservation`
  String get remark_set_text2 {
    return Intl.message(
      'Preservation',
      name: 'remark_set_text2',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get clear {
    return Intl.message(
      'Empty',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Determine`
  String get confirm {
    return Intl.message(
      'Determine',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Preservation`
  String get save {
    return Intl.message(
      'Preservation',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the chat with "%s"?`
  String get dialog_text1 {
    return Intl.message(
      'Are you sure you want to delete the chat with "%s"?',
      name: 'dialog_text1',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to blacklist %s?`
  String get dialog_text2 {
    return Intl.message(
      'Are you sure to blacklist %s?',
      name: 'dialog_text2',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete "%s"?`
  String get dialog_text3 {
    return Intl.message(
      'Are you sure to delete "%s"?',
      name: 'dialog_text3',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get dialog_button1 {
    return Intl.message(
      'Empty',
      name: 'dialog_button1',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get dialog_button2 {
    return Intl.message(
      'Delete',
      name: 'dialog_button2',
      desc: '',
      args: [],
    );
  }

  /// `Determine`
  String get dialog_button3 {
    return Intl.message(
      'Determine',
      name: 'dialog_button3',
      desc: '',
      args: [],
    );
  }

  /// `Add friends`
  String get add_friend_text1 {
    return Intl.message(
      'Add friends',
      name: 'add_friend_text1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the account number`
  String get add_friend_text2 {
    return Intl.message(
      'Please enter the account number',
      name: 'add_friend_text2',
      desc: '',
      args: [],
    );
  }

  /// `My Account：%s`
  String get add_friend_text3 {
    return Intl.message(
      'My Account：%s',
      name: 'add_friend_text3',
      desc: '',
      args: [],
    );
  }

  /// `Search：`
  String get add_friend_text4 {
    return Intl.message(
      'Search：',
      name: 'add_friend_text4',
      desc: '',
      args: [],
    );
  }

  /// `The user does not exist`
  String get add_friend_text5 {
    return Intl.message(
      'The user does not exist',
      name: 'add_friend_text5',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get add_friend_text6 {
    return Intl.message(
      'Add friend',
      name: 'add_friend_text6',
      desc: '',
      args: [],
    );
  }

  /// `Send Message`
  String get add_friend_text7 {
    return Intl.message(
      'Send Message',
      name: 'add_friend_text7',
      desc: '',
      args: [],
    );
  }

  /// `Account number:%s`
  String get add_friend_text8 {
    return Intl.message(
      'Account number:%s',
      name: 'add_friend_text8',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get new_friend_text1 {
    return Intl.message(
      'Add',
      name: 'new_friend_text1',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get new_friend_text2 {
    return Intl.message(
      'Added',
      name: 'new_friend_text2',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get new_friend_text3 {
    return Intl.message(
      'Rejected',
      name: 'new_friend_text3',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get new_friend_text4 {
    return Intl.message(
      'Agree',
      name: 'new_friend_text4',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get new_friend_text5 {
    return Intl.message(
      'Reject',
      name: 'new_friend_text5',
      desc: '',
      args: [],
    );
  }

  /// `Address book blacklist`
  String get black_list1 {
    return Intl.message(
      'Address book blacklist',
      name: 'black_list1',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get black_list2 {
    return Intl.message(
      'Remove',
      name: 'black_list2',
      desc: '',
      args: [],
    );
  }

  /// `Change nickname`
  String get set_nickname {
    return Intl.message(
      'Change nickname',
      name: 'set_nickname',
      desc: '',
      args: [],
    );
  }

  /// `Search contacts`
  String get search_contact {
    return Intl.message(
      'Search contacts',
      name: 'search_contact',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load picture`
  String get pic_load_error {
    return Intl.message(
      'Unable to load picture',
      name: 'pic_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Group notification`
  String get group_chat_text1 {
    return Intl.message(
      'Group notification',
      name: 'group_chat_text1',
      desc: '',
      args: [],
    );
  }

  /// `Launch group chat`
  String get group_chat_text2 {
    return Intl.message(
      'Launch group chat',
      name: 'group_chat_text2',
      desc: '',
      args: [],
    );
  }

  /// `Add group chat`
  String get group_chat_text3 {
    return Intl.message(
      'Add group chat',
      name: 'group_chat_text3',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get group_chat_text4 {
    return Intl.message(
      'Complete',
      name: 'group_chat_text4',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get group_chat_text5 {
    return Intl.message(
      'Contacts',
      name: 'group_chat_text5',
      desc: '',
      args: [],
    );
  }

  /// `No "%s" results were found.`
  String get group_chat_text6 {
    return Intl.message(
      'No "%s" results were found.',
      name: 'group_chat_text6',
      desc: '',
      args: [],
    );
  }

  /// `Add group chat`
  String get group_chat_text7 {
    return Intl.message(
      'Add group chat',
      name: 'group_chat_text7',
      desc: '',
      args: [],
    );
  }

  /// `Group chat doesn't exist`
  String get group_chat_text8 {
    return Intl.message(
      'Group chat doesn\'t exist',
      name: 'group_chat_text8',
      desc: '',
      args: [],
    );
  }

  /// `Please enter group number`
  String get group_chat_text9 {
    return Intl.message(
      'Please enter group number',
      name: 'group_chat_text9',
      desc: '',
      args: [],
    );
  }

  /// `The application has been sent`
  String get application_has_been_sent {
    return Intl.message(
      'The application has been sent',
      name: 'application_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `Group chat settings`
  String get group_chat_text10 {
    return Intl.message(
      'Group chat settings',
      name: 'group_chat_text10',
      desc: '',
      args: [],
    );
  }

  /// `Group announcement`
  String get group_chat_text11 {
    return Intl.message(
      'Group announcement',
      name: 'group_chat_text11',
      desc: '',
      args: [],
    );
  }

  /// `Transfer of management rights`
  String get group_chat_text12 {
    return Intl.message(
      'Transfer of management rights',
      name: 'group_chat_text12',
      desc: '',
      args: [],
    );
  }

  /// `My nickname in the group`
  String get group_chat_text13 {
    return Intl.message(
      'My nickname in the group',
      name: 'group_chat_text13',
      desc: '',
      args: [],
    );
  }

  /// `Break up group chat`
  String get group_chat_text14 {
    return Intl.message(
      'Break up group chat',
      name: 'group_chat_text14',
      desc: '',
      args: [],
    );
  }

  /// `Empty chat record`
  String get group_chat_text15 {
    return Intl.message(
      'Empty chat record',
      name: 'group_chat_text15',
      desc: '',
      args: [],
    );
  }

  /// `No hint news`
  String get group_chat_text16 {
    return Intl.message(
      'No hint news',
      name: 'group_chat_text16',
      desc: '',
      args: [],
    );
  }

  /// `Top chat`
  String get group_chat_text17 {
    return Intl.message(
      'Top chat',
      name: 'group_chat_text17',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get group_chat_text18 {
    return Intl.message(
      'Sign out',
      name: 'group_chat_text18',
      desc: '',
      args: [],
    );
  }

  /// `Chat members`
  String get group_chat_text19 {
    return Intl.message(
      'Chat members',
      name: 'group_chat_text19',
      desc: '',
      args: [],
    );
  }

  /// `Select contact`
  String get group_chat_text20 {
    return Intl.message(
      'Select contact',
      name: 'group_chat_text20',
      desc: '',
      args: [],
    );
  }

  /// `Group members`
  String get group_chat_text21 {
    return Intl.message(
      'Group members',
      name: 'group_chat_text21',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get group_chat_text22 {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'group_chat_text22',
      desc: '',
      args: [],
    );
  }

  /// `Modify group data`
  String get group_chat_text23 {
    return Intl.message(
      'Modify group data',
      name: 'group_chat_text23',
      desc: '',
      args: [],
    );
  }

  /// `Group chat name`
  String get group_chat_text24 {
    return Intl.message(
      'Group chat name',
      name: 'group_chat_text24',
      desc: '',
      args: [],
    );
  }

  /// `Group portrait`
  String get group_chat_text25 {
    return Intl.message(
      'Group portrait',
      name: 'group_chat_text25',
      desc: '',
      args: [],
    );
  }

  /// `Group Introduction`
  String get group_chat_text26 {
    return Intl.message(
      'Group Introduction',
      name: 'group_chat_text26',
      desc: '',
      args: [],
    );
  }

  /// `Edit group chat name`
  String get group_chat_text27 {
    return Intl.message(
      'Edit group chat name',
      name: 'group_chat_text27',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message(
      'Agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get refuse {
    return Intl.message(
      'Refuse',
      name: 'refuse',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get group_chat_text28 {
    return Intl.message(
      'Complete',
      name: 'group_chat_text28',
      desc: '',
      args: [],
    );
  }

  /// `Please edit the group announcement`
  String get group_chat_text29 {
    return Intl.message(
      'Please edit the group announcement',
      name: 'group_chat_text29',
      desc: '',
      args: [],
    );
  }

  /// `My nickname in the group`
  String get group_chat_text30 {
    return Intl.message(
      'My nickname in the group',
      name: 'group_chat_text30',
      desc: '',
      args: [],
    );
  }

  /// `After the nickname is modified, it will only be displayed in this group, and members of the group can see it.`
  String get group_chat_text31 {
    return Intl.message(
      'After the nickname is modified, it will only be displayed in this group, and members of the group can see it.',
      name: 'group_chat_text31',
      desc: '',
      args: [],
    );
  }

  /// `Editor Group Introduction`
  String get group_chat_text32 {
    return Intl.message(
      'Editor Group Introduction',
      name: 'group_chat_text32',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to choose the new group leader of %s , you will automatically give up the group leader identity.`
  String get group_chat_text33 {
    return Intl.message(
      'Make sure to choose the new group leader of %s , you will automatically give up the group leader identity.',
      name: 'group_chat_text33',
      desc: '',
      args: [],
    );
  }

  /// `You are the group leader. If you want to quit the group chat, please transfer the management right first.`
  String get group_chat_text34 {
    return Intl.message(
      'You are the group leader. If you want to quit the group chat, please transfer the management right first.',
      name: 'group_chat_text34',
      desc: '',
      args: [],
    );
  }

  /// `You are a member of a group and do not have this permission.`
  String get group_chat_text35 {
    return Intl.message(
      'You are a member of a group and do not have this permission.',
      name: 'group_chat_text35',
      desc: '',
      args: [],
    );
  }

  /// `Group list`
  String get group_chat_text36 {
    return Intl.message(
      'Group list',
      name: 'group_chat_text36',
      desc: '',
      args: [],
    );
  }

  /// `Group chat`
  String get group_chat_text37 {
    return Intl.message(
      'Group chat',
      name: 'group_chat_text37',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get group_chat_text38 {
    return Intl.message(
      'Search',
      name: 'group_chat_text38',
      desc: '',
      args: [],
    );
  }

  /// `Refused`
  String get group_chat_text39 {
    return Intl.message(
      'Refused',
      name: 'group_chat_text39',
      desc: '',
      args: [],
    );
  }

  /// `Agreed`
  String get group_chat_text40 {
    return Intl.message(
      'Agreed',
      name: 'group_chat_text40',
      desc: '',
      args: [],
    );
  }

  /// `Group number：%s`
  String get group_chat_text41 {
    return Intl.message(
      'Group number：%s',
      name: 'group_chat_text41',
      desc: '',
      args: [],
    );
  }

  /// `scan`
  String get scan {
    return Intl.message(
      'scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `you`
  String get you {
    return Intl.message(
      'you',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `revoked a message`
  String get msg_tips_1 {
    return Intl.message(
      'revoked a message',
      name: 'msg_tips_1',
      desc: '',
      args: [],
    );
  }

  /// `Have read`
  String get status_have_read {
    return Intl.message(
      'Have read',
      name: 'status_have_read',
      desc: '',
      args: [],
    );
  }

  /// `Unread`
  String get status_unread {
    return Intl.message(
      'Unread',
      name: 'status_unread',
      desc: '',
      args: [],
    );
  }

  /// `Typing...`
  String get typing {
    return Intl.message(
      'Typing...',
      name: 'typing',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
