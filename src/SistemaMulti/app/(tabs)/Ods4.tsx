import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

import { useNavigation } from '@react-navigation/native';

const Ods4: React.FC<{}> = () => {
  const navigation = useNavigation<any>();

  return (
    <ScrollView style={styles.container}>
      {/* Topo com botão de voltar */}
      <View style={styles.topContainer}>
        <TouchableOpacity onPress={() => navigation.navigate('Home')} style={{ padding: 8 }}>
          <Ionicons name="arrow-back" size={24} color="#8A2BE2" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>ODS 4 - Educação de Qualidade</Text>
      </View>
      
      <View style={styles.card}>
        <Text style={[styles.title, { marginTop: 20 }]}>Nosso Projeto</Text>
        <Text style={styles.text}>
          Nosso projeto tem como missão reunir e centralizar diversas oportunidades de bolsas de estudo em um único lugar, tornando mais fácil e acessível para estudantes de todas as regiões encontrarem e se candidatarem a essas chances de aprendizado. Ao facilitar o acesso a informações sobre bolsas, contribuímos para reduzir barreiras que muitos jovens enfrentam para continuar seus estudos, especialmente aqueles em situações de vulnerabilidade social.
        </Text>
        <Text style={styles.text}>
          Dessa forma, promovemos diretamente os princípios da ODS 4, que visa garantir uma educação inclusiva, equitativa e de qualidade para todos. Nosso sistema incentiva a participação ativa, ajuda a ampliar a diversidade de estudantes beneficiados e fortalece a formação educacional, preparando-os melhor para o mercado de trabalho e para a vida cidadã. Além disso, ao valorizar e divulgar essas oportunidades, colaboramos para o desenvolvimento de habilidades, a diminuição das desigualdades educacionais e o fortalecimento de comunidades mais justas e sustentáveis.
        </Text>
      

      
        <Text style={styles.title}>O que são ODS?</Text>
        <Text style={styles.text}>
          ODS são os Objetivos de Desenvolvimento Sustentável, um conjunto de metas globais da ONU para melhorar o mundo até 2030.
        </Text>

        <Text style={styles.title}>Qual é a ODS 4?</Text>
        <Text style={styles.text}>
          A ODS 4 busca garantir educação de qualidade para todos, promovendo acesso igualitário, inclusão, aprendizado relevante e formação de professores.
        </Text>

        <Text style={styles.title}>Objetivos da ODS 4:</Text>
        <View style={styles.list}>
          {[
            'Garantir que todas as pessoas concluam o ensino básico com aprendizado relevante.',
            'Oferecer acesso igualitário à educação infantil de qualidade.',
            'Ampliar o acesso ao ensino técnico, superior e universitário para todos.',
            'Promover o desenvolvimento de habilidades úteis para o trabalho e o empreendedorismo.',
            'Eliminar desigualdades de gênero e garantir acesso igualitário à educação.',
            'Garantir alfabetização e educação de qualidade para jovens e adultos.',
            'Promover a educação para o desenvolvimento sustentável, cidadania global e diversidade cultural.',
            'Criar ambientes escolares seguros, inclusivos e eficazes.',
            'Ampliar o número de bolsas de estudo para países em desenvolvimento.',
            'Valorizar e formar professores qualificados, especialmente em regiões mais vulneráveis.',
          ].map((item, index) => (
            <Text key={index} style={styles.listItem}>• {item}</Text>
          ))}
        </View>
</View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: '#f2f2f2' },
  topContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  headerTitle: {
    fontWeight: 'bold',
    fontSize: 18,
    marginLeft: 12,
    color: '#8A2BE2',
  },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16 },
  title: { fontWeight: 'bold', fontSize: 16, marginTop: 12, marginBottom: 4 },
  text: { fontSize: 14, color: '#333', marginBottom: 8 },
  list: { marginTop: 4 },
  listItem: { fontSize: 14, color: '#333', marginBottom: 6 },
});

export default Ods4;
