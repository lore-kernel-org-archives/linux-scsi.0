From: =?ISO-8859-1?Q?Gustavo_Mart=EDn?= <gmartin@filmayer.es>
Subject: Re: Problems with SCSI device
Date: Thu, 27 Mar 2003 17:49:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E832BB2.8070707@filmayer.es>
References: <200303261713.h2QHDXLr090443@mail5.mx.voyager.net> <3E81E9A9.5040502@filmayer.es> <Pine.LNX.4.52.0303262017410.2462@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi again,

after executing stinit /dev/st0, this is what I can see in the log.....=
=2E

[root@ns2 root]# dmesg
(scsi0:A:5): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
st0: Block limits 8 - 589576 bytes.
(scsi0:A:5): 3.300MB/s transfers
(scsi0:A:5): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
st0: Mode 0 options: buffer writes: 1, async writes: 1, read ahead: 1
st0:    can bsr: 1, two FMs: 0, fast mteom: 0, auto lock: 1,
st0:    defs for wr: 0, no block limits: 0, partitions: 0, s2 log: 1
st0:    sysv: 0 nowait: 0
st0: Compression default set to 1
st0: Error with sense data: Info fld=3D0x8000800 (nonstd), Current=20
st09:00: sense
key Aborted Command

Stinit replays: "Can't find defaults for tape number 0. Definitions for=
=20
/dev/st0 failed"
These are my defaults in stinit.def file:

manufacturer=3DQUANTUM model=3D"DLT8000" revision=3D0250
{
scsi2logical=3D1
mode1 compresion=3D1
buffering=3D1 async-writes=3D1 read-ahead=3D1
can-bsr=3D1 two-fms=3D0 fast-eom=3D0 auto-lock=3D1
defs-for-writes=3D0 noblklimits=3D0 can-partitions=3D0
sysv=3D0 no-wait=3D0
}

Where can be now the problem?

Thanks,
GUSTAVO

Kai Makisara wrote:

>On Wed, 26 Mar 2003, Gustavo Mart=EDn wrote:
>
> =20
>
>>Hi again,
>>
>>I made some changes on my .def file. The manufacturer, model, etc see=
ms
>>to be correct. I changed the modes and now I recive errno 5, can't op=
en
>>tape device /dev/nst0.
>>
>>I'm getting crazy with this stuff. Any other idea?
>>
>>   =20
>>
>What messages do you see in the system log (or with dmesg)? What are t=
he
>definitions in stinit.def? Are you defining 'can-partitions'?
>
> =20
>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
