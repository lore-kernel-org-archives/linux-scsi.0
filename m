From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Write-protect checks
Date: Thu, 8 Dec 2005 13:32:46 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9ECB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44968 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932229AbVLHScs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 13:32:48 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Antipov <antipov@ru.mvista.com>

I have an interest in this being checked for fixed media as well, we
want to expose the underlying physical array components, but read &
write protected to protect the array contents. Christoph asked for us to
use the scsi layer for this check rather than spoofing it in the driver.

The other alternative is to add yet another device flag to enforce this.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Thursday, December 08, 2005 1:22 PM
> To: SCSI development list; Alan Cox
> Cc: Dmitry Antipov
> Subject: Write-protect checks
> 
> 
> On Thu, 8 Dec 2005, Alan Cox wrote:
> 
> > On Iau, 2005-12-08 at 11:00 -0500, Alan Stern wrote:
> > > module parameter.  For some reason (don't ask me why -- I 
> don't know) the
> > > SCSI core doesn't check a disk device's write-protect 
> status unless the
> > > device is marked as removable.
> > 
> > Have you asked the scsi maintainers why this occurs. Having 
> had a quick
> > look over the specs I have here I can't see why this is done either.
> 
> No, I haven't.
> 
> Okay guys.  Does anyone know why sd.c calls 
> sd_read_write_protect_flag 
> only for devices with removable media?
> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
