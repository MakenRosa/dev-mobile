
# Repositório de Estudos – ADS (Arquivado)

> Coleção de projetos e exercícios que desenvolvi durante a graduação em **Análise e Desenvolvimento de Sistemas**.  
> **Status:** arquivado / sem manutenção. Último commit: há mais de 2 anos.

Este repositório existe para documentar minha evolução prática com **Dart** e **Flutter** (incluindo Firebase, HTTP, navegação, estados, testes e consumo de APIs). Os códigos aqui foram feitos para **estudo** e **prototipagem** — não são produtos finais.

---

## Conteúdo (visão geral)

Cada subpasta é um projeto independente:

- **`dart/dart_application_1`** – App de linha de comando em Dart consumindo a API pública *JSONPlaceholder* (usuários e posts).
- **`flutter_application_1`** – App Flutter básico com navegação por rotas e alguns componentes customizados (circle/rectangle, cards de contato).
- **`flutter_application_2`** – CRUD simples de nomes em memória + navegação para uma segunda página passando dados.
- **`flutter_application_3`** – Jogo “Pedra, Papel e Tesoura” com placar e imagens remotas.
- **`flutter_application_4`** – Lista e busca de **contatos** consumindo uma API fake (JSON no GitHub), com *hover*, diálogo de detalhes e campo de busca.
- **`flutter_application_5`** – Teste de **Firebase Realtime Database** via **REST** (criar/editar/deletar/listar jogos) sem SDK do Firebase.
- **`mkn_bank`** – App Flutter com **Firebase Auth** + **Cloud Firestore** para controle financeiro pessoal (registro de despesas/receitas, categorias, filtros, visão geral e resumo com gráfico de pizza).
- **`mkn_offer`** – App Flutter com **Firebase Auth** e telas de **login/cadastro/recuperação** (UI básica e integração inicial com Firestore).
- **`prova`** – Telas de **login** e **clima** consumindo uma API pública brasileira de tempo (cidade, temperatura, mín/máx, descrição).

> Há arquivos de teste gerados pelo template do Flutter em algumas pastas (`test/widget_test.dart`) usados apenas como *smoke tests*.

---

## Como executar

> **Dica:** cada projeto tem seu próprio `pubspec.yaml`. Abra e rode **um por vez** a partir da pasta correspondente.

### Pré-requisitos
- **Flutter SDK** instalado e configurado (`flutter doctor`).
- **Dart SDK** compatível com cada projeto (ver `environment` no `pubspec.yaml`).
  - Há projetos com **Dart 2.19.x** e outros com **Dart 3.1.x**.
  - Recomendo usar **FVM (Flutter Version Management)** para alternar versões por projeto.

### Passo a passo (Flutter)
```bash
cd <pasta_do_projeto_flutter>
flutter pub get
flutter run
````

### Passo a passo (Dart CLI)

```bash
cd dart/dart_application_1
dart pub get
dart run
```

---

## Projetos com Firebase

Alguns projetos usam Firebase:

* **`mkn_bank`**: Firebase Auth + Cloud Firestore
* **`mkn_offer`**: Firebase Auth (+ Firestore inicial)
* **`flutter_application_5`**: Realtime Database via REST (sem SDK)

Os arquivos `firebase_options.dart` (gerados pelo **FlutterFire CLI**) estão versionados **apenas para estudo**.
Essas chaves **não são segredos**, mas **podem estar desativadas/obsoletas**.

### Para rodar com sua conta do Firebase

1. Crie um projeto no \[Firebase Console].
2. Execute:

   ```bash
   flutterfire configure
   ```
3. Substitua o `firebase_options.dart` gerado nos projetos que usam Firebase.
4. Caso use Realtime Database (ex.: `flutter_application_5`), ajuste as **regras** e a **URL** do DB no código.

> Se não quiser configurar o Firebase agora, foque nos projetos que só usam HTTP ou lógica local (`dart_application_1`, `flutter_application_1`–`4`, `prova` usando API pública).

---

## APIs públicas usadas (estudo)

* **JSONPlaceholder** – dados fake de usuários/posts (Dart CLI).
* **Fake Contacts API (JSON no GitHub)** – lista de contatos (Flutter 4).
* **Weather (contrateumdev.com.br)** – endpoint público para clima (Projeto `prova`).
* **Firebase Realtime Database REST** – leitura/escrita de dados (Flutter 5).

Esses serviços podem mudar ou ficar indisponíveis. Caso falhem, substitua por outro endpoint de teste ou ajuste a URL.

---

## Observações importantes

* **Versões mistas**: há projetos com *constraints* diferentes de Dart/Flutter. Use **FVM** para isolar versões por pasta, se necessário.
* **Dependências antigas**: por ser um repositório antigo, algumas libs podem estar desatualizadas. Use:

  ```bash
  flutter pub outdated
  flutter pub upgrade --major-versions
  ```

  (faça isso **projeto a projeto**).
* **Qualidade & segurança**: código acadêmico, sem hardening de segurança, sem cobertura de testes real e sem garantia de boas práticas de produção.
* **Uso educacional**: fique à vontade para ler, clonar e brincar; evite usar “como está” em produção.

---

## Estrutura (alto nível)

```
dart/
flutter_application_1/
flutter_application_2/
flutter_application_3/
flutter_application_4/
flutter_application_5/
mkn_bank/
mkn_offer/
prova/
```

Cada pasta contém `lib/`, `pubspec.yaml` e, quando aplicável, `test/` e `assets`.

---

## Autor

Maken da Rosa - Software Developer
Se algo te ajudou aqui, ⭐ no repositório é sempre bem-vindo :)

