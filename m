From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [GIT PATCH] scsi updates for post 2.6.18
Date: Fri, 6 Oct 2006 00:12:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610060011320.14466@poirot.grange>
References: <1159995678.3437.80.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0610052104330.6619@poirot.grange> <45255A02.2010308@garzik.org>
 <Pine.LNX.4.60.0610052129020.6619@poirot.grange> <45256728.2060004@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54944 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932335AbWJEWMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 18:12:48 -0400
In-Reply-To: <45256728.2060004@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 5 Oct 2006, Jeff Garzik wrote:

> Guennadi Liakhovetski wrote:
> > Sure, it WOULD be nice, but I don't know how. The "don't know" refers to the
> > case 16MB block size, my tape supports only 16MB - 1 byte (according to st
> > report). Is there a way to test various block sizes with CDs / hard-disks /
> > ZIP / scanners? Would something with sg_dd work? Looks like it must be only
> > sector size. Can I low-level format a disk with 16M sector?:-)
> > 
> > Another possibility is to limit the block size at 8MB - I can test that.
> 
> I would say, increase it to whatever the max is you can test...

Ok, tested with 8MB, an updated patch submitted.

Thanks for the suggestion
Guennadi
---
Guennadi Liakhovetski
