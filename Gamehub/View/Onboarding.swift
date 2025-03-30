//
//  Onboarding.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 30/03/25.
//

import SwiftUI
import AVKit

struct Onboarding: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var currentTab = 0
    @State private var loopingPlayer: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?
    @State private var animateBackground = false
    
    // Conteúdo do onboarding
    private let onboardingData = [
        OnboardingItem(title: "Bem-vindo ao GameHub", description: "Sua central de jogos e comunidade gamer", systemImage: "gamecontroller.fill", color: Color("WelcomePurpleColor")),
        OnboardingItem(title: "Descubra Novos Jogos", description: "Explore uma vasta biblioteca de jogos classificados por gênero", systemImage: "magnifyingglass", color: Color("DiscoverBlueColor")),
        OnboardingItem(title: "Conecte-se com Amigos", description: "Jogue com amigos e participe de comunidades", systemImage: "person.2.fill", color: Color("ConnectPinkColor"))
    ]
    
    var body: some View {
        ZStack {
            // Fundo escuro com gradiente animado
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color("BackgroudnColor")]),
                startPoint: animateBackground ? .topLeading : .bottomTrailing,
                endPoint: animateBackground ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(Animation.easeInOut(duration: 8.0).repeatForever(autoreverses: true), value: animateBackground)
            .onAppear { animateBackground = true }
            
            // Efeito de partículas (simulado com círculos)
            ParticleEffectView()
                .opacity(0.15)
                .ignoresSafeArea()
            
            // Vídeo de fundo em loop
            VideoPlayerWithLoop()
                .disabled(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(0.4)
                .ignoresSafeArea()
                .overlay(
                    // Overlay gradiente para melhorar contraste
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.3), Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            
            // Conteúdo do onboarding
            VStack(spacing: 0) {
                // Logo no topo
                Text("GAMEHUB")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color("AccentColor"), Color("SecondaryPurpleColor")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.top, 20)
                    .shadow(color: Color("AccentColor").opacity(0.5), radius: 10, x: 0, y: 0)
                
                // Conteúdo principal
                TabView(selection: $currentTab) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingView(item: onboardingData[index])
                            .tag(index)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentTab)
                .padding(.vertical)
                
                // Indicadores de página personalizados
                HStack(spacing: 12) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(currentTab == index ? onboardingData[index].color : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentTab == index ? 1.2 : 1.0)
                            .overlay(
                                currentTab == index ?
                                Circle()
                                    .stroke(onboardingData[index].color.opacity(0.5), lineWidth: 2)
                                    .scaleEffect(1.4)
                                : nil
                            )
                            .animation(.spring(), value: currentTab)
                    }
                }
                .padding(.bottom, 20)
                
                // Botões de navegação
                HStack {
                    // Botão Pular (visível apenas na primeira página)
                    if currentTab == 0 {
                        Button(action: {
                            withAnimation {
                                hasSeenOnboarding = true
                                dismiss()
                            }
                        }) {
                            Text("Pular")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer()
                    }
                    
                    // Botão Próximo/Começar
                    Button(action: {
                        withAnimation {
                            if currentTab == onboardingData.count - 1 {
                                hasSeenOnboarding = true
                                dismiss()
                            } else {
                                currentTab += 1
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentTab == onboardingData.count - 1 ? "Começar" : "Próximo")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Image(systemName: currentTab == onboardingData.count - 1 ? "play.fill" : "chevron.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 28)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    onboardingData[currentTab].color.opacity(0.8),
                                    onboardingData[currentTab].color
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: onboardingData[currentTab].color.opacity(0.5), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    if currentTab != 0 {
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}



// Efeito de partículas
struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .blur(radius: particle.size / 3)
            }
        }
        .onAppear {
            particles = (0..<50).map { _ in
                Particle(
                    position: CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    ),
                    size: CGFloat.random(in: 2...6),
                    opacity: Double.random(in: 0.05...0.2)
                )
            }
        }
    }
    
    struct Particle: Identifiable {
        let id = UUID()
        let position: CGPoint
        let size: CGFloat
        let opacity: Double
    }
}

// Estrutura para reproduzir vídeo em loop
struct VideoPlayerWithLoop: View {
    @State private var player: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?
    @State private var isVideoAvailable = false
    
    var body: some View {
        ZStack {
            if isVideoAvailable {
                VideoPlayer(player: player)
            } else {
                // Fallback quando o vídeo não está disponível
                Color.black
            }
        }
        .onAppear {
            if let videoURL = Bundle.main.url(forResource: "gameVideo", withExtension: "mov") {
                let playerItem = AVPlayerItem(url: videoURL)
                self.player = AVQueuePlayer(playerItem: playerItem)
                self.playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
                self.player?.play()
                self.isVideoAvailable = true
            } else {
                print("Vídeo 'gameVideo.mov' não encontrado no bundle")
                self.isVideoAvailable = false
            }
        }
        .onDisappear {
            player?.pause()
            playerLooper = nil
            player = nil
        }
    }
}

// Estrutura para os itens do onboarding
struct OnboardingItem {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

// View para cada item de onboarding
struct OnboardingView: View {
    let item: OnboardingItem
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Ícone com efeito de glow
            ZStack {
                // Efeito de glow externo
                Circle()
                    .fill(item.color.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .blur(radius: 20)
                
                // Gradiente de fundo
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        item.color.opacity(0.8),
                                        item.color.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                
                // Ícone
                Image(systemName: item.systemImage)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, item.color],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: item.color.opacity(0.8), radius: 8, x: 0, y: 0)
            }
            .offset(y: isAnimating ? 0 : 20)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring(response: 0.8).delay(0.1), value: isAnimating)
            
            // Título
            Text(item.title)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.8).delay(0.2), value: isAnimating)
            
            // Descrição
            Text(item.description)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 5)
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.8).delay(0.3), value: isAnimating)
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            ZStack {
                // Fundo com gradiente sutíl
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.6),
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Bordas com brilho
                RoundedRectangle(cornerRadius: 30)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                item.color.opacity(0.6),
                                item.color.opacity(0.2),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: item.color.opacity(0.15), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
        .offset(y: isAnimating ? 0 : 30)
        .opacity(isAnimating ? 1 : 0)
        .animation(.spring(response: 0.8), value: isAnimating)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    Onboarding()
}
