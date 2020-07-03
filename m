Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8663FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B4D20760
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGCNV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:21:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726347AbgGCNV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 09:21:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063D2YZP161748;
        Fri, 3 Jul 2020 09:21:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 321cvea83n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:21:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063DJiSk019303;
        Fri, 3 Jul 2020 13:20:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 31wwr8fb3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 13:20:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063DKu3K12583264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 13:20:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C899911C04C;
        Fri,  3 Jul 2020 13:20:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B302311C04A;
        Fri,  3 Jul 2020 13:20:56 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.150.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 13:20:56 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jrLcd-005ouH-M9; Fri, 03 Jul 2020 15:20:55 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 4/7] scsi: docs: remove invalid link and update text for zfcp kernel config
Date:   Fri,  3 Jul 2020 15:20:00 +0200
Message-Id: <96069b9f4c4f056a515b37e89b2bdfccc282e3d3.1593780621.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593780621.git.bblock@linux.ibm.com>
References: <cover.1593780621.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0 clxscore=1011
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030087
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IBM decided to retire a lot of the content that was previously hosted on
"developerworks", and so some of the links we've used for documentation
are now dead or redirect to some general landing page with no correlation
to what the links were meant to provide.

Change the provided link in the Kconfig file for zfcp to rather refer to
our device drivers book that we regularly update and publish for free,
and whose name hasn't been changed since it was first published.

Our hardware is also not called "IBM eServer zSeries" anymore - in fact,
it hasn't been called like that since 2006. Use a broader term that
covers different server names over time.

Lastly, add a short paragraph about how our HBAs are typically named, to
have some more tangible references.

Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/scsi/Kconfig | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e9ff4cd5fbe9..571473a58f98 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1469,14 +1469,19 @@ config SCSI_SUNESP
 	  module will be called sun_esp.
 
 config ZFCP
-	tristate "FCP host bus adapter driver for IBM eServer zSeries"
+	tristate "FCP host bus adapter driver for IBM mainframes"
 	depends on S390 && QDIO && SCSI
 	depends on SCSI_FC_ATTRS
 	help
-          If you want to access SCSI devices attached to your IBM eServer
-          zSeries by means of Fibre Channel interfaces say Y.
-          For details please refer to the documentation provided by IBM at
-          <http://oss.software.ibm.com/developerworks/opensource/linux390>
+	  If you want to access SCSI devices attached to your IBM mainframe by
+	  means of Fibre Channel Protocol host bus adapters say Y.
+
+	  Supported HBAs include different models of the FICON Express and FCP
+	  Express I/O cards.
+
+	  For a more complete list, and for more details about setup and
+	  operation refer to the IBM publication "Device Drivers, Features, and
+	  Commands", SC33-8411.
 
           This driver is also available as a module. This module will be
           called zfcp. If you want to compile it as a module, say M here
-- 
2.26.2

