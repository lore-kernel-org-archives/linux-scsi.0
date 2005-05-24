From: Ming Zhang <mingz@ele.uri.edu>
Subject: aic7xxx: how to decode this msg?
Date: Tue, 24 May 2005 10:59:40 -0400
Message-ID: <1116946780.5547.73.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v9lQIRSS0zSihpm9rolm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:3217 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262083AbVEXO7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 10:59:45 -0400
Received: from localhost.localdomain (leviathan [131.128.51.64])
	by leviathan.ele.uri.edu (8.12.9/8.12.9) with ESMTP id j4OExffP015730
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 10:59:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-v9lQIRSS0zSihpm9rolm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi folks

I met this message again and again when running a aix7xxx with a HP lTO3
drive. i add some debug msg in my code and i found that this is what i
executed.

May 24 05:09:21 bridge2scsi kernel: raw_execute_cmnd(102) ENTER
raw_execute_cmnd with command 0x8
May 24 05:09:21 bridge2scsi kernel: raw_execute_cmnd(102) ENTER
raw_execute_cmnd with command 0x11
May 24 05:09:21 bridge2scsi kernel: raw_execute_cmnd(102) ENTER
raw_execute_cmnd with command 0x8
May 24 05:09:21 bridge2scsi last message repeated 21 times
May 24 05:09:21 bridge2scsi kernel: raw_execute_cmnd(102) ENTER
raw_execute_cmnd with command 0x11

a lot of read_6 follow a space_6.

i wonder if anybody can explain a bit me on how to read this dump and
what possible reasons can lead to this. thanks.

ps, i do not think my code abort a command.

ming


-------------------------------------------------
May 24 05:09:14 bridge2scsi kernel: scsi0:0:3:0: Attempting to queue an
ABORT message
May 24 05:09:14 bridge2scsi kernel: CDB: 0x11 0x1 0x0 0x0 0x1 0x0
May 24 05:09:14 bridge2scsi kernel: scsi0: At time of recovery, card was
not paused
May 24 05:09:14 bridge2scsi kernel: >>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
May 24 05:09:14 bridge2scsi kernel: scsi0: Dumping Card State while
idle, at SEQADDR 0x9
May 24 05:09:14 bridge2scsi kernel: Card was paused
May 24 05:09:14 bridge2scsi kernel: ACCUM =3D 0x4, SINDEX =3D 0x64, DINDEX =
=3D
0x65, ARG_2 =3D 0x0
May 24 05:09:14 bridge2scsi kernel: HCNT =3D 0x0 SCBPTR =3D 0x0
May 24 05:09:14 bridge2scsi kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR
[0x0] SCSIBUSL[0x0]=20
May 24 05:09:14 bridge2scsi kernel: LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ
[0x12]:(ENAUTOATNP|ENRSELI)=20
May 24 05:09:14 bridge2scsi kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB)
SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)=20
May 24 05:09:14 bridge2scsi kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|
NOT_IDENTIFIED) SSTAT0[0x0]=20
May 24 05:09:14 bridge2scsi kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0]
SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)=20
May 24 05:09:14 bridge2scsi kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|
ENSELTIMO) SXFRCTL0[0x80]:(DFON)=20
May 24 05:09:14 bridge2scsi kernel: DFCNTRL[0x0] DFSTATUS[0x89]:
(FIFOEMP|HDONE|PRELOAD_AVAIL)=20
May 24 05:09:14 bridge2scsi kernel: STACK: 0x0 0x163 0x178 0x3
May 24 05:09:14 bridge2scsi kernel: SCB count =3D 4
May 24 05:09:14 bridge2scsi kernel: Kernel NEXTQSCB =3D 2
May 24 05:09:14 bridge2scsi kernel: Card NEXTQSCB =3D 2
May 24 05:09:14 bridge2scsi kernel: QINFIFO entries:=20
May 24 05:09:14 bridge2scsi kernel: Waiting Queue entries:=20
May 24 05:09:14 bridge2scsi kernel: Disconnected Queue entries: 0:3=20
May 24 05:09:14 bridge2scsi kernel: QOUTFIFO entries:=20
May 24 05:09:14 bridge2scsi kernel: Sequencer Free SCB List: 1 2 3 4 5 6
7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31=20
May 24 05:09:14 bridge2scsi kernel: Sequencer SCB Info:=20
May 24 05:09:14 bridge2scsi kernel:   0 SCB_CONTROL[0x64]:(DISCONNECTED|
TAG_ENB|DISCENB) SCB_SCSIID[0x37]=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0x0] SCB_TAG[0x3]=20
May 24 05:09:14 bridge2scsi kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   3 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   4 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   5 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   7 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   8 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID
[0xff]:(TWIN_CHNLB|OID|TWIN_TID)=20
May 24 05:09:14 bridge2scsi kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID)
SCB_TAG[0xff]=20
May 24 05:09:14 bridge2scsi kernel: Pending list:=20
May 24 05:09:14 bridge2scsi kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|
DISCENB) SCB_SCSIID[0x37] SCB_LUN[0x0]=20
May 24 05:09:14 bridge2scsi kernel: Kernel Free SCB list: 1 0=20
May 24 05:09:14 bridge2scsi kernel: DevQ(0:3:0): 0 waiting
May 24 05:09:14 bridge2scsi kernel:=20
May 24 05:09:14 bridge2scsi kernel: <<<<<<<<<<<<<<<<< Dump Card State
Ends >>>>>>>>>>>>>>>>>>
May 24 05:09:14 bridge2scsi kernel: (scsi0:A:3:0): Device is
disconnected, re-queuing SCB
May 24 05:09:14 bridge2scsi kernel: Recovery code sleeping
May 24 05:09:14 bridge2scsi kernel: (scsi0:A:3:0): Abort Tag Message
Sent
May 24 05:09:14 bridge2scsi kernel: (scsi0:A:3:0): SCB 3 - Abort Tag
Completed.
May 24 05:09:14 bridge2scsi kernel: Recovery SCB completes
May 24 05:09:14 bridge2scsi kernel: Recovery code awake
May 24 05:09:14 bridge2scsi kernel: aic7xxx_abort returns 0x2002

--=-v9lQIRSS0zSihpm9rolm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCk0FcSYbkL5BnVYoRAsq8AKCK9E9nKoHCaRhpEBhlNMWy/v3/agCfY/XG
iFI1emVl7SlQgKXxGNdAXWw=
=s8Jx
-----END PGP SIGNATURE-----

--=-v9lQIRSS0zSihpm9rolm--

