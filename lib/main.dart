import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  //This key is used to id the instance of this form
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Dollars', 'Pounds', 'Rupess'];
  final _minPadding = 5.0;
  var _currentItemSelected = '';
  var displayResult = '';

  //to get around the "Only static members can be accessed in initializers."
  //_currentItemSelected = _currencies[0];
  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minPadding * 2),
        //margin: EdgeInsets.all(_minPadding),
          child: ListView(
            children: <Widget>[
              getImageAssest(),
              Padding(
                child: TextFormField(
                  controller: principalController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter principal amount';
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Principal',
                      hintText: 'Enter Principal e.g. 12000',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              ),
              Padding(
                child: TextFormField(
                  controller: roiController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter rate of interest';
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Rate of Interest',
                      hintText: 'In percent',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: termController,
                        validator: (String value){
                          if(value.isEmpty){
                            return 'Please enter time';
                          }
                        },
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: 'Time in years',
                            labelStyle: textStyle,
                            errorStyle: TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(width: _minPadding * 5),
                    Expanded(
                        child: DropdownButton<String>(
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: _currentItemSelected,
                            onChanged: (String newValueSelected) {
                              _onDropDownItemSelected(newValueSelected);
                            }))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: _minPadding, top: _minPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          'Calculate',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          
                          setState(() {
                            if(_formKey.currentState.validate()){
                            this.displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Reset', textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: _minPadding, top: _minPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAssest() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(
      child: image,
      margin: EdgeInsets.all(_minPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    this.principalController.text = '';
    this.roiController.text = '';
    this.termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
