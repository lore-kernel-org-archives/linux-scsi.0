From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 6/7] block: allow large discard requests
Date: Sat, 29 Aug 2009 22:49:02 -0400
Message-ID: <4A99E89E.9020204@rtr.ca>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090829231122.302813585@bombadil.infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

Pardon my cursory review, but I don't see where this
patch set allows for more than a single extent/range
of sectors per TRIM command.

If it still does not group many extents into a single TRIM,
then it will be far to slow to be useful at all for SATA.

But if it does.. my apologies.  :)
