From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 3/3] phy: qcom-ufs: Declare 20nm qcom ufs qmp phy as
 Broken
Date: Mon, 24 Sep 2018 10:29:35 -0700
Message-ID: <20180924172935.GM1367@tuxbook-pro>
References: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
 <20180904101719.18049-4-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904101719.18049-4-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, subhashj@codeaurora.org, evgreen@chromium.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Sep 03:17 PDT 2018, Vivek Gautam wrote:

> Fork out separate configs for 14nm and 20nm qcom ufs qmp phys
> to declare the 20nm phy as broken.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/phy/qualcomm/Kconfig  | 17 +++++++++++++++++
>  drivers/phy/qualcomm/Makefile |  4 ++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/Kconfig b/drivers/phy/qualcomm/Kconfig
> index 632a0e73ee10..32f7d34eb784 100644
> --- a/drivers/phy/qualcomm/Kconfig
> +++ b/drivers/phy/qualcomm/Kconfig
> @@ -50,6 +50,23 @@ config PHY_QCOM_UFS
>  	help
>  	  Support for UFS PHY on QCOM chipsets.
>  
> +if PHY_QCOM_UFS
> +
> +config PHY_QCOM_UFS_14NM
> +	tristate
> +	default PHY_QCOM_UFS
> +	help
> +	  Support for 14nm UFS QMP phy present on QCOM chipsets.
> +
> +config PHY_QCOM_UFS_20NM
> +	tristate
> +	default PHY_QCOM_UFS
> +	depends on BROKEN
> +	help
> +	  Support for 20nm UFS QMP phy present on QCOM chipsets.
> +
> +endif
> +
>  config PHY_QCOM_USB_HS
>  	tristate "Qualcomm USB HS PHY module"
>  	depends on USB_ULPI_BUS
> diff --git a/drivers/phy/qualcomm/Makefile b/drivers/phy/qualcomm/Makefile
> index deb831f453ae..c56efd3af205 100644
> --- a/drivers/phy/qualcomm/Makefile
> +++ b/drivers/phy/qualcomm/Makefile
> @@ -5,7 +5,7 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>  obj-$(CONFIG_PHY_QCOM_QMP)		+= phy-qcom-qmp.o
>  obj-$(CONFIG_PHY_QCOM_QUSB2)		+= phy-qcom-qusb2.o
>  obj-$(CONFIG_PHY_QCOM_UFS)		+= phy-qcom-ufs.o
> -obj-$(CONFIG_PHY_QCOM_UFS)		+= phy-qcom-ufs-qmp-14nm.o
> -obj-$(CONFIG_PHY_QCOM_UFS)		+= phy-qcom-ufs-qmp-20nm.o
> +obj-$(CONFIG_PHY_QCOM_UFS_14NM)		+= phy-qcom-ufs-qmp-14nm.o
> +obj-$(CONFIG_PHY_QCOM_UFS_20NM)		+= phy-qcom-ufs-qmp-20nm.o
>  obj-$(CONFIG_PHY_QCOM_USB_HS) 		+= phy-qcom-usb-hs.o
>  obj-$(CONFIG_PHY_QCOM_USB_HSIC) 	+= phy-qcom-usb-hsic.o
> -- 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
