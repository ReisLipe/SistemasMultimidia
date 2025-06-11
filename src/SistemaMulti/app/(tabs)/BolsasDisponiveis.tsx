import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Modal
} from 'react-native';
// Importa ícones das bibliotecas Ionicons e Feather
import { Ionicons, Feather } from '@expo/vector-icons';
// Importa o módulo Linking para abrir URLs externas
import { Linking } from 'react-native';

import { useNavigation } from '@react-navigation/native';

// Define o tipo BolsaModel que representa a estrutura dos dados das bolsas
type BolsaModel = {
  id: number;
  title: string;
  descricao: string;
  inscricoes: string;
  link: string;
  situacao: string;
};

// Define os tipos para filtro de situação e ordenação de datas
type SituacaoFilter = 'todas' | 'aberta' | 'fechada';
type DateSort = 'none' | 'asc' | 'desc';

// Função que retorna a URL base da API para buscar as bolsas
const getBaseUrl = () => {
  const localIP = '127.0.0.1';
  return `http://${localIP}:8080/api/scrape`;
};

// Componente principal que exibe a lista de bolsas disponíveis
const BolsasDisponiveis: React.FC<{}> = () => {
  const navigation = useNavigation<any>();

  // Estado inicial com alguns dados de exemplo (mock)
  const [bolsas, setBolsas] = useState<BolsaModel[]>([]);
  // Estado para controlar o carregamento dos dados
  const [loading, setLoading] = useState(false);
  // Estado para armazenar mensagem de erro, caso ocorra
  const [error, setError] = useState<string | null>(null);

  // Estado para controlar o texto digitado na busca
  const [searchText, setSearchText] = useState<string>('');
  // Estado para armazenar as bolsas filtradas conforme busca/filtros
  const [filteredBolsas, setFilteredBolsas] = useState<BolsaModel[]>([]);

  // Estados para filtros principais: situação e ordenação de data
  const [situacaoFilter, setSituacaoFilter] = useState<SituacaoFilter>('todas');
  const [dateSort, setDateSort] = useState<DateSort>('none');

  // Estado para controlar a visibilidade do modal de filtros
  const [modalVisible, setModalVisible] = useState(false);
  // Estados temporários para filtros usados dentro do modal antes de aplicar
  const [tempSituacaoFilter, setTempSituacaoFilter] = useState<SituacaoFilter>(situacaoFilter);
  const [tempDateSort, setTempDateSort] = useState<DateSort>(dateSort);

  // Função para abrir o modal e sincronizar os filtros temporários com os atuais
  const openModal = () => {
    setTempSituacaoFilter(situacaoFilter);
    setTempDateSort(dateSort);
    setModalVisible(true);
  };

  // Função para aplicar os filtros selecionados no modal
  const applyModalFilters = () => {
    setSituacaoFilter(tempSituacaoFilter);
    setDateSort(tempDateSort);
    setModalVisible(false);
  };

  // Função para cancelar o modal sem aplicar alterações
  const cancelModal = () => {
    setModalVisible(false);
  };

  const [selectedBolsa, setSelectedBolsa] = useState<BolsaModel | null>(null);
  const [modalDetalhesVisible, setModalDetalhesVisible] = useState(false);


  // Atualiza a lista filtrada sempre que o array original mudar
  useEffect(() => {
    setFilteredBolsas(bolsas);
  }, [bolsas]);

  // useEffect que faz a requisição para buscar as bolsas da API quando o componente é montado
  useEffect(() => {
    const fetchBolsas = async () => {
      setLoading(true);  // ativa indicador de carregamento
      setError(null);    // limpa erros anteriores
      try {
        // faz a requisição para a API
        const response = await fetch(getBaseUrl());
        if (!response.ok) throw new Error(`Erro HTTP ${response.status}`);
        // extrai dados JSON da resposta
        const data = await response.json();
        // atualiza o estado com as bolsas recebidas (ou vazio se não vier)
        setBolsas(data.items || []);
      } catch (err: any) {
        // caso dê erro, salva mensagem de erro no estado
        setError('Erro ao buscar bolsas: ' + err.message);
      } finally {
        // desliga indicador de carregamento
        setLoading(false);
      }
    };

    fetchBolsas();
  }, []);

  // Função para converter string de data dd/mm/yyyy para objeto Date
  const parseDate = (str: string): Date | null => {
    const parts = str.split('/');
    if (parts.length !== 3) return null;
    const [day, month, year] = parts.map(Number);
    return new Date(year, month - 1, day);
  };

  // Função que aplica os filtros de situação, busca e ordenação sobre o array de bolsas
  const applyFilters = () => {
    // Primeiro filtra pela situação e busca
    let filtered = bolsas.filter((bolsa) => {
      const situacaoLower = bolsa.situacao.toLowerCase();
      // Filtra pela situação selecionada
      if (situacaoFilter === 'aberta' && !situacaoLower.includes('aberta')) return false;
      if (situacaoFilter === 'fechada' && !situacaoLower.includes('fechada')) return false;

      // Filtra pelo texto da busca (título ou descrição)
      if (searchText) {
        const text = searchText.toLowerCase();
        if (
          !bolsa.title.toLowerCase().includes(text) &&
          !bolsa.descricao.toLowerCase().includes(text)
        ) {
          return false;
        }
      }

      return true;
    });

    // Ordena por data se necessário
    if (dateSort !== 'none') {
      filtered = filtered.sort((a, b) => {
        // Pega a data inicial do período de inscrição
        const dateA = parseDate(a.inscricoes.split(' ')[0]) || new Date(0);
        const dateB = parseDate(b.inscricoes.split(' ')[0]) || new Date(0);
        return dateSort === 'asc'
          ? dateA.getTime() - dateB.getTime()
          : dateB.getTime() - dateA.getTime();
      });
    }

    // Atualiza o estado das bolsas filtradas
    setFilteredBolsas(filtered);
  };

  // Sempre que bolsas, texto da busca ou filtros mudarem, reaplica os filtros
  useEffect(() => {
    applyFilters();
  }, [bolsas, searchText, situacaoFilter, dateSort]);

  // Função para atualizar o texto da busca e filtrar imediatamente
  const handleSearch = (text: string) => {
    setSearchText(text);

    // Aplica filtro local na busca para resposta rápida
    const filtered = bolsas.filter((bolsa) =>
      bolsa.title.toLowerCase().includes(text.toLowerCase()) ||
      bolsa.descricao.toLowerCase().includes(text.toLowerCase())
    );

    setFilteredBolsas(filtered);
  };

  const openDetalhesModal = (bolsa: BolsaModel) => {
  setSelectedBolsa(bolsa);
  setModalDetalhesVisible(true);
};

  const closeDetalhesModal = () => {
    setSelectedBolsa(null);
    setModalDetalhesVisible(false);
  };


  return (
    <View style={styles.container}>
      {/* Topo da tela com botão voltar e campo de busca */}
      <View style={styles.topContainer}>
        <TouchableOpacity onPress={() => navigation?.goBack()} style={{ padding: 8 }}>
          {/* Ícone de voltar */}
          <Ionicons name="arrow-back" size={24} color="#8A2BE2" onPress={() => navigation.navigate('Home')} />
        </TouchableOpacity>
        <View style={styles.searchContainer}>
          {/* Ícone da lupa */}
          <Ionicons name="search" size={20} color="#999" />
          {/* Campo de texto para busca */}
          <TextInput
            placeholder="Search"
            style={styles.searchInput}
            value={searchText}
            onChangeText={setSearchText}
            autoCorrect={false}
            autoCapitalize="none"
          />
        </View>
      </View>

      {/* Botão para abrir o modal de filtros */}
      <View style={{ alignItems: 'flex-end', marginBottom: 10 }}>
        <TouchableOpacity style={styles.filterButton} onPress={openModal}>
          <Feather name="filter" size={16} color="#555" />
          <Text style={styles.filterText}>Filter</Text>
        </TouchableOpacity>
      </View>

      {/* Mostra indicador de carregamento durante busca */}
      {loading && <ActivityIndicator size="large" color="#8A2BE2" />}
      {/* Mostra mensagem de erro caso tenha */}
      {error && <Text style={{ color: 'red', marginBottom: 10 }}>{error}</Text>}

      {/* Lista de bolsas filtradas dentro de um ScrollView */}
      <ScrollView>
        {filteredBolsas.map((bolsa) => (
          <View key={bolsa.id} style={styles.card}>
            <Text style={styles.title}>{bolsa.title}</Text>
            <Text>Inscrições: {bolsa.inscricoes}</Text>
            <Text>{bolsa.situacao}</Text>
            {/* Botão para abrir o link da bolsa no navegador */}
            <View>
              {bolsa.link && (
                <TouchableOpacity style={styles.siteButton} onPress={() => Linking.openURL(bolsa.link)}>
                  <Text style={styles.siteButtonText}>Acessar Site</Text>
                </TouchableOpacity>
              )}
              <TouchableOpacity
                style={styles.siteButton}
                onPress={() => openDetalhesModal(bolsa)}
              >
                <Text style={styles.siteButtonText}>Ver Mais</Text>
              </TouchableOpacity>
            </View>
          </View>
        ))}
      </ScrollView>

      <Modal
        visible={modalDetalhesVisible}
        animationType="fade"
        transparent={true}
        onRequestClose={closeDetalhesModal}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Detalhes da Bolsa</Text>
            {selectedBolsa && (
              <>
                <Text style={{ fontWeight: 'bold' }}>{selectedBolsa.title}</Text>
                <Text>{selectedBolsa.descricao}</Text>
                <Text>Inscrições: {selectedBolsa.inscricoes}</Text>
                <Text>{selectedBolsa.situacao}</Text>
                <TouchableOpacity
                  style={[styles.siteButton, { marginTop: 10 }]}
                  onPress={() => Linking.openURL(selectedBolsa.link)}
                >
                  <Text style={styles.siteButtonText}>Acessar Site</Text>
                </TouchableOpacity>
              </>
            )}
            <TouchableOpacity
              onPress={closeDetalhesModal}
              style={{ marginTop: 20, alignSelf: 'flex-end' }}
            >
              <Text style={{ color: '#8A2BE2', fontWeight: '600' }}>Fechar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>


      {/* Modal que contém os filtros de situação e ordenação */}
      <Modal
        visible={modalVisible}
        animationType="slide"
        transparent={true}
        onRequestClose={cancelModal}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Filtros</Text>

            {/* Filtro por situação */}
            <View style={styles.filterGroup}>
              <Text style={styles.filterLabel}>Situação:</Text>
              {['todas', 'aberta', 'fechada'].map((status) => (
                <TouchableOpacity
                  key={status}
                  style={[
                    styles.filterOption,
                    tempSituacaoFilter === status && styles.filterOptionSelected,
                  ]}
                  onPress={() => setTempSituacaoFilter(status as SituacaoFilter)}
                >
                  <Text
                    style={
                      tempSituacaoFilter === status
                        ? styles.filterOptionTextSelected
                        : styles.filterOptionText
                    }
                  >
                    {status.charAt(0).toUpperCase() + status.slice(1)}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            {/* Filtro por ordenação de data */}
            <View style={styles.filterGroup}>
              <Text style={styles.filterLabel}>Ordenar por data:</Text>
              {[
                { label: 'Nenhum', value: 'none' },
                { label: 'Mais recentes', value: 'desc' },
                { label: 'Mais antigos', value: 'asc' },
              ].map(({ label, value }) => (
                <TouchableOpacity
                  key={value}
                  style={[
                    styles.filterOption,
                    tempDateSort === value && styles.filterOptionSelected,
                  ]}
                  onPress={() => setTempDateSort(value as DateSort)}
                >
                  <Text
                    style={
                      tempDateSort === value
                        ? styles.filterOptionTextSelected
                        : styles.filterOptionText
                    }
                  >
                    {label}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            {/* Botões para cancelar ou aplicar filtros */}
            <View style={styles.modalButtons}>
              <TouchableOpacity style={styles.modalButtonCancel} onPress={cancelModal}>
                <Text style={{ color: '#8A2BE2', fontWeight: '600' }}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.modalButtonApply} onPress={applyModalFilters}>
                <Text style={{ color: 'white', fontWeight: '600' }}>Aplicar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: '#f2f2f2' },
  topContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  searchContainer: {
    backgroundColor: '#eee',
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    borderRadius: 12,
    height: 40,
    flex: 1,
    marginLeft: 12,
  },
  searchInput: {
    flex: 1,
    marginLeft: 10,
    fontSize: 16,
  },
  filterButton: {
    backgroundColor: '#ddd',
    padding: 8,
    borderRadius: 10,
    alignItems: 'center',
    flexDirection: 'row',
  },
  filterText: {
    marginLeft: 6,
    fontWeight: '600',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: 14,
    padding: 16,
    marginBottom: 16,
  },
  title: {
    fontWeight: 'bold',
    fontSize: 18,
    marginBottom: 4,
  },
  description: {
    color: '#555',
    marginBottom: 12,
  },
  siteButton: {
    alignSelf: 'flex-end',
    backgroundColor: '#8A2BE2',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 20,
    marginTop: 7,
  },
  siteButtonText: {
    color: 'white',
    fontWeight: '600',
  },

  filterRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
    flexWrap: 'wrap',
  },
  filterGroup: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 6,
    flexWrap: 'wrap',
  },
  filterLabel: {
    fontWeight: '600',
    marginRight: 10,
    fontSize: 14,
    color: '#333',
  },
  filterOption: {
    paddingVertical: 4,
    paddingHorizontal: 10,
    backgroundColor: '#ddd',
    borderRadius: 12,
    marginRight: 8,
    marginBottom: 6,
  },
  filterOptionSelected: {
    backgroundColor: '#8A2BE2',
  },
  filterOptionText: {
    color: '#555',
    fontWeight: '500',
  },
  filterOptionTextSelected: {
    color: 'white',
    fontWeight: '700',
  },

  // Estilos do modal
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.3)',
    justifyContent: 'center',
    padding: 20,
  },
  modalContent: {
    backgroundColor: 'white',
    borderRadius: 16,
    padding: 20,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 15,
  },
  modalButtons: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    marginTop: 20,
  },
  modalButtonCancel: {
    marginRight: 20,
  },
  modalButtonApply: {
    backgroundColor: '#8A2BE2',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 20, 
  },

});

export default BolsasDisponiveis;
