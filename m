From: Chris Worley <cworley@lnxi.com>
Subject: Re: SCSI Timeout issue w/ QLA2460
Date: 26 Sep 2003 12:55:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064602538.9216.43217.camel@localhost.localdomain>
References: <B179AE41C1147041AA1121F44614F0B060ED2E@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [208.177.141.226] ([208.177.141.226]:27449 "EHLO
	localhost.lnxi.com") by vger.kernel.org with ESMTP id S261592AbTIZS6e
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 14:58:34 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by localhost.lnxi.com (8.11.6/8.11.6) with ESMTP id h8QItfM02449
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2003 12:55:41 -0600
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED2E@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew,

The tarball from Qlogic was labeled:

  qla2x00-v6.01.00-dist.tgz 

It's the full-height, PCI-X, 133MHz, single port, 2340 (I think). 
Sorry.

Thanks,

Chris
On Fri, 2003-09-26 at 12:36, Andrew Vasquez wrote:
> Chris,
> 
> > Background: 2.4.21 korg kernel w/ Qlogic 2460 HBA and Qlogic's
> > driver (modified for 4096 scatter-gather list size).  Eight servers
> > are directly connected to a DDN S2A8000 SAN (dual controler, eight
> > FC ports, 2GB file system), no FC switch.  
> 
> Just a couple of questions:
> 
> 	o Which driver version are you refering to?  We'll need to
> 	  enable some debugging.
> 
> 	o QLogic doesn't have a 2460 card (perhaps it was just a
> 	  typo).  What type of card do you have (2340/2342)?
> 
> Regards,
> Andrew Vasquez

