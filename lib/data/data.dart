import '../models/book.dart';

// Ces données correspondent exactement aux images présentes dans tes assets.
// Elles seront injectées dans la base de données SQLite au premier lancement.

final List<Book> allBooks = [
  Book(
    id: '1',
    title: 'Le Petit Prince',
    author: 'Antoine de Saint-Exupéry',
    genre: 'Philosophie',
    imagePath: 'assets/images/petit_prince.jpg',
    description: 'Un pilote s\'écrase dans le désert et rencontre un jeune prince venu d\'une autre planète. Une fable poétique sur l\'humanité.',
    durationMinutes: 90, // ~90 pages
    popularity: 150,
  ),
  Book(
    id: '2',
    title: '1984',
    author: 'George Orwell',
    genre: 'Science-Fiction',
    imagePath: 'assets/images/1984.jpg',
    description: 'Dans une société totalitaire soumise à Big Brother, Winston Smith tente de résister en commettant un crime par la pensée.',
    durationMinutes: 350, // ~300 pages
    popularity: 140,
  ),
  Book(
    id: '3',
    title: 'Harry Potter à l’école des sorciers',
    author: 'J.K. Rowling',
    genre: 'Fantasy',
    imagePath: 'assets/images/harry_potter.jpg',
    description: 'Le jour de ses onze ans, Harry Potter découvre qu\'il est un sorcier et rejoint l\'école de sorcellerie de Poudlard.',
    durationMinutes: 380, // ~300 pages
    popularity: 200,
  ),
  Book(
    id: '4',
    title: 'Le Seigneur des Anneaux',
    author: 'J.R.R. Tolkien',
    genre: 'Fantasy',
    imagePath: 'assets/images/lotr_communaut.jpg',
    description: 'Le jeune hobbit Frodon Sacquet hérite d\'un anneau unique et doit entreprendre un voyage périlleux pour le détruire.',
    durationMinutes: 700, // Tome 1 assez dense
    popularity: 180,
  ),
  Book(
    id: '5',
    title: 'Dune',
    author: 'Frank Herbert',
    genre: 'Science-Fiction',
    imagePath: 'assets/images/dune.jpg',
    description: 'Sur la planète des sables Arrakis, Paul Atreides se retrouve au cœur d\'une lutte politique et écologique pour l\'Épice.',
    durationMinutes: 900, // Très long
    popularity: 160,
  ),
  Book(
    id: '6',
    title: 'Le Hobbit',
    author: 'J.R.R. Tolkien',
    genre: 'Fantasy',
    imagePath: 'assets/images/le_hobbit.jpg',
    description: 'Bilbo Bessac, un hobbit sans histoire, est entraîné par le magicien Gandalf dans une quête pour récupérer un trésor gardé par un dragon.',
    durationMinutes: 320, // Plus court que LOTR
    popularity: 130,
  ),
  Book(
    id: '7',
    title: 'L’Alchimiste',
    author: 'Paulo Coelho',
    genre: 'Philosophie',
    imagePath: 'assets/images/l_alchimiste.jpg',
    description: 'Santiago, un jeune berger andalou, part à la recherche d\'un trésor enfoui au pied des Pyramides.',
    durationMinutes: 120, // Court
    popularity: 110,
  ),
  Book(
    id: '8',
    title: 'Fondation',
    author: 'Isaac Asimov',
    genre: 'Science-Fiction',
    imagePath: 'assets/images/fondation.jpg',
    description: 'Le psychohistorien Hari Seldon prédit la chute de l\'Empire Galactique et crée une Fondation pour préserver le savoir.',
    durationMinutes: 280, // ~250 pages
    popularity: 105,
  ),
  Book(
    id: '9',
    title: 'Les Misérables',
    author: 'Victor Hugo',
    genre: 'Classique',
    imagePath: 'assets/images/les_miserables.jpg',
    description: 'La vie de Jean Valjean, ancien forçat en quête de rédemption, poursuivi par l\'impitoyable inspecteur Javert.',
    durationMinutes: 2800, // Monumental (~1500 pages)
    popularity: 120,
  ),
  Book(
    id: '10',
    title: 'L’Assassin Royal',
    author: 'Robin Hobb',
    genre: 'Fantasy',
    imagePath: 'assets/images/assassin_royal1.jpg',
    description: 'Fitz, le bâtard d\'un prince, est formé à l\'art de l\'assassinat pour servir le roi en secret.',
    durationMinutes: 550, // Assez long
    popularity: 95,
  ),
  Book(
    id: '11',
    title: 'Shining',
    author: 'Stephen King',
    genre: 'Horreur',
    imagePath: 'assets/images/shining.jpg',
    description: 'Jack Torrance accepte un poste de gardien dans un hôtel isolé par la neige, où des forces maléfiques le poussent à la folie.',
    durationMinutes: 500,
    popularity: 115,
  ),
  Book(
    id: '12',
    title: 'Autant en emporte le vent',
    author: 'Margaret Mitchell',
    genre: 'Romance Historique',
    imagePath: 'assets/images/autant_en_emporte_le_vent.jpg',
    description: 'La vie tumultueuse de Scarlett O\'Hara pendant la guerre de Sécession américaine.',
    durationMinutes: 1100, // Très long
    popularity: 100,
  ),
  Book(
    id: '13',
    title: 'Les Fleurs du mal',
    author: 'Charles Baudelaire',
    genre: 'Poésie',
    imagePath: 'assets/images/les_fleurs_du_mal.jpg',
    description: 'Un recueil de poèmes explorant la modernité, le spleen, la beauté et la décadence.',
    durationMinutes: 180, // Poésie, lecture variable mais courte
    popularity: 90,
  ),
  Book(
    id: '14',
    title: 'La Voleuse de livres',
    author: 'Markus Zusak',
    genre: 'Drame',
    imagePath: 'assets/images/la_voleuse_de_livres.jpg',
    description: 'Liesel vole des livres dans l\'Allemagne nazie et partage son amour des mots avec un réfugié juif caché dans sa cave.',
    durationMinutes: 580,
    popularity: 125,
  ),
  Book(
    id: '15',
    title: 'Le Nom du Vent',
    author: 'Patrick Rothfuss',
    genre: 'Fantasy',
    imagePath: 'assets/images/le_nom_du_vent.jpg',
    description: 'Kvothe, aubergiste humble, raconte sa véritable histoire : celle d\'un magicien légendaire et musicien de génie.',
    durationMinutes: 850, // Très dense
    popularity: 135,
  ),
  Book(
    id: '16',
    title: 'La Horde du Contrevent',
    author: 'Alain Damasio',
    genre: 'Science-Fiction',
    imagePath: 'assets/images/la_horde_du_contrevent.jpg',
    description: 'Un groupe d\'élite remonte à pied vers l\'origine du vent, dans un monde balayé par des tempêtes constantes.',
    durationMinutes: 750,
    popularity: 110,
  ),
  Book(
    id: '17',
    title: 'Neuromancien',
    author: 'William Gibson',
    genre: 'Cyberpunk',
    imagePath: 'assets/images/neuromancien.jpg',
    description: 'Un hacker sur le déclin est engagé pour une dernière mission suicidaire dans le cyberespace.',
    durationMinutes: 320,
    popularity: 98,
  ),
  Book(
    id: '18',
    title: 'Orgueil et Préjugés',
    author: 'Jane Austen',
    genre: 'Romance',
    imagePath: 'assets/images/orgueil_et_prejuges.jpg',
    description: 'Les affrontements spirituels et amoureux entre Elizabeth Bennet et le riche mais orgueilleux Mr Darcy.',
    durationMinutes: 400,
    popularity: 145,
  ),
  Book(
    id: '19',
    title: 'Le Parfum',
    author: 'Patrick Süskind',
    genre: 'Thriller',
    imagePath: 'assets/images/le_parfum.jpg',
    description: 'L\'histoire d\'un meurtrier doté d\'un odorat absolu dans la France du XVIIIe siècle, cherchant à créer l\'essence parfaite.',
    durationMinutes: 340,
    popularity: 108,
  ),
  Book(
    id: '20',
    title: 'La Ferme des animaux',
    author: 'George Orwell',
    genre: 'Satire',
    imagePath: 'assets/images/la_ferme_des_animaux.jpg',
    description: 'Les animaux d\'une ferme se révoltent contre les humains pour créer une société égalitaire, mais la corruption s\'installe.',
    durationMinutes: 100, // Très court
    popularity: 130,
  ),
];