From: Ermanno Poggi <epoggi@libero.it>
Subject: aic7xxx error
Date: Mon, 20 Dec 2004 21:15:03 +0100
Message-ID: <cq7br0$cho$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:19382 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261480AbULTUZe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 15:25:34 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1CgU2r-0003N5-00
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 21:22:17 +0100
Received: from host72-199.pool8248.interbusiness.it ([82.48.199.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 21:22:17 +0100
Received: from epoggi by host72-199.pool8248.interbusiness.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 21:22:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

=A0Hello
=A0From=A0kernel=A02.6.0,=A0I've=A0a=A0problem=A0with=A0the=A0aic7xxx=A0=
driver=A0(2.6.0-testXX=A0was
ok).
=A0Until=A02.6.7=A0I=A0can=A0solve=A0this=A0issue=A0deleting=A0the=A0or=
iginal=A0aic7xxx=A0directory
in the kernel source and substitute this with the one downloaded from
http://people.freebsd.org/~gibbs/linux/ !
=A0From=A02.6.7=A0I=A0can't=A0do=A0this=A0anymore,=A0because=A0I=A0get=A0=
some=A0error=A0compiling=A0the
kernel!
=A0Can=A0some=A0one=A0tell=A0me=A0if=A0there=A0is=A0a=A0solution,=A0now=
=A0I'm=A0stuck=A0with=A02.6.7=A0and
can't upgrade my kernel!
=A0
=A0The=A0only=A0thing=A0that=A0I've=A0noticed=A0is=A0the=A0ACPI=A0row=A0=
before=A0the=A0detection=A0of
the aic7xxx, in the 2.6.X (where X>7) it could be an ACPI problem??
=A0
=A0Thanks=A0in=A0advance
=A0
=A0Bye=A0bye
=A0
=A0---------kernel=A02.6.9=A0with=A0original=A0aic7xxx=A0driver--------=
----
=A0
=A0Zeus=A0ACPI:=A0PCI=A0interrupt=A00000:00:0d.0[A]=A0->=A0GSI=A011=A0(=
level,=A0low)=A0->=A0IRQ=A011
=A0Zeus=A0scsi0=A0:=A0Adaptec=A0AIC7XXX=A0EISA/VLB/PCI=A0SCSI=A0HBA=A0D=
RIVER,=A0Rev=A06.2.36
=A0Zeus=A0<Adaptec=A02940=A0Ultra=A0SCSI=A0adapter>
=A0Zeus=A0aic7880:=A0Ultra=A0Single=A0Channel=A0A,=A0SCSI=A0Id=3D7,=A01=
6/253=A0SCBs
=A0Zeus
=A0Zeus=A0(scsi0:A:5):=A020.000MB/s=A0transfers=A0(20.000MHz,=A0offset=A0=
8)
=A0Zeus=A0scsi0:0:5:0:=A0Attempting=A0to=A0queue=A0an=A0ABORT=A0message
=A0Zeus=A0CDB:=A00x12=A00x0=A00x0=A00x0=A00x24=A00x0
=A0Zeus=A0scsi0:=A0At=A0time=A0of=A0recovery,=A0card=A0was=A0not=A0paus=
ed
=A0Zeus=A0>>>>>>>>>>>>>>>>>>=A0Dump=A0Card=A0State=A0Begins=A0<<<<<<<<<=
<<<<<<<<
=A0Zeus=A0scsi0:=A0Dumping=A0Card=A0State=A0in=A0Data-in=A0phase,=A0at=A0=
SEQADDR=A00x7c
=A0Zeus=A0Card=A0was=A0paused
=A0Zeus=A0ACCUM=A0=3D=A00x0,=A0SINDEX=A0=3D=A00xb8,=A0DINDEX=A0=3D=A00x=
a8,=A0ARG_2=A0=3D=A00x0
=A0Zeus=A0HCNT=A0=3D=A00x20=A0SCBPTR=A0=3D=A00x0
=A0Zeus=A0SCSISIGI[0x44]=A0ERROR[0x0]=A0SCSIBUSL[0x0]=A0LASTPHASE[0x40]
=A0Zeus=A0SCSISEQ[0x12]=A0SBLKCTL[0x0]=A0SCSIRATE[0x8]=A0SEQCTL[0x10]
=A0Zeus=A0SEQ_FLAGS[0x20]=A0SSTAT0[0x0]=A0SSTAT1[0x2]=A0SSTAT2[0x0]
=A0Zeus=A0SSTAT3[0x0]=A0SIMODE0[0x0]=A0SIMODE1[0xac]=A0SXFRCTL0[0x80]
=A0Zeus=A0DFCNTRL[0x38]=A0DFSTATUS[0x0]
=A0Zeus=A0STACK:=A00x0=A00x162=A00x192=A00x6e
=A0Zeus=A0SCB=A0count=A0=3D=A04
=A0Zeus=A0Kernel=A0NEXTQSCB=A0=3D=A02
=A0Zeus=A0Card=A0NEXTQSCB=A0=3D=A02
=A0Zeus=A0QINFIFO=A0entries:
=A0Zeus=A0Waiting=A0Queue=A0entries:
=A0Zeus=A0Disconnected=A0Queue=A0entries:
=A0Zeus=A0QOUTFIFO=A0entries:
=A0Zeus=A0Sequencer=A0Free=A0SCB=A0List:=A01=A02=A03=A04=A05=A06=A07=A0=
8=A09=A010=A011=A012=A013=A014=A015
=A0Zeus=A0Sequencer=A0SCB=A0Info:
=A0Zeus=A00=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0x57]=A0SCB_LUN[0x0]=A0SCB_=
TAG[0x3]
=A0Zeus=A01=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A02=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A03=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A04=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A05=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A06=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A07=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A08=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A09=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SCB=
_TAG[0xff]
=A0Zeus=A010=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A011=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A012=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A013=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A014=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A015=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0xff]=A0SCB_LUN[0xff]=A0SC=
B_TAG[0xff]
=A0Zeus=A0Pending=A0list:
=A0Zeus=A03=A0SCB_CONTROL[0x0]=A0SCB_SCSIID[0x57]=A0SCB_LUN[0x0]
=A0Zeus=A0Kernel=A0Free=A0SCB=A0list:=A01=A00
=A0Zeus=A0Untagged=A0Q(5):=A03
=A0Zeus=A0DevQ(0:5:0):=A00=A0waiting
=A0Zeus
=A0Zeus=A0<<<<<<<<<<<<<<<<<=A0Dump=A0Card=A0State=A0Ends=A0>>>>>>>>>>>>=
>>>>>>
=A0Zeus=A0scsi0:0:5:0:=A0Device=A0is=A0active,=A0asserting=A0ATN
=A0Zeus=A0(scsi0:A:5:0):=A0Abort=A0Message=A0Sent
=A0Zeus=A0Recovery=A0code=A0sleeping
=A0Zeus=A0(scsi0:A:5:0):=A0SCB=A03=A0-=A0Abort=A0Completed.
=A0Zeus=A0Recovery=A0SCB=A0completes
=A0Zeus=A0Recovery=A0code=A0awake
=A0Zeus=A0aic7xxx_abort=A0returns=A00x2002
=A0Zeus=A0(scsi0:A:5):=A010.000MB/s=A0transfers=A0(10.000MHz,=A0offset=A0=
8)
=A0Zeus=A0Vendor:=A0PIONEER=A0=A0=A0Model:=A0DVD-ROM=A0DVD-303F=A0=A0Re=
v:=A02.00
=A0Zeus=A0Type:=A0=A0=A0CD-ROM=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ANSI=A0SCSI=A0revision:=A0=
02
=A0Zeus=A0sr0:=A0scsi3-mmc=A0drive:=A00x/0x=A0cd/rw=A0xa/form2=A0cdda=A0=
tray
=A0Zeus=A0Attached=A0scsi=A0CD-ROM=A0sr0=A0at=A0scsi0,=A0channel=A00,=A0=
id=A05,=A0lun=A00
=A0Zeus=A0Attached=A0scsi=A0generic=A0sg0=A0at=A0scsi0,=A0channel=A00,=A0=
id=A05,=A0lun=A00,=A0=A0type=A05


=A0=A0---------kernel=A02.6.7=A0with=A0Gibbs=A0aic7xxx=A0driver--------=
----
=A0
=A0Zeus=A0scsi0=A0:=A0Adaptec=A0AIC7XXX=A0EISA/VLB/PCI=A0SCSI=A0HBA=A0D=
RIVER,=A0Rev=A06.3.9
=A0Zeus=A0<Adaptec=A02940=A0Ultra=A0SCSI=A0adapter>
=A0Zeus=A0aic7880:=A0Ultra=A0Single=A0Channel=A0A,=A0SCSI=A0Id=3D7,=A01=
6/253=A0SCBs
=A0Zeus
=A0Zeus=A0Vendor:=A0PIONEER=A0=A0=A0Model:=A0DVD-ROM=A0DVD-303F=A0=A0Re=
v:=A02.00
=A0Zeus=A0Type:=A0=A0=A0CD-ROM=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ANSI=A0SCSI=A0revision:=A0=
02
=A0Zeus=A0sr0:=A0scsi3-mmc=A0drive:=A00x/0x=A0cd/rw=A0xa/form2=A0cdda=A0=
tray
=A0Zeus=A0Attached=A0scsi=A0CD-ROM=A0sr0=A0at=A0scsi0,=A0channel=A00,=A0=
id=A05,=A0lun=A00
=A0Zeus=A0Attached=A0scsi=A0generic=A0sg0=A0at=A0scsi0,=A0channel=A00,=A0=
id=A05,=A0lun=A00,=A0=A0type=A05

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
