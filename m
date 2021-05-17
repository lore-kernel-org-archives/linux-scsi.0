Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F200AC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5C4D610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbhEQKBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 06:01:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2996 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbhEQKBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 06:01:11 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkDzs2wvwzQpQ0;
        Mon, 17 May 2021 17:56:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 17:59:53 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 17:59:52 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        open-iscsi <open-iscsi@googlegroups.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: Fix spelling mistakes in header files
Date:   Mon, 17 May 2021 17:59:45 +0800
Message-ID: <20210517095945.7363-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix some spelling mistakes in comments:
pathes ==> paths
Resouce ==> Resource
retreived ==> retrieved
keep-alives ==> keep-alive
recevied ==> received
busses ==> buses
interruped ==> interrupted

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/scsi/iscsi_proto.h    | 2 +-
 include/scsi/libfc.h          | 6 +++---
 include/scsi/libfcoe.h        | 2 +-
 include/scsi/scsi_bsg_iscsi.h | 2 +-
 include/scsi/scsi_host.h      | 2 +-
 include/scsi/sg.h             | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index b71b5c4f418c..7b192d88f186 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -52,7 +52,7 @@ static inline int iscsi_sna_gte(u32 n1, u32 n2)
 }
 
 /*
- * useful common(control and data pathes) macro
+ * useful common(control and data paths) macro
  */
 #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
 #define hton24(p, v) { \
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9b87e1a1c646..eeb8d689ff6b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -399,7 +399,7 @@ struct fc_seq {
  * @sid:          Source FCID
  * @did:          Destination FCID
  * @esb_stat:     ESB exchange status
- * @r_a_tov:      Resouce allocation time out value (in msecs)
+ * @r_a_tov:      Resource allocation time out value (in msecs)
  * @seq_id:       The next sequence ID to use
  * @encaps:       encapsulation information for lower-level driver
  * @f_ctl:        F_CTL flags for the sequence
@@ -668,7 +668,7 @@ enum fc_lport_event {
  * @wwnn:                  World Wide Node Name
  * @service_params:        Common service parameters
  * @e_d_tov:               Error detection timeout value
- * @r_a_tov:               Resouce allocation timeout value
+ * @r_a_tov:               Resource allocation timeout value
  * @rnid_gen:              RNID information
  * @sg_supp:               Indicates if scatter gather is supported
  * @seq_offload:           Indicates if sequence offload is supported
@@ -841,7 +841,7 @@ static inline void fc_lport_free_stats(struct fc_lport *lport)
 
 /**
  * lport_priv() - Return the private data from a local port
- * @lport: The local port whose private data is to be retreived
+ * @lport: The local port whose private data is to be retrieved
  */
 static inline void *lport_priv(const struct fc_lport *lport)
 {
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index fac8e89aed81..089aa1f201ac 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -87,7 +87,7 @@ enum fip_mode {
  * @port_ka_time:  time of next port keep-alive.
  * @ctlr_ka_time:  time of next controller keep-alive.
  * @timer:	   timer struct used for all delayed events.
- * @timer_work:	   &work_struct for doing keep-alives and resets.
+ * @timer_work:	   &work_struct for doing keep-alive and resets.
  * @recv_work:	   &work_struct for receiving FIP frames.
  * @fip_recv_list: list of received FIP frames.
  * @flogi_req:	   clone of FLOGI request sent
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 6b8128005af8..9b1f0f424a79 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -84,7 +84,7 @@ struct iscsi_bsg_reply {
 	 */
 	uint32_t result;
 
-	/* If there was reply_payload, how much was recevied ? */
+	/* If there was reply_payload, how much was received ? */
 	uint32_t reply_payload_rcv_len;
 
 	union {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0bf88d77f02..9448225a9904 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -582,7 +582,7 @@ struct Scsi_Host {
 
 	/*
 	 * These three parameters can be used to allow for wide scsi,
-	 * and for host adapters that support multiple busses
+	 * and for host adapters that support multiple buses
 	 * The last two should be set to 1 more than the actual max id
 	 * or lun (e.g. 8 for SCSI parallel systems).
 	 */
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 7327e12f3373..e1a42c2409cc 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -145,7 +145,7 @@ typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
 
 typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
     char req_state;     /* 0 -> not used, 1 -> written, 2 -> ready to read */
-    char orphan;        /* 0 -> normal request, 1 -> from interruped SG_IO */
+    char orphan;        /* 0 -> normal request, 1 -> from interrupted SG_IO */
     char sg_io_owned;   /* 0 -> complete with read(), 1 -> owned by SG_IO */
     char problem;       /* 0 -> no problem detected, 1 -> error to report */
     int pack_id;        /* pack_id associated with request */
-- 
2.25.1


