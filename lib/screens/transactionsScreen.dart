import 'package:africmobile/models/accountModel.dart';
import 'package:africmobile/models/transactionModel.dart';
import 'package:africmobile/screens/widget/transactionCardWidget.dart';
import 'package:africmobile/services/bankingService.dart';
import 'package:flutter/material.dart';
import 'package:africmobile/screens/widget/filterChipWidget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, credit, debit

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await BankingService.getTransactions('acc_1');
      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        // Text search
        bool matchesSearch = _searchQuery.isEmpty ||
            transaction.description.toLowerCase().contains(_searchQuery.toLowerCase());

        // Type filter
        bool matchesType = _selectedFilter == 'all' ||
            (_selectedFilter == 'credit' && transaction.isCredit) ||
            (_selectedFilter == 'debit' && !transaction.isCredit);

        return matchesSearch && matchesType;
      }).toList();

      // Sort by date (most recent first)
      _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = ModalRoute.of(context)?.settings.arguments as Account?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(account?.displayType ?? 'Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une transaction...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChipWidget(
                  label: 'Toutes',
                  isSelected: _selectedFilter == 'all',
                  onTap: () {
                    _selectedFilter = 'all';
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                FilterChipWidget(
                  label: 'Crédits',
                  isSelected: _selectedFilter == 'credit',
                  onTap: () {
                    _selectedFilter = 'credit';
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                FilterChipWidget(
                  label: 'Débits',
                  isSelected: _selectedFilter == 'debit',
                  onTap: () {
                    _selectedFilter = 'debit';
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTransactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucune transaction trouvée',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTransactions,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _filteredTransactions[index];
                            return TransactionCard(transaction: transaction);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer les transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Toutes les transactions'),
              value: 'all',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
                _applyFilters();
              },
            ),
            RadioListTile<String>(
              title: const Text('Crédits seulement'),
              value: 'credit',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
                _applyFilters();
              },
            ),
            RadioListTile<String>(
              title: const Text('Débits seulement'),
              value: 'debit',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
                _applyFilters();
              },
            ),
          ],
        ),
      ),
    );
  }
}
