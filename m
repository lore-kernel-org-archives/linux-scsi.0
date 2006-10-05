From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi updates for post 2.6.18
Date: Thu, 05 Oct 2006 16:12:24 -0400
Message-ID: <45256728.2060004@garzik.org>
References: <1159995678.3437.80.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.60.0610052104330.6619@poirot.grange> <45255A02.2010308@garzik.org> <Pine.LNX.4.60.0610052129020.6619@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51074 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751192AbWJEUM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 16:12:28 -0400
In-Reply-To: <Pine.LNX.4.60.0610052129020.6619@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Guennadi Liakhovetski wrote:
> Sure, it WOULD be nice, but I don't know how. The "don't know" refers to 
> the case 16MB block size, my tape supports only 16MB - 1 byte (according 
> to st report). Is there a way to test various block sizes with CDs / 
> hard-disks / ZIP / scanners? Would something with sg_dd work? Looks like 
> it must be only sector size. Can I low-level format a disk with 16M 
> sector?:-)
> 
> Another possibility is to limit the block size at 8MB - I can test that.

I would say, increase it to whatever the max is you can test...

	Jeff


