import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddManualEntryPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;

  AddManualEntryPage({required this.onAddItem});

  @override
  _AddManualEntryPageState createState() => _AddManualEntryPageState();
}

class _AddManualEntryPageState extends State<AddManualEntryPage> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  final _nameController = TextEditingController();
  final _newTagController = TextEditingController();
  final _tags = ['Tag1', 'Tag2', 'Tag3']; // 示例标签
  final _selectedTags = <String>{};

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _addNewTag() {
    final newTag = _newTagController.text.trim();
    if (newTag.isNotEmpty && !_tags.contains(newTag)) {
      setState(() {
        _tags.add(newTag);
        _selectedTags.add(newTag);
        _newTagController.clear();
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAddItem({
        'image': _image?.path,
        'name': _nameController.text,
        'tags': _selectedTags.toList(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('手动录入'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: _image == null
                      ? Center(child: Text('点击选择图片'))
                      : Image.file(File(_image!.path), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '名称'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入名称';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('标签', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _tags.map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              TextField(
                controller: _newTagController,
                decoration: InputDecoration(
                  labelText: '添加新标签',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewTag,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
