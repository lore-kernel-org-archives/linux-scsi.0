Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9493A47A0DD;
	Wed, 16 Sep 2026 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548283; cv=fail; b=k20Z5lsrAZOXVJ+r50QDzs9zKuleq2sAaNj94+x/HLL95JfIt2P1JXM0H0IYIV2YUDuGkCTTA2ur5rFnSxFtBSQa6ZHwzr1QQToXtXJg39PrnOZ3cQC0Lf97r2n+7dFevyyhnhyv3VCyquz2zK1dn/lV5jsMwOqdneMc7iWh4Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548283; c=relaxed/simple;
	bh=N96I0/ARXRK3YzhkZZUf5hfwsWs1UfPh2J9PdLtXZV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kuZN4ncXBaOfhan8p03QzJ1y3DsHi1cRUGPw/sD+6bYCn2tLngINgyEFV7orC8713P3Iq6yamaWZHJCd182/KgUMx+afLPx9ecJaSFwoZNMoU2cqPtCh8M6XtK3HekZ21EPCeZhZT6DGn2TSJ1P2x6iedFSgINTE+P+XvddfHqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=NQ9hFfYp; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="NQ9hFfYp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDT/TiuLO7U3dQhxlCuPWkJ18mb4icrDPTpQqhDCQDaBKiGHpuA+8Gz2ChTGNyQYyrjiIp9cfhxDsMqN3LXAokCAFe5KaRgFP+j+AphTl55wyxK4DmS66Kjbw42okPn64/Tvt+DLU5OxbJJtGolveFKl6rupUKIKs6NX0heiC31FgHU5uxMfNfY+XBlM1uGwmJ3ezgChJciegjOQMZNfFCfTgMFnkKZnxGgVO7OHw/cJRtmdi61Y2NF1IPBaClVn/w62qns3cI4x21bVi6Jwn5JsoZqd19zjEvJNBFiUbAQALrAfxVC6i+2iltgDaZbrSsDLiAzViEzfmbKZMpJ6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sf7Pnm74cIgbaDt1QyGCdAwp4xOihlrJF8+UxctyQew=;
 b=xzKiXTsUwkCdEoo/8IsYTqtwLR55UvtVUZsMvAZIxNAI34fR2nF0fauoY7t4gsU2Z/qgZBa0k0zm8MW4lufPWcUM50kYFhtGUPGqiK0rWGH+6q62ln9oweEM+Tn4w4YfeNVfOVMp2W1nF2+32dSwZfnBs/MENzqEtI63ESYbC9Pw67jADGsCwMDsCDUnjSjbhKEa+zsnl5ZzAxJyPz+FIH3x/M/LXj1kCvi2Dq9joDBEwz+UNRNeHeqpiNMJaZCC7VeDf1kRBD6wHci2gujSYPqTn63iyA5Q0U8pC5X3HEsd3i+3dhdnwiLqoQ1SdeIH9iJarWHHUJF74z/ry/LIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sf7Pnm74cIgbaDt1QyGCdAwp4xOihlrJF8+UxctyQew=;
 b=NQ9hFfYpEMdqIQK5vBlgqQ6t8bVeKZQHE9qj7pzddmFSsCzm4Am5uJVqIdEVqT75pEGNBpFZW45TtgEtfTwA51tnWqEZoEv9wQdbencaTipRY9RuIgCAt24AVCxKBx1ev1Ez5q8+M4iqqT21k6aL245WfDDknfGrqgYlnOUIoocGML8lp+yIx8uN+1DDDHCxfGCHZrV5APVkHhuyn4fLs5OSJc+bfUhkicSywGVGFVyTOGA9RjkMNklnHMx4CrL/67dj2RHZTIcf/B2XyX9I8lWDRvvgZc7qpG1Nod6hpfTxzB18L2Gv5mJBt+8CKNQ1idsBlPJRRlTCgztuEYxcgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:22 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:22 +0000
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
Subject: [PATCH v3 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Wed, 16 Sep 2026 10:44:04 +0200
Message-ID: <20260916084411.941297-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 559045f8-deaf-43c0-b573-08df13ceb456
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 zHJSJfiX6bXs3hE8j82c8SSHcNNvUGLW2JZ0o1HNmqOLQ4C5Be1ns/8adDIa7kh2sEagsRWoYLyWyU8Rx1k1I8HHCGcTTBIcNH678zCDVShikyS5gc+Xn3YBlqsfHYG95cItbefDCgAb0iTp6g8Dxfu8DckgIxbGpF65747mrhzDn2k+F04sjeR/zRoiKg6phNAJ0AKsIDOjjj99Nm2szvqFVYySrI4QKhkwFEQeKHL3LE7UsPdIlYrQUY7GG3Mo49k+hQ9UNeLCuehmnvpYq65QY9HLnA08yDReMCnb1s2L6lLPOME3ZAEI1VKdF0D81AO+SEF2YPGnmr214TGYa0UhWecfKQ66lCF7kNDji3UrSNTiLQnH4FZMU+wB64BONZlTmQ2MnIovkMJHxbPecn3g8EzLw2xX5SUIz/VPr42aOF+nHyCGChI/MvlmW75LRcttXDWzxtvfbeRArvK461DAQYLg2zHi6C57etHt1i5jUEv/Dpl02ilqRyw4zZqauk5DP/RiK2z0CSp79GAsSUHWY8VJANmnoGYS+msL7R5jnGZsg7jlymlhVURt8/4i1PRTUxDdTtWatFcpe1oD4EqQKA8QkHOFhO8U/kjav3gUrjFwHlwKu6KIiSyThQKgoAJVPkdNJUuoBQ3Ptft/bJ1qjMzqUNequ0IEuCerFi2upbNxX7WjkZfgVTYaptAzVcLHUwX8fL7O9DJiWyl4OA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SjV4U0J2SzU1bERJUEZGUHJ4ZWpINHRucUxldWJNenV3eFJTUnZBTmJQbGFw?=
 =?utf-8?B?MXIxWDB0WGN2VkFjNmMzK1pWN3BCQkNEakdNK3NUL3kvc1JTOHh6VmdERkJv?=
 =?utf-8?B?MXZGUU9WMGd3eU5YWUpla3NlWUYrMjVBMGcwYUVta0lCRDdEaStOcExMcWpt?=
 =?utf-8?B?c2oyZSt4UGw3U0VIcEpNOVl0STV3QVczYzVBVWxzd2tiUDZDTG1uYUF3Z25x?=
 =?utf-8?B?YlRFcXBocVl5UzVmVHEwbjVNc050dnZSZWNhSllvUWVxOFlmdys2Z0lJSHpr?=
 =?utf-8?B?MWZ5S29RUkRpWitRVkpWajA0MzY0dVczYU1NN2tzWDJHbTRyQ3pXcEtpeHZZ?=
 =?utf-8?B?Zy92NUdSM0dpWk1mZ1FWS0R1bHFGWmFQZEY5Ynh5Zm91aGlzR2JPdHBhL1g3?=
 =?utf-8?B?WCs1NzN0bjNJY3I5NXF4ejJmTUE1WWJmVWpCdlpmSm5jbmYzZUJ0UjZpLzlv?=
 =?utf-8?B?UStnREJramJ0VDVnVWhqZTNlWHNIVlJsdmxWZTVyWitiVCsyTkpFYjQ5RVIw?=
 =?utf-8?B?dlRxMnpGRTIxL205UDlHdmtWcHplZFZjd3J6ZGFTSmdqbUxpSXRFOFZDYzQy?=
 =?utf-8?B?UGpDQ1NIclBqMXo1NHR2YmMwQ203K2RuOWdyUmdvVlpGN0tjaTBocDVwaUxu?=
 =?utf-8?B?cnU4OHk2eFpqcTFIbWxFWE1sZXh1SlQxbVFPY0dRK1VIZXZDLytpc0FybjFx?=
 =?utf-8?B?U1hXdUJMSDJYU0pPZUpwTmswMWsyUTZqVllzN0NSbm5zQnJkZkhqNDFmWjQz?=
 =?utf-8?B?OXovTGtjdmw1TCtxV0V0Qi82QmhFOW44MHZ3cGppSVpML2ppejZ6VC90MUg5?=
 =?utf-8?B?UStTYmp4YklqZXNLRnI3eENBU3FYK3ZyY1BhQWNiVE9zTGVXcnpOeEZ3RCtT?=
 =?utf-8?B?NXpvVDZXWXcveE9nQWdLaC82VVo5M1pyT29FYVZNQnRoMzkxN2JGQU1ZdG9l?=
 =?utf-8?B?U3FHVURacCt2cThxaVNlZnNFZmwvMUdmUFBta2ZNWC9kTGw5ajYyRFdJRU4x?=
 =?utf-8?B?STlZaEYrUlU5WEY1TVFkOWlJWGZkdExUcnBxcVc2dlBmbHpReW9vUUptblpL?=
 =?utf-8?B?VVAxV3ZSRm9aUGJzdEhPRHVreHBhcTFGREowQXZtQmI1VE5MbXFuMVUvZ09I?=
 =?utf-8?B?NWxFUEtaWGxlNm9JUWlLcFAyM3daVWcxR0dVYUF5aUs2a2hqVXVjSDNtWkl1?=
 =?utf-8?B?RHdRNUlNcWpGWkJDVGVVWWQ4dldKeTI0VUc5Z0pZakFhY1pCMEY2RHRXeDVt?=
 =?utf-8?B?NkR2RXpoQm1USnFkeEtndysyZUdpcm5HV0FPMnc4Sk0yVnQ0OWtHUDRnWmFG?=
 =?utf-8?B?YUlEeFMwM0Nzb0JsWkFxSmNNK3d4eDU1ZHQ0Skh5RXJRZkVhNDJkVDJTS3Bi?=
 =?utf-8?B?aWdwbEJONU5oamc1OWFYeG9XcE1TaTIvMWo4UUxXSG9xVlphK3ljMkVZTjFp?=
 =?utf-8?B?NmpLMGt3Vk8yYmU5M2lKcmZkZU5oUkhBY2tIbjI3Qkx3eVB1Y0pBY0VQY24z?=
 =?utf-8?B?V2gyU3htWitrYlVtbGpqWlRVSDFUT2M2ZWppNmtCdkNYNDdIVHI5eFNmelk3?=
 =?utf-8?B?Y0tsdVUvN2VpVEp5Rk5nWFhVbXZCSlpDcTBHRnBQbnd3dCthMkxPdXhiUE5Z?=
 =?utf-8?B?WnVmQ282UjVOZGxWWkV2bU92NHU0MjFCK2szYkVSUjNrcFlmd2g3TVE2TWpQ?=
 =?utf-8?B?T1pNcjJFMTNzWEUwbFB0ekh1UzdzSW1UUDQ4a2ZIUjh2VkppK2JBMXZkbUFm?=
 =?utf-8?B?Q3pUZFhQOXBjTnpadGRaai82TkFKemE3Yk1HbG5RQjMwNWlyMC9sU1I2elFk?=
 =?utf-8?B?ZXpRSkcvTURHZEt2MTl6T2NocTlBWXJHNW42VjRpVzVaMXZuZ05yVDRNK1No?=
 =?utf-8?B?YUpMdTRlSkFzdVFYM0tiWkRjdVI1V2FzOU4rUEx0V254bVdFZnNFVUVGL09k?=
 =?utf-8?B?Q1luTWxHaHJNL3BQVlVXU2xQS3VwUVVobG1JL3RCcWRvb1VzVlZ6ajZmb0k0?=
 =?utf-8?B?VG5TMVFzdUtuVkRWbUNCRFY2OU04dWd3SnhKbWh1T0xTMlpDclZtQlpOVDZY?=
 =?utf-8?B?SlhleHFxZVYvVFBUTmR2cnA5MURmUll3S1FwRTJtMXVwczlVMklwTnh5UTdF?=
 =?utf-8?B?alBmcWt0THVzSHNRcDJMeThRWGpUSCtwSnhqdVhlVzVZWXkzQStETGpPZXlv?=
 =?utf-8?B?Si84VVNKOFI0bEFlZ0FGTUZaV0JmRUI3cFJIN2hqUTZJaTgzelZQY1poZTFJ?=
 =?utf-8?B?TGIxQ1VuVGZaYkdwTHB1OUV6ZXdjWU9ON29BS1E1TlZPUGd1Rlp5dXJGOHk1?=
 =?utf-8?B?d2huWHNmaGhjemNXVC9tRytXYXg3YWlLQUtGMUdCS0hFeGVqSFRGZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559045f8-deaf-43c0-b573-08df13ceb456
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:22.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5NBkFUJ0+otyP5pq3C6CbVhsL0XM1qgbMBPjtHkf9cTNeuLFpjPpmZ6+On4/smO2SbY/Da9bgjOrVyc7R+v1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd so it can be shared across host
controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
This is an intentional, harmless change of the returned error value; the
pass/fail behaviour at the call sites is unchanged.

Unlike the initial implementation, the timeout error is now reported only
once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
per lane.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 86 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +--------------------
 drivers/ufs/host/ufs-qcom.c | 42 +-----------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 91 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..f34b7fe54a16 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,92 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
+ * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
+ * timeout) if the attribute read fails.
+ */
+static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
+					unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: timeout in milliseconds for all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	unsigned long timeout;
+	int err;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
+
+	do {
+		err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
+		/*
+		 * -EAGAIN means the lanes are simply not in HIBERN8 yet, so
+		 * keep polling. Any other error is a real failure and must
+		 * be returned immediately instead of being retried.
+		 */
+		if (err != -EAGAIN)
+			return err;
+
+		/* sleep for max. 200us */
+		usleep_range(100, 200);
+	} while (time_before(jiffies, timeout));
+
+	/*
+	 * We might have been scheduled out for long during polling, so do
+	 * one final check before reporting timeout.
+	 */
+	err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
+	if (err == -EAGAIN) {
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+		err = -ETIMEDOUT;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..b84075dfe00d 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1e492dac8d93..815ca82a0878 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..0d9d0a26eb20 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
+				       unsigned int num_lanes,
+				       unsigned int timeout_ms);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
 				    struct ufs_pa_layer_attr *pwr_mode,
 				    enum ufshcd_pmc_policy pmc_policy);
-- 
2.43.0

