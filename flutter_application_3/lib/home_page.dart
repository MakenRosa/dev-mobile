import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int playerScore = 0;
  int computerScore = 0;
  String result = 'Jogue para ver o resultado!';
  String? computerChoice;
  String? computerChoiceImage;

  Map<String, String> options = {
    'Pedra': 'https://img2.gratispng.com/20180705/sfh/kisspng-rockpaperscissors-computer-icons-clip-art-paper-scissors-5b3e1287be5a43.5750598415307946317797.jpg',
    'Papel': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBYBdhVNF_v0VJvEtAzSK8dzLKr-_rQ0fwGg&usqp=CAU',
    'Tesoura': 'https://e7.pngegg.com/pngimages/588/310/png-clipart-hand-rock-paper-scissors-computer-icons-hand-angle-text-thumbnail.png',
  };

  void playGame(String playerChoice) {
    setState(() {
      computerChoice = options.keys.elementAt(Random().nextInt(options.length));
      computerChoiceImage = options[computerChoice];

      if (playerChoice == computerChoice) {
        result = 'Empate!';
      } else if ((playerChoice == 'Pedra' && computerChoice == 'Tesoura') ||
          (playerChoice == 'Papel' && computerChoice == 'Pedra') ||
          (playerChoice == 'Tesoura' && computerChoice == 'Papel')) {
        result = 'Você ganhou!';
        playerScore++;
      } else {
        result = 'Você perdeu!';
        computerScore++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sua jogada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options.entries.map((MapEntry entry) {
                return GestureDetector(
                  onTap: () => playGame(entry.key),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(entry.value),
                    radius: 30,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Jogada do computador',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            if (computerChoiceImage != null)
              CircleAvatar(
                backgroundImage: NetworkImage(computerChoiceImage!),
                radius: 30,
              ),
            SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Placar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Você',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        )),
                    Text('$playerScore',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        )),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    Text('PC',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        )),
                    Text('$computerScore',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
