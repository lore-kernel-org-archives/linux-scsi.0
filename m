From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas : reserving a channel for integrated raid
Date: Tue, 11 Jul 2006 16:30:22 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F64B9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63689 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932219AbWGKWaZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 18:30:25 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

-- Tuesday, July 11, 2006 3:50 PM, James Bottomley wrote: 

> > I'll work in it this afternoon, trying to getting something 
> out later
> > today.
> 
> Try this .. it works for aic94xx, but being away from my test set up I
> can't actually plug in the mptsas card.  (Ignore the errors 
> about unable
> to find aic94xx files to patch ... )
> 

Thankyou, that works.  I like that much better.   Pls apply.

