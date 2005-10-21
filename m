From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 13:32:51 -0400
Message-ID: <43592643.2010701@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63716 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965035AbVJURdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 13:33:07 -0400
In-Reply-To: <1129852879.30258.137.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 20:01, Andrew Patterson wrote:
> 
> My guess is that what current app writers want is to use IOCTL's so they
> don't have to special-case Linux.  Next best thing would be something
> that closely approaches it, to avoid re-writing a lot of code.  

"to avoid re-writing a lot of code." is also what I'm driving at.
I'm sure HP as well as LSI have a lot of user space programs using
the SDI interface.

>>Rejected by whom?  "The community" or by you?
> 
> 
> I believe there is a common understanding that IOCTL's are bad and
> should be avoided. See:
> 
> http://lkml.org/lkml/2001/5/20/81

I wasn't talking about IOCTLs.  I was talking in general about the
SDI spec.  As you can see for yourself, I suggested an SDI interface
which is agnostic to the front end.

>>>HP decided to move ahead despite that and did a huge mis-services to
>>>their customers.
> 
> 
> Perhaps.  Given that there seems to be no alternative, we don't have
> much of a choice.

Please do *NOT* cross-reply.  It was Christoph who said that, NOT ME.

>>>It's not my problem if big companies can't listen and do things their
>>>customers have to pay for, and it's certainly not our job to work
>>>around their idiocy.
> 
> 
> Yes, CSMI should have had more Linux input when it was developed.  The
> no-new IOCTL policy certainly came as a surprise to the authors. Still,
> there doesn't seem to be any other usable cross-platform interface that
> is acceptable to the linux community (or at least to Christoph)'s corner
> of it).  My personal preference is to hide this stuff in a library, so
> the kernel implementation is hidden. But even a library needs an
> underlying kernel implementation.

Please do *NOT* cross-reply.  It was Christoph who said that, NOT ME.

>>Bold statment.
>>
>>Who should "big companies" listen to?  You?  "The community?"
>>Are you saying "big companies" whould listen to Linux which
>>says "no to specs" among other things?
>>
>>Often enough what "big companies" agree on and use and deploy is
>>what Linux (you?) should _listen_ to, try to understand and maybe
>>get out of the way.
>>
> 
> 
> Big companies often want to do things in a proprietary fashion.  I
> personally would prefer to see a standard's-based approach.

I think SDI is what we're talking about here.

>>It is all about customer satisfaction, which is completely
>>foreign to Linux, simply because of the _nature_ of Linux.
> 
> 
> More bold statements? ;-)

No, its just reality.  It appears that you have had very little
interaction with your software engineers about "compatibility".
Also read the Linux blurb on kernel.org, the "What is Linux?" one.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
