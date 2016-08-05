From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] fcoe: Use kfree_skb() instead of kfree()
Date: Thu, 04 Aug 2016 21:29:40 -0400
Message-ID: <yq1ziosvw8r.fsf@sermon.lab.mkp.net>
References: <1469430033-8422-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964818AbcHEB3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 21:29:52 -0400
In-Reply-To: <1469430033-8422-1-git-send-email-weiyj.lk@gmail.com> (Wei
	Yongjun's message of "Mon, 25 Jul 2016 07:00:33 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> Use kfree_skb() instead of kfree() to free sk_buff.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
