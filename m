Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA514ACC9A;
	Thu, 17 Sep 2026 09:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636581; cv=fail; b=ZwVk8aZEJhymNMjuIjxt2wVu+WIfCz9Mm64+wDZA305E1aPFcyZXpEMDvzhf0yuc2haARbJJKDfeKeE1kaoKjaoaIa9wQzFNvaC+XJsMhEVN4uVeSmmr7gVeLFtZQ32//KSoGPq9VoFqka7D8HJKanc6eAIgU65w75Nbj4pqOtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636581; c=relaxed/simple;
	bh=zr+FlxzSuTrS34aRVcIFRoSeuFp+4sqRqi9+RZaS848=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F9H8OC2VSbDvrJrbJTuPh+Fr3U9nVA3G6E7PmJrO6FKi9G9oJkJqSKIXOidjws62EGfUWy+XHwA/+hzURJ0OPqC9yfqBC0tf45REByfuaVqmeJamq2y6YCPZIwI4dYgrbjBo/jaPTTLZvut0pN10g37q994vUp6rpvvq4ftMZ0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=bj703NPm; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bj703NPm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWyinwxIAlyUAHpUhdp+XKAn8eWkktkGzdCRQdVXyhxC/ekPy7Q4aGhRM+m0XkzC/9M5HNe+U1Swozx1wtRkAuUhC2tswKDvMXj+3CEiXie9Moow2pdjQLrLu9iDssFnGVm7hQRK8CzHikcxpiQoSB+K0+Da8amPXl5jTEiwe15KcJhRYQP6afEs8b7QEXj07cIFKmKgnw2/R8vaGiYIac5bJwLDCXMEByLQ6aTybSnH5idf0ZCIEGzqv9bzaHCp5RWd7+r6xBK3QIQ45OGsKXqEJXKnSq2rJLU7/SmFFloSHeaA4bg8glxdLC0qPZzUIet8qRaLgDR9GgR7xcpKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4JF1xp4ezPN4HGnvUi+UwFwr6LRhMEgubsBq8Iq6LE=;
 b=tZ2f2PnN7FaCrlIXLfu1LTuPfIyBuPQfJlWN/M3/tdnRGGm8oDw8oU/9Fkai0iDlKCUR1aOOb3ms15jCm6fS6bZIkrHikg5TAKEnibDq3ApQZSj20ua7nF9+Y03oZdtD0IJZR4Ap23WmZrLH9GEDXUHIKJ+QkkP+gsTaj9m+rMQwsjuEGIQsINJeoJnafYAWlLfYuAmUtbYN2Goe6YKEKN9jgOKjz2coJGxU6AMeQCIPbs4ZNjLr73qVuyrZhXaPEZO07M4Janhtik5qRIPtXtT2GztmH7y+5oBYfxmozUpWlW5/owwQSEqf6PWSBCZqe7i2u4pkutjfiwNTtcPfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4JF1xp4ezPN4HGnvUi+UwFwr6LRhMEgubsBq8Iq6LE=;
 b=bj703NPmaDvF1y3dGbXR7ZgIqfq17XdZc5Tza52GxqA+eA3n2R8k4cW8W/NrNCV8beaKYiCbpoqmy20tDQZsNII2TKfmNc9JwNXte9uzUuWcK9GAcQwUSf2nKMFwc02iEJw5c3bdw8xXqHCdhrdSOCOTEvQaKBol+Fma7nxGY+vj4OVzZNW5uCwndoIe6O+KhTNXiNd4REGQJGE4C57a1yuQqi0+8TfgycwCBxJop5heqT2etA1g93cIokxVoe7l4RLaa6bxMeNVVDEcYlD94bVJVHTcT8wfa8Er6Zpb2LHhvva9eIcbFHEyTOGAjVdBegHvsR9CLoZO69V6PACDFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:11 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:11 +0000
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
Subject: [PATCH v4 07/11] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Thu, 17 Sep 2026 11:15:51 +0200
Message-ID: <20260917091555.1443076-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0148.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 61ecfbe5-fdfb-474a-7dcd-08df149c5103
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 IVFrHaChUCNWOtslVFE2GXU+n87RqZeAjqw87n1Oy9SRb277Nn+Ve6RDyNyR7oyROwsElJpDBvsBMuAf/HZhh7ulaHuF3/x+fHrf7B6Tb1fsX6dOI6ubhRiLwPBK7G705zBVIoUZvOgw4NPMD0pfshni28dD5UchWVTMtuFrF+WJ0XzZ4sDhjILQTVFWuoDu8s/Ri1on3d0ViZrPVdRqAhHVv7/OIsCPuuP5GkdJFcZtKmTQ4g4PxcI613dbQGtrKQl/2DYg6jR9z0/n1pFpcYTc5NaRvTBK+oCMx0EWL/o6UryCzw+34IzExLSLNtdlLYr3EqkHwZNuAOnRl0kaCfq/IvO20elq8Epwmul0ZoDZZEjhcbPuK4m3bhYCZLuoMk8fVPXnPtRrA/zFABw5Xx4cL3GdZxPXcGKTTGo/BB/+GEODOMxsoao//gAHXWmsfMMpIhwajwZq8w5qcYuxl9c8VjTWAEGvOQfH05CQOoJA+JYqwOktko1j2oW0Wp4a0ByTSOI04+buDIiWC9NXIp7bSDyuACRoEY8sNbgddQPkR2cWllIqkDWtlaMDRPYQaLbgZkafYR5TzTZ9ByEcJ48W1lfM12lzbhuQ6ZdCgU5CKZCJyaynDaatMlNeK143VoyhSYjQZmycHvV7iRXXeN2bgv+oiTa/eYqlvq55dvA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?K2RNSGhNdE0rdVJXU0NOK1NCeUZoWXZvdTB3Ym9GNG54TFBCUDVMT2dGVTdR?=
 =?utf-8?B?NC9MNUI2Y1pTM3NQNFduWEZzM1RoaE4yVWdQWjBZTGZ0SUkzUkhWRk1SMTJE?=
 =?utf-8?B?VnJGbVZGdEg0cTlLd0VVaG83MWhnV2pib2diNlVOejBiV0QvNER5UUhHM00z?=
 =?utf-8?B?ZnpCOXkvcmhndDliYTRtTHVlbkN2TENTcWY5eGpyd0FYVUlhRkExT0I5aldP?=
 =?utf-8?B?ZmFTbGdLZHNOR3QrU24rTEdOcm5LZ01ZVkhML01nclFJeUhNNXBxZ1pMNk5I?=
 =?utf-8?B?NU9xYmxHbmZqQ2pMNndCUTNqWW5tUHZFb3JBeFNpVElrd2hhL3A4Mk81bVNj?=
 =?utf-8?B?T2VtSmNCc05zb1JVR2RvL3RvU05hQXphUDVsS25iVUFUQVljUWhjRWl5eEoz?=
 =?utf-8?B?SmxOTDdXMjc4aWw0MlRxNDdWdmNEekRLT1Z5WTNHb1BlM1ExWEcxT3BUMXN1?=
 =?utf-8?B?dTZRMFhMcWo2T2xSV203NW42dUFERWVQejBlY3IwQlRNTlRpSkY0MXlJOHI5?=
 =?utf-8?B?a1VXVFIxR0NHcmhXMDZYenQ3ZGpCeVYvQ3dBUzZSbjhvVHFBcllSREVjejJL?=
 =?utf-8?B?Q1dMcmcrNU5QMmVnVlpURFo1bkVsQW5JVXhkeWwzZGJTbGdnVG5JMEZtK1NV?=
 =?utf-8?B?Mmx5ZGpZTTNaQ2NjOUYweUhOTUt6cW8vZFM4WC9veEJsdHRTUEJCaUtLVlBP?=
 =?utf-8?B?Mm14RUJmS0x6dFkzQlN0ZG04bmg1bzNhRklBVElSQVJTR1l1N2xUOE5qa0dB?=
 =?utf-8?B?K09xM1hoZ09LZkI5bVI0SzhoUTJwUElGMDZ0RFBvczE1ZVA1eUpRNVFzQXVp?=
 =?utf-8?B?MUo1RStYUXhXRXlrbVpESy9xTEFnS3NVN2hHUTh4dVkzbGZPWnhDd1k1ZGhI?=
 =?utf-8?B?SUZBY1h6eTdXcWxYMUwyc1lVQS83MGplMjRWRjUvK1k5U0lKVDhFTDM4c09Y?=
 =?utf-8?B?djFuWEFoRGM2ZTZZTThPb0tmYnZ1QW1ZdzZESnFIZGZUOU5NTFhGR1BXdUEy?=
 =?utf-8?B?dDA4Uk9lNFpEdjZ1N1N6L2hMVFZ6OGxJQjJNaFZjVlRnT1dnOWppY0VzZkRP?=
 =?utf-8?B?REUrcXRFVkFhVHhkR1VBNzladnhRVTVqaFdGUDFRd0QrQlh3U3pJTzRlS1lC?=
 =?utf-8?B?VUNqYmhZVXRFaTJWaU9MLzJnaXlQU2djWUVVT0tDNXRKWUgwUUJ2Z29lMnBs?=
 =?utf-8?B?aHN5SHJ0SFFkNWw4RnZuWUdRMDdobHNSajdrcitOZk9EKytKM01lWDV4TWZD?=
 =?utf-8?B?Q2hlWG03UDhJMXY4V0s4LzBTU3lvdGRqSjR6dVQxNm14R09ydnd4clB0Q0Fn?=
 =?utf-8?B?d0RyYXNSR296UDBzdmlMT3J1RnFQbkNiWEJtZ3o1ZWdTKzNDdktXanhvV2F1?=
 =?utf-8?B?aHFmcE9VNmZ2NWcxT1ZkRmJ6bExOY294bEJBVi9kRG1oeGhucWw4clpTbXRD?=
 =?utf-8?B?UnJiNXhJSHBqUHo4ck5Bb21id1kxYzV1RUlCOWpSOGMrSW51TGhHK1ovV1Ja?=
 =?utf-8?B?R2JNSllsek5MNzAvQXR4a3NwL2RIS0FSdjRpemsxdURER0pkMXRvbnBGOTMv?=
 =?utf-8?B?SjNxdkFoWENydGVtTXl4L0FXNjdrZXFCYmJSZEQ1Ri8wRHE5YStzQVpxTUNL?=
 =?utf-8?B?anB5dzVGUzM4UWtSSmtmUC9Nd2hSSFV2aGdsWWlDTXlxdjJDMFMwdFhrR3ZD?=
 =?utf-8?B?dFB0R3pQTUpCbENCUmphbndidVczMzF3NnVKZU9MSkVMUEZ4cmh0STlDV2RX?=
 =?utf-8?B?VG5QRFcyWGNzaG5NeHFEZXh6MEFMb0FEYVliYnNydzZ0VnRTb1lIWkNlWHp6?=
 =?utf-8?B?VmJpczlwWnYrM3JHTTlJcHJvY2dJdVYwK2hib0dmUW1SV3h5dUJVb3dwb2Vn?=
 =?utf-8?B?ZndsN0VCOXQ3L3V2SEpjOE11OEhyaWNPcXBzWjN3aVRMWmt3K29oVUNZOWl4?=
 =?utf-8?B?VG9VSG45NHBQV0FKb0JDVnp1OTBrMGRnZGQwNFR4WEZDRytZQy9UZHk0Q0xv?=
 =?utf-8?B?YVEyYW9oZnZBZVBsY3RFS2RNWEVGc2YzNVhxL2xmeUxWNzNYdHBWUm1GeDlW?=
 =?utf-8?B?cDdsOUJtOUlPYkF5TW04TTNpNGRJdHArVFlEYjI3RTJaUm1jb0FndlRtZm5n?=
 =?utf-8?B?bDVhTWRaNklxZFhNOTRaQ1FMdjYwbDZuRWtUMUQxdE01bTZSS29DR0loOU5T?=
 =?utf-8?B?YUlBbVBSeGltVE1mNG0xcXVhMlNBZDkwZ0U5R2Q5WGo0VjNnbkI2SFI3N1NR?=
 =?utf-8?B?N1R4c1o5OFNlTzBYbGpXZW9kM0lZQmhCT043YlVIaXoxWEp5QStpamZ0ckZC?=
 =?utf-8?B?RXJUSDBETWFhM0dhdEhBcEdveVE4WVVqRElkTDhFem1PYUdrRXZ6SHBBcndr?=
 =?utf-8?Q?u/Aduba8bJWdCMzE=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ecfbe5-fdfb-474a-7dcd-08df149c5103
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:11.7506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Babk68mge0ZTdeOf4RFe8V5fCKI21z7Da67Q3/rp4Ea9paUX58aeHOoWoLPy3QJqt6mLbz8yut3t2i3T0EJftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

Document the UFS host controller on the NXP S32N79 SoC.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
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

