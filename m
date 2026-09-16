Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD547F796;
	Wed, 16 Sep 2026 08:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548291; cv=fail; b=j1/C8MfTbnqXC1x9Q7O2YHhzkApOqT5t4xcHAdSASlX5PCEHhjkU/Uox5lSbYSMhVGhtqA1rQgcv/iyPkYbuqm6pdulswUpNGAqgkznBQjCvk08/+/hdxfgf9zt9C7AR6DdrVdN86kyiW8AJ6FfHWS0BT9biFOKEDeVFqv0bNtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548291; c=relaxed/simple;
	bh=gnWreuaBBylEoDj0oB0zbMDcvSsm3SR78f+PDqMt87E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uNdR13/Pn0O29XTRTT+hSx0oSWnvMZRT0tNzKBa4YbqLXJkzeXN/McaZew020CvnCC5Or9gbi6AiKSzloQlH03nYERsDFO3qL9v54ux/gsBtoL7ssH33AszYoKD4V8CPQ+yJ0EEN//Vwnz0zBn1AGQhh0ZOMiNCGTkDpfxPKp4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=hHKV9six; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hHKV9six"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+RzIFEyUXOLKEl3k7UOnbyAA2dkZOjrh6GiN1OaCa7XulALimrgNE1K/fLUniiu8/tPHbb40uw1Iqw584LpXaiz0Av5DvxeoL824mJbitHUvh42z6azrbVIZ/WUwzSHFMCYsOdxKiS4rilPh6VUMpJSIALCbeXEZYM3h7QY0hl3IW8lP50IFlbKYqfoz8LuYFwurvYF/UigcN3Fs4YRIu2iNctY8jZxQbN7edD78X+65xLLjZvlCQvxoyajnLHqTnDzoIeKTw9zFdILz8CN6GL8cRSkmY2yU345PJwfIv7ukyF77Pqiwh5arVeoEnPDFsQ3TjsHozR1nMVeCPBoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ol5zfhGUpyogBezoZJFPqNYVQ2/vUfOC34G1gkvSYnc=;
 b=tb+XDWpzOOP8eb8Z4Db1xM33PH2Ct8sfF42d771LSZqnZq/9Io40QWdiG45bvHYYFC5ZYLO/zEuHMM8EcubPHL6FSOzPZTF9L404zf9cuzsg9S6JttKPZSmrXWuTbWXeSYhksZV2P220LhB9l0pe1o0egavydBcHaqiriHSQDZrDVPQaX5Ee2kTvpClE2nbF7SxE2ESc09vHmPHJp+lvLGFybvE34JG6crHxKDBvlnVyi2trRfxUbbSt7QXe10z8p08d+HXMXf7kQh+OsZEu0Hd8Lf39Kyo6DMfznRstJ6RQpGCwhw+CN7UTfk52/0QjBfGqcmzIXyu/QzRimMu1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol5zfhGUpyogBezoZJFPqNYVQ2/vUfOC34G1gkvSYnc=;
 b=hHKV9six5O73O7JvCBIA6nHKwe0KRfE0Xv4thWdZXcTRMVY6uxLOCq4c7cclVDpUtRIpL/h7kfwxeaB7fC6Cjf2pix45R5sCA4M/UOpDx6pnqp19ThnBAAt2gEJZoTqnOcNvjd3I3tvj9Ks+m1lTp1ufIsdaQJT66Jv86IkP4JJz9hoaatThkETGYSWU0qGzBYX7NL3qsOnnOEQ3ihSkD8gflBBntw84VjBg+YKCryEboYTuk5eBX8VXte9yHpcu54KYF1tHyOCzvS9lzEny5q8dUl9Ni8tGZwPShuSZlFoE4xGkyww9+DnhDRW5CnPUrSn8qAGF37HYZd+bRi9ZkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:28 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:28 +0000
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
	=?UTF-8?q?Pedro=20Sousa=20=C2=A0?= <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v3 06/10] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Wed, 16 Sep 2026 10:44:07 +0200
Message-ID: <20260916084411.941297-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DUZPR04MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: c6961a09-56eb-4465-7e5e-08df13ceb7fe
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Mj7ek8gMDTpqXs7YXchxYKPVcWOY8sk4815/fyKfjRlL1AJ3SuEYugk85zbUry9bn3gBxNyk5i+uFN20xF/vSgeWOjNkZdxbUjBBhvMB+ZygDOcb/hi9tn9AZ5ez7yyjV8+2hP+fnKTgtSEw2ZYLUsPx1+8wBnKapd/fePRs8jXILLNReWkKX3Ho2ACvnR8ON9YlpXShFfvsUC49HEhd0JEvU+BpF7Fv09na6incCfsSJaT/VCX8Oqejp6pwvHRV4YmZswxTMG8tRvWQsfB8E5i7/ikkIam4GFnj+IZJ4/MsXk3+XVrvWjpf3vCd+dkza9O61zsGGIDwoxBlQK/eaQvAy566hfAxpMR+yqzu+N8nc+xDVjT/xVf/Cr27Wt9oAfRDmw3A0l6j/AmfBQr7QUTS+lX8AJcxX59gsY0G0zQTxPA87udN2nziw6Yv7Nk+HFc5azKFKDOubYc1Mm7xjEqj3CLKCBoHb6JGZFgsA81jHOstND7ctsg/1yoTZXjLozZQIXV3osCIyRK3xgtsqP3zohuYWgjKGjWgqSLxi0615+FB+T+P4bFCTft9wo2s3X3b0aOhWJ+1htq74MFXizJjcT3yO4bbOFNi0r6FgK+xWu+xuCkZvYl/VvrR5x3s0m3dvpTuOUPvRKPDukH6z0xo100HRBsKyuq2RfussAA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WHFQNklkelhFanVKYjNzSkVvM3YyUWJ6R0dmbVRrb1kyWXJBalJSQ3hpNVBJ?=
 =?utf-8?B?b2dMOUJhVEZWYThHdkozcHJ3U21yUlhPcmtudEMxK3hITDFVa0tnUE5STlI1?=
 =?utf-8?B?NE8wTmFDOTd6RVpQZXhnWDNMSVBNbG9VRzVMYkExS3ZRaXFlTEtPVVFZSHJa?=
 =?utf-8?B?VDdGZ3RQaGQ0d3QvN3FQMUkvSk1haFdGRUU4QzNCZy9LTkpUN05BZVpwdlJO?=
 =?utf-8?B?a1NsQ2xEbkxrVFJHeDBvZllGdVRXT0ZyS0h6TlRzYTAra0dDQlR4M2ZIMk9n?=
 =?utf-8?B?bkwwdmgwb1RVZWxhRysxNEpBUlRWVUFNTTBCS21Rczg5NC81cElBbzJNY29Q?=
 =?utf-8?B?RzlFbU5OQ3RVcUpCYllBRmUzTnZOTDFQZnJWVmRlVWVZNnJMbG13ZmhZeGR3?=
 =?utf-8?B?YThmMTh0eVFFTXBKNHFJL0QzQVdYMmZjQXBhRDVRSThkVXIxb1VTaUpCN1Mr?=
 =?utf-8?B?YzF0ZXNNQW1tWHFzVk9rLytVb1VtRHJIL1JDQ0F2ei9TYkRKNGVrMDFqME15?=
 =?utf-8?B?YUdwQ1FzeGFIQ2lJRXQrSnVkRUVYWFFFOGFudVlDYnBKMmJmMVFocXAwOVJl?=
 =?utf-8?B?VG9QNnkxNTZpN3c1RDh6VUU4K2hvc1ZRMjBFWjBjT05UejhybUNya09vV21o?=
 =?utf-8?B?RDl1NWdFT3AvYWwvTG83aHQzWmJTMjJMcy9xVjJZSXpDSjFtYzNQV0hqUDNv?=
 =?utf-8?B?RU5GeStYTDg1RGJJelYzVWFFTXgzaWxBVFJyYVdQT2VGL01GUjJvZXIySVY5?=
 =?utf-8?B?V2ltL2FadERCQkNrbWpNSUdNVGdnYzNNU1pTdWUxRGV4S3NuRXJsUHBPa2J5?=
 =?utf-8?B?Q0cxT1JoK0tLZGxjV1hhWHN4ajByTG5zc3JXRkxTY2Y1aThwVGZ6eWhSMzVy?=
 =?utf-8?B?RjV4SDQ5OU9aRGZTdWkzUkdVbFdsdVpBalZldnVkSmdNajgwZlkzTGdmdDVG?=
 =?utf-8?B?c3BmZ0RJYU9QeVBzNVZsWWVxcGtGTzdJZ1lkSzlOTC9VMWNqS3grZDUyQlV3?=
 =?utf-8?B?dDBRMG02NzBHNUwwN3Fpc3hLR2dUWTkxSVllVTNxTkt5aFRaRDF6bjk0Slov?=
 =?utf-8?B?RnVRMThyZnpkbExlWXdITmFVNkxDeDZzWnlGZ21neGtIVVYyM01HN1lXWExP?=
 =?utf-8?B?UFJ1K3V0T3pJZFNTeWVpZXFnUkFtNFptbXFmdmlJRnRkNnhYNHdLQWVEcmdP?=
 =?utf-8?B?NkZSNTNaelNJNHROK1ZuOHlQSmxsNkdQeGZEZDBaRXZxZUp2S1czQUk0K1VG?=
 =?utf-8?B?LytOQXM5NTNBMjQ0QkhsZEU3WUhDZGUxSVJYbGVsaUtFenU5YnF5c241cmww?=
 =?utf-8?B?MGFtOGxKTXhISTEvU3JzYnZIeGdxbFZDQzh2dXVoem5wYzFaYXRnODRQb09x?=
 =?utf-8?B?Ky85YjdEM2dJTXpDWUJIbUpWNXZqR0lsdndNK3pIaTgzS05qazVkUmJqSU1n?=
 =?utf-8?B?eTl2TnliTDJ4TlZGUCtTODNiVWw5bHJoZTZlMUlwaHlDMWxsd1BkcWhUQ0c5?=
 =?utf-8?B?WDNCMzYxK2g3VEN6RHBjUFgvdGt3ODJjcnhYVkEzR20zcVZ1S2ZSaG5Td0NJ?=
 =?utf-8?B?NHBCb3k3Z1dxSmpuUVQrankySUNyakw4SndZYm01NXpXRlRTbE1kenhxN0ZP?=
 =?utf-8?B?RS9vL1ZXcjlUNWROTFFjaE9GYmFaejNDMlhWSWVaMW5EdDF0S1JoUUE4Mm5i?=
 =?utf-8?B?ZGFxQ1J3WERCRWFiK2MrbGZDcnhubE1BOGMzVzNKQlJHTHZ0NlRSMHJrOVdO?=
 =?utf-8?B?WXpRSFI1eDgrcFhXTU5LVyt5bGhHV0NWNTAzRGtzTnJaeXNPNEdvSTU3VnZm?=
 =?utf-8?B?dEtCakoyeHRPc0F5cXg3NDRNQW56SVJvek5ZWXloQ1NPR2JNeDdqdXRHR0NG?=
 =?utf-8?B?NmhSUTlITytabG14SXp2MHdobDhYYnBtZG8rY1Facmg1Z1h4bmdSTFNVc1VG?=
 =?utf-8?B?cTZWcWRCL3pUWkZSUGp3ZHpXY0tlajZsek5sUFE3ZlJJNWtJS2NiRjdjaEta?=
 =?utf-8?B?K1AyVFM5c3VEMnZuZTBkQ2RMWVFQWGI5YTdxbnd6QjVKM3JBYytmSjk4MFY3?=
 =?utf-8?B?Y0hncHJPeThlRzlnL1hnam5ZeGI4bFJLd2poWTZJQmc4OHU1alVXUFVlL1BM?=
 =?utf-8?B?ZkpKR3lSQ3k1N2tPRTRRNjFjdWdYN3pUMkFuL0kxQkVpQm9nanBZUStEYlBC?=
 =?utf-8?B?NzZtY2xhRDVid0xxNGZmbkdVRnNHN3ZJd0FVT3loYnJESFlMZ3ZYZHA2WmhI?=
 =?utf-8?B?enVNcks5QXdaWGFMMHlZYnpCY2ZWU0dmSEVMbkFzMEhocjlQMExlRlQ1WUMw?=
 =?utf-8?B?NHdQdGgrZDU1aFVSdks0NTVLK2R5b3c2b1Z3NEJlZXc0ZEJZSHNFZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6961a09-56eb-4465-7e5e-08df13ceb7fe
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:28.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EO/fhmPTlsvwYVUjDgdtQx5lBVLsNZJlVCmXR2pnGl5MRUqt2trBC9kTxgd90/q+BFLG+fn2OatCsT9cLxqtOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

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

