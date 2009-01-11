From: Jan Engelhardt <jengelh@medozas.de>
Subject: scsi: constify VFTs
Date: Sun, 11 Jan 2009 10:38:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901111038370.9874@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901111037460.9874@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52715 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZAKJjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2009 04:39:00 -0500
In-Reply-To: <alpine.LSU.2.00.0901111037460.9874@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

parent 55840de5a8bee6494db6a79c231ec76e22417534 (v2.6.29-rc1-4-g55840de)
commit 2b9b79b49bef5f00559bb275400ae024434db780
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jan 11 10:37:26 2009 +0100

scsi: constify VFTs

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |   16 ++++++++--------
 drivers/scsi/sg.c                |   30 +++++++++++++++---------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index b615eda..81cdcf4 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1132,7 +1132,7 @@ lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
 }
 
 #undef lpfc_debugfs_op_disc_trc
-static struct file_operations lpfc_debugfs_op_disc_trc = {
+static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_disc_trc_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1141,7 +1141,7 @@ static struct file_operations lpfc_debugfs_op_disc_trc = {
 };
 
 #undef lpfc_debugfs_op_nodelist
-static struct file_operations lpfc_debugfs_op_nodelist = {
+static const struct file_operations lpfc_debugfs_op_nodelist = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_nodelist_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1150,7 +1150,7 @@ static struct file_operations lpfc_debugfs_op_nodelist = {
 };
 
 #undef lpfc_debugfs_op_hbqinfo
-static struct file_operations lpfc_debugfs_op_hbqinfo = {
+static const struct file_operations lpfc_debugfs_op_hbqinfo = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_hbqinfo_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1159,7 +1159,7 @@ static struct file_operations lpfc_debugfs_op_hbqinfo = {
 };
 
 #undef lpfc_debugfs_op_dumpHBASlim
-static struct file_operations lpfc_debugfs_op_dumpHBASlim = {
+static const struct file_operations lpfc_debugfs_op_dumpHBASlim = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_dumpHBASlim_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1168,7 +1168,7 @@ static struct file_operations lpfc_debugfs_op_dumpHBASlim = {
 };
 
 #undef lpfc_debugfs_op_dumpHostSlim
-static struct file_operations lpfc_debugfs_op_dumpHostSlim = {
+static const struct file_operations lpfc_debugfs_op_dumpHostSlim = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_dumpHostSlim_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1177,7 +1177,7 @@ static struct file_operations lpfc_debugfs_op_dumpHostSlim = {
 };
 
 #undef lpfc_debugfs_op_dumpData
-static struct file_operations lpfc_debugfs_op_dumpData = {
+static const struct file_operations lpfc_debugfs_op_dumpData = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_dumpData_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1187,7 +1187,7 @@ static struct file_operations lpfc_debugfs_op_dumpData = {
 };
 
 #undef lpfc_debugfs_op_dumpDif
-static struct file_operations lpfc_debugfs_op_dumpDif = {
+static const struct file_operations lpfc_debugfs_op_dumpDif = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_dumpDif_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -1197,7 +1197,7 @@ static struct file_operations lpfc_debugfs_op_dumpDif = {
 };
 
 #undef lpfc_debugfs_op_slow_ring_trc
-static struct file_operations lpfc_debugfs_op_slow_ring_trc = {
+static const struct file_operations lpfc_debugfs_op_slow_ring_trc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_slow_ring_trc_open,
 	.llseek =       lpfc_debugfs_lseek,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cb830fc..752f16e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1332,7 +1332,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 	}
 }
 
-static struct file_operations sg_fops = {
+static const struct file_operations sg_fops = {
 	.owner = THIS_MODULE,
 	.read = sg_read,
 	.write = sg_write,
@@ -2216,14 +2216,14 @@ sg_get_dev(int dev)
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
 
-static char sg_proc_sg_dirname[] = "scsi/sg";
+static const char sg_proc_sg_dirname[] = "scsi/sg";
 
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
 static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
-static struct file_operations adio_fops = {
+static const struct file_operations adio_fops = {
 	.open = sg_proc_single_open_adio,
 	.write = sg_proc_write_adio,
 	.release = single_release,
@@ -2235,7 +2235,7 @@ static struct file_operations adio_fops = {
 static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
-static struct file_operations dressz_fops = {
+static const struct file_operations dressz_fops = {
 	.open = sg_proc_single_open_dressz,
 	.write = sg_proc_write_dressz,
 	.release = single_release,
@@ -2246,7 +2246,7 @@ static struct file_operations dressz_fops = {
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
 static int sg_proc_single_open_version(struct inode *inode, struct file *file);
-static struct file_operations version_fops = {
+static const struct file_operations version_fops = {
 	.open = sg_proc_single_open_version,
 	.release = single_release,
 	.read = seq_read,
@@ -2256,7 +2256,7 @@ static struct file_operations version_fops = {
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
 static int sg_proc_single_open_devhdr(struct inode *inode, struct file *file);
-static struct file_operations devhdr_fops = {
+static const struct file_operations devhdr_fops = {
 	.open = sg_proc_single_open_devhdr,
 	.release = single_release,
 	.read = seq_read,
@@ -2269,14 +2269,14 @@ static int sg_proc_open_dev(struct inode *inode, struct file *file);
 static void * dev_seq_start(struct seq_file *s, loff_t *pos);
 static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos);
 static void dev_seq_stop(struct seq_file *s, void *v);
-static struct file_operations dev_fops = {
+static const struct file_operations dev_fops = {
 	.open = sg_proc_open_dev,
 	.release = seq_release,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.owner = THIS_MODULE,
 };
-static struct seq_operations dev_seq_ops = {
+static const struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2285,14 +2285,14 @@ static struct seq_operations dev_seq_ops = {
 
 static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v);
 static int sg_proc_open_devstrs(struct inode *inode, struct file *file);
-static struct file_operations devstrs_fops = {
+static const struct file_operations devstrs_fops = {
 	.open = sg_proc_open_devstrs,
 	.release = seq_release,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.owner = THIS_MODULE,
 };
-static struct seq_operations devstrs_seq_ops = {
+static const struct seq_operations devstrs_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2301,14 +2301,14 @@ static struct seq_operations devstrs_seq_ops = {
 
 static int sg_proc_seq_show_debug(struct seq_file *s, void *v);
 static int sg_proc_open_debug(struct inode *inode, struct file *file);
-static struct file_operations debug_fops = {
+static const struct file_operations debug_fops = {
 	.open = sg_proc_open_debug,
 	.release = seq_release,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.owner = THIS_MODULE,
 };
-static struct seq_operations debug_seq_ops = {
+static const struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2318,10 +2318,10 @@ static struct seq_operations debug_seq_ops = {
 
 struct sg_proc_leaf {
 	const char * name;
-	struct file_operations * fops;
+	const struct file_operations *fops;
 };
 
-static struct sg_proc_leaf sg_proc_leaf_arr[] = {
+static const struct sg_proc_leaf sg_proc_leaf_arr[] = {
 	{"allow_dio", &adio_fops},
 	{"debug", &debug_fops},
 	{"def_reserved_size", &dressz_fops},
@@ -2336,7 +2336,7 @@ sg_proc_init(void)
 {
 	int k, mask;
 	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
-	struct sg_proc_leaf * leaf;
+	const struct sg_proc_leaf *leaf;
 
 	sg_proc_sgp = proc_mkdir(sg_proc_sg_dirname, NULL);
 	if (!sg_proc_sgp)
-- 
# Created with git-export-patch
