From: =?ISO-8859-1?Q?Gustavo_Mart=EDn?= <gmartin@filmayer.es>
Subject: Re: Problems with SCSI device
Date: Thu, 27 Mar 2003 09:22:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E82B4BD.4050506@filmayer.es>
References: <200303261713.h2QHDXLr090443@mail5.mx.voyager.net> <3E81E9A9.5040502@filmayer.es> <Pine.LNX.4.52.0303262017410.2462@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

It says:
    kmod: failed  to exec /sbin/modprobe -s -k scsi_hostadapter, errno =
=3D 2
 =20
After, loads the HBA driver correctly.
It also says:  Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0.

In the .def file, I have configured the manufacturer, model and=20
revision, scsi2logical, can-bsr can-partitions and auto-lock. Of course=
,=20
I have configured the modes

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
