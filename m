From: "HighPoint Linux Team" <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Tue, 12 Sep 2006 13:40:33 +0800
Message-ID: <016101c6d62d$fc6e3070$1200a8c0@GMM>
References: <20060730171336.GA31646@lst.de> <1154888332.3683.231.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:17670 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP
	id S1750820AbWILFkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 01:40:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@SteelEye.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2006-07-30 at 19:13 +0200, Christoph Hellwig wrote:
> > The hptiop just got merged with a horrible amount of really bad ioctl
> > code that is against the standards for new scsi drivers.  This patch
> > backs it out (and fixes a small bug where scsi_add_host is called to
> > early).  We can re-add proper APIs once we agree on them.
> 
> I'm assuming the model you want to use is megaraid_sas, which only has a
> couple of defined ioctls?
> 
> > Please send this to Linus for 2.6.19 so that the ioctls don't make it
> > into a release.
> 
> OK, provided you take the lead in sorting out the ioctl infrastructure
> for this driver ...
> 
> James
> 

Is there a suggested solution now? We just want RAID management
functions to work on this driver. Is it ok to use register_chrdev()
for the management interface like megaraid_sas?

HighPoint Linux Team

