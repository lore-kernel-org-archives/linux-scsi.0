Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013025.outbound.protection.outlook.com [40.107.44.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AEE30BF6E;
	Tue,  2 Sep 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819482; cv=fail; b=YagpYKuLQfF1MEc5OZgRhA+qpm6rmI0jdlOtmiZTnJKjDMkw8ZdCe0kc5qz/RPgU0HyGAy9AKWSH6HmAPTs2FgFdRFyf97bIlCE6L97UWCIe4M9gw4QAzULeV3nzcUgSZbdvzL4N4blUuYBl7jG6d6QyeeTqM9AJZ4jRvKlI2ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819482; c=relaxed/simple;
	bh=m0QUPD/qbmzzW1lNdaUYohq0PPxj1+m00oY7nHhgP04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fTx50Kxxzp7XluM3zoNmxf102og8zzFLbTIIUYyQ4dsP95vQntHqYHZcTUPN+ke3aFUq/IHwB7QV4NiHixZ9N1bATNUS2OsI2oAvsLMjquoBNWvKyPLGBit5C2VEEOtotxb+JJk9eo+s8ovIjDLx8vowokNKLXDpl5ZQbDI+0og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Zd4LwJQ8; arc=fail smtp.client-ip=40.107.44.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Zd4LwJQ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZXsRjXEvRTHqqt82EIHc04AW6+zU5sRcdZFUCq4EznQV8Uxzkpg63YEbpFf1TP9u9RR5V6/wfVV0EqaMMZ8JoA1766YuCoMNb34Ki1Sn8ge4ZfeGmvm+idkaQdPoBB+FMV5U9dKJgTXIF6TmXAErGbF16iK4ZftNCJk3fGBRiJ3UA5mU6siFaAKJTghLRKCDq0JYnzX2jFXZ/YiNxbZoxGorhXjGYRFu2Vh/VKFNbamEODPVRYGkS1l32k3b57rWFLZx36JgABKak7GOUr6ISq4tmJjbxP2htakw8oQ/B+owlqWQJpg2gJESPzIXIcDScSMkSmOqYgWx2CG/wj5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I71FP9IFjuc5OASLqOMKbOVlrAG6smVcHpIWKTViU+8=;
 b=UrLTJu+mETl59m176DR3vLj0O0KVA1H6sjEUItj0b2TA/z5Fz8Uvl3LEYIEg39q60al/dZYif0P4Peo3y0l4pNYwLI/+71B0dvp3BsDM4zgCWRmWodW9f1qOUkked13bna1hptwPCAj69xTHmz1PuYGsi3DtlvRuQXwE3twEkBY+UbJ/Ew7hkeC8r7VM9b57Vq6IqUjd3ZglLLcjRT360bcPP5hrL5Jar4Kik4Tq54FTPoIqb2ws1vZiyXTo67Mb28SNwO5sV92IBJf71UdHOP1eP653Oerj9hJ2rXMpx+Wqs9Z9gdAFzDwlLhG9GAg2myjb/8Rmt5TxpFGOCHfJKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I71FP9IFjuc5OASLqOMKbOVlrAG6smVcHpIWKTViU+8=;
 b=Zd4LwJQ8h+DWJEriYD/xymhC3v/mr2lWdcPPppgvBa2qT5gNYk/IRDytTv1GPdXUWIBs513rhMUFr6WUn79xht2fJYeRtGzdRU4i/xf8S60sXMAtSlVuS7Ai/TwJLSadQehQW+RdvKPf7zqnOTAr922BdlfkjHEoPS9H3WrbNhaBtZ5lCYtaK1qxHTrLo1MO7XJVAdzsSjad6E4M/hJ1Dx+HecQF/xAUKhVbL9hs1xxXbXS8lOXo4V+m7AGHZ8xXR/SyjPL8U8z8Mo3e+BREJiZG834IQbrXxhI5/NicyWQzhtq91FUhGG6cRElLBaHp1eXsuS4hLTuTNOVlg4TIjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB5078.apcprd06.prod.outlook.com (2603:1096:400:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 13:24:38 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:24:38 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Geoff Levand <geoff@infradead.org>,
	Prateek Singh Rathore <prateek.singh.rathore@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 2/6] scsi: csiostor: Remove redundant ternary operators
Date: Tue,  2 Sep 2025 21:23:42 +0800
Message-Id: <20250902132359.83059-3-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250902132359.83059-1-liaoyuanhong@vivo.com>
References: <20250902132359.83059-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0238.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::11) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 838a5c38-f0fd-4f28-af6f-08ddea2410e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n27ycNsjW9FISt94kGP5dSMcqkSgkLViPV+B/BEbMU7C+Mzhoa9jV0CLhNP+?=
 =?us-ascii?Q?JHcWGQuP2wvu80/9hg3uIfgLr8wwAt74pHjRwuPns6fq+K/4aOW1UUoqBsKR?=
 =?us-ascii?Q?+a9Dwl2FeoeWdEKMbRswLp0W+2m+cENWh0xis2zV2MLGb4j3CvXBvbx/tBxf?=
 =?us-ascii?Q?rDab5jbmSbyahg0gtOfFMTUe3VA5+3kD7twJ16ndZqcAfWsZP1M47hLBrbfT?=
 =?us-ascii?Q?cZP+qXKRminrgSWMzmyHjXJJPosPyQxCPcqvPZxV0NyvaxrT0y1swB8v58z0?=
 =?us-ascii?Q?5m+/i+/JUNNWB/Vdrnr7LkCV9X8+QACjiRdkAhzM+YFmVqglqYnuivNAyub+?=
 =?us-ascii?Q?QUpfRdk8AxoMgR4jP9LSZWsYH1F9GMgWTRY+2Q47FvaBSfkPisPWL5VVBR0i?=
 =?us-ascii?Q?stkzsMDTbdM/XePgdFsNYdNc8O5oE2brvL6th1CgYN6xWT7qT7Jf7C5v/D9R?=
 =?us-ascii?Q?0ok3FlFe9ej9Exp+6OYQmL9yjbW2/GNuMibuRZzjUU8nz0FKx3R2eCdSrlrz?=
 =?us-ascii?Q?wmarSN5mGryL1qqXu0Uf00dv+MG0NoiYQavEiMptOSEVjM6WsTCZcPMGW0ZP?=
 =?us-ascii?Q?UXUBTakBuX3KAM6XZUyOAsCVCV8bE5VFiX5Ei1Z+SPRMeY6QAAFpAWYmiMUp?=
 =?us-ascii?Q?A18c7CN1iE0EjPNBKlf5NTS4vWG/S6rYAe4QPu9tvkk9yvse9kO1ivZFjvqd?=
 =?us-ascii?Q?I5GjdnTAfGgQM/II/UxXq3u+s7W0sR1orCGhS0imoxhxbz9facSG9Nb3FOwJ?=
 =?us-ascii?Q?Yge3RR5XKyHdem8d5wR/eA6q57x3tkeDHuY94eGoNSawT3VqgacqBam/Q3PC?=
 =?us-ascii?Q?NmKL8CWUG/lf+ABYCsFG4hCjCydeJkYvhOCfD4TyYPGiahVHbok0N4vWxZUA?=
 =?us-ascii?Q?el7m4LVyTxTTBX5gKFn5VmXtYsf5HxGhKfvCVRfk14j+hbnn4bEGVqrrn2mX?=
 =?us-ascii?Q?vPNHHKipyKPAJnbwGDzBWbk+hmI76mMrGwX6f8RbIRhT+ucV0L3PYJTeJjmi?=
 =?us-ascii?Q?pfI6RwI1WDGUEV9dNpvydOGvdx72cdANcNxg3q1l7s8s9F6whsrzwmDpwg2I?=
 =?us-ascii?Q?HYp5UCn/jd7yozNdH4jEJRSHF3kaTCv7GmBHHmcCB233Jbiw7dFOX5PkZC+N?=
 =?us-ascii?Q?ei6frk2eDg0tdSqucfn+1t1Zbwl7nIQoLvyIJ30d3YvFLxqDZ7L3pKWVmh90?=
 =?us-ascii?Q?7Tf8VfR6OYNQ2etk0y5zBNxcxYWLOULS+FLSKupaAwcPGgT0DzUUjO30rsSW?=
 =?us-ascii?Q?ubSPupOimEoPxDMuRJ0i+IAQUmYM7yiKReSsWQeO1QZqa67d7Tklm14ql9PA?=
 =?us-ascii?Q?se+c1GeLb3A9LD8m8djcVEFEof9Lvqo1TIrnXaL59Je9S37yo3KCP1niMsYu?=
 =?us-ascii?Q?yoPNWwSAbiZqY6pX9Rj7aHz1POpvOvbAQgsIMzV5qtwdkUoM2CqziiEwkqbR?=
 =?us-ascii?Q?Csw5xVshQwbG0lQEy6hGNkgBHtlkcV2LH4OtuMfRQNNoOOeFrI5vOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g59DBKHNDe2/WcDgZgqYBIRbAjPfHWYQD/L7nTmIwKIWJ1SyweAPUDwzSHdb?=
 =?us-ascii?Q?0c7qQlENkz4JDUTBh+v9+mWiSplXQNkulnfEcHu3W3RhqUPVQPacRM5/FymF?=
 =?us-ascii?Q?gYYjFDHKzSnCC1LlRPtkaPtwo1DSdCTzCk2nzQ4pbXLD9iAHdtUH70sEVQ0P?=
 =?us-ascii?Q?+f71lHno/IZqN0cvFqBrsLH5DrUhFrmeVruZ8OzXMRkef7On6ltcxTRcbxag?=
 =?us-ascii?Q?F6XPC8NOaVvkx0ih+xuHIDy8cngsnbYQmhcdA8zr+incg7fU8WAVERCz9J24?=
 =?us-ascii?Q?YC32PNbW9H7QiyLXzxBmxyBqpQVE6pS0Ej5vTBTL4d4x5F/G2ZTFA254ApbO?=
 =?us-ascii?Q?bh4BJ1jZwySxzR4zH2Rs1ZpGE3GrwvJQkfxe8ukfos/1FUKCVjMur0HjmlAT?=
 =?us-ascii?Q?sLVNKpUC3GYApo1R9vTyazM01l2ROS/bX7EkKEdCJp1imVTfc8X95foAlNuv?=
 =?us-ascii?Q?+Y5AZCAheMDwO3F1FGcBN+B11VvyGsws+Ruqg2Vep+OViy2U+wyPZhsI99ZW?=
 =?us-ascii?Q?p23B2Zv/Ka8Xk3IpVqFFMjgF4HmM7rPGU25vcNsGQJVUyQAjhZL/L43prMEz?=
 =?us-ascii?Q?oMXZLaKeu5Zq9JqlxAWS6Rd5809MoUolGtjV0BwK+zmUH4epiTo8TebV4qEF?=
 =?us-ascii?Q?nyAat7ukJ7Jovn1U1wN3lKg/kBjn1bXeKDz/SOhuJ7QHz02IdM/+ER7Hf27g?=
 =?us-ascii?Q?zd/XNAcGs9SOOJITGBOrbyz1thNoDRi1h61y+RimCz17jIsbL9j5aOdrEv6R?=
 =?us-ascii?Q?nGeYEf7FxjaQnSUG4AiV7wjg1UD+TU+ygL7iV+K7ISZQCuo8CqkRa620O2S0?=
 =?us-ascii?Q?sgbrblLu7e6hy93k8G+uLjmALIu6emSWF1u8ZeRoDj7BpVAFWFDOwdoZtwCu?=
 =?us-ascii?Q?NGL0WMONjUdYFjMwmwzN95WLIkPN/3M7nPRose+AmAChICShlBsI8znxMCRF?=
 =?us-ascii?Q?rwhVZIxn2prnOrGrR3NKS5/DiXQIiz7FXfISC1/l/fcpSjAye2lPDIqx32+W?=
 =?us-ascii?Q?bPhTSxs1J+IUATpN65oyrCWVOTKNMpCjCnjIUsMps7q6qSGUW3/pxW091yqu?=
 =?us-ascii?Q?y3blUXCFOfah3AFWG+a9qysIJ16XiOBPr43OYXZr4UdYA3jtxqPyaPRHAeNy?=
 =?us-ascii?Q?LPZwSv6djzm6DcwyvBemm45bW1fy/SckkZDu8sy8gxeYkszfiKdh4p2p0TnJ?=
 =?us-ascii?Q?LEPWe+SIrASD6USohwrf+TyaBA34YcXUkr+/Zyd0xpjAk5NiNYW6Y+o3odpt?=
 =?us-ascii?Q?qyZH1nUWiuIxT23PTt3YmUhu/CKy5rB+qgPyXqTek7TCh77vMqKPXx5GsmK9?=
 =?us-ascii?Q?Trg8igxr3/KOWD3UWSe+o4+jM7n4fqrKad9CUI0ZpMgLTrSJ0RVApEz2vyqn?=
 =?us-ascii?Q?zvKcM8+yruHbpIEAODl2qgPX6WOtOfT96Ppah/aKkygVshB70NFChK+yuKcc?=
 =?us-ascii?Q?3DKfnyG2NEBBMZDGNMeX2gL8s6MbIBlpTDuH+FHs4tMeYz47bTOa5ZT7C6wR?=
 =?us-ascii?Q?JDkX7UraYAIci3Ddav6o7hqFWzB0QJDgZ8ftWg+KHR7SiBfMldGT9AzgcIoK?=
 =?us-ascii?Q?fvzUZGeeWVxBqtvhH++WmGIws5Zl68S4CYoF+1pw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838a5c38-f0fd-4f28-af6f-08ddea2410e8
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:24:38.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtzXtpun+Q0Jk+1i90/bCeiqaN2uxoM+hsfKtCvJ8N38EkTcUF3Nxqb5f7SsHBA33BBhay/1hILygC0KKicdrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5078

Remove redundant ternary operators to clean up the code.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 34bde6650fae..a95a7ccdb3a9 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1407,7 +1407,7 @@ csio_disable_port(struct device *dev,
 	bool disable;
 
 	if (*buf == '1' || *buf == '0')
-		disable = (*buf == '1') ? true : false;
+		disable = *buf == '1';
 	else
 		return -EINVAL;
 
-- 
2.34.1

