From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 12:41:33 +0200
Message-ID: <BANLkTi=QOSDOvgfXX9qqgdmOSicQpV4ViA@mail.gmail.com>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com>
	<BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
	<4DCD09D9.4080702@die-jansens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54196 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab1EMKle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 06:41:34 -0400
Received: by qwk3 with SMTP id 3so1214707qwk.19
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2011 03:41:33 -0700 (PDT)
In-Reply-To: <4DCD09D9.4080702@die-jansens.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Jansen <lists@die-jansens.de>
Cc: linux-scsi@vger.kernel.org

That is something I really don't like.

After more checking I noticed the /dev/disk/by-path doesn't have any
links for the disks and their slots anymore.

Kind regards,

Caspar Smit
Systemengineer
True Bit Resources B.V.
Amp=E8restraat 13E
1446 TP=A0 Purmerend

T: +31(0)299 410 475
=46: +31(0)299 410 476
@: c.smit@truebit.nl
W: www.truebit.nl




2011/5/13 Arne Jansen <lists@die-jansens.de>:
> On 13.05.2011 12:34, Caspar Smit wrote:
>> I tried with Debian Squeeze with the latest backports kernel 2.6.38,
>> which has mpt2sas version 07.100.00.00
>> and now the disks are ordered this way:
>>
>> /dev/sdb =3D slot 3
>> /dev/sdc =3D slot 2
>> /dev/sdd =3D slot 1
>> /dev/sde =3D slot 0
>> /dev/sdf =3D slot 7
>> /dev/sdg =3D slot 6
>> /dev/sdh =3D slot 5
>> /dev/sdi =3D slot 4
>
> I see something similar here, and, what's worse, the order may very f=
rom
> boot to boot.
>
> -Arne
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
