From: David Jacovkis Halperin <david@vega.uab.es>
Subject: aic7xxx, HP-dat i/o error
Date: Fri, 18 Oct 2002 13:20:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <02101812544601.11648@vega>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vega (localhost [127.0.0.1])
	by vega.uab.es (8.11.3/8.11.3/SuSE Linux 8.11.1-0.5) with SMTP id g9IBKEW02509
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2002 13:20:14 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi all. I have a problem with a tape drive (hp dat24i, model C1537A)=20
connected to an Adaptec 2930U SCSI card installed in a SuSE7.2 (2.4.4-4=
GB=20
kernel) on a pc-intel box. The drive used to work until some days ago, =
when=20
it got blocked, not allowing to load the aic7xxx. After powering it off=
 and=20
on again it loads the module, but any operation involving read or write=
=20
results in an I/O error of this kind:

__________________________

Oct 18 11:04:42 vega kernel: st0: Error with sense data: Info fld=3D0x0=
,=20
	Current st09:00: sns =3D f0  3
Oct 18 11:04:42 vega kernel: ASC=3D c ASCQ=3D 0
Oct 18 11:04:42 vega kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x=
00=20
	0x00 0x0e 0x00 0x00 0x00 0x00 0x0c 0x00 0x00 0x00 0x00 0x85 0x00 0x00 =
0x00 	=09
	0x08=20
Oct 18 11:04:42 vega kernel: st0: Error on write filemark.
___________________________

I'm not familiar with SCSI devices, so I don't even know which kind of =
error=20
should I look for, or at which level. I'd appreciate any suggestions.

Thanks in advance,

David

--=20
David Jacovkis Halperin
Grup de F=EDsica dels Materials I
Universitat Aut=F2noma de Barcelona
08193 Bellaterra
Spain

http://vega.uab.es
Tel:  (34) 93 581 1481
=46ax: (34) 39 581 2155
Jabber: memnoch@jabber.at / ICQ: 103428664 / MSN: memnoch@inicia.es

"No uso ning=FAn programa de Micro$oft. Por favor, a ser posible no me =
mandes=20
archivos de Word"

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
