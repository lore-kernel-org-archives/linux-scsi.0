From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Mon, 24 Oct 2005 23:08:03 -0400
Message-ID: <435DA193.9010805@rtr.ca>
References: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:30346 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S1751415AbVJYDIF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 23:08:05 -0400
In-Reply-To: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, axboe@suse.de, jgarzik@pobox.com, hch@lst.de

Randy Dunlap wrote:
> Although Jens's SATA suspend/resume patch works, it seems that the
> SCSI maintainer(s) want something different, e.g., Nathan Bryant's
> 2004 patch[1] with some changes:
..
As-is, the patch fails the practical examination:

My notebook fails to come back from suspend (to-RAM) using this patch,
but works fine with Jens' patch.

Modern notebook, no serial port, backlight still off so no on-screen messages.
Using ata_piix (libata) for hard disk.

Cheers
