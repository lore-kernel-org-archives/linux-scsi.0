From: =?iso-8859-1?q?Sulamita=20Garcia?= <sulagarcia@yahoo.com.br>
Subject: Kernel panic - Ththththaats all folks
Date: Fri, 5 Sep 2003 11:01:00 -0300 (ART)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030905140100.53464.qmail@web21106.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21106.mail.yahoo.com ([216.136.227.108]:7304 "HELO
	web21106.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262665AbTIEOBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 10:01:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I have a RocketRAID 404 (HPT374) controller adapter on
a RedHat 9.0 box. I compiled a new fresh kernel
2.4.22, because errors I get with 2.4.20 from
instalation default, and rebuild module from source
because kernel module didn't work. Now I have a Raid 0
by hardware, which is a 800Gb partition. I formated
this as ext3, and for while, was good.=20
But I doing this for a high availabity cluster, with
drbd (mirroring). And I can't sync machines, I get
this kernel panic:

Incorrect number of segments after building list
nr_segments is 10
counted segments is 1
=46lags 0 0
Kernel Panic: Ththththaats all folks. To dangerous to
continue
In interrupt handler - not syncing.

I found this message in scsi_merge, and I don't know
that did it mean. It's kernel problem, scsi problem,
chipset problem, or what?=20

Thanks

Sulamita Garcia


_______________________________________________________________________
Desafio AntiZona: participe do jogo de perguntas e respostas que vai
dar um Renault Clio, computadores, c=E2meras digitais, videogames e mui=
to
mais! www.cade.com.br/antizona
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
