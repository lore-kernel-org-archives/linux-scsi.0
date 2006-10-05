From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi updates for post 2.6.18
Date: Thu, 05 Oct 2006 15:16:18 -0400
Message-ID: <45255A02.2010308@garzik.org>
References: <1159995678.3437.80.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.60.0610052104330.6619@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57216 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750731AbWJETQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 15:16:26 -0400
In-Reply-To: <Pine.LNX.4.60.0610052104330.6619@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 4 Oct 2006, James Bottomley wrote:
> 
>> This is (hopefully) my final batch of updates before we go -rc1.  It's
>> mainly code cleanups, some driver updates and the new qla4xxx iScsi
>> driver.
> 
> James, is there a reason why you didn't include this one:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=115974328128341&w=2
> 
> Do you think it can cause problems?

It would be nice to get it tested, based on your "don't know if it works 
though" comment...

	Jeff



