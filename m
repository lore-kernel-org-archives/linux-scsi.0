From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: [PATCH] mark qlogicfc broken
Date: Fri, 11 Feb 2005 09:29:43 -0500 (EST)
Message-ID: <Pine.GSO.4.33.0502110925430.5536-100000@sweetums.bluetronic.net>
References: <20050211141015.GA28665@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:8168 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S262209AbVBKOay (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 09:30:54 -0500
In-Reply-To: <20050211141015.GA28665@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Fri, 11 Feb 2005, Christoph Hellwig wrote:
>Arjan tested it on the 2100 a while ago and it worked just fine.  Have
>you tested it recently?

Yes.  If you sling enough traffic at it, it hangs, times out, and eventually
restarts the card goes on about it's business for a few more seconds before
hanging again.

>It _is_ broken.  See the url in my initial post.

No, it is not.  I'm using it right now -- and have been for ~5 years.
Tridge's message doesn't say anything -- 4000 4 can happen with either
driver.

--Ricky


