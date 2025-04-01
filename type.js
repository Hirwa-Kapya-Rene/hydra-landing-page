class User{
  nom : string;
  prenom : string;
  age : number;
  constructor(nom : string, prenom : string, age : number){
    this.nom = nom;
    this.prenom = prenom;
    this.age = age;
  }
  getNom(){
    return this.nom;
  } 
}