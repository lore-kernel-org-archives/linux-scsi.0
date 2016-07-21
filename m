From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi:libsas: fix oops caused by assigning a freed task to ->lldd_task
Date: Wed, 20 Jul 2016 20:54:07 -0400
Message-ID: <yq160rzerps.fsf@sermon.lab.mkp.net>
References: <1467795625-15249-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcGUA6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 20:58:37 -0400
In-Reply-To: <1467795625-15249-1-git-send-email-fangwei1@huawei.com> (Wei
	Fang's message of "Wed, 6 Jul 2016 17:00:25 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Fang <fangwei1@huawei.com> writes:

Wei> A freed task has been assigned to ->lldd_task when
Wei> lldd_execute_task() failed in sas_ata_qc_issue(), and access of
Wei> ->lldd_task will cause an oops:

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
