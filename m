From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard() function
Date: Fri, 07 Nov 2014 11:27:39 -0500
Message-ID: <yq17fz79ds4.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
	<20141107082610.GC8394@infradead.org>
	<yq1k3379fvj.fsf@sermon.lab.mkp.net> <20141107162025.GA607@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45801 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaKGQ2J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 11:28:09 -0500
In-Reply-To: <20141107162025.GA607@thunk.org> (Theodore Ts'o's message of
	"Fri, 7 Nov 2014 11:20:25 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

Ted> So I'd be in favor of adding a flag to to blkdev_issue_zeroout(),
Ted> and I would have a slight preference for also modifying
Ted> sb_issue_zeroout so the flag gets plumbed all the way through to
Ted> the fs-level callers.

OK. I'll do that, then. I always liked the flag better. I was just
trying to minimize the impact.

What would you prefer as the default for the ext4 use case? To allocate
or to discard?

-- 
Martin K. Petersen	Oracle Linux Engineering
