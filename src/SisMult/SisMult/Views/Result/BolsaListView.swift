//
//  BolsaListView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//

import SwiftUI

struct BolsaListView: View {
    let bolsas: [BolsaModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(bolsas) { bolsa in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(bolsa.title)
                                .font(.headline)
                                .lineLimit(2)
                                .foregroundColor(.redEducation)
                            Spacer()
                        }
                        
                        Text(bolsa.descricao)
                            .font(.subheadline)
                            .foregroundColor(.grayText)
                        
                        HStack {
                            Link(destination: URL(string: bolsa.link)!) {
                                Text("Ver mais")
                                    .font(.caption)
                                    .foregroundColor(.redEducation)
                            }
                            .fixedSize()
                            
                            Spacer()
                            
                            Button {
                                testNotification(bolsa)
                                // notify(bolsa)
                            } label: {
                                Image(systemName: "bell.badge.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(.redEducation)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .padding()
                    .background(Color.redSoft)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
            }
            .padding()
        }
    }
    
    // MARK: Essa função é usada apenas para testes
    private func testNotification(_ bolsa: BolsaModel) {
        let testDate = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        requestNotificationPermission()
        scheduleNotification(at: testDate, withTitle: bolsa.title)
    }
    
    private func notify(_ bolsa: BolsaModel) {
        guard let date = extractDate(fromString: bolsa.inscricoes) else {
            print("Não foi possível obter data de inscrição para agendar a notificação.")
            return
        }
        requestNotificationPermission()
        scheduleNotification(at: date, withTitle: bolsa.title)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permissão concedida.")
            } else {
                print("Permissão negada.")
            }
        }
    }
    
    func scheduleNotification(at date: Date, withTitle title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Hoje é o dia de encerramento do seu período de inscrição!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            } else {
                print("Notificação agendada para: \(date)")
            }
        }
    }
    
    private func extractDate(fromString string: String) -> Date?{
        let regexPattern = #"(\d{2}/\d{2}/\d{4})\s*[àa]+\s*(\d{2}/\d{2}/\d{4})"#
        
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            print("Não foi possível compilar expressão regular.")
            return nil
        }
        
        let range = NSRange(string.startIndex..., in: string)
        
        guard let match = regex.firstMatch(in: string, options: [], range: range) else {
            print("Não foi possível encontrar uma match para a expressão regular.")
            return nil
        }
        guard let lastDateRange = Range(match.range(at: 2), in: string) else {
            print("Não foi possível encontrar a data de término.")
            return nil
        }
        
        let lastDateString = String(string[lastDateRange])
        return convertStringToDate(lastDateString)
    }
    
    private func convertStringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR") // ou en_US_POSIX para consistência
        
        guard let lastDate = dateFormatter.date(from: string) else {
            print("Não foi possível converter a data.")
            return nil
        }
        
        return lastDate
    }
}

