From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] arcmsr: add const to bin_attribute structures
Date: Tue,  1 Aug 2017 19:51:14 +0530
Message-ID: <1501597274-5544-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Add const to bin_attribute structures as they are only passed to the
functions system_{remove/create}_bin_file. The arguments passed are of
type const, so declare the structures to be const.

Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 9c86481..259d9c2 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -190,7 +190,7 @@ static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
 	return 1;
 }
 
-static struct bin_attribute arcmsr_sysfs_message_read_attr = {
+static const struct bin_attribute arcmsr_sysfs_message_read_attr = {
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
@@ -199,7 +199,7 @@ static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
 	.read = arcmsr_sysfs_iop_message_read,
 };
 
-static struct bin_attribute arcmsr_sysfs_message_write_attr = {
+static const struct bin_attribute arcmsr_sysfs_message_write_attr = {
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
@@ -208,7 +208,7 @@ static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
 	.write = arcmsr_sysfs_iop_message_write,
 };
 
-static struct bin_attribute arcmsr_sysfs_message_clear_attr = {
+static const struct bin_attribute arcmsr_sysfs_message_clear_attr = {
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
-- 
1.9.1
