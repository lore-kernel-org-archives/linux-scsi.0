From: "emmanuel\.fuste" <emmanuel.fuste@laposte.net>
Subject: Re: Dead Adaptec AHA-2940U2/U2W while ripping a CD
Date: Fri, 27 Jan 2006 12:28:44 +0100
Message-ID: <ITR17W$2B8A7E1A2CD50327367252872E28FBDC@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:1863 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S964995AbWA0L30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 06:29:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Chouquet-Stringer <ml2news@free.fr>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

See http://bugzilla.kernel.org/show_bug.cgi?id=3D5921

Regards,
Emmanuel.

>        Hello,
>
>I was ripping a (copy protected) cd on my alpha and got the
following
>stuff (see below). At that point, the box failed to respond
and because I
>don't have a console, I rebooted it.
>
>Kernel version is (vanilla 2.6.15):
>Linux alpha 2.6.15 #1 Sat Jan 7 16:32:48 CET 2006 alpha EV56
EB164 GNU/Linux
>
>Here's the lspci entry for the card:
>01:01.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
>        Subsystem: Adaptec AHA-2940U2 SCSI Controller
>        Flags: bus master, medium devsel, latency 32, IRQ 26
>        BIST result: 00
>        I/O ports at 9000 [disabled] [size=3D256]
>        Memory at 09200000 (64-bit, non-prefetchable) [size=3D4K]
>        [virtual] Expansion ROM at 09640000 [disabled]
[size=3D128K]
>        Capabilities: [dc] Power Management version 1
>
>If you want me to test anything let me know.
>
>Cheers,
>
>Jan 26 18:23:06 alpha sr 1:0:6:0: Attempting to queue an
ABORT message
>Jan 26 18:23:06 alpha CDB: 0xbe 0x4 0x0 0x2 0x78 0x11 0x0 0x0
0x5 0xf8 0x0 0x0
>Jan 26 18:23:06 alpha scsi1: At time of recovery, card was
not paused
>Jan 26 18:23:06 alpha >>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
>Jan 26 18:23:06 alpha scsi1: Dumping Card State while idle,
at SEQADDR 0x9
>Jan 26 18:23:06 alpha Card was paused
>Jan 26 18:23:06 alpha ACCUM =3D 0x0, SINDEX =3D 0x0, DINDEX =3D
0xe4, ARG_2 =3D 0x0
>Jan 26 18:23:06 alpha HCNT =3D 0x0 SCBPTR =3D 0x1d
>Jan 26 18:23:06 alpha SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] \
>                LASTPHASE[0x1]:(P_BUSFREE)=20
>Jan 26 18:23:06 alpha SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) \
>                SBLKCTL[0xa]:(SELWIDE|SELBUSB)=20
=2E.....

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
