From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
Date: Tue, 26 Feb 2008 10:20:10 +0800
Message-ID: <000901c8781e$1cb6e780$8800a8c0@Nick>
References: <751a4f870802251451k2f6355d0o110d74cd226f0f84@mail.gmail.com>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:34730 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850AbYBZCUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 21:20:14 -0500
In-Reply-To: <751a4f870802251451k2f6355d0o110d74cd226f0f84@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Aron Stansvik' <elvstone@gmail.com>, 'erich' <erich@areca.com.tw>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Aron,
Thanks for your patience.
If you still got into trouble, please let me know.
Thank you again,
-----Original Message-----
=46rom: Aron Stansvik [mailto:elvstone@gmail.com]=20
Sent: Tuesday, February 26, 2008 6:52 AM
To: erich
Cc: nick.cheng@areca.com.tw; akpm@linux-foundation.org;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1

Hi Erich.

2008/2/25, nickcheng <nick.cheng@areca.com.tw>:
> Hi Aron,
>  From our field experiences and customers' feedbacks, all of them dir=
ect
to
>  vibration and power issues.
>  The vibration could be caused by FANs not only by themselves.

Okay. I have a chassi fan that is quite close to the drives, I will
try disabling it. I've also ordered two Nexus TwinDisk anti vibration
harddrive mounts with which I'll place the disks in my 5.25" slots
instead, away from any fans.

If this doesn't work, I'm stumped, as I really don't think it's the
power supply and I don't have the money to buy a new one.

>  You mentioned it could be the F/W issue.
>  If the environment does not meet the prerequisite, FW could not work
>  correctly.
>  Actually FW just reacts to the situations not it causes the issue.

Of course, I understand this. Just trying to figure this problem out..

>  Please check it out!!

I'll report back with my findings with moving disk away from fans and
using anti-vibrations mounts.

Thanks for taking your time to reply.

Aron

>  Thank you,
>
>
>  -----Original Message-----
>  From: Aron Stansvik [mailto:elvstone@gmail.com]
>  Sent: Sunday, February 24, 2008 1:54 AM
>  To: nick.cheng@areca.com.tw
>  Cc: erich; akpm@linux-foundation.org; linux-scsi@vger.kernel.org;
>  linux-kernel@vger.kernel.org
>
> Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
>
>  Hello again Areca and LKML hackers.
>
>  2008/2/18, Aron Stansvik <elvstone@gmail.com>:
>  > Hello Nick.
>  >
>  >  Sorry that I'm not answering until now. I've been busy.
>  >
>  >  2008/2/13, nickcheng <nick.cheng@areca.com.tw>:
>  >
>  > > Hi Aron,
>  >  >  From our experience and some customers' feedback, your issue c=
ould
be
>  caused
>  >  >  by power instability or vibration to your HDs.
>  >  >  Please check step by step:
>  >  >  (1).under your original environment, increase the SCSI command
value,
>  >  >  default=3D30, with the shell script, set_scsicmd_timeout(). 90=
 or 120
is
>  >  >  enough.
>  >  >  (2).if method 1 does not work, find out the vibration source o=
r
change
>  the
>  >  >  power supply
>  >
>  >
>  > I will try to increase that value. I don't think it's vibration; t=
he
>  >  disks are firmly in place in a very heavy chassi (Silverstone
>  >  SST-TJ05B-T). And I really don't think there's something wrong wi=
th
>  >  the power supply, it's a pretty new Silverstone ST65ZF 650W. This=
 is
>  >  my own personal workstation, so I don't just have another power s=
upply
>  >  to test with :/
>  >
>  >  I will report back on my success/failure. Thanks for your answer.
>
>  I've now tried with both 90 and 120 for the timeout value, and the
>  problem still persists. It seems to happen when lots of small writes
>  are occuring, e.g. when installing something.
>
>  I really don't think the disks are vibrating, I don't see how they
>  could. One more thing I'm going to test is to use the legacy ATA pow=
er
>  connector instead of the SATA power connector. This was what I was
>  using before when I only had a single drive and no RAID controller.
>  Maybe my power supply is malfunctioning and not giving enough power =
on
>  the SATA power connectors.. but I doubt it.
>
>  Is there anything else that could cause this? Have you guys at Areca
>  tested the ARC-1200 with Raptors in RAID1?
>
>  :(
>
>  Regards,
>  Aron
>
>  >
>  >
>  >  Aron
>  >
>  >
>  >  >  If your still have any questions, please feel free to let me k=
now.
>  >  >
>  >  >  P.S. The attached driver source, arcmsr-1.20.00.15-71224, has =
been
>  >  >  upstreamed to kernel.org and will be released in kernel 2.6.25=
=2E If
you
>  like,
>  >  >  you could update your driver with it.
>  >  >  It fixes some minor bugs, but these bugs are nothing to do wit=
h
your
>  issue.
>  >  >
>  >  >
>  >  >  -----Original Message-----
>  >  >  From: erich [mailto:erich@areca.com.tw]
>  >  >  Sent: Wednesday, February 13, 2008 4:33 PM
>  >  >  To: (=BCs=A6w=AC=EC=A7=DE)=BEG=A6u=C1=BE
>  >  >  Subject: Fw: Aborted commands with arcmsr and 2xWD1500ADFD in =
RAID1
>  >  >
>  >  >
>  >  >
>  >  >  ----- Original Message -----
>  >  >  From: "Andrew Morton" <akpm@linux-foundation.org>
>  >  >  To: "Aron Stansvik" <elvstone@gmail.com>
>  >  >  Cc: <linux-kernel@vger.kernel.org>; <linux-scsi@vger.kernel.or=
g>;
>  "erich"
>  >  >  <erich@areca.com.tw>
>  >  >  Sent: Wednesday, February 13, 2008 4:03 PM
>  >  >  Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in =
RAID1
>  >  >
>  >  >
>  >  >  >
>  >  >  > (cc's added)
>  >  >  >
>  >  >  > On Mon, 11 Feb 2008 17:44:08 +0100 "Aron Stansvik"
>  <elvstone@gmail.com>
>  >  >  > wrote:
>  >  >  >
>  >  >  >> Hello LKML.
>  >  >  >>
>  >  >  >> Under semi-high disk I/O (e.g. installing a compiled KDE), =
I get
>  the
>  >  >  >> following (accompanied by seconds of lock-ups on the machin=
e):
>  >  >  >>
>  >  >  >> [ 7727.345183] arcmsr0: abort device command of scsi id =3D=
 0 lun
=3D 0
>  >  >  >> [ 7730.348776] arcmsr0:                 scsi id =3D 0 lun =3D=
 0 ccb
=3D
>  >  >  >> '0xdfb461c0' poll command abort successfully
>  >  >  >> [ 8053.795943] arcmsr0: abort device command of scsi id =3D=
 0 lun
=3D 0
>  >  >  >> [ 8056.799528] arcmsr0:                 scsi id =3D 0 lun =3D=
 0 ccb
=3D
>  >  >  >> '0xdfb595e0' poll command abort successfully
>  >  >  >> [ 8884.592810] arcmsr0: abort device command of scsi id =3D=
 0 lun
=3D 0
>  >  >  >> [ 8887.596392] arcmsr0:                 scsi id =3D 0 lun =3D=
 0 ccb
=3D
>  >  >  >> '0xdfb56d80' poll command abort successfully
>  >  >  >> [ 8917.760216] arcmsr0: abort device command of scsi id =3D=
 0 lun
=3D 0
>  >  >  >> [ 8920.763797] arcmsr0:                 scsi id =3D 0 lun =3D=
 0 ccb
=3D
>  >  >  >> '0xdfb472c0' poll command abort successfully
>  >  >  >> [ 9074.106547] arcmsr0: abort device command of scsi id =3D=
 0 lun
=3D 0
>  >  >  >>
>  >  >  >> This is my setup:
>  >  >  >>
>  >  >  >> 1 x MSI K8N Master2-FAR
>  >  >  >> 1 x Opteron 252
>  >  >  >> 1 x Areca ARC1200 (sitting in a PCIe x4 socket)
>  >  >  >> 2 x WD1500ADFD in RAID1
>  >  >  >>
>  >  >  >> astan@rubik:~$ uname -a
>  >  >  >> Linux rubik 2.6.24-7-generic #1 SMP Thu Feb 7 01:29:58 UTC =
2008
>  i686
>  >  >  >> GNU/Linux
>  >  >  >> astan@rubik:~$ modinfo arcmsr
>  >  >  >> filename:
>  >  >  >> /lib/modules/2.6.24-7-generic/kernel/drivers/scsi/arcmsr/ar=
cmsr.
ko
>  >  >  >> version:        Driver Version 1.20.00.15 2007/08/30
>  >  >  >> license:        Dual BSD/GPL
>  >  >  >> description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAI=
D
HOST
>  Adapter
>  >  >  >> author:         Erich Chen <support@areca.com.tw>
>  >  >  >> srcversion:     28EAD6AB49D4491CA04D465
>  >  >  >> [...]
>  >  >  >>
>  >  >  >> I've read some previous posts here on LKML that it could be=
 the
>  Areca
>  >  >  >> firmware who doesn't like my WD disks. Anyone know if this =
is an
>  IRQ
>  >  >  >> handling problem in the kernel, or if it's a problem with t=
he
RAID
>  >  >  >> controller firmware?
>  >  >  >>
>  >  >  >> Erich Chen (of Areca); have you tried the new ARC1200 in RA=
ID1
>  >  >  >> configuration with Raptor disks on Linux?
>  >  >  >>
>  >  >  >> As a side note, I can tell you that I first tried running
=46reeBSD
>  6.3
>  >  >  >> (RELENG_6) on this machine, but got random reboots during d=
isk
I/O
>  >  >  >> (even with a kernel with KDB debugging turned on). This lea=
ds me
to
>  >  >  >> believe that it might be a firmware issue, and that Linux j=
ust
>  handles
>  >  >  >> it more gracefully than FreeBSD.
>  >  >  >>
>  >  >  >> Any ideas or advice is appriciated. This is my first post t=
o the
>  LKML,
>  >  >  >> so please instruct me if you want more information or if yo=
u
want
>  me
>  >  >  >> to take further debugging actions.
>  >  >  >>
>  >  >  >> Best regards,
>  >  >  >> Aron Stansvik
>  >  >  >
>  >  >
>  >  >
>  >
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
