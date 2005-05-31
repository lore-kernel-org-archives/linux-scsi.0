From: =?windows-1252?Q?Martin_MOKREJ=8A?=
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: Attempting to queue an ABORT message
Date: Tue, 31 May 2005 18:10:58 +0200
Message-ID: <429C8C92.4090905@ribosome.natur.cuni.cz>
References: <429C45C9.4040708@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:63395 "EHLO
	ribosome.natur.cuni.cz") by vger.kernel.org with ESMTP
	id S261927AbVEaQL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 12:11:28 -0400
In-Reply-To: <429C45C9.4040708@ribosome.natur.cuni.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I forgot to include aic7xxx version, so here it is with some more data =
right away. ;-)


# cat /proc/scsi/aic7xxx/1=20
Adaptec AIC7xxx driver version: 6.2.36
Adaptec 29160 Ultra160 SCSI adapter
aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
Allocated SCBs: 6, SG List Length: 85

Serial EEPROM:
0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a=20
0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a=20
0x00f5 0x7c5d 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff=20
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xde50=20

Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 80.000MB/s transfers (40.000MHz, offset 62, 16bit)
        Curr: 80.000MB/s transfers (40.000MHz, offset 62, 16bit)
        Channel A Target 4 Lun 0 Settings
                Commands Queued 711
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
        Curr: 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
        Channel A Target 6 Lun 0 Settings
                Commands Queued 33373
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
# cat /proc/scsi/aic7xxx/2=20
Adaptec AIC7xxx driver version: 6.2.36
Adaptec 29160B Ultra160 SCSI adapter
aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
Allocated SCBs: 42, SG List Length: 85

Serial EEPROM:
0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a=20
0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a 0x433a=20
0x00f4 0x605d 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff=20
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xc24f=20

Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
        Channel A Target 0 Lun 0 Settings
                Commands Queued 15152
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
        Channel A Target 0 Lun 1 Settings
                Commands Queued 9
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
        Channel A Target 0 Lun 2 Settings
                Commands Queued 383
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
        Channel A Target 0 Lun 3 Settings
                Commands Queued 5330
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
#



Martin MOKREJ=8A wrote:
> Hi,
>  could someone explain me meaning of teh below debug messages?
> The disk sdb went wrong because of bad media. However, I observe
> weird scsi-card errors. We had to re-generate parity on RAID5 disks
> in the array, although the disk which broke was NRAID disk:
>=20
>=20
> Setting Global Tags=3D 32
> scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>        <Adaptec 29160 Ultra160 SCSI adapter>
>        aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
>=20
> scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>        <Adaptec 29160B Ultra160 SCSI adapter>
>        aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
>=20
> blk: queue f73eaa18, I/O limit 524287Mb (mask 0x7fffffffff)
> (scsi2:A:0): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
> (scsi1:A:4): 80.000MB/s transfers (40.000MHz, offset 62, 16bit)
> (scsi1:A:6): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
>  Vendor: QUANTUM   Model: SuperDLT1         Rev: 4646
>  Type:   Sequential-Access                  ANSI SCSI revision: 02
> blk: queue f73ea818, I/O limit 524287Mb (mask 0x7fffffffff)
>  Vendor: OVERLAND  Model: LXB               Rev: 0106
>  Type:   Medium Changer                     ANSI SCSI revision: 02
> blk: queue f704f418, I/O limit 524287Mb (mask 0x7fffffffff)
>  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
>  Type:   Direct-Access                      ANSI SCSI revision: 04
> blk: queue f704fa18, I/O limit 524287Mb (mask 0x7fffffffff)
>  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
>  Type:   Direct-Access                      ANSI SCSI revision: 04
> blk: queue f73ea418, I/O limit 524287Mb (mask 0x7fffffffff)
>  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
>  Type:   Direct-Access                      ANSI SCSI revision: 04
> blk: queue f6fadc18, I/O limit 524287Mb (mask 0x7fffffffff)
>  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
>  Type:   Direct-Access                      ANSI SCSI revision: 04
> blk: queue f6fada18, I/O limit 524287Mb (mask 0x7fffffffff)
> scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
> scsi2:A:0:1: Tagged Queuing enabled.  Depth 32
> scsi2:A:0:2: Tagged Queuing enabled.  Depth 32
> scsi2:A:0:3: Tagged Queuing enabled.  Depth 32
> st: Version 20040102, bufsize 32768, max init. bufs 4, s/g segs 16
> Attached scsi tape st0 at scsi1, channel 0, id 4, lun 0
> Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
> Attached scsi disk sdc at scsi2, channel 0, id 0, lun 1
> Attached scsi disk sdd at scsi2, channel 0, id 0, lun 2
> Attached scsi disk sde at scsi2, channel 0, id 0, lun 3
> SCSI device sdb: 245760000 512-byte hdwr sectors (125829 MB)
> /dev/scsi/host2/bus0/target0/lun0: p1
> SCSI device sdc: 40989184 512-byte hdwr sectors (20986 MB)
> /dev/scsi/host2/bus0/target0/lun1: p1
> SCSI device sdd: 1638400000 512-byte hdwr sectors (838861 MB)
> /dev/scsi/host2/bus0/target0/lun2: p1
> SCSI device sde: 651395072 512-byte hdwr sectors (333514 MB)
> /dev/scsi/host2/bus0/target0/lun3: p1
>=20
> The disk sdb1 went wrong because of bad media. However, I observe
> weird scsi-card errors:
>=20
> scsi1:0:4:0: Attempting to queue an ABORT message
> CDB: 0x12 0x0 0x0 0x0 0x32 0x0
> scsi1: At time of recovery, card was not paused
>=20
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>=20
> scsi1: Dumping Card State in Message-out phase, at SEQADDR 0x36
> Card was paused
> ACCUM =3D 0xa0, SINDEX =3D 0x48, DINDEX =3D 0xe4, ARG_2 =3D 0x0
> HCNT =3D 0x0 SCBPTR =3D 0x0
> SCSIPHASE[0x4] SCSISIGI[0xb6] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xa0=
]=20
> SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0x93] SEQCTL[0x10] SEQ_FLAGS[0x40=
]=20
> SSTAT0[0x2] SSTAT1[0x11] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]=20
> SIMODE1[0xac] SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] STACK: 0x0=20
> 0x16a 0x17f 0x34
> SCB count =3D 6
> Kernel NEXTQSCB =3D 4
> Card NEXTQSCB =3D 4
> QINFIFO entries: Waiting Queue entries: Disconnected Queue entries:=20
> QOUTFIFO entries: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12=
 13=20
> 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 Sequencer SCB=20
> Info:  0 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0x3]=
  1=20
> SCB_CONTROL[0xc0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff]  2=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  3=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  4=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  5=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  6=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  7=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  8=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  9=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 10=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 11=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 12=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 13=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 14=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 15=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 16=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 17=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 18=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 19=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 20=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 21=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 22=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 23=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 24=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 25=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 26=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 27=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 28=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 29=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 30=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 31=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] Pending=
=20
> list:  3 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] Kernel Free =
SCB=20
> list: 5 2 1 0 Untagged Q(4): 3 DevQ(0:4:0): 0 waiting
> DevQ(0:6:0): 0 waiting
>=20
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi1:0:4:0: Device is active, asserting ATN
> Recovery code sleeping
> (scsi1:A:4:0): Abort Message Sent
> (scsi1:A:4:0): SCB 3 - Abort Completed.
> Recovery SCB completes
> Recovery code awake
> aic7xxx_abort returns 0x2002
> scsi1:0:6:0: Attempting to queue an ABORT message
> CDB: 0x12 0x0 0x0 0x0 0x32 0x0
> Infinite interrupt loop, INTSTAT =3D 0scsi1: At time of recovery, car=
d was=20
> not paused
>=20
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>=20
> scsi1: Dumping Card State while idle, at SEQADDR 0x18
> Card was paused
> ACCUM =3D 0x3, SINDEX =3D 0x48, DINDEX =3D 0xe4, ARG_2 =3D 0x0
> HCNT =3D 0x0 SCBPTR =3D 0x0
> SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=
=20
> SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10] SEQ_FLAGS[0xc0]=
=20
> SSTAT0[0x10] SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]=20
> SIMODE1[0xac] SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] STACK: 0xe8=20
> 0x16a 0x17f 0x17
> SCB count =3D 6
> Kernel NEXTQSCB =3D 5
> Card NEXTQSCB =3D 5
> QINFIFO entries: Waiting Queue entries: 0:3 Disconnected Queue entrie=
s:=20
> QOUTFIFO entries: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12=
 13=20
> 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 Sequencer SCB=20
> Info:  0 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0x3]=
  1=20
> SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff]  2=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  3=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  4=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  5=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  6=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  7=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  8=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  9=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 10=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 11=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 12=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 13=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 14=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 15=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 16=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 17=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 18=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 19=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 20=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 21=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 22=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 23=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 24=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 25=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 26=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 27=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 28=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 29=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 30=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 31=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] Pending=
=20
> list:  3 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] Kernel Free =
SCB=20
> list: 4 2 1 0 Untagged Q(6): 3 DevQ(0:4:0): 0 waiting
> DevQ(0:6:0): 0 waiting
>=20
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi1:0:6:0: Cmd aborted from QINFIFO
> aic7xxx_abort returns 0x2002
> scsi1:0:6:0: Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> Infinite interrupt loop, INTSTAT =3D 0scsi1: At time of recovery, car=
d was=20
> not paused
>=20
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>=20
> scsi1: Dumping Card State while idle, at SEQADDR 0x18
> Card was paused
> ACCUM =3D 0x3, SINDEX =3D 0x48, DINDEX =3D 0xe4, ARG_2 =3D 0x0
> HCNT =3D 0x0 SCBPTR =3D 0x0
> SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=
=20
> SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10] SEQ_FLAGS[0xc0]=
=20
> SSTAT0[0x10] SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]=20
> SIMODE1[0xac] SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] STACK: 0xe8=20
> 0x16a 0x17f 0x17
> SCB count =3D 6
> Kernel NEXTQSCB =3D 3
> Card NEXTQSCB =3D 5
> QINFIFO entries: 5 Waiting Queue entries: Disconnected Queue entries:=
=20
> QOUTFIFO entries: Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 =
12=20
> 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 Sequencer SC=
B=20
> Info:  0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff]=
  1=20
> SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff]  2=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  3=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  4=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  5=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  6=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  7=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  8=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  9=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 10=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 11=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 12=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 13=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 14=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 15=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 16=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 17=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 18=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 19=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 20=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 21=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 22=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 23=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 24=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 25=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 26=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 27=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 28=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 29=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 30=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 31=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] Pending=
=20
> list:  5 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] Kernel Free =
SCB=20
> list: 4 2 1 0 Untagged Q(6): 5 DevQ(0:4:0): 0 waiting
> DevQ(0:6:0): 0 waiting
>=20
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi1:0:6:0: Cmd aborted from QINFIFO
> aic7xxx_abort returns 0x2002
> scsi1:0:6:0: Attempting to queue a TARGET RESET message
> CDB: 0x12 0x0 0x0 0x0 0x32 0x0
> scsi1:0:6:0: Command not found
> aic7xxx_dev_reset returns 0x2002
> scsi1:0:6:0: Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> Infinite interrupt loop, INTSTAT =3D 0scsi1: At time of recovery, car=
d was=20
> not paused
>=20
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>=20
> scsi1: Dumping Card State while idle, at SEQADDR 0x18
> Card was paused
> ACCUM =3D 0x3, SINDEX =3D 0x48, DINDEX =3D 0xe4, ARG_2 =3D 0x0
> HCNT =3D 0x0 SCBPTR =3D 0x0
> SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=
=20
> SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10] SEQ_FLAGS[0xc0]=
=20
> SSTAT0[0x10] SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]=20
> SIMODE1[0xac] SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] STACK: 0xe8=20
> 0x16a 0x17f 0x17
> SCB count =3D 6
> Kernel NEXTQSCB =3D 5
> Card NEXTQSCB =3D 3
> QINFIFO entries: 3 Waiting Queue entries: Disconnected Queue entries:=
=20
> QOUTFIFO entries: Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 =
12=20
> 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 Sequencer SC=
B=20
> Info:  0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff]=
  1=20
> SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff]  2=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  3=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  4=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  5=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  6=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  7=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  8=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]  9=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 10=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 11=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 12=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 13=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 14=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 15=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 16=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 17=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 18=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 19=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 20=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 21=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 22=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 23=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 24=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 25=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 26=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 27=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 28=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 29=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 30=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 31=20
> SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] Pending=
=20
> list:  3 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] Kernel Free =
SCB=20
> list: 4 2 1 0 Untagged Q(6): 3 DevQ(0:4:0): 0 waiting
> DevQ(0:6:0): 0 waiting
>=20
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi1:0:6:0: Cmd aborted from QINFIFO
> aic7xxx_abort returns 0x2002
>=20
> # lspci
> 0000:00:00.0 Host bridge: Intel Corporation E7501 Memory Controller H=
ub=20
> (rev 01)ernel-headers=3D/usr/src/linux-2.4.30-pre2-bk3 -
> 0000:00:00.1 Class ff00: Intel Corporation E7500/E7501 Host RASUM=20
> Controller (rev 01)-new-config --enable-debug-kernel --enabl
> 0000:00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface =
C=20
> PCI-to-PCI Bridge (rev 01)
> 0000:00:03.1 Class ff00: Intel Corporation E7500/E7501 Hub Interface =
C=20
> RASUM Controller (rev 01)
> 0000:00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #=
1)=20
> (rev 02)
> 0000:00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #=
2)=20
> (rev 02)
> 0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42)
> 0000:00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface=20
> Controller (rev 02)
> 0000:00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Stora=
ge=20
> Controller (rev 02)
> 0000:00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (r=
ev 02)
> 0000:01:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL=20
> (rev 27)
> 0000:02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
> 0000:02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Brid=
ge=20
> (rev 04)
> 0000:02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
> 0000:02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Brid=
ge=20
> (rev 04)
> 0000:03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit=20
> Ethernet Controller (Copper) (rev 01)
> 0000:03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit=20
> Ethernet Controller (Copper) (rev 01)
> 0000:03:08.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 0=
2)
> 0000:04:08.0 RAID bus controller: Intel Corporation RAID Controller
> 0000:04:09.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 0=
2)
> # cat /proc/scsi/scsi Attached devices: Host: scsi0 Channel: 00 Id: 0=
0=20
> Lun: 00
>  Vendor: Intel    Model: Host Drive  #00  Rev:      Type:  =20
> Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 02 Id: 06 Lun: 00
>  Vendor: ESG-SHV  Model: SCA HSBP M16     Rev: 0.05
>  Type:   Processor                        ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 04 Lun: 00
>  Vendor: QUANTUM  Model: SuperDLT1        Rev: 4646
>  Type:   Sequential-Access                ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 06 Lun: 00
>  Vendor: OVERLAND Model: LXB              Rev: 0106
>  Type:   Medium Changer                   ANSI SCSI revision: 02
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
>  Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi2 Channel: 00 Id: 00 Lun: 01
>  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
>  Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi2 Channel: 00 Id: 00 Lun: 02
>  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
>  Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi2 Channel: 00 Id: 00 Lun: 03
>  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
>  Type:   Direct-Access                    ANSI SCSI revision: 04
> #
> # uname -a
> Linux oxygen 2.4.30-pre2-bk3 #3 SMP Mon Mar 7 13:35:40 MET 2005 i686=20
> Intel(R) Xeon(TM) CPU 3.06GHz GenuineIntel GNU/Linux
>=20
> Thanks for help
> Martin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--=20
Martin Mokrejs
Email: 'bW9rcmVqc21Acmlib3NvbWUubmF0dXIuY3VuaS5jeg=3D=3D\n'.decode('bas=
e64')
GPG key is at http://www.natur.cuni.cz/~mmokrejs
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
