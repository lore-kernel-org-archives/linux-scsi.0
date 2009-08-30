From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 6/7] block: allow large discard requests
Date: Sat, 29 Aug 2009 20:50:22 -0600
Message-ID: <20090830025022.GE22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org> <4A99E89E.9020204@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A99E89E.9020204@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2009 at 10:49:02PM -0400, Mark Lord wrote:
> Pardon my cursory review, but I don't see where this
> patch set allows for more than a single extent/range
> of sectors per TRIM command.

It doesn't.

> If it still does not group many extents into a single TRIM,
> then it will be far to slow to be useful at all for SATA.

That depends on the firmware.  I do have plans to group the extents,
but let's get something working before making it quick.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
