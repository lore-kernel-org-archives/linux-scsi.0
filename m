From: Mathieu Chouquet-Stringer <ml2news@free.fr>
Subject: Dead Adaptec AHA-2940U2/U2W while ripping a CD
Date: 26 Jan 2006 18:39:13 +0100
Message-ID: <m3acdi99dq.fsf_-_@localhost.localdomain>
References: <Pine.LNX.4.64.0601261138500.23310@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from AMarseille-252-1-93-193.w86-202.abo.wanadoo.fr ([86.202.148.193]:21945
	"EHLO localhost.localdomain") by vger.kernel.org with ESMTP
	id S932377AbWAZRjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 12:39:35 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by localhost.localdomain (8.13.5/8.13.5) with ESMTP id k0QHdFR9031288
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2006 18:39:15 +0100
In-Reply-To: <Pine.LNX.4.64.0601261138500.23310@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

        Hello,

I was ripping a (copy protected) cd on my alpha and got the following
stuff (see below). At that point, the box failed to respond and because=
 I
don't have a console, I rebooted it.

Kernel version is (vanilla 2.6.15):
Linux alpha 2.6.15 #1 Sat Jan 7 16:32:48 CET 2006 alpha EV56 EB164 GNU/=
Linux

Here's the lspci entry for the card:
01:01.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
        Subsystem: Adaptec AHA-2940U2 SCSI Controller
        Flags: bus master, medium devsel, latency 32, IRQ 26
        BIST result: 00
        I/O ports at 9000 [disabled] [size=3D256]
        Memory at 09200000 (64-bit, non-prefetchable) [size=3D4K]
        [virtual] Expansion ROM at 09640000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 1

If you want me to test anything let me know.

Cheers,

Jan 26 18:23:06 alpha sr 1:0:6:0: Attempting to queue an ABORT message
Jan 26 18:23:06 alpha CDB: 0xbe 0x4 0x0 0x2 0x78 0x11 0x0 0x0 0x5 0xf8 =
0x0 0x0
Jan 26 18:23:06 alpha scsi1: At time of recovery, card was not paused
Jan 26 18:23:06 alpha >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<=
<<<<<<<<<<
Jan 26 18:23:06 alpha scsi1: Dumping Card State while idle, at SEQADDR =
0x9
Jan 26 18:23:06 alpha Card was paused
Jan 26 18:23:06 alpha ACCUM =3D 0x0, SINDEX =3D 0x0, DINDEX =3D 0xe4, A=
RG_2 =3D 0x0
Jan 26 18:23:06 alpha HCNT =3D 0x0 SCBPTR =3D 0x1d
Jan 26 18:23:06 alpha SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[=
0x1]:(P_BUSFREE)=20
Jan 26 18:23:06 alpha SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKCTL[0xa]:(=
SELWIDE|SELBUSB)=20
Jan 26 18:23:06 alpha SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0=
xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)=20
Jan 26 18:23:06 alpha SSTAT0[0x0] SSTAT1[0xa]:(PHASECHG|BUSFREE) SSTAT2=
[0x0]=20
Jan 26 18:23:06 alpha SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xa4]:=
(ENSCSIPERR|ENSCSIRST|ENSELTIMO)=20
Jan 26 18:23:06 alpha SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] DFSTATUS[0x89]=
:(FIFOEMP|HDONE|PRELOAD_AVAIL)=20
Jan 26 18:23:06 alpha STACK: 0x0 0x167 0x10d 0x3
Jan 26 18:23:06 alpha SCB count =3D 56
Jan 26 18:23:06 alpha Kernel NEXTQSCB =3D 19
Jan 26 18:23:06 alpha Card NEXTQSCB =3D 19
Jan 26 18:23:06 alpha QINFIFO entries:=20
Jan 26 18:23:06 alpha Waiting Queue entries:=20
Jan 26 18:23:06 alpha Disconnected Queue entries: 18:24=20
Jan 26 18:23:06 alpha QOUTFIFO entries:=20
Jan 26 18:23:06 alpha Sequencer Free SCB List: 29 0 24 13 5 10 6 8 21 1=
9 4 11 1 7 23 26 15 9 12 28 3 31 25 16 27 17 30 20 22 14 2=20
Jan 26 18:23:06 alpha Sequencer SCB Info:=20
Jan 26 18:23:06 alpha 0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 8 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) =
SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 11 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 13 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 14 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 15 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 16 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 17 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 18 SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB) SCB_S=
CSIID[0x67]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0x18]=20
Jan 26 18:23:06 alpha 19 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 20 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 21 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 22 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x17]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 23 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 24 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x27]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 25 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x27]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 26 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 27 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 28 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 29 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 30 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha 31 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)=
 SCB_SCSIID[0x7]=20
Jan 26 18:23:06 alpha SCB_LUN[0x0] SCB_TAG[0xff]=20
Jan 26 18:23:06 alpha Pending list:=20
Jan 26 18:23:06 alpha 24 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x67] S=
CB_LUN[0x0]=20
Jan 26 18:23:06 alpha Kernel Free SCB list: 0 35 47 42 40 46 10 12 20 2=
6 31 3 7 14 8 18 27 17 34 15 21 5 33 1 11 29 23 25 6 30 38 16 4 9 39 13=
 41 43 54 44 45 37 32 55 28 22 36 2 53 52 51 50 49 48=20
Jan 26 18:23:06 alpha Untagged Q(6): 24=20
Jan 26 18:23:06 alpha=20
Jan 26 18:23:06 alpha <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>=
>>>>>>>>
Jan 26 18:23:06 alpha (scsi1:A:6:0): Device is disconnected, re-queuing=
 SCB
Jan 26 18:23:06 alpha (scsi1:A:6:0): Abort Message Sent
Jan 26 18:23:06 alpha Recovery code sleeping
Jan 26 18:23:11 alpha Recovery code awake
Jan 26 18:23:11 alpha Timer Expired
Jan 26 18:23:11 alpha aic7xxx_abort returns 0x2003
Jan 26 18:23:11 alpha sr 1:0:6:0: Attempting to queue a TARGET RESET me=
ssage
Jan 26 18:23:11 alpha CDB: 0xbe 0x4 0x0 0x2 0x78 0x11 0x0 0x0 0x5 0xf8 =
0x0 0x0
Jan 26 18:23:11 alpha aic7xxx_dev_reset returns 0x2003
Jan 26 18:23:11 alpha Recovery SCB completes

--=20
Mathieu Chouquet-Stringer
    "Le disparu, si l'on v=E9n=E8re sa m=E9moire, est plus pr=E9sent et
                 plus puissant que le vivant".
           -- Antoine de Saint-Exup=E9ry, Citadelle --
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
