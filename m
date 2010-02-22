From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Mon, 22 Feb 2010 19:45:44 +0530
Message-ID: <3e7aae31002220615j118e5703hd6d80121db7b936d@mail.gmail.com>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
	 <1266508049.4355.37.camel@mulgrave.site>
	 <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
	 <1266589605.2822.2.camel@mulgrave.site>
	 <3e7aae31002220450o6f83d2f3n45c795d70ef01f72@mail.gmail.com>
	 <1266843999.4414.27.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f191.google.com ([209.85.221.191]:43776 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0BVOXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 09:23:12 -0500
In-Reply-To: <1266843999.4414.27.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

On Mon, Feb 22, 2010 at 6:36 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> OK, so now see what max_hw_sectors_kb says ... if it's still 512 and
> you're sure you've got sg_tablesize set to something higher, there's
> likely something in the USB stack resetting it ... I suppose it's
> possible there's something else in your kernel doing that for the
> architecture, but you could rule that out by looking at
> max_hw_sectors_kb for either a SCSI or libata device and verifying it's
> much higher than 512.

when I set the max_sectors to 1024 in scsiglue.c(drivers/usb/storage),
it reflected as 512 in
/sys/block/<dev>/queue/max_sectors_kb and
/sys/block/<dev>/queue/max_hw_sectors_kb.
If I change the max_sectors to 1536 or 2048 in scsiglue.c file, still
it reflected as 512 in
/sys/block/<dev>/queue/max_sectors_kb and
768 or 1024 in /sys/block/<dev>/queue/max_hw_sectors_kb.

Thanks and Regards,
RD
