From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 06/11] hisi_sas: modify return value of hisi_sas_query_task()
Date: Wed, 16 Nov 2016 09:50:08 +0800
Message-ID: <CAMj5BkgS-yJdd1QR0-E1B=QMqTRRWuKSFVyOkFAhjVrSK05kTg@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-7-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36025 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbcKPBuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 20:50:10 -0500
In-Reply-To: <1478522920-108145-7-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> sas_scsi_find_task() only deals with return value
> TMF_RESP_FUNC_FAILED/TMF_RESP_FUNC_SUCC/TMF_RESP_FUNC_COMPLETE of
> query task. So for LLDD errors just return TMF_RESP_FUNC_FAILED.
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
