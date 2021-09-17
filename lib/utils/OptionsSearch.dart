import 'package:security_app/model/Idbean.dart';

class OptionsSearch {

  static Idbean defaultOption = Idbean(7,'últimos 7 dias');
  static List<Idbean> options = <Idbean>[
    const Idbean(1,'últimas 24 horas'),
    const Idbean(7,'últimos 7 dias'),
    const Idbean(15,'últimos 15 dias'),
    const Idbean(30,'últimos 30 dias'),
  ];

  static List<Idbean> get lstOptions=>options;
  static Idbean get defaultOpt=>defaultOption;


}