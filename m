Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E6F4B1D1A;
	Tue, 13 Oct 2026 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887425; cv=fail; b=F1Y4LRSUKcnXG38DQW7JGIuL0bh5dwdW0F0JsQAXWNqYeC/T/NLFScjn81jr9/HY5DY3weLr0IYSPX2dUn5uO9VkjmfoUtX2yXiNg8T/QswA28Nt5J94rIZ/O+DFlCGUi+wwUeCZC8cmSWK+BfPbJL52udT+W1v5SOgsNiMp+pU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887425; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NPAaCF5a9ATXJ2cnTHkHg2qQ7xSyZLoR+lz/BnpOzLbfm1CPMPHl2U37N8+PTLotScAr7IWfNFnHX+nVO74+YH9nLSnMfXYrF1NtP9M/JK0dU6NK7D7E7c9agVBh7DHh7mhFPIj5O8bDBxbHjym0djyBYdCDTmj7Em0rAO8yVP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IrIff1f9; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IrIff1f9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JreXvolGkBqme+ZNeZkJaAIcEi5kEF5beqDXJJDC6AZ/iON2FcZLQF7Ar393aul99Meo/ijVT2dR+AQ/+9R92n3Fpy5Svw8inUk+XkEaAQ+bO2OO40eVPnxhke3kyjMh/VEdvgRGA6G8tTFyejA8a0n8ME6i1Loagls6AMu1YMtpTVBuspvSi5Xf1yeFbGQ20AElMCNzKLg7xadR9FlWmPu1beRfi+Msr0CjxOgNWWhv8Z7iMXUVYYjj6VhkZieeBPZxr6E5CzelfFN5ga2zvdO8hz/Fww0tzUYVzwpjevWXzAPIZTZ/fjm8iRaA7jDu66jpGkVD7Kvt7b8ydVYOnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=Ngq8NFgK4R03Kr++rkjPzfs60t+AarykiPG1Q3o6mMgybSiFHebCK4+7JdG2KPCkLiGD03P/0owmu9eWylpKszmxSTpaYuh8EU2N2cYzY7SOdOuvEnzw/nxVHt6ceWb2zU3xxyh9FCnZg441b3ezUEu3b1JZ2Zdc5FprRWvgf/MVtAakbECnZ58RHC6ApPSLxs1qHYjBhPU/Zex+yrgY4/0sF6e6o49u9z6i+poKBolKqYy5on+4g1eA9ExHEtvWD4JcWV/Y4g3FMZt3YZ4yoDN294/LBPiJgPRRRW6xeUBc0z2QHV8MxTy69S+aftg9/DHB1i78bsc47M/wPz7hdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=IrIff1f9CQnuwOPvjDQ111WHmETydFdpv3bDydOHCHCtdwMj7dhOlcJUdxRrzfRmNldhkFBFIayCEPvRFXWXnqAahCu7Mtb3A2EiioKZCJo3Fki96xhZsM+V8sLv1974tzx8PzPiOkYlSRcFoUfuY8yFM99/u4zRI7q7LbKn5tnV/qz7KOCW8FOzNg9OkBDRkxGs/IzzVZAH0rJmZiRTt08lHPme7i8aBszTdBK2Q6K8ezeHL5m6iHKM8DKZ0cF7iOL8U4Z8DgoxYYBxj1jaJEzYSKquG4cGXkFFoE4EL4blGRYQLLiNF5Zk8DcXvkBW7G5m/96P8PG3APmKpU5pCw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:17 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:17 +0000
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
Subject: [PATCH v8 03/12] ufs: unipro: Add TX/RX FSM state attributes
Date: Tue, 13 Oct 2026 12:29:54 +0200
Message-ID: <20261013103003.373156-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::13) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 56cfb726-e659-4b8e-5450-08df2914f9cd
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|6133799003|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 SxbzLsk1zpwZWaa5JdDcwmuqQBhUP+F1llZqGO01cxyskaLMz67ghH88gvCm3PxYZKSsOQNiEty8cKAEGjbQ2m10IW/2nal6IEi9pJ8LVCx7GO6TW36wK7l3X3VZ6wowpX+1+Jjor2DpvebZGgw5+NnuPVza3g3Q9UB+yuzi00ehMJVdaP8FW69LlhGbvoQttLt/K51q3yu4IFqVt0tQeq3qGNnVbZCh1BWZzlEV/mdmH8MlZNJfcYp/1G9HCkPSLe66d+RkRJq5pFCqgj4u6pP/nZxYXuceAGmbEfan1VIWrrPyKwWsD4AH1ndBcZZv89NYUa+xS9lKf3+ErKv5Y4yPkufCVQtDhi+GF8pJ89Z4kEBiCqfASzp2KeE0RHBtCatCLEhN3rnsmrffEC2UAmMKYdm3/Eo9zp20qG9LUoe4HHvYd9a80wihPsOpNiRyJMI5nVHk6hu3E5n49A/zJgA36At3bP7yViz2yJRcCMYfwti9LiLboTPBefSItiz5FjhpRGkdMn5DOYqD72jFyw2aAop3PupDY8XGfTcQHfKZXfuJ/a41KhNNaytVGdjJLmUKAdoc5ShHJhCpmJ2x0wtcbU0+0NYndIHgGBiILxts/avR7O2v6EmHvzHmqV9dHxdAnd6m3o6Wgm6x88YR3iiZDHYsI6iF9fGUpCwV3w7mhpgnn1gM9ilm+xm2RQFrlJVZJdLnivhzLFM1GfsXbA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WU9peGxSaHZPZFVYT3Z5YWdGMlp0ZWxBZ0pOZVJGNWJHenJaVDB5T3A1VkFG?=
 =?utf-8?B?Um5hUWxsei96ajdPd0RSK1NrZ3J1OG5NTHAvaEo2c21zNzRBczJWb0xHb3Ew?=
 =?utf-8?B?d2tON3d1QTlvOC8zczFrU2xyVHBSanFtckgxS0FENDVjU0pRb28vcGVoc0J0?=
 =?utf-8?B?TFlvNFNDbG8wVHEyRzlaQmUyZ2dNVU54amFmMjFGRWcxaWV3ejdhb0xmMmZV?=
 =?utf-8?B?UjFXS0VYVkdYbWNYVHFzTmcvYmpnK1NubWNqbXFhTjlCbmE4WDRIWkV0TmdM?=
 =?utf-8?B?T0Y0MFJVTnlsUW5zRmpXSVhoS2sxZXZ4WUlNUHNrYmsxUE5BSHNMZUhla2hj?=
 =?utf-8?B?aFJ4K0ZBbEdESStGVHByZDNyUlRwVTF2SDRWSWNOTHM3OUp0d29jS3dmZkhn?=
 =?utf-8?B?NTBaZVc3QmlFV1lBNlhjdDlld0VtNVlEV3o0RVBUdTd6V0VXY1VXRHF1V0Vv?=
 =?utf-8?B?YjV0QlFUdlRXQkMrSnE1d1pWY0ZtUS8xUUVqNk5maW1hOURpYndvL056QVRN?=
 =?utf-8?B?YTZrV1ZxbExIMXJyTzlXeElPT0luY3V2bWk5Zzc0MlBUNnNiQjlNbjAwbmU3?=
 =?utf-8?B?YXhneU9PRFhMUEU0bmVuaU5HMlBVa2VuWnprNWNvK0RvSUhwRzlobjRtMktV?=
 =?utf-8?B?NmVQMW05T0lUZU01b1A1UGlkMzhIL0VLMjRxRGtLelI4Qm1DZW1JVGdnZjZu?=
 =?utf-8?B?YlhDNG1qaUswK1krY0ZRQWlIU2FWbzBnSnVHTWNlNEU5S3BMem55c1JTa1FS?=
 =?utf-8?B?SUswbGxNaWxPUUxJcnRucTZCTnZjb3NxTUxGQXlzd21XcnMzQmgxcS94MHlD?=
 =?utf-8?B?WGtZbUpYcXdtbS8yck5GUTlOSzYvUUlyNzR5VlFBZFo4V08yUkhicDVlWSt1?=
 =?utf-8?B?M3RLOTIwR1FvYWRxRVM1N2VxOXJzVjZDUEt3QnR1RnJKdWVFTGZsM25YNkl6?=
 =?utf-8?B?Njhid3p6bzFnbWIxNVRZWW8wS1NCOFVoblBUaGZxZzFxK3FxdVZFOHB2ZUZ6?=
 =?utf-8?B?dGRZai9xMGxhUzNLZWI1VWpQVm8wa29wWUs2M2g0S0lOcDNmbGJYTjJoN3ZK?=
 =?utf-8?B?TGRLWm4zVktuQXpwY1h5dVVhWHlEWkorR3N6WWtxb0FtcitzUWpkdVdjV0dz?=
 =?utf-8?B?QUVxMnY1ZTVmanRjZnBWOHQreWZQYkpZUUJDd2k1cG9IbTdIV0w2aEMzNHlQ?=
 =?utf-8?B?VFlwdnorZXE3U3BvNjNYOURiU0w3V0I5czNuQmh4ZVBSYXByRDJHN3EvU0g0?=
 =?utf-8?B?bjEzYXh1SmdTclZqWjZSdU5OeVExc1VDRnhneUxqckdJQllVOFBqSXhyZnc4?=
 =?utf-8?B?aDRaN0F0MDY1TU9Pa3M2WkwyZkVZbHZLdUtBdWFtbmxrUGFUdmxvYUZ5YXVs?=
 =?utf-8?B?VzU4cUpudTh3UE05Wkp0ZXJYU1JtUnRSVWQ2U0UwR0F5bEZVRzUyUTNuOTV1?=
 =?utf-8?B?bGc4cng0bzRHUG84WVhiQlBpSUd2b21QZnZUMjRiMlNBcXA3U3lQejBNRkJV?=
 =?utf-8?B?a1NSenlaY2oyOG1ybG9vd0VlQ3VyZS9TYlRNM1NzSVdMbTVGditIa3FhTmR2?=
 =?utf-8?B?UGVCOTc5Q0dIVmYxYjVQcFB5eXdXeUpPQmdZM1VBWk1iR3F2NHVaOWE5NWlC?=
 =?utf-8?B?VkxnakwwZXoxTStrYkRIbzZRRTZUbFpFL1JTWnRQL05OMHJkczQ0ZHFubGYv?=
 =?utf-8?B?RERIcW9YWk5OdUV0QWhzSzRMbXlVbGhoaEFPRy82K2tIS3RMTXo1YlJEOFBQ?=
 =?utf-8?B?T1FMSm1oQ3pEMDJKNmdDMjVoY24vMHVZQVlyejl4b25sMXBaYzNncjNaekhk?=
 =?utf-8?B?TXN6Z3BVcnJpSE84V1RnZjZYcVhrVUoyTGFUUUN6NWZmeGVwQ3RIWm9RSktD?=
 =?utf-8?B?MXBKOTdUdWhCRXBEcERqZUtuWTVLU2QrZUNITkhrSXZxV1VPVHZTTkIwd0dQ?=
 =?utf-8?B?dG11VlBuQ1d4YnQ2c2lsbDlHRStzaWd6NDJIOUdPNkVRQzZPTU1QVkl1Tm52?=
 =?utf-8?B?N3YzUXJzQldYSWt6Y3ZsVGk0RmlrTDEzQWVHa3V4cEtoUG0wT0phR3NKMjB4?=
 =?utf-8?B?RlptTzErR3pCazZDMHJHOVNEeGp1eXg1Y2xBNWN6RllwMmpFTVBmOEtNNGxW?=
 =?utf-8?B?WGRqWmt3MWQ2MTdieFBSSWQyNFNpYnAvd1RtNnFVcGxIRzhrTUhrQzN2VjhE?=
 =?utf-8?B?STlEQ1IreFQzNG52TTZmVXhRaEo2OVBLOWgxWDg0N2FoOXZxQzVtMzJMMksr?=
 =?utf-8?B?U0ZIbzcyMU9aYzI1VG5wMjJvR2ZiUXg3b1I3S3NnbnJKeVEzWFY3MDBRUWxQ?=
 =?utf-8?B?aXRqZ1pJS255ZFc3SzNqV2dTaTFnbVhWV1lLZjNSK29vcGtCbGcvUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56cfb726-e659-4b8e-5450-08df2914f9cd
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:17.7758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oq0IYr7XrICVflAS9CNaZbYPOtDMgfVCNUBKVkjwxrF4dv2YOqzFNCUBkdlEmmWj36yIjgDkRL/Oo0v2eGtyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..0d4d5e98ad65 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 2d214ce9620e..bd223bda1ce2 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 38897d01fde2..1e492dac8d93 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == TX_STATE_HIBERN8)
@@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 3c6cb2281af0..1ec661277c1d 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index e0f490e11c7f..6fee545bdee5 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

