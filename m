From: Tejun Heo <tj@kernel.org>
Subject: Re: support ranges TRIM for libata
Date: Thu, 23 Mar 2017 11:04:58 -0400
Message-ID: <20170323150458.GA3241@htj.duckdns.org>
References: <20170320204319.12628-1-hch@lst.de>
 <20170321185901.GB3706@htj.duckdns.org>
 <20170322181947.GA4733@lst.de>
 <1490276861.2202.8.camel@HansenPartnership.com>
 <20170323135521.GA30361@lst.de>
 <1490279706.2202.17.camel@HansenPartnership.com>
 <20170323144330.GA31447@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323144330.GA31447@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Christoph.

On Thu, Mar 23, 2017 at 03:43:30PM +0100, Christoph Hellwig wrote:
> > That's up to you ... from the point of view of code documenting itself,
> > forming the ATA_16 TRIM in sd and not doing any satl transformation is
> > easier for others to follow, but if it's going to cause more code, I'm
> > only marginal on the advantages of easier to follow code.
> 
> I tried this earlier before giving up on it because it looked to ugly.
> But I can complete that version of it and post it for people to compare.

I kinda like the idea of sticking with satl as that's how libata has
been doing most things even if the implementation is uglier.  It'd be
great to find out whether the ugliness would be acceptable or too
much.

Thanks.

-- 
tejun
