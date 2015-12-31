From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 31 Dec 2015 18:08:01 +0200
Message-ID: <AC6651F8-0642-42DF-A3B1-72C5A8D8E665@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi> <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr> <20151229175859.0c2c9b91@harpe.intellique.com> <8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi> <20151229191347.2e0e5f0e@harpe.intellique.com> <alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr> <20151230193309.0df94c88@harpe.intellique.com> <D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi> <20151230222418.03e40cf7@harpe.intellique.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs17.mail.saunalahti.fi ([62.142.117.198]:37248 "EHLO
	vs17.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbLaQIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Dec 2015 11:08:06 -0500
In-Reply-To: <20151230222418.03e40cf7@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org


> On 30.12.2015, at 23.24, Emmanuel Florac <eflorac@intellique.com> wro=
te:
>=20
> Le Wed, 30 Dec 2015 21:21:47 +0200
> "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi> =C3=A9criva=
it:
>=20
>> This happens if the position is not at the beginning of partition 0.
>> Could you try to switch to partition 0:
>> mt -f /dev/nst0 setpartition 0
>> mt -f /dev/nst0 status
>>=20
>> and the retry partitioning.
>=20
> Alas, no dice:
>=20
OK.

In the HP LTFS sources I found an interesting detail: the code does LOA=
D before unformatting.
A comment says that it is in some cases better method to put the positi=
on to beginning of
partition 0 than other methods. You could try =E2=80=98mt load=E2=80=99=
 before trying to partition.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
