From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [BUG] linux-2.6.0-test9: slave_destroy called too early
Date: Tue, 11 Nov 2003 08:44:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031111164421.GB2259@beaverton.ibm.com>
References: <200311111145.49009.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:15332 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263632AbTKKQkD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 11:40:03 -0500
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id hABGe2kF171778
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 11:40:02 -0500
Content-Disposition: inline
In-Reply-To: <200311111145.49009.heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Heiko Carstens [heiko.carstens@de.ibm.com] wrote:
> Hi,
> 
> in linux-2.6.0-test9 there seems to be a bug in scsi_remove_device: each time
> I try to remove a scsi disk the sd driver fails to synchronize the SCSI cache.
> Reason for this is that the slave_destroy function of the LLD gets called
> before sd_shutdown of the sd driver gets called.
> I would suggest the patch below. Please apply or let me know that this is the
> wrong thing to do.
> 

The patch I previously posted would give the same effect. You can find
it in the archives.
http://marc.theaimsgroup.com/?l=linux-scsi&m=106810957502435&w=2

I will repost the patch with a update based on the feedback I received
on the previous thread (inline the scsi_free_sdev function).  This
updated patch will look very similiar to the sequence you have in your
patch.

-andmike
--
Michael Anderson
andmike@us.ibm.com

