From: =?iso-8859-1?q?Jos=E9_Luis_S=E1nchez?=
	<jsanchez@todounix.homeip.net>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Thu, 24 Nov 2005 16:00:40 +0100
Message-ID: <200511241600.40403.jsanchez@todounix.homeip.net>
References: <20051123134327.GS1598@parisc-linux.org> <200511231723.45088.jsanchez@todounix.homeip.net> <20051123164342.GV1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-202-88-178.user.ono.com ([81.202.88.178]:20119 "EHLO
	mafalda.lcv") by vger.kernel.org with ESMTP id S1751266AbVKXPAq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Nov 2005 10:00:46 -0500
In-Reply-To: <20051123164342.GV1598@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

El Mi=E9rcoles, 23 de Noviembre de 2005 17:43, Matthew Wilcox escribi=F3=
:

> Seems to me that it's not negotiating wide, for some reason.
> 	cat /sys/class/spi_transport/target0:0:5/width
> (should be 0)
> Then try
> 	echo 1 >/sys/class/spi_transport/target0:0:5/width
>
> You'll then have to get it to perform some IO to the device -- an
> 'mt status' should do the trick.

mafalda:/home/jsanchez# echo 1> /sys/class/spi_transport/target0\:0\:5/=
width
mafalda:/home/jsanchez# mt status
SCSI 2 tape drive:
=46ile number=3D-1, block number=3D-1, partition=3D0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=3D0
General status bits on (50000):
 DR_OPEN IM_REP_EN
mafalda:/home/jsanchez# cat /sys/class/spi_transport/target0\:0\:5/widt=
h
0

Don't work...
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
