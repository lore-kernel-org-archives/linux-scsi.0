From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write same support
Date: Thu, 16 Feb 2012 15:02:03 -0500
Message-ID: <20120216200202.GA27311@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab2BPUCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 15:02:08 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

Hi Martin,

Given the feedback you've gotten so far I'd imagine you're well on your
way with a new patchset (building on your discard merge cleanup, etc).

But one thing that seemed odd about the previous set was the order of
the patches.

I think it'd be more appropriate to put patch 4 and 5 (scsi support) at
the beginning of the patchset (block interfaces aren't functional
without underlying scsi support).

FYI, I'll bounce a message detailing the iSCSI scatter-gather NULL
pointer I _always_ hit with dm-io issuing async WRITE_SAME.

Mike
