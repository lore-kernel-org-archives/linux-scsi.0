From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 0/8] Support for Exynos specific UFS driver
Date: Thu, 06 Oct 2016 12:13:18 -0700
Message-ID: <85ac557c49df48cc605813b04f3778f5@codeaurora.org>
References: <006301d21fa9$70aebe80$520c3b80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37453 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbcJFTNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 15:13:19 -0400
In-Reply-To: <006301d21fa9$70aebe80$520c3b80$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

Hi Kim,


On 2016-10-06 01:12, Kiwoong Kim wrote:
> This series of patches introduce support for Exynos specific UFS 
> driver.
> An original version of this has been applied on mass production
> of commercial mobile devices.
> 
>  Documentation/devicetree/bindings/ufs/ufs-exynos.txt |   93 +
>  drivers/scsi/ufs/Kconfig                                      |   10 +
>  drivers/scsi/ufs/Makefile                                     |    1 +
>  drivers/scsi/ufs/mphy.h                                        |   38 
> +
>  drivers/scsi/ufs/ufs-exynos.c                                | 2084
> ++++++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h                                |  621 
> ++++++
>  drivers/scsi/ufs/ufshcd.c                                     |  146 
> +-
>  drivers/scsi/ufs/ufshcd.h                                     |   62 +
>  drivers/scsi/ufs/ufshci.h                                     |   14 
> +-
>  drivers/scsi/ufs/unipro.h                                     |   24 +
>  10 files changed, 3073 insertions(+), 20 deletions(-)
>  create mode 100644 
> Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>  create mode 100644 drivers/scsi/ufs/mphy.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.h

This supposed to be 8-patch series but i only patch #1 (subject: [PATCH 
v1 1/8] ufs: add some vendor specific operations) on mailing list. Can 
you please send out the full patch series?

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
