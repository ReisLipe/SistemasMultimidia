import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, StatusBar } from 'react-native';
import { Ionicons, FontAwesome, MaterialIcons, Feather } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';

const Home: React.FC = () => {
  const navigation = useNavigation<any>(); 

  return (
    <View style={styles.container}>
      <StatusBar barStyle="dark-content" />

      <View style={styles.header}>
        <View style={styles.logoBox}>
          <Ionicons name="school" size={32} color="white" />
        </View>
        <Text style={styles.appName}>APP DE BOLSAS</Text>
      </View>

      <Text style={styles.subtitle}>
        Descubra{'\n'}Oportunidades{'\n'}de Bolsas{'\n'}Universitárias
      </Text>

      <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('BolsasDisponiveis')}>
        <MaterialIcons name="grid-view" size={24} color="white" />
        <Text style={styles.buttonText}>Ver Bolsas</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('Ods4')}>
        <Feather name="check-circle" size={24} color="white" />
        <Text style={styles.buttonText}>ODS4</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.button}>
        <FontAwesome name="info-circle" size={24} color="white" />
        <Text style={styles.buttonText}>App Info</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.button}>
        <FontAwesome name="github" size={24} color="white" />
        <Text style={styles.buttonText}>Github</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f9f9f9', paddingHorizontal: 20, paddingTop: 60 },
  header: { flexDirection: 'row', alignItems: 'center', marginBottom: 30 },
  logoBox: { backgroundColor: '#8A2BE2', padding: 10, borderRadius: 10, marginRight: 10 },
  appName: { fontSize: 38, fontWeight: 'bold' },
  subtitle: { fontSize: 42, fontWeight: 'bold', lineHeight: 50, marginBottom: 60, marginTop: 30, textAlign: 'center'},
  button: {
    backgroundColor: '#8A2BE2',
    paddingVertical: 15,
    paddingHorizontal: 20,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 15,
  },
  buttonText: { color: 'white', fontSize: 25, marginLeft: 10 },
});

export default Home;