From: Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH] scsi: hisi_sas: optimise DMA slot memory
Date: Wed, 28 Jun 2017 17:06:11 +0200
Message-ID: <CAH6sp9Ms3owydSN8hgSCiLXmOG5ke5yPdRxWbPjTVCS__n3RDA@mail.gmail.com>
References: <1498663554-51272-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:36083 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752554AbdF1PGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 11:06:13 -0400
In-Reply-To: <1498663554-51272-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Xiaofei Tan <tanxiaofei@huawei.com>

On Wed, Jun 28, 2017 at 5:25 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiaofei Tan <tanxiaofei@huawei.com>
>
> Currently we allocate 3 sets of DMA memories from separate
> pools for each slot. This is inefficient in terms of memory usage
> (buffers are less than 1 page in size, so we lose due to alignment),
> and also time spend in doing 3 allocations + de-allocations per slot,
> instead of 1.
>
> To optimise, combine the 3 DMA buffers into a single buffer from a
> single pool.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>

I'm not sure how strictly this is done, but typically the author signs
off first.

Frans
