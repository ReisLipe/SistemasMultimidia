import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import Home from './Home';
import BolsasDisponiveis from './BolsasDisponiveis';
import Ods4 from './Ods4';

import * as NavigationBar from 'expo-navigation-bar';
import { useEffect } from 'react';

export type RootStackParamList = {
  Home: undefined;
  BolsasDisponiveis: undefined;
  Ods4: undefined;
};

useEffect(() => {
  NavigationBar.setVisibilityAsync("hidden");
  NavigationBar.setBehaviorAsync("overlay-swipe");
}, []);

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function HomeScreen() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={Home} options={{ title: 'App de Bolsas' }} />
        <Stack.Screen name="BolsasDisponiveis" component={BolsasDisponiveis} options={{ title: 'BOLSAS DISPONÍVEIS' }} />
        <Stack.Screen name="Ods4" component={Ods4} options={{ title: 'ODS4' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
