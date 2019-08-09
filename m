Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57ED8C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4B0216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404951AbfHIDCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35613 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404679AbfHIDCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so3368356pgv.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkVWmYOv8xZ9XIu5KNR0485xzNHtzoGRqtIz5Xb1I0Y=;
        b=mliQ7Dha7WyCEo5uj9FXNjObThgCVv8htDLharOA1Vkwinrz9/UCkZ/YCGERZ/yzw7
         qgDXjzGLX7n3CU+b8h3ZMjiiwNzZn8DEp79jg0wnUtlC3jBg661+vEmNcMBjx0dYRkGq
         m1gkhrA5ZCFicp7d0MQebd6LofuGWOx7e4/QdYuShWKe6M2W4HNDhdWBueZMhrE4S92e
         ABDZRJYzYquDq1F+qPJLouk3TKLHZN15a6/O/mnBlSWoqaSF2x5Yl7gc0siZ+rAI1NCB
         hbTAOECglrXB7IoQlCoALSxNYmXG5hhCo7TBJ7MZZNoMZjuwmvLYpfBcMh7jyQ4R1/RD
         JCoA==
X-Gm-Message-State: APjAAAWizWW81pZ2Jw8PGbg0CsHYKvh2aqcCpCMiqEZ0JL2EA3fxWJT5
        6is5laI/4kwNKbQKYbzyxak=
X-Google-Smtp-Source: APXvYqzJ5qEK3h4vIQ31gqFMfQIIKK/cJhV8WbzOnKsD3U4Dd6SlkKteeK08HbudrrzfNEpoJfQ/yg==
X-Received: by 2002:a17:90a:6546:: with SMTP id f6mr7130943pjs.11.1565319760593;
        Thu, 08 Aug 2019 20:02:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 03/58] qla2xxx: Improve Linux kernel coding style conformance
Date:   Thu,  8 Aug 2019 20:01:24 -0700
Message-Id: <20190809030219.11296-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Insert a space where required, surround complex expressions in macros
with parentheses, use the UL suffix instead of the (unsigned long) cast,
do not use line continuations when not necessary and do not explicitly
initialize static variables to zero.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 10 +++++-----
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c |  1 +
 drivers/scsi/qla2xxx/qla_nvme.c |  1 -
 drivers/scsi/qla2xxx/qla_nx.c   | 10 +++++-----
 drivers/scsi/qla2xxx/qla_nx.h   | 14 +++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |  6 +++---
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b91ef7b75e8d..a94b0d440f0f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -117,9 +117,9 @@
 #define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
 #define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
 #define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
-#define WRT_REG_BYTE(addr, data)	writeb(data,addr)
-#define WRT_REG_WORD(addr, data)	writew(data,addr)
-#define WRT_REG_DWORD(addr, data)	writel(data,addr)
+#define WRT_REG_BYTE(addr, data)	writeb(data, addr)
+#define WRT_REG_WORD(addr, data)	writew(data, addr)
+#define WRT_REG_DWORD(addr, data)	writel(data, addr)
 
 /*
  * ISP83XX specific remote register addresses
@@ -207,7 +207,7 @@
  * 133Mhz slot.
  */
 #define RD_REG_WORD_PIO(addr)		(inw((unsigned long)addr))
-#define WRT_REG_WORD_PIO(addr, data)	(outw(data,(unsigned long)addr))
+#define WRT_REG_WORD_PIO(addr, data)	(outw(data, (unsigned long)addr))
 
 /*
  * Fibre Channel device definitions.
@@ -3851,7 +3851,7 @@ struct qla_hw_data {
 
 	/* NVRAM configuration data */
 #define MAX_NVRAM_SIZE  4096
-#define VPD_OFFSET      MAX_NVRAM_SIZE / 2
+#define VPD_OFFSET      (MAX_NVRAM_SIZE / 2)
 	uint16_t	nvram_size;
 	uint16_t	nvram_base;
 	void		*nvram;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d82d1a2b3543..3585eb7b87b5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5397,7 +5397,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    "%s %8phN. rport %p is %s mode\n",
 	    __func__, fcport->port_name, rport,
 	    (fcport->port_type == FCT_TARGET) ? "tgt" :
-	    ((fcport->port_type & FCT_NVME) ? "nvme" :"ini"));
+	    ((fcport->port_type & FCT_NVME) ? "nvme" : "ini"));
 
 	fc_remote_port_rolechg(rport, rport_ids.roles);
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1886de92034c..b514ab4d243e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1364,6 +1364,7 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 	cur_dsd++;
 	return 0;
 }
+
 /**
  * qla24xx_build_scsi_crc_2_iocbs() - Build IOCB command utilizing Command
  *							Type 6 IOCB types.
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index af7919a5acdc..16028ee8c7a7 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -267,7 +267,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	schedule_work(&priv->abort_work);
 }
 
-
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
     struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
 {
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c760ae354174..c1c832271ccb 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1985,7 +1985,7 @@ qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
 }
 
 /* ISR related functions */
-static struct qla82xx_legacy_intr_set legacy_intr[] = \
+static struct qla82xx_legacy_intr_set legacy_intr[] =
 	QLA82XX_LEGACY_INTR_CONFIG;
 
 /*
@@ -3286,7 +3286,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 		case QLA8XXX_DEV_NEED_QUIESCENT:
 			qla82xx_need_qsnt_handler(vha);
 			/* Reset timeout value after quiescence handler */
-			dev_init_timeout = jiffies + (ha->fcoe_dev_init_timeout\
+			dev_init_timeout = jiffies + (ha->fcoe_dev_init_timeout
 							 * HZ);
 			break;
 		case QLA8XXX_DEV_QUIESCENT:
@@ -3301,7 +3301,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			qla82xx_idc_lock(ha);
 
 			/* Reset timeout value after quiescence handler */
-			dev_init_timeout = jiffies + (ha->fcoe_dev_init_timeout\
+			dev_init_timeout = jiffies + (ha->fcoe_dev_init_timeout
 							 * HZ);
 			break;
 		case QLA8XXX_DEV_FAILED:
@@ -4232,7 +4232,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 		goto md_failed;
 	}
 
-	entry_hdr = (qla82xx_md_entry_hdr_t *) \
+	entry_hdr = (qla82xx_md_entry_hdr_t *)
 	    (((uint8_t *)ha->md_tmplt_hdr) + tmplt_hdr->first_entry_offset);
 
 	/* Walk through the entry headers */
@@ -4339,7 +4339,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 		data_collected = (uint8_t *)data_ptr -
 		    (uint8_t *)ha->md_dump;
 skip_nxt_entry:
-		entry_hdr = (qla82xx_md_entry_hdr_t *) \
+		entry_hdr = (qla82xx_md_entry_hdr_t *)
 		    (((uint8_t *)entry_hdr) + entry_hdr->entry_size);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 3c7beef92c35..230abee10598 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -486,13 +486,13 @@
 #define QLA82XX_ADDR_QDR_NET		(0x0000000300000000ULL)
 #define QLA82XX_P3_ADDR_QDR_NET_MAX	(0x0000000303ffffffULL)
 
-#define QLA82XX_PCI_CRBSPACE		(unsigned long)0x06000000
-#define QLA82XX_PCI_DIRECT_CRB		(unsigned long)0x04400000
-#define QLA82XX_PCI_CAMQM		(unsigned long)0x04800000
-#define QLA82XX_PCI_CAMQM_MAX		(unsigned long)0x04ffffff
-#define QLA82XX_PCI_DDR_NET		(unsigned long)0x00000000
-#define QLA82XX_PCI_QDR_NET		(unsigned long)0x04000000
-#define QLA82XX_PCI_QDR_NET_MAX		(unsigned long)0x043fffff
+#define QLA82XX_PCI_CRBSPACE		0x06000000UL
+#define QLA82XX_PCI_DIRECT_CRB		0x04400000UL
+#define QLA82XX_PCI_CAMQM		0x04800000UL
+#define QLA82XX_PCI_CAMQM_MAX		0x04ffffffUL
+#define QLA82XX_PCI_DDR_NET		0x00000000UL
+#define QLA82XX_PCI_QDR_NET		0x04000000UL
+#define QLA82XX_PCI_QDR_NET_MAX		0x043fffffUL
 
 /*
  *   Register offsets for MN
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index db1f1aac79f2..8f972e1b5215 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -69,7 +69,7 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"a Fabric scan.  This is needed for several broken switches. "
 		"Default is 0 - no PLOGI. 1 - perform PLOGI.");
 
-int ql2xloginretrycount = 0;
+int ql2xloginretrycount;
 module_param(ql2xloginretrycount, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
@@ -234,7 +234,7 @@ MODULE_PARM_DESC(ql2xmdenable,
 		"0 - MiniDump disabled. "
 		"1 (Default) - MiniDump enabled.");
 
-int ql2xexlogins = 0;
+int ql2xexlogins;
 module_param(ql2xexlogins, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xexlogins,
 		 "Number of extended Logins. "
@@ -250,7 +250,7 @@ module_param(ql2xiniexchg, uint, 0644);
 MODULE_PARM_DESC(ql2xiniexchg,
 	"Number of initiator exchanges.");
 
-int ql2xfwholdabts = 0;
+int ql2xfwholdabts;
 module_param(ql2xfwholdabts, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xfwholdabts,
 		"Allow FW to hold status IOCB until ABTS rsp received. "
-- 
2.22.0

