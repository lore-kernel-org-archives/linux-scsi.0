Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C90C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81EF722597
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgLDH5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgLDH5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47nBqo025401;
        Fri, 4 Dec 2020 07:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=jOv9YPr2bcD4HPbNyC5GLOaqYbv61fg7/dPB67/jLhA=;
 b=uLckWixRqiXLSR4IPj9ZB9qB8wXnNJD2MqCzhTqvj/gJoOvstHxqPImRghUl7w3+WMiu
 55cbWsjev10lBAqNLaCeDwmKYXGxaXk3NbGNfTQOv+/jljophF44zp2FXmPMbE10OXQh
 zVHRHGDGLnNZar/R797Pjs6ap+MlA5J88jqXW69QnhhzZTLbb5PKcbTL6trJT581TK+u
 V+y3Mnui+Pc8AMR03eRG9cFe0nWCnlyq4HiJby/awxYgWwDfg0+I8v11qEDWmLXG77vR
 HGvy52yl5njGVXSKyo/bDTST0ir8BzgK7Tj31a+euMItEsXOAWK+3w8Owf97yUHKilN9 aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm1u7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47pTK3142377;
        Fri, 4 Dec 2020 07:56:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g37q2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:45 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B47uipf007273;
        Fri, 4 Dec 2020 07:56:44 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:44 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 3/8] vhost poll: fix coding style
Date:   Fri,  4 Dec 2020 01:56:28 -0600
Message-Id: <1607068593-16932-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use like 3 coding styles in this struct. Switch to just tabs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/vhost/vhost.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1ba8e81..575c818 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -28,12 +28,12 @@ struct vhost_work {
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
-	poll_table                table;
-	wait_queue_head_t        *wqh;
-	wait_queue_entry_t              wait;
-	struct vhost_work	  work;
-	__poll_t		  mask;
-	struct vhost_dev	 *dev;
+	poll_table		table;
+	wait_queue_head_t	*wqh;
+	wait_queue_entry_t	wait;
+	struct vhost_work	work;
+	__poll_t		mask;
+	struct vhost_dev	*dev;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
-- 
1.8.3.1

