From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Mon, 25 Jul 2005 21:49:14 +0100
Message-ID: <E1Dx9sw-0007rV-9G@sledge.mossbank.org.uk>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net> <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk> <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:18701 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S261571AbVGYUtV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 16:49:21 -0400
In-Reply-To: <Pine.LNX.4.63.0507251231290.23540@hotblack.deepthot.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: denebeim@deepthot.org
Cc: linux-scsi@vger.kernel.org

Jay Denebeim wrote:
>On Mon, 25 Jul 2005, Steve McIntyre wrote:
>
>> Jay Denebeim wrote:
>>>
>>> I'm a little confused here.  Tape devices have variable sector sizes.
>>> I believe they're required to handle up to 64K in a unix environment.
>>> The drives I work on go up to 256k.
>>
>> Tapes are different. The UDO drive that Johann was asking about is an
>> optical _disk_ drive...
>
>Yeah, I got that.  I wasn't going to say anything until he mentioned using 
>the tape driver with it.  Is the UDO drive presenting itself as a tape or 
>as a disk?

It's a disk, SCSI type 7 (optical). The tape thing is a red herring,
IMHO.

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
You lock the door
And throw away the key
There's someone in my head but it's not me 
