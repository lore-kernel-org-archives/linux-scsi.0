Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD964B2CCA;
	Fri, 25 Sep 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347014; cv=fail; b=CxBQEve153ZmLI09/fFb3Qwkd26qNt93J9icQDdE/5cfywWDo6mq4WhqZrTbCTaRqCzkHjRJp3zRrMBTqwJcJWbnUjJz/0BJ97MTtBjP0Vr7F9g8J+ZEKht0tbbKReKNAlq3wWsHgdzX43+kfDhhl7zHzgi0hKzsCauCK26KA9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347014; c=relaxed/simple;
	bh=b8yFhbe5RmU8hRdUh1VkilrIemV5CvKP0zNsavASvBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P4zpXpfst00Buo2oLDZG0jKWl3Amo6N3KWozz22VBjfHQ0OcEOtYuzd4Mh4uFs6Hg/faeuYXxJlR6TzPQX2P34VinFRvadnVWFxP8e7kuT0bm/5tNwsUBKAhRGsbkPJuK/rkkurHNLGClEYdDOHUZOq25pMWWqLWmNssCfqJ7Rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=oW7HZoab; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="oW7HZoab"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pac2WpMUEh3PKjhzZ4h8StHAAPWlPIbSwazB/oL0P7baFLcyK56CjT085pUUrmfmc8ebnpkZmX42xPMgcKGcvcGB/CfbR1iOnc1hnADYvU6CcnNRvdXA8ISXErDJdHhr2Of8Tp3hN2MK6G2IwE/U3oXBKI4Gk30EZtlRRCAg8o0iA7Ph262Xf1xbHMAJxLcuCM8p1jUnRHLsYBQqQM8EJ8n0ezGlrJjka+qEuCyL+OFr8N50heT8DXJNzppxz+qUC6mwZXrfVXnamjxBkEHCqRGGt6Ho8sBSfJHyc0/MxUyImfquM7WWtm6DAOMoB+hwh3khBsjOMHYceH0qhW5EJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=Fw/s5bGy/T4S7rwhg3ypFRvRKy3CtgtIFIvDYwgZEmh12NTu+N/ll7zIFmnZSXmBs8K/rKKQPM7TMmB3gBMU2elOqFOfK26Ur8qgtNN2ZG7N6RjiKddRP+qdAB0xv6O6kgMuPbiH3J5u0eA1Aq8BsU3BC3XQR36ryY5qbOAlfXH91OSGN8r5DalOuyyhcU8RCd2pLiKxO2q+U0zg8LGT0chhcyS6+LvvzV5KxFfncU0waeiBDHzja6ToFtNTf890VgDBGydJaJDhJUTFTrWoi3EnVxIeeRMu+um/NSSGpmGGBrHcCGsA1+tRGFrs9mDe8QgDabCIe768o030CNELMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=oW7HZoabJkViuQ4TqlxhFWKPzgsE0lbgT5RgJ9ldWsOMmwlsqyvfbBh1T6si2HUVW1gvobLWKvPPILDwUTW3Z8TNAWrpR0+zA+4HJ9r5c9QUsbk4FMt3bDXn1lQYzW2pX1JYPm2Ne9uhKekAqswDUlA9vs74f+/DYGuiKI/Pnh4ssMSoLaOSMw+vMzXgTPcwGT79sc7Jq7ZhoXiX19HYk3bArtZ6IDFkUrlS1maQhFUxZCQSX/e8r1jfRaTnmTohM84geX+8jsnLGqfVAxoeqiP59DqUxCJyBnrJbtQ7Zv84GnToODfHbP981pbxLaZviYFIZ8JUb874xRlpp3vO1A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7256.eurprd04.prod.outlook.com
 (2603:10a6:10:1a3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:48 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:48 +0000
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
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
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
Subject: [PATCH v6 02/12] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Fri, 25 Sep 2026 16:35:24 +0200
Message-ID: <20260925143534.3298540-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: 7715b87c-b6d0-439a-fd2c-08df1b124abe
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|23010399003|7416014|376014|10067099003|56012099006|6133799003|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
 8ImktaQRMJsYnltsPKjW7+RTsN3wY53xI44RwXt5AiP8IuVMQJEN7fRCYf7sWVwX2gD3hBwC+Jhfr8mbbuJNGKB+Pbt79a4gK7NpX5FWgqydDU/CtbmZS5fBRadClgWEJ23ty9kibLl6Xum8ZYpc6sD/igS0hN/RU4ExlmdLjRU1DD+k72mVh7ShN6711g2s3LKNcwTNgesWsmqObwQbC8OtM0Tr0Gcw6MFacR2BpnQRoLhMUWqoT/QPk9vBM4J+E/UuZMsOCK5sdAgqdThdw2DYwT9vGDOY3qj4ikDPzJK9rIInaNv/hnMrUw0prqvlm/nDPjAyPJyBgiZKy1RU7Rq1aPArSkfzd82D7FKqjo60XCC1JbwzDjImzHvRGdJ+JpBIoYw8pWmgueMc9L4/dmFUIJH164fqiwpONInP1AL/4Eq6lowQgtjC95ODklEbL7nk7lJ6Q4ENA5d8bDej13hJxKD3OjXKHCLB7fpecm6+rqnuiYNH1ykaxBMjC21VEpp8UIyhnofhRYiq5DktTPPrLbjh/PrQ637bCE51bb4idSr70iyq+jhtkHbW53zFxVBB84i6di7iH9LCAMaxgkTc938QitGDNyU+MGETlre5Ks00e6fdUQtaoT+JqJrj6QG7HfOl2Op447EQjfAcUpgWtwRb/bGxeEkCJXLorw+0NCfGAYW7Vp6UM40yTUxO2oLVHbgl4FOwy8+jh/8R2w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TDNtUEVlTU5BSjF2ODh2c09NOEVKcHlIVVhvNGNXN0xtaFVJbUI3MGhPelZv?=
 =?utf-8?B?Rll5NzExOGQyR3RZczNIZkpSY2VOR2NmU1l2TEZYYTNQV2loK3RrYWNORWpL?=
 =?utf-8?B?STRrTW1mSDhTdVlKQkZhWE91QTdtU0dBcE41UVBJeEo5dkxzUFBNU0VtSlVo?=
 =?utf-8?B?QTlwR0FHMENIaUlzK0RGRnhiTjNmNzZCeFZJVW4yWEhhcVpJRlpUZnRlSXhi?=
 =?utf-8?B?THVWN29hWTA3Qk9hSTBZd3k0RWhsN0dOM1ZvS0FxRWNoUWgwaGN1RTR4bUp1?=
 =?utf-8?B?U0paTFA0MGlhNGp2VlRnbDd6WjgrUFh2bitKOUc2ajhnZTgwT2xYUEFxSmRQ?=
 =?utf-8?B?Nm5qemlNdGNVdm9hd0RYVUk3Z3RURno0c3c1RkhOSS9adzZGRFZHdkhhVWpn?=
 =?utf-8?B?NlUzYU1SS3ltbzhDcjR6bnRLbkpzRjZmdFFkZXdFS2ZOK3dNSDF1QW1UUStM?=
 =?utf-8?B?ZUpqNTdTU0xLSDV6b3creTFKZFRDa1lMTWdxeklzb2lWQlB5RUVQWmRCUzZs?=
 =?utf-8?B?bFUvNythcXRZVy9MOFoxZXRqZlAxb0wxbXprR0NhZW1PZitRR2JPSCtaS0FO?=
 =?utf-8?B?OGwrTHJqeG1TR3pCS3ZCTTBCeGcyQk52SmEraXRhODNSRkN6VEpuaXVkaDln?=
 =?utf-8?B?c0sxaEN5NjJxN25pK3JmQ2czb0ZzYThrMVFkVUI1SkllU2hHMDdKL3RPK2ls?=
 =?utf-8?B?N1c4a0RodXY2VXVzbVZFN0R5akFOTmQ2M0hGbTltZXhaNlBtQk9WS3pDUnM0?=
 =?utf-8?B?NnlCUkdXNTdHY1dhQ3hobVpSRDFBY0ZBTGUvVWRGWWk0ZGQvbnZnUEZLN0JW?=
 =?utf-8?B?ZEhUU2VKK3JvcGIreVR2Qm1JM1RuU3lESzc2V3ZQOGJGT2lIUXRWNVJqMFlX?=
 =?utf-8?B?bjdmc1k1cHZUUWR4OGQrcU5Cb205NWRoVTd5ekxCWkFuUWhHeDBsYTdKc2hp?=
 =?utf-8?B?aXoxSGY1ZHJmN2ZCZ0xWYVkrVUdhbG5EZ244T2lRS0ltTW9xclhBTzQ1MU85?=
 =?utf-8?B?OVJpcHF3eWxoWGsxeHVCT0lVcm04OGJPSndBUGtPa1dpTHh6UHY1NGxhNm45?=
 =?utf-8?B?ZmJ1RTlDZ0t3TzJBWXhGeTB2dlZxNCtjUmZYREpVT3lSMHpoaXhscS9SWG9S?=
 =?utf-8?B?eGJwNk5zeEgvL3I5ZUNDYnBIMnJtbTNEZEU3U1prd1FDS1RwZjMxak83aDBU?=
 =?utf-8?B?bXIxdk1TOWJXZGMySnRJYXdpTlBWS0VhbDV6RUJEVkpuSytuRG95Nm1tUlk0?=
 =?utf-8?B?cStKdGRjazZqMmlaS04veHl3cERHTVlOUk1sVnBsRUpmTWlYOHkrNlZ3N0tI?=
 =?utf-8?B?SC9ta0lCbVVuai9YaFFzdTlNVWd1akRsb2dHVWV6ZE5VYTAySWtQcC9BMk9p?=
 =?utf-8?B?cHJKMjNQbEFpWHB1SnZTUXlmWmJZTDBIS3JueS9meDE3K1pFa0l5SDNVQUYx?=
 =?utf-8?B?NmJKRWpSOVFkcGtpeTZ5dzRpOUdsUGlkaHJOeHBxV0dnT0Z4RER2TWMrTmdz?=
 =?utf-8?B?a1ZLdzZwOHFIdDBlUExRTlAzV2pNZjQ5UHlPOXNueEtaZ1JFaGdyaytDaVVQ?=
 =?utf-8?B?U3ZDRWNSVFFCWlpZWGQ5VCsvNVA3ZkpMTTFqeGtsMDFTQnJvODFRRWFIMXFy?=
 =?utf-8?B?VnlvTm1ZZyswekpoY2RSQzBnei9ZcWI1T28xUnE2SjRmcm51c1lkaUdyOUZE?=
 =?utf-8?B?M0l1aWhZc0x1cnhBRllrakxjR1pBbFpWb2I2TzZ4b3h0dUp6MWhLRnQ1bHBQ?=
 =?utf-8?B?Wmh6YktnWlA5SkJieHhOREtqeTJ5TGl3S0ltbjJmT1AwNnBoSU9xblZGeE9Z?=
 =?utf-8?B?UDJ4Z3lMaUs2YVBjWEMxZkYwMHlYWThhak1Bdk00TVlmQzJVZ052K3dNTUNM?=
 =?utf-8?B?azlkalByczN0MnJ5TjlrLzlwMUdLN0EvdVhFQS9hMXJKcDNjcm9QVVBnZjJT?=
 =?utf-8?B?MjJwU3ZPNE5CMWtTdzFEMVNia00ya0NIa0V5SXZUcldTaGt1a0w5bTRTb0h1?=
 =?utf-8?B?ZDh3WXJNMDZERTk5ZTRqTDMwWHBYbnI4WnFhZ0FWemJqOGtra0hyM1ZBbDVY?=
 =?utf-8?B?RmxUWnNwM09BSWdGWDN1eERqNFd0bTFQZXFtZHMxQWxpNXFKamRkTjR0M1h2?=
 =?utf-8?B?VkQ2dUNBQ1FFd1I0KzNRYmRpTTFKSmo2eEdjWTM5M0s4dlY2MG1rVDhnb2pT?=
 =?utf-8?B?YVoyMTdtczFkS1QzNGIvNS9FbVF4T3pab0lCd0x5SDJ4QTJzaWFpckM0NGR3?=
 =?utf-8?B?a1BZazMxbVBUR2g0U2ZGUlFpcDg0Z3F6Sm1kOVQ3dGVDWjk3LzZVNzNXUFJU?=
 =?utf-8?B?ZXZYOVgwNmhPN1lYc0grbGZGUG4xN1ArZ09abEFHbGdYOTNBREgvdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7715b87c-b6d0-439a-fd2c-08df1b124abe
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:48.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flgD1hw2tCsM/cMlIFYrDcRFZHv9NHJohSq41hXhpjCWf7meMXbKOPpLWOE9jAk6YIAZY6D+f86jT/4MbdxKgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7256

Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
include/ufs/unipro.h.

These state values are UniPro/M-PHY related and are not specific to
the DesignWare UFS host controller implementation, so unipro.h is a
more appropriate location for sharing them.

As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-hisi.c   |  8 ++++----
 drivers/ufs/host/ufs-hisi.h   |  1 -
 drivers/ufs/host/ufs-qcom.c   |  4 ++--
 drivers/ufs/host/ufs-qcom.h   |  1 -
 drivers/ufs/host/ufshcd-dwc.h | 19 -------------------
 include/ufs/unipro.h          | 20 ++++++++++++++++++++
 6 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 993e20ac211d..2d214ce9620e 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
 		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
-			tx_fsm_val_1 == TX_FSM_HIBERN8))
+		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
+			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
 
 		/* sleep for max. 200us */
@@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 			__func__, err);
-	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
-			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
+			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
 		err = -1;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
 			__func__, tx_fsm_val_0, tx_fsm_val_1);
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 5a90c0f4e90c..6af6a268458d 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -43,7 +43,6 @@
  * M-TX Configuration Attributes for Hixxxx
  */
 #define MPHY_TX_FSM_STATE	0x41
-#define TX_FSM_HIBERN8	0x1
 
 /*
  * Hixxxx UFS HC specific Registers
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 954be9343f42..38897d01fde2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+		if (err || tx_fsm_val == TX_STATE_HIBERN8)
 			break;
 
 		/* sleep for max. 200us */
@@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 				__func__, err);
-	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
 		err = tx_fsm_val;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
 				__func__, err);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index a5ad5ce44a19..3c6cb2281af0 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -11,7 +11,6 @@
 #include <ufs/ufshcd.h>
 
 #define MPHY_TX_FSM_STATE       0x41
-#define TX_FSM_HIBERN8          0x1
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..a5e40e7604a1 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -39,25 +39,6 @@
 #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
 #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
 
-/* Tx/Rx FSM state */
-enum rx_fsm_state {
-	RX_STATE_DISABLED = 0,
-	RX_STATE_HIBERN8 = 1,
-	RX_STATE_SLEEP = 2,
-	RX_STATE_STALL = 3,
-	RX_STATE_LSBURST = 4,
-	RX_STATE_HSBURST = 5,
-};
-
-enum tx_fsm_state {
-	TX_STATE_DISABLED = 0,
-	TX_STATE_HIBERN8 = 1,
-	TX_STATE_SLEEP = 2,
-	TX_STATE_STALL = 3,
-	TX_STATE_LSBURST = 4,
-	TX_STATE_HSBURST = 5,
-};
-
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..e0f490e11c7f 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -466,4 +466,24 @@ enum {
 	CPORT_CONNECTED,
 };
 
+/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
+enum ufs_rx_fsm_state {
+	RX_STATE_DISABLED = 0,
+	RX_STATE_HIBERN8 = 1,
+	RX_STATE_SLEEP = 2,
+	RX_STATE_STALL = 3,
+	RX_STATE_LSBURST = 4,
+	RX_STATE_HSBURST = 5,
+};
+
+/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
+enum ufs_tx_fsm_state {
+	TX_STATE_DISABLED = 0,
+	TX_STATE_HIBERN8 = 1,
+	TX_STATE_SLEEP = 2,
+	TX_STATE_STALL = 3,
+	TX_STATE_LSBURST = 4,
+	TX_STATE_HSBURST = 5,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
2.43.0

