From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi
 device handler
Date: Thu, 02 Jul 2009 10:07:39 -0400
Message-ID: <1246543659.6393.31.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:36530 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZGBOIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 10:08:11 -0400
In-Reply-To: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com


Yes, hopefully this afternoon (I head to the doctor in a few minutes -
back pain).  If I can not do it today then I wont be able to do it until
Tuesday (July 7th) as I will be on vacation for a long weekend.

Eddie
On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> Hello,
> 
> Last week, Eddie Williams reported a regression w.r.t scsi_dh
> (http://www.redhat.com/archives/dm-devel/2009-June/msg00285.html).
> Parameter setting part of dm multipath handler has been removed
> when we moved to scsi device handler.
> 
> This set of patches adds an new interface to scsi_dh and uses it.
> 
> This patch set applies on 2.6.31-rc1 and the following 2 patches:
> 	(1) http://patchwork.kernel.org/patch/32646/raw/
> 	(2) http://patchwork.kernel.org/patch/32647/raw/
> 
> This interface part of the patch has been tested.
> 
> Eddie,
> 
> If you can test it on an EMC storage and respond with your
> findings it will be of great help.
> 
> Thanks,
> 
> chandra
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

