From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: [PATCH] mark qlogicfc broken
Date: Fri, 11 Feb 2005 10:08:08 -0800
Message-ID: <41EBA11203419D4CA8EB4C6140D8B40101401B65@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from avexch01.qlogic.com ([198.70.193.200]:3137 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262157AbVBKSIJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 13:08:09 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>, Christoph Hellwig <hch@lst.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

If you could run the qla2xxx driver with debug enabled and send me the message file after the failure then maybe I can determine whats wrong with it and fix for good.
-- Duane

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Ricky Beam
> Sent: Friday, February 11, 2005 6:30 AM
> To: Christoph Hellwig
> Cc: Linux SCSI List
> Subject: Re: [PATCH] mark qlogicfc broken
> 
> 
> On Fri, 11 Feb 2005, Christoph Hellwig wrote:
> >Arjan tested it on the 2100 a while ago and it worked just 
> fine.  Have
> >you tested it recently?
> 
> Yes.  If you sling enough traffic at it, it hangs, times out, 
> and eventually
> restarts the card goes on about it's business for a few more 
> seconds before
> hanging again.
> 
> >It _is_ broken.  See the url in my initial post.
> 
> No, it is not.  I'm using it right now -- and have been for ~5 years.
> Tridge's message doesn't say anything -- 4000 4 can happen with either
> driver.
> 
> --Ricky
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
