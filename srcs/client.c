/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: slathouw <slathouw@student.s19.be>         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/10/06 11:28:34 by slathouw          #+#    #+#             */
/*   Updated: 2021/10/08 11:03:12 by slathouw         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/minitalk.h"

void	send_temination(pid_t server_pid)
{
	int	i;

	i = 8;
	while (i--)
	{
		usleep(50);
		kill(server_pid, SIGUSR2);
	}
	exit(0);
}

void	send_bit(char *s, pid_t pid)
{
	static int				i = 8;
	static unsigned char	curr_char;
	static char				*str;
	static pid_t			server_pid;

	if (s)
	{
		str = s;
		server_pid = pid;
		curr_char = *str;
	}
	if (!i)
	{
		i = 8;
		curr_char = *(++str);
		if (!curr_char)
			send_temination(server_pid);
	}
	if (curr_char && curr_char >> --i & 1)
		kill(server_pid, SIGUSR1);
	else if (curr_char)
		kill(server_pid, SIGUSR2);
}

void	sig_handler(int sig, siginfo_t *siginfo, void *uap)
{
	static int	recv_bytes = 0;

	(void)siginfo, (void)uap;
	if (sig == SIGUSR1)
		ft_printf("\rBytes confirmed\t: %i", ++recv_bytes);
	send_bit(0, 0);
}

int	main(int argc, char **argv)
{
	struct sigaction	sig_event;

	if (argc != 3 || !(100 <= ft_atoi(argv[1]) && ft_atoi(argv[1]) <= 99998))
	{
		ft_putstr_fd("Use : ./client [Server PID] [Message]", 1);
		return (1);
	}
	if (!ft_strlen(argv[2]))
		exit(0);
	sig_event.sa_flags = SA_SIGINFO;
	sig_event.sa_sigaction = sig_handler;
	sigaction(SIGUSR1, &sig_event, 0);
	sigaction(SIGUSR2, &sig_event, 0);
	ft_printf("Bytes sent\t: %i\n", ft_strlen(argv[2]));
	send_bit(argv[2], ft_atoi(argv[1]));
	while (1)
		pause();
	return (0);
}
