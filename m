From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sym2 & lasi700 small updates
Date: 14 Aug 2004 18:42:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092523333.2095.9.camel@mulgrave>
References: <20040814214556.GC12936@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41694 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266236AbUHNWmO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 18:42:14 -0400
In-Reply-To: <20040814214556.GC12936@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-08-14 at 17:45, Matthew Wilcox wrote:
>  	if (request_irq(dev->irq, NCR_700_intr, SA_SHIRQ,
> -				dev->dev.bus_id, host)) {
> +				"lasi700", host)) {
>  		printk(KERN_ERR "%s: irq problem, detaching\n",

Actually, this was deliberate.  By design it's trying to give the sysfs
device node so that the location of the irq is uniquely descriptive to
the particular device in question.

I find this useful when I'm tracing things, but I suppose others would
prefer that it be more obviously descriptive.

What the old driver used to put there was 700 or 710 depending on which
chip it was driving.

James


