Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6461E3C4B68;
	Tue, 22 Sep 2026 07:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062444; cv=fail; b=UvGiHnaq8ximIv31CjzOOhspOz81lIPE2Yk/Ai/caENQ1oTY/a2q2mSAeKbhlGSDbOqn/2o2LDwAWpnqO4ataLaNy5AWhGWe3WMCAorKgC6mZIBbU5c1lFFEMqRNYbU3SW8CpFMyf67EbamEVxWm/mIFSnyPIVU42T1razeQseM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062444; c=relaxed/simple;
	bh=vxHiHQ8TCou2gMacBhYKabBwcQsImxAuGRXVVJ0KjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JVkhoaz3TLTFwemvASNc+frig/vHOHjogCIjYIGeIbd2ja+C1v7A8oMOAYtnJGpGZwYSvp9IeyXcoyQeLrbEVQy82Jbq8O7uAiWefBFZustUhzo5C+wEi8PZG0SGyLSoqmAZLAXCQcIXtnO9bemmTqT4rlnZXuB+xIyW1vuJ08Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=OW5/24sL; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="OW5/24sL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKJiHXJdBFX5AAwAKs0hav1xZM15j0fu8fO2W0ffUKlVdXLaJ78koiI226EG3B5qQsPDHXBjvAALRbfIAfRTe+huFEW/bHQRLWrUjLqyU2P/SSwSCb8C+/Y5FwzZmjjExLVNp84GrElAVqjDCVAznUFZT/Qn0InRvKrPo334jueGu4ZSwcQs5l+fmr6YfSBASkOFViH8wU3X8pf7Wjldtkw/HSeXVowPkO993A+FyAUZlD/iRa9dpVEZjYQ0ARzeFxnrwU3/xe1N/hNZVeGkQf2XCy911IYNEoCUnzYzGo1sAkZ2316m9XTAUv43FS6UBN3dReaHNl6xHtluMD2T4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFtPGxIpz3UV9fRrrYum/6wEcffLzC7frZcFRmMGgmc=;
 b=hEMskO+xTtYRAOwXFy0hBCpeDCaM+Q+J/hdkzShHLvAGQEIqhhSZ8UtMk0ehxtHy3PLGUdZOBlOnxMrMrCkKlmiRZ3VjkKKoI2CjNL4O2JMXadhnsKMll3gFE3gDwFe2aTlYyFn0+9rsKBPAxoank0X4+X32kZOjxbFeQJv2JBxmhY3BJWrOenPfE3kxLihwTT9ltYZ9KqCJUOhwxahIMX4g4EEUPHXjB4csCttR25/Ouz3t01igkCybWXeBIE2XGBqfBBQqOKx2TFFIjecbVcrwFR9eyYueN1Ez+v7fUsDmHDJOvR1N3Ymo4erahsAMjoaKRyE9eH4qr+3jq5ajFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFtPGxIpz3UV9fRrrYum/6wEcffLzC7frZcFRmMGgmc=;
 b=OW5/24sLAtkHbqLRKd63Ba0Zn+tIKosrbPiBe7y690SqzH3dtaOQ9M0TUmkkuuf1RsZZvxutev6ky3L2qlIjIeAUOgHj6RjbY6yqSjKxgd82mgUFwJNt0lN6b++SZKGXfX5Us7dUvLQfJoZj7FkH2DR9fdjEeC2BHYlJ4hVrnpEYgj8jfxEI7OHCB/GybaxMbKQBENtlR9DTugTORtRqLg1tWnpsPYNOirefcXSgnZ3QU0oeuRhVFsk/fWegecsKjzEGeboxnLcBUzGa0kQGPO30J6PQYnYIxMPknkDfGs35qK4GjCS1TclsCr60m5DvzK5FjVUnBpmV58fet6uZOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:26 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:26 +0000
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
Subject: [PATCH v5 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Tue, 22 Sep 2026 09:30:04 +0200
Message-ID: <20260922073009.1449688-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ca7b3a9e-0884-490c-3b20-08df187bca60
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 98c0iozF+U4jdT25CtklWPxjNvwJowfJfPdf4j1rYHs6TcNLy/F2agmH75cSWalUXZvOu25rm7pYLVPCpwe7bj7PqqjN7ifauzdtl1b3J/Qlqo4QVX8cCmMkZMYyaODKWMBMGZ51SBoSYUVW5rnI0/gdueckeVT80xXD960qGfqbWdHPl1MI9+nc5xdwE0EKxahvev4bkssNkszn2rYowbK7ceiJyCa1QuBMEeHIz/Yv8fdImhWMINBxazuda2C+UGgtno7KN+oB+5y17PcWWYREGfjVHpuAZtWXb9RzjiN3VJOFJzESKBao3OJ7KBCsvDRY7c5d7VtXN3JvpUJ7VBrz7hxu7R6O4f+i+I20Ogjt94VdsLYEVdG52nziDXUsfdmwCF5qqPLyWrjUqinQGm3W1u0LqORv/rJF5URnIWbw9kEDvgC9y20vu/bjVFzJxCCqWFWFcU3aWgYD2+wi5mUdib0dP/HRzBedBiG3MRCSzc2cAEKAxkETB9xwasy0N0QRJR1nzbIzxckNNZPTn9WI1SU4Eah4y3ByFZu+xaL2gHMSlo35V00vAdiCW4ezILMcFWTvm0BoiebghHmOaN7raMuzPD38jTdYUlJsmBxglO+k32HnjsICoeOgB3db79YW7m0zFk8ECcgZIeWNcWG/W7s44fZJdIsk5baSWCc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YjBnSm9icWRxT0c4eSthS09WNGVWSjFPTTJ0UHZzdVRFalE5Zit2RnlwMk0z?=
 =?utf-8?B?alB4QWZiZks4NUdTdjQ1YUdROGVyamlGU2ptTlgxbkUwNjllalRLbWIrNklx?=
 =?utf-8?B?NS9rbWV6ZnovVTNOaFJtNjhKTU9ZbVdDQXYrUHBQZkJ1OFJJeVJuNWppTXFR?=
 =?utf-8?B?dUFuZEovWDBmdmV1ODMwemNtVmR2T25rQTd2WlVKNTNFeTBRblhXWlJLSXlP?=
 =?utf-8?B?YTZZWDJQOVdhb3NIa3phV2dkSitXSVhWMzNjZWVNUmNrQ2dJTlliLzFHS0Ur?=
 =?utf-8?B?Q1hYcmRXVDh6TUgyQ05jMmhDN2sreVF1TXZsNVFYazYxOE4zK3V4a3paaUpX?=
 =?utf-8?B?YVdzbExPOGM5Mk1hQ0VDc2RvKzkvMTRRT21VMjBSZUorZE52djBBTWJzUzM1?=
 =?utf-8?B?S2tQWE9YekRUWnlSNVlkNnpiTjhERXJ2UWxZWHJVOU5BTGYwMjE3cFBhOVpm?=
 =?utf-8?B?Vmc3SFZqZGpuaVlqOUE2RmNhaEpxMWlBbnZhVkFPZFlKejVVOG9aNThPcWlQ?=
 =?utf-8?B?UmcvaktYLzN0d2YrTkh2VFdoc3NHL1RKUStVS05zMk5yczRGVEJOdHF6dzVL?=
 =?utf-8?B?QTBvanR1cDhLNWNHRUNWbWxNV0hBc21WTi9LblBJRFJGd1JWbjl0aStiS3NX?=
 =?utf-8?B?M09JTjlWQ1dWcitpVDZYUVBSa3JLSWk2Z2FCRXJhMk1ITWJIcUNpaTZUbExN?=
 =?utf-8?B?dGwwOVJZN3dCYk5kcWpISzU2Q2tDRlliSVVSek12a0c0M0g5QTR6OWJmZG1H?=
 =?utf-8?B?ZGZ2RGZhaWxuWENEMnBmczJNWE1abVFXdU9oZkhINVM5T1IwcDU0Z3BQVVpv?=
 =?utf-8?B?UXV3WDFWS2EybTFIc0N1NW0wREdGNUlLcXl5RTRkRmNPdDJmM2NEZllmSVJ2?=
 =?utf-8?B?dnp0c21JaWF5TnBXQ1A3OXJZUmFzdWxoNHRFMXZvM08xOWtBVVFrLzV0ak9l?=
 =?utf-8?B?WHl0anJLdHl6aEpjVTJSQ1JWclovQUJvSytjTERmZGJ4NEdnVG9HS0VIVnA2?=
 =?utf-8?B?VCswYitlUFpKZ1dIeGR1WHJEakE5ZytyMldJbTQvUTliWVZCMGhGbkpYVlYw?=
 =?utf-8?B?SHBGVkk3bjdGajVEM3Z1Q21jSERIWmk4TVoyU0lRY1c1UWZ6eTh4Ujl2Tzc5?=
 =?utf-8?B?Vk16aHNXV2NBamN0c3lTdk02RFN2Sk94Wk1GQlBIbzJ3NDN4Ti8rZzdvTFFS?=
 =?utf-8?B?cW9QeG5UWDlhMnB6anNjMUpQWURHcVNJeFpUK2ppcEE3bGVCRWZWc2o4WjRS?=
 =?utf-8?B?d0hwODFXeXo5QzM0THFiK2xrbnZMR0E3dEp1OC9WQjlLdjdEcEcvQlNZczVT?=
 =?utf-8?B?ZEFzVmVIdHowbXA3a3lXNmF0eXJyNjE0ejByM2hBQy9UbWZidHN2bXY2MXk3?=
 =?utf-8?B?UGhyUnVNWEM5NVBqVTBQb1hycFRUZkU1Ri81NjJxTk5LRFBaOTU3WjREdUN0?=
 =?utf-8?B?M1ZHUzR4c3BzVW5pUFVKcEFMM1VzV2wyekFwdTNCa1hvaXNoM1VxOWk0QW5y?=
 =?utf-8?B?ZVVFQk1VdFNVd1VINGYvckt2ZGl5SHl6Q2tFb3BCMWszb3hERzVhb1V0aWw5?=
 =?utf-8?B?YXovU2toMldIY3E1TEpzQzZiRWxrb0dyMDRyTzJ3SzNPSklVN2dJUWRNc21S?=
 =?utf-8?B?QVFzbHorYlJiWCtIOUNYMFQ3UmZHOUMrQVA3RXluWlZTT1B5b091UE1KV3hh?=
 =?utf-8?B?RGR6Sk1iSTdkeDZ6OXdHRlFTZ3RMTGh5T09TQSs3SGd2WWc5Yjk1TEFYeHRy?=
 =?utf-8?B?OFlzWU1vMG9QbkRMd0JqSXEzVzhUczNreVVDL01jTlhzandkTnpOVHhkWUpn?=
 =?utf-8?B?WlVDbkovaUJCUTJBRUVlYnl0ZktxMUVqY0toR2xseVkxbGhoU2dXZnlZeStj?=
 =?utf-8?B?Tnp1dHEvMCtPUnlodS9tbWxGSlVwZE42V21SRG9MZVoxb2M4MkdDaEZhU2tN?=
 =?utf-8?B?VzdBSnRQbDhITVVPV0d3WjRUUFpsaGtlZjNLSUFZNjEvTVhHUzh6NGVHY01M?=
 =?utf-8?B?SDZQemFZSUpvVnNWeUp3eHZSbXQ4ZTd5VFEwaHQ4ZUg0cWlmRWJiSzF2MlF1?=
 =?utf-8?B?aEdiZFQ1end5RTA5UHAzR2NmNFlqM2tKZ1ovWStaajdzTHJQN2hKYllZSkll?=
 =?utf-8?B?T21GaXpic1VLSStHVExlRUF1SUdRNUlNeTcxcmI4SktBRGRkWTIyY29lc1U0?=
 =?utf-8?B?ZzRodWk1UlpGY0JsNExudFNjSUFnVlRjWlZIbHdaeGRwUkVmdFFMcFhjcnRw?=
 =?utf-8?B?ZEEySWoyOFJpdzJKd04xUytuSzQzQWthS3kvRjhNMzVxK1ZtRkwrMHloVjVV?=
 =?utf-8?B?SW81ZFlhbkx0NUlnRjNOdkpnMjJhR0RTZlFoOVFxdVlXYXFFWUxOVGFKZGpn?=
 =?utf-8?Q?Ly2LbMwO2YSDJIQI=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7b3a9e-0884-490c-3b20-08df187bca60
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:26.6063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ux51KURV5omtH4Ix2jhEQjEOx0r9knjwUe8ciRwDx2Tx28uszfN24IGnKaFIRcMQV2UIV4mLT1T5d406G/Ds7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

Document the UFS host controller on the NXP S32N79 SoC.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..b825fc1f5e25
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,49 @@
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
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+    };
-- 
2.43.0

