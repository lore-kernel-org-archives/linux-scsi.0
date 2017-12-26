From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] documentation: add a target/iscsi driver document
Date: Tue, 26 Dec 2017 15:50:50 -0800
Message-ID: <2affd531-43d1-c798-8467-dece4b88a1df@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add a driver-api document for target/iSCSI interfaces.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
This patch depends on 4 previous patches to driver source files:

[PATCH] target: fix kernel-doc warnings in drivers/target/target_core_transport.c
  https://marc.info/?l=linux-scsi&m=151398041926906&w=2

[PATCH] scsi: fix iscsi-related kernel-doc warnings
  https://marc.info/?l=linux-scsi&m=151398051426923&w=2

[PATCH] target: add kernel-doc overview in target_core_user.[hc]
  [PATCH] target: add kernel-doc overview in target_core_user.[hc]

[PATCH] target: cleanup target_core_transport.c for kernel-doc
  https://marc.info/?l=linux-scsi&m=151409284812033&w=2

 Documentation/driver-api/index.rst  |    1 
 Documentation/driver-api/scsi.rst   |    2 
 Documentation/driver-api/target.rst |   64 ++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

--- linux-next-20171221.orig/Documentation/driver-api/index.rst
+++ linux-next-20171221/Documentation/driver-api/index.rst
@@ -34,6 +34,7 @@ available subsections can be seen below.
    edac
    scsi
    libata
+   target
    mtdnand
    miscellaneous
    w1
--- linux-next-20171221.orig/Documentation/driver-api/scsi.rst
+++ linux-next-20171221/Documentation/driver-api/scsi.rst
@@ -340,5 +340,5 @@ todo
 ~~~~
 
 Parallel (fast/wide/ultra) SCSI, USB, SATA, SAS, Fibre Channel,
-FireWire, ATAPI devices, Infiniband, I2O, iSCSI, Parallel ports,
+FireWire, ATAPI devices, Infiniband, I2O, Parallel ports,
 netlink...
--- /dev/null
+++ linux-next-20171221/Documentation/driver-api/target.rst
@@ -0,0 +1,64 @@
+=================================
+target and iSCSI Interfaces Guide
+=================================
+
+Introduction and Overview
+=========================
+
+TBD
+
+Target core device interfaces
+=============================
+
+.. kernel-doc:: drivers/target/target_core_device.c
+    :export:
+
+Target core transport interfaces
+================================
+
+.. kernel-doc:: drivers/target/target_core_transport.c
+    :export:
+
+Target-supported userspace I/O
+==============================
+
+.. kernel-doc:: drivers/target/target_core_user.c
+    :doc: Userspace I/O
+
+.. kernel-doc:: include/uapi/linux/target_core_user.h
+    :doc: Ring Design
+
+iSCSI helper functions
+======================
+
+.. kernel-doc:: drivers/scsi/libiscsi.c
+   :export:
+
+
+iSCSI boot information
+======================
+
+.. kernel-doc:: drivers/scsi/iscsi_boot_sysfs.c
+   :export
+
+
+iSCSI transport class
+=====================
+
+The file drivers/scsi/scsi_transport_iscsi.c defines transport
+attributes for the iSCSI class, which sends SCSI packets over TCP/IP
+connections.
+
+.. kernel-doc:: drivers/scsi/scsi_transport_iscsi.c
+   :export:
+
+
+iSCSI TCP interfaces
+====================
+
+.. kernel-doc:: drivers/scsi/iscsi_tcp.c
+   :internal:
+
+.. kernel-doc:: drivers/scsi/libiscsi_tcp.c
+   :export:
+
