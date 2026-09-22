Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F04517BDA;
	Tue, 22 Sep 2026 07:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062458; cv=fail; b=OLXhtjGRRJ9Sr4uSoPyudA0fFu1lDAUXMZ6GHe+6mXtoP4SZIAgVnFxmvP+6F1Y5Yy9vvhkYNFtH4L02O4fB5IvqZ4xUQXb2jgmcz36Ic7Izyj7KUjr0X+BRkW4gQAgTbdLx+FndUzNpFbBYxVKtBTxMI2b+ClE5IUPszemaMAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062458; c=relaxed/simple;
	bh=N3b8yvZL8nOr1bSjt359XhvxmXu8OPq8MUm5GsZ50P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m3I+3SabGHnpb0WYhpLxvvijAcN49ZmwG1i6LyORs0djdGwGC8qqZC+//yC6NPG/SIu9B2dPYI/c6N/ZLfyG01ybEKCDPQfLMNwrkei61GPBS0ohQpDKqMgKXX/Ln+iT79BPVGVkpd2I6PW+Pw5qTM6AJiqBJSzniMJ5sdZQgvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=dxfylUef; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="dxfylUef"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FHoWanWoksjvbRp0F2gzjRjxQ1v3+aT/QpzlYf1T7VBtPPdhO69DuO3ElqtQ6SpVNjEbd9sSoejqiJ9hoIJXE4MeHAzU5hRydqVL97bjwgoYs/o1e3PCfJJbnRI1xh8kruzmvhC7as9JLOTOJ2VhYOP+S1vnyL1XBtjwCzLakaDtTXXpRVOp3mak6PF7/8xl99z9tX9fxHxPgIrNUfPMvTZgu5pd7ZlZ9ylixsl52I4qkpYxgQxzdNVV05bD23EB6EDniVjf8uStLvKju/WPIHWIJ3aa8gTPRoD2a7iW4RLlrvvQcuY6g8Uc6Hhepc4tTWRrTTU3/qg4NY6ktQuIRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1fYQlKK4Z5jSC4WP88E0Oc7f/fULS2/pKPT2PzeWXM=;
 b=V2VGQXTJ32L7Syyed86JilmsfMO24QdqMa/FNHsFO4Ca0iZuqsXqtr8aXYQhqWG4eouD1Jn167yHVjwbiGZkuH2nfc1sFJrLGeMTfnX7BMtpo0DddRV5KNKu5tJRQFpL/GGMwEA8G9UIAAuJUDMwgq20wrK24JpQuAddSa7vg8ghsRrj6V0TBIquNUdWeBlojqn7i3LhbPEjI+qD1/ycEXs+J35+kNaFqCGkvAeJXt+Zg6ZA4kZhU3ueM4EaExgXzyAb6/zb4UST4TlZL4LldvZhUGVsp8WK6OsvP6H5GNxDBcFAHsc9a94MOTsmGjAS6+2Ch++zTmjcNPaFAXeiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1fYQlKK4Z5jSC4WP88E0Oc7f/fULS2/pKPT2PzeWXM=;
 b=dxfylUefEwcwXM4wig/ESUFkCW5MX1a4ZgA0CkTvicym4yn+0kZA7yN00DFsZC/ySYlETmtlV0VHa7D1Dozi0TAcakTSGomjwKXvGVfI4Kt2CY8SOKmxo3qF8ke3oB8ez/98ipbyUGy62TuG/5mCS+E9Z/v6d20f/h28sqxojqC9hzrJBkbEzz7gFPbxuG1TnqPjCMjnNifFjGSTEIKDLfh2thf6UZXtHolL54Qh+jlPbdL58AtNttSjJz9W2pqSLs5ZCC65fazla0q//l4/h8ZKfRrXKSTnUCAxsRLOu9Or+8XDLSfERMAz45OENbVYW79uJM4fTHnHA/yxz+6NuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:36 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:36 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v5 12/12] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Tue, 22 Sep 2026 09:30:09 +0200
Message-ID: <20260922073009.1449688-13-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P309CA0012.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MMZPR04MB213195:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fbed124-1a73-4a36-17fb-08df187bd020
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 muPIpiz9OxmbK+z1qvMZdH0RxtZQ9Qk/FMvP+nX7joZU9ZajvE4MyDcYa71Gie9nLGCEacfOeQiL8q0jQmAjNwX/fVPg/EmTgmOij+BqYSZgjKJroLQdCcH+HvDQaZC2Zi+93JZtIqk5xjhxcAWdRFf4cVieziXcHw/t/7MU3yYd2GCYeNnd3MI5j/AasXPniL6+M3TTTej/pOEXUIk+Zio2MN1hkCGq1v5Iauio774xPA+1vs533pXk3Z/PFS5VXGLxxRJ3K4WDWvbC9dBj5h+vL2LK2x0mwGZS/mPYFrFXygWdWWkG5jhqRBRkmd4v3Oy83gT+ZNQRpFoGql9U8H290gSqnKxPKp167qf+w31WOgUWaPbAvwFVuk63YTODWHu45bbj0obGcP2U02t26hPiqTJ9g1nq1ymo9nIwpmFJ3z3qXOSScVtnSZcy5I+dwOi6+BDy7/QTVOI7juKWbA+QdNuMMMesHjXQnUh4oubpLUDfgiNxCPaCY94Nb3BmaU+YSi+kIsLoqwYygeoK4cwwma13fTQPvFcNbmr+ksfaJtRQa8cN0a6007XKMeOkXkkTFo9Bgy5l9W3oiV6zKDhdefYHYjELRapQOc62FkAnS/Eo9Il5FU5v3gh1bA6UmfAQKZwi6apL9OTad2R5YpOOs53E616zG1ChMM7ZohAbLOg1//ZvvJ1cFJHfrDe9Ziz+/yYfWXX85vgm0jDjRw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?V3JUVnJJVTF2aS84ZkRtTHBnR2hvdXRBQ3ZSb3h1OUtWNGpZOTVaNnlpcUhG?=
 =?utf-8?B?YlN3VkNpWEpoRE1jQktIMTJGc3YvU0JsdkNuU1lwdFVReTFYTlhnSWlMMlhB?=
 =?utf-8?B?T0l2eXBiR2t6ZHpIczRYM3kzaHpuckV6UkErcUg2S20xcnpEUVVLeCtmdlBa?=
 =?utf-8?B?bkZ2VElvcmE2cHhhOE5lWDFNbGdEalJFSkZUTTVpRmRadVg3TXF6VEN4dVM5?=
 =?utf-8?B?L0tyOWE4RjJESlhoRkovWkUvUTYzZ3ZFdUFQVlIvcW0zL0pTUVV4QXhqblZv?=
 =?utf-8?B?T2dyWUw4NUJOK3dHbVdlTGVIandvemo2Vmp5UDZRL0JKaWlnVm9VWlIreE5X?=
 =?utf-8?B?RGdoS3prdVlZNlVWdUZ1eDE0WUwrUzRCMEhQb2wyNXpIdGNLR0ZoWnB1ejZz?=
 =?utf-8?B?dHpNaGxYOUpENnpCSUJDSFE1T1hYUytacmpPUTNlRWN2aUtEa0Z5QUowT2hU?=
 =?utf-8?B?cHVOdXhTQ3JwRGpoUSsvMnJxM1pBeDZLcENvZzdmaThRWkVmczRMQUlHUEky?=
 =?utf-8?B?SlFKQ0l5WHN3SjRhcWplVG9VbzluUTBuL3R6OGRTM0FGRUtiT0RLSXhBdllr?=
 =?utf-8?B?aUQyV2ZBdmZyUUg2WUZtS0htZ3p2ZGExend5blQrV3RDdHB5OXpleStXQlpD?=
 =?utf-8?B?WHlJc1hFVVR0MEhkWVBlVWxDbml0MzFTb2tYRmZRTHRERDNIT2dwMlpkbTlu?=
 =?utf-8?B?dS9XUjBzR1hmcm5Icy9JZGpUM2RDM3YzWUxXdmdubVI0eENYcDVUalJLV3g4?=
 =?utf-8?B?WjEvdHFrbzZ3MW15eFRnNWdPUVJpcWlPU0dwK0MrVmJyYlEzWUlhU1BvaTV3?=
 =?utf-8?B?b2RRYUJqcUhLajcrME1wdXZZa0FiZ0ZqYlZKMVlmYTJPZHJ3MkYvVllIcTR1?=
 =?utf-8?B?YmEwTEEyb2hrZGp2QjdjaXhxbGpUb1JRejljQnU1UWdSZ21FcWJaWFRkRTY1?=
 =?utf-8?B?bVBUQ2xsTGlsWjh4a01kb09INkxMWUlhM3d3NTdwVzFBS3NoY3lhTTVQeUVV?=
 =?utf-8?B?eGJMOE9MQVJlYmxqbzhTOUJCYU9GdUdHbzdLdkFSY0xLTkRzTXVGeVRJQ0VF?=
 =?utf-8?B?V2VpaWNSVW01eFlwVHhRbDZHZG9kenRLaFVTN1NtRWI5N3NhT3psOGwrV3Bz?=
 =?utf-8?B?a3ZVZE9USWdKQm9JUW9hM1FwczhJTWIzMmQ4V0NjZDVPK1lrNG1aVWJna1Zn?=
 =?utf-8?B?LytGNUlHaVE4bVVwTVVtbkYwSDUyQVpubTRkNndGSGVFK1B4aEJaM1hDczYv?=
 =?utf-8?B?UUoyNmUrUURHQmQzQlFRZFIxU3lRcU8rbGNrNGs1V3MvZTF4VmVNYjB1RXZH?=
 =?utf-8?B?MWxMZ2o2amFCNHRXS3JHVzZqYytvdHRxdXcvdTFFS01GRDdhcmIxU09nYkh2?=
 =?utf-8?B?M1NPWCtJb05wVXArNmRJNGxrOTZ1OG9zQ05GelB2dU4rTk5VK2tkaTAxVmJR?=
 =?utf-8?B?cC9NOExQRXphODY0L0UzZS8wODJ6OWNaMk9HejVBVEV3ZzJhQzMwS3pVOHVP?=
 =?utf-8?B?ekM4bE5CaEJoemlYcm53VC9GMS9HWjZ4MVpqdFRpdi9PYW9TbW0vTkFvKzIz?=
 =?utf-8?B?d2VHZnhuT0NWVkFrTmRaU0NpamVLVzlvNlJSeGpmY0N1WGNtbzhpUEpTbEJ1?=
 =?utf-8?B?OFBOMlh6c1ZzeGMvVTdmb3htS1lXNFUvaHVGeVV0OHdPQ1JuS2UreW40OTlp?=
 =?utf-8?B?dG1KVVdmbzJlNFlka0l0TmpnMmVpYndQS1lDUDVNS0lncUJod0preDhCa2dB?=
 =?utf-8?B?QXBleFBEMEwzdmQ5blRRNTNmNjdiL3hxeTlmdE9NOTVuWnRJRytoS0p2d2hU?=
 =?utf-8?B?dmU0OFVIVGlkWTN1dDl2K3JZT1pQN1p5SDM1WjI3S3p6by9RdzZNbGtHbFRB?=
 =?utf-8?B?cU1JajhOU1JoSnRJWTN5MU14QTFoVlV5Q1Y0RTVua3M3QU5VNUpTaHVPQk5x?=
 =?utf-8?B?UzZWVXR3ZVY2Tjl3U0NVZURYVVRNcjdjOW4xU29JK0JxV05wOFVUM0NIVmJy?=
 =?utf-8?B?d3RRMUR5Wnl1L1M4VnVTYUs1RW53cThoUnEwc1VXQXVod1ZkUGlSRSszdVNo?=
 =?utf-8?B?VXZ3VXR4Y25GWnhhTHVNazZ4S0YzVkVkYW5XR0txM1JheTYxb1ExZFJZeVV5?=
 =?utf-8?B?UnNBVmE0ZG5ncU96ZTJxMWNoWWEva24weHBJNDA0WDU1QTVLQlZUQ01hazhu?=
 =?utf-8?B?ZUNxWVJHQmIxRDBibHorbXBEc3dRSUx5NEZ5emk5aXhKMVYxVlZIbGRYM2pC?=
 =?utf-8?B?eE1QK0RaOHVieTMvTlFMdXNVVjVTeFlPT0IyWkUzM0tCTExwamZVY0JuTzlp?=
 =?utf-8?B?U3pneVlZdkpPUi90elNvRnk0WVhEU3NrelB1Y0dxS0tTVVdHVFk0WmtjS2RS?=
 =?utf-8?Q?vqQEoDte8vlURjFk=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbed124-1a73-4a36-17fb-08df187bd020
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:36.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2w94haSIvRyi3lsHV+BD3H3VXE9MVNwYBQt0qPHmi/IhTuZ0dcMYjscL3QPxNNcaRBUcPJb5I2IQWGFQcTe3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a89a..32b01db895f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28096,6 +28096,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

