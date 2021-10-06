# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: slathouw <slathouw@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/10/06 14:26:03 by slathouw          #+#    #+#              #
#    Updated: 2021/10/06 14:30:39 by slathouw         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME 	= minitalk
LIBFT 	= ft_printf
INCLUDES= includes
CC		= gcc
CFLAGS	= -Wall -Wextra -Werror
OBJDIR	= obj


SOURCES	= server.c client.c
SRCDIR 	= srcs
SRCS 	= ${addprefix $(SRCDIR)/, $(SOURCES)}
OBJS	= ${addprefix $(OBJDIR)/, $(SOURCES:.c=.o)}


BONUSSOURCES = server_bonus.c client_bonus.c
BONUSSRCDIR = srcs_bonus
BONUSSRCS = ${addprefix $(BONUSSRCDIR)/, $(BONUSSOURCES)}
BONUSOBJS = ${addprefix $(OBJDIR)/, $(BONUSSOURCES:.c=.o)}


all : 		${NAME}

$(NAME) :	$(OBJS)
	make -C $(LIBFT)
	cp ft_printf/libftprintf.a ./$(NAME)
# add compilation rules for server and client	

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p obj
	${CC} ${CFLAGS} -I ${INCLUDES} -c $< -o $@

bonus :	$(BONUSOBJS)
	make -C $(LIBFT)
	cp libft/libft.a ./$(NAME)
	ar rc $(NAME) $(BONUSOBJS)
	ranlib $(NAME)

$(OBJDIR)/%.o: $(BONUSSRCDIR)/%.c
	mkdir -p obj
	${CC} ${CFLAGS} -I ${INCLUDES} -c $< -o $@

clean:
	rm -f $(OBJS)
	rm -f $(BONUSOBJS)
	rm -rf $(OBJDIR)
	make clean -C $(LIBFT)

fclean: clean
	rm -f $(NAME)
	make fclean -C $(LIBFT)

re :		fclean all

.PHONY: all clean fclean re bonus
