From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 0/5] hisi_sas: v2 hw SATA fixes
Date: Wed, 13 Apr 2016 17:28:54 +0800
Message-ID: <CAMj5Bki348iVmZPY7UVk=y4wqHymn5kWizDym4CarggWstEbhQ@mail.gmail.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:35661 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbcDMJ2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 05:28:55 -0400
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Apr 8, 2016 at 5:23 PM, John Garry <john.garry@huawei.com> wrote:
> This patchset introduces SATA support fixes for

> the HiSilicon v2 hw SAS controller.
>
> Fixes include:
> - attach issue for SATA disk attached through expander
> - intermittent issue for directly attaching multiple
> SATA disks
> - add support for directly attaching SATA disk to phy
> index 4+
> - ITCT config issue
>
> John Garry (5):
>   hisi_sas: use device linkrate in MCR for v2 hw
>   hisi_sas: fix v2 hw multiple SATA disk issue
>   hisi_sas: add v2 hw support for >4 SATA phys
>   hisi_sas: for v2 hw only set ITCT qw2 for SAS device
>   hisi_sas: update driver version to 1.4

For the series,
Reviewed-by:  Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
