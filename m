From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] fcoe: add missing destroy_workqueue() on error in fcoe_init()
Date: Tue, 02 Aug 2016 01:18:41 -0400
Message-ID: <yq1vazjn3ym.fsf@sermon.lab.mkp.net>
References: <1469807688-32470-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29341 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbcHBFSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 01:18:51 -0400
In-Reply-To: <1469807688-32470-1-git-send-email-weiyj.lk@gmail.com> (Wei
	Yongjun's message of "Fri, 29 Jul 2016 15:54:48 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> Add the missing destroy_workqueue() before return from fcoe_init()
Wei> in the fcoe transport register failed error handling case.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
