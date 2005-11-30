From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/11]  lpfc 8.1.1 : Add polled-mode support
Date: Wed, 30 Nov 2005 19:18:07 +0000
Message-ID: <20051130191807.GD19164@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C5F@xbl3.emulex.com> <20051129040244.GA28049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60095 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751545AbVK3TSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:18:09 -0500
Content-Disposition: inline
In-Reply-To: <20051129040244.GA28049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Smart@Emulex.Com, hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 09:02:44PM -0700, Matthew Wilcox wrote:
> On Mon, Nov 28, 2005 at 04:10:37PM -0500, James.Smart@Emulex.Com wrote:
> > 
> > > This needs some documentation for where it is useful.  Do you 
> > > want this
> > > to avoid interrupts under high loads or for something else? 
> > 
> > Yes - we've been asked to support this mode so that a heavily loaded
> > system can claim back some cpu cycles spent on interrupt processing.
> > (SPC benchmarks being a prime example)
> 
> sounds like we need to implement SAPI ;-)
> 
> [ for those with no clue what i'm talking about, see
> Documentation/networking/NAPI_HOWTO.txt ]

Exactly what I was thinking when writing this previous mail.

