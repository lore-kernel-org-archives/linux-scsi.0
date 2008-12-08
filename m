From: Gal Rosen <galr@storwize.com>
Subject: Re: rmmod qlogic driver stuck
Date: Mon, 08 Dec 2008 19:48:52 +0200
Message-ID: <1228758532.6291.229.camel@galr-linux.storwiz.com>
References: <1228736014.6291.221.camel@galr-linux.storwiz.com>
	 <9BECC90A-21CB-4600-A6F9-9ABEAEB48839@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:22602 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbYLHRt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 12:49:27 -0500
In-Reply-To: <9BECC90A-21CB-4600-A6F9-9ABEAEB48839@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com

On Mon, 2008-12-08 at 09:23 -0800, Seokmann Ju wrote:
> On Dec 8, 2008, at 3:33 AM, Gal Rosen wrote:
> 
> > Hi,
> >
> > I am working against IBM Total Storage DS4000 with LSI INF-01-00 Rev:
> > 0534 controller. First I don't understand why this controller  
> > present 32
> > access LUNs instead of one.
> >
> > But my main issue is when I create virtual port and then try to rmmod
> > the qlogic driver, it stuck. I must say that I made changes to the
> > qlogic driver which add possibility to create virtual port in FC-AL
> > topology. The base driver is from kernel 2.6.26.2.
> >
> > Here is a part of the messages file:
> >
> > [ 1814.053285] scsi(7): DPC handler exiting
> [snip]
> >
> > host5 is the physical port, and host8 is the virtual port that created
> > on host5.
> > This issue does not occur against CLARiiON for instanse.
> As you may know, the NPIV feature implemented in such a way to work only
> in switched fabric topology.
> It requires certain switch with NPIV capable to be able to make the
> feature fully working.

Yes, I know that, but we use the Multi ID feature in Qlogic 24xx
firmware, to create the virtual port in LOOP topology.

I found that if I configure the LUN in the array to write cache disable
this problem does not occur; does this tell something to anyone ?
I don't think that it related to the vport, it will happened also with
physical port.

Gal.
> 
> Thank you,
> Seokmann
> 
> >
> >
> > Please help !!!
> >
> > Thanks,
> > Gal Rosen.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux- 
> > scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
