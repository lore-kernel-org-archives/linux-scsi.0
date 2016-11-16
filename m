From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 01/11] hisi_sas: add v2 hw support for ECC and AXI bus
 fatal error
Date: Wed, 16 Nov 2016 09:47:09 +0800
Message-ID: <CAMj5BkgAJrky9B8EO+ZZ-hvqnii5+g8nscU4m6fUnizbgEac=w@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:32852 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbcKPBrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 20:47:11 -0500
In-Reply-To: <1478522920-108145-2-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> For ECC 1bit error, logic can recover it, so we only print
> a warning.
> For ECC multi-bit and AXI bus fatal error, we panic.

Is it possible to recover via resetting phy and device etc instead of panic?

Thanks
