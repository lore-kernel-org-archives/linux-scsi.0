From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH]:Amended:Allow random write for PDT 5 profile 2 Removable Disk
Date: Mon, 8 Mar 2004 20:20:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040308192011.GG23525@suse.de>
References: <1078769250.7104.15.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:16801 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261156AbUCHTUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 14:20:16 -0500
Content-Disposition: inline
In-Reply-To: <1078769250.7104.15.camel@lintest.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <mckellj@iomega.com>
Cc: Pat LaVarre <LAVARRE@iomega.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Mar 08 2004, John McKell wrote:
> Jens,
> 
> All of this discussion has left me a bit confused:
> 
> On Sunday, March 7, 2004, Jens Axboe wrote:
> > On Sat, Mar 06 2004, Pat LaVarre wrote:
> > > > queued it for 2.6.4-pre
> > >
> > > Absent from 2.6.4-rc2, I think.
> >  
> > Will most likely have to wait for 2.6.5-pre/rc
> 
> What is the best indicator that I can use to monitor and know when a given 
> patch is to be inserted into the kernel?  I monitor kernel.org at least 
> once a day, if not more, but I hope that there would be something a bit 
> more informative.  If checking kernel.org frequently is the only way, then 
> I can deal with that.

You can check changes between last "released" (not 2.6.4, but also
2.6.4-pre2 for instance) kernel here:

http://www.kernel.org/pub/linux/kernel/v2.5/testing/cset/

that will show you what's queued for next sub-release.

-- 
Jens Axboe

