From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] ipr: Fix error return code in ipr_probe_ioa()
Date: Tue, 02 Aug 2016 01:19:41 -0400
Message-ID: <yq1r3a7n3wy.fsf@sermon.lab.mkp.net>
References: <1469808045-1821-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567AbcHBFTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 01:19:47 -0400
In-Reply-To: <1469808045-1821-1-git-send-email-weiyj.lk@gmail.com> (Wei
	Yongjun's message of "Fri, 29 Jul 2016 16:00:45 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> Fix to return error code -ENOMEM from the workqueue alloc error
Wei> handling case instead of 0, as done elsewhere in this function.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
