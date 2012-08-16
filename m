From: Dan Williams <djbw@fb.com>
Subject: [PATCH] MAINTAINERS: update address for Dan Williams
Date: Wed, 15 Aug 2012 19:20:02 -0700
Message-ID: <20120816021839.1269.20937.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44019 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab2HPCUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 22:20:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Moved to djbw@fb.com

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 MAINTAINERS |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..a728dc0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -827,24 +827,24 @@ F:	arch/arm/mach-pxa/colibri-pxa270-income.c
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -869,7 +869,7 @@ F:	drivers/pcmcia/pxa2xx_stargate2.c
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1227,9 +1227,9 @@ S:	Maintained
 F:	drivers/hwmon/asb100.c
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 W:	http://sourceforge.net/projects/xscaleiop
-S:	Supported
+S:	Maintained
 F:	Documentation/crypto/async-tx-api.txt
 F:	crypto/async_tx/
 F:	drivers/dma/
@@ -2359,7 +2359,7 @@ T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@fb.com>
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
@@ -3547,7 +3547,6 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
-M:	Dan Williams <dan.j.williams@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Ed Nadolski <edmund.nadolski@intel.com>
 L:	linux-scsi@vger.kernel.org
@@ -3590,8 +3589,8 @@ F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
-M:	Dan Williams <dan.j.williams@intel.com>
-S:	Supported
+M:	Dan Williams <djbw@fb.com>
+S:	Maintained
 F:	drivers/dma/ioat*
 
 INTEL IOMMU (VT-d)
@@ -3603,8 +3602,8 @@ F:	drivers/iommu/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
-M:	Dan Williams <dan.j.williams@intel.com>
-S:	Maintained
+M:	Dan Williams <djbw@fb.com>
+S:	Odd fixes
 F:	drivers/dma/iop-adma.c
 
 INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT

