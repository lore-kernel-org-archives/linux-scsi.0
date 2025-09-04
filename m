Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012040.outbound.protection.outlook.com [40.107.75.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533CC2FF178;
	Thu,  4 Sep 2025 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756992251; cv=fail; b=p0dgqAwm/xx+G3NbI7sYD7X0v4iuc1AgAH8TZiYAZNferQc/9le5urYEi2Fze9nrdZZLBDse7XlcDv3EBYYAcK2k7wwJ8fNk7t/ENI6KcIGL24dGk2wzdvLaXst+xEp5B2SbpL1n4TN4MFeZiDUk4BhzcuX0f8IPuSGnU1CErQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756992251; c=relaxed/simple;
	bh=dWPxEkDjcnCZg50BFit7Jf/uZsgIl5XkEH1FbHa9uY8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=icsjB54b9QKrfRSQ1FjpuKUVAC60yCdIOZjfa2s8qazJZDarJ+vPb86bOopolXYGIYddEUz3BfDx3ECv/fNPZUcJhOIEwKYwzEl+dJw8vCNaSiEwYN6/iD/4MHpqqI3mxKdo0qquhgkh0UB1zYN0SAeJnjwBnuJ1GeRWJ2qoBbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dGL+LvlD; arc=fail smtp.client-ip=40.107.75.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dGL+LvlD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iVUGC3seAe05dn67+7YELPksKOC4YLp8xD7GmqRJnHrNlcPKlYzwRQY9ZmopOGT2hFg93U3wca2DtYCWbhVH9zfNQIfdaOgvbAA9BBdKWGVeshslZac+mTx9HmXahSpk9Yro7ma9B5SkzLsS8ZWZ/5pncfMu2SQMginzTLRB0CAqkSWQVIxLrx845pQ+e2fWqCptcSP60EyTJCoFxMq2rTuJoBMISq/z9jmNTNQaobgJJtQ8SJQ4dskyBwtkMbOcXIG2llaxSXfd0eR9pxp2sWRf3+nBh1UmWpgZUCEkEv2Y5jgzOCA4ZNnFKYpHwsEfFZ6dhY7d95P9hn//hqpOGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tJwXR3HdyuM6hhyJlD4ssxmL33SeixlaN2w4XuRCHg=;
 b=eBPtfsmvjFvk3iFw7T0obbj+kt+Mws0nXnWsdicz/jXYeoy5ogb9/LJMF8OASKUr0+/CaJr8LQbqji91LGb+u5jFL+kbS+zE/uDPfg+uOkcQfaywwuHicF4/nAitW6gT1I7Sk/EQcnuyJZ1VSULQy03yLsauFY21umccTLV7gb0SZuE9PbAtC3Oogr4sIoXOesb+T8xDwAyj2J0DylwA23fsi7jRabwB9FNM4OMefOpJjTHwgUc1QMr5FROFR6P7iZp+7qUyor32zSLKZShJfjLzQN03IXgc/vcxttsFCu+GVYr+S5sv6ZUpSCTvgAuox7elvA8y2Nl/vLoPhBRvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tJwXR3HdyuM6hhyJlD4ssxmL33SeixlaN2w4XuRCHg=;
 b=dGL+LvlDax3oFJjnCd/D9lMKHxUhaTj68L+FTXLLxHeYw28vHjl8r7yGMc0wLcxGnrGA+Kh6RuHlg1V8Ms5aFcMT4AkihPdFOHK0SI2qoowiAijpHZS7cnZxwYHcUKVtRM2nkYJrmZsN6T3HAQJQQTFqRKNFKg3dAVKgjp2fknmYJB9zqz2aM5ezfM6k9EGH1ytjRy8FhVi65vvMQjpTmTbGA3NBVZc1JrhIr++a6EcDVh2jZDouCGJXkXWHOuCJDtBIIPzp8BmsWn0koHMH8/DdWdXEdKWPVzpIy1iDqq6/5z1WYdi3Ss/4Xuij9UpBO+TGUMuACXF6vNdMGNYokw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SE2PPFD1755A465.apcprd06.prod.outlook.com (2603:1096:108:1::7ec) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Thu, 4 Sep
 2025 13:24:03 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 13:24:03 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] scsi: lpfc: Use int type to store negative error codes
Date: Thu,  4 Sep 2025 21:23:51 +0800
Message-Id: <20250904132351.483297-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SE2PPFD1755A465:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d4a732-da10-49be-3f41-08ddebb65116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1701FlJz2vPBEfSYZsxqU762myVmK88hxr/I3jKFU7PC3JE0tXcmWnNWzzrL?=
 =?us-ascii?Q?rT5ccgamCkNiuLnuxaPUCiygepb4qelBrePiFlHzArsC+CeiAopHN6pBiPeT?=
 =?us-ascii?Q?PI0VBRf+UgMwHXBjaMEc20iVkBJdD+OdwDCnaRCB9bWP4z9x3WP6Px2x72ww?=
 =?us-ascii?Q?eMRrjhlS+LG4Lj7953islAaqqx64NXD/XteuWN0r8QOyNLfTJg6TNB9SO/bn?=
 =?us-ascii?Q?jO5cI4f40Cuh/Hj6t6vP5gak3tccsEnM+vuqj3HCkSs5xiBIEeeD9X6IFZFW?=
 =?us-ascii?Q?tbbMV2wL03a7dHChhxhzkLavcvTI3+JmoRmpyBcXmpMWYeAi0bPrhgmyc/Oh?=
 =?us-ascii?Q?g+dJoKGegZgw7AnWlBO4NkIr/YM9qyWYy2/i4kRC5bMLV+9pKBWFfGVxNdfu?=
 =?us-ascii?Q?HhrBhuXUYHNkNv4CHn3IhxIr7jJdwQmIw4nLhQoyuCXN27Vu49N/JEyvjooR?=
 =?us-ascii?Q?giu0EQJaea1J7kbb5/5ohyp7BNK29am1OTjGuaoLic7v/kg2ShSJ4etvqp7N?=
 =?us-ascii?Q?s2NjM1L6znnwUOPxQoSQRYWc2sw7IWgj56h5UK0oZASGY/xyocBNz1oxnMTI?=
 =?us-ascii?Q?vgl2Afc5aA7MJB/kODBaKymyUcOnUnDbHtQ9NaYT4D46hrJVeZiRSVXkHmWC?=
 =?us-ascii?Q?tKExdowC/cJkSRvoYAIc9W6lyeP16+64pc5WcCQCEISLHXMTxuse8FzG1b3A?=
 =?us-ascii?Q?2GozZ1G/khem0+WVUbZbSMTwHqaGmQ0FT69G8ZYZRXreZ49DxqxrrSvNLrw9?=
 =?us-ascii?Q?9GXP+BSC1VOv5DGuMNT8yNz9/J1Rsy4+xgIJbINZKuka+oB7ueOfI8oQ2PT3?=
 =?us-ascii?Q?uGtvP34U3vJPo0SSmdTATDFJJrFXLuIfwVq5r8BVIHPcWDysz+HNjLr4PmBG?=
 =?us-ascii?Q?p9Xxw4yZUr7onBnldOUxZHAK0PBXOqayV+7x9UrsDOQgJhy3270yuZnJE+OT?=
 =?us-ascii?Q?GrMMTIlEFD4kJCfRhpdNtWeuP/tElNYQrtFNKYZJAi3/vFsbASHf7+llEEVH?=
 =?us-ascii?Q?U0wHP3CK8PTzLq2TE/eBn76UvrUTinaM2XN8M9rScNUtfhb5LK4sYjD7OysU?=
 =?us-ascii?Q?52n+l6Lm9tU9l6AqUKxXc+yr36WohayAyzUyWg13OP1l2MtbRcuvVdhtWFhP?=
 =?us-ascii?Q?z+UwL/cZ7U9sZGkNDFqukMn3LNeX0roa6WJnQO/wSZtnRoqdWhRBewrnFgjn?=
 =?us-ascii?Q?+NgF1CuJqKVDZ4QKM/5cYHA/7wAZe136Zg1UlsQMY7X0h0N/gTi7CjA7cm8u?=
 =?us-ascii?Q?MGnu3E79jTrf3+9aIyNeImlH79uakyKlDS5fJvgvs7DCpp+jCHOUih31LJbj?=
 =?us-ascii?Q?0ygx2GdCBDdVow6iXZr0rdCnMz+CfK/QCVHgouJVFZzcFdokjzrXUIW/noUo?=
 =?us-ascii?Q?4XuSrwDM4vUUbQWkfSLT3fCq4MCx/dBM6XB7jUGIqgim/NaQd2x5vEFRHb3p?=
 =?us-ascii?Q?HM0FKvx7nOQ4q2PbGAtGNYjqhGplMHUGQACwyN/gnkzjCg5SUK6YMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vFRsp7TIZBWR76ZPQhWDUo54ThZj8EsdfLT4YO0xZy8zetAnw640R0GvBk0R?=
 =?us-ascii?Q?b2BA2UDE5IQ3YP0cE/MopIdp0N6gWDy7sk8Y0lx4ZTwMalhGmW+RlADxWdbm?=
 =?us-ascii?Q?TjUUJ41nQf5Qw8B2nXThfsNmUYKzu+MBpDKCKuvbcQZCihf2RAXgXQoKOEc6?=
 =?us-ascii?Q?kSFXerNVi1OkSrHDk6E/xNgQ/e9THda3bMBo+1Th8AGbmazkk+QIMFIi/bbl?=
 =?us-ascii?Q?9xHwC2/lyGPBoW0Ed70Fd9+GHDZO92VMmRp7NltMqHXcVc+Sf4V6DaSNY6r8?=
 =?us-ascii?Q?zYPLmJk7baKrE3Z4pdvQsgZ5ujU0EttsGjl879LF76aEbNxcbC11N46FDQAB?=
 =?us-ascii?Q?wHY4pWlcFtjARd2wp29s56oI4CZIRLlj3pS19UHUm27RN8Xnb6WJVMNLbzKk?=
 =?us-ascii?Q?8wVoKWaAqQMJ7RPJHXwCX/Q5gc+4CveDyVWcH/gHn8QIZu2ptT2SQAfgDS5j?=
 =?us-ascii?Q?ShsFmObQXNZy3uozpHZkX784Za7b+15q8EzJ9GUU+x0nnC310PBzmxAMEbhG?=
 =?us-ascii?Q?w2VVBjOjQdzfQ/uiIot36vvfgtccR+DRXLLF1EGItPaUSgJcRXRX8rC0vRwy?=
 =?us-ascii?Q?TxC0a651bVbfUuirPry5gy/amP+a2amsBPHaMNVgHw7SsKIJ1h9cmBy5EI9l?=
 =?us-ascii?Q?E3H1iaAxN23anrphsk2+XA2amNfH2SEf39BDkQA0A6x4mBkAWfLJhZNa0ZWG?=
 =?us-ascii?Q?sJEtpwaG7blUBKv98l+ohnY2USRWJgkXJs35leS9bYnSD2Fl1kih7OrmGYeZ?=
 =?us-ascii?Q?VhfCzmbiQfXkzD9DkJrYo3WWKESYq1pvz6C9EmtzSMFBPCE2fWleELkVpTov?=
 =?us-ascii?Q?rwuOQVTWAYY8WDXZck4bVqQxyOuJxiOug9/e2OJyzfPkFr0vD6cEfaIrcA4n?=
 =?us-ascii?Q?nQ9bcpNhGQZ+9NawcLjyF78sUI0WqhCejrY9aH6GFAbPHI6reNCKVBW4AsHU?=
 =?us-ascii?Q?4h3Duwp0/jSgrg43juJAlNKKj0Ll5YH0GKBOickKbJLo1T4QaJEqjBQI7Zs5?=
 =?us-ascii?Q?Tez4deD9SMxSWTTTw48QYvlDk9kHDEmtHotpzyL9frCnC+aLa0/p0dzCLWw8?=
 =?us-ascii?Q?HkP/I3tJo1eNJFUeI2eyOzZQb8dLKVhLWDRBiuos7R9Jf7v/VlebtjYmeTZq?=
 =?us-ascii?Q?lfQeJf6kU08V5N7V/Rsyk5ngW5xDl+1uAamhzw8cvXIbPvvzY3lqXD6tx2mI?=
 =?us-ascii?Q?V+Qf+2U8hTPZQgxyrKctAnlHaaVDDt64a78/crBQT1PECMDwWVFidZVyawxO?=
 =?us-ascii?Q?2pXInImkpbcVpA91ZeirZaZxn5H6XIsOT8rXoEbnqYsOrl+pqPgE2i782xYe?=
 =?us-ascii?Q?YU/oBmsu2SpXeYko2dX///P9k8ka33gYWXkvHvjg+E4jYsqUek+IroDl34oa?=
 =?us-ascii?Q?XSzNeebiTVsFdCEILaMJc2mTgwSJQQpJ9iBkJv4iAYqraAAnMZoeeyqUk+3M?=
 =?us-ascii?Q?r2iAQ50LY/iu4qf/1uSke7z06NBAnhJUL1F7XQ0Q5s6BA1La1eaqiV3St7NK?=
 =?us-ascii?Q?3oiwfhEI8rCzi0wLjgZEIv3qFO7DlpPOGlholXgz6rFAzLarm9D+XhLtan54?=
 =?us-ascii?Q?V6epn9gJMRGWNKBE+Iz5wRNmR1U5Mc2FTSB17bqD?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d4a732-da10-49be-3f41-08ddebb65116
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:24:03.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 200QMGMM0rhJRuOhXiSCSgI5goSuJrR4uG4/Wotay8tkSITE4Aj2A7mdb3lu8ND/yxMeI6s6Mllu8AaXHw3+Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPFD1755A465

Change the 'ret' variable in lpfc_sli4_issue_wqe() from uint32_t to int,
as it needs to store either negative error codes or zero returned by
lpfc_sli4_wq_put().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but can be confusing.  Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a8fbdf7119d8..8a2434a96919 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21373,7 +21373,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	struct lpfc_sglq *sglq;
 	struct lpfc_sli_ring *pring;
 	unsigned long iflags;
-	uint32_t ret = 0;
+	int ret = 0;
 
 	/* NVME_LS and NVME_LS ABTS requests. */
 	if (pwqe->cmd_flag & LPFC_IO_NVME_LS) {
-- 
2.34.1

