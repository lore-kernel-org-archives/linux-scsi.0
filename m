From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 06 Jun 2008 12:53:39 -0400
Message-ID: <yq1zlpyld2k.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605104042.GB20308@shareable.org>
	<yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
	<20080606045150.GL10720@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:60550 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYFFQyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 12:54:03 -0400
In-Reply-To: <20080606045150.GL10720@disturbed> (Dave Chinner's message of "Fri\, 6 Jun 2008 14\:51\:50 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> So is there going to be any obvious kernel API to access all
Dave> this info? i.e. if you do an online modification of a volume
Dave> (e.g.  add new storage of a different geometry to the volume)
Dave> and then do an online grow of the filesystem, how does the
Dave> filesystem get that new geometry information for the expanded
Dave> area?

xfs_growfs would call libdisk to see whether the topology had changed
since the fs was created.

-- 
Martin K. Petersen	Oracle Linux Engineering

