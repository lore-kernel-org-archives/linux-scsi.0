From: =?iso-8859-1?q?Sulamita=20Garcia?= <sulagarcia@yahoo.com.br>
Subject: Re: Kernel panic - Ththththaats all folks
Date: Fri, 5 Sep 2003 11:52:35 -0300 (ART)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030905145235.19968.qmail@web21109.mail.yahoo.com>
References: <1062772665.32436.4.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21109.mail.yahoo.com ([216.136.227.111]:48030 "HELO
	web21109.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262723AbTIEOwp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 10:52:45 -0400
In-Reply-To: <1062772665.32436.4.camel@dhcp23.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 --- Alan Cox <alan@lxorguk.ukuu.org.uk> escreveu: >
On Gwe, 2003-09-05 at 15:01, Sulamita Garcia wrote:
> > instalation default, and rebuild module from
> source
> > because kernel module didn't work. Now I have a
> Raid 0
> > by hardware
>=20
> Problems with HPT's partially binary module should
> be directed to
> highpoint not to this list. Looking at the trace its
> almost certainly
> a bug in their alternative software raid driver.

But the module who did the panic was scsi(the panic
error is in scsi_merge). I just want know why.

>=20
> Alan=20

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
