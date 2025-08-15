Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012029.outbound.protection.outlook.com [40.107.75.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F633019A1;
	Fri, 15 Aug 2025 12:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260194; cv=fail; b=FGl5yRPhwPwNlC4nglpTV/055QxK34o7oWUcgQ+0Z1RTtICgeL9N314ueKr9H4T3bXcB6pojjRtPVu8CI650xHb98Q64R87o8iokRpcPhlWejLE9c6mtTglaNSUR6463gS56P60LHP+bL5cwh5yPAHtNUVWenFOEvRZyI4YgT4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260194; c=relaxed/simple;
	bh=1qzZEKd4ZQhYGcrFjm12p76yHt/O2nl00J4Sr+OWHM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YKbiEXxHQ+h6uagDygbuCYx6kCAGGIBICS7i4qR7yVTR+isZrRyOZ873o0xB9cQOlEmSFQdJNMjg218D1p0Ul7i2O+g/P90popUEQyDQW5XinDY9NxCmoV/p2tubjeTNrxFkoJse00uhJTTJSBOHkiMGPTFryT48AKW86axeyfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ouPRbU0r; arc=fail smtp.client-ip=40.107.75.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ouPRbU0r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zjzb7mZFhMg5Pv5hTgwspl32/5Ksalqu41zidFTp4Rzi+B62G7YnrKeFadRY8eeZoc5dxNiHL4nAXta1FUyuQIp8o9I/UNgq6Ja5g8H6abE637SO0rQSsC/UcvsPozTgI/K1y8qXaYh6TaSsaf6DgFneRv8idgF0KJEWmlfgimWKzHTgGTYFIwQCls5qk9P0ioZJYzvptuDypD71qzggL3OA3iS03+yc3mZvik4tEawGNYJ8l2+GfVAl0jDgUvi7iu6qtWY4l9MmL00EFUZJAosbrYrDlaqmlguvORjr0CoFUck5R5aIsD+vu96AqWheVKPRRy/DwD3g8GEY/EDChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHrZmaDlEPNr/1o5+bJYCW6Wh5hekl4VK9ggnWEQr7o=;
 b=gViu2aKUvMggXbaG46dEBkLgLWsg39+P73EMRJjR9VA9klCc9HkKqmII/kFAqrNwFhu35KDjMDqnk10+1jm0jzIOmaSKwHmEJX0ZSNUxChSD+ddehl84GTv6OoRWqE1Y+tMdBmL64ge5N/4rAPyhxbdNR6a/tynF7sT5fZxs9zr5Iidt1v+eD6TE4E3FvUERR63WxoM8Hq7FToVSFSjAhqO50v8/B8PEwkkelK4o0M/QNGqQvMU2cN5f7TA/D2QO3Dc25JRi6eu6R0UaQr/eqVzBZtRKtAA5o8mo7SlXEG3tdWQp/mRixxitUxqX4SiR9W6YohaqpFsQqh2U0ZKnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHrZmaDlEPNr/1o5+bJYCW6Wh5hekl4VK9ggnWEQr7o=;
 b=ouPRbU0rcTGeg59Fv7+igPUyMvJWFpaGGSX3PB8t4y30xMswQQN8okam9+Wq7pO6SLAp42Cywc5rjhGxNmD9pAX7IjlWYVrD4FfFpBkLseJzkz1EfurS8Vo6kGnJpvdhP1JVIb4/MxfA2LXEFcIkKHArzC+CfHUTY2WamoKpZxpWSFtL+bw+dzdzJGRVFGrYNRapqKa4nfNOd8hEM2edhnny3j+BZq7gqTMmb3ew/xw7XweVO7V+apuyKVrfJz6hCfv83DLYrKYD4YkAoelo0kbXdxRP4StQCwAs/aKonX5TRJhgmceTuTl7wxKLdgrfw97FJvGHqc5T00M/hOaMxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:30 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:30 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 3/6] scsi: lpfc: use min() to improve code
Date: Fri, 15 Aug 2025 20:16:05 +0800
Message-Id: <20250815121609.384914-4-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250815121609.384914-1-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f80395-88ec-4dde-8e4d-08dddbf590f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aCHTfVDcYDg7wT+6kZf/tZISvJxeNpXfv4tSWUcKP9cNdu99Kia9kIZGrxd9?=
 =?us-ascii?Q?49fFrh054h91JzcJ9uy3zXdi3E7u5py5O1a+IKvA2gFcg+wDIX0JmrzC2KXa?=
 =?us-ascii?Q?otPZK3yifYUBpmPEYmYoQCcAJftPw2CgBBKg5rEdK0GJxB/xZBdhoBfmsZAM?=
 =?us-ascii?Q?nZlXJlvSxeASbqzoqgaV0CT8QqdeFJV1YObjmcpnB74zBUYewYtXVvoXh8fY?=
 =?us-ascii?Q?JuN1717jOZzWko4aOIhUULdBHLW2+ZbYtpL5gmJ6MHD8Ig2xh4wb6ZUDyok3?=
 =?us-ascii?Q?bODe1q45JahJBMFwnOniTMQlLl3Iyic6zn+robdxcE6rci857/Ft+ZK9s2W1?=
 =?us-ascii?Q?qUm6JMTUIdxHaNQhEhqpDg5oQK+b+NySQt1Agm5zePp/3YiG+DEDiwXV2L01?=
 =?us-ascii?Q?xsFrO824xfm0PSIIUkLsdOl1n9LaEMcLz5ggupfzy4ah0X620RYeUw8O75vq?=
 =?us-ascii?Q?ebNMLRzzA+8Wlk9UAX9LweEGMWMyo3lsJGRnr+Mpj7fJzzd+J9fL2p6gLxe7?=
 =?us-ascii?Q?h7MP5b3QQedgcXKBUXJS4T7DAR/Rce+I8TXgmYcVJxWxh2BZSTUCz9Llzu3R?=
 =?us-ascii?Q?KEmD9Qmnp5wP2Ns+mSfH80dxn0GdvXnskOi33Y+QHJjCDFd6EDhsMWvgGxOh?=
 =?us-ascii?Q?/QJ4QmtryqXXCehSl4cgblfvcpxxDoYIqVoNLDPrqt6rGAn7y5IzHUtjORQt?=
 =?us-ascii?Q?DScAGNQvgfYAERRutzRe3+JT0nDN4hfWCGTDAI0tgrawogKicvVu7JAxTup2?=
 =?us-ascii?Q?oLyFqdI3yIs9uqlcA+ZGvvQFnWmp4E6zpJxnN87q+HidvUjwh/gO3gkrgxmw?=
 =?us-ascii?Q?/Sdcpk5qbDnem7udsr2FevhbT4zO0H2jMTpznh0zj6cOlUz14SukxIfyiYhQ?=
 =?us-ascii?Q?Zu2DHhKuh1SLItWZLgL8El5+J5cbFmrxzq10CVF6fPiaTeHZrjkBbgS609B4?=
 =?us-ascii?Q?qCS4/7ymf+ml7fzMTswklz1hbdwEuHos1Ie5uz3VKR7qidZcaYR4GTl8Qnmf?=
 =?us-ascii?Q?uNrCLE9ItREJQrmWBfqxH/xrDScUQhy74zMBcBuFq6lEoyBcWmX4LbCAaGCS?=
 =?us-ascii?Q?x3lwg54+am7muH6C+Wwe6/VFChXMuDT//vXL6qmoJdX1KMV6FOPCTEA0019b?=
 =?us-ascii?Q?MDwl7Y9eMLjQONrMTin14M270jWUKOjSu2pkMTxXQ1TusNcVEjKC43K+Lynp?=
 =?us-ascii?Q?i7P3vppKFophRFY+O7y+dx7dIe6+IF4kotSulnJI3XhTYvzn69n8b6YFvGAZ?=
 =?us-ascii?Q?7SxYqYpy7tQ7GDAiDb/2G5HFclbHM+1WpHZTbq98dKrDRQXsjyd+wdole5Ij?=
 =?us-ascii?Q?R2AkxzyHPfMtNhKpmnTg/k8+VDUdgdTql05N0PsU6VcGT6359QrnKE79EU7v?=
 =?us-ascii?Q?/wyclVpbDz+NKwGpGGqA2Yo+GeZUpcqtBx7gi9t5tJcTQUt/FnRO62qKGlPh?=
 =?us-ascii?Q?AEEdslTUaKQOVicmUOXbhXB79R5CmMVpoiqPTXhZQJDQ8ZM0S1LlVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JvZCECpUZOyguaGOnr5cTaBA5mkxIhVAqszMH3TaDPPWj1da9ZZP8WP2JUVz?=
 =?us-ascii?Q?W8x31VzSepxvl8QhA7MSlqzmeH68g16/jWSwo9eFMZC1YNzxpKL8b3TdX85h?=
 =?us-ascii?Q?quUqOsKuUDWsdVkHErr2Gap6qjay2MH5t90fD2S5sa+s0ZQhLTum4qH79DVE?=
 =?us-ascii?Q?ggPqBciHnzEjpsNRMdi+/ljEVZwdz9Iz94gi5gU21MStRw4xo8VsluXFT1Gj?=
 =?us-ascii?Q?zfjPZdhlaSBZnT/lZIiJEZUVT4pJ+1Xa0p1YWfp1JGJnvaqPluAzJgH4IkI9?=
 =?us-ascii?Q?RBxsvTawnyiky4tdUQTnRqHSQyHKhQON+9/MGh0Nwlmm/Qen6Gt3EaVqJj0L?=
 =?us-ascii?Q?9DLKMCK//4rzHZkFaxOyFjX0Q+ieDzzlX4mx/vfiSLo1xOCWIwJEIMkh6g4J?=
 =?us-ascii?Q?0/rnHOOfNp0hQeZ7c/Skxx/yriirzU7Zlbz7+IASYYU1RfNU4081h5L6h1Lr?=
 =?us-ascii?Q?j81VyTuiNE3m62rb0osnaf5b14lf5yFL4l0cnjD7Ks6+DroiqEJb/38gwk2S?=
 =?us-ascii?Q?wFgDaoe5xKpapuuSfsOHpesdOWuldjB1wkna7s7m4k+bIxOHvpaVWeAyKWB5?=
 =?us-ascii?Q?6ppnfj5D4JFbZV9OiBKLMOQZD1+f0mAmknDpBaaRek6GQfa9GLv/e8CASyiC?=
 =?us-ascii?Q?KABE7DvwyKlbnJHZbcHKr/DzgcTTmdROMJRZs6BLOLtKGKlnTxfNjwDSwEwV?=
 =?us-ascii?Q?xCDzYem9o0rRJGKwuk6E6YS5zr8imPtqqid4YOcNkBLG82cD4s+6s+fEHrOR?=
 =?us-ascii?Q?AGUDR/NrCIi9qlluXKGKzetlSyiEd8L5zbaLuqnfJroYPCbfoNU9pY3uMVOH?=
 =?us-ascii?Q?VoNOlS4zyf+lmKJ9XNlVtKokc7Ab0OCS2lxRgdSI2FdJ6VyibNjjIkz94UeS?=
 =?us-ascii?Q?8/SocTyvBNXzqD/FVd4bsb2ZL0OSkxX2Syt3bTW3drpbOPhRTergAepE2Mwl?=
 =?us-ascii?Q?t1r3sy2y8JbFB5FLdWsgZFE37yD25mFv6XQZHzN1i1kxvSARfy24zbFxN7aQ?=
 =?us-ascii?Q?aS6XkyaUBd4QckStNmiNBbo5n5e3YttbuKJFuO4SVrw4WcZbZr8sBQG9mJ9q?=
 =?us-ascii?Q?eeHyjH6n2h6PHVjs1h8epKxPkMzJhsyC9f3khWtxjCjaP6iDpJBXR4NJJaDP?=
 =?us-ascii?Q?4lK9H8U5btw9ZA2O8b/pHTXWwRvnbAX8qtrHL0s/xF8KLihE3iaMtttELAmi?=
 =?us-ascii?Q?I9h4JiWYI9rOp70GvTtbDJkpX/1o0jks5VwVU4MnuGxm7AtJdAKj5HoIamUT?=
 =?us-ascii?Q?AOz/EGzpei9JGlBkRONcpyRsXmoNAumV6a6SbzhJhwm4mazKsLRIZmCUkbhL?=
 =?us-ascii?Q?NIkBBA9SK4gFQfIMN/h/miFfVQc/DUlJb/7ArmhRpuorKNwptKw9k2EFYVHv?=
 =?us-ascii?Q?ADelW1hT8CHRGSX5csR5ogoSe/gERwO+xfsn8jCxpYOnZ6BShCORbCFcEU7Z?=
 =?us-ascii?Q?LfaJTau5JdkZYmRPP36ZaJVFErA55MfPPzIXVjwT5v+asB9OiJyOrHoybJzF?=
 =?us-ascii?Q?pofvqKcqHmTqRxbz3DH5d3E6SttDPSSzvKluRyTZhvu7tBU55clqLFCVnMhP?=
 =?us-ascii?Q?WUoxCdcjUy11gMwoCnxWzKzhSeKZY5dMgfaNtKse?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f80395-88ec-4dde-8e4d-08dddbf590f9
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:30.3503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KCCYR0kaNsE91TOr2jeo3grOCjmQydyVBF2NejH4Mepaf7MBpVKmjrM8f04DfefY7TUMU2nkSYyUldIjQF0qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min_t() to reduce the code in lpfc_sli4_driver_resource_setup() and
lpfc_nvme_prep_io_cmd(), and improve readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 +----
 drivers/scsi/lpfc/lpfc_nvme.c | 8 ++------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4081d2a358ee..ad8a85c65bfd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8300,10 +8300,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_total_seg_cnt,  phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 
-	if (phba->cfg_sg_dma_buf_size < SLI4_PAGE_SIZE)
-		i = phba->cfg_sg_dma_buf_size;
-	else
-		i = SLI4_PAGE_SIZE;
+	i = min(phba->cfg_sg_dma_buf_size, SLI4_PAGE_SIZE);
 
 	phba->lpfc_sg_dma_buf_pool =
 			dma_pool_create("lpfc_sg_dma_buf_pool",
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a6647dd360d1..e6f632521cff 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1234,12 +1234,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			if ((phba->cfg_nvme_enable_fb) &&
 			    test_bit(NLP_FIRSTBURST, &pnode->nlp_flag)) {
 				req_len = lpfc_ncmd->nvmeCmd->payload_length;
-				if (req_len < pnode->nvme_fb_size)
-					wqe->fcp_iwrite.initial_xfer_len =
-						req_len;
-				else
-					wqe->fcp_iwrite.initial_xfer_len =
-						pnode->nvme_fb_size;
+				wqe->fcp_iwrite.initial_xfer_len = min(req_len,
+								       pnode->nvme_fb_size);
 			} else {
 				wqe->fcp_iwrite.initial_xfer_len = 0;
 			}
-- 
2.34.1

