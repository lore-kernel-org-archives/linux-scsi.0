From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Using scsi_cmd->request->nr_hw_segments within a LLDD...
Date: Wed, 22 Sep 2004 08:01:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922150120.GA14069@beaverton.ibm.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD913@AVEXCH02.qlogic.org> <20040922065727.GB2299@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:36511 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266009AbUIVPBo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 11:01:44 -0400
Content-Disposition: inline
In-Reply-To: <20040922065727.GB2299@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 22, 2004 at 08:57:27AM +0200, Jens Axboe wrote:
> On Tue, Sep 21 2004, Andrew Vasquez wrote:

> Would this by any chance be from request initiated with SG_IO? This
> problem should be fixed in 2.6.9-rcX, are you still seeing it?
> 
> ->nr_hw_segments was not initialized for some paths earlier, so it
> contained random crap.

Jens, 

What code change is it? I thought it was already in 2.6.8.

-- Patrick Mansfield
