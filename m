From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v4 4/5] FireWire: add a Documentation driver-api chapter
Date: Tue,  4 Sep 2018 17:02:24 -0700
Message-ID: <20180905000225.10733-5-rd.dunlab@gmail.com>
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

From: Randy Dunlap <rdunlap@infradead.org>

Add a basic Firewire/IEEE 1394 driver API chapter to the Linux
kernel documentation.

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
 Documentation/driver-api/firewire.rst |   33 ++++++++++++++++++++++++
 Documentation/driver-api/index.rst    |    1 
 2 files changed, 34 insertions(+)

--- /dev/null
+++ linux-next-20180904/Documentation/driver-api/firewire.rst
@@ -0,0 +1,33 @@
+===========================================
+Firewire (IEEE 1394) driver Interface Guide
+===========================================
+
+Introduction and Overview
+=========================
+
+TBD
+
+Firewire char device data structures
+====================================
+
+.. kernel-doc:: include/uapi/linux/firewire-cdev.h
+    :internal:
+
+Firewire device probing and sysfs interfaces
+============================================
+
+.. kernel-doc:: drivers/firewire/core-device.c
+    :export:
+
+Firewire core transaction interfaces
+====================================
+
+.. kernel-doc:: drivers/firewire/core-transaction.c
+    :export:
+
+Firewire Isochronous I/O interfaces
+===================================
+
+.. kernel-doc:: drivers/firewire/core-iso.c
+   :export:
+
--- linux-next-20180904.orig/Documentation/driver-api/index.rst
+++ linux-next-20180904/Documentation/driver-api/index.rst
@@ -29,6 +29,7 @@ available subsections can be seen below.
    iio/index
    input
    usb/index
+   firewire
    pci
    spi
    i2c

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
