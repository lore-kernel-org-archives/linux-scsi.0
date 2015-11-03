From: Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH v9 0/8] Fix error message and present UFS variant
Date: Tue, 3 Nov 2015 06:29:52 +0530
Message-ID: <CAGOxZ53OpV5r3R8DTLAYC=ySd7mutYakapNETDHGwuAL6b3B1w@mail.gmail.com>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, James.Bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Hi Yaniv,

On Wed, Oct 28, 2015 at 4:45 PM, Yaniv Gardi <ygardi@codeaurora.org> wrote:
> V9: update commit message with Reviewed-by
> and update commit message of patch 4/8
>
> V8: add phy attributes to UFS devicetree documentation file
>
> V7: removed additional dead code
>
> V6: removed dead code from ufs-qcom.c and added
> calling to ufshcd_dealloc_host() in ufshcd-pltfrm.c in case
> of an error after a successfull ufshcd_alloc_host()
>
> V5: removed a redundant null check
>
> V4: add file
> Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> and modify the compatible strings in
> Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>
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
>   scsi: ufs: add ufshcd_get_variant ufshcd_set_variant
>   scsi: ufs: creates wrapper functions for vops
>   scsi: ufs: make the UFS variant a platform device

for patch 4 ~ 6, ufshcd bits, have tested on a exynos variant, so feel
free to add

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

>   scsi: ufs-qcom: add debug prints for test bus
>   scsi: ufs-qcom: add QUniPro hardware support and power optimizations
>
>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt |  58 ++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  11 +-
>  drivers/phy/phy-qcom-ufs.c                         |  11 +
>  drivers/scsi/ufs/Kconfig                           |   2 +-
>  drivers/scsi/ufs/ufs-qcom.c                        | 905 ++++++++++++++++-----
>  drivers/scsi/ufs/ufs-qcom.h                        |  68 +-
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   |  98 +--
>  drivers/scsi/ufs/ufshcd-pltfrm.h                   |  41 +
>  drivers/scsi/ufs/ufshcd.c                          | 122 ++-
>  drivers/scsi/ufs/ufshcd.h                          | 149 +++-
>  10 files changed, 1127 insertions(+), 338 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
