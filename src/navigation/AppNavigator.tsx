import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { RootStackParamList, MainTabParamList } from '../types/navigation';

// Screens
import HomeScreen from '../screens/HomeScreen';
import BibleSelectScreen from '../screens/BibleSelectScreen';
import CopyScreen from '../screens/CopyScreen';
// TODO: Import other screens (Saved, Settings, Write)

// Placeholder components for screens that are not yet implemented
const SavedScreenPlaceholder = () => null; // Replace with actual SavedScreen
const SettingsScreenPlaceholder = () => null; // Replace with actual SettingsScreen

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<MainTabParamList>();

function MainTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Saved" component={SavedScreenPlaceholder} /> 
      <Tab.Screen name="Settings" component={SettingsScreenPlaceholder} /> 
    </Tab.Navigator>
  );
}

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Main" screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Main" component={MainTabs} />
        <Stack.Screen name="BibleSelect" component={BibleSelectScreen} />
        <Stack.Screen name="Copy" component={CopyScreen} />
        {/* TODO: Add Write screen */}
      </Stack.Navigator>
    </NavigationContainer>
  );
} 