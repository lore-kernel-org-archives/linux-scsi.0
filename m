From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and partitions
Date: Fri, 22 May 2009 09:34:12 -0400
Message-ID: <yq1ljopdzxn.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-6-git-send-email-martin.petersen@oracle.com>
	<20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com>
	<yq1fxf1gi3y.fsf@sermon.lab.mkp.net> <20090519181530.GH4140@kernel.dk>
	<yq1ws8bealr.fsf@sermon.lab.mkp.net>
	<20090522073050.GH11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:17363 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZEVNeQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 09:34:16 -0400
In-Reply-To: <20090522073050.GH11363@kernel.dk> (Jens Axboe's message of "Fri,
	22 May 2009 09:30:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> I replaced the original patch and went to apply this, but it fails
Jens> even at the first patch. What is this against? If you want it
Jens> queued for 2.6.31, please post it against the for-2.6.31 branch of
Jens> the block repo.

Weird.  It was cut against your for-2.6.31 branch as of a few days ago.
I just updated to your latest and greatest and the patches still apply
cleanly for me.

Are you sure you got the patch order right?

-- 
Martin K. Petersen	Oracle Linux Engineering
