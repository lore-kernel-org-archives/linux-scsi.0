From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [RFQ] New driver architecture questions
Date: Fri, 15 May 2009 11:01:33 +1000
Message-ID: <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
	<4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
	<4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:27366 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZEOBBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 21:01:52 -0400
In-Reply-To: <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 15, 2009 at 10:58, adam radford <aradford@gmail.com> wrote:
> On Wed, May 13, 2009 at 9:16 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Taking drivers/net/e1000e as an
>> example,
>>
>> =A0 =A0 =A0 =A0hw.h =A0 =A0 =A0 =A0 =A0 =A0hardware-specific defines=
, ~cross-OS
>> =A0 =A0 =A0 =A082571.c =A0 =A0 =A0 =A0 code specific to 8257x chip f=
amily, ~cross-OS
>
> 82571.c contains Linux specific code such as: =A0including Linux
> specific header files, calls to msleep().
>
>> =A0 =A0 =A0 =A0ich8lan.c =A0 =A0 =A0 code specific to ICH8+ chip fam=
ily, ~cross-OS
>
> ich8lan.c contains Linux specific code such as: =A0might_sleep(),
> mutex_trylock(), mutex_unlock(), udelay(), msleep(), writel(), readl(=
).
>
> Perhaps this is a bad example? =A0It seems like the "common layer"
> sections that are "cross-OS" shouldn't contain any Linux specific cod=
e at all.

I think the implication is that the cross-OS parts are coded, as it
happens, in the linux coding style, using linux functions, but then a
Windows layer maps these to Windows specific functions.

E.g. msleep(), mutex_trylock(), etc are implemented in the Windows
layer by mapping them to the Windows functions to do the same.

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
