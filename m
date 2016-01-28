From: Laurence Oberman <loberman@redhat.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 18:23:13 -0500 (EST)
Message-ID: <1586705024.9989294.1454023393133.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:43861 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbcA1XXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 18:23:31 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shane M Seymour <shane.seymour@hpe.com>
Cc: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org

On My DAT tape with the latest patch


[root@srp-server ~]# cat /sys/class/scsi_tape/st0/device/scsi_level
4

[root@srp-server ~]# mt -f /dev/st0 stsetoption can-partitions

Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 - 1=
6777215 bytes.
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Length=
 11, medium 0, WBS 10, BLL 8
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape l=
ength: 0, drv buffer: 1
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, buf=
fer size: 4096 (1 blocks).
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Mode 0 options: bu=
ffer writes: 1, async writes: 1, read ahead: 1
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0]     can bsr: 1, tw=
o FMs: 0, fast mteom: 0, auto lock: 0,
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0]     defs for wr: 0=
, no block limits: 0, partitions: 1, s2 log: 0
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0]     sysv: 0 nowait=
: 0 sili: 0 nowait_filemark: 0
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0]     debugging: 1
Jan 28 18:17:49 srp-server kernel: st 6:0:1:0: [st0] Rewinding tape.

[root@srp-server ~]# mt -f /dev/st0 mkpartition 1000

Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 - 1=
6777215 bytes.
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Length=
 11, medium 0, WBS 10, BLL 8
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape l=
ength: 0, drv buffer: 1
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, buf=
fer size: 4096 (1 blocks).
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Loading tape.
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Error: 8000002, cm=
d: 0 0 0 0 0 0
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Sense Key : Unit A=
ttention [current]
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Add. Sense: Not re=
ady to ready change, medium may have changed
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 - 1=
6777215 bytes.
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Length=
 11, medium 0, WBS 10, BLL 8
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape l=
ength: 0, drv buffer: 1
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, buf=
fer size: 4096 (1 blocks).
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Partition page len=
gth is 10 bytes.
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] PP: max 1, add 0, =
xdp 0, psum 02, pofmetc 0, rec 03, units 00, sizes: 0 65535
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] MP: 11 08 01 00 10=
 03 00 00 00 00 ff ff
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] psd_cnt 2, max.par=
ts 1, nbr_parts 0
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Formatting tape wi=
th two partitions (1 =3D 1000 MB).
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Sent partition pag=
e length is 12 bytes. needs_format: 0
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] PP: max 1, add 1, =
xdp 1, psum 02, pofmetc 0, rec 03, units 00, sizes: 65535 1000
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] MP: 11 0a 01 01 30=
 03 00 00 ff ff 03 e8
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Error: 8000002, cm=
d: 15 10 0 0 18 0
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Sense Key : Illega=
l Request [current]
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Add. Sense: Invali=
d field in parameter list
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Partitioning of ta=
pe failed.
Jan 28 18:18:01 srp-server kernel: st 6:0:1:0: [st0] Rewinding tape.



Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Shane M Seymour" <shane.seymour@hpe.com>
To: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
Cc: "Laurence Oberman" <loberman@redhat.com>, "Emmanuel Florac" <eflora=
c@intellique.com>, "Laurence Oberman" <oberman.l@gmail.com>, linux-scsi=
@vger.kernel.org
Sent: Thursday, January 28, 2016 6:12:41 PM
Subject: RE: What partition should the MTMKPART argument specify? Was: =
Re: st driver doesn't seem to grok LTO partitioning

Hi Kai,

$ pwd
/sys/class/scsi_tape/st1/device
$ cat scsi_level
4

Thanks
Shane

> -----Original Message-----
> From: "Kai M=C3=A4kisara (Kolumbus)" [mailto:kai.makisara@kolumbus.fi=
]
> Sent: Friday, January 29, 2016 4:04 AM
> To: Seymour, Shane M
> Cc: Laurence Oberman; Emmanuel Florac; Laurence Oberman; linux-
> scsi@vger.kernel.org
> Subject: Re: What partition should the MTMKPART argument specify? Was=
:
> Re: st driver doesn't seem to grok LTO partitioning
>=20
>=20
> > On 28.1.2016, at 9.36, Seymour, Shane M <shane.seymour@hpe.com>
> wrote:
> >
> > Hi Kai,
> >
> > With the changes the I get a failure partitioning a HP DAT72 drive =
(DDS-5):
> >
> > # ./mt -f /dev/st1 stsetoption debug
> > # ./mt -f /dev/st1 stsetoption can-partitions # ./mt -f /dev/st1
> > mkpartition 1000
> > /dev/st1: Input/output error
> >
> ...
> > [ 3976.389605] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> > [ 3976.389610] st 6:0:3:0: [st1] PP: max 1, add 0, xdp 0, psum 02,
> > pofmetc 0, rec 03, units 00, sizes: 0 65535 [ 3976.389614] st 6:0:3=
:0:
> > [st1] MP: 11 08 01 00 10 03 00 00 00 00 ff ff [ 3976.389618] st
> > 6:0:3:0: [st1] psd_cnt 2, max.parts 1, nbr_parts 0
>                                                      ^^^^^^^^^ The pr=
oblem is here
>=20
> ...
> > Using a slightly older kernel to partition the DAT72 drive works (s=
ame 3
> commands as above):
> ...
> > [  351.584906] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> > [  351.584908] st 6:0:3:0: [st1] psd_cnt 1, max.parts 1, nbr_parts =
0
>=20
> The old driver computes the psd_cnt from the returned page length. Th=
e
> same applies to the patched driver if the SCSI level of the device < =
SCSI_3.
> This works correctly with my drive that reports SCSI_2. So, the quest=
ion is:
> what SCSI level does your device report?
>=20
> Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
