From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Write same support
Date: Thu, 16 Feb 2012 15:46:39 -0500
Message-ID: <yq1hayqa4ls.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27293 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2BPUqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 15:46:47 -0500
In-Reply-To: <20120216200202.GA27311@redhat.com> (Mike Snitzer's message of
	"Thu, 16 Feb 2012 15:02:03 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Given the feedback you've gotten so far I'd imagine you're well on
Mike> your way with a new patchset (building on your discard merge
Mike> cleanup, etc).

Yeah, tweaked a few things based on your comments.


Mike> I think it'd be more appropriate to put patch 4 and 5 (scsi
Mike> support) at the beginning of the patchset (block interfaces aren't
Mike> functional without underlying scsi support).

The SCSI patches depend on the block layer ditto (topology parameters
need to be present, etc.).

Also, we always do it this way so we can get the block layer changes in
during the merge window and then add the SCSI bits to the post-merge
tree.


Mike> FYI, I'll bounce a message detailing the iSCSI scatter-gather NULL
Mike> pointer I _always_ hit with dm-io issuing async WRITE_SAME.

Interesting, please do. I've only tested on SAS and FC...

-- 
Martin K. Petersen	Oracle Linux Engineering
