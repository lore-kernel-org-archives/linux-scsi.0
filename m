From: ygardi@codeaurora.org
Subject: Re: [PATCH v3 0/8] Fix error message and present UFS variant
Date: Tue, 25 Aug 2015 11:52:40 -0000
Message-ID: <264c06d25f57b5a0c4360851b500c1c5.squirrel@www.codeaurora.org>
References: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

> V3: fixes a few minor issues.
>
> V2: fixes a few issues of unnecessary EXPORT_SYMBOL,
> types of parameters in routine definition,
> build errors in case CONFIG_PM is not defined and some
> other minor fixes.
>
> Yaniv Gardi (8):
>   phy: qcom-ufs: fix build error when the component is built as a module
>   scsi: ufs-qcom: fix compilation warning if compiled as a module
>   scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
>   add ufshcd_get_variant ufshcd_set_variant
>   scsi: ufs: creates wrapper functions for vops
>   scsi: ufs: make the UFS variant a platform device
>   scsi: ufs-qcom: add debug prints for test bus
>   scsi: ufs-qcom: add QUniPro hardware support and power optimizations
>
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   2 +-
>  drivers/phy/phy-qcom-ufs.c                         |  11 +
>  drivers/scsi/ufs/Kconfig                           |   2 +-
>  drivers/scsi/ufs/ufs-qcom.c                        | 921
> ++++++++++++++++-----
>  drivers/scsi/ufs/ufs-qcom.h                        |  68 +-
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   |  92 +-
>  drivers/scsi/ufs/ufshcd-pltfrm.h                   |  41 +
>  drivers/scsi/ufs/ufshcd.c                          | 122 ++-
>  drivers/scsi/ufs/ufshcd.h                          | 149 +++-
>  9 files changed, 1072 insertions(+), 336 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
