import axios from 'axios';

const API_BASE_URL = 'https://bible-api.com';

export type BibleVerse = {
  verse: number;
  text: string;
};

export type BibleChapter = {
  chapter: number;
  verses: BibleVerse[];
};

// Map translation IDs to bible-api.com format
const translationMap: { [key: string]: string } = {
  'kr': 'krv',    // Korean Revised Version
  'en': 'kjv',    // King James Version
  'niv': 'niv',   // New International Version (Check if supported by API)
  'krv': 'krv',   // Korean Revised Version (alternative ID)
  // Add more translations as needed
};

// Map book IDs to common names used by bible-api.com User Input API
const bookMap: { [key: string]: string } = {
  'gen': 'Genesis',
  'exo': 'Exodus',
  'lev': 'Leviticus',
  'num': 'Numbers',
  'deu': 'Deuteronomy',
  'jos': 'Joshua',
  'jdg': 'Judges',
  'rut': 'Ruth',
  '1sa': '1 Samuel',
  '2sa': '2 Samuel',
  '1ki': '1 Kings',
  '2ki': '2 Kings',
  '1ch': '1 Chronicles',
  '2ch': '2 Chronicles',
  'ezr': 'Ezra',
  'neh': 'Nehemiah',
  'est': 'Esther',
  'job': 'Job',
  'psa': 'Psalms',
  'pro': 'Proverbs',
  'ecc': 'Ecclesiastes',
  'sng': 'Song of Solomon',
  'isa': 'Isaiah',
  'jer': 'Jeremiah',
  'lam': 'Lamentations',
  'ezk': 'Ezekiel',
  'dan': 'Daniel',
  'hos': 'Hosea',
  'jol': 'Joel',
  'amo': 'Amos',
  'oba': 'Obadiah',
  'jon': 'Jonah',
  'mic': 'Micah',
  'nam': 'Nahum',
  'hab': 'Habakkuk',
  'zep': 'Zephaniah',
  'hag': 'Haggai',
  'zec': 'Zechariah',
  'mal': 'Malachi',
  'mat': 'Matthew',
  'mrk': 'Mark',
  'luk': 'Luke',
  'jhn': 'John',
  'act': 'Acts',
  'rom': 'Romans',
  '1co': '1 Corinthians',
  '2co': '2 Corinthians',
  'gal': 'Galatians',
  'eph': 'Ephesians',
  'php': 'Philippians',
  'col': 'Colossians',
  '1th': '1 Thessalonians',
  '2th': '2 Thessalonians',
  '1ti': '1 Timothy',
  '2ti': '2 Timothy',
  'tit': 'Titus',
  'phm': 'Philemon',
  'heb': 'Hebrews',
  'jas': 'James',
  '1pe': '1 Peter',
  '2pe': '2 Peter',
  '1jn': '1 John',
  '2jn': '2 John',
  '3jn': '3 John',
  'jud': 'Jude',
  'rev': 'Revelation'
};

export async function getBibleChapter(
  translationId: string,
  bookId: string,
  chapter: number
): Promise<BibleChapter> {
  try {
    const translation = translationMap[translationId] || 'kjv';
    const book = bookMap[bookId.toLowerCase()] || bookId; // Use common book name
    // Using '%20' for space and '?translation' query parameter
    const url = `${API_BASE_URL}/${book}%20${chapter}?translation=${translation}`;
    console.log('Fetching chapter from URL:', url);
    const response = await axios.get(
      url
    );

    const verses = response.data.verses.map((verse: any) => ({
      verse: parseInt(verse.verse),
      text: verse.text,
    }));

    return {
      chapter,
      verses,
    };
  } catch (error) {
    console.error('Error fetching Bible chapter:', error);
    throw error;
  }
}

export async function getBibleVerses(
  translationId: string,
  bookId: string,
  chapter: number,
  startVerse: number,
  endVerse: number
): Promise<BibleVerse[]> {
  try {
    const translation = translationMap[translationId] || 'kjv';
    const book = bookMap[bookId.toLowerCase()] || bookId; // Use common book name
    // Using '%20' for space and '?translation' query parameter
    const url = `${API_BASE_URL}/${book}%20${chapter}:${startVerse}-${endVerse}?translation=${translation}`;
    console.log('Fetching verses from URL:', url);
    const response = await axios.get(
      url
    );

    return response.data.verses.map((verse: any) => ({
      verse: parseInt(verse.verse),
      text: verse.text,
    }));
  } catch (error) {
    console.error('Error fetching Bible verses:', error);
    throw error;
  }
}