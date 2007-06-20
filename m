From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Wed, 20 Jun 2007 23:16:56 +0200
Message-ID: <46799948.8000106@gmail.com>
References: <4677FD50.2090803@panasas.com> <20070619171610.GH18863@kernel.dk> <4679072C.2010604@panasas.com> <20070620122247.GA4443@infradead.org> <20070620122409.GU18863@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754463AbXFTVUk@vger.kernel.org>
In-Reply-To: <20070620122409.GU18863@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/20/2007 02:24 PM, Jens Axboe wrote:

> On Wed, Jun 20 2007, Christoph Hellwig wrote:
>> On Wed, Jun 20, 2007 at 01:53:32PM +0300, Boaz Harrosh wrote:

>>>  drivers/cdrom/aztcd.c
>>>  drivers/cdrom/cm206.c
>>>  drivers/cdrom/gscd.c
>>>  drivers/cdrom/mcdx.c
>>>  drivers/cdrom/optcd.c
>>>  drivers/cdrom/sjcd.c
>>> 
>> These are old cdrom drivers that are broken in various ways and
>> probably should be killed off aswell.
> 
> I agree (with both sentiments), would anyone mind if I just killed them
> off?

I wouldn't. As far as I'm concerned everything in drivers/cdrom except 
viocd.c and cdrom.c itself can go, assuming I'll be allowed to bring back 
support for the legacy cdrom types I'd still like to have supported -- in 
the first place mitsumi (mcdx), panasonic (sbpcd) and sony (cdu31a) and 
perhaps at some point other types if/when I happen across the hardware.

The old drivers serve as a source of hardware information but at least mcdx 
was broken in so many ways that it only did so at the source level. When I 
wanted to check throughput with the old driver I actually had to go back as 
far as 2.0.34 to find a working driver (the old mcd.c, already removed since 
2.6.10). 2.0.34 sources are available from kernel.org, and 2.6.22 sources 
even from my local machine...

> mitsumi support is being reworked, that can get reintroduced once the
> driver is in a stable state.

... which, by the way, is still waiting on comment from anyone with a clue 
as to why it makes the machine go boom (easily repeatable when using CFQ, 
not or not easily when using AS):

http://lkml.org/lkml/2007/6/4/50

Rene.
