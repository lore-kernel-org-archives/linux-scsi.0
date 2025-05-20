Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012014.outbound.protection.outlook.com [52.101.126.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8825CC6A;
	Tue, 20 May 2025 06:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722930; cv=fail; b=KUCEPEiAz2xt7ajXRi+pAoFiJQqnCkvKVZKkCeK486ARpNt5URmp/vb2JU9clDq/UE1EIf1UYHmw7K/V0I9B8xaC443YWI1247+V+bGovFobY/Ojo/IQbzVpTpMTXGHVkeVpVhHksoXxo6ofeFK+LLiMVJiYOxolgVfiwU3ByS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722930; c=relaxed/simple;
	bh=0Y3d/7ajv60W5cwM3MM4AbMYRssEcWFHw3IeD2Rs+yM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=now4SX8zQWF9+3uFbwqU9BePV3LnQTESFMpeuddsdtj2btvD1t6yzk/q8ayW6BvnhV+gxHsWRws6eWkKSaRSE1d1Ga4/bMzqdg8QpldPGQo5/VKnxnbobMjraYnRfUqevd7h4QRZsxIVFX8F7w6CuSfTUipQljg2fWlLOxJMZOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=DZGFwOvG; arc=fail smtp.client-ip=52.101.126.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="DZGFwOvG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+3Qs0CwcrBwC7LgQLgS7GY9Vouh1bG3ViSJgLw/eYSqbpqcuUmR9lCW777FRK9xKDtqlm9AhLyHax0k2h2594NnL13ML7TSbRNUagnAVZm/vyBF9ij8RCCpyhs1dyvsJn+J7QlXVnLOa8H63BfhIGMDuNG8N3URQvaJD/UsRZhPXgHdgjuWflFatIqwP9h3QEwHhJ3yzJ5u3v3IXtldPvu+q2ngJDz9bNpPWCqNT1czo21X/baOz7+VM1jNMwA/N6lVag17fFMLK9C9pWRFanDxU82Yq9a3yEFjgS06ZvXNn3mwXAbQCQRN+mEyQtOA/znoP2OeWu2Lj/6VOmDgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3f+ys59Ow3aMe8zm3KtE45AESRGfxc8xCiGYD/upeE=;
 b=T2xSJRoDPVJEubwxu2cqFpiDnxk29ymDm1siFjNGzazMcDSduFWB714Hd+BAOAAv6StQLp7DKyrSKaQv8PSznotQT5EFNo55rYBeL66FRYGAdgXvLqKyMumaxUOqn9jDO6zqmyPimtmfEIf50sZqXRzOACdhFrU3LS8hlnDlYKsEPIatQSbw7yLMwI0Xesn0NfGT/9a5919YTQ9HPjcjYzjGhC85NuA7qfIM/1Gss793gpbceyWT5k2k+NqaJkPwP2Lb1zAOqVzqFDw/+VbafOSmlm0Ib0FE1gyKPIob+K5q77yyf4ogKQF2gEdhStIc5Ya00L5qFcfy/Uyp7S/TYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3f+ys59Ow3aMe8zm3KtE45AESRGfxc8xCiGYD/upeE=;
 b=DZGFwOvGDTsXsRaV1n1YPP2iHIU1WV6bqMUiMyPjYZuJKAxQI6atiHxI+l4bn+OBKamUUQcZS++Xrc0qHsb9hcOjQ9BcKpBLBW7pLBF3LDxdsrxikDf4SITO+jAeagRcjH7qdNBEheDXUXRHBauGN3S5hXelXFW+uVez+DKOKd/S6ewyixDYI/PLRxToDIuEK++aQjtUHSPslEreixAJQUay76hZEVM7/N21N0oxDOEAQHOKVI96aoFepdFnhbUcrgP/NrTcjnt/FWMnRpYkF4vrvk/pWH9f2dM+6rC8+SfnuB8Rw+xHyLOiBJtQs04MId7eUeeCHzOTQffcuS2MTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB7352.apcprd06.prod.outlook.com (2603:1096:990:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 06:35:23 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 06:35:23 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	luhongfei@vivo.com,
	tanghuan@vivo.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com,
	Wenxing Cheng <wenxing.cheng@vivo.com>
Subject: [PATCH v4] ufs: core: Add HID support
Date: Tue, 20 May 2025 14:35:12 +0800
Message-Id: <20250520063512.213-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: caffdf0f-ed20-4bb4-b016-08dd97687f5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ovspKiO5XAg8s4sR6aF6JxTsEw6oaMMxnvIHTZmjXax9blHYqBJZWtGt0DFA?=
 =?us-ascii?Q?B7x31DJ9XdWRTaa8bbI2+fgpM0dwILoIOXbiyjTJwGQLI2Hyf4gr/Wpc460R?=
 =?us-ascii?Q?WL+Z7MeSN4LCHd/4Jh1blRi29xsD1KHyoV+lGaU5kMSCkCx0Xxnt1J/6MJ1Y?=
 =?us-ascii?Q?L1gkdjZ3AS7hDOLuLhT6dxtFY7og8PAi6AR0oznqwaaxZyRaj4GnqbzVUXkJ?=
 =?us-ascii?Q?vliBvOz9XIHAiGTDZN4FcRLVKE0/U/dD1D42uFzxEv8fIPVgEpBy0mRR+Ixw?=
 =?us-ascii?Q?nIHUs9GjDGBDH37jyCjoYW1HB7tO56uZd3RP5bvo679cGj7J5ns15uJ8/1qH?=
 =?us-ascii?Q?mru7xCnjsTD8PnBRFSRLLSLQPiUQncuLhXGV686nFvwhKIdEPd6VzWJHsjKl?=
 =?us-ascii?Q?365NOh3wbVZzbri3imkRkeqRC8PGugnFdmrurbmhHi5bodQldPdKThpaAjcF?=
 =?us-ascii?Q?JY4FOcDZKM2z8dRe9Beutt7V2uRZFir31DeS1a3bSq3E3wG52T+rCJabyvrh?=
 =?us-ascii?Q?dN9LDQJD6rRlDQJRtLa4kFpotgneLkhdAA9azw7yQUrLPM7iXk7UMIZocLSB?=
 =?us-ascii?Q?WHvSmBky+kp7iGAnizSjRa3Zy8IsHZpIWsJLgxXZB845c8Uc63Eszx3JjgiX?=
 =?us-ascii?Q?UITseDapyu/4ZmwV/VEYAduffKJrOdFCBv2Zou8ogN3By5Jo/8nzuuFTNp7f?=
 =?us-ascii?Q?vNjq7bvfjiC0sXQSVFmSgMXyYWWtKah/YbYCKgahv9WeyE2q+xLc3+eXogM2?=
 =?us-ascii?Q?SXQqZnql0qAVSu6oyx9wgpXZNfrXl68tGyVkuR7MHDs2DFyepSXo9R+cHOSW?=
 =?us-ascii?Q?IYaYfGm3TuGDOTErPL+p2+cnpTgFY4cwxFPwtrxkPfsqFfpiz2Ei9XkaQA5V?=
 =?us-ascii?Q?N0jm23mz7hHdy6rQSMSVvxfVr0Ll3AgMphnRgfaY6bDGANupckpc9rjscKl/?=
 =?us-ascii?Q?R2jjo3RaBhNV9UBqmV7O1fGcwwIaCfrW52kwlT9FaKy59RApFP8IaXunkU1e?=
 =?us-ascii?Q?UAA09Z+nUH+AyBhsA7jWZnjZSIbtivgttrtKJ/PXB24PL/doWpH+KEzMMJOG?=
 =?us-ascii?Q?sIQ0/WRPt4FKxk1E78GfeeD/CAGQ+mzG5RvgdCbQg/L+DlORgi/2kSCefAyM?=
 =?us-ascii?Q?wPfayfoNuLvrca7CI8MsgE3wnHLQeW9EFE36YdYueyxkaA5v0OVcLJ7e11wq?=
 =?us-ascii?Q?SFrP2MNZfubE/3g2DY4n8SGgqTlF3nzPjuezyPZFvFI0kv6rnMim/Nw2S9jo?=
 =?us-ascii?Q?hoSAH5jvnS2vOCxBe8JiK8axHs6xE2v4o6LgPZ9/CoNIZXVmv9MHFTEzpr7N?=
 =?us-ascii?Q?v2jsrOHwHiunKLCcGSSAw8sQI+fWgFSvjhI/vEThPUxcHaaEiFC0+IM/NCdK?=
 =?us-ascii?Q?8SrLt7CPI+xZhxA70uHREoNYo3Qxh1ZFuVf22j7u1Yq1y+3pKtTypwsIVLE7?=
 =?us-ascii?Q?ieBZwxCtcNsWjPrcQM5PBzBM8mCVJDacXP5tOJ7NwW/R+MUjTKu3oy5+Mu7z?=
 =?us-ascii?Q?JWuKYsiFGjd0Q70=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AUemkOdQaDS5l9EFeML/LO7IO8NJr/rL4XKhLJ886eUfrq8Ldg2IZsDw5sz1?=
 =?us-ascii?Q?CqARS0G4q54re5OdK14MiLFl4j4ZRNOx6yBGVDnAhQKUt06EvdvLwKGU2ESH?=
 =?us-ascii?Q?WrWnhQMmLoulA1vxuabkyXF9IrrpUtIRomhe8mU6EomT90cSjL4PezsQXSuJ?=
 =?us-ascii?Q?2nIYCuKnfW5ujTwwyslfxOs1vCo/yOZwoBZK+hF/XWG2w8MoBpsD0R45y0Rd?=
 =?us-ascii?Q?s3rP2zr88bzflvUccg3We4CZF13AQDrdf2vTj2r5feltZaOAnyDNLycGu6Wq?=
 =?us-ascii?Q?+eau+5iqAYD2yXLTHVb+B5wu1SRa7pz/T7DxiR3C2WSlqdweCuDF8jRQoCx4?=
 =?us-ascii?Q?dCZORFaEEprU+y11td752hU+W/RHe9BKIT+qtbFOco9W+qiEmRZoVUq4p55h?=
 =?us-ascii?Q?gNGzhj4EcLde+Lw3VMB7tltMl8gtuJzAFh4IV8VckHt8aKf28F50Gj92hMNk?=
 =?us-ascii?Q?RLKu+fdACKbcSyQMZsbJJp78/8VbGL01958u4ek2OK+RCEHqPcOEMAK03tFc?=
 =?us-ascii?Q?jyZcgbTpAIk5I+Znkr5YGr41/lh3ppkI9j488QRyIFTt7+Lt2/8uNuI8pMOr?=
 =?us-ascii?Q?n0VSVYgMRrHS4Eo/rn52wW5LXXTj5tAHBojc6zPYnyb9bSYDpLtCSSpYS7rA?=
 =?us-ascii?Q?bzG9LwjXSoT2AknTtaGLwACPk3Re1umTOz0/3+y96xJ/LqhkiPhoIqFd0G9J?=
 =?us-ascii?Q?YNApQyzLVpJ+fAJNBDr4jW4tkJzaHBZfThjgVBogotxPpZz95rpF5/FuuXrS?=
 =?us-ascii?Q?pa2twqmy8IneKHgFi4iY/FNfMRWf+svX5yMN1beXDttjB1WXqWNiM9j/FqA3?=
 =?us-ascii?Q?9rjp9FEbNK+y7VjN1/uHl4AJ88diAQ4+LLfuCrGVJoi8dvMO1bZFoH0OIwPf?=
 =?us-ascii?Q?AHTpjE3ttuihMUjycihlKHdPDJNe4o4nMIx4qriA4Ym0ZtTlmHd5W3vXmO/P?=
 =?us-ascii?Q?0l+MXcVoaNiBtudtOosTP7Jz9TaEnjlr4s8kvsShAxV0W90aQyHj0+jrcyOF?=
 =?us-ascii?Q?P8DZvnfyWfx4Q8+ydrhgqoI66pPxqIkIROq7AhTL5P0xGBKUi00uIlBtL0eB?=
 =?us-ascii?Q?YnxExo4it792QRsC6GencjkSHlzDTe6lmfpLcj4r8gxzLZlUEiTqCDbFo1HX?=
 =?us-ascii?Q?V+pw/1JP5ZqZnSNJXGmysTC/WtPoSu3+uVIsZvW7Itg9MvcRhWeHxyljdJnL?=
 =?us-ascii?Q?WsiLsDxLEgyo0Oi5mqMZ6k6H+H//WDHl+J1ar0OMQYhVy4Cf+bdxZPEh2fy1?=
 =?us-ascii?Q?GlfrREjxfsTLrY8afT8BDxyf+T2WjR/DjLLuDfty46lLszKCbDHYvAzkRn4W?=
 =?us-ascii?Q?pwt9WXYZoS20R5AFIOe3RC5S3gaYALs/2TCXMbMnfz/t88VJ1wAoIRsUMhKS?=
 =?us-ascii?Q?Ohv0JDFQCl2JfkHeX8aEXsyVAGPq0VZSpCR0IP9mv2bk0iW496Jld6SRW/3H?=
 =?us-ascii?Q?DqsFHkq91fg2JqzLraUEeA/1EkJo0ggWitnfAEHmSlfDrHA1QqE5lNYZW8L3?=
 =?us-ascii?Q?OyTR+sqG1j3TzIc0Z45ADD5RgzIvf+55gBquCzKddRdAZeVVCXYwo3WVGJoU?=
 =?us-ascii?Q?6dAkDI9fAFaGbyu9tlo6Q5+zxO5oC92cbLNRO0d3?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caffdf0f-ed20-4bb4-b016-08dd97687f5c
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 06:35:22.9537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pwsh3dyWEu+QUkz1bcigFl7Txz4t719YKkaSOI/8cDI6rnflL8Ht7ffCBeQUSo4ZTmySKZOdVpJe05JjE2MV0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7352

Follow JESD220G, support HID(Host Initiated Defragmentation)
through sysfs, the relevant sysfs nodes are as follows:
	1.analysis_trigger
	2.defrag_trigger
	3.fragmented_size
	4.defrag_size
	5.progress_ratio
	6.state
The detailed definition	of the six nodes can be	found in the sysfs
documentation.

HID's execution policy is given to user-space.

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
---
Changelog
===
v3 - > v4:
	1.Move the changelog description under "---"
v2 - > v3:
	1.Remove the "ufs_" prefix from directory name
	2.Remove the "hid_" prefix from node names
	3.Make "ufs" appear only once in the HID group name
	4.Add "is_visible" callback for "ufs_sysfs_hid_group"
v1 - > v2:
	1.Refactor the HID code according to Bart and Peter and
	Arvi's suggestions
v3
	https://lore.kernel.org/all/20250519022912.292-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/
v1
	https://lore.kernel.org/all/20250417125008.123-1-tanghuan@vivo.com/

 Documentation/ABI/testing/sysfs-driver-ufs |  83 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 192 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |   4 +
 include/ufs/ufs.h                          |  25 +++
 4 files changed, 304 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d4140dc6c5ba..490efdf1a0b4 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1685,3 +1685,86 @@ Description:
 		================  ========================================
 
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/analysis_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/analysis_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID analysis operation.
+
+		=======  =========================================
+		disable   disable HID analysis operation
+		enable    enable HID analysis operation
+		=======  =========================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID defragmentation operation.
+
+		=======  =========================================
+		disable   disable HID defragmentation operation
+		enable    enable HID defragmentation operation
+		=======  =========================================
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/fragmented_size
+What:		/sys/bus/platform/devices/*.ufs/hid/fragmented_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The total fragmented size in the device is reported through
+		this attribute.
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_size
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host sets the size to be defragmented by an HID
+		defragmentation operation.
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/progress_ratio
+What:		/sys/bus/platform/devices/*.ufs/hid/progress_ratio
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		Defragmentation progress is reported by this attribute,
+		indicateds the ratio of the completed defragmentation size
+		over the requested defragmentation size.
+
+		====  ============================================
+		1     1%
+		...
+		100   100%
+		====  ============================================
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/state
+What:		/sys/bus/platform/devices/*.ufs/hid/state
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The HID state is reported by this attribute.
+
+		====================   ===========================
+		idle			Idle(analysis required)
+		analysis_in_progress    Analysis in progress
+		defrag_required      	Defrag required
+		defrag_in_progress      Defrag in progress
+		defrag_completed      	Defrag completed
+		defrag_not_required     Defrag is not required
+		====================   ===========================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index de8b6acd4058..f162eb36f46b 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -87,6 +87,26 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
 	}
 }
 
+static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
+{
+	switch (state) {
+	case HID_IDLE:
+		return "idle";
+	case ANALYSIS_IN_PROGRESS:
+		return "analysis_in_progress";
+	case DEFRAG_REQUIRED:
+		return "defrag_required";
+	case DEFRAG_IN_PROGRESS:
+		return "defrag_in_progress";
+	case DEFRAG_COMPLETED:
+		return "defrag_completed";
+	case DEFRAG_IS_NOT_REQUIRED:
+		return "defrag_not_required";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -1763,6 +1783,177 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 	.attrs = ufs_sysfs_attributes,
 };
 
+static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+			enum attr_idn idn, u32 *attr_val)
+{
+	int ret;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return ret;
+}
+
+static const char * const hid_trigger_mode[] = {"disable", "enable"};
+
+static ssize_t analysis_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(analysis_trigger);
+
+static ssize_t defrag_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	if (mode)
+		mode = HID_ANALYSIS_AND_DEFRAG_ENABLE;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(defrag_trigger);
+
+static ssize_t fragmented_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_AVAILABLE_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(fragmented_size);
+
+static ssize_t defrag_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static ssize_t defrag_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(defrag_size);
+
+static ssize_t progress_ratio_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_PROGRESS_RATIO, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(progress_ratio);
+
+static ssize_t state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_STATE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_hid_state_to_string(value));
+}
+
+static DEVICE_ATTR_RO(state);
+
+static struct attribute *ufs_sysfs_hid[] = {
+	&dev_attr_analysis_trigger.attr,
+	&dev_attr_defrag_trigger.attr,
+	&dev_attr_fragmented_size.attr,
+	&dev_attr_defrag_size.attr,
+	&dev_attr_progress_ratio.attr,
+	&dev_attr_state.attr,
+	NULL,
+};
+
+static umode_t  ufs_sysfs_hid_is_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return	hba->dev_info.hid_sup ? attr->mode : 0;
+}
+
+static const struct attribute_group ufs_sysfs_hid_group = {
+	.name = "hid",
+	.attrs = ufs_sysfs_hid,
+	.is_visible = ufs_sysfs_hid_is_visible,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_capabilities_group,
@@ -1777,6 +1968,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_string_descriptors_group,
 	&ufs_sysfs_flags_group,
 	&ufs_sysfs_attributes_group,
+	&ufs_sysfs_hid_group,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3e2097e65964..8ccd923a5761 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8390,6 +8390,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	dev_info->rtt_cap = desc_buf[DEVICE_DESC_PARAM_RTT_CAP];
 
+	dev_info->hid_sup = get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
+				UFS_DEV_HID_SUPPORT;
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c0c59a8f7256..e61caa40f7cd 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -182,6 +182,11 @@ enum attr_idn {
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
 	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34,
+	QUERY_ATTR_IDN_HID_DEFRAG_OPERATION	= 0x35,
+	QUERY_ATTR_IDN_HID_AVAILABLE_SIZE	= 0x36,
+	QUERY_ATTR_IDN_HID_SIZE			= 0x37,
+	QUERY_ATTR_IDN_HID_PROGRESS_RATIO	= 0x38,
+	QUERY_ATTR_IDN_HID_STATE		= 0x39,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
@@ -401,6 +406,7 @@ enum {
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 	UFS_DEV_LVL_EXCEPTION_SUP       = BIT(12),
+	UFS_DEV_HID_SUPPORT		= BIT(13),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -466,6 +472,23 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bDefragOperation attribute values */
+enum ufs_hid_defrag_operation {
+	HID_ANALYSIS_AND_DEFRAG_DISABLE	= 0,
+	HID_ANALYSIS_ENABLE		= 1,
+	HID_ANALYSIS_AND_DEFRAG_ENABLE	= 2,
+};
+
+/* bHIDState attribute values */
+enum ufs_hid_state {
+	HID_IDLE		= 0,
+	ANALYSIS_IN_PROGRESS	= 1,
+	DEFRAG_REQUIRED		= 2,
+	DEFRAG_IN_PROGRESS	= 3,
+	DEFRAG_COMPLETED	= 4,
+	DEFRAG_IS_NOT_REQUIRED	= 5,
+};
+
 /* bWriteBoosterBufferResizeEn attribute */
 enum wb_resize_en {
 	WB_RESIZE_EN_IDLE	= 0,
@@ -625,6 +648,8 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	bool hid_sup;
 };
 
 /*
-- 
2.48.1

