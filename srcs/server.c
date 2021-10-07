/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: slathouw <slathouw@student.s19.be>         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/10/07 12:18:26 by slathouw          #+#    #+#             */
/*   Updated: 2021/10/07 12:18:29 by slathouw         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/minitalk.h"

void	sig_handler(int sig, siginfo_t *siginfo, void *unused)
{
	static unsigned char	curr_char = 0x00;
	static int				cnt = 0;
	static pid_t			client_pid = 0;

	(void)unused;
	if (!client_pid)
		client_pid = siginfo->si_pid;
	curr_char |= (sig == SIGUSR1);
	if (++cnt == 8)
	{
		cnt = 0;
		if (curr_char == 0x00)
		{
			client_pid = 0;
			return ;
		}
		ft_putchar_fd(curr_char, 1);
		curr_char = 0x00;
		kill(client_pid, SIGUSR1);
	}
	else
	{
		curr_char <<= 1;
		kill(client_pid, SIGUSR2);
	}
}

int	main(void)
{
	struct sigaction	sig_event;

	ft_putstr_fd("Server PID [", 1);
	ft_putnbr_fd(getpid(), 1);
	ft_putstr_fd("]\n", 1);
	sig_event.sa_flags = SA_SIGINFO;
	sig_event.sa_sigaction = sig_handler;
	sigaction(SIGUSR1, &sig_event, 0);
	sigaction(SIGUSR2, &sig_event, 0);
	while (1)
		pause();
	return (0);
}
