From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 46/53] ia64, scsi: update references for the device-io book
Date: Tue, 16 May 2017 09:16:38 -0300
Message-ID: <2a76213072c8d6ac4364455e236d52b7d36601ca.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Richard Weinberger <richard@nod.at>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, linux-mtd@lists.infradead.org, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michael Reed <mdr@sgi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The book is now at Documentation/driver-api/device-io.rst.
Update such references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 arch/ia64/include/asm/io.h | 2 +-
 arch/ia64/sn/kernel/iomv.c | 2 +-
 drivers/scsi/qla1280.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 5de673ac9cb1..a2540e21f919 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -117,7 +117,7 @@ extern int valid_mmap_phys_addr_range (unsigned long pfn, size_t count);
  * following the barrier will arrive after all previous writes.  For most
  * ia64 platforms, this is a simple 'mf.a' instruction.
  *
- * See Documentation/DocBook/deviceiobook.tmpl for more information.
+ * See Documentation/driver-api/device-io.rst for more information.
  */
 static inline void ___ia64_mmiowb(void)
 {
diff --git a/arch/ia64/sn/kernel/iomv.c b/arch/ia64/sn/kernel/iomv.c
index c77ebdf98119..2b22a71663c1 100644
--- a/arch/ia64/sn/kernel/iomv.c
+++ b/arch/ia64/sn/kernel/iomv.c
@@ -63,7 +63,7 @@ EXPORT_SYMBOL(sn_io_addr);
 /**
  * __sn_mmiowb - I/O space memory barrier
  *
- * See arch/ia64/include/asm/io.h and Documentation/DocBook/deviceiobook.tmpl
+ * See arch/ia64/include/asm/io.h and Documentation/driver-api/device-io.rst
  * for details.
  *
  * On SN2, we wait for the PIO_WRITE_STATUS SHub register to clear.
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 634254a52301..8a29fb09db14 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3390,7 +3390,7 @@ qla1280_isp_cmd(struct scsi_qla_host *ha)
 	 *    On PCI bus, order reverses and write of 6 posts, then index 5,
 	 *       causing chip to issue full queue of stale commands
 	 * The mmiowb() prevents future writes from crossing the barrier.
-	 * See Documentation/DocBook/deviceiobook.tmpl for more information.
+	 * See Documentation/driver-api/device-io.rst for more information.
 	 */
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
 	mmiowb();
-- 
2.9.3
