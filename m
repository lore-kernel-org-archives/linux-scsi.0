From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 00:04:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022040423.GA28782@havoc.gtf.org>
References: <4178244E.1060906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.28.190.101]:32950 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S270937AbUJVEEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 00:04:24 -0400
Content-Disposition: inline
In-Reply-To: <4178244E.1060906@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 21, 2004 at 05:04:14PM -0400, Mark Lord wrote:
> Like the subject line says.. BLKFLSBUF (and friends) are broken for SATA.
> I'm getting tons of emails about this now that 2.6.9 is out.
> 
> Jeff: any chance of you fixing this soon?

More details...  define broken.

libata doesn't handle BLKFLSBUF directly, and never has, 
so nothing changed in that regard for 2.6.9.

	Jeff



