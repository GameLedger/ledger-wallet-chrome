class @WalletXpubkeyIndexDialogViewController extends ledger.common.DialogViewController

  view:
    derivationPath: '#derivation_path'
    confirmButton: '#confirm_button'

  onAfterRender: ->
    super
    chrome.app.window.current().show()
    @path = Api.cleanPath(@params.path)
    @view.derivationPath.text("m/" + @path)

  cancel: ->
    Api.callback_cancel 'get_xpubkey', t('wallet.xpubkey.errors.cancelled')
    @dismiss()

  confirm: ->
    dialog = new WalletXpubkeyProcessingDialogViewController path: @path
    @getDialog().push dialog