From: Nicolas Mailhot <Nicolas.Mailhot@laposte.net>
Subject: scsi1:0:0:0: Attempting to queue an ABORT message problem
Date: 15 May 2003 17:59:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053014366.9064.12.camel@ulysse.olympe.o2t>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GLD5qEGQHdnYisUI9SYp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.clb.oleane.net ([213.56.31.20]:60378 "EHLO
	smtp4.clb.oleane.net") by vger.kernel.org with ESMTP
	id S264081AbTEOPqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 11:46:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: gibbs@btc.adaptec.com
Cc: linux-scsi@vger.kernel.org


--=-GLD5qEGQHdnYisUI9SYp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

	I'm getting regular slowdowns on  a Dell server. System will freeze
then recover after a few minutes. The logs show the scsi subsystem is
always doing aborts when this happens. I'd like to know if this is
software or hardware problem, and what could be done to cure this box.

	System is :

RH 7.3+ 2.4.21-rc1 + aic79xx-linux-2.4-20030424

	Relevant information follows :

lspci
*****

01:02.0 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
        Subsystem: Dell Computer Corporation: Unknown device 00ce
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 08
        Interrupt: pin A routed to IRQ 30
        BIST result: 00
        Region 0: I/O ports at dc00 [disabled] [size=3D256]
        Region 1: Memory at f9001000 (64-bit, non-prefetchable)
[size=3D4K]
        Expansion ROM at f8000000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=20
01:02.1 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
        Subsystem: Dell Computer Corporation: Unknown device 00ce
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 08
        Interrupt: pin B routed to IRQ 31
        BIST result: 00
        Region 0: I/O ports at d800 [disabled] [size=3D256]
        Region 1: Memory at f9000000 (64-bit, non-prefetchable)
[size=3D4K]
        Expansion ROM at f8000000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
dmesg
*****

SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.32
        <Adaptec 2940A Ultra SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=3D7, 3/253 SCBs
=20
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.32
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
=20
scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.32
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=3D7, 32/253 SCBs
=20

blk: queue c1f69674, I/O limit 4095Mb (mask 0xffffffff)
(scsi1:A:0): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
(scsi1:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
(scsi1:A:4): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
(scsi0:A:5): 10.000MB/s transfers (10.000MHz, offset 15)
  Vendor: HP        Model: C1557A            Rev: U812
  Type:   Sequential-Access                  ANSI SCSI revision: 02
blk: queue c1f69774, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: HP        Model: C1557A            Rev: U812
  Type:   Medium Changer                     ANSI SCSI revision: 02
blk: queue f7c89294, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: FUJITSU   Model: MAJ3364MP         Rev: 5509
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue c1f69a74, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K3_36_SCA  Rev: 020W
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue c1f69974, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K2-TY184L  Rev: DA40
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7c89094, I/O limit 4095Mb (mask 0xffffffff)
scsi1:A:0:0: Tagged Queuing enabled.  Depth 64
scsi1:A:1:0: Tagged Queuing enabled.  Depth 64
scsi1:A:4:0: Tagged Queuing enabled.  Depth 64
blk: queue c1f69d74, I/O limit 4095Mb (mask 0xffffffff)
st: Version 20020805, bufsize 32768, wrt 30720, max init. bufs 4, s/g
segs 16
Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi1, channel 0, id 4, lun 0
SCSI device sda: 71132959 512-byte hdwr sectors (36420 MB)

/var/log/message
****************

May 15 17:20:10 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:20:10 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xa1 0x9a 0x0 0x0
0x8 0x0
May 15 17:20:10 crios kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
<<<<<<<<<<<<<<<<<
May 15 17:20:10 crios kernel: scsi1: Dumping Card State while idle, at
SEQADDR 0x9
May 15 17:20:10 crios kernel: Card was paused
May 15 17:20:10 crios kernel: ACCUM =3D 0x0, SINDEX =3D 0x37, DINDEX =3D 0x=
e4,
ARG_2 =3D 0x0
May 15 17:20:10 crios kernel: HCNT =3D 0x0 SCBPTR =3D 0x11
May 15 17:20:10 crios kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
SCSIBUSL[0x0]=20
May 15 17:20:10 crios kernel: LASTPHASE[0x1]:(P_BUSFREE)
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)=20
May 15 17:20:10 crios kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB)
SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)=20
May 15 17:20:10 crios kernel:
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) SSTAT0[0x0]=20
May 15 17:23:06 crios kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0]
SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)=20
May 15 17:23:07 crios kernel:
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) SXFRCTL0[0x80]:(DFON)=20
May 15 17:23:07 crios kernel: DFCNTRL[0x0]
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)=20
May 15 17:23:07 crios kernel: STACK: 0xe9 0x16b 0x111 0x3
May 15 17:23:07 crios kernel: SCB count =3D 150
May 15 17:23:07 crios kernel: Kernel NEXTQSCB =3D 76
May 15 17:23:07 crios kernel: Card NEXTQSCB =3D 76
May 15 17:23:07 crios kernel: QINFIFO entries:=20
May 15 17:23:07 crios kernel: Waiting Queue entries:=20
May 15 17:23:07 crios kernel: Disconnected Queue entries: 5:67 3:39
23:71 31:36 27:64 9:133 10:118 4:108 20:10 22:65 2:98 18:77 16:52 6:13
26:136 25:130 8:38 24:37 30:113 15:59 7:124 1:120 12:115 29:134 11:138
0:119 19:22 28:83 21:123 13:95=20
May 15 17:23:07 crios kernel: QOUTFIFO entries:=20
May 15 17:23:07 crios kernel: Sequencer Free SCB List: 17 14=20
May 15 17:23:07 crios kernel: Sequencer SCB Info:=20
May 15 17:23:07 crios kernel:   0
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x77]=20
May 15 17:23:07 crios kernel:   1
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x78]=20
May 15 17:23:07 crios kernel:   2
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x62]=20
May 15 17:23:07 crios kernel:   3
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x27]=20
May 15 17:23:07 crios kernel:   4
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x6c]=20
May 15 17:23:07 crios kernel:   5
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x43]=20
May 15 17:23:07 crios kernel:   6
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xd]=20
May 15 17:23:07 crios kernel:   7
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x7c]=20
May 15 17:23:07 crios kernel:   8
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x26]=20
May 15 17:23:07 crios kernel:   9
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x85]=20
May 15 17:23:07 crios kernel:  10
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x76]=20
May 15 17:23:07 crios kernel:  11
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x8a]=20
May 15 17:23:07 crios kernel:  12
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x73]=20
May 15 17:23:07 crios kernel:  13
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x5f]=20
May 15 17:23:07 crios kernel:  14
SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x17]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  15
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x3b]=20
May 15 17:23:07 crios kernel:  16
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x34]=20
May 15 17:23:07 crios kernel:  17
SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x17]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  18
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x4d]=20
May 15 17:23:07 crios kernel:  19
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x16]=20
May 15 17:23:07 crios kernel:  20
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xa]=20
May 15 17:23:07 crios kernel:  21
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x7b]=20
May 15 17:23:07 crios kernel:  22
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x41]=20
May 15 17:23:07 crios kernel:  23
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x47]=20
May 15 17:23:07 crios kernel:  24
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x25]=20
May 15 17:23:07 crios kernel:  25
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x82]=20
May 15 17:23:07 crios kernel:  26
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x88]=20
May 15 17:23:07 crios kernel:  27
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)  entries: 5:67 3:39
23:71 31:36 27:64 9:133 10:118 4:108 20:10 22:65 2:98 18:77 13:95=20
May 15 17:23:07 crios kernel: QOUTFIFO entries:=20
May 15 17:23:07 crios kernel: Sequencer Free SCB List: 16 6 26 25 8 24
30 15 7 1 12 29 11 0 19 28 21 17 14=20
May 15 17:23:07 crios kernel: Sequencer SCB Info:=20
May 15 17:23:07 crios kernel:   0
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:   1
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:   2
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x62]=20
May 15 17:23:07 crios kernel:   3
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x27]=20
May 15 17:23:07 crios kernel:   4
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x6c]=20
May 15 17:23:07 crios kernel:   5
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x43]=20
May 15 17:23:07 crios kernel:   6
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:   7
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:   8
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:   9
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x85]=20
May 15 17:23:07 crios kernel:  10
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x76]=20
May 15 17:23:07 crios kernel:  11
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  12
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  13
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x5f]=20
May 15 17:23:07 crios kernel:  14
SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x17]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  15
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  16
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  17
SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x17]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  18
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x4d]=20
May 15 17:23:07 crios kernel:  19
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  20
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xa]=20
May 15 17:23:07 crios kernel:  21
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  22
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x41]=20
May 15 17:23:07 crios kernel:  23
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x47]=20
May 15 17:23:07 crios kernel:  24
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  25
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  26
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  27
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x40]=20
May 15 17:23:07 crios kernel:  28
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  29
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  30
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
May 15 17:23:07 crios kernel:  31
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0] SCB_TAG[0x24]=20
May 15 17:23:07 crios kernel: Pending list:=20
May 15 17:23:07 crios kernel:  16
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  17
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  19
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  14
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  28
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  29
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 100
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  12
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 109
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 110
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  40
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  48
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:   6
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  26
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  11
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  50
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 137
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  69
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  82
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:   2
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:   1
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 131
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  66
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 128
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  90
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  70
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 117
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 121
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  86
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  67 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  39 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  71 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  36 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  81
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  34
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  49
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  63
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  27
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]=20
May 15 17:23:07 crios kernel: SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  64 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 133 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 118 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: 108 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  10 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  65 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  98 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  77 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel:  95 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB)
SCB_SCSIID[0x7] SCB_LUN[0x0]=20
May 15 17:23:07 crios kernel: Kernel Free SCB list: 13 136 130 38 37 113
59 124 120 115 134 138 119 22 83 123 76 55 146 33 30 107 56 116 84 21 75
41 61 46 0 3 15 9 74 43 106 96 73 92 94 102 101 132 57 54 91 51 5 31 68
24 53 93 129 20 111 104 7 44 125 60 72 85 99 126 139 25 135 4 32 87 78
45 47 97 122 23 42 79 35 147 80 140 141 149 142 103 143 112 144 89 127
148 114 58 18 105 8 62 88 145=20
May 15 17:23:07 crios kernel: DevQ(0:0:0): 0 waiting
May 15 17:23:07 crios kernel: DevQ(0:1:0): 0 waiting
May 15 17:23:07 crios kernel: DevQ(0:4:0): 0 waiting
May 15 17:23:07 crios kernel:=20
May 15 17:23:07 crios kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
May 15 17:23:07 crios kernel: (scsi1:A:0:0): Device is disconnected,
re-queuing SCB
May 15 17:23:07 crios kernel: Recovery code sleeping
May 15 17:23:07 crios kernel: (scsi1:A:0:0): Abort Tag Message Sent
May 15 17:23:07 crios kernel: (scsi1:A:0:0): SCB 95 - Abort Tag
Completed.
May 15 17:23:07 crios kernel: Recovery SCB completes
May 15 17:23:07 crios kernel: Recovery code awake
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x82 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xba 0xa2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xc8 0x32 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xc9 0x72 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xc9 0x9a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xca 0xea 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xcc 0x1a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xcc 0x3a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xcd 0x6a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x2a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x3a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x62 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x72 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x0 0x11 0x19 0x2a 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x8a 0x0 0x0
0x20 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x32 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x42 0x0 0x0
0x18 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x6a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x7a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x8a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x9a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xb2 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xca 0x0 0x0
0x18 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x1a 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0xb2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0xd8 0x2d 0xf2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2d 0xf2 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x1a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x5a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x82 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x92 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xf2 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0xa 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x2a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x3a 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x72 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x12 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0xaa 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0xba 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0x2 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xa2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xc2 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2e 0xe2 0x0 0x0
0x10 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x32 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
May 15 17:23:07 crios kernel: CDB: 0x2a 0x0 0x3 0x28 0x2f 0x4a 0x0 0x0
0x28 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_abort returns 0x2002
May 15 17:23:07 crios kernel: scsi1:0:0:0: Attempting to queue a TARGET
RESET message
May 15 17:23:07 crios kernel: CDB: 0x28 0x0 0x3 0xeb 0xa1 0x9a 0x0 0x0
0x8 0x0
May 15 17:23:07 crios kernel: scsi1:0:0:0: Command not found
May 15 17:23:07 crios kernel: aic7xxx_dev_reset returns 0x2002

Regards,

--=20
Nicolas Mailhot

--=-GLD5qEGQHdnYisUI9SYp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+w7leI2bVKDsp8g0RAvIdAKD17PSpN1WWOQUvumB91tkqhR42TwCff0Mi
pDUJmfBe+rwKmvlxFitTNsw=
=RAv1
-----END PGP SIGNATURE-----

--=-GLD5qEGQHdnYisUI9SYp--

