From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [patch] Have qla2xxx driver bind fcports.
Date: Mon, 19 Jan 2004 09:20:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E42@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:45013 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265406AbUASRUC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:20:02 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Monday, January 19, 2004 9:11 AM, James Bottomley wrote:
> On Mon, 2004-01-19 at 12:03, Andrew Vasquez wrote:
> > BTW: This fix is already in the resync_bk-v8.00.00b9 patch up on the
> > SF.net site.
> 
> Thanks, sorry about that.
>

No problem.
 
> As far as the resync goes, I'd like to wait a while just to see if any
> more bugs turn up in the ioctl/failover separation piece ...
> it will be
> easier to debug if we have fewer changes, so how does early
> 2.6.2 sound
> for this (depending, of course, on when that actually is)?
>

That's fine, especially since there are some other structural fixups
the community would like to see with respect to the new firmware
images contained in b9.

Regards,
Andrew Vasquez
