#include <array>
#include <iostream>
#include <numeric>
#include <vector>

using namespace std;

int main() {
  vector<int> ns;
  vector<pair<bool, array<int, 25>>> cards;

  do {
    int n;
    cin >> n;
    ns.push_back(n);
  } while (cin.get() != '\n');

  while (true) {
    array<int, 25> card;
    for (int i = 0; i < 25; i++) {
      int n;
      cin >> n;
      if (cin.eof())
        break;
      card[i] = n;
    }
    if (cin.eof())
      break;
    cards.push_back(make_pair(false, card));
  };

  int winner = 1;
  for (auto n : ns) {
    for (auto &p : cards) {
      if (p.first)
        continue;
      auto &card = p.second;
      for (auto &c : card) {
        if (c == n) {
          c = 0;
        }
      }
      for (int i = 0; i < 5; i++) {
        bool bingo = true;
        for (int j = 0; j < 5; j++) {
          if (card[j * 5 + i] != 0) {
            bingo = false;
          }
        }
        if (bingo) {
          cout << "Winner " << winner++ << ": "
               << n * accumulate(card.begin(), card.end(), 0) << endl;
          p.first = true;
          break;
        }
      }
      if (p.first)
        continue;
      for (int j = 0; j < 5; j++) {
        bool bingo = true;
        for (int i = 0; i < 5; i++) {
          if (card[j * 5 + i] != 0) {
            bingo = false;
          }
        }
        if (bingo) {
          cout << "Winner " << winner++ << ": "
               << n * accumulate(card.begin(), card.end(), 0) << endl;
          p.first = true;
        }
      }
    }
  }

  return 0;
}