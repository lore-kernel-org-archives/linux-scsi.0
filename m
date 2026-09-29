Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78990502D62;
	Tue, 29 Sep 2026 10:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676644; cv=fail; b=dOIsPP6pP7ueDkLmKMTLmFGTupU9Y1dcbDwaHlmj678i4gT1weacPXqlCOEfOvOjrFduT+Ub20eWyDGaAUWPB/AzF5rrjqW5B0S9jQIZfYI5nncOtWhx43S3hz6NrnSL2eQNgQbzqwgQv4BsBRTeF6UEo2tUrGI/kbIt3ejMtc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676644; c=relaxed/simple;
	bh=4NiE8tq9I4+KkmCkCSUHh9s1MZ2/o+fYsMro5apuCVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dbsQCoqoTvzv4JA9D5i3B/m+anD/ZWGyyVoAM9E1qtzgTcv5rd4W3zdWSfpfsAcwRWgiH8zG4udRddwhmLGKbF/zyav7JAVBf5ZDbOIVUn2/XstUqzhNw/YvkRpG2RDBzti9+mF+IY769C7UyNIdN8KnJq51HM06zZyJCMboe94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=B8P/uXcm; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="B8P/uXcm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECTjawVgANM3l1z3I9AJXBzATInH1Pd4cjZBy9kNrmEgkayfMMSRUCQHl0qNTqBFVYE7egbNYlXHg3F7skOAZZMUjSLEnOAerNpMoGUjYDH9N/OPMrmQ1B9dNflTD95/ZMU17fEOdMdwowuAOhD1hK6EeTTvfCX5gtK06/i342wppiHkCKwKRrhxLmMqwD3VL7QPzpjwuSe41HqWXCAUSAgKEFIQAKHhQUCn++7ZtOaBGZL8JlcuPctnyZkeDIYpZfFRQM0YnByJmXuhYpsiXFq89SWuHept2O/bTEbyXcOS+/ha+w8VrAt4XqhABrfGHOg66NtYrrjnkJbHl97zOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=VUBdNPHPVFfCFqnc9/SMkVoTWCeQ6k6f0n5KcH0ziDdKZ5Y69zQUSCgtaZThA8+VGy8bMTxC5eFrfEaGLsZgeesD1LRWoO8W5Rt0zIEIYd648bm2f9c034wnE3j0ZRwdvRrRyExcrCffIU2jGTOZLn9xrntl1AOQgKNJBSN8SgIYqGNq4iVbqgPabaKEljrO1K+NwbbXKop8geIoob4B7MqLXVioB2wREM+/DFWur/5Ww2MNbhLFMOjGh/D9yeYiNm3VOJ4I8CAoCwqx8KAok3KEa+UVsherNo8LR3Hl5HVbbFjeIquiRCkEUTjkor+M7LH59zERccNcMNMziQml0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=B8P/uXcmht9OcqJIFS5BsacVUNBC7yYQdREzFvH/9rAoEhftAdwBdn3oN70Y3JgKr+R1ciWqEgz9Kb2FohL1+b8KVBeL2Wl1BdxRIP/OB/y1DL54dVXFvxtBOk4jrU+8ivNYzVNH9Kv+CbgfcFpK4SK5LHuhoo+/iCyUC1vDKsn4O0ZTv27pONsCivCDOPgEiurWEjxl8EgHBTFQscAvfVC5d/FLidbILQo1oNhK2Sj5vYTJrl5Cfx+doMwAlbn2nLbdiSVk1jldSXn5+H0kLSBRU88XuUzHW5A64z4XZNRCoL4KgfZIC4SZ6K/1N18nqypu9+FrQByYdekyVKgyqg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:05 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:05 +0000
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
Subject: [PATCH v7 05/12] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Tue, 29 Sep 2026 12:09:39 +0200
Message-ID: <20260929100946.693962-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: b1317198-5ac3-42ab-7736-08df1e11d51d
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 4NWhJ9WBlOsUmN/tpTIWLVo+JXXiduXIZtzrRwMR/THlH59K93Dp1aODVz2Zh7BIXslH6P5PBmAl36V0ShnKUWsH28EXA3kpSwQFaurRqcMNabDOzVj0thL/0j5brQRMBwvOkBxkHGCEkTuhpLHgZrcB7QHSsv6zYbaxtYC/W2W0/iFgGplsAVNYj1VYaSs4CloRoLW4aEbo1F1Ji0vnnk+g1HFY9/rVW7dObPcw7VIHAg60iDIC9plC18kgtGM2sLpeQ7vVvjmIP0U/8NCy6f1WWgoPH7WBpIyBoqjePT1VZ0vtzT6rvYjJ8Xz2GaE38FtvUsP3K/l323M/Don0v70bmb1wXJjRf5uSWq7bgBxMG6HHhvM2+d7udzPL0vrGdzuaYq/U8rSlwTmJhZU7nPsJ1laTFSdOYIq/sYmaDTEv7shzfQ+IbA+CkYfwWQo0KEmGrE1sa3ZhOPCnVX7mqiPC65mvLJT8QWaQJCuGxA2uzKq0VLP6Wi4K2voRdtTAaON8HVvUDufdASScgJ+KZEOP/8DVO8SzAp8QAitmSwvkEnP7ZazYtYPoVJzDSNF1G9UKhyN0xpTZJtJ543YgYlmRlzoD/M7mqvM1Mg8TQYhzVoNHemIscfuvBCJ2ZlryOnbv8gbN66N1T9hqT3mrmx+/9w4f7omzcCvM95hQ45cDG7vZmwx5cmBt8wOmeaJ/vPE/jMjHeevGjnMvW8lISA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?a2lxaFRCSjc1RThPRjRNdlhRa1V5Ulk4dXI3SFpUZlJuS0JNZms0dnZpdDVB?=
 =?utf-8?B?SStHZHVvNCt3U1ZBdXNnNUo1UXgyNDByQVRZSkdnYUhZTDAzVnkybWwyK0Q1?=
 =?utf-8?B?VVhhMmNMeEJ0ZDJHMnl3Q080TlFRUmlrTHlUYjFxbjNpTHU0QXNGZ3B2aXow?=
 =?utf-8?B?QmY4TTY2ZGNPcE5YMmN1alVLSkYwMzFNL3laMzVjei9lajRFay9ZQ2k3ZjZP?=
 =?utf-8?B?WXllU1MxWXJYeDVqdklHUGlOVnE2Z0xOOUdHbVRabi9GaEpqeVVxMUZiWUhu?=
 =?utf-8?B?bkFmb0p0dDFDQWpzdy9pUDhJWkJvNzNiK3pLU1dPL0NyMjBRRG1jVUQ3Zll6?=
 =?utf-8?B?MHNTcEZ6Q1dnTTZIbHMxd1VyVGw0UE95Q1d1M254REkwcmZBWXBjVnE3Y0tB?=
 =?utf-8?B?RUwvQ2o2UkRyY2dUNlpZMG4vVFNJaXBSUjAyWWRtZVVHa3ZXOURuN3FQcnZ5?=
 =?utf-8?B?L1VQcHJBb214M2VDYkwySlY0dVhhQ2RYaldyQ3NFa2hzUEVIVDdOUTBBNFVS?=
 =?utf-8?B?d0dNWTZ4NU4wQnUwbC84eXZrL01QamUvcURqY1hUbkJuNFhIZU1JS2RiSUg4?=
 =?utf-8?B?dGtYbzdrTDRwbUx4MFNoZThVRFNNZmxOVThQdVdpQU5ZQ2R4WTZGYUppSGMz?=
 =?utf-8?B?Z1oyN3BEREg3am4vRHNaMTJEK2V2RDZad1c5VmRaV2tnZUpaN1ZZTnRmOE9N?=
 =?utf-8?B?TmVSMm9DL3F6RVpFZzRjbGVSb296ZC8zVWl2bGhyUlJmeEM1Y1hkMWlGdjBE?=
 =?utf-8?B?akhTeXNQOG5MZ0pLMy81aXdIMk0vV2VzR2U2MEZZd3ErKzFoTThWZUZGc1Jj?=
 =?utf-8?B?L1NFVTlNcXdrZTAxYzk4QmRsYTFsdkhOTEc2bmp6TEpYNmZtWDZSMGFXRlBZ?=
 =?utf-8?B?V2daYjhVNkZMMWlKb0dhbkxQUC82Q1VsWURhc21sNFJLS3JQTWhzUHVidTF2?=
 =?utf-8?B?TUZSZ2Z2bllmdjVKbHlacTMwSzJnNnNLSlZCKy8rdmpyVTN6YitwK3JGd1NF?=
 =?utf-8?B?V1FReWg2dnQvR09USlNKTzR1d1BsRTZjbVM4YUdtVzNDeFNDQ0k2YWdocURw?=
 =?utf-8?B?aW54Mld5TFFLY2xFQlM2cVJ2b0VqMmRyeDZaQmp5bFArclBGWklHVkpBVElO?=
 =?utf-8?B?Ry9UVkQrR2pWa0tJcTY3UzFmdUhvWW9vYkdrOGNNcDE2WjdUTXowblE3Vmpl?=
 =?utf-8?B?QzJhM0lhRFlocmJpYVU1UkNiakJTbFAyY1hxcVhjanhjakZieGozcGVOUjhH?=
 =?utf-8?B?RllIVDVhMEsyUWhmNEw1WTg3VHZUSnN6TE04eHNqRXV5Wk5udVhrVUpURjJH?=
 =?utf-8?B?UWV3WndXYWlDc3FxVGlISUpQaHYxV284Z2xKTEpZMVdRdUw0YzZmemo5b09l?=
 =?utf-8?B?UWpWYUl4dEZiWkFlNkJZcU8zb0dPdU9OR0xJNVhvaHBhSXhONzJLZEs0VFpX?=
 =?utf-8?B?Q1lHN0RCNEpvbjFZOHUzSU1EVUtDaU01NUVQSVBKdWkrYXZrMkNmd3cvZmFa?=
 =?utf-8?B?UStHSWpMNzJ6NUNpYUJtNU5XSFNkb3NYdmEvYmtPQytoZFZaN0UzK3hPZFRj?=
 =?utf-8?B?MEdicU9GZHp6THlXL1YyYWxMMDFjb0l3Rm9rZUpidGwwTjlqelhLc2tadjFW?=
 =?utf-8?B?Z1VORklXd21UNXZ4aWNaYjFrU2EwanVpVE0wb1RXRGRBK0R5TC9QN0c5VUJm?=
 =?utf-8?B?VGw1UjgwUGNPdFdYd2thNmVRcWlQdzFvVlYyTDZJV2lMUCtTemJwR0k5Y29Q?=
 =?utf-8?B?RkdRNVlaeUdLMVVNTy80UVBUNUMrZk1PMTZsajVRYXJzaTliL2JQcHVLa1BU?=
 =?utf-8?B?MDVkamcvUnlzakJvRFoxd29ZRGtOK1l5SW5DZERPRzcvOWl4VkNqNXlVa2ZP?=
 =?utf-8?B?WEp1Vzhvd0p5ZHBQV2ZGR3dNQ2Nja1NHc21maHg0UHVVUUVnN2t6VGF1QzlP?=
 =?utf-8?B?STR6dUQ2MU1SN3JWVFBTWllqbHZJcHkzb3F1OG5rbHA1N0VaRlcrTUN4U2tV?=
 =?utf-8?B?aVRCV2dZcjk4dWNCQVE5T2s0Y0UvbHZmQ3ZQbDZmV0lQWEhjU3ZHT0RKK2Zj?=
 =?utf-8?B?SWlXOWdLYW1nSDVLOGoyYktBQkl6QXFyNVhJMVpwUGhlbmRudU14cEhmajFx?=
 =?utf-8?B?MzlyeWFwR201NWhPLzZHd1pSM1kxWkw3dVdQTStkR3ZqM3lpVDJrL0FiTDVU?=
 =?utf-8?B?R1RvbFM0VVg5N3ZjVXF1ZloweTR6NUZxT1JGVTZsNXU4aEdDbmNxeUd2a2VQ?=
 =?utf-8?B?d1BEVS9iUlloNGZSMU42alFZZmZWQTVxVmczcDMvYXpJbUpEalZhZE9yZnhK?=
 =?utf-8?B?SjNYSVlrNnpwK0hkUmR2WWhWbzkxSlNtWnFvOXpKaGNjeTZJTWtZUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1317198-5ac3-42ab-7736-08df1e11d51d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:04.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPOjjoWAVxVBQTu/BvCZzCmo0CkE1IqZKkTLZoF4F1O/ZnJk9SinMnWu/+HgbYyAb+JYNW8+J41iBMs5a/77mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

The AMD Versal Gen 2 UFS platform driver carries local helpers to access
M-PHY control registers through the UniPro CREG interface.

Move these helpers into the common Synopsys DWC layer as
ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
duplication in DWC-based glue drivers and provides a single implementation
for future reuse.

Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
is no benefit in keeping them persistent.

Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 0d4d5e98ad65..c7da95999c85 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,57 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
-	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
-	if (ret)
-		return ret;
-
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val = mib_val;
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val |= (mib_val << 8);
-
-	return 0;
-}
-
 static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 {
 	u32 offset, reg;
@@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 71433b4d04aa..20b7174e9498 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -144,6 +144,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
+/**
+ * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: value to write
+ *
+ * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
+					ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: pointer where the read value is stored
+ *
+ * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+	u32 mib_val;
+	int ret;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
+				       ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
+
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 0406f2bb576b..d8673cd54d4c 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.43.0

