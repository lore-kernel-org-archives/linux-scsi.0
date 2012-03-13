From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/7] block: Make blkdev_issue_zeroout use WRITE SAME
Date: Mon, 12 Mar 2012 22:30:05 -0400
Message-ID: <yq1zkblb5ci.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-4-git-send-email-martin.petersen@oracle.com>
	<4F5A467D.1000703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30412 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2CMCaX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2012 22:30:23 -0400
In-Reply-To: <4F5A467D.1000703@redhat.com> (Paolo Bonzini's message of "Fri,
	09 Mar 2012 19:05:49 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, vgoyal@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Paolo" == Paolo Bonzini <pbonzini@redhat.com> writes:

Paolo> Why not try DISCARD first if lbprz is true and the alignment is
Paolo> okay?  This doesn't even require WRITE SAME support in the disk.

Because we may want to use WRITE SAME to preallocate or anchor blocks.

If you don't care about block allocation then by all means use
blkdev_issue_discard().

-- 
Martin K. Petersen	Oracle Linux Engineering
