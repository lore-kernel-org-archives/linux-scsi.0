From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: Re: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Tue, 25 Oct 2005 14:22:02 -0700
Message-ID: <20051025142202.226a5746.randy_d_dunlap@linux.intel.com>
References: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
	<435DA193.9010805@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr19.intel.com ([134.134.136.18]:48845 "EHLO
	orsfmr004.jf.intel.com") by vger.kernel.org with ESMTP
	id S932386AbVJYVUh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 17:20:37 -0400
In-Reply-To: <435DA193.9010805@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, axboe@suse.de, jgarzik@pobox.com, hch@lst.de

On Mon, 24 Oct 2005 23:08:03 -0400
Mark Lord <liml@rtr.ca> wrote:

> Randy Dunlap wrote:
> > Although Jens's SATA suspend/resume patch works, it seems that the
> > SCSI maintainer(s) want something different, e.g., Nathan Bryant's
> > 2004 patch[1] with some changes:
> ..
> As-is, the patch fails the practical examination:
> 
> My notebook fails to come back from suspend (to-RAM) using this patch,
> but works fine with Jens' patch.

Maybe I should have used Jeff's "DO NOT APPLY" wording here.
I didn't mean to give the impression that the patch was complete.
It's a work in progress, looking for constructive feedback,
which yours is, of course.

> Modern notebook, no serial port, backlight still off so no on-screen messages.
> Using ata_piix (libata) for hard disk.


---
~Randy
