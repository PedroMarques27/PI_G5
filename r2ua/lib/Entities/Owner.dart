
class Owner{
    String name, email, phone; 

    Owner({
      this.name, this.email, this.phone
    });

    factory Owner.fromJson(Map<String, dynamic> json) {
      return Owner(name: json['name'], email: json['email'], phone: json['phone']);
  }
  }