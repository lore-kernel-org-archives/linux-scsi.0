From: =?ISO-8859-1?Q?John_Damm_S=F8rensen?= <john@hovedpuden.dk>
Subject: Re: /dev/[*]st* does not work with EXBAYTE 8505 with 2.6 kernels
Date: Wed, 25 Aug 2004 23:58:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412D0B89.5040301@hovedpuden.dk>
References: <412C315D.1000708@hovedpuden.dk>    <Pine.LNX.4.58.0408252225550.1974@kai.makisara.local> <28477.192.48.171.17.1093467320.squirrel@192.48.171.17> <Pine.LNX.4.58.0408260015100.1974@kai.makisara.local>
Reply-To: john@hovedpuden.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:1033 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S263962AbUHYV7s
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 17:59:48 -0400
In-Reply-To: <Pine.LNX.4.58.0408260015100.1974@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:

>On Wed, 25 Aug 2004, John Damm S=F8rensen wrote:
>
>...
> =20
>
>>>If you look at the kernel messages, do you see something like this:
>>>
>>>st: Version 20040403, fixed bufsize 32768, s/g segs 256
>>>Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
>>>st0: try direct i/o: yes (alignment 512 B), max page reachable by HB=
A
>>>268435455
>>>     =20
>>>
>>Yes, I see this message in dmesg.
>>
>>   =20
>>
>OK, st has attached the drive.
>
>...
> =20
>
>>With 2.6 the tape  drive fails to work with the Qlogic HBA's ISP1040 =
(the
>>HBA simply doesn't work with 2.6) and QLA12160, but it works with the
>>Symbios/LSI HBA.
>>
>>   =20
>>
>So, the problem is specific to the Qlogic adapters. Do you see any SCS=
I=20
>error messages? (When st has attached the drive, the device should be=20
>present. If it is offlined by failing SCSI error recovery, the device=20
>disappears again.)
>
> =20
>
No, I see no error messages with QLA12160 HBA everything seems to be OK=
,=20
except that I cannot access the device. I am able to access=20
/proc/scsi/sg/device_strs and read the device string for the tape. As=20
for the ISP1040 the qlogicisp driver simply prevents the system from=20
mounting the root fs, even though the fs resides on an IDE disk.
BTW. The QLA1260 is now being used in my PS with WIN98 and seem to work=
=20
OK with a SCSI disk.
/John

--=20
John Damm S=F8rensen, Stenkrogen 6, DK-2800 Kgs. Lyngby, 4498 6995

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
