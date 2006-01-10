From: "emmanuel\.fuste" <emmanuel.fuste@laposte.net>
Subject: Re: panic with AIC7xxx
Date: Tue, 10 Jan 2006 10:33:17 +0100
Message-ID: <ISVEJH$DEFF7A73BB517DB961D40DE65BBC816F@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:26116 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932168AbWAJJfL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 04:35:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk <bunk@stusta.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello,

> On Sat, Oct 29, 2005 at 01:34:20AM +0200, Emmanuel Fust=E9 wrote:
>=20
> > Hello,
>=20
> Hi Emmanuel,
>=20
> > I recently made the switch from 2.4.26 to 2.6.13 and
2.6.14rc5 on my old
> > dual 586mmx 233mhz.
>=20
> are your problems still present in 2.6.15?
>=20
> > I've got many problems with SMP on 2.6.13 (bad irq
balancing/routing
> > very bad performance on IDE and SCSI) but I tried to use
the long
> > awaited CDRW support.
> > I format a disc with cdrwtools -d/dev/cdrw -t4 -q
> > the initialisation of the disc start and ~5min later I got :
> >=20
> > Oct 20 20:44:57 rafale kernel: scsi0:0:3:0: Attempting to
queue an ABORT message
> > Oct 20 20:44:57 rafale kernel: CDB: 0x4 0x17 0x0 0x0 0x0 0x0
> > Oct 20 20:44:57 rafale kernel: scsi0: At time of recovery,
card was not paused
=2E.....
> >=20
> > Now I use a 2.6.14rc5 kernel with great results from a
performance stand
> > point: no longer bad SMP IRQ routing/balancing, good perfs
for IDE and
> > SCSI disc but when I try to blank a disc with the same
command:
> > cdrwtools -d/dev/cdrw -t4 -q
> > Nothing append and the cd-writer/scsi bus directly crash:
> > Oct 26 21:07:57 rafale kernel: scsi0:0:3:0: Attempting to
queue an ABORT message
> > Oct 26 21:07:57 rafale kernel: CDB: 0x5c 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0xc 0x0 0x0 0x0
> > Oct 26 21:07:57 rafale kernel: scsi0: At time of recovery,
card was not paused
=2E......
>=20
> cu
> Adrian
>=20
> --=20

I was waiting the merge of the patch serie from Hannes
Reinecke <hare () suse ! de>, because of the sequencer fixes.
I did'nt try this patch serie myself because the sequencer
fixes one ([PATCH 5/6]] never reach lkml or linux-scsi.

I will compile a clean 2.6.15 today and give it a try this
evening.

Regards,
Emmanuel.

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
