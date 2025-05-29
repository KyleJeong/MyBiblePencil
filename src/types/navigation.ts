import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { BibleVerse } from '../services/bibleApi';

export type RootStackParamList = {
  Main: undefined;
  BibleSelect: undefined;
  Copy: {
    verses: BibleVerse[];
    book: string;
    chapter: number;
    translation: string;
  };
  Write: {
    verses: BibleVerse[];
    book: string;
    chapter: number;
    translation: string;
  };
};

export type MainTabParamList = {
  Home: undefined;
  Saved: undefined;
  Settings: undefined;
};

export type RootStackScreenProps<T extends keyof RootStackParamList> = NativeStackScreenProps<
  RootStackParamList,
  T
>;

export type MainTabScreenProps<T extends keyof MainTabParamList> = BottomTabScreenProps<
  MainTabParamList,
  T
>; 