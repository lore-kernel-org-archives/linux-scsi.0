From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 13:18:15 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F667B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57059 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750827AbWGLTSw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 15:18:52 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

--  Wednesday, July 12, 2006 11:40 AM, James Bottomley wrote:

> 
> I haven't objected to the vendor specific CDB yet ... although if
> everyone implemented one of these the first time they found a 
> difficulty
> with one of the SCSI standards, the storage world would be in 
> a bit of a
> mess.

If the mode pages method worked properly, they wouldn't had to go this
other route.  

> 
> What I did say is that you can't do this in the driver ... it 
> has to be
> in the transport layer because it's not a driver problem.  
> Any other SAS
> driver would have the same issue.
> 

Ok, since this patch was the head of the queue, will you need
a respin of all the other patchs I posted yesterday?


> > The usage of Mode Sense and Mode Select will still work with the HP
> > tape drives, if you can find a way around the above issues.  But I
> > would suggest discussing any solution with the HP-Bristol tape drive
> > folks.
> 
> Yes ... someone at HP is asking them about this ...
> 

Are they aware of the problems we faced?



