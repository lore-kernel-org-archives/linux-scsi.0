From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH v2 12/21] media: Remove depends on HAS_DMA in case of platform
	dependency
Date: Fri, 16 Mar 2018 14:51:45 +0100
Message-ID: <1521208314-4783-13-git-send-email-geert@linux-m68k.org>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1521208314-4783-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Matias Bjorling <mb-VR7NuqX4VJ8tq7phqP6ubQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mauro
Cc: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Note:
  - The various VIDEOBUF*DMA* symbols had to loose their dependencies on
    HAS_DMA, as they are selected by several individual drivers.

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Drop dependency of VIDEOBUF{,2}_DMA_{CONTIG,SG} on HAS_DMA,
  - Drop new dependencies of VIDEO_IPU3_CIO2 and DVB_C8SECTPFE on
    HAS_DMA,
  - Split per subsystem.
---
 drivers/media/common/videobuf2/Kconfig       |  2 --
 drivers/media/pci/dt3155/Kconfig             |  1 -
 drivers/media/pci/intel/ipu3/Kconfig         |  1 -
 drivers/media/pci/solo6x10/Kconfig           |  1 -
 drivers/media/pci/sta2x11/Kconfig            |  1 -
 drivers/media/pci/tw5864/Kconfig             |  1 -
 drivers/media/pci/tw686x/Kconfig             |  1 -
 drivers/media/platform/Kconfig               | 40 +++++++++-------------------
 drivers/media/platform/am437x/Kconfig        |  2 +-
 drivers/media/platform/atmel/Kconfig         |  4 +--
 drivers/media/platform/blackfin/Kconfig      |  1 -
 drivers/media/platform/davinci/Kconfig       |  6 -----
 drivers/media/platform/marvell-ccic/Kconfig  |  3 +--
 drivers/media/platform/rcar-vin/Kconfig      |  2 +-
 drivers/media/platform/soc_camera/Kconfig    |  3 +--
 drivers/media/platform/sti/c8sectpfe/Kconfig |  2 +-
 drivers/media/v4l2-core/Kconfig              |  2 --
 drivers/staging/media/davinci_vpfe/Kconfig   |  1 -
 drivers/staging/media/omap4iss/Kconfig       |  1 -
 19 files changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
index 17c32ea58395d78f..4ed11b46676ac4d0 100644
--- a/drivers/media/common/videobuf2/Kconfig
+++ b/drivers/media/common/videobuf2/Kconfig
@@ -12,7 +12,6 @@ config VIDEOBUF2_MEMOPS
 
 config VIDEOBUF2_DMA_CONTIG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	select DMA_SHARED_BUFFER
@@ -25,7 +24,6 @@ config VIDEOBUF2_VMALLOC
 
 config VIDEOBUF2_DMA_SG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 
diff --git a/drivers/media/pci/dt3155/Kconfig b/drivers/media/pci/dt3155/Kconfig
index 5145e0dfa2aa9e12..858b0f2f15bef9c8 100644
--- a/drivers/media/pci/dt3155/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_DT3155
 	tristate "DT3155 frame grabber"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index a82d3fe277d2cdec..2533ec1cb1177715 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -4,7 +4,6 @@ config VIDEO_IPU3_CIO2
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on X86 || COMPILE_TEST
 	depends on MEDIA_CONTROLLER
-	depends on HAS_DMA
 	depends on ACPI
 	select V4L2_FWNODE
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index 0fb91dc7ca73529e..d9e06a6bf1ebc1a7 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
-	depends on HAS_DMA
 	select BITREVERSE
 	select FONT_SUPPORT
 	select FONT_8x16
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index e03587b1af714199..7b856395ede9295c 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,7 +1,6 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
-	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
index 87c8f327e2d49dfa..760fb11dfeaef47b 100644
--- a/drivers/media/pci/tw5864/Kconfig
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW5864
 	tristate "Techwell TW5864 video/audio grabber and encoder"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Support for boards based on Techwell TW5864 chip which provides
diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
index 34ff37712313b780..da8bfee71b44cca5 100644
--- a/drivers/media/pci/tw686x/Kconfig
+++ b/drivers/media/pci/tw686x/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW686X
 	tristate "Intersil/Techwell TW686x video capture cards"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2 && SND
-	depends on HAS_DMA
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 614fbef08ddcabb0..a45e91006bab80a8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -36,7 +36,7 @@ source "drivers/media/platform/blackfin/Kconfig"
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on VIDEO_DEV && I2C && HAS_DMA
+	depends on VIDEO_DEV && I2C
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	help
@@ -85,7 +85,7 @@ config VIDEO_MUX
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
-	depends on HAS_DMA && OF
+	depends on OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
@@ -102,7 +102,7 @@ config VIDEO_OMAP3_DEBUG
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
@@ -112,7 +112,7 @@ config VIDEO_PXA27x
 
 config VIDEO_QCOM_CAMSS
 	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_FWNODE
@@ -122,7 +122,6 @@ config VIDEO_S3C_CAMIF
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on PM
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
@@ -133,7 +132,7 @@ config VIDEO_S3C_CAMIF
 
 config VIDEO_STM32_DCMI
 	tristate "STM32 Digital Camera Memory Interface (DCMI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -155,7 +154,6 @@ config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
 	default n
@@ -183,7 +181,6 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
-	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
@@ -201,7 +198,6 @@ config VIDEO_MEDIATEK_JPEG
 	depends on MTK_IOMMU_V1 || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -213,7 +209,7 @@ config VIDEO_MEDIATEK_JPEG
 
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	---help---
 	    This driver provides downloading VPU firmware and
@@ -229,7 +225,6 @@ config VIDEO_MEDIATEK_MDP
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
@@ -244,7 +239,7 @@ config VIDEO_MEDIATEK_MDP
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
 	depends on MTK_IOMMU || COMPILE_TEST
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -271,7 +266,6 @@ config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -283,7 +277,6 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -294,7 +287,6 @@ config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
@@ -304,7 +296,6 @@ config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_IMX27 || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -316,7 +307,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -325,7 +315,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_STI_BDISP
 	tristate "STMicroelectronics BDISP 2D blitter driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -335,7 +324,6 @@ config VIDEO_STI_BDISP
 config VIDEO_STI_HVA
 	tristate "STMicroelectronics HVA multi-format video encoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -362,7 +350,6 @@ config VIDEO_STI_DELTA
 	tristate "STMicroelectronics DELTA multi-format video decoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_STI || COMPILE_TEST
-	depends on HAS_DMA
 	help
 		This V4L2 driver enables DELTA multi-format video decoder
 		of STMicroelectronics STiH4xx SoC series allowing hardware
@@ -408,7 +395,7 @@ config VIDEO_SH_VEU
 
 config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -422,7 +409,7 @@ config VIDEO_RENESAS_FDP1
 
 config VIDEO_RENESAS_JPU
 	tristate "Renesas JPEG Processing Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -447,7 +434,7 @@ config VIDEO_RENESAS_FCP
 
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -460,7 +447,7 @@ config VIDEO_RENESAS_VSP1
 
 config VIDEO_ROCKCHIP_RGA
 	tristate "Rockchip Raster 2d Graphic Acceleration Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
@@ -477,7 +464,6 @@ config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
@@ -496,7 +482,7 @@ config VIDEO_TI_VPE_DEBUG
 
 config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM if ARCH_QCOM
@@ -638,7 +624,7 @@ if SDR_PLATFORM_DRIVERS
 
 config VIDEO_RCAR_DRIF
 	tristate "Renesas Digitial Radio Interface (DRIF)"
-	depends on VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_VMALLOC
 	---help---
diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 160e77e9a0fbfa61..f4ce1176e4dc8179 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_AM437X_VPFE
 	tristate "TI AM437x VPFE video capture driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 55de751e5f51500b..a211ef20f77eadba 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_ATMEL_ISC
 	tristate "ATMEL Image Sensor Controller (ISC) support"
-	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select REGMAP_MMIO
@@ -11,7 +11,7 @@ config VIDEO_ATMEL_ISC
 
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
index 68fa90151b8f40f2..cc239972fa2c3228 100644
--- a/drivers/media/platform/blackfin/Kconfig
+++ b/drivers/media/platform/blackfin/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_BLACKFIN_CAPTURE
 	tristate "Blackfin Video Capture Driver"
 	depends on VIDEO_V4L2 && BLACKFIN && I2C
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  V4L2 bridge driver for Blackfin video capture device.
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 55982e681d779d3a..6273853a86f900c3 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
@@ -19,7 +18,6 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -35,7 +33,6 @@ config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -52,7 +49,6 @@ config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -68,7 +64,6 @@ config VIDEO_DM355_CCDC
 config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -82,7 +77,6 @@ config VIDEO_DM365_ISIF
 config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	help
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 4bf5bd1e90d69fea..7f7868bc6fcbee87 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_CAFE_CCIC
 	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
 	depends on PCI && I2C && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
@@ -14,7 +13,7 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
-	depends on HAS_DMA && BROKEN
+	depends on BROKEN
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index af4c98b44d2e22cb..9064337a4bd9fc66 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) Driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f5979c12ad618f4a..669d116b8f09b2aa 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -18,9 +18,8 @@ config SOC_CAMERA_PLATFORM
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
 	depends on ARCH_SHMOBILE || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index 740190f8a3b606d3..7420a50572d347ef 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -1,6 +1,6 @@
 config DVB_C8SECTPFE
 	tristate "STMicroelectronics C8SECTPFE DVB support"
-	depends on PINCTRL && DVB_CORE && I2C && HAS_DMA
+	depends on PINCTRL && DVB_CORE && I2C
 	depends on ARCH_STI || ARCH_MULTIPLATFORM || COMPILE_TEST
 	select FW_LOADER
 	select DEBUG_FS
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8e37e7c5e0f7e25a..bbbbc42af3dee4a1 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -65,7 +65,6 @@ config VIDEOBUF_GEN
 
 config VIDEOBUF_DMA_SG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF_GEN
 
 config VIDEOBUF_VMALLOC
@@ -74,7 +73,6 @@ config VIDEOBUF_VMALLOC
 
 config VIDEOBUF_DMA_CONTIG
 	tristate
-	depends on HAS_DMA
 	select VIDEOBUF_GEN
 
 config VIDEOBUF_DVB
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index f40a06954a92eaec..0da8d7a5f57f818f 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
-	depends on HAS_DMA
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 46183464ee79f896..dbdb1ae82fdab323 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_OMAP4
 	tristate "OMAP 4 Camera support"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
-	depends on HAS_DMA
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
-- 
2.7.4
