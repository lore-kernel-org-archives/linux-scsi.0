From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 20:06:04 -0500
Message-ID: <1306371965.1641.79.camel@mulgrave.site>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
	 <4DDB8BF6.2000304@fusionio.com>
	 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
	 <4DDCB1C8.7040708@fusionio.com>
	 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
	 <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
	 <4DDD5240.2060308@fusionio.com>
	 <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
	 <4DDD55D6.1080909@fusionio.com>
	 <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
	 <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
	 <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
	 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>
	 <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
	 <1306356735.1641.61.camel@mulgrave.site>
	 <BANLkTimuomu=_JuMr7SWrMVvboMX4BX0fA@mail.gmail.com>
	 <1306370123.1641.76.camel@mulgrave.site>
	 <BANLkTi=YW91=mj6KVUia6ykgEJ8DNEmbUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44430 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110Ab1EZBGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2011 21:06:09 -0400
In-Reply-To: <BANLkTi=YW91=mj6KVUia6ykgEJ8DNEmbUA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, 2011-05-25 at 18:01 -0700, Linus Torvalds wrote:
> On Wed, May 25, 2011 at 5:35 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote: > > Jens, can you look
> at this, please ... would you prefer a separate DEAD > test instead? 
> Incidentally, this is in addition to the other DEAD test > you still
> haven't applied ...
> 
> Ugh.
> 
> Can you please just always set STOPPED at the same time you set DEAD?

Well, Jens wondered the same thing in this thread:

http://marc.info/?l=linux-scsi&m=130632292705404

It's just an RFC patch to see if I can fix an oops ... how it's
ultimately implemented will be up to Jens.

James


