From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] fusion - mptspi - reset handler shouldn't be calledfor other bus protocals
Date: Thu, 18 May 2006 14:52:37 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7011B7B5@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18646 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751198AbWERUwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 16:52:45 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday, May 17, 2006 5:07 PM, James Bottomley wrote:

> > 
> > This is urgent bug fix. Pls apply this to scsi-rc-fixes-2.6,
> > as well as this patch posted yesterday:
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=114782261719616&w=2
> 
> That's a pretty nasty bug ... and it will bite on the other reset
> handlers, won't it as well?  Shouldn't we be fixing it this 
> way instead:
> 

ACK

Agreed, very nasty bug.  

Your implementation is much cleaner.  Pls apply.

Eric Moore 
