From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 09/11] hisi_sas: check SATA FIS when directly attaching
 SATA device
Date: Wed, 16 Nov 2016 09:49:03 +0800
Message-ID: <CAMj5Bkhjji5zC=KsCWMhXOvM1ZK0G8t-EWg57ZotuGaoObWung@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-10-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36163 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbcKPBtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 20:49:04 -0500
In-Reply-To: <1478522920-108145-10-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> Check ERR bit of status to decide whether there is something wrong with
> initial register-D2H FIS. If error exists, PHY reset the channel to
> restart OOB.
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
