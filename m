From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 3/3] scsi: hisi_sas: lock sensitive region in
 hisi_sas_slot_abort()
Date: Wed, 4 Jan 2017 09:20:26 +0800
Message-ID: <64edc70b-8ff0-a9d5-8552-167bb560cf16@linaro.org>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
 <1483446290-185084-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35190 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935425AbdADBVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 20:21:35 -0500
Received: by mail-pg0-f46.google.com with SMTP id i5so155900052pgh.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jan 2017 17:20:50 -0800 (PST)
In-Reply-To: <1483446290-185084-4-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org



On 2017年01月03日 20:24, John Garry wrote:
> When we call hisi_sas_slot_task_free() we should grab the
> hisi_hba.lock, as hisi_sas_slot_task_free() accesses common
> hisi_hba elements.
> Function hisi_sas_slot_abort() is missing this, so add it.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
