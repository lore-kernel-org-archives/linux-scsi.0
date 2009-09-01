From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [RFC PATCH 0/9] RFC: handle queue_depth adjustments because of
 QUEUE_FULLs in scsi_error.c
Date: Tue, 01 Sep 2009 15:57:33 -0700
Message-ID: <1251845853.27437.69.camel@vi2.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:19664 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755292AbZIAW5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 18:57:31 -0400
In-Reply-To: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-08-26 at 11:03 -0700, Vasu Dev wrote:
> First four patches are from Mike Christie's original RFC at:-
> 
> http://www.spinics.net/lists/linux-scsi/msg35959.html
> http://www.spinics.net/lists/linux-scsi/msg35962.html
> http://www.spinics.net/lists/linux-scsi/msg35961.html
> http://www.spinics.net/lists/linux-scsi/msg35963.html
> http://www.spinics.net/lists/linux-scsi/msg35964.html
> 
> Above four patches adds ramp down code and I appended ramp
> up code in following patches and tested this entire
> series with libfc/fcoe. This series works fine without any
> regression and also queue_depth adjustment works for both
> ramp down and ramp up.
> 
> Above patches are updated to scsi-misc -rc7 plus recently
> submitted 64 fcoe patches series by Rob
> "[PATCH 00/64] libfc, libfcoe and fcoe updates for scsi-misc"
> This series also applies cleanly to scsi-misc -rc7.
> 
> I'd appreciate review comments for added more patches for
> ramp up.
> 
> I'll post my final patches to this list skipping fcoe list,
> this as per Rob Love suggestion since mostly scsi changes
> by this series beyond fcoe/libfc. However Rob agreed to
> review/Ack fcoe/libfc changes at this list.
> 
> Mike, I'll be able to post my ramp up patches only once
> you send final patches for ramp down on which my patches
> depends. As I said your patches are tested for libfc,
> so most common code is already tested and they are
> good go as far as libfc goes.
> 

Hey Mike, 

	I'd like to get final patches of this series out this week to
get them into next merge window but not sure how to get final patches
out with your first four RFC patches in this series on which rest all
patches depends. Please help me on this.

I see following ways to get final patches out:-

 1. You post your first four as final patches and then I post mine.

 2. I've tested this series for libfc, so I can trim your patches to
only scsi-ml and libfc changes excluding lpfc and qla changes for now
since this is all I can test before I send out final patches. I suppose
it should be okay to post your RFC patches by me with my verification
with libfc and your approval as these RFC patches author.

	Let me know which way you would like to proceed, In any case patches
needs to be updated for recent comments.

	Thanks
	Vasu
> 
> ---
> 
> Mike Christie (4):
>       drivers: convert fc drivers calling scsi_track_queue_full
>       drivers: convert drivers setting the change_queue_depth callback
>       scsi error: have scsi-ml call change_queue_depth to handle QUEUE_FULL
>       scsi-ml: modify change_queue_depth to take in reason why it is being called
> 
> Vasu Dev (5):
>       libfc: adds queue_depth ramp up to libfc
>       fcoe, libfc: fix an libfc issue with queue ramp down in libfc
>       scsi: add common queue_depth ramp up code
>       scsi: adds sdev->queue_ramp_up_period to sysfs
>       scsi: updates sdev to add queue_depth ramp up code
> 

> 

