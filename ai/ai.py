from AIchess import *
import chess

class AI:
    def __init__(self):
        self.board = ''
        self.ai_chess = None

    def load_board(self, filename):
        file = open(filename, "r")
        self.board = file.read()
        file.close()

    def create_ai_board(self):
        assert(len(self.board) > 0)

        self.ai_chess = AIChess()
        self.ai_chess.board = chess.Board(self.board)

    def make_a_move(self):
        assert(self.ai_chess != None)

        move_arr = self.ai_chess.chessAIMove()

        if len(move_arr) <= 0:
            raise("Erro! Nenhum movimento válido.")

        for move in move_arr:
            if len(move) == 4:
                self.save_move(move)
                print(self.ai_chess.board)
                print("="*15)
                self.ai_chess.makeChessMove(move)
                print(self.ai_chess.board)
                break

    def save_move(self, move):
        assert(len(move) == 4)
        print(f"move: {move}")
        BASE_CHAR = ord('a')
        file = open("chess.out", "w")
        char_list = list(move)
        char_list[0] = str(ord(char_list[0]) - BASE_CHAR + 1)
        char_list[1] = str(9 - int(char_list[1]))
        char_list[2] = str(ord(char_list[2]) - BASE_CHAR + 1)
        char_list[3] = str(9 - int(char_list[3]))
        file.write(''.join(char_list))
        file.close()


board_ai = AI()
board_ai.load_board('board.in')
board_ai.create_ai_board()
board_ai.make_a_move()
