<h1 align="center">
  <br>
  <img src="https://cdn-icons-png.flaticon.com/512/9320/9320664.png" alt="TaskMaster Logo" width="120">
  <br>
  TaskMaster
  <br>
</h1>

<h4 align="center">✅ Gerencie suas tarefas com foco e estilo.</h4>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0-6200EA?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Storage-Local-7C4DFF?style=for-the-badge&logo=database&logoColor=white" alt="Shared Prefs">
</p>

<p align="center">
  <a href="#sobre">Sobre</a> •
  <a href="#recursos">Recursos</a> •
  <a href="#layout">Layout</a> •
  <a href="#tecnologias">Tecnologias</a> •
  <a href="#instalação">Instalação</a>
</p>

---

## 🔖 Sobre

O **TaskMaster** é um aplicativo de produtividade focado na simplicidade e eficiência. Desenvolvido com uma interface moderna em **Dark Mode**, ele permite que o usuário organize seu dia a dia sem distrações.

O diferencial técnico deste projeto é a **persistência de dados local**, garantindo que suas tarefas estejam salvas mesmo se você fechar o aplicativo ou ficar sem internet.

---

## 📱 Layout

O design foi pensado para uso prolongado, utilizando um tema escuro com gradientes em tons de violeta e roxo para reduzir o cansaço visual.

| Tela Inicial (Lista) | Ação de Excluir | Adicionar Tarefa |
|:---:|:---:|:---:|
| <img width="747" height="848" alt="Image" src="https://github.com/user-attachments/assets/9ff3b326-066f-4a4e-bd70-8fdc3ab61897" /> | <img width="751" height="981" alt="Image" src="https://github.com/user-attachments/assets/257c8a57-bfcd-444d-9062-6bae96396a53" /> | <img width="752" height="850" alt="Image" src="https://github.com/user-attachments/assets/c36bc4a6-2c87-4665-a9be-c9fddb02fb60" />  |

---

## 🚀 Recursos Principais

- [x] **Gestão Completa:** Adicionar, editar e visualizar tarefas.
- [x] **Interatividade:** Arraste para o lado (*Dismissible*) para excluir uma tarefa.
- [x] **Checklist:** Marque tarefas como concluídas com um toque.
- [x] **Persistência de Dados:** Uso de `SharedPreferences` para salvar tudo no dispositivo.
- [x] **Interface Moderna:** Design responsivo com gradientes e feedback visual.

---

## 🛠 Tecnologias Utilizadas

- **[Flutter](https://flutter.dev/)** - UI Toolkit.
- **[Dart](https://dart.dev/)** - Linguagem.
- **[Shared Preferences](https://pub.dev/packages/shared_preferences)** - Banco de dados local key-value.
- **JSON Serialization** - Conversão de dados para armazenamento.

---

## 🏁 Como rodar o projeto

```bash
# 1. Clone o repositório
$ git clone [https://github.com/rafaoliveira11/TaskMaster_Flutter]

# 2. Entre na pasta
$ cd taskmaster

# 3. Instale as dependências (Principalmente o shared_preferences)
$ flutter pub get

# 4. Execute o app
$ flutter run