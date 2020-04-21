Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF768C54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D212A206A5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgDUPOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:14:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41971 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgDUPOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:14:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DBDEA204148;
        Tue, 21 Apr 2020 17:14:43 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 89eHWhLvgbYy; Tue, 21 Apr 2020 17:14:41 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 3706920424C;
        Tue, 21 Apr 2020 17:14:39 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v5 7/8] scsi_debug: re-arrange parameters alphabetically
Date:   Tue, 21 Apr 2020 11:14:23 -0400
Message-Id: <20200421151424.32668-8-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421151424.32668-1-dgilbert@interlog.com>
References: <20200421151424.32668-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This module has a lot of parameters and when searching for one, the
author prefers them in alphabetical order. This can lead to somewhat
illogical ordering (e.g. inq_product before inq_vendor). However it
is not clear what another sensible total logical ordering would be.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f63eee5bae5d..4b15f3f93c7c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4683,32 +4683,34 @@ module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
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
+module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
-module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
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
 module_param_named(per_host_store, sdebug_per_host_store, bool,
 		   S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
-module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(random, sdebug_random, bool, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
@@ -4721,8 +4723,8 @@ module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, sdebug_unmap_max_desc, int, S_IRUGO);
-module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(uuid_ctl, sdebug_uuid_ctl, int, S_IRUGO);
+module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
@@ -4734,7 +4736,7 @@ MODULE_DESCRIPTION("SCSI debug adapter driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(SDEBUG_VERSION);
 
-MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
+MODULE_PARM_DESC(add_host, "add n hosts, in sysfs if negative remove host(s) (def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(cdb_len, "suggest CDB lengths to drivers (def=10)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
@@ -4747,30 +4749,30 @@ MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
-MODULE_PARM_DESC(inq_vendor, "SCSI INQUIRY vendor string (def=\"Linux\")");
 MODULE_PARM_DESC(inq_product, "SCSI INQUIRY product string (def=\"scsi_debug\")");
 MODULE_PARM_DESC(inq_rev, "SCSI INQUIRY revision string (def=\""
 		 SDEBUG_VERSION "\")");
+MODULE_PARM_DESC(inq_vendor, "SCSI INQUIRY vendor string (def=\"Linux\")");
+MODULE_PARM_DESC(lbprz,
+		 "on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(lbprz,
-	"on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
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
-MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get new store");
+MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get new store (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
-MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
-- 
2.26.1

