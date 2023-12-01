import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkn_bank/models/financial_record.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/models/expense_category.dart';
import 'package:mkn_bank/services/financial_activity_service.dart';

class ExpenseCreationView extends StatefulWidget {
  final AccountProfile userProfile;
  ExpenseCreationView({super.key, required this.userProfile});

  @override
  _ExpenseCreationViewState createState() => _ExpenseCreationViewState();
}

class _ExpenseCreationViewState extends State<ExpenseCreationView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  late TextEditingController _paymentMethodController;
  late TextEditingController _descriptionController;
  late TextEditingController _newCategoryController;
  final List<String> _paymentMethods = [
    'Cartão de Crédito',
    'Cartão de Débito',
    'Dinheiro',
    'Pix'
  ];
  String _selectedPaymentMethod = 'Cartão de Crédito';
  final List<String> _transactionTypes = ['Despesa', 'Receita'];
  String _selectedTransactionType = 'Despesa';
  late FinancialActivityService financialActivityService =
      FinancialActivityService();
  List<ExpenseCategory> _categories = [];
  ExpenseCategory? _selectedCategory;
  bool _isOtherCategorySelected = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dateController = TextEditingController();
    _amountController = TextEditingController();
    _paymentMethodController = TextEditingController();
    _descriptionController = TextEditingController();
    _newCategoryController = TextEditingController();
    _fetchCategories();
  }

  void _fetchCategories() async {
    try {
      List<ExpenseCategory> categories = await financialActivityService
          .fetchCategories(widget.userProfile.accountId);
      setState(() {
        _categories = categories;
        _categories.add(ExpenseCategory(id: 'other', name: 'Outra'));
      });
    } catch (error) {
      _showSnackBar('Erro ao buscar categorias: $error');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _paymentMethodController.dispose();
    _descriptionController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Financeiro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _transactionTypeDropdown(),
                _textFormField(
                    _titleController, 'Título', 'Por favor, insira um título'),
                _categoryDropdown(),
                if (_isOtherCategorySelected) _newCategoryTextField(),
                _dateFormField(),
                _textFormField(_amountController, 'Valor',
                    'Por favor, insira um valor', true),
                _paymentMethodDropdown(),
                _textFormField(_descriptionController, 'Descrição'),
                const SizedBox(height: 16.0),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<ExpenseCategory> _categoryDropdown() {
    return DropdownButtonFormField<ExpenseCategory>(
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          _isOtherCategorySelected = newValue?.name == 'Outra';
          _selectedCategory = newValue ?? _categories.first;
        });
      },
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.name),
              if (category.name != 'Outra') // Não mostra a lixeira para 'Outra'
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCategory(category),
                ),
            ],
          ),
        );
      }).toList(),
      decoration: const InputDecoration(labelText: 'Categoria'),
    );
  }

Future<void> _deleteCategory(ExpenseCategory category) async {
  try {
    // Excluir a categoria no Firestore
    await financialActivityService.deleteCategory(category.id);

    // Atualizar registros financeiros que utilizavam a categoria excluída
    await financialActivityService.updateRecordsWithDeletedCategory(
        widget.userProfile.accountId, category.name);

    // Atualize a lista de categorias na UI
    setState(() {
      _categories.remove(category);
      if (_selectedCategory == category) {
        _selectedCategory = null;
      }
    });

    // Mostrar mensagem de sucesso
    _showSnackBar('Categoria excluída com sucesso');
  } catch (e) {
    // Mostrar mensagem de erro
    _showSnackBar('Erro ao excluir categoria: $e');
  }
}


  Widget _newCategoryTextField() {
    return TextFormField(
      controller: _newCategoryController,
      decoration: const InputDecoration(labelText: 'Nova Categoria'),
      validator: (value) {
        if (_isOtherCategorySelected && (value == null || value.isEmpty)) {
          return 'Por favor, insira o nome da nova categoria';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _paymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMethod,
      onChanged: (newValue) {
        setState(() {
          _selectedPaymentMethod = newValue!;
        });
      },
      items: _paymentMethods
          .map((method) => DropdownMenuItem(value: method, child: Text(method)))
          .toList(),
      decoration: const InputDecoration(labelText: 'Método de Pagamento'),
    );
  }

  DropdownButtonFormField<String> _transactionTypeDropdown() =>
      DropdownButtonFormField<String>(
        value: _selectedTransactionType,
        onChanged: (newValue) =>
            setState(() => _selectedTransactionType = newValue!),
        items: _transactionTypes
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        decoration: const InputDecoration(labelText: 'Tipo'),
      );

  TextFormField _textFormField(TextEditingController controller, String label,
      [String? validatorMsg, bool isNumber = false]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: (value) {
        if (validatorMsg != null && (value == null || value.isEmpty)) {
          return validatorMsg;
        }
        if (isNumber && value != null && double.tryParse(value) == null) {
          return 'Por favor, insira um número válido';
        }
        return null;
      },
    );
  }

  Widget _dateFormField() => TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(labelText: 'Data'),
        validator: (value) => value == null || value.isEmpty
            ? 'Por favor, insira uma data'
            : null,
        onTap: () => _selectDate(context),
        readOnly: true,
      );

  ElevatedButton _submitButton() => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _createFinancialRecord();
          }
        },
        child: const Text('Cadastrar'),
      );

  Future<void> _createFinancialRecord() async {
    double amount = double.parse(_amountController.text);
    if (_selectedTransactionType == 'Despesa') {
      amount *= -1;
    }

    ExpenseCategory category;
    if (_isOtherCategorySelected && _newCategoryController.text.isNotEmpty) {
      // Verifica se a categoria já existe
      if (_categories.any((category) =>
          category.name.toLowerCase() ==
          _newCategoryController.text.toLowerCase())) {
        _showSnackBar('Categoria já existe');
        return;
      }

      String newCategoryId =
          new DateTime.now().millisecondsSinceEpoch.toString();

      // Criar nova categoria com os dados fornecidos
      category = ExpenseCategory(
          id: newCategoryId,
          name: _newCategoryController.text,
          accountId: widget.userProfile.accountId);

      await financialActivityService.addCategory(category.toFirestore());
      _categories.insert(_categories.length - 1, category);
      _selectedCategory = category;
    } else {
      category = _selectedCategory ??
          ExpenseCategory(
              id: 'default',
              name: 'Sem Categoria',
              accountId: widget.userProfile.accountId);
    }

    // Criar o registro financeiro
    final record = FinancialRecord(
      recordTitle: _titleController.text,
      recordDate: DateTime.parse(_dateController.text),
      transactionAmount: amount,
      expenseCategory: category.name,
      paymentMethod: _selectedPaymentMethod,
      userIdentifier: widget.userProfile.accountId,
      description: _descriptionController.text,
    );

    try {
      print(category.name);
      await financialActivityService.addFinancialRecord(record);
      _showSnackBar('Registro financeiro adicionado com sucesso!');

      _formKey.currentState!.reset();
      _resetFormFields();
    } catch (error) {
      _showSnackBar('Erro ao adicionar registro: $error');
    }
  }

  void _resetFormFields() {
    _selectedTransactionType = 'Despesa';
    _titleController.clear();
    _dateController.clear();
    _amountController.clear();
    _paymentMethodController.clear();
    _selectedCategory = null;
    _newCategoryController.clear();
    _descriptionController.clear();
    _isOtherCategorySelected = false;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
