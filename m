Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505FAECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiHZK0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343528AbiHZK0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C6CD515
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q319Bl027726
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=QUHyKXF7EflNhPJR/10/RkmQrQgN21WtVrULIzTGMuU=;
 b=MT0pMR6gdDYNctL0ammNSLgbu1jfc1vpznyY77VoOKUXOYPRcDKMoL28C/41Uf+sxDdW
 Z2ZbJtluPgpv+oQgGv0M2H7A72fhqRqqXPgnxZXOMrR913kyikWZqyHPS4kBOjZObjWJ
 lC4Atw8O3nRn6GA4GKDJsKhri1rah4f5RyEwT/siTFMpXwkb7/5U/eMmjtIHy9f1UD5g
 pLTQqAmCkfV+CpMoPaOqpbzI9sz5OJw0DE5ao78WJbN3XhymNm9vFQDU4o0s2Juls4aL
 6LDnn3tClSv7pH4OjUE2sQ50D5rCujH5rfom6ra9Zkni75haLW3VpYPwUKvIDaXM5tiw +w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Aug
 2022 03:26:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 460A03F70F7;
        Fri, 26 Aug 2022 03:26:18 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 6/7] qla2xxx: define static symbols
Date:   Fri, 26 Aug 2022 03:25:58 -0700
Message-ID: <20220826102559.17474-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qW0zN790VnPUAqKZOqFVvRZVSSgTsnOv
X-Proofpoint-GUID: qW0zN790VnPUAqKZOqFVvRZVSSgTsnOv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/qla2xxx/qla_os.c:40:20: warning: symbol 'qla_trc_array'
was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_os.c:345:5: warning: symbol
'ql2xdelay_before_pci_error_handling' was not declared.
Should it be static?

Define qla_trc_array and ql2xdelay_before_pci_error_handling
as static to fix sparse warnings.

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4a55c1e81327..46c281b55c63 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -37,7 +37,7 @@ static int apidev_major;
  */
 struct kmem_cache *srb_cachep;
 
-struct trace_array *qla_trc_array;
+static struct trace_array *qla_trc_array;
 
 int ql2xfulldump_on_mpifail;
 module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
@@ -342,7 +342,7 @@ MODULE_PARM_DESC(ql2xabts_wait_nvme,
 		 "To wait for ABTS response on I/O timeouts for NVMe. (default: 1)");
 
 
-u32 ql2xdelay_before_pci_error_handling = 5;
+static u32 ql2xdelay_before_pci_error_handling = 5;
 module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
-- 
2.19.0.rc0

