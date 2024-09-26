Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2084.outbound.protection.outlook.com [40.107.117.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550DE158DC0;
	Thu, 26 Sep 2024 07:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727336173; cv=fail; b=N8W7NPkGfLWoaVET+9fLbaq3/wlpsZ9nfT/XLst/5q/ARWe1+vBxYz3R7ZJWyPk3fC+S14kKLW+wDx+9tM8cruZqWrhe/iACK7cGXRbXJvYKHeXd/SehOfGZqVAlSyIohNsWNRjPxeXmiwQJ9bwbez4DYyGuB9L6DqKFNQv4Ydc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727336173; c=relaxed/simple;
	bh=xXI9Hgnutbt0ca7hcCiYEkADmERusGZFvwYJ3H3xsGE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fgbjM1NTYgB8VFIhrZkm3RC80c/5S0mZ6sTJahKjZZ4Ni9CP6QxUT8Ihlh1l8QmfqwOmt/MAWYghCa629s7ol9EEjm5/sOtV5Zwc+J+wJ8PhqX1jyeHLxuqwiy1BPjNu8xdPDH7rsJ9a5OBqpjc2LjqFhaYyansJ9p1wu4JTTC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=MDcgrdKS; arc=fail smtp.client-ip=40.107.117.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="MDcgrdKS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6euBPpzwpd9ZiRQ0WiVPj615y5XpvI3gSTChoUYg+p1dtrVW5ievdMnk021sLx5n0E1hzunGEtBM9pXkxoEwSHy8YE50Xq/QIXSfWyXM9+rODa3Hr50Wi5trcQGMujGiZhlHFHceiLvGqfzzO3cHQPcuEjAUUHvOfkniuFlYNRH+K3qBcfNz0Ml8pi8ThfJVdQ5zYMWSCotgLDUNMzMeuOPM4wOX1ddqySMajTyQn6uqLcTXOotEyK5E1WCx/pGnGZm7XIlsaV7F1ntgAbA5X5NS59dv54ITq+GRZgNzKFIzmC4QEMs5frdPz38Xgv3FKd5YZK/AtCIEgoIS0e2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGu7g8sbeUj9a+8ppuZ+0H7RS/10yFKhjmqP0JvSj9k=;
 b=HYTZ43Y0WxbboTkMTGiA7q01mtBP0460TU5UHblVJjAAuIJsEkni7N/WgJvpQhT8SFuiYhpWOYY+VHjTTppPtHWSOVRuXXDrc6segTcMahZ7OIv49RAaNDTVYiZI0Z3lbnnzNkCJ4dbXNq1S6P6EfsGT/8n0C1ZA629O8ErnedSo6njtX3DJPBcornftiE63xvEpzh+DE7Fdl/aCjvSw4rAl28PMlZmCGvUICPowKSbfGRljoURKuOtzeYB+OZlbGlTpChDqH9a4VNPKyy2YA5WTYK7VE/+R02NS6BGseEvZo1PlBDjc85lyANhMDX/p6rKJs0Wnth8BLpsYEEvCEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGu7g8sbeUj9a+8ppuZ+0H7RS/10yFKhjmqP0JvSj9k=;
 b=MDcgrdKSbQoQ1AFEpKoGxgaiTw1PLfgwLdz0AJQ8Msu2SX2/O282MZp35guTMLosauM6RcW7ZQf/mSgR9EYRXzbqlkQR/32v+HTPxrtirJBN+pVrGTAkbElZ82vLeLc1XqB7fGm9zOI8UK+KJtrdqtVzQ+HkJ/takFhxhOOAIoRH8jOI87oZpAeY7SjjyiboSj4OLyM1jBuGMKgu73aNUWx3P6w3Qj6We1w+XWuMENCgyw7D1exI08o/jwVrxih/z35SKuRemcTZg2aj/1ZWkn2mXXK1MMhyg1qiH1bs4pLbSrwen56WVJl7yJMfok9tn9f27X6vCRprXJdtbb9PQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com (2603:1096:400:82::8)
 by SEZPR06MB6383.apcprd06.prod.outlook.com (2603:1096:101:12c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.28; Thu, 26 Sep
 2024 07:36:05 +0000
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70]) by TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70%5]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 07:36:05 +0000
From: Yu Jiaoliang <yujiaoliang@vivo.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH v1] scsi: target: Fix typos in comment across various files
Date: Thu, 26 Sep 2024 15:34:56 +0800
Message-Id: <20240926073507.3575438-1-yujiaoliang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To TYZPR06MB4461.apcprd06.prod.outlook.com (2603:1096:400:82::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4461:EE_|SEZPR06MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 37ad329c-8e25-4fd2-755c-08dcddfde0d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PkEF38OkdlnbiXEK0Ne52ZkF0gqeg7OS6d4In26l2tPFkG/TW3J5jRk2r/Bi?=
 =?us-ascii?Q?WmIf/Y38zj4iWNv8szxtu0w/0Xv2/7oQaDlYOVbJkeyILa491iinYLwkZKRL?=
 =?us-ascii?Q?FMPq5KLYS2yuUBhZXcni12U8L/5lWFqFjiqjcNxCYCasjdyu0DTFo05psYnr?=
 =?us-ascii?Q?QVOdUmKqVjLdB7U7W6MjNKP35O6q2FKF+4Mxf4Lw/YNr8CFTvuMMdC5ARSJs?=
 =?us-ascii?Q?5T35IDpzBmS7h/jiUqWsr2W0pad1Gjk+AZq+FyLm9qy975HTsm2K6lroOCMA?=
 =?us-ascii?Q?W+ayDC4WcgG9oPSE+iM9d8PGXGwffXS6BAaRnoVHElNvZ7zjNhVDEsnmgzQc?=
 =?us-ascii?Q?RVwPW+4rXacx0OJ9UoL5+tgfiilMZDPoTdPiH8Qa+kD+3JQeOzROLNXFy6I2?=
 =?us-ascii?Q?5gp9UJHiPD3gADcLA6NfV/pucOLsBgRt7hXniKwiUGzRl1So+b9gjBIE+2ee?=
 =?us-ascii?Q?DRInw4zcYc/6Mef+cZXFcKVBWVsRcE2sJ6i0SOOE68yCCBcwIBniEPDr4RDN?=
 =?us-ascii?Q?sM3q2dCLSkxGPZUi9/3Nx7mZ1gKKOxI0h0EIjTjHxbX8TP3mp2bj8F9riGRE?=
 =?us-ascii?Q?miikiDKiP7Iw4TKSXFoTdMOYzRfFC//nMdPFgm++g3PEUusgJ4Ogt1gCoN8f?=
 =?us-ascii?Q?cMa55x/YSELu6AKDYO3MGxeJksxyY0yOik54XSEnhQF6YeRBrGs2D0CU3YXc?=
 =?us-ascii?Q?xJ0ESvASpUPbX8t+yeCmzPyTak+2Y43fHknOAQgXMy4KluksFxONwMNo16bB?=
 =?us-ascii?Q?qUaokoUq4WNAU7Adl6ZeihHtnYrUFS9FFEzXAtiu/VIVoNIOpvguyjcWPuYN?=
 =?us-ascii?Q?z0yzL22ahbuSKooyHRU/d8LmNIldoDxFO2VLB2eQni6Tr4nNuirkEoe48xbo?=
 =?us-ascii?Q?jlU4O6kPOwJIcDMDVYPct0KOm/wRFU93C0G/G73hrsG9aHBg0Wh/hy5kqoaQ?=
 =?us-ascii?Q?l13MjOjBUdK7BdJ9AgXo0g1GIu/NLFtkMXhgELzu3UrdWme3LXNZNsuf+9WC?=
 =?us-ascii?Q?AZezKzS5ccqczCewLcm55ivtWDTW8K/kej6PtFqzYcOrKFn2VJQ9f3mZAYYN?=
 =?us-ascii?Q?V8E86FFOXKs+HT0v6FmRuA7OTJ9P9xH9Vkxh//2SADUUPwjqBa7by33n7Fza?=
 =?us-ascii?Q?9eRkYDdI/OvIV/MRqV9I4e1jRruElRIlpT20vvopkoR7rc9UCljrmnvqTFKX?=
 =?us-ascii?Q?9k0Fu2yx1FLAUAt/pICrx+d6NUBHsSQ2ftNC7DTvg0wT+fikNBXU1FR+7uYa?=
 =?us-ascii?Q?8KAFbgJqeX3N/9I7bgV3Z27NHQ6Pmw/GXA7RpzaJOila8ZZpe6R+PIWwxotB?=
 =?us-ascii?Q?/1sRdc1JHOXq3lyqizbGO7f4Qf4AEVFeCES3BM0p5ccObw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4461.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0kcJl3fuihybCEnCOo4UzAHE4Z/I99o0+RRUp56l3fCkcJIU/Y3fnjS5AFHW?=
 =?us-ascii?Q?2Bek3759fs630HogoX0DnRbOry+wi+0GNBjfNIKFtDKYhtFx1CMbVkMKZGQi?=
 =?us-ascii?Q?FD9ffnWB4437lxLK/AFeFe+vfYaU+KFx+kpka8zU1RJzy4Nm0vgROWE4yTia?=
 =?us-ascii?Q?G6MYxkHcpEwJEcwlwqKCo0LviOKCgQ0nNtSBNyib5xk+Hh2+yzi1gGX2aBeR?=
 =?us-ascii?Q?YCee+/w7S908sO/xFq/u745mmwmQXC5l9ZsbgqXBcU07/7D2qOyzwtPzX0kP?=
 =?us-ascii?Q?X8Lqs55nOmpbu4bKvLCcA5mTlZ6bxzfXCQp6wr54L9Qo9NnAf8dMiUkdpS7c?=
 =?us-ascii?Q?RI4+j3oO4U0Lg4qnZiGpe8JvCs/150BdRevm4NYnVd1yFvu/eDziPiVxbYTv?=
 =?us-ascii?Q?rGAmuQlGXC0d02JVR6S0lYvXyXqXuI6OA0gsOeIRhaaK6gdOS+icCV36ATp/?=
 =?us-ascii?Q?4bwRDGeWYEUOANdwrsbMxZcmQWhkPXekbVnxVJ/J3yXqgu9o8gcLiwxx4QD+?=
 =?us-ascii?Q?EszIh5jfJ4PxuKdqwZQ4wYUH3NYfW/nRWsqopqOT9Y3BCVOA5shSKBQxtn2D?=
 =?us-ascii?Q?hVThyM7E7ypvLhOlZ18lQYTCrXbBysdDNrmGMYo3FG0fvQdoZXHMy2Pow7Xk?=
 =?us-ascii?Q?jld4RJc6jfzBxS7wWraYh7KJu9Y8MlL5N4M4EoZ97irroPUpylJnV1sV2W75?=
 =?us-ascii?Q?sDKqZZShsxyFXesFnsHfiUUDU0DiCMghJ7SpD7B0nMzd1njbmUVG2FLHX2do?=
 =?us-ascii?Q?yZiCAHxYZ9SKYHKmjr5Vr0DO4TlI7rT6ANKTSiox4q/rG8b13rkmba5jOR/W?=
 =?us-ascii?Q?WD4mw+gVo5MNq/xBooZx+W8zUQHq349b6AVsHtQNAOJuUvyKcSzIrOqoRDhY?=
 =?us-ascii?Q?j0a+9cDzRSC5fYyWb/l/7jOe/JuQdjOt8bupYEKfm4LlViaDjAHKE3sSg2xw?=
 =?us-ascii?Q?M7MpSYfPitXVz424W5zINotWOCn84jX0LIzWPTtf0zBgOFO8Kf8bJEAZUgjY?=
 =?us-ascii?Q?C53MZGh6fF318+/l3sq1ahpSXXrebWGyAzB2ienrfMbU3FSUFcfLKXkFo2XS?=
 =?us-ascii?Q?sXwmieqxnavtRN5er4hPnn733g5m852xRytOoercjOTkriPrLHiVtKSyalCg?=
 =?us-ascii?Q?Z0BCIkWlvsWuje6FMd0VjxqMf6UnsYtf+FUY2Z7bR7nAJUQkoWfEIEyBrfL7?=
 =?us-ascii?Q?/cTSCVSjPlkQDWhe+knP/FXuhb11M1UW5iNIhQilbxiERYWkiNHAnRdFj6id?=
 =?us-ascii?Q?rYZkB5tfEe+qI6M/CinVz+0icrRObJzGepZ8uRpTjwTIdGgqVlzjIFgHwCHR?=
 =?us-ascii?Q?d2IePRk5+szoQveR+4JdpHl7teVrkun3aPF/mZ+krzkbkytJbJ+zZP7oik5a?=
 =?us-ascii?Q?O+eM/cgjp2yoO/7NRqOeisp/SAt1c062I6USWGAi4Zrrlq3ehtDy4lDM+rzE?=
 =?us-ascii?Q?mJ9Km3J+WS5apo7jJMi+n7CEtXOKBYw3UqFQ11nv9xe23MDpPeAaVOk1pMlV?=
 =?us-ascii?Q?XON1hDo0clNKQJdoqzsgjCt+l0/od28v8RPrYtzabgOgUfZ8Y6HP4kaiWDox?=
 =?us-ascii?Q?MCHjCU1HvsQY7jNWC6EXiC367DyLagd4wkejNh6z?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ad329c-8e25-4fd2-755c-08dcddfde0d9
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4461.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 07:36:05.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDE5wcBvgce8A7lY1/o71IEdkbk+pTGUnOolnFWOm1frpwR650e1uSlNWMLky/KaIAYATIIH1ubYERnet6kWyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6383

This commit fixes several typographical errors in comments within
the drivers/target directory. No functional changes are made.

Detected using codespell.

Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
---
 drivers/target/iscsi/iscsi_target.c            | 6 +++---
 drivers/target/iscsi/iscsi_target_erl0.c       | 4 ++--
 drivers/target/iscsi/iscsi_target_login.c      | 2 +-
 drivers/target/iscsi/iscsi_target_parameters.h | 2 +-
 drivers/target/iscsi/iscsi_target_tmr.c        | 2 +-
 drivers/target/iscsi/iscsi_target_tpg.c        | 2 +-
 drivers/target/target_core_alua.h              | 2 +-
 drivers/target/target_core_configfs.c          | 2 +-
 drivers/target/target_core_pr.c                | 8 ++++----
 drivers/target/target_core_sbc.c               | 2 +-
 drivers/target/target_core_spc.c               | 8 ++++----
 drivers/target/target_core_transport.c         | 4 ++--
 drivers/target/target_core_ua.h                | 2 +-
 13 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1d25e64b068a..da05a65bb247 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -108,7 +108,7 @@ void iscsit_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
 
 /*
  * Note that IQN formatting is expected to be done in userspace, and
- * no explict IQN format checks are done here.
+ * no explicit IQN format checks are done here.
  */
 struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 {
@@ -1033,7 +1033,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		 *  Expected Data Transfer Length and/or Bidirectional Read
 		 *  Expected Data Transfer Length are 0"
 		 *
-		 * For this case, go ahead and clear the unnecssary bits
+		 * For this case, go ahead and clear the unnecessary bits
 		 * to avoid any confusion with ->data_direction.
 		 */
 		hdr->flags &= ~ISCSI_FLAG_CMD_READ;
@@ -4591,7 +4591,7 @@ static void iscsit_logout_post_handler_closesession(
 	/*
 	 * Traditional iscsi/tcp will invoke this logic from TX thread
 	 * context during session logout, so clear tx_thread_active and
-	 * sleep if iscsit_close_connection() has not already occured.
+	 * sleep if iscsit_close_connection() has not already occurred.
 	 *
 	 * Since iser-target invokes this logic from it's own workqueue,
 	 * always sleep waiting for RX/TX thread shutdown to complete
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 07e9cf431edd..604378b7bfe2 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -343,7 +343,7 @@ static int iscsit_dataout_check_datasn(
 
 	/*
 	 * Considering the target has no method of re-requesting DataOUT
-	 * by DataSN, if we receieve a greater DataSN than expected we
+	 * by DataSN, if we receive a greater DataSN than expected we
 	 * assume the functions for DataPDUInOrder=[Yes,No] below will
 	 * handle it.
 	 *
@@ -394,7 +394,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 
 	/*
 	 * For DataSequenceInOrder=Yes: If the offset is greater than the global
-	 * DataPDUInOrder=Yes offset counter in struct iscsit_cmd a protcol error has
+	 * DataPDUInOrder=Yes offset counter in struct iscsit_cmd a protocol error has
 	 * occurred and fail the connection.
 	 *
 	 * For DataSequenceInOrder=No: If the offset is greater than the per
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 90b870f234f0..bbfaa428f734 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -589,7 +589,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 * We use the original ExpStatSN sent in the first login request
 	 * to acknowledge commands for the failed connection.
 	 *
-	 * Also note that an explict logout may have already been sent,
+	 * Also note that an explicit logout may have already been sent,
 	 * but the response may not be sent due to additional connection
 	 * loss.
 	 */
diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 00fbbebb8c75..c143d487afa8 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -95,7 +95,7 @@ extern void iscsi_set_session_parameters(struct iscsi_sess_ops *,
 #define OFMARKINT			"OFMarkInt"
 
 /*
- * Parameter names of iSCSI Extentions for RDMA (iSER).  See RFC-5046
+ * Parameter names of iSCSI Extensions for RDMA (iSER).  See RFC-5046
  */
 #define RDMAEXTENSIONS			"RDMAExtensions"
 #define INITIATORRECVDATASEGMENTLENGTH	"InitiatorRecvDataSegmentLength"
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 9c4aa01b6351..037d8e82d9ed 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -449,7 +449,7 @@ static int iscsit_task_reassign_complete(
 /*
  *	Handles special after-the-fact actions related to TMRs.
  *	Right now the only one that its really needed for is
- *	connection recovery releated TASK_REASSIGN.
+ *	connection recovery related TASK_REASSIGN.
  */
 int iscsit_tmr_post_handler(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 {
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index f7bac98fd4fe..23478c8957df 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -313,7 +313,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 	}
 	/*
 	 * Make sure that AuthMethod does not contain None as an option
-	 * unless explictly disabled.  Set the default to CHAP if authentication
+	 * unless explicitly disabled.  Set the default to CHAP if authentication
 	 * is enforced (as per default), and remove the NONE option.
 	 */
 	param = iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index fc9637cce825..6f54bca0bc2f 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -47,7 +47,7 @@
 #define ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA		0x02
 
 /*
- * From spc4r17, Table D.1: ASC and ASCQ Assignement
+ * From spc4r17, Table D.1: ASC and ASCQ Assignment
  */
 #define ASCQ_04H_ALUA_STATE_TRANSITION			0x0a
 #define ASCQ_04H_ALUA_TG_PT_STANDBY			0x0b
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..4fdd48a27441 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -204,7 +204,7 @@ static struct config_group *target_core_register_fabric(
 		 * mkdir -p /sys/kernel/config/target/$MODULE_NAME
 		 *
 		 * Note that this does not limit which TCM fabric module can be
-		 * registered, but simply provids auto loading logic for modules with
+		 * registered, but simply provides auto loading logic for modules with
 		 * mkdir(2) system calls with known TCM fabric modules.
 		 */
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 80b7d85030d0..3c1b13a18916 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -512,7 +512,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 * PR TYPEs to pass for registered and
 			 * non-registered_nexuxes NOT holding the reservation.
 			 *
-			 * We only make noise for the unregisterd nexuses,
+			 * We only make noise for the unregistered nexuses,
 			 * as we expect registered non-reservation holding
 			 * nexuses to issue CDBs.
 			 */
@@ -1658,7 +1658,7 @@ core_scsi3_decode_spec_i_port(
 			goto out_unmap;
 		}
 		/*
-		 * Locate the desintation struct se_dev_entry pointer for matching
+		 * Locate the destination struct se_dev_entry pointer for matching
 		 * RELATIVE TARGET PORT IDENTIFIER on the receiving I_T Nexus
 		 * Target Port.
 		 */
@@ -1814,7 +1814,7 @@ core_scsi3_decode_spec_i_port(
 out:
 	/*
 	 * For the failure case, release everything from tid_dest_list
-	 * including *dest_pr_reg and the configfs dependances..
+	 * including *dest_pr_reg and the configfs dependences..
 	 */
 	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
 		bool is_local = false;
@@ -3643,7 +3643,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	}
 	/*
 	 * If the backend device has been configured to force APTPL metadata
-	 * write-out, go ahead and propigate aptpl=1 down now.
+	 * write-out, go ahead and propagate aptpl=1 down now.
 	 */
 	if (dev->dev_attrib.force_pr_aptpl)
 		aptpl = 1;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6a02561cc20c..35dfe5cb40ec 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -573,7 +573,7 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	int rc;
 	/*
 	 * Submit the READ first for COMPARE_AND_WRITE to perform the
-	 * comparision using SGLs at cmd->t_bidi_data_sg..
+	 * comparison using SGLs at cmd->t_bidi_data_sg..
 	 */
 	rc = down_interruptible(&dev->caw_sem);
 	if (rc != 0) {
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 50290abc07bc..d45756de820a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -294,7 +294,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 
 		tpg = lun->lun_tpg;
 		/*
-		 * Relative target port identifer, see spc4r17
+		 * Relative target port identifier, see spc4r17
 		 * section 7.7.3.7
 		 *
 		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
@@ -305,7 +305,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		buf[off] = 0x80; /* Set PIV=1 */
 		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
-		/* DESIGNATOR TYPE == Relative target port identifer */
+		/* DESIGNATOR TYPE == Relative target port identifier */
 		buf[off++] |= 0x4;
 		off++; /* Skip over Reserved */
 		buf[off++] = 4; /* DESIGNATOR LENGTH */
@@ -388,7 +388,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		buf[off++] |= 0x8;
 		off += 2; /* Skip over Reserved and length */
 		/*
-		 * SCSI name string identifer containing, $FABRIC_MOD
+		 * SCSI name string identifier containing, $FABRIC_MOD
 		 * dependent information.  For LIO-Target and iSCSI
 		 * Target Port, this means "<iSCSI name>,t,0x<TPGT> in
 		 * UTF-8 encoding.
@@ -428,7 +428,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		buf[off++] |= 0x8;
 		off += 2; /* Skip over Reserved and length */
 		/*
-		 * SCSI name string identifer containing, $FABRIC_MOD
+		 * SCSI name string identifier containing, $FABRIC_MOD
 		 * dependent information.  For LIO-Target and iSCSI
 		 * Target Port, this means "<iSCSI name>" in
 		 * UTF-8 encoding.
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 73d0d6133ac8..87ef8eede7d7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2146,7 +2146,7 @@ void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
 		/*
 		 * Check for an existing UNIT ATTENTION condition after
 		 * target_handle_task_attr() has done SAM task attr
-		 * checking, and possibly have already defered execution
+		 * checking, and possibly have already deferred execution
 		 * out to target_restart_delayed_cmds() context.
 		 */
 		ret = target_scsi3_ua_check(cmd);
@@ -3447,7 +3447,7 @@ static const struct sense_detail sense_detail_table[] = {
 		 * REGISTER AND MOVE service actionis attempted,
 		 * but there are insufficient device server resources to complete the
 		 * operation, then the command shall be terminated with CHECK CONDITION
-		 * status, with the sense key set to ILLEGAL REQUEST,and the additonal
+		 * status, with the sense key set to ILLEGAL REQUEST,and the additional
 		 * sense code set to INSUFFICIENT REGISTRATION RESOURCES.
 		 */
 		.key = ILLEGAL_REQUEST,
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 76487c9be090..d295a5e65572 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -5,7 +5,7 @@
 #include <target/target_core_base.h>
 
 /*
- * From spc4r17, Table D.1: ASC and ASCQ Assignement
+ * From spc4r17, Table D.1: ASC and ASCQ Assignment
  */
 #define ASCQ_29H_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURED	0x00
 #define ASCQ_29H_POWER_ON_OCCURRED				0x01
-- 
2.34.1

