Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013003.outbound.protection.outlook.com [40.107.162.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CB54C10F5;
	Tue, 13 Oct 2026 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887436; cv=fail; b=QOUvnfWq0VFPHq3s0vV7FNnoUWY2yKplZiLcXrE0pnQqtgOX9vAGRrmvD3HuJyAfSs75mzZg0Rhe9eSgX6PwtTU2cFPpE1HzrD8kVON3A4cAuQTI2tPqUcLcWuEiz6v9qA2g2RoAGdgmhb+y4LFtX9NXefR4Nuv1VqMRX04lcK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887436; c=relaxed/simple;
	bh=Vt7t3svxZLZZLB2ckezvJvq1fL5WHp04fFJKxtz4ssA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QRFZCUqGUSUVg3o/XBCn2+ooAJlNI6r4zosqxLhppRJ0Ba+MqKCdoq51ba867C+Eo4Kxb7LUoUelvS/kgMkFpEMx6OxrsKUltHEdloACZuIN6wWNJ/z/FaRuKoNZZ+7wZGGEh4OPFcsuawajUUpTKVa+/nyXGfcQVuXLEhjnoLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=x/f2lJ+7; arc=fail smtp.client-ip=40.107.162.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="x/f2lJ+7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvbA7NHteaAyNlIYUWzWUMomsfLUXTab8W9Tnj1+FoPb+SZ+WOoeLL7lVV0oKsmdIEmfXcCTzV6If8+zoYmKMigAOCmdRKZG7/BsR8cwY2qS5pFCN8zd/TnQUUQ1g1xkNy9ERVHk8XkZ/eQiejHaJkbqX31KVklRfE9tJwV340SrfXAc6++goN2dzRYdtQVr+PDiILtfu4tsmEUCDAVav+12/zviTltE46LuABiCi/Hni50bY7PeiuRDuFBPZEms9hwsrenj/KcZjwkLJebDussOFqCzVkrzZe5To8fP6EJpyJ4bGOJRl8h2OFqh8XVXt+j5/gU2j0RuLTnWY7U1gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLq+y3n4BSiP7S06O4kVb0Eu9yfX+C6WQyu4o1bwjwg=;
 b=Efhq31i6dvFujGW6XpjLIwiRczcFMdLBIyCn4ZTbsEGET136ras0ZZF6QPDr4JQAXHwWYe0J6KZDpAbQmfX8j+X52W7I8eYrzJiTwxBAOxoc/NySkwsL1JtWK8zTauFxuu4KK/1aQ+yMWeDL60Vqla2TBwp1fIy3ZV8XhqS6M73okSr6xU7WwhaFsFOh6YEQayvj+zBeWOPTfnaxgJi/2BkutQrEAdS7MMvHaL1To/zr39Sb/uejF06rYprZFu9uf+zJoNI0vZapzrX3yzcBXMZ5SmicNXIKdkFyWl2c2gad4D90AJ2htCcm8b0S1pW2xZQ0lMz7NZLSwoXBxg2SXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLq+y3n4BSiP7S06O4kVb0Eu9yfX+C6WQyu4o1bwjwg=;
 b=x/f2lJ+7eX7vM3NHJZzBF8wdKhyEhcP2LSLPbR1+M/0+q3FHbJSHml9xPiqG4qoPADxDgiAqx3qzFXTrdJ9/y+ZYCIai69E33oI76x/QBbXVaaogvuhqkAQKdFLm1DxbsYiI9oPxFt2+AOBEGRR9bJ1DDBmOdee9VDR9HymM6/q/SNfsDJobNe1FXn/s5by3YK+GN2qi2HG+xzYttQ/HpElyHSoYS62guZkVUnepl09xC+4I1DVk/wUHa2tcvWzCEHMVg7a2GB9ecILO7x3zPRLWH4jAyYwoPOrYIbKVDlSSdn76/tsNfUtXuYReUds0GXYZ6hfFuHDrov4hYWQXMQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:30 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:30 +0000
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
Subject: [PATCH v8 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Tue, 13 Oct 2026 12:29:58 +0200
Message-ID: <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI1PR04MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e67627b-9c62-4c9f-6c3e-08df29150126
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|22082099003|10067099003|18002099003|3023799007|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 4yJU2CHAKvAZVKBElA2iYtjYp7aFIbz1lQFETk0cgYG9VTj8EcaTe8dIpePhA2ZiOK7svO1Qw6990xqPHhTu0lWnM8w3/xZ4R+EbgTzNcPpydBoMWJhXllIeoGQnQynAT1qeM4/rKJdakJRVFe8kJitzI4gu0ru4Cl78cUz/Z5z7yalb9jcO/PpzP8Pnv+7w4LotRhDyYH/MxspuuMjDEeeDF8WxWKPw1JTqKU78T3/23+VMCf1IiFiKUQwBbZMSn4ImaDxlezxPkQ33VJ7hLEy1/JO4xDfl09ohLecWQMk2qKw3d7S4Jeu6K1Qep21/S8kZQzYVxqxOX64zK58xCzg4oFJA2NhZ3Ps0zll1xzCOPnDcWbrowPrdO351t0/veKJj9cIbMIPSSQQhGF85Q39MonIoiYftpxv4f1HE5G20rmoz15S+MnB4W+Qj4XGJFf1ap8BtAgThHLrYyzd9zMTzNlXFvb3gBySjWT3ljPjLjoc90/vIQB6KPZxYkjPYVKeocSDOj4zhySO1WBEecxj4etq0/TDNU2y31ZPop6DdJNwIEliT9AebdMc7yrbSbEgVnC5rZfM4fK4+dZL3Hjqx/iauDtcaj0g72VW0ldfkmOTsZNYUIDM8UUNGWy6BckvLwN1LNUcf5YcEfLfp4NrNv+gAzJ5sMywalmVWWtM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(10067099003)(18002099003)(3023799007)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QzVxaVJVK3NpYUFURmRLNTR1RDJOZjNSaHBnK1lpSGpKVldRNGJxbW5ONFhV?=
 =?utf-8?B?ZVhEU2Q0M21rdGNheDNESWdpa3pmTUxOMDNyYlpIME9FcHBTbnRzWTNRR0pU?=
 =?utf-8?B?WnVOaXBQaUU0THhoQk1UZlZIcHZKUTNQcTBWcWxQbUl4UUZLMG1ENTI2czVm?=
 =?utf-8?B?Z2UwZE1RRG9YL3FjNUJuTE1XNmlEYWpTMnBmSmJ6SlR1YnU2T0cyTzEzS1d4?=
 =?utf-8?B?MVc4Q3o0QnNtRzNoZUdEWng5NHVhditETnJaeHJuYjkrSkxoTkNvajhFUjk5?=
 =?utf-8?B?TVlBbUplL3BqVmpwYmx1bWVTUms1VWgrc2xkTlFvWS9rTnpDU2xEd0czTnBi?=
 =?utf-8?B?SndxUGxqL1BxZ0YveUtBWDJVNnNEVEl3akpoU1ZOTjhDbHJUR2V6UmdjTW9X?=
 =?utf-8?B?b3Q4TlZLVm4wUW9iVjFmZmFMR25FQ3NBWE9NaS8vRVhONjV1M0c3OEEyd0dt?=
 =?utf-8?B?U2lVaWUwbEYraVhsRXZrSUVackpUaTZPNUFKUlBWbUpKKyt4OTY1bXFrR2RL?=
 =?utf-8?B?MjEzSzZHMURhVEtHYlQvQWhKN0hJNzd3dkxlRGxneSsyMWJEQTU2ZDJ5T2tD?=
 =?utf-8?B?Q0hITFZTQnJXNytXM2tjVHZhUW1ka095UVpyaWZCNXpwZlRtdFhNdWs5WTlw?=
 =?utf-8?B?MzlkMGhtdDk3VFI0RFFQdGU3bDJWZTl0TkVXSjJjK3R0eUhMTWpiRkd5VGZv?=
 =?utf-8?B?bmdOUEtKaHNxaHlaaVoxSUlma0pwaWV3ZEVHMVVOZXBqN1lHUm9oWDc2Smcw?=
 =?utf-8?B?R0F2UXVFVzZKKzBiV3VGVjFQNzh6N08vRy9VUlRKZTkxTWJNeTlzcFFYU3lW?=
 =?utf-8?B?TDBSVC90dHhYZlB5K2d3VGVKdTBiOFQ5bVZyVm92VmxDdDBlTmNGaGF3bmt6?=
 =?utf-8?B?MjNnOTVkUzdHTElvUmJLY0xuUnNHVm9jZTF1NHVnV0pBYnIvc1NCazBCTXV1?=
 =?utf-8?B?Rk95Y3VmamVBMC93ZWRyRmJrRXRuZEIrUXQxb0tWRnc4MG9nb1h2VmJZbVpF?=
 =?utf-8?B?UThDcjZodVdVWUZwVThRK1FVVFMwMXE2V0JiallhQTBFc2pva1RSYTYxM253?=
 =?utf-8?B?dTUzQXJsQXB1Y3VjUjZaNUZVNnpNdFBRSTBkK2JCMUVKb1I0NFFOWDBhRzNP?=
 =?utf-8?B?eVZ0M1czS3lZS2UyTE5nb3hUdkVHazNYS2lvV3o4a1VjbFYzcDVwT0hLQVdU?=
 =?utf-8?B?OC8wbjlOVkpHTlJ5TThCcUFnUE9QeWpTcmw2dk1qTVkzb1FXTGZQMG9STVMx?=
 =?utf-8?B?N0VabE9rMCtiMVlpelY0b1JkWm9LSE1IS2V1U3RzRDBKckpFVDFNU01hT1U4?=
 =?utf-8?B?ZE1BTGpZY2RNc1lQRlQ0dTRoWTdoOEZTMjRoRlZsMDVPbmd4bnY3Z1g3ekRT?=
 =?utf-8?B?TUFvU25xNGpTYTdDcE5XeXVKaHlHQUViNWcxMkN2VFF3Q1AxYzlXT0dhRURq?=
 =?utf-8?B?U0l4czhtZnlpb1ptUG45dXlnL0FSemFzeEI5bXVGU1VuT05jVnJUWnVLOG1B?=
 =?utf-8?B?ejJLSUtmd3Z0emlSWHhubEttbzRRRU1QYTNSSllnOXBuWDNMdE5rMlN4akRp?=
 =?utf-8?B?Mm54b3VxZFJnS0ZhcmtvUHFEQkdMOTlHYTE5TEdBS3dVODdKZ1M2elZMZmRm?=
 =?utf-8?B?UU0zVUMra2tTc0ZaUkpNcnFHeFQwcEo2MWQyVmVEUnUyVFA1dGg2Ny9uSTNj?=
 =?utf-8?B?a3hLdC9wVGd2N3lnNCtCQjVudW5VODZCS1VRVFlldGdUMEc3cWV2TnQya3Nw?=
 =?utf-8?B?K2VJcWFBaG03ZjNSTVpJanhWdU1DU2UycFFtZHRORVE2a3hrR3lJLzAvY3Ri?=
 =?utf-8?B?blVuZmFOTjA5K09XdmRLM3RJSDRsejA2c0VleCtNMjZJT1ZSQ3NUVFNJS3ly?=
 =?utf-8?B?Y1MyV0tVNHVkM0ZueWtyTDZFUUdjZnR6cWd0WFZPOWpZL3RxN0s2NFF3YU80?=
 =?utf-8?B?amF3L1h4WkJXUGxaQzlrM09JYmFIc2E3RHZadDV4eGY3QjJRSGExODMyaFBz?=
 =?utf-8?B?QlB0T3BiT2N3UjFGZ2NmYkY3UW9MSmhjNFlvVzhBZ05zZElGMC8rVDRVQ2ZY?=
 =?utf-8?B?R25HeGlJNGlRQjRJV2s5QkFBVyt0ZmFRbW1QeXBRaWxWVHlGdUo0TmpKOGpt?=
 =?utf-8?B?cTJWOHNidWFueGk1OGc2dzk3NGVFeFcrY003VTJXcTZXZXhQbmppUlQ2ZmdN?=
 =?utf-8?B?dHdJdGpKN0hldVJjN2hEOG9JWHVUQnZZVHoyTVBTZjZHSTlSTHA4SlBCT1Jv?=
 =?utf-8?B?aHFERHo1MU5zNVFlbDFrQVZtdzQ1dlh0d1RiNHBkZThYbW92bnZ3SCt0VDcx?=
 =?utf-8?B?OG12cUpNR3cwbkhRQ05kWXFCSUx5OWhiYzdSQ3lqbXU1OG1nM3FhUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e67627b-9c62-4c9f-6c3e-08df29150126
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:30.0994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Um1SNGu7ojxg+oDs4CcSAxjaHlVcUEeBwp+27LsYPecYnIvfRycS7++EIssVqBmJqqmx1q8emEwaz3hYa3qEsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

Document the UFS host controller on the NXP S32N79 SoC.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..14291c5506f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,65 @@
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
+properties:
+  compatible:
+    const: nxp,s32n79-ufshc
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
+
+  clock-names:
+    items:
+      - const: core
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - operating-points-v2
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+        clock-names = "core";
+        operating-points-v2 = <&ufs_opp_table>;
+
+        ufs_opp_table: opp-table {
+            compatible = "operating-points-v2";
+
+            opp-0 {
+                opp-hz = /bits/ 64 <0>;
+            };
+        };
+    };
-- 
2.43.0

