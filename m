From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] scsi: Export scsi_bus_type
Date: Wed, 15 Sep 2010 15:57:59 -0400
Message-ID: <1284580683-2386-1-git-send-email-mjg@redhat.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, lenb@kernel.org, James.Bottomley@suse.de, jgarzik@pobox.com, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We need scsi_bus_type in order to be able to bind ata devices against acpi
devices. Export it from the scsi core.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/scsi/scsi_priv.h |    1 -
 include/scsi/scsi.h      |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..ff1e284 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -132,7 +132,6 @@ extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
-extern struct bus_type scsi_bus_type;
 extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8fcb6e0..6eb0c90 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -149,6 +149,8 @@ struct scsi_cmnd;
 
 #define SCSI_MAX_VARLEN_CDB_SIZE 260
 
+extern struct bus_type scsi_bus_type;
+
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
 	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-- 
1.7.1

