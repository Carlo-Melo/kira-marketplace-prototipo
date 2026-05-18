import 'dart:io';

Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.tryParse(args.first) ?? 8080 : 8080;
  final base = Directory('build/web');
  if (!base.existsSync()) {
    stderr.writeln('build/web not found. Run: flutter build web');
    exitCode = 1;
    return;
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Serving ${base.path} at http://127.0.0.1:$port');

  await for (final req in server) {
    try {
      var path = req.uri.path;
      if (path == '/' || path.isEmpty) {
        path = '/index.html';
      }

      final filePath = '${base.path}${path.replaceAll('/', Platform.pathSeparator)}';
      final file = File(filePath);
      final fallback = File('${base.path}${Platform.pathSeparator}index.html');
      final target = file.existsSync() ? file : fallback;

      final mime = _mimeFor(target.path);
      req.response.headers.contentType = ContentType.parse(mime);
      await req.response.addStream(target.openRead());
      await req.response.close();
    } catch (e) {
      req.response.statusCode = HttpStatus.internalServerError;
      req.response.write('Server error: $e');
      await req.response.close();
    }
  }
}

String _mimeFor(String path) {
  if (path.endsWith('.html')) return 'text/html; charset=utf-8';
  if (path.endsWith('.js')) return 'application/javascript; charset=utf-8';
  if (path.endsWith('.css')) return 'text/css; charset=utf-8';
  if (path.endsWith('.json')) return 'application/json; charset=utf-8';
  if (path.endsWith('.wasm')) return 'application/wasm';
  if (path.endsWith('.png')) return 'image/png';
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
  if (path.endsWith('.svg')) return 'image/svg+xml';
  if (path.endsWith('.ico')) return 'image/x-icon';
  if (path.endsWith('.woff2')) return 'font/woff2';
  if (path.endsWith('.ttf')) return 'font/ttf';
  return 'application/octet-stream';
}
