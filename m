Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A60475350;
	Mon, 14 Sep 2026 12:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390227; cv=fail; b=Xhzp/4pCAcAl9gfU6v9mR+LCCLQibKQ/JbBBW2dNzrL9VwQxW5cbMCjDCWV+xWoAVNluUKH8FBvSywTm+r9OeSTRyL1Ksw9u1HBsUXHH8w30D7Fpwa5/yFiqo0etqzMyA0xEUSGFRiu2uusUvydTewCBTYaTqcBx/cFtmeXFfq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390227; c=relaxed/simple;
	bh=gnWreuaBBylEoDj0oB0zbMDcvSsm3SR78f+PDqMt87E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WjsYaqu8qTAo1By4nCDVQeFFm8QMBiwqp0nxDfMArhHOo7oHxbMHutR/CUxJ1gq2Ft4xs+QU9TlbChiBAFsKmUYE0Yt/XKAZGFqlH8ZoD/OBvBCiCy8yLYITOJ+M7OP/Y6Ilbn1v/xDrdTgdsdAzk7xcWY0F5Wu1cJBZAHZVNHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=soNclVll; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="soNclVll"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XStHnYrH/cV1B/wEZsbuBuHVAhTuAWxPTMDGV5HOz9D7L2H6K9vK9Ps61JO4Hcc7XnWYdwfULFYwUOyhAahq5oOipLqJD1IA6LxEjnesPtVy+8Xyl57xQam4SVOYyRI1nWNy0TCVJ+4ebRHKN8lrDrJxnsCLHzaLOZgQlE1V0uyF2ybRRj3n2BTz5B5wxxH5G1KlAmZ4S3bRVNU+I9nzxgntSslUkE49LBzk0q+RoTgZ5mi201x1tpAPhocKzu1U5E8XYpNGvWWvktL61jL2jMenzIaZzvHrkr7DfGKxNW7gRsFxWeTSUk+Z1E4B3KG626gONhvw7x0vvAn/oZzX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ol5zfhGUpyogBezoZJFPqNYVQ2/vUfOC34G1gkvSYnc=;
 b=NrNpDGC8ZHlSS8MvX+CHf/YUK1epfcgKSDXoionu+EFcXaPhH7aDxj59iruJTwHLWo+iXvMHUUlKRug80Nelg0jSe4bz0N6NAFPk792oNV+gjKUVWhU7c+EsgVVF5N9wTjR77aB+MQ7Mf46uttTts1zZwXQB26b2mS3iF+ypqY15Bfh9/1hVSN+nWnXzAyvu90IoNblegzyHjWPr02aADFgAPG/UhasMPuoSOBkRwJzulos6xmGS/3jAegU95cs2WeZHHrUM1d5HdhDMvPKxsHF/o8F6cYP6k9hF65nfKkKhCBreVT1mDeSkSLBfdrpy+8e6V1U2isTV6NenRaB7lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol5zfhGUpyogBezoZJFPqNYVQ2/vUfOC34G1gkvSYnc=;
 b=soNclVlljdZJOxf5zYZeb7v1X+kJREg9yH55eTPFprb2KG9tgzevjQNM8bJUlPwbV1CYACc64vOWB5Y67tgsMpXOdSgxxI5Cq16Kg00wnFZuPubKH7n6/Y/KV2qQkZtSRM/PL2sJigAG2b6B/hUn+RB2iqNOv1oR+vCb3IwZLoFNOTN24l9od0NGxH8viwvIXC2afBOlyC727JwTwu2rXW3qflq5XYgcQpCSsDygFeKG8nw27piOXY53v0FwwaFlFQJlqoD+AxSdpgOcQiHvz17/41rYK1v4jzUyw8vnl9xnzTyuXzMcChKbvJ7WoMbb0ZQ/QJuY1DiLeiNXsD6ySg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:16 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:16 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v2 06/10] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Mon, 14 Sep 2026 14:49:56 +0200
Message-ID: <20260914125000.30812-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0012.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba08a38-0cf5-4e6b-1b76-08df125eb9a1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|3023799007|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 ViUeVSu+tcGreXGaDOX9cHX8w1hRYovu2//RXMO97wyodN6Z+YxgI8a75szPy5G7wtJtwD9KRWb5c2JiVnDlYOr5zRAc2Km0hJr1yZf/X0X1A8yLiFlfjoQG5nDKhzvGOT14TWK0eS34vyF+IxETs6QZ70XRHO5Ec8fy8LCvtrdWtVv2/J0/DpceaaH3GKqS0A8SSVTZ7Tfk5kB0PerpfoXYg02NDzfuGmJUT4s83r8ZC17vfBFbgl5PqTlf1+qxyd0iHhulSuuVhBsyYainjEKuj8pO319J7/jKJXE2OrsAR0yvOFNnlcl8av9CeISs539+b2s8aYL6xf9BCbaIKb4v+WWIsxUxuSwbb8gWJuvxOrjR9uWCAfY+t1hOopdu2t5wKA0gnhE38L7u2Uww0ldgEw70LAmhQRTg/45QUq/1pDLPaxHLoyq5dBY1fFA4OAOg9d5Lk/9seYSqdXrWigZvxYFZwFXqeTwusRBl6DC0mPqggx5qdnEikblOqGeaRfBO2KcIP+dq64bGodeRHOwhwxg7UCZbWVu4uBsyhP0LOqmCmLD3V5uirF0FjKmBoMyE5g9uKlqDNYFlLtXtgQi9BEmdwjkWptiyBbDnLFK8ja0dX3b7GFV4nFdEqoLaDcmNL4BnKukExl6e1oEL0tUk8oXUWrLDsyIwnHgSXYQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(3023799007)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YmlUMG42T3UrNzJUSXJtSlhiNE0wcFJBRmdpRERQODJ2L2FWV1A5aUtIenJl?=
 =?utf-8?B?QXJmcHlwY0k2YzQ5NmcvNUk3QlF3My9MeC9RZ0xxTll2WXFCQ2xDZGhyaUhN?=
 =?utf-8?B?U3Y2V2hEZ2k2aXlvaUZ2cWdteWIxYUJydFB1SS9RZ2VtRlFZaXRaenpmZm1o?=
 =?utf-8?B?YXdTRGZwWjh5d3VvSy9qOGhiVTVnWUQ4K1JMTVNWbno5U2ZFWlN3UkFpWU51?=
 =?utf-8?B?eWlBRnJyQzJCamoyL1hqV0hxUng5ZENTNGJ4NnVpL25zalBQaURaRzB2R3pt?=
 =?utf-8?B?UHk1TGorU2pGUHV0RG8xT2VOdHQzUHhSK1lkZkp5bEZmd2JMZldNK0h2cFBW?=
 =?utf-8?B?T3B1WnFPSTBsblZCNC9UTzJJbjR4c0NxMm9yL2UzS3h2VktuSndmUmI1dFJh?=
 =?utf-8?B?RDZlWXh2K0dQTkpZVDl2MnNvUm80dG16SktKMm5ncVFJQkl4Q2lYdzY4dm1S?=
 =?utf-8?B?ZTMvUjhaOG51R0ZlbXloZ2dvc1pzenJFK1VZNWszSUxHTGphQThFT3JYam95?=
 =?utf-8?B?a1MxSkxVKzhCNytDa20vMGRnbUwyOHQxQzl4UzlVb3ZXNk83OWRsTjNYbGlr?=
 =?utf-8?B?d1RKT2FrUjVEOEpod0MrLzkzWCtNZm1RbTdCTGtZRmdjYjlPbjh3cUh3Y09q?=
 =?utf-8?B?WTYxWlJpdmk5Y2tOdEtZRzgvck9sUHhVbEx1ejZwTTljOUF3YlcwQ2U2V0tr?=
 =?utf-8?B?T0dNdkdkZlI2QjZoZEJSUjBkS2lGbkhnM2kvQVI3dnRxVDJSUVVIazhKaFRR?=
 =?utf-8?B?T1dPL0dyQ1pYUWFtZmQzRk5PeWd2aWdrNjZ2UnVjcTEyTk5MSmkvbmZFNXd5?=
 =?utf-8?B?bW9ock5SMkhJSkZmbDZHMTI3NExEb0crcVhZVTRBeW9Eb0VuTVV5amN4RkJQ?=
 =?utf-8?B?dXVQL2JqZHhkY3FjbzZUYy9HOTdaYmlVdWh3VmlLMUgxUHlIOU9reGNHejRO?=
 =?utf-8?B?bkU4ZXpGV2h1bkZLLzVDT1N4OGF3Wm9VRGJ1RzBKWkZlNklVMUNzTElVSkRo?=
 =?utf-8?B?OVA4QWs3dE8vcFpSRUVva3l0VzZKdXF5cm96OVowcGs2WmE2TERTSzFyOTlX?=
 =?utf-8?B?YWtjcFJRbkRjQ010WGpWMkZRUks0cnNrZWZPN3o1T3J5clFKck9Tdk1FVGJ6?=
 =?utf-8?B?Z2FQODNjaFpXOXBzL0RHT1ViYm9uT3Y1dzd5Vi8xdUZ4VVhKMDhwSFlIUVJK?=
 =?utf-8?B?dFhWOHdUUnpwNDJtOXFKZEs2SXp2U3lhVkpKK2xNRnlWUVI3VWQveVdxdU8y?=
 =?utf-8?B?clRlT3MrWFc4cWxWZ0pVc3JTMEwyRmI3ZGg2UEhQZ2MwNjZMSUE4Mlo1SG1B?=
 =?utf-8?B?cnNROU81cktzdkZUVDNuUFRDZC9HR255SzdSN09ZS09XRjU2N2swSHRzZHd3?=
 =?utf-8?B?alR5bzBFVE1idVFNS3hKRUM2SUtWdW5SZVJtYWlicnlYSyswL0cxN1JOQnEz?=
 =?utf-8?B?L3NVVHR4WU00WE5iNm01bnI4b1hjUXJ3MXRpUitzODQzSEJDV1gxcHlaRTdQ?=
 =?utf-8?B?UG80UmpndGh3ZFhsS0U5N1RUaW4yaHM0aHBJaEtzOEJtWUNxOGFEVTJSLzJ6?=
 =?utf-8?B?L3JQMUpvanBYSEYxcm5DRHl3V0ZpaFk5cTJwZ216NHh1eHRrTTdSQjBOYjE2?=
 =?utf-8?B?QyttQnRZa0t2OVdKMWpiMjR6MlBQYTMyaVF6aGRkSUpzL2hDbDdYWjgxUnFT?=
 =?utf-8?B?QUg2MmN4OUVpRnROU2tqc0t5ZWlKcXkvTU1vOG1GN1dHb1hjTUJNdERLRjZI?=
 =?utf-8?B?MjNWN2U4QjAxc29lNzNUWm82ZkVWV0V1Mzh5eXBvMmwvVXkyUGwrNmthUEpR?=
 =?utf-8?B?d2s4WUJjYlZLYU10dVpUQkZFOUNWcW1wWHZ4VTVNY1ZrMHQ5VWp6OGdtWmNC?=
 =?utf-8?B?SjR5R3pQaTJ0Zk5EcHVqRG14RFdSU1craTJrZzY1T0l1U2RQbUhQbWRLQ01q?=
 =?utf-8?B?VU9LK2tLeEdoSzFwWlJ1MTBYWnhEcU4xQ3ZZZEZGUTJ5NWNRd1VyYzZFekZI?=
 =?utf-8?B?MzdmY1J4RTh1dWR4eDREajdPRmR4dnNwTWtHSVdGLytkeFVRNkNEbXl2M3RE?=
 =?utf-8?B?VkFUTVB6UWdWczVUT2tQbW9VMHFWcnQyRHVTcWl5UUpSc2Q3QUU0VnpWV3p2?=
 =?utf-8?B?aUJIR1Y4bWpGbi9OcGFpbUthU0tWYk92R2tkRkZ4d1B1bEdBL1E0dFU4OWNX?=
 =?utf-8?B?Rzc1RThjeG5XajBnVm1IMEVTYkFCYVFkTUd1cnlZMDhWdEZFRmZLeEt2VEx6?=
 =?utf-8?B?dlJtd3J4dXdqQmFXNnJYN1MvSkFjT29DQzJwUGY5aE5pbUF4U2I4cXRDQ1RB?=
 =?utf-8?B?bFgrbVZXQlBDNnZpU3JtTUxSU0FjaEJFcVJMcEhFNGNPZVB0bGpNUFF1V0xC?=
 =?utf-8?Q?98gSSfwOJSLcf2hY=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba08a38-0cf5-4e6b-1b76-08df125eb9a1
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:16.1373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHjbioHOcxKwfC7f5iXzrIro6mqzclHPAy3S854fxyr9F+1pPBxYmIYQF2rdMYeaABk32pMJgA+MIbzkSZssxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Document the UFS host controller on the NXP S32N79 SoC.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..2bede50a9b6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP S32N79 Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Larisa Grigore <larisa.grigore@oss.nxp.com>
+
+# Select only our matches, not all jedec,ufs
+select:
+  properties:
+    compatible:
+      contains:
+        const: nxp,s32n79-ufshc
+  required:
+    - compatible
+
+properties:
+  compatible:
+    items:
+      - const: nxp,s32n79-ufshc
+      - const: jedec,ufs-2.0
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: System Control Module registers
+
+  reg-names:
+    items:
+      - const: ufshc
+      - const: scm
+
+  clocks:
+    maxItems: 1
+    description: UFS core clock
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc", "jedec,ufs-2.0";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+    };
-- 
2.43.0

