From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v4 5/5] FireWire: add driver-api Introduction section
Date: Tue,  4 Sep 2018 17:02:25 -0700
Message-ID: <20180905000225.10733-6-rd.dunlab@gmail.com>
References: <20180905000225.10733-1-rd.dunlab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180905000225.10733-1-rd.dunlab@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: Jonathan Corbet <corbet@lwn.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

Replace the Introduction section's TBD with some useful overview text.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: linux-doc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/driver-api/firewire.rst |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- linux-next-20180904.orig/Documentation/driver-api/firewire.rst
+++ linux-next-20180904/Documentation/driver-api/firewire.rst
@@ -5,17 +5,32 @@ Firewire (IEEE 1394) driver Interface Gu
 Introduction and Overview
 =========================
 
-TBD
+The Linux FireWire subsystem adds some interfaces into the Linux system to
+ use/maintain+any resource on IEEE 1394 bus.
+
+The main purpose of these interfaces is to access address space on each node
+on IEEE 1394 bus by ISO/IEC 13213 (IEEE 1212) procedure, and to control
+isochronous resources on the bus by IEEE 1394 procedure.
+
+Two types of interfaces are added, according to consumers of the interface. A
+set of userspace interfaces is available via `firewire character devices`. A set
+of kernel interfaces is available via exported symbols in `firewire-core` module.
 
 Firewire char device data structures
 ====================================
 
+.. include:: /ABI/stable/firewire-cdev
+    :literal:
+
 .. kernel-doc:: include/uapi/linux/firewire-cdev.h
     :internal:
 
 Firewire device probing and sysfs interfaces
 ============================================
 
+.. include:: /ABI/stable/sysfs-bus-firewire
+    :literal:
+
 .. kernel-doc:: drivers/firewire/core-device.c
     :export:
 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
