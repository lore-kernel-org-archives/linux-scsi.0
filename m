From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Tue, 06 Mar 2012 12:43:14 -0500
Message-ID: <yq1pqcplj65.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
	<20120302213616.GH26315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24037 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2CFRn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 12:43:28 -0500
In-Reply-To: <20120302213616.GH26315@redhat.com> (Vivek Goyal's message of
	"Fri, 2 Mar 2012 16:36:16 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> While you are removing special casing of REQ_DISCARD, may be
Vivek> following is also a good candidate.

Vivek> static inline int blk_do_io_stat(struct request *rq) {

Yeah, missed that one. Fixed, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
