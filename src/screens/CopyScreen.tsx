import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, SafeAreaView } from 'react-native';
import { RootStackScreenProps } from '../types/navigation';
import { BibleVerse } from '../services/bibleApi';

export default function CopyScreen({ route, navigation }: RootStackScreenProps<'Copy'>) {
  const { verses, book, chapter, translation } = route.params;
  const [selectedVerses, setSelectedVerses] = useState<Set<number>>(
    new Set(verses.map((v: BibleVerse) => v.verse))
  );

  const toggleVerse = (verse: number) => {
    const newSelected = new Set(selectedVerses);
    if (newSelected.has(verse)) {
      newSelected.delete(verse);
    } else {
      newSelected.add(verse);
    }
    setSelectedVerses(newSelected);
  };

  const getSelectedVersesText = () => {
    const sortedVerses = Array.from(selectedVerses).sort((a, b) => a - b);
    if (sortedVerses.length === 0) return '';
    
    let result = '';
    let start = sortedVerses[0];
    let prev = start;

    for (let i = 1; i <= sortedVerses.length; i++) {
      if (i === sortedVerses.length || sortedVerses[i] !== prev + 1) {
        if (start === prev) {
          result += `${start}`;
        } else {
          result += `${start}-${prev}`;
        }
        if (i < sortedVerses.length) {
          result += ', ';
          start = sortedVerses[i];
        }
      }
      if (i < sortedVerses.length) {
        prev = sortedVerses[i];
      }
    }
    return result;
  };

  const handleSelect = () => {
    const selectedVersesList = verses
      .filter((v: BibleVerse) => selectedVerses.has(v.verse))
      .sort((a, b) => a.verse - b.verse);
    
    navigation.navigate('Write', {
      verses: selectedVersesList,
      book,
      chapter,
      translation,
    });
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
        <Text style={styles.title}>
          {book} {chapter}장
        </Text>
      </View>

      <View style={styles.selectedInfo}>
        <Text style={styles.selectedText}>
          선택된 구절: {getSelectedVersesText()}
        </Text>
      </View>

      <ScrollView style={styles.content}>
        {verses.map((verse: BibleVerse) => (
          <TouchableOpacity
            key={verse.verse}
            style={[
              styles.verseContainer,
              selectedVerses.has(verse.verse) && styles.selectedVerse
            ]}
            onPress={() => toggleVerse(verse.verse)}
          >
            <Text style={styles.verseNumber}>{verse.verse}</Text>
            <Text style={styles.verseText}>{verse.text}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity 
          style={[
            styles.selectButton,
            selectedVerses.size === 0 && styles.disabledButton
          ]}
          onPress={handleSelect}
          disabled={selectedVerses.size === 0}
        >
          <Text style={styles.selectButtonText}>필사하기</Text>
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
  selectedInfo: {
    padding: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  selectedText: {
    fontSize: 16,
    color: '#666',
  },
  content: {
    flex: 1,
    padding: 15,
  },
  verseContainer: {
    flexDirection: 'row',
    padding: 10,
    marginBottom: 10,
    borderRadius: 5,
    backgroundColor: '#f8f8f8',
  },
  selectedVerse: {
    backgroundColor: '#e3f2fd',
  },
  verseNumber: {
    fontSize: 16,
    fontWeight: 'bold',
    marginRight: 10,
    color: '#007AFF',
  },
  verseText: {
    flex: 1,
    fontSize: 16,
    lineHeight: 24,
  },
  footer: {
    padding: 15,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  selectButton: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  disabledButton: {
    backgroundColor: '#ccc',
  },
  selectButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
}); 