From: Christoph Hellwig <hch@lst.de>
Subject: Re: qla1280 compile problems
Date: Tue, 5 Aug 2003 14:49:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805124904.GA25181@lst.de>
References: <20030805121813.GA24647@lst.de> <m31xw0wa58.fsf@trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:19373 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272702AbTHEMtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 08:49:08 -0400
Content-Disposition: inline
In-Reply-To: <m31xw0wa58.fsf@trained-monkey.org>
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Aug 05, 2003 at 08:40:03AM -0400, Jes Sorensen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> The qla1280 update still has some issues, mostly because it
> Christoph> backs out all the 2.5 changes applied to the driver in the
> Christoph> last months, also it doesn't work on ia64 because the IA64
> Christoph> generic build references sn2-specific symbols that don't
> Christoph> exist in that build.
> 
> Christoph,
> 
> Which version of the driver are you testing and what kernel? I tried
> it out fairly recently on 2.5.x (2.5.59 or so) and it compiled without
> any problems.

That's Jame's latest scsi-misc-2.5 tree, i.e. Linus' tree from four days
ago plus lots of scsi-related chanhges including qla 3.23.34.

> I will take a look at building it against the latest 2.6.0-test
> kernel. However, I am not going to make the vchan workaround a new
> config option, it doesn't make any sense as it's already protected by
> CONFIG_IA64_SGI_SN2 || CONFIG_IA64_GENERIC. The appropriate patches
> for that have already been pushed for 2.4 and Jesse is about to push
> them out for 2.5.

It does make sense.  Your punishing all ia64 users for SN2 breakage
although 95% (or probably more) of the IA64 boxens won't ever need it.

And no, so far SN2 isn't part of the generic IA64 build in either 2.4
or 2.5 although it's hopefully going to happen soon for 2.5.
