class detailData {
    String base_unit;
    String factory;
    String material;
    num output_kg;
    String plant;
    String process_order_no;
    String production_date;
    String timestamp;
    String time_entry;
    String production_plant;
    String master_tag;


  detailData(
       {this.base_unit,this.factory, this.material, this.output_kg, this.plant, this.process_order_no, this.production_date, this.timestamp, this.time_entry, this.production_plant, this.master_tag});

   factory detailData.fromJson(Map<String, dynamic> json) {
     return detailData(
       base_unit: json['BASE_UNIT'],
       factory: json['FACTORY'],
       material: json['MATERIAL'],
       output_kg: json['OUTPUT_KG'],
       plant: json['PLANT'],
       process_order_no: json['PROCESS_ORDER_NO'],
       production_date: json['PRODUCTION_DATE'],
       timestamp: json['TIMESTAMP'],
       time_entry: json['TIME_ENTRY'],
       production_plant: json['PRODUCTION_PLANT'],
       master_tag: json['MASTER_TAG']
     );
   }

}