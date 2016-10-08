From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 0/8] Support for Exynos specific UFS driver
Date: Sat, 08 Oct 2016 09:38:59 -0700
Message-ID: <e4edf11f725e817955f0a1fa9cafb3f3@codeaurora.org>
References: <000001d22111$e6d67260$b4835720$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755437AbcJHQjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2016 12:39:04 -0400
In-Reply-To: <000001d22111$e6d67260$b4835720$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-10-07 20:13, Kiwoong Kim wrote:
> This series of patches introduce support for Exynos specific UFS 
> driver.
> An original version of this has been applied on mass production
> of commercial mobile devices.
> 
> I checked compiling with Subhash's patch
> - [PATCH v3] scsi: ufshcd: fix possible unclocked register access
> 
> ---
> Changes from v1:
> * Separate a set of newer callbacks to be added
> * Make Exynos specific UFS driver compatible with a following patch
>      [PATCH v3] scsi: ufshcd: fix possible unclocked register access
>      (http://www.spinics.net/lists/linux-scsi/msg100290.html)
> * Rename three of the callbacks as follows:
>    set_nexus_t_xfer_req -> setup_xfer_req
>    set_nexus_t_task_mgmt -> setup_task_mgmt
>    hibern8_notify -> setup_hibern8
> ---
>  Documentation/devicetree/bindings/ufs/ufs-exynos.txt |   93 +
>  drivers/scsi/ufs/Kconfig                                       |   10 
> +
>  drivers/scsi/ufs/Makefile                                     |    1 +
>  drivers/scsi/ufs/mphy.h                                        |   38 
> +
>  drivers/scsi/ufs/ufs-exynos.c                                | 2099
> ++++++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h                                |  621 
> ++++++
>  drivers/scsi/ufs/ufshcd.c                                     |  144 
> +-
>  drivers/scsi/ufs/ufshcd.h                                     |   55 +
>  drivers/scsi/ufs/ufshci.h                                     |   14 
> +-
>  drivers/scsi/ufs/unipro.h                                     |   24 +
>  10 files changed, 3079 insertions(+), 20 deletions(-)
>  create mode 100644 
> Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>  create mode 100644 drivers/scsi/ufs/mphy.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.h

I could only see one patch "[PATCH 01/10] ufs: introduce setup_xfer_req 
callback" posted. can you post all of them? Also, please add the version 
number for each patch in patch series.

Thanks,
Subhash

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
