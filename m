From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 28 May 2014 08:50:08 -0700
Message-ID: <20140528155008.GA6913@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140520100343.31490551@canb.auug.org.au>
 <20140520053928.GA1751@infradead.org>
 <20140521094636.515289e8@canb.auug.org.au>
 <1400639101.2481.19.camel@dabdike>
 <20140528105429.GA20549@infradead.org>
 <538602BB.2080609@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <538602BB.2080609@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 10:37:31AM -0500, Mike Christie wrote:
> On 05/28/2014 05:54 AM, Christoph Hellwig wrote:
> >       be2iscsi: Fix processing cqe for cxn whose endpoint is freed
> 
> I didn't look at your tree, but when this patch was posted on the list I
> think it had a bug.
> 
> http://www.spinics.net/lists/linux-scsi/msg74191.html

I read through it and saw your comment, but so far it seems the patch
and especially the series does more good than harm.  I'll ping the
author again to get a fix for the issue you pointed out - I was planning
to do that anwyay.
