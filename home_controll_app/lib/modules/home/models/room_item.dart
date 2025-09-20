// Enum para tipos de quarto
enum RoomType { bedroom, livingRoom, kitchen }

// Modelo do quarto
class RoomItem {
  final String name;
  final String id;
  final RoomType type;

  RoomItem({required this.name, required this.id, required this.type});
}