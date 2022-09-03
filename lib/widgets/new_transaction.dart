import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.button.color,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.normal),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
