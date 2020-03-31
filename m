Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFB8C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 14:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3409207FF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 14:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbgCaOWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 10:22:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730703AbgCaOWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 10:22:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VE53xv015826
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 10:22:24 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303vfhaj6b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 10:22:24 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Tue, 31 Mar 2020 15:22:19 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 15:22:18 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VEMIlL61603994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 14:22:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2A3552050;
        Tue, 31 Mar 2020 14:22:17 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.63.31])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CD97B5204E;
        Tue, 31 Mar 2020 14:22:17 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jJHmT-0013dt-05; Tue, 31 Mar 2020 16:22:17 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Joe Perches" <joe@perches.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>
Subject: [PATCH] zfcp: use fallthrough;
Date:   Tue, 31 Mar 2020 16:21:48 +0200
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20033114-0028-0000-0000-000003EF6810
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033114-0029-0000-0000-000024B4EAE8
Message-Id: <d14669a67a17392490d3184117941123765db1a4.1585663010.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_04:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310125
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
[bblock@linux.ibm.com: resolved merge conflict with recently upstream-sent patch "zfcp: expose fabric name as common fc_host sysfs attribute"]
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 10 +++++-----
 drivers/s390/scsi/zfcp_fsf.c | 23 +++++++++++------------
 2 files changed, 16 insertions(+), 17 deletions(-)

Hello James, Martin, Joe,

please consider this patch for the next release that is convenient for
you. It applies on James' "for-next" and "misc" branch; and Martin's
"for-next" and "queue" branch - it goes on top of the series Steffen
sent for 5.7.

Heiko C. applied the other changes from this series to the other parts
of the s390x architecture, so we would like to have them for zfcp as
well.

I ran them through our regression suite with error-recovery and I/O, all
looks well for us.

Also thanks for the work Joe.


Comments are welcome :-).

Best regards,
 - Benjamin

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 18a6751299f9..3d0bc000f500 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -178,12 +178,12 @@ static enum zfcp_erp_act_type zfcp_erp_required_act(enum zfcp_erp_act_type want,
 			return 0;
 		if (!(p_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_PORT;
-		/* fall through */
+		fallthrough;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		p_status = atomic_read(&port->status);
 		if (!(p_status & ZFCP_STATUS_COMMON_OPEN))
 			need = ZFCP_ERP_ACTION_REOPEN_PORT;
-		/* fall through */
+		fallthrough;
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		p_status = atomic_read(&port->status);
 		if (p_status & ZFCP_STATUS_COMMON_ERP_INUSE)
@@ -196,7 +196,7 @@ static enum zfcp_erp_act_type zfcp_erp_required_act(enum zfcp_erp_act_type want,
 			return need;
 		if (!(a_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
-		/* fall through */
+		fallthrough;
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		a_status = atomic_read(&adapter->status);
 		if (a_status & ZFCP_STATUS_COMMON_ERP_INUSE)
@@ -1086,7 +1086,7 @@ static enum zfcp_erp_act_result zfcp_erp_lun_strategy(
 		if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_OPEN)
 			return zfcp_erp_lun_strategy_close(erp_action);
 		/* already closed */
-		/* fall through */
+		fallthrough;
 	case ZFCP_ERP_STEP_LUN_CLOSING:
 		if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_OPEN)
 			return ZFCP_ERP_FAILED;
@@ -1415,7 +1415,7 @@ static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act,
 		if (act->step != ZFCP_ERP_STEP_UNINITIALIZED)
 			if (result == ZFCP_ERP_SUCCEEDED)
 				zfcp_erp_try_rport_unblock(port);
-		/* fall through */
+		fallthrough;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		put_device(&port->dev);
 		break;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 7c603e5b5b19..111fe3fc32d7 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -564,7 +564,7 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	case FSF_TOPO_AL:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
 		fc_host_fabric_name(shost) = 0;
-		/* fall through */
+		fallthrough;
 	default:
 		fc_host_fabric_name(shost) = 0;
 		dev_err(&adapter->ccw_device->dev,
@@ -1032,7 +1032,7 @@ static void zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *req)
 		switch (fsq->word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			zfcp_fc_test_link(zfcp_sdev->port);
-			/* fall through */
+			fallthrough;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -1127,7 +1127,7 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 		break;
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1");
-		/* fall through */
+		fallthrough;
 	case FSF_GENERIC_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
 	case FSF_REQUEST_SIZE_TOO_LARGE:
@@ -1313,7 +1313,7 @@ static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 		break;
 	case FSF_SBAL_MISMATCH:
 		/* should never occur, avoided in zfcp_fsf_send_els */
-		/* fall through */
+		fallthrough;
 	default:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1736,7 +1736,7 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			/* no zfcp_fc_test_link() with failed open port */
-			/* fall through */
+			fallthrough;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 		case FSF_SQ_NO_RETRY_POSSIBLE:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1909,14 +1909,14 @@ static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
 			 "Opening WKA port 0x%x failed\n", wka_port->d_id);
-		/* fall through */
+		fallthrough;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
-		/* fall through */
+		fallthrough;
 	case FSF_PORT_ALREADY_OPEN:
 		wka_port->status = ZFCP_FC_WKA_PORT_ONLINE;
 	}
@@ -2059,7 +2059,6 @@ static void zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *req)
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -2144,7 +2143,7 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1");
-		/* fall through */
+		fallthrough;
 	case FSF_LUN_ALREADY_OPEN:
 		break;
 	case FSF_PORT_BOXED:
@@ -2175,7 +2174,7 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 			 (unsigned long long)zfcp_scsi_dev_lun(sdev),
 			 (unsigned long long)zfcp_sdev->port->wwpn);
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
-		/* fall through */
+		fallthrough;
 	case FSF_INVALID_COMMAND_OPTION:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2183,7 +2182,7 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			zfcp_fc_test_link(zfcp_sdev->port);
-			/* fall through */
+			fallthrough;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -2277,7 +2276,7 @@ static void zfcp_fsf_close_lun_handler(struct zfcp_fsf_req *req)
 		switch (req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			zfcp_fc_test_link(zfcp_sdev->port);
-			/* fall through */
+			fallthrough;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-- 
2.25.1

