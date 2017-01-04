From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 2/3] scsi: hisi_sas: lock sensitive regions when servicing
 CQ interrupt
Date: Wed, 4 Jan 2017 09:19:51 +0800
Message-ID: <5e36ec8b-fc52-3f9c-4a34-9b3c8c2efa6e@linaro.org>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
 <1483446290-185084-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33796 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965571AbdADBUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 20:20:03 -0500
Received: by mail-pg0-f43.google.com with SMTP id y62so168670477pgy.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jan 2017 17:20:03 -0800 (PST)
In-Reply-To: <1483446290-185084-3-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org



On 2017年01月03日 20:24, John Garry wrote:
> There is a bug in the current driver in that certain hisi_hba
> and port structure elements which we access when servicing
> the CQ interrupt do not use thread-safe accesses; these include
> hisi_sas_port linked-list of active slots (hisi_sas_port.entry),
> bitmap of currently allocated IPTT (in hisi_hba.slot_index_tags),
> and completion queue read pointer.
>
> As a solution, lock these elements with the hisi_hba.lock.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
