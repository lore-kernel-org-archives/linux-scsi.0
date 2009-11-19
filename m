From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] libata: add TRIM support
Date: Wed, 18 Nov 2009 22:35:29 -0500
Message-ID: <4B04BD01.5090706@rtr.ca>
References: <20091116154343.GA6672@infradead.org> <4B02AD86.8010304@rtr.ca> <20091117143507.GC588@infradead.org> <20091117145239.768072c9@lxorguk.ukuu.org.uk> <20091117150012.GA10748@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091117150012.GA10748@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Nov 17, 2009 at 02:52:39PM +0000, Alan Cox wrote:
>> I'm not convinced that is the right way to handle it. If we start doing
>> that we'll have this massive unmanagable set of magic flags and twiddles
>> for every possible host specific corner case.
>>
>> Far better to keep the issue of the command as Christoph has done and
>> block the command issue in the afflicted devices qc_issue so that you get
>> an error back. That keeps the mess in the right places.
> 
> Ok, new version of the patch without this will go out this minute.  I'm
> happy to add whatever patch is nessecary to block it for controllers
> that can't accept it once we agree on a method.
..

I imagine some sort of port or host flag, that the LLD could set
to indicate that it can correctly handle TRIM.  Or not handle TRIM.

Tejun is pretty good at these flag things.. I wonder what he might suggest?

Cheers
