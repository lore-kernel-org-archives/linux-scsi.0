Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D225C35DF9
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64FD721D7E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgBYGYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:24:14 -0500
Received: from smtp.infotech.no ([82.134.31.41]:36105 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbgBYGYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 01:24:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 471B320423A;
        Tue, 25 Feb 2020 07:24:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 22Ys9o0atFb7; Tue, 25 Feb 2020 07:24:10 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A27242041F1;
        Tue, 25 Feb 2020 07:24:08 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v4 10/14] scsi_debug: re-arrange parameters alphabetically
Date:   Tue, 25 Feb 2020 01:23:47 -0500
Message-Id: <20200225062351.21267-11-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225062351.21267-1-dgilbert@interlog.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This module has a lot of parameters and when searching for
one, the author prefers them in alphabetical orders. This can
lead to somewhat illogical ordering (e.g. inq_product before
inq_vendor) but it is not clear what another total logical
ordering would be.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ddd8dc784f7e..7e601e96808e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5406,30 +5406,32 @@ module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, sdebug_guard, uint, S_IRUGO);
 module_param_named(host_lock, sdebug_host_lock, bool, S_IRUGO | S_IWUSR);
-module_param_string(inq_vendor, sdebug_inq_vendor_id,
-		    sizeof(sdebug_inq_vendor_id), S_IRUGO|S_IWUSR);
 module_param_string(inq_product, sdebug_inq_product_id,
-		    sizeof(sdebug_inq_product_id), S_IRUGO|S_IWUSR);
+		    sizeof(sdebug_inq_product_id), S_IRUGO | S_IWUSR);
 module_param_string(inq_rev, sdebug_inq_product_rev,
-		    sizeof(sdebug_inq_product_rev), S_IRUGO|S_IWUSR);
+		    sizeof(sdebug_inq_product_rev), S_IRUGO | S_IWUSR);
+module_param_string(inq_vendor, sdebug_inq_vendor_id,
+		    sizeof(sdebug_inq_vendor_id), S_IRUGO | S_IWUSR);
+module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
+module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
-module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
-module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
-module_param_named(medium_error_start, sdebug_medium_error_start, int, S_IRUGO | S_IWUSR);
-module_param_named(medium_error_count, sdebug_medium_error_count, int, S_IRUGO | S_IWUSR);
+module_param_named(medium_error_count, sdebug_medium_error_count, int,
+		   S_IRUGO | S_IWUSR);
+module_param_named(medium_error_start, sdebug_medium_error_start, int,
+		   S_IRUGO | S_IWUSR);
 module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
 module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
 module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
+module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(opts, sdebug_opts, int, S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
-module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(random, sdebug_random, bool, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
@@ -5442,8 +5444,8 @@ module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, sdebug_unmap_max_desc, int, S_IRUGO);
-module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(uuid_ctl, sdebug_uuid_ctl, int, S_IRUGO);
+module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
@@ -5464,35 +5466,35 @@ MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
-MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(doublestore, "If set, 2 data buffers allocated, devices alternate between the two");
+MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
-MODULE_PARM_DESC(inq_vendor, "SCSI INQUIRY vendor string (def=\"Linux\")");
 MODULE_PARM_DESC(inq_product, "SCSI INQUIRY product string (def=\"scsi_debug\")");
 MODULE_PARM_DESC(inq_rev, "SCSI INQUIRY revision string (def=\""
 		 SDEBUG_VERSION "\")");
+MODULE_PARM_DESC(inq_vendor, "SCSI INQUIRY vendor string (def=\"Linux\")");
+MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
+MODULE_PARM_DESC(lbprz,
+		 "on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(lbprz,
-	"on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
-MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
-MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
+MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
+MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
-MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
@@ -6290,8 +6292,8 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_delay.attr,
 	&driver_attr_opts.attr,
 	&driver_attr_ptype.attr,
-	&driver_attr_dsense.attr,
 	&driver_attr_doublestore.attr,
+	&driver_attr_dsense.attr,
 	&driver_attr_fake_rw.attr,
 	&driver_attr_no_lun_0.attr,
 	&driver_attr_num_tgts.attr,
-- 
2.25.1

