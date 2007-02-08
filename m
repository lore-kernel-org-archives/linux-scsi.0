From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
Date: Thu, 8 Feb 2007 12:25:39 -0800
Message-ID: <20070208122539.d9c24ad9.akpm@linux-foundation.org>
References: <1170920422.15989.354.camel@ymzhang>
	<20070208194204.GC2354@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070208194204.GC2354@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 8 Feb 2007 19:42:04 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 08, 2007 at 03:40:22PM +0800, Zhang, Yanmin wrote:
> > If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> > fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> > to irq vector.
> > 
> > Below patch against kernel 2.6.20 fixes it.
> 
> These direct arch ifdefs in core aren't acceptable.

For 2.6.21 that's true.  But this is a suitable fix for 2.6.20.x, no?
