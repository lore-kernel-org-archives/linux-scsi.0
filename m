From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 09/15] isci: update version to 1.1
Date: Wed, 04 Jan 2012 01:33:10 -0800
Message-ID: <20120104093310.9147.85218.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2ADJdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:11 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bump the version now that the driver has atapi support and the initial
round of hotplug fixes.  The EXPERIMENTAL tag should have been removed a
while back.  While we're here also kill the "select SCSI_SAS_HOST_SMP"
as the build error was separately fixed by commit d962480e "[SCSI]
libsas: fix try_test_sas_gpio_gp_bit() build error".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/Kconfig     |    5 -----
 drivers/scsi/isci/init.c |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 06ea3bc..16570aa 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -830,16 +830,11 @@ config SCSI_ISCI
 	tristate "Intel(R) C600 Series Chipset SAS Controller"
 	depends on PCI && SCSI
 	depends on X86
-	# (temporary): known alpha quality driver
-	depends on EXPERIMENTAL
 	select SCSI_SAS_LIBSAS
-	select SCSI_SAS_HOST_SMP
 	---help---
 	  This driver supports the 6Gb/s SAS capabilities of the storage
 	  control unit found in the Intel(R) C600 series chipset.
 
-	  The experimental tag will be removed after the driver exits alpha
-
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
 	depends on ISA && SCSI
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 2bcfb40..17c4c2c 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,7 +65,7 @@
 #include "probe_roms.h"
 
 #define MAJ 1
-#define MIN 0
+#define MIN 1
 #define BUILD 0
 #define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
 	__stringify(BUILD)

