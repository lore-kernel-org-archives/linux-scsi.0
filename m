From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Mon, 09 Jun 2008 11:05:53 -0400
Message-ID: <yq1skvmk5ri.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605104042.GB20308@shareable.org>
	<yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
	<20080606045150.GL10720@disturbed>
	<yq1zlpyld2k.fsf@sermon.lab.mkp.net>
	<20080607205438.GS10720@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:44532 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYFIPLB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 11:11:01 -0400
In-Reply-To: <20080607205438.GS10720@disturbed> (Dave Chinner's message of "Sun\, 8 Jun 2008 06\:54\:38 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> Sure it could, but xfs_growfs is currently just a wrapper around
Dave> an ioctl that tells the kernel to grow the filesystem by N bytes
Dave> and the kernel does all the changes transactionally. So changing
Dave> xfs_growfs to provide this information to the kernel will
Dave> require a new userspace API for XFS to push this information
Dave> straight back down into the kernel....

Dave> Also, it would be good to verify that stored filesystem
Dave> parameters are still optimal at mount time by querying the block
Dave> device(s) when internal structures are first initialised from
Dave> disk.  Hence even a simple kernel API to this info would be
Dave> handy.

Ok, I'll see if I can come up with a reasonable interface for this.

-- 
Martin K. Petersen	Oracle Linux Engineering

