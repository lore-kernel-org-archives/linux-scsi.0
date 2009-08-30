From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 6/7] block: allow large discard requests
Date: Sat, 29 Aug 2009 22:52:59 -0400
Message-ID: <4A99E98B.403@rtr.ca>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org> <4A99E89E.9020204@rtr.ca> <20090830025022.GE22870@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:60550 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZH3Cw6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Aug 2009 22:52:58 -0400
In-Reply-To: <20090830025022.GE22870@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dwmw2@infradead.org

Matthew Wilcox wrote:
> On Sat, Aug 29, 2009 at 10:49:02PM -0400, Mark Lord wrote:
>> Pardon my cursory review, but I don't see where this
>> patch set allows for more than a single extent/range
>> of sectors per TRIM command.
> 
> It doesn't.
> 
>> If it still does not group many extents into a single TRIM,
>> then it will be far to slow to be useful at all for SATA.
> 
> That depends on the firmware.  I do have plans to group the extents,
> but let's get something working before making it quick.
..

In this situation, it's more a case of making it *not sucky slow*
than getting to the point where we think about making it "quick".

One extent at a time is glacial.

Cheers

