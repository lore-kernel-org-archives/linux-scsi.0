From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH v2 15/21] net: Remove depends on HAS_DMA in case of platform
	dependency
Date: Fri, 16 Mar 2018 14:51:48 +0100
Message-ID: <1521208314-4783-16-git-send-email-geert@linux-m68k.org>
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
  - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops().
    set_dma_ops() does not exist if NO_DMA=y, and its use in this driver
    is questionable.

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Split per subsystem.
---
 drivers/net/ethernet/amd/Kconfig                | 2 +-
 drivers/net/ethernet/apm/xgene-v2/Kconfig       | 1 -
 drivers/net/ethernet/apm/xgene/Kconfig          | 1 -
 drivers/net/ethernet/arc/Kconfig                | 6 ++++--
 drivers/net/ethernet/broadcom/Kconfig           | 2 --
 drivers/net/ethernet/calxeda/Kconfig            | 2 +-
 drivers/net/ethernet/hisilicon/Kconfig          | 2 +-
 drivers/net/ethernet/marvell/Kconfig            | 8 +++-----
 drivers/net/ethernet/mellanox/mlxsw/Kconfig     | 2 +-
 drivers/net/ethernet/renesas/Kconfig            | 2 --
 drivers/net/wireless/broadcom/brcm80211/Kconfig | 1 -
 drivers/net/wireless/quantenna/qtnfmac/Kconfig  | 2 +-
 12 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index d5c15e8bb3de706b..f273af136fc7c995 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -173,7 +173,7 @@ config SUNLANCE
 
 config AMD_XGBE
 	tristate "AMD 10GbE Ethernet driver"
-	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM && HAS_DMA
+	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
 	depends on X86 || ARM64 || COMPILE_TEST
 	select BITREVERSE
 	select CRC32
diff --git a/drivers/net/ethernet/apm/xgene-v2/Kconfig b/drivers/net/ethernet/apm/xgene-v2/Kconfig
index 1205861b631896a0..eedd3f3dd22e2201 100644
--- a/drivers/net/ethernet/apm/xgene-v2/Kconfig
+++ b/drivers/net/ethernet/apm/xgene-v2/Kconfig
@@ -1,6 +1,5 @@
 config NET_XGENE_V2
 	tristate "APM X-Gene SoC Ethernet-v2 Driver"
-	depends on HAS_DMA
 	depends on ARCH_XGENE || COMPILE_TEST
 	help
 	  This is the Ethernet driver for the on-chip ethernet interface
diff --git a/drivers/net/ethernet/apm/xgene/Kconfig b/drivers/net/ethernet/apm/xgene/Kconfig
index afccb033177b3923..e4e33c900b577161 100644
--- a/drivers/net/ethernet/apm/xgene/Kconfig
+++ b/drivers/net/ethernet/apm/xgene/Kconfig
@@ -1,6 +1,5 @@
 config NET_XGENE
 	tristate "APM X-Gene SoC Ethernet Driver"
-	depends on HAS_DMA
 	depends on ARCH_XGENE || COMPILE_TEST
 	select PHYLIB
 	select MDIO_XGENE
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index e743ddf46343302f..5d0ab8e74b680cc6 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -24,7 +24,8 @@ config ARC_EMAC_CORE
 config ARC_EMAC
 	tristate "ARC EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && HAS_DMA && (ARC || COMPILE_TEST)
+	depends on OF_IRQ && OF_NET
+	depends on ARC || COMPILE_TEST
 	---help---
 	  On some legacy ARC (Synopsys) FPGA boards such as ARCAngel4/ML50x
 	  non-standard on-chip ethernet device ARC EMAC 10/100 is used.
@@ -33,7 +34,8 @@ config ARC_EMAC
 config EMAC_ROCKCHIP
 	tristate "Rockchip EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && REGULATOR && HAS_DMA && (ARCH_ROCKCHIP || COMPILE_TEST)
+	depends on OF_IRQ && OF_NET && REGULATOR
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	---help---
 	  Support for Rockchip RK3036/RK3066/RK3188 EMAC ethernet controllers.
 	  This selects Rockchip SoC glue layer support for the
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index af75156919edfead..4c3bfde6e8de00f2 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -157,7 +157,6 @@ config BGMAC
 config BGMAC_BCMA
 	tristate "Broadcom iProc GBit BCMA support"
 	depends on BCMA && BCMA_HOST_SOC
-	depends on HAS_DMA
 	depends on BCM47XX || ARCH_BCM_5301X || COMPILE_TEST
 	select BGMAC
 	select PHYLIB
@@ -170,7 +169,6 @@ config BGMAC_BCMA
 
 config BGMAC_PLATFORM
 	tristate "Broadcom iProc GBit platform support"
-	depends on HAS_DMA
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	depends on OF
 	select BGMAC
diff --git a/drivers/net/ethernet/calxeda/Kconfig b/drivers/net/ethernet/calxeda/Kconfig
index 07d2201530d26c85..9fdd496b90ff47cb 100644
--- a/drivers/net/ethernet/calxeda/Kconfig
+++ b/drivers/net/ethernet/calxeda/Kconfig
@@ -1,6 +1,6 @@
 config NET_CALXEDA_XGMAC
 	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	depends on ARCH_HIGHBANK || COMPILE_TEST
 	select CRC32
 	help
diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 8bcf470ff5f38a4e..fb1a7251f45d3369 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_HISILICON
 	bool "Hisilicon devices"
 	default y
-	depends on (OF || ACPI) && HAS_DMA
+	depends on OF || ACPI
 	depends on ARM || ARM64 || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index ebe5c91489355c9e..0704a1900bbca444 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -18,8 +18,8 @@ if NET_VENDOR_MARVELL
 
 config MV643XX_ETH
 	tristate "Marvell Discovery (643XX) and Orion ethernet support"
-	depends on (MV64X60 || PPC32 || PLAT_ORION || COMPILE_TEST) && INET
-	depends on HAS_DMA
+	depends on MV64X60 || PPC32 || PLAT_ORION || COMPILE_TEST
+	depends on INET
 	select PHYLIB
 	select MVMDIO
 	---help---
@@ -58,7 +58,6 @@ config MVNETA_BM_ENABLE
 config MVNETA
 	tristate "Marvell Armada 370/38x/XP/37xx network interface support"
 	depends on ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	select MVMDIO
 	select PHYLINK
 	---help---
@@ -84,7 +83,6 @@ config MVNETA_BM
 config MVPP2
 	tristate "Marvell Armada 375/7K/8K network interface support"
 	depends on ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	select MVMDIO
 	---help---
 	  This driver supports the network interface units in the
@@ -92,7 +90,7 @@ config MVPP2
 
 config PXA168_ETH
 	tristate "Marvell pxa168 ethernet support"
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	depends on CPU_PXA168 || ARCH_BERLIN || COMPILE_TEST
 	select PHYLIB
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index d56eea3105090051..b591c8cc9896ccb7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -30,7 +30,7 @@ config MLXSW_CORE_THERMAL
 
 config MLXSW_PCI
 	tristate "PCI bus implementation for Mellanox Technologies Switch ASICs"
-	depends on PCI && HAS_DMA && HAS_IOMEM && MLXSW_CORE
+	depends on PCI && HAS_IOMEM && MLXSW_CORE
 	default m
 	---help---
 	  This is PCI bus implementation for Mellanox Technologies Switch ASICs.
diff --git a/drivers/net/ethernet/renesas/Kconfig b/drivers/net/ethernet/renesas/Kconfig
index 27be51f0a421b43e..f3f7477043ce1061 100644
--- a/drivers/net/ethernet/renesas/Kconfig
+++ b/drivers/net/ethernet/renesas/Kconfig
@@ -17,7 +17,6 @@ if NET_VENDOR_RENESAS
 
 config SH_ETH
 	tristate "Renesas SuperH Ethernet support"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || SUPERH || COMPILE_TEST
 	select CRC32
 	select MII
@@ -31,7 +30,6 @@ config SH_ETH
 
 config RAVB
 	tristate "Renesas Ethernet AVB support"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select CRC32
 	select MII
diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 9d99eb42d9176f0f..6acba67bca07abd7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -60,7 +60,6 @@ config BRCMFMAC_PCIE
 	bool "PCIE bus interface support for FullMAC driver"
 	depends on BRCMFMAC
 	depends on PCI
-	depends on HAS_DMA
 	select BRCMFMAC_PROTO_MSGBUF
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
index 025fa6018550895a..8d1492a90bd135c0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -7,7 +7,7 @@ config QTNFMAC
 config QTNFMAC_PEARL_PCIE
 	tristate "Quantenna QSR10g PCIe support"
 	default n
-	depends on HAS_DMA && PCI && CFG80211
+	depends on PCI && CFG80211
 	select QTNFMAC
 	select FW_LOADER
 	select CRC32
-- 
2.7.4
