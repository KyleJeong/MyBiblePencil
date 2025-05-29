import React, { useState } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity, SafeAreaView, ScrollView, Alert } from 'react-native';
import { RootStackScreenProps } from '../types/navigation';
import { BibleVerse } from '../services/bibleApi';
import AsyncStorage from '@react-native-async-storage/async-storage';

type SavedCopy = {
  id: string;
  title: string;
  verses: BibleVerse[];
  content: string;
  createdAt: string;
};

export default function WriteScreen({ route, navigation }: RootStackScreenProps<'Write'>) {
  const { verses, book, chapter, translation } = route.params;
  const [title, setTitle] = useState<string>(`${book} ${chapter}장`);
  const [content, setContent] = useState<string>('');
  const [isSaving, setIsSaving] = useState<boolean>(false);

  const handleSave = async () => {
    if (!content.trim()) {
      Alert.alert('알림', '필사 내용을 입력해주세요.');
      return;
    }

    setIsSaving(true);
    try {
      const savedCopy: SavedCopy = {
        id: Date.now().toString(),
        title,
        verses,
        content,
        createdAt: new Date().toISOString(),
      };

      // 기존 저장된 필사 목록 가져오기
      const savedCopiesJson = await AsyncStorage.getItem('savedCopies');
      const savedCopies: SavedCopy[] = savedCopiesJson ? JSON.parse(savedCopiesJson) : [];
      
      // 새로운 필사 추가
      savedCopies.unshift(savedCopy);
      
      // 저장
      await AsyncStorage.setItem('savedCopies', JSON.stringify(savedCopies));
      
      Alert.alert('알림', '필사가 저장되었습니다.', [
        { text: '확인', onPress: () => navigation.goBack() }
      ]);
    } catch (error) {
      Alert.alert('오류', '필사를 저장하는 중 오류가 발생했습니다.');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity 
          style={styles.backButton}
          onPress={() => navigation.goBack()}
        >
          <Text style={styles.backButtonText}>←</Text>
        </TouchableOpacity>
        <Text style={styles.title}>필사하기</Text>
      </View>

      <View style={styles.content}>
        <View style={styles.bibleTextContainer}>
          <ScrollView style={styles.bibleText}>
            {verses.map((verse: BibleVerse) => (
              <Text key={verse.verse} style={styles.verseText}>
                {verse.verse} {verse.text}
              </Text>
            ))}
          </ScrollView>
        </View>

        <View style={styles.writeContainer}>
          <TextInput
            style={styles.titleInput}
            value={title}
            onChangeText={setTitle}
            placeholder="제목을 입력하세요"
            placeholderTextColor="#999"
          />
          <TextInput
            style={styles.contentInput}
            value={content}
            onChangeText={setContent}
            placeholder="여기에 필사하세요"
            placeholderTextColor="#999"
            multiline
            textAlignVertical="top"
          />
        </View>
      </View>

      <View style={styles.footer}>
        <TouchableOpacity 
          style={[styles.saveButton, isSaving && styles.disabledButton]}
          onPress={handleSave}
          disabled={isSaving}
        >
          <Text style={styles.saveButtonText}>
            {isSaving ? '저장 중...' : '저장하기'}
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  backButton: {
    padding: 10,
  },
  backButtonText: {
    fontSize: 24,
    color: '#333',
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  content: {
    flex: 1,
    flexDirection: 'row',
  },
  bibleTextContainer: {
    flex: 1,
    borderRightWidth: 1,
    borderRightColor: '#eee',
    padding: 15,
  },
  bibleText: {
    flex: 1,
  },
  verseText: {
    fontSize: 16,
    lineHeight: 24,
    marginBottom: 10,
  },
  writeContainer: {
    flex: 1,
    padding: 15,
  },
  titleInput: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
    padding: 10,
    borderWidth: 1,
    borderColor: '#eee',
    borderRadius: 5,
  },
  contentInput: {
    flex: 1,
    fontSize: 16,
    lineHeight: 24,
    padding: 10,
    borderWidth: 1,
    borderColor: '#eee',
    borderRadius: 5,
  },
  footer: {
    padding: 15,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  saveButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  disabledButton: {
    backgroundColor: '#ccc',
  },
  saveButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
}); 