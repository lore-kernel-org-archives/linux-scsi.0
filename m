From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: An MCA ESP driver
Date: Wed, 15 Aug 2007 11:26:00 -0600
Message-ID: <20070815172600.GF16277@parisc-linux.org>
References: <20070806232458.GC9732@parisc-linux.org> <20070807.002604.78735512.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53845 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760742AbXHOR0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 13:26:03 -0400
Content-Disposition: inline
In-Reply-To: <20070807.002604.78735512.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 07, 2007 at 12:26:04AM -0700, David Miller wrote:
> > -	struct sbus_dma		*dma;
> > +	union {
> > +		struct sbus_dma	*sbus_dma;
> > +		unsigned int	x86_dma;
> > +	};
> >  };
> 
> Feel free to make this a "void *dma_cookie" or similar.
> It's private to the bus front-end.

Hi Dave,

Could I just clarify; would you prefer it to be a void *?  I prefer the
anonymous union that I have there right now, but I'm not particularly
attached to it.  In particular, I don't really care to be casting ints
(x86) to pointers, but that's a matter of personal taste.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
