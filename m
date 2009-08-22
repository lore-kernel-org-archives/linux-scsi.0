From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sat, 22 Aug 2009 16:14:20 -0300
Message-ID: <20090822191420.GA5572@ime.usp.br>
References: <20090820220740.GA767@ime.usp.br>
 <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout8.uol.com.br ([200.221.4.199]:38582 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933308AbZHVTOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 15:14:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by socom8.uol.com.br (Postfix) with ESMTP id 4B2701C0000A4
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 16:14:24 -0300 (BRT)
Received: from chagas.nectar.ath.cx (unknown [187.22.248.83])
	by socom8.uol.com.br (Postfix) with ESMTPA id 1B48B1C0000A0
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 16:14:20 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

Hi, Alan, Andrew and others.

On Aug 21 2009, Alan Stern wrote:
> On Thu, 20 Aug 2009, Rog=C3=A9rio Brito wrote:
>=20
> > Again, just reiterating, what I said before, even though I am not s=
ure
> > if I can reproduce it, I will try to.
>=20
> A usbmon trace showing what happens when you plug in the drive and=20
> when you run smartctl would help.

Well, I'll just go grab the sources to usbmon. In the mean time, I just
issued the command with a freshly compiled 2.6.31-rc7 and the problem
persists:

,----
|  5581 pts/1    D+     0:00 ./smartctl -d usbcypress -a /dev/sda
`----

(And the stack traces too).

I will be replying with the usbmon trace ASAP.


Thanks, Rog=C3=A9rio Brito.

--=20
Rog=C3=A9rio Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2C=
AEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
