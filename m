From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 16:02:38 -0400
Message-ID: <4357F7DE.7050004@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com> <20051020170330.GA16458@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42986 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932517AbVJTUCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 16:02:52 -0400
In-Reply-To: <20051020170330.GA16458@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 13:03, Christoph Hellwig wrote:
>>I'd suggest a reading of the SDI, SAS and SAM specs for an insight
>>of how it all ties together.
> 
> 
> Thanks Luben.  You might not be able to imagine it, but there are people
> other than you who are able to read specs, and despite having read them
> they can actually talk like a normal human without referencing them in
> every second sentence.  That beeing said SDI is not a final
> specification.  It's a draft that's probablt not going to make it as a
> t10 standard because the main pushers have backed of a bit again.

The whole point is that LSI/HP/Adaptec are _using_ SDI in one form
or another and would like to have it officially in the kernel.

> We are not going to implement SDI in the kernel.  Long before SDI or

Who is "we"?

> it's predecessor, HP CSMI were designed we made it clear we're not going
> to accept wide ioctl-APIs, especially when they're even bad for old

You do not have to take section 4 of SDI literally, but what everyone
wants is the _functionality_ of section 5 of SDI.  That can be implemented
as a backend, see my next message to Arjan on this thread, and the front
end can be anything at all (sg/sysfs/whatever1/whatever2).

> ioctl API standards.  The CSMI spec has been passed around in an early
> phase and been totally rejected, I think even publically on linux-scsi.

Rejected by whom?  "The community" or by you?

Let me understand this properly: LSI/HP/Adaptec are using SDI in one
form or another and would like to see something like it in the kernel,
but "the community", the "we" you refer to above, rejects it?

> HP decided to move ahead despite that and did a huge mis-services to
> their customers.

Yes, because there is a _need_ for it.

> It's not my problem if big companies can't listen and do things their
> customers have to pay for, and it's certainly not our job to work
> around their idiocy.

Bold statment.

Who should "big companies" listen to?  You?  "The community?"
Are you saying "big companies" whould listen to Linux which
says "no to specs" among other things?

Often enough what "big companies" agree on and use and deploy is
what Linux (you?) should _listen_ to, try to understand and maybe
get out of the way.

It is all about customer satisfaction, which is completely
foreign to Linux, simply because of the _nature_ of Linux.

Why is there a need to _reinvent_ things?
Aren't there engineers at those "big companies" who know
OS design and programming?

Why do you feel the need to antiquate engineers from
companies submitting drivers/patches/solutions to the
Linux kernel?

Surely this isn't good for the Linux kernel in the long term.
Or is it?

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
