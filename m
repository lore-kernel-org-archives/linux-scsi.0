From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 0/3] hisi_sas: some CQ processing fixes
Date: Wed, 4 Jan 2017 10:14:53 +0800
Message-ID: <52fd4c87-a1e7-8a7e-835c-03297f7b1737@linaro.org>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:32981 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754827AbdADCWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 21:22:07 -0500
Received: by mail-pg0-f51.google.com with SMTP id g1so182128913pgn.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jan 2017 18:22:07 -0800 (PST)
In-Reply-To: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2017/1/3 20:24, John Garry wrote:
> This patchset fixes some issues related to servicing of the
> completion queue interrupt.
> The major fix is that sensitive hisi_hba structures need to be
> locked when free'ing a slot.
> Another modification is that the v2 hw completion queue irq is
> now serviced with a tasklet, as too much work was being done in
> the ISR.

Tested on v2 based sas hardware and the crashes are gone,

Tested-by: Hanjun Guo <hanjun.guo@linaro.org>

Thanks
Hanjun
