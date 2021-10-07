# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: slathouw <slathouw@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/10/06 14:26:03 by slathouw          #+#    #+#              #
#    Updated: 2021/10/07 10:39:13 by slathouw         ###   ########.fr        #
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
	cp ft_printf/libftprintf.a .
	${CC} ${CFLAGS} -I ${INCLUDES} ${OBJDIR}/server.o libftprintf.a -o server
	${CC} ${CFLAGS} -I ${INCLUDES} ${OBJDIR}/client.o libftprintf.a -o client

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p obj
	${CC} ${CFLAGS} -I ${INCLUDES} -c $< -o $@

bonus :	$(BONUSOBJS)
	make -C $(LIBFT)
	cp ft_printf/libftprintf.a .
	${CC} ${CFLAGS} -I ${INCLUDES} ${OBJDIR}/server_bonus.o libftprintf.a  -o server
	${CC} ${CFLAGS} -I ${INCLUDES} ${OBJDIR}/client_bonus.o libftprintf.a  -o client

$(OBJDIR)/%.o: $(BONUSSRCDIR)/%.c
	mkdir -p obj
	${CC} ${CFLAGS} -I ${INCLUDES} -c $< -o $@

clean:
	rm -f $(OBJS)
	rm -f $(BONUSOBJS)
	rm -rf $(OBJDIR)
	make clean -C $(LIBFT)

fclean: clean
	rm -f server client libftprintf.a
	make fclean -C $(LIBFT)

re :		fclean all

.PHONY: all clean fclean re bonus
