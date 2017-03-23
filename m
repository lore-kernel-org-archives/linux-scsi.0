From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/23] hisi_sas: error handling and other misc fixes and improvements
Date: Thu, 23 Mar 2017 11:12:40 -0400
Message-ID: <yq1mvccdo2f.fsf@oracle.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33424 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933210AbdCWPMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 11:12:54 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 23 Mar 2017 01:25:16 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org

John Garry <john.garry@huawei.com> writes:

John,

> This patchset introduces a range of error handling
> and other misc improvements for the HiSilicon SAS
> controller, including:
> - controller reset function
> - softreset for SATA error handling
> - fixes for slot free'ing
> - v2 hw error handling improvements
> - and other misc, more minor stuff

Applied to 4.12/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
