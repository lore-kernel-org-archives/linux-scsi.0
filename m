From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 08 Feb 2012 18:12:50 -0500
Message-ID: <yq139akor65.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
	<20120208225023.GA16401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45021 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2BHXM6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 18:12:58 -0500
In-Reply-To: <20120208225023.GA16401@redhat.com> (Mike Snitzer's message of
	"Wed, 8 Feb 2012 17:50:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> + BUG_ON(length != bdev_logical_block_size(bdev));

Mike> Why require @length to be passed in if we can easily determine the
Mike> only correct length, via bdev_logical_block_size, locally?

Just sanity checking since the caller is passing in a buffer pointer.
See my comment in the patch series introduction about a page vs a
buffer. I don't really care whether we pick one or the other. Whatever
makes the most sense to dm, md and the filesystems...

-- 
Martin K. Petersen	Oracle Linux Engineering
