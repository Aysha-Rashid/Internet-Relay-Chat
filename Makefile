NAME = ircserv

SRC = main.cpp \
		Server/Server.cpp \
		Client/Client.cpp \
		Channel/Channel.cpp \
		Channel/Commands.cpp \
		Channel/nick.cpp \
		Channel/join.cpp \
		Channel/mode.cpp \
		Channel/topic.cpp \
		Utils.cpp
	 	 
OBJ = $(SRC:.cpp=.o)

CXX = c++

CXXFLAGS = -std=c++98 -Wall -Wextra -Werror

$(NAME): $(OBJ)
	$(CXX) $(CXXFLAGS) $(OBJ) -o $(NAME)

all: $(NAME)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all
