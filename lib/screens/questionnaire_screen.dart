import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/review.dart';
import '../services/database_service.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Book book;

  const QuestionnaireScreen({
    super.key,
    required this.book,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  double _rating = 3.0;
  String _pacing = "Modéré";
  bool _likedEnding = true;
  final TextEditingController _commentController = TextEditingController();
  bool _isSaving = false;

  final List<String> _pacingOptions = ["Lent", "Modéré", "Rapide"];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveReview() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final review = Review(
        bookId: widget.book.id,
        rating: _rating,
        pacing: _pacing,
        likedEnding: _likedEnding,
        comment: _commentController.text.trim(),
        date: DateTime.now(),
      );

      await DatabaseService().saveReview(review);

      if (!mounted) return;

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Avis enregistré avec succès !'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Attendre un peu puis retourner
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Erreur: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire de Lecture'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec info du livre
            _buildBookHeader(theme),
            
            const SizedBox(height: 32),

            // Section Note
            _buildRatingSection(theme),
            
            const SizedBox(height: 32),

            // Section Rythme
            _buildPacingSection(theme),
            
            const SizedBox(height: 32),

            // Section Fin
            _buildEndingSection(theme),
            
            const SizedBox(height: 32),

            // Section Commentaire
            _buildCommentSection(theme),
            
            const SizedBox(height: 40),

            // Bouton Enregistrer
            _buildSaveButton(theme),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.book.imagePath,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.book.author,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: theme.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Note du livre',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Affichage des étoiles
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < _rating.floor()
                      ? Icons.star
                      : (index < _rating ? Icons.star_half : Icons.star_border),
                  color: Colors.amber,
                  size: 40,
                );
              }),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Valeur numérique
          Center(
            child: Text(
              _rating.toStringAsFixed(1),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Slider
          Slider(
            value: _rating,
            min: 1.0,
            max: 5.0,
            divisions: 8,
            label: _rating.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          
          // Labels min/max
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1.0', style: theme.textTheme.bodySmall),
              Text('5.0', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPacingSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: theme.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Rythme du livre',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _pacing,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                style: theme.textTheme.bodyLarge,
                items: _pacingOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          value == "Lent"
                              ? Icons.trending_down
                              : value == "Modéré"
                                  ? Icons.trending_flat
                                  : Icons.trending_up,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _pacing = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndingSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Icon(
              _likedEnding ? Icons.favorite : Icons.favorite_border,
              color: theme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Avez-vous aimé la fin ?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        value: _likedEnding,
        onChanged: (bool value) {
          setState(() {
            _likedEnding = value;
          });
        },
      ),
    );
  }

  Widget _buildCommentSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment, color: theme.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Votre commentaire',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Partagez votre avis sur ce livre...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          shadowColor: theme.primaryColor.withValues(alpha: 0.4),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
