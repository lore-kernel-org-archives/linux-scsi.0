From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Wed, 07 Mar 2012 23:41:25 -0500
Message-ID: <yq1ipifhfgq.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
	<20120302202139.GG26315@redhat.com>
	<yq1ty21lj6x.fsf@sermon.lab.mkp.net>
	<20120307165253.GD13430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48096 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2CHElm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 23:41:42 -0500
In-Reply-To: <20120307165253.GD13430@redhat.com> (Vivek Goyal's message of
	"Wed, 7 Mar 2012 11:52:53 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> So may be it is better to leave it as it is and have the
Vivek> understanding that REQ_NOMERGE_FLAGS represents flags both for
Vivek> bio and reqeust. Given the fact that bio only bits will not be
Vivek> set in req and vice a versa, it is fine to use this either on bio
Vivek> or rq. May be 1-2 line of comment above REQ_NOMERGE_FLAG will
Vivek> help.

Sure. Will do.

-- 
Martin K. Petersen	Oracle Linux Engineering
