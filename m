From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: Large disk drives
Date: Sat, 8 Nov 2014 09:35:47 +0900 (JST)
Message-ID: <273787.22163.qm@web100014.mail.kks.yahoo.co.jp>
References: <533357.25557.qm@web100006.mail.kks.yahoo.co.jp> <063D6719AE5E284EB5DD2968C1650D6D1C9EAE8F@AcuExch.aculab.com>
Reply-To: Norman Diamond <n0diamond@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100014.mail.kks.yahoo.co.jp ([114.111.98.188]:44294 "HELO
	web100014.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752315AbaKHAfu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 19:35:50 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9EAE8F@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

=46rom: David Laight
>=20
> From: Norman Diamond
> ...
>>  By the way, I've seen some USB bridges that lie about whether they
>>  performed various SAT commands (ATA passthrough), but told the trut=
h
>>  about performing an ATA IDENTIFY DEVICE through SAT.=A0 So we could=
 attempt
>>  ATA passthrough with an IDENTIFY DEVICE command, and if it happens =
to
>>  return a sane looking result, we could comparre it to the bridge's =
own
>>  translation of READ_CAPACITY_10 and READ_CAPACITY_16.=A0 If the pas=
sthrough
>>  yielded a sane result and the capacity doesn't match, we know not t=
o
>>  trust the bridge with 16-byte commands (except if tested, as mentio=
ned).
>>  In such a case, we don't even have to look at the partition table.=A0=
 Of
>>  course if the ATA passthrough fails or if the result is garbage the=
n
>>  abandon this test and maybe look at the partition table.
> ...
>=20
> Don't count on devices answering ATA IDENTIFY correctly either.
=A0
Of course.=A0 That's why you quoted me saying this:
=A0
>> Of
>>  course if the ATA passthrough fails or if the result is garbage the=
n
>>  abandon this test and maybe look at the partition table.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
