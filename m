Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3711DC2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 20:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF15A20825
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 20:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W2vCjdCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgKDUaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 15:30:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgKDUaE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 15:30:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4KSuV1138411;
        Wed, 4 Nov 2020 20:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=FToGzsZPwqjkfY/+asvzjJUVdhP15ggBp9VvJTBHik4=;
 b=W2vCjdCMdU+/CI4KVIzJOopMI0VPxIxKP3vohkHjeSKoX9fLF8TOCSv1CYnZZvDtmjHA
 qE1xguDCJI69pQGpTaTe4JeyMOHrF00AoItHnoqoOPvF5fQ9FSXKfFFduZvBJpVzKuRC
 JDd4oTAeoyYEtR+xTotsA+oCQStHYs02lFIg6EdFCelt0ckjrPWsqaOxMSvYmHmEMt4q
 IhX8SR0dBjAyYGSZDMR1KqSCU4CmM1/zaTrd815wlIFzdXBRxDfx1xZIPf2f4n/IeArh
 db+ptbYnGPMSBU+LszXWVquM14ZT7oqZds3WBfoRYW8Rm7a7AlbvJg8FuLyp1q9VBYnP tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34hhw2rr8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 20:29:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4KOjNN039852;
        Wed, 4 Nov 2020 20:27:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34hw0g37pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 20:27:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4KRsV3024907;
        Wed, 4 Nov 2020 20:27:56 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 12:27:53 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 1/1] target_core_user: make Bodo maintainer
Date:   Wed,  4 Nov 2020 14:27:46 -0600
Message-Id: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bodo knows the code better than me now, has time to review
patches and is excellent at it, and has lots of ideas for how to
make the driver better, so this patch adds him as the maintainer.

There was no entry in there already. Andy had posted on the
list here:
https://www.spinics.net/lists/target-devel/msg14690.html
when it got transitioned to me. I added an entry because
several companies used it and I thought it would be easy for
them to find Bodo.

Cc: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b43b595..65e7814 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15585,6 +15585,15 @@ F:	Documentation/scsi/st.rst
 F:	drivers/scsi/st.*
 F:	drivers/scsi/st_*.h
 
+SCSI TARGET CORE USER DRIVER
+M:	Bodo Stroesser <bostroesser@gmail.com>
+L:	linux-scsi@vger.kernel.org
+L:	target-devel@vger.kernel.org
+S:	Supported
+F:	Documentation/target/tcmu-design.rst
+F:	drivers/target/target_core_user.c
+F:	include/uapi/linux/target_core_user.h
+
 SCSI TARGET SUBSYSTEM
 M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 L:	linux-scsi@vger.kernel.org
-- 
1.8.3.1

