import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, SafeAreaView, Alert } from 'react-native';
import { RootStackScreenProps } from '../types/navigation';
import { getBibleChapter } from '../services/bibleApi';

type Language = 'ko' | 'en';
type Translation = {
  id: string;
  name: string;
  language: Language;
};

const translations: Translation[] = [
  { id: 'krv', name: '개역개정', language: 'ko' },
  { id: 'krv2', name: '개역한글', language: 'ko' },
  { id: 'niv', name: 'NIV', language: 'en' },
  { id: 'kjv', name: 'KJV', language: 'en' },
];

const allBooks = [
  { id: 'gen', name: '창세기', chapters: 50, testament: 'old' },
  { id: 'exo', name: '출애굽기', chapters: 40, testament: 'old' },
  { id: 'lev', name: '레위기', chapters: 27, testament: 'old' },
  { id: 'num', name: '민수기', chapters: 36, testament: 'old' },
  { id: 'deu', name: '신명기', chapters: 34, testament: 'old' },
  { id: 'jos', name: '여호수아', chapters: 24, testament: 'old' },
  { id: 'jud', name: '사사기', chapters: 21, testament: 'old' },
  { id: 'rut', name: '룻기', chapters: 4, testament: 'old' },
  { id: '1sa', name: '사무엘상', chapters: 31, testament: 'old' },
  { id: '2sa', name: '사무엘하', chapters: 24, testament: 'old' },
  { id: '1ki', name: '열왕기상', chapters: 22, testament: 'old' },
  { id: '2ki', name: '열왕기하', chapters: 25, testament: 'old' },
  { id: '1ch', name: '역대상', chapters: 29, testament: 'old' },
  { id: '2ch', name: '역대하', chapters: 36, testament: 'old' },
  { id: 'ezr', name: '에스라', chapters: 10, testament: 'old' },
  { id: 'neh', name: '느헤미야', chapters: 13, testament: 'old' },
  { id: 'est', name: '에스더', chapters: 10, testament: 'old' },
  { id: 'job', name: '욥기', chapters: 42, testament: 'old' },
  { id: 'psa', name: '시편', chapters: 150, testament: 'old' },
  { id: 'pro', name: '잠언', chapters: 31, testament: 'old' },
  { id: 'ecc', name: '전도서', chapters: 12, testament: 'old' },
  { id: 'sng', name: '아가', chapters: 8, testament: 'old' },
  { id: 'isa', name: '이사야', chapters: 66, testament: 'old' },
  { id: 'jer', name: '예레미야', chapters: 52, testament: 'old' },
  { id: 'lam', name: '예레미야애가', chapters: 5, testament: 'old' },
  { id: 'ezk', name: '에스겔', chapters: 48, testament: 'old' },
  { id: 'dan', name: '다니엘', chapters: 12, testament: 'old' },
  { id: 'hos', name: '호세아', chapters: 14, testament: 'old' },
  { id: 'jol', name: '요엘', chapters: 3, testament: 'old' },
  { id: 'amo', name: '아모스', chapters: 9, testament: 'old' },
  { id: 'oba', name: '오바댜', chapters: 1, testament: 'old' },
  { id: 'jon', name: '요나', chapters: 4, testament: 'old' },
  { id: 'mic', name: '미가', chapters: 7, testament: 'old' },
  { id: 'nah', name: '나훔', chapters: 3, testament: 'old' },
  { id: 'hab', name: '하박국', chapters: 3, testament: 'old' },
  { id: 'zep', name: '스바냐', chapters: 3, testament: 'old' },
  { id: 'hag', name: '학개', chapters: 2, testament: 'old' },
  { id: 'zac', name: '스가랴', chapters: 14, testament: 'old' },
  { id: 'mal', name: '말라기', chapters: 4, testament: 'old' },
  { id: 'mat', name: '마태복음', chapters: 28, testament: 'new' },
  { id: 'mrk', name: '마가복음', chapters: 16, testament: 'new' },
  { id: 'luk', name: '누가복음', chapters: 24, testament: 'new' },
  { id: 'jhn', name: '요한복음', chapters: 21, testament: 'new' },
  { id: 'act', name: '사도행전', chapters: 28, testament: 'new' },
  { id: 'rom', name: '로마서', chapters: 16, testament: 'new' },
  { id: '1co', name: '고린도전서', chapters: 16, testament: 'new' },
  { id: '2co', name: '고린도후서', chapters: 13, testament: 'new' },
  { id: 'gal', name: '갈라디아서', chapters: 6, testament: 'new' },
  { id: 'eph', name: '에베소서', chapters: 6, testament: 'new' },
  { id: 'php', name: '빌립보서', chapters: 4, testament: 'new' },
  { id: 'col', name: '골로새서', chapters: 4, testament: 'new' },
  { id: '1th', name: '데살로니가전서', chapters: 5, testament: 'new' },
  { id: '2th', name: '데살로니가후서', chapters: 3, testament: 'new' },
  { id: '1ti', name: '디모데전서', chapters: 6, testament: 'new' },
  { id: '2ti', name: '디모데후서', chapters: 4, testament: 'new' },
  { id: 'tit', name: '디도서', chapters: 3, testament: 'new' },
  { id: 'phm', name: '빌레몬서', chapters: 1, testament: 'new' },
  { id: 'heb', name: '히브리서', chapters: 13, testament: 'new' },
  { id: 'jas', name: '야고보서', chapters: 5, testament: 'new' },
  { id: '1pe', name: '베드로전서', chapters: 5, testament: 'new' },
  { id: '2pe', name: '베드로후서', chapters: 3, testament: 'new' },
  { id: '1jn', name: '요한일서', chapters: 5, testament: 'new' },
  { id: '2jn', name: '요한이서', chapters: 1, testament: 'new' },
  { id: '3jn', name: '요한삼서', chapters: 1, testament: 'new' },
  { id: 'jude', name: '유다서', chapters: 1, testament: 'new' },
  { id: 'rev', name: '요한계시록', chapters: 22, testament: 'new' },
];

const oldTestamentBooks = allBooks.filter(book => book.testament === 'old');
const newTestamentBooks = allBooks.filter(book => book.testament === 'new');

export default function BibleSelectScreen({ navigation }: RootStackScreenProps<'BibleSelect'>) {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>('ko');
  const [selectedTranslation, setSelectedTranslation] = useState<string>('krv');
  const [selectedTestament, setSelectedTestament] = useState<'old' | 'new'>('old');
  const [selectedBook, setSelectedBook] = useState<string>('gen');
  const [selectedChapter, setSelectedChapter] = useState<number>(1);

  // Add console logs to track state changes
  React.useEffect(() => {
    console.log('Selected Language:', selectedLanguage);
  }, [selectedLanguage]);

  React.useEffect(() => {
    console.log('Selected Translation:', selectedTranslation);
  }, [selectedTranslation]);

  React.useEffect(() => {
    console.log('Selected Testament:', selectedTestament);
  }, [selectedTestament]);

  React.useEffect(() => {
    console.log('Selected Book:', selectedBook);
  }, [selectedBook]);

  React.useEffect(() => {
    console.log('Selected Chapter:', selectedChapter);
  }, [selectedChapter]);

  const filteredTranslations = translations.filter(t => t.language === selectedLanguage);
  const filteredBooks = selectedTestament === 'old' ? oldTestamentBooks : newTestamentBooks;
  const selectedBookInfo = filteredBooks.find(b => b.id === selectedBook);

  const handleConfirm = async () => {
    try {
      const response = await getBibleChapter(selectedTranslation, selectedBook, selectedChapter);
      if (response) {
        navigation.navigate('Copy', {
          verses: response.verses,
          book: selectedBook,
          chapter: selectedChapter,
          translation: selectedTranslation
        });
      }
    } catch (error) {
      console.error('Error fetching Bible verses:', error);
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
        <Text style={styles.title}>성경 선택</Text>
      </View>

      <ScrollView style={styles.content}>
        {/* 언어 선택 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>언어</Text>
          <View style={styles.languageButtons}>
            <TouchableOpacity
              style={[
                styles.languageButton,
                selectedLanguage === 'ko' && styles.selectedButton
              ]}
              onPress={() => setSelectedLanguage('ko')}
            >
              <Text style={[
                styles.languageButtonText,
                selectedLanguage === 'ko' && styles.selectedButtonText
              ]}>한국어</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[
                styles.languageButton,
                selectedLanguage === 'en' && styles.selectedButton
              ]}
              onPress={() => setSelectedLanguage('en')}
            >
              <Text style={[
                styles.languageButtonText,
                selectedLanguage === 'en' && styles.selectedButtonText
              ]}>English</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* 번역본 선택 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>번역본</Text>
          <View style={styles.translationButtons}>
            {filteredTranslations.map(translation => (
              <TouchableOpacity
                key={translation.id}
                style={[
                  styles.translationButton,
                  selectedTranslation === translation.id && styles.selectedButton
                ]}
                onPress={() => setSelectedTranslation(translation.id)}
              >
                <Text style={[
                  styles.translationButtonText,
                  selectedTranslation === translation.id && styles.selectedButtonText
                ]}>{translation.name}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* 구약/신약 선택 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>구분</Text>
          <View style={styles.testamentButtons}>
            <TouchableOpacity
              style={[
                styles.testamentButton,
                selectedTestament === 'old' && styles.selectedButton
              ]}
              onPress={() => {
                setSelectedTestament('old');
                setSelectedBook(oldTestamentBooks[0].id);
                setSelectedChapter(1);
              }}
            >
              <Text style={[
                styles.testamentButtonText,
                selectedTestament === 'old' && styles.selectedButtonText
              ]}>구약</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[
                styles.testamentButton,
                selectedTestament === 'new' && styles.selectedButton
              ]}
              onPress={() => {
                setSelectedTestament('new');
                setSelectedBook(newTestamentBooks[0].id);
                setSelectedChapter(1);
              }}
            >
              <Text style={[
                styles.testamentButtonText,
                selectedTestament === 'new' && styles.selectedButtonText
              ]}>신약</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* 책 선택 - filtered based on testament */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>책</Text>
          <ScrollView 
            horizontal 
            style={styles.bookScroll}
            showsHorizontalScrollIndicator={true}
            contentContainerStyle={styles.bookScrollContent}
          >
            {filteredBooks.map(book => (
              <TouchableOpacity
                key={book.id}
                style={[
                  styles.bookButton,
                  selectedBook === book.id && styles.selectedButton
                ]}
                onPress={() => {
                  setSelectedBook(book.id);
                  setSelectedChapter(1);
                  console.log('Book selected:', book.id);
                }}
              >
                <Text style={[
                  styles.bookButtonText,
                  selectedBook === book.id && styles.selectedButtonText
                ]}>{book.name}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* 장 선택 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>장</Text>
          <ScrollView horizontal style={styles.chapterScroll}>
            {selectedBookInfo && Array.from({ length: selectedBookInfo.chapters }, (_, i) => i + 1).map(chapter => (
              <TouchableOpacity
                key={chapter}
                style={[
                  styles.chapterButton,
                  selectedChapter === chapter && styles.selectedButton
                ]}
                onPress={() => {
                  setSelectedChapter(chapter);
                  console.log('Chapter selected:', chapter);
                }}
              >
                <Text style={[
                  styles.chapterButtonText,
                  selectedChapter === chapter && styles.selectedButtonText
                ]}>{chapter}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* 선택 완료 버튼 */}
        <TouchableOpacity 
          style={styles.confirmButton}
          onPress={handleConfirm}
        >
          <Text style={styles.confirmButtonText}>선택 완료</Text>
        </TouchableOpacity>
      </ScrollView>
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
    padding: 15,
  },
  section: {
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  languageButtons: {
    flexDirection: 'row',
    gap: 10,
  },
  languageButton: {
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#f0f0f0',
    minWidth: 100,
    alignItems: 'center',
  },
  languageButtonText: {
    fontSize: 16,
    color: '#333',
  },
  translationButtons: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
  },
  translationButton: {
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#f0f0f0',
    minWidth: 100,
    alignItems: 'center',
  },
  translationButtonText: {
    fontSize: 16,
    color: '#333',
  },
  testamentButtons: {
    flexDirection: 'row',
    gap: 10,
  },
  testamentButton: {
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#f0f0f0',
    minWidth: 100,
    alignItems: 'center',
  },
  testamentButtonText: {
    fontSize: 16,
    color: '#333',
  },
  bookScroll: {
    flexDirection: 'row',
  },
  bookScrollContent: {
    paddingRight: 20,
  },
  bookButton: {
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#f0f0f0',
    marginRight: 10,
    minWidth: 80,
    alignItems: 'center',
  },
  bookButtonText: {
    fontSize: 16,
    color: '#333',
  },
  chapterScroll: {
    flexDirection: 'row',
  },
  chapterButton: {
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#f0f0f0',
    marginRight: 10,
    minWidth: 50,
    alignItems: 'center',
  },
  chapterButtonText: {
    fontSize: 16,
    color: '#333',
  },
  selectedButton: {
    backgroundColor: '#007AFF',
  },
  selectedButtonText: {
    color: '#fff',
  },
  confirmButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginTop: 20,
  },
  confirmButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
}); 