From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Mon, 25 Jul 2005 21:50:46 +0100
Message-ID: <E1Dx9uQ-0007t0-86@sledge.mossbank.org.uk>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net> <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk> <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:21261 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S261613AbVGYUur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 16:50:47 -0400
In-Reply-To: <200507260038.22820.jhml@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jhml@gmx.net
Cc: linux-scsi@vger.kernel.org

In article <200507260038.22820.jhml@gmx.net> you write:
>> >I'm a little confused here.  Tape devices have variable sector sizes.
>> >I believe they're required to handle up to 64K in a unix environment.
>> >The drives I work on go up to 256k.
>> Tapes are different. The UDO drive that Johann was asking about is an
>> optical _disk_ drive...
>Hmm... would it be _possible_ to support it as tape device (/dev/st* 
>and /dev/nst*)?

Not that I'm aware, no. It's not designed to be used as a tape at
all. To be honest, if you want a device that looks like a tape,
then... :-)

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
Into the distance, a ribbon of black
Stretched to the point of no turning back
