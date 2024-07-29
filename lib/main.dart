import 'package:flutter/material.dart';

void main() {
  // 앱의 시작점, MyApp 위젯을 실행합니다.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp은 Flutter의 기본 앱 구조를 제공합니다.
    return MaterialApp(
      title: 'Memo App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 색상을 파란색으로 설정합니다.
      ),
      home: MemoListScreen(), // 앱이 시작될 때 표시할 화면을 MemoListScreen으로 설정합니다.
    );
  }
}

// 메모 목록 화면을 상태를 가지는 StatefulWidget으로 정의합니다.
class MemoListScreen extends StatefulWidget {
  @override
  _MemoListScreenState createState() => _MemoListScreenState();
}

class _MemoListScreenState extends State<MemoListScreen> {
  // 메모를 저장할 리스트를 정의합니다.
  final List<String> _memos = [];

  // 새로운 메모를 추가하는 함수입니다.
  void _addMemo(String memo) {
    setState(() {
      _memos.add(memo); // 메모 리스트에 새로운 메모를 추가합니다.
    });
  }

  // 기존 메모를 수정하는 함수입니다.
  void _editMemo(int index, String memo) {
    setState(() {
      _memos[index] = memo; // 해당 인덱스의 메모를 수정된 메모로 교체합니다.
    });
  }

  // 메모를 삭제하는 함수입니다.
  void _deleteMemo(int index) {
    setState(() {
      _memos.removeAt(index); // 해당 인덱스의 메모를 리스트에서 삭제합니다.
    });
  }

  // 메모 추가 화면으로 이동하는 함수입니다.
  void _navigateToAddMemoScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMemoScreen()),
    );

    // 추가된 메모가 null이 아닌 경우 메모 리스트에 추가합니다.
    if (result != null) {
      _addMemo(result);
    }
  }

  // 메모 수정 화면으로 이동하는 함수입니다.
  void _navigateToEditMemoScreen(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemoScreen(
          initialMemo: _memos[index], // 수정할 메모를 전달합니다.
        ),
      ),
    );

    // 수정된 메모가 null이 아닌 경우 해당 메모를 수정합니다.
    if (result != null) {
      _editMemo(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모장'), // 앱 바의 제목을 설정합니다.
      ),
      body: ListView.builder(
        itemCount: _memos.length, // 메모 리스트의 길이를 설정합니다.
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_memos[index]), // 메모 내용을 표시합니다.
            onTap: () => _navigateToEditMemoScreen(context, index), // 메모를 클릭하면 수정 화면으로 이동합니다.
            trailing: IconButton(
              icon: Icon(Icons.delete), // 삭제 아이콘을 표시합니다.
              onPressed: () => _deleteMemo(index), // 삭제 아이콘을 클릭하면 해당 메모를 삭제합니다.
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddMemoScreen(context), // 플로팅 액션 버튼을 클릭하면 메모 추가 화면으로 이동합니다.
        child: Icon(Icons.add), // 플로팅 액션 버튼에 더하기 아이콘을 설정합니다.
      ),
    );
  }
}

// 메모 추가 및 수정을 위한 화면을 StatelessWidget으로 정의합니다.
class AddMemoScreen extends StatelessWidget {
  final String? initialMemo; // 초기 메모 내용 (수정 시 사용)
  final TextEditingController _controller = TextEditingController();

  // 생성자에서 초기 메모 내용을 설정합니다.
  AddMemoScreen({this.initialMemo}) {
    if (initialMemo != null) {
      _controller.text = initialMemo!; // 초기 메모 내용이 있는 경우 텍스트 필드에 설정합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(initialMemo == null ? '메모 추가' : '메모 수정'), // 앱 바의 제목을 추가 또는 수정으로 설정합니다.
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // 화면에 여백을 줍니다.
        child: Column(
          children: [
            TextField(
              controller: _controller, // 텍스트 필드의 컨트롤러를 설정합니다.
              decoration: InputDecoration(
                hintText: '내용을 입력하세요', // 텍스트 필드에 힌트를 설정합니다.
              ),
              maxLines: null, // 여러 줄 입력을 허용합니다.
            ),
            SizedBox(height: 16.0), // 간격을 줍니다.
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text); // 버튼을 클릭하면 현재 입력된 메모를 반환합니다.
              },
              child: Text('Save'), // 버튼의 텍스트를 'Save'로 설정합니다.
            ),
          ],
        ),
      ),
    );
  }
}
