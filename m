From: Jens Axboe <axboe@suse.de>
Subject: Re: Using scsi_cmd->request->nr_hw_segments within a LLDD...
Date: Wed, 22 Sep 2004 17:02:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922150255.GK2375@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0012AD913@AVEXCH02.qlogic.org> <20040922065727.GB2299@suse.de> <20040922150120.GA14069@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:3505 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266116AbUIVPFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 11:05:04 -0400
Content-Disposition: inline
In-Reply-To: <20040922150120.GA14069@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 22 2004, Patrick Mansfield wrote:
> On Wed, Sep 22, 2004 at 08:57:27AM +0200, Jens Axboe wrote:
> > On Tue, Sep 21 2004, Andrew Vasquez wrote:
> 
> > Would this by any chance be from request initiated with SG_IO? This
> > problem should be fixed in 2.6.9-rcX, are you still seeing it?
> > 
> > ->nr_hw_segments was not initialized for some paths earlier, so it
> > contained random crap.
> 
> Jens, 
> 
> What code change is it? I thought it was already in 2.6.8.

Yes it was already in 2.6.8, I just wasn't sure. It's the
bio_copy_user() stuff that replaces the kmalloc() approach for unaligned
user data.

-- 
Jens Axboe

