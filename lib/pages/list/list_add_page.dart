import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/repository/list_repository.dart';

class ListAddPage extends StatefulWidget {
  static String tag = 'list_add_page';

  const ListAddPage({super.key});

  @override
  ListAddPageState createState() => ListAddPageState();
}

class ListAddPageState extends State<ListAddPage> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  final _dateController = MaskedTextController(mask: '00/00/0000');
  final TextEditingController _listNameController = TextEditingController();
  final GlobalKey<FormState> _formNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formDateKey = GlobalKey<FormState>();
  late ListRepository listRepository;

  void _addList() {
    // Adiciona a nova lista ao repositório
    listRepository.addList(Lists(
        name: _listNameController.text,
        date: _dateController.text,
        isChecked: 'false'));

    // Limpa os campos de texto
    _listNameController.clear();
    _dateController.clear();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listRepository = Provider.of<ListRepository>(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3653)),
      locale: const Locale('pt', 'BR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreenColor,
              onPrimary: AppColors.secondaryWhiteColor,
              surface: AppColors.secondaryWhiteColor,
              onSurface: AppColors.primaryGreenColor,
            ),
            dialogBackgroundColor: AppColors.primaryWhiteColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = _dateFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryGreenColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.primaryWhiteColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'lib/assets/images/logo.svg',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryWhiteColor,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryBlackColor.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Text(
                          'Nova lista',
                          style: TextStyle(
                            color: AppColors.primaryGreenColor,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Form(
                              key: _formNameKey,
                              child: TextFormField(
                                controller: _listNameController,
                                cursorColor: AppColors.secondaryGreenColor,
                                style: const TextStyle(
                                  color: AppColors.primaryBlackColor,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                ),
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondaryGreenColor,
                                    ),
                                  ),
                                  labelText: 'Nome da lista',
                                  labelStyle: TextStyle(
                                    color: AppColors.primaryBlackColor,
                                    fontFamily: AppFonts.montserrat,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Este campo é obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Form(
                              key: _formDateKey,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: AppColors.primaryBlackColor,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                ),
                                controller: _dateController,
                                cursorColor: AppColors.secondaryGreenColor,
                                decoration: InputDecoration(
                                  labelText: 'Data de conclusão',
                                  labelStyle: const TextStyle(
                                    color: AppColors.primaryBlackColor,
                                    fontFamily: AppFonts.montserrat,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    icon: const Icon(
                                      Icons.calendar_today,
                                      color: AppColors.secondaryGreenColor,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.secondaryGreenColor),
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  try {
                                    if (value == '00/00/0000') {
                                      return null;
                                    }
                                    _dateFormat.parseStrict(value);
                                    return null;
                                  } catch (e) {
                                    return 'Formato de data inválido';
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.primaryRedColor
                                      .withOpacity(0.2); // Cor do splash
                                }
                                return null; // Use o valor padrão
                              },
                            ),
                          ),
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppColors.primaryGreenColor,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.secondaryGreenColor
                                      .withOpacity(0.2); // Cor do splash
                                }
                                return null; // Use o valor padrão
                              },
                            ),
                          ),
                          onPressed: () {
                            if (_formNameKey.currentState!.validate() &&
                                _formDateKey.currentState!.validate()) {
                              _addList();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Lista salva'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              color: AppColors.primaryGreenColor,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
