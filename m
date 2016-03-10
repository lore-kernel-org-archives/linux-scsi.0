From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 06/17] scsi: ufs: separate device and host quirks
Date: Wed, 09 Mar 2016 21:16:32 -0500
Message-ID: <yq1r3fjqdq7.fsf@sermon.lab.mkp.net>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
	<1457440568-13084-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934809AbcCJCQq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 21:16:46 -0500
In-Reply-To: <1457440568-13084-7-git-send-email-ygardi@codeaurora.org> (Yaniv
	Gardi's message of "Tue, 8 Mar 2016 14:35:57 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>

>>>>> "Yaniv" == Yaniv Gardi <ygardi@codeaurora.org> writes:

Yaniv> Currently we use the host quirks mechanism in order to handle
Yaniv> both device and host controller quirks.  In order to support
Yaniv> various of UFS devices we should separate handling the device
Yaniv> quirks from the host controller's.

This patch causes a circular dependency:

depmod: ERROR: Cycle detected: ufshcd -> ufs_quirks -> ufshcd

Please fix!

-- 
Martin K. Petersen	Oracle Linux Engineering
