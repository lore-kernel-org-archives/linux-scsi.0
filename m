From: Tejun Heo <htejun@gmail.com>
Subject: Re: Boot failure with block/for-next
Date: Thu, 23 Dec 2010 17:13:12 +0100
Message-ID: <20101223161312.GC18482@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
 <20101223100956.GA15625@htj.dyndns.org>
 <1293118041.3029.3.camel@mulgrave.site>
 <20101223155239.GB18482@htj.dyndns.org>
 <1293120614.7776.0.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1293120614.7776.0.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > Can you please apply the debug patch I posted in the other message and
> > post the boot log?  Let's see how the partition read is failing.
> 
> That's actually a red herring ... the disk isn't spinning up, so the
> partition read is getting a not ready.

Oh, yay, but at any rate I think the don't-clear-media-presence patch
is probably a good idea just in case UA gets reported somehow.

Thanks.

-- 
tejun
