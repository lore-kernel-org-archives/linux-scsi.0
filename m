From: Jens Axboe <axboe@suse.de>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Wed, 30 Nov 2005 15:51:35 +0100
Message-ID: <20051130145134.GP15804@suse.de>
References: <20051129200334.GB15804@suse.de> <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org> <20051130080854.GD15804@suse.de> <1133361995.3312.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49739 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751258AbVK3Oud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 09:50:33 -0500
Content-Disposition: inline
In-Reply-To: <1133361995.3312.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Nov 30 2005, James Bottomley wrote:
> On Wed, 2005-11-30 at 09:08 +0100, Jens Axboe wrote:
> > Oh well, so much for expecting than even the most basic SCSI behaviour
> > is always implemented correctly. A device must only return
> > 0x05/0x20/0x00 for an illegal opcode. It's a little suspicious I'd say,
> > are you sure it isn't something else affecting this? Even though there
> > are crappy devices out there, this seems a little too odd to me.
> 
> And anyway, just because it doesn't actually work in the failing case
> doesn't mean this isn't a good patch ... it's certainly unsafe to switch
> back to 6 byte commands without checking for the correct illegal opcode
> sense, so we should put it in anyway.

Yup, I think so too.

-- 
Jens Axboe

