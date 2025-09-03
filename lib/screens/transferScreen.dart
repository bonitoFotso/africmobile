import 'package:africmobile/models/accountModel.dart';
import 'package:africmobile/services/bankingService.dart';
import 'package:africmobile/utils/currencyFormatter.dart';
import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  List<Account> _accounts = [];
  Account? _selectedAccount;
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() => _isLoading = true);
    try {
      final accounts = await BankingService.getAccounts();
      setState(() {
        _accounts = accounts;
        _selectedAccount = accounts.first;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitTransfer() async {
    if (!_formKey.currentState!.validate() || _selectedAccount == null) return;

    final amount = double.tryParse(_amountController.text.replaceAll(' ', ''));
    if (amount == null) return;

    setState(() => _isSubmitting = true);

    try {
      final result = await BankingService.initiateTransfer(
        fromAccountId: _selectedAccount!.id,
        toAccountNumber: _accountNumberController.text,
        amount: amount,
        currency: 'XAF',
        note: _noteController.text,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Virement Initié'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID de transaction: ${result["transferId"]}'),
                const SizedBox(height: 8),
                Text('Statut: ${result["status"]}'),
                const SizedBox(height: 8),
                const Text('Votre virement est en cours de traitement.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to dashboard
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showConfirmationDialog() {
    final amount = double.tryParse(_amountController.text.replaceAll(' ', ''));
    if (amount == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le virement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('De: ${_selectedAccount!.displayType}'),
            Text('Vers: ${_accountNumberController.text}'),
            Text('Montant: ${CurrencyFormatter.format(amount, "XAF")}'),
            if (_noteController.text.isNotEmpty)
              Text('Note: ${_noteController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTransfer();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Virement'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Source Account Selection
                  const Text(
                    'Compte source',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<Account>(
                      value: _selectedAccount,
                      isExpanded: true,
                      underline: Container(),
                      items: _accounts.map((account) {
                        return DropdownMenuItem<Account>(
                          value: account,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(account.displayType),
                              Text(
                                CurrencyFormatter.format(account.balance, account.currency),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (account) {
                        setState(() => _selectedAccount = account);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Destination Account
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(
                      labelText: 'Numéro de compte bénéficiaire',
                      prefixIcon: const Icon(Icons.account_balance),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez saisir le montant';
                      }
                      final amount = double.tryParse(value!.replaceAll(' ', ''));
                      if (amount == null || amount <= 0) {
                        return 'Montant invalide';
                      }
                      if (_selectedAccount != null && amount > _selectedAccount!.balance) {
                        return 'Solde insuffisant';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Note
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Note (optionnel)',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : () {
                      if (_formKey.currentState!.validate()) {
                        _showConfirmationDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BCD4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Traitement en cours...'),
                            ],
                          )
                        : const Text(
                            'Initier le virement',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
