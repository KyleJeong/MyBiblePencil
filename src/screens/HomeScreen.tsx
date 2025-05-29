import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { MainTabScreenProps, RootStackScreenProps } from '../types/navigation';
import { useNavigation } from '@react-navigation/native';

export default function HomeScreen({ navigation }: MainTabScreenProps<'Home'>) {
  const rootNavigation = useNavigation<RootStackScreenProps<'BibleSelect'>['navigation']>();

  return (
    <View style={styles.container}>
      <Text style={styles.title}>MyBiblePencil</Text>
      <Text style={styles.subtitle}>손글씨로 느끼는 성경의 감동</Text>
      <TouchableOpacity
        style={styles.button}
        onPress={() => rootNavigation.navigate('BibleSelect')}
      >
        <Text style={styles.buttonText}>성경 선택</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 30,
  },
  button: {
    backgroundColor: '#007AFF',
    padding: 15,
    borderRadius: 10,
    marginTop: 20,
  },
  buttonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
}); 