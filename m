Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2393C3787;
	Tue, 29 Sep 2026 10:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676658; cv=fail; b=TeKieEmkAVsx1DTNW74/vvwvH2CrC+F4+vNLjCRMDZT4N50cNpWrxBKzI+rDdF7P5vfQzA6HEQPsiHkvWC/gTli2p3/AgNGoFEDW3xGYLbkta9MzhRblK89EYURK8fNlQfmdRKWBUZKcra3fDJrWlggdJUWNbETsMOabBQS2BMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676658; c=relaxed/simple;
	bh=uVrTTrPr414e6eCXD7ChBsPh5v+5ucfHvnPCy6T4XOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m0re3HDJfA+rGMg2nRCQ7JGBju9XmEx6NEgRQRgAu4WoEltdqVjGJFzS0Zvf5kmLxIXU2bw6WapoTRzXEUAU51svZ+GfhdDtWirbSkXy5S6BISuCI5GVUqtm6S+KEhJyA7RnX6gVsFNGwePzZkpjad2CAv50eI0WvNqqfv5NJpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=O6Tm714W; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="O6Tm714W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlssFIxf2MtHtgvGzXISeGqbS2KtXsX7wMviUpYte+7kKSSYxbgZEz+kZ0bn4s32Y0cstCWWFbJ05YIB0TRx5xcw94YD9Gxv2Vip92GXm49gaRh6HKgUn4IaO/VFW4gWKu5B3my8E8tlreSnbT4v6C7ha1aqfEvgk2eGlN823ij+hQQMKwS7gpAApiQ8W78nj++1ZNVwgRG3u13LOMXHNVfk7VKgYAiJx2A/g4ChR+gsx4mi0HUDE5jLViS3ArEmq4lsoZtOT+6+ayaPJ0pTNm/qytcR24z6DEIcCWbjn0qfnP6YAgvHJ7kVIVe5mtOdcurATgKEur4EgWMfomMkjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmgkbTZp3m87r7igMrrrqQgkTA/6SC9yrA07BiRGFpU=;
 b=gtF2+kxpOjg5ZzwpkMJx/FCleM7RyitHNz6QDds/b8ZOG5WDxLO7+JbNPffusgegVnalbwA1y2w+lqbTU69OWtOUN8aDetEKuHfs8YBjD60D6LjdV/zDo2VTW7/W79EepLonykiVFucxnvcOAIBOYEFM7plWEVydcmc2jH7SzyE3Uf6uZRfVY42xp8S6rJ4wznUVwkR4vT6iidkytWs2PSakzUxUz9US04OSdRQrEQezrtIK9JBtcQja9ytR8d2ZGbcw18LHC15YEBn1R4n4KS1mVHr+f1EB+fHkY30ngI4YvbHmIq7FCVjpFMrps3MR9eU+fjxyxFXvqLOAHQ+51Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmgkbTZp3m87r7igMrrrqQgkTA/6SC9yrA07BiRGFpU=;
 b=O6Tm714Wbft1kSXk8w/GnpWlV9St54AuAwDb26EbZacDcNV3dewZovLME+ZT5cDXuqkc9DkrjJQP4hpG/nTbeQRhO4Da3UhcNUv6hg3dRIByFigW7l1nly7fSs4f3rkVVhEr6qYAjQZYlHPRo2j/oouGrpxWPQb3p2G6bu0X87fFJQNyjF5EHQqFUyHU2Rc83/zHVEdGtLIBJNySsiQCtICUuMv4aKVZnEWMDlzMi6sM2pWDH7QNwSqFkT5vOvJhLk38XPQakmR4YT8j+6Dx8cmYddvRfWyS3FG81efBO9+lRnMGs2sPWflYP0dQ3cQOS3khAsKjRL9Zm/JWtNT6WQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:13 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:13 +0000
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
	echanude@redhat.com,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v7 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Tue, 29 Sep 2026 12:09:41 +0200
Message-ID: <20260929100946.693962-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0024.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI2PR04MB10595:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bdefbcd-5cf9-42c5-3ef1-08df1e11da49
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 AMj2WsRK5cWuRXptE5l1vA5u7g36ehZ7nf3E64yOqultXFtIAaWORXQrSSRpqyKhDhysyzVtrADWo8WOXuGc5qCV0wGAhgLAL0K3lDnHryIqYO8YL9ZlK4TAXjbr45vhpJPQzcyBc0kgGM+/h1Fq3XVsrTq3ILrJ2J6z7XBgUHRtAwqCia2Fjyz7WW1JXQ57HU798l1j3pAkq4DrQmkCDk12y6f2wtCw/VIbwcDW4NwNlXGg0lNY2NaVOx5Myy9L2wAJ7/ol7IzroEw3VYzuP9JuEnufsqHLmr25cho3ekzfwk34b+AbQT5JjMik13s3eWcc+ADW3/uNSaCYEo6jXRZtywOxYKysl46+0vkdywxwI33+bNexJ50Gxd7Rje79LiwbvSX2VOQTyHlI/AthXUasB5eQRBX1gklXcJYcvLgXpQsEnN2jE92qBB86R1exk7psh2jHp+kGZ56CidUb0hzNj8MH6oeKKTlxvI5AqHqqaC5Vt9+JlVwLxhY5GHAQm+RSqU7EHmW5wUKyNXDx9lMfZhDKp6zylXfd229AdB22vcRqajkVnqyyNy53WRmUQW1+0NziKm7gfFhXUMVNW7GDZZRRf+AfDa5EUcBsMqgQ27xhdD6rhtjcHFLa9XyMh9KsQKxEHU2H9AqdyTq6gfO7Wmkd7VzxzKNEYr5uBLk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eWJVMzI1VmZWRVozRkNrSWp0cW5PYTUzb1ZuTHQ5aVV3blhBYVFnZE5LTUFK?=
 =?utf-8?B?OWlTL1pYSXhBTjdCemg0NTRhN3BGeWJEcGlUTUpIaEw3Uno3UG1UejRTck41?=
 =?utf-8?B?Skt0dDU2amgwU0ZwNW1pVWtQS1FMSUxYTzZJWlgvZkIzSUpqek1nS2ZzU3ZO?=
 =?utf-8?B?TWtFd3p2Z2E5cENIZ21MaUM4Um8zREJPOFNmL0lUd1lvdWRnTjB6N0kvckZh?=
 =?utf-8?B?UC9CVFdlMVBuQmxsMmlmLzZFc1BidGRHREM5MTRyTlo3WktuNTNUWlBnUlZ0?=
 =?utf-8?B?QUlDa0kxVGlKUUM5UkZvbk9iNS9NcElMSUFZQmtOTUxNTUJ3NnBmU1RGREtH?=
 =?utf-8?B?cnYxVXhvb3l2MFlDSkRyZjdSVUNoc1FTdWRNYTFTWGlaOW00WDNKN2VjS3VI?=
 =?utf-8?B?dHNzdjNYRnU5RXRCU2c2NlZER1dEMVl1eUluZlRwTzQ1L2tzeXV1dU5QS0M1?=
 =?utf-8?B?NjJUaERNU2tRUGoxNjRHYzRwWkRPR0pPdTV2eHdRc0hvcHNiY0wwcVY1OEgz?=
 =?utf-8?B?S0xuUVg0VmRDUG9qdkgwcW5hbXcwODFKMW9QZ0hoY1lGZ3VseS9BOUQwS25r?=
 =?utf-8?B?UVZjb0Q4VW5UYmMyTEpjbjdSSWNmaERNQXVrWVlWWnlpZkkxbzhGZjdzZzNm?=
 =?utf-8?B?QWw3WmxwZDM3WnFJT0tQSlVJdjF2TVE1SzJsQjVtcmZRd29QZjJabU56SlMr?=
 =?utf-8?B?VnFIN2Mrb1drRDYzc2laQnV0Y3ZnWDRBeEs0WERWTkxSNXBhMjZXcmZCT2t4?=
 =?utf-8?B?bS9DaUZ2MmlibGptMDJFN29wTjZ3Z0pnUlFKNXZ6N2ZoQkxYOGYxSHlITStx?=
 =?utf-8?B?bjlMY3Z1Q3YvY2tScHl1WjJZRUpjUDQyM2xKdjlRNzdham54N0VOcWVpdU15?=
 =?utf-8?B?TlVSRUsxMUZRb3I5RTFjSWtmdzNzU3pBODB4cWdnUFJDWXloQUJyWGlKWG1D?=
 =?utf-8?B?dGxJdnFsVzVyVXFvQzlSMmNSVUx6SytKV0kvbXBZcmsyRzJDYzIrd3BuV3Q1?=
 =?utf-8?B?SU92ZUZQNnVWSGhBTmR6NEZNaENMRHRleEN5OGRZOXNtdER0QmtTcVZ1bklV?=
 =?utf-8?B?UjQycDN0L0FKS0FobUcwaUxlejN3V2RVeDVWa1ArT2NFWlozVkE2aUlDOCt2?=
 =?utf-8?B?STNLaWQ1bUJHV3lGR1FkSXh5aG5zMVZ4WHlDMmMxMlFwbkMyTTM5ZVpMQXBE?=
 =?utf-8?B?OXJ2bm5oME1iZER4cjU3Q1hOUy9xMzdwSkVVMVk4VWQ0SkszNXVrMy9mMGVj?=
 =?utf-8?B?MWo5YlM0OXVOYlpEOXF6Vjl0cW9wSG85Z0dGdlBOZGp3Q1l4WStEOFErY3pJ?=
 =?utf-8?B?ZWxzR0kyZS9PWHdBZkJZbUNJZTFzOFBkT0FiTXBEWWtidzF5Z01rdkJWM3F2?=
 =?utf-8?B?eUtzLzhneFJTN0h3Z1NoaW9lMlRFZ3lYVWVQK3pyZzR0Q2dGM2g4MCtEbnoz?=
 =?utf-8?B?eUxXZlRML3E0NmtBUzdBb0NISlRDZlRERThQVS9ycmhOZ1d2a0c3STBOMlhM?=
 =?utf-8?B?WUhGREd0M1lzSWpRczRJRzhNamovYkNFMVN0SVZkVzhoN0dGd2h0dWJoNjhp?=
 =?utf-8?B?bnZaL29RUStaa0ZEVVNjWmpyK1pSTHVIajJwSmZFTkdEWFZuUVlEdUZzUDlM?=
 =?utf-8?B?Z2NaL0NFRlMxancyM2hmZnBGam5Eb0ZkRjhXZU5HbnFEMUQvNHlxQloxcEhS?=
 =?utf-8?B?VUJzQ2RTT29ocm5PQXFsWDgvUzhsbVBQNTNOdmZYOFgva2p4REljeEhuTlRB?=
 =?utf-8?B?eUJqRVMzb0M1Y3h4Q1drazRsR1lONHlXc1FlNWp5UU1tUk1EZlJlZDBlUXdN?=
 =?utf-8?B?aVQ2V051VHBFSWZUd2VwN3hMWGg2U29qV3dIMndYUjlaVS9tSUk1NXhoOUtS?=
 =?utf-8?B?ZlhtRXRrMFdMYUNkWnN4cHNOS2w1Qk4wSjlrQXg3aGJudllLQWkwUEF5NUI3?=
 =?utf-8?B?UEc3N2xtNVlBZnNsbzM4VDY1dzBncEhpSlZaamhVN2JBYTdHaFpSNEtiV2RN?=
 =?utf-8?B?bFZxdlJISWNCQTVmL25RNnp4U3FiTlNPcE9ZWDQ0aDFqSjE5eXdabkhmcFFN?=
 =?utf-8?B?QXk2bjFVWjhBY0tOcHBwWEJjMzRhM0ttWEFkQ0w5akhKSU9SZFJGSGd4UjQz?=
 =?utf-8?B?amFGZzByQmUza2x6SVorbWc5SlRqNGloaVFxaWthNTIzcVVOU2NqbCtWOWpE?=
 =?utf-8?B?VTRRVUNBNERQbkhNd0c2WFh6MkVyZ20wTWtraWtkN04wS2VkVkZaelp5ajFB?=
 =?utf-8?B?OCtoc2V1VWZpUVdJOE1RUm9nRnozYUU2MGdyK25SbkJMTXNlYWNOVkRxY3JX?=
 =?utf-8?B?WHFCaGlVdUNvQ05INEs1WUs3K3I5Ry9XMTB6Z3ZFQXc0emVqeTFRdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdefbcd-5cf9-42c5-3ef1-08df1e11da49
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:13.6536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+g45PElhClrVrVJknb1gS2TVYT+sZ/k9H+e76UnVvkNL+F6qsx3JV5wS6a8LdLUkLYM4+bXf1AVSIAEs1U02A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

Document the UFS host controller on the NXP S32N79 SoC.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
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

