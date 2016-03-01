From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/6] hisi_sas: add abort and retry feature
Date: Mon, 29 Feb 2016 21:00:48 -0500
Message-ID: <yq1si0bc5yn.fsf@sermon.lab.mkp.net>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20568 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbcCACBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 21:01:14 -0500
In-Reply-To: <1456393335-38294-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Thu, 25 Feb 2016 17:42:09 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces support to abort certain commands which
John> have failed and retry.  Certain errors require that the command be
John> retried, like TRANS_TX_CREDIT_TIMEOUT_ERR in v1 hw.  However, when
John> these errors occur the IO may still be in the device, so the IO
John> must first be aborted, and then retried. The HiSilicon SAS
John> controller has no FW to do this work, so it needs to be done
John> manually.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
