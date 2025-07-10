import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TechnologyNewsScreen extends StatefulWidget {
  const TechnologyNewsScreen({super.key});

  @override
  State<TechnologyNewsScreen> createState() => _TechnologyNewsScreenState();
}

class _TechnologyNewsScreenState extends State<TechnologyNewsScreen> {
  final String apiKey =
      '95a20f4928ba4f5cad51b2df5076a8e4'; // 🔑 Thay bằng key thật
  List<Article> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?category=technology&language=en&apiKey=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _articles = articlesJson.map((json) => Article.fromJson(json)).toList();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức công nghệ'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
              ? const Center(child: Text('Không có tin tức.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) =>
                      NewsTile(article: _articles[index]),
                ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt']?.substring(0, 10) ?? '',
      url: json['url'] ?? '',
    );
  }
}

class NewsTile extends StatelessWidget {
  final Article article;

  const NewsTile({super.key, required this.article});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Không thể mở $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openUrl(article.url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.imageUrl,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(article.publishedAt,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
