Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2068.outbound.protection.outlook.com [40.107.215.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB0718BBAF;
	Wed, 21 Aug 2024 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724225103; cv=fail; b=Wd0si0WSJE6vDXHZFWTTf5fGobpEdeFvHixz2ecKVT7331AQWzCcysZtRrcP9S8iNRGUa0P4pGJNWXZE0uHjpYqPBen5KQtGIc/XnuqWtRDPqqLcPPmq3mpFwroLi8dd4iOQUYpkM1Q8xzHovaOjnhAVet2i2Pdn6i34zSBtO/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724225103; c=relaxed/simple;
	bh=6Si4RjTfjvZ60jaucF1dc/0tO0QK0+XzMzKzwA5MmMs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=jSRj+jv/u0SqowuWk9JZe0i81qnhhEG3klYF6IFofkgigbGX2h6hACwjhTuz0RJaww0Qfz5ZV/rCOVg2ab2Ys10VU7y/55lLAy52LlV7f+4JTyW6MYk8UAxAUsOCJnsA8xO0AqQmi7I7p79kgTk9K2Mscfhbnc5ETbhb/Dguwsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=FNorprSS; arc=fail smtp.client-ip=40.107.215.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="FNorprSS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qX5BS9fDb+aZisV5ghBYPCAvJX0QC8T6E5U367mdW7VHNp7PAwmf/+1CXOyjYxTuyeTkrgHuygUI0ptLpK0rsnBCes97wjA4MRXZ6t+p7ry9aap3dPdyLjGbolD0wh6d4KHlftDPurgiLfNb5vJBjv9gjTv4gnmXY5DVfk8i6zjxGr0TO/tanyYykf5VpxMDU7rb2eiZjsIYw3+Osn5Gv67NvoVJOVVuLMQgOcyeDfLNw2borxqKfsIDJXh3vTOYGLrF5VkrLhZzZ5CSSPrqlW4oi4sXQpawKHjizKQu7xzwbH500jKjn+qtXgDLw1e9iFOlzfgPo86yRbA0Qj/kVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTMCbvaIW1atBeCggxe12LRPC9HH/i9Bpu/pNXdYB9E=;
 b=oaCH+wobsQ5TPatPvSRTXUtdPbVU45LlxZfbAcUvp0c61cP+58z4utNG61KbAF8dvxA8Nf/bbD43LjrHWCa1V6EiE5NKU36mxeXkwKyE135+ALbCxgZoDAix9/D9PRIvPjwQ02XkAgLFqGsmIuThmsxGIYVcznR8HmV2DtnWxrXsFFNPgOVAX9dpv8ji4Z++VygxS3Tt4o/PCuT313BSU+i2CnkkI4w2B2Tor+UT/VF82hS1t6sEYGl5mlv/SgT6yX5cTL2ftgZm9nhZ6SlAEg5+7b9inuZqiDD3pDmkCgvp4Y5yhIYkzoaLQRMLHaNegBN1R2JYFdWyUVahvn+U2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTMCbvaIW1atBeCggxe12LRPC9HH/i9Bpu/pNXdYB9E=;
 b=FNorprSSiO0yV90yaDhwCNyc9YPaf7kqx/gAeHlTO3FxHF60oTQSQ8mgInJShwAY+mtOxTryhycw5FkZp1MImS/ENAlr9nJSJYYfvEg85Adb52L/BgnXG3ycd1KA1E+ccoqpMQZIxb3/AnMlNj3SPYMtyq2oHgMmh44ivAEBACf+j2AS4J1g4U2bO+XIp13QLUXVW1H3FDfdko8kdTsV8x58moqf6t71bP6Y+aeU4x/u45ej201pwe/7ppaf+RqDeIwUv63LEbx8w06NIRkhgNmswWaCT9sGCla4akTX/qaXOnnodKoitI5AtVoFlwDTrvGZTsSu+IWbXi1cupTqqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6263.apcprd06.prod.outlook.com (2603:1096:400:33d::14)
 by TYSPR06MB7247.apcprd06.prod.outlook.com (2603:1096:405:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 07:24:56 +0000
Received: from TYZPR06MB6263.apcprd06.prod.outlook.com
 ([fe80::bd8:d8ed:8dd5:3268]) by TYZPR06MB6263.apcprd06.prod.outlook.com
 ([fe80::bd8:d8ed:8dd5:3268%6]) with mapi id 15.20.7875.019; Wed, 21 Aug 2024
 07:24:56 +0000
From: Yang Ruibin <11162571@vivo.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Yang Ruibin <11162571@vivo.com>
Subject: [PATCH v1] drivers:megaraid:Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed, 21 Aug 2024 03:24:43 -0400
Message-Id: <20240821072444.8838-1-11162571@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To TYZPR06MB6263.apcprd06.prod.outlook.com
 (2603:1096:400:33d::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6263:EE_|TYSPR06MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c75d2b-ad65-41a8-4270-08dcc1b25b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014|81742002;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wuLs4zL1l2inMhzywt8UIpGVYTpdUM1CwyYsrw9Zy2lXdVvy+jLymgDhlIKW?=
 =?us-ascii?Q?6tl4sM8gYweFIUAUdZhyqRw3wFSbI4eEoBbww4bh2thmePAl72sO7CrJ1M5h?=
 =?us-ascii?Q?RXIiSbj0Nyve2wZFYyZICBACU8lMJGYM/JHN3LybBXQsCLED+Xyl935DaL6d?=
 =?us-ascii?Q?j46e0RqAK9TfaGnm9AHxVNJdsXrO3l8HBjj/b6YqXKrbyGU8NihnKoBkKyeo?=
 =?us-ascii?Q?6A4hcQwnOynTKdpu71pWOdOUrjzZNjZ7FGN6L5zpIkQ82DsL2+L+inHwlpWl?=
 =?us-ascii?Q?ziC4Xoy2lxZYcZlz41ds9qKG8dAJ98mS2iS6AjIkK8P7P/PAv3fU1BRXjOuI?=
 =?us-ascii?Q?rS8sUJalQhR5c+5/cobmucIu/Hf2afiVsM2BilFkOAmo+gP9buzPFDRlm6t8?=
 =?us-ascii?Q?/FU9t/DPB2VjnldwZZKrninbU6OkZtwkZvmlm3AKXX3/eUFfxu/R8euYMfFO?=
 =?us-ascii?Q?JFKNWOtnHtRsNjpFgwh/NQX4DWTC3YtDw5cErg+BpjgLeqVS4xlkIeXsrQiG?=
 =?us-ascii?Q?G95UskR0IH/0ep/I8Iq3NrGuubUyQ769nhuSel18MTQCM0khYi4I6i0oKPWn?=
 =?us-ascii?Q?mGvHHs7KG2hO536AdApOhixeO1NKwuQHzvCoFPT+gn/OQwB6ic9Ji8R8ZivS?=
 =?us-ascii?Q?T51aLnAXTHujLaGqOwsKEMR8OZlTC7qkagYRxnq7liR0/SA/9zDZz8idaOx3?=
 =?us-ascii?Q?q2pdPgEEH7N0xuBt/3DqQrURf8HYp9wA8GrzxPCDYErbIo0Rxis4BK0OL/bH?=
 =?us-ascii?Q?B80H3UPDQUFNdlWZ/yiEuAiIzH/PUowRVRWP2hqYCI/bSTsmUi9ebfa1iUXj?=
 =?us-ascii?Q?0FCP2Ccqa9Cn3gEGIfVE7xCZ8yuuQt8xh8oo0Jq6W0B9do0WKHY+LTYtYpht?=
 =?us-ascii?Q?gsCq0iRJ7U9CjG6a4Qo8C4VBt4fX+cXwDGf+1ufytsygpYnL1hqhAl3OTfFi?=
 =?us-ascii?Q?gYbick8NnN3hUcLdYabQehn/wGNWJ/3quV+kAaRc6AeYJIrnPWQ1XQV0zGGU?=
 =?us-ascii?Q?a0qBUKs8TseU5e8rBcR0CAHdBulYrfdaM2Lug+40b3Pwz3DhKVqnfU+i65mg?=
 =?us-ascii?Q?CeY9ca1Wx3CW629vmgrwajrpWbmtSEltI7puBgIJC98wtG84tltWLSoUAcYK?=
 =?us-ascii?Q?i9BlWJ6/ljBQetXD9RpHc3EieJVbwHSq7+S8Xkg6abozd5vr5Mf4J0kSAw4c?=
 =?us-ascii?Q?T2gm8W3LjB4dUm9CPBDQTtR7pXvLkEbEhyjLyz/bFAlNv/vKqaHK0ELORfFb?=
 =?us-ascii?Q?kUwya5nSmxWAPL9P+Zjc6pdRNA3KhBT+478FGsXUUPOBEQuIwRuXfSUO1/80?=
 =?us-ascii?Q?joAANI4mzNKcSkTyMU1YtBNjqMSnpPzuPUN8ULNtIe+PJ20oxHLaGpRsR+re?=
 =?us-ascii?Q?Egg7kn8FQNo5ZHaEZp3j6LKkLPmwkSIegewOKyRYq/GJ70A4GeL48PbMBC2N?=
 =?us-ascii?Q?WTdHcBtx2BI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6263.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014)(81742002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KqF4aqGhdehnWe8yAmZvelFc46PZ4BXr7Vpxy46oQGluLxXTW9ovWXMX7Axf?=
 =?us-ascii?Q?XG3TYAHKem/1gsOr0ce7fPaBSfN+R0Qh6QtYfuZQ/Eegcv69fxur98apay7m?=
 =?us-ascii?Q?poknI+cgA67/GQWYBYjLqjOtHC83TE7IXafbQSqz8UrqMkwBk7c2QEHMDx44?=
 =?us-ascii?Q?6T/AiZho8YVbwjXLE0WGfcR8ezywcsT7+Repgp2CXFMKkDmu1m7KepguTBiM?=
 =?us-ascii?Q?QI8Vmv5YLjZNdI3u4qzPrI2hliw3Xwvs9P6DFoU2kDQkIawddFZLDd8huQKD?=
 =?us-ascii?Q?NgZmfyjSJVc6Br9w7Q3a1gfigTkE9RWBzM6m6HavzMZo5qwPkGLtqrzrvGNy?=
 =?us-ascii?Q?QnSftWwWw1Cor+Cgqsp3bA7nz8BJpsqN0qQOhHRoFYT1Fz8AXavFB2jJsVC6?=
 =?us-ascii?Q?Wt8o8uYoXMY2howF2fPrCRSsQ4wSg5wpvHjFwyjDby9E8L/gUEObi9/nMGZP?=
 =?us-ascii?Q?S31RdU6Ao9YtztryMFNvZFxOcJRk82FgafMrONzGB3lQ+MqPqiDBz4ujyj91?=
 =?us-ascii?Q?n3Plccc1/rhzOgl9I1KX1WUIQ/VSTvan5e9BSZHoUmo3eO3iMnhxyDj2NSax?=
 =?us-ascii?Q?fcYTT+0zMQe5rZsfP3v8WtdBH7REo3v7Ypt0uLcmf4Bc4K1wCnUbd7LtCNqj?=
 =?us-ascii?Q?zlVrLT3lpD/s6jwaEnsZYNZzHmK8EPeXKbFbDJwRHzBmDIYNK8xHOv3Pu5Eq?=
 =?us-ascii?Q?crZivwR/0EwLNlYXoTZBr/+jx8Po2PS+7yb2S4/tJUrLS+kA3XZv8Uv6Hm+F?=
 =?us-ascii?Q?2vX7nI9S6oCstj6S0Ir9p9c45T9ZLTdE6YnPgxSVUJ1CoccREQb4dNppAK4y?=
 =?us-ascii?Q?je4U8aa9AF6xfgaCGnoVUocmRqKWMYnhO4Dm3TtnYju+9EDou93NTIDbSPEe?=
 =?us-ascii?Q?ljzb2cjai4NtkRQRzG+5hhJCEwC2/x5Q+WF59L6zSS1nz9ML9f9x1LMwbP/+?=
 =?us-ascii?Q?C11Pi6ZlanBvQnNBwUw4QEkTtPw1xH/+JycMXE7iMrd1d2HqTK4/UZ4fnRWL?=
 =?us-ascii?Q?8XUAmUDGZhQBztbjADVM/bR9vsiGnKjwPO5QQKl/9V5X6hgMMGhxdLW1pMpA?=
 =?us-ascii?Q?i789oKTPmQ8eroRZSRSy9K1wp1g2Pe5Tu4p7fWcKZFZfawCug7mLYQcS6dia?=
 =?us-ascii?Q?LtBEYqWReSc3J/8ph5XUr7KCdJEkyf8wHVUc1LEQxKC8PUL89rclIm9ppysx?=
 =?us-ascii?Q?U9yjz9jgt+wt9Upea/H1OXQqkreveNsidCTDStGlGooFpKtAg4/V+QGuTgsY?=
 =?us-ascii?Q?OGuyAqXO5WKSA/VraZnUJDAaV+KN6wjAaCGGgLxKCxHlzwXY1ejNQ3ad7G7h?=
 =?us-ascii?Q?GemCG4+b7ehPLPNTnXb3U7RXA6Etf8m2Rf0dZSNUqZsXKfXjaTq6E9NnJKxY?=
 =?us-ascii?Q?nA8IfvjPYcFs6ynRikp9o6DEqfq3HSlD7BqWV9PWVJXOmu4F7czVJkde9pxy?=
 =?us-ascii?Q?Kr7vbrw9lf5o0RSOp+nFlLal1hcukBnPU48G7IsHMXGU3qnNBfxDBE9/U0kU?=
 =?us-ascii?Q?4bLMzgMEvIPBa381LOF84oNlTtin9NpG+fRwjJGK6lfZGUhFNYp8s2WPHRS6?=
 =?us-ascii?Q?TNWEOb4g0MB4ozs4ZLqqcImLVAZ5ZRrsXXCJXAmy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c75d2b-ad65-41a8-4270-08dcc1b25b6e
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6263.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 07:24:56.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iv5tEFoiSPqk/v59M6oBBLX0knul0MCZA6pOFwlz0MxbmZ/Qsad0xNxU/dd6EVwqaAOXOQhj1ZWBrF9pwlwq5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB7247

The debugfs_create_dir() function returns error pointers.
It never returns NULL. So use IS_ERR() to check it.

Signed-off-by: Yang Ruibin <11162571@vivo.com>
---
 drivers/scsi/megaraid/megaraid_sas_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index c69760775efa..b8b66d590571 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
@@ -102,7 +102,7 @@ static const struct file_operations megasas_debugfs_raidmap_fops = {
 void megasas_init_debugfs(void)
 {
 	megasas_debugfs_root = debugfs_create_dir("megaraid_sas", NULL);
-	if (!megasas_debugfs_root)
+	if (IS_ERR(megasas_debugfs_root))
 		pr_info("Cannot create debugfs root\n");
 }
 
@@ -132,7 +132,7 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 		if (!instance->debugfs_root) {
 			instance->debugfs_root =
 				debugfs_create_dir(name, megasas_debugfs_root);
-			if (!instance->debugfs_root) {
+			if (IS_ERR(instance->debugfs_root)) {
 				dev_err(&instance->pdev->dev,
 					"Cannot create per adapter debugfs directory\n");
 				return;
-- 
2.34.1

