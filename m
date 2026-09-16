Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2139F478E23;
	Wed, 16 Sep 2026 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548290; cv=fail; b=fd37fpn8mB8ifWeAJU/Auud1KOhJXL1mAX79xO9W/EB3EvT3IYJ/Eyzd9/1FTZfGy0iQRrj2gSgwr7B4I8pgj/ET8u3/GU8SxY4vgYJp+/Dwiv7O6UK0pFFmVE+fy5qgxF9Qr+7aSjQka/TQlq7uG0Rksh6ski3Oab7Jb0IOvH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548290; c=relaxed/simple;
	bh=T1WVVLI2dCHbzhT/kD7wNObTExv6HtQAnr82p+jWbBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OWKIWexc9UwPpJcmTDnv/ZGCbPgOdkFkOXJXtKvlU/L1MOlDQmqQL6eXSonEoTnW4s4K08xaZ+ccXDktegYiNfOwAsuzGQh4+TxFnGrMQEFW3xnnjai5YYk/Sk7aDVRwXgVoCUFjVRd3dz0niFthBG27jQUK9Flkthi5lKuDNe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IUsQ66xw; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IUsQ66xw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwrwYIOXa8r7oy8+0gPZTbBdlEG/KBqbcOd929aTw1doQoeHdf9Ku3Lj1XPfCQ0QZOxgbX7luK1KZa9uSbUHzsFuN1Wke1pPrIr2G6Y4HXP+vSQvVQy0TjEhTTHXJyD+Kt9zmnlJZDDRLTqSnUHWW2TAcACAqnp0PNnJ/CAGsukF7GMR3t4Ik5+Ujn19l8ud4cW7ccPsThr9ECmwAdgUf75wBvpPgga/9cZS8xoT8yDKeSpRybdpNkhudHjfiQ8lrBaLOP8zLcsj6CabVUAbeX18T2ZEdGnyOwkj6Y+W6PkuyUYI6ittYsWzvy3q8zUoe+Dtsxc8+B9Rm6/gaZObEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQUXhftURTjhh1iKq86SS9IMJdaJpMwRFa8pMuZB1KQ=;
 b=nEGFwFbxs3m/dFCP6e7X1wO9VfFOr0RNo802+lvHnzacGPfFj8oDyDS7gKZVA6Kj/g8v2wxbNsKMJllH+jTheNcOf8fUcscVJ3Q6VDIiMhlUkdAkJ2mEG9VVod5IHCLsUTHwP4qYG7e4gnZUyOrHcbxhlgWpxQzz9d1i21LJ+4aod4GUDufj8c0kqNLEMiyuh6O7h87xaBSOQ0gCCPwJWzVAAOL64ad8b09y4WS7541keeYDp76xWkZJG0FSr8rgXL+rsEkeX6rECipV3PxNJAlQ/ToLRh5F9f3/kVpdgFr2NyL6Y1th64/jsznKwJGCHG17sG0v4lkStileBVz1wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQUXhftURTjhh1iKq86SS9IMJdaJpMwRFa8pMuZB1KQ=;
 b=IUsQ66xwIExt/ts1sZBmqWh5E3euDz8l9e3NPmMwp1+SU/fLkKNTO5ZGiii3zBneN+dnnpzVhINzr2eUsIxDTvQ2PXzgxQn90zKXJBTnRs9DgJ8RulVUGmJ6aDl2+eLsH/9D0hF9DSshnFBHPXIgF9SCqPLclbK3+HkMQo05Fk0EP+oT8gM3TuKTqtNBWoL6hG+JK0x9OdJTcToNHo40SV1OxsFJ9vNn2ZX4KOUmPM27tsmAHh/QUi5EEccbGSTdlDaHc/Ij6nO4ymV2gLEOFosWMvikhs+Xtd2M2HBl3ptsIOCaIVs+PdpBtJapvF6yVMB+W7+OQwkPrR+UXsGkcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:26 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:26 +0000
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
Subject: [PATCH v3 05/10] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Wed, 16 Sep 2026 10:44:06 +0200
Message-ID: <20260916084411.941297-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ed26ffcb-ac8d-4d9f-8ea0-08df13ceb6d5
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 9RQTmuk4PvvsTcPJW2/OdO30jxU9CYca3CjfHOMBJoRQOKMUhhcMTSLzqz18+XZfkmGTT+Ce2rBGcyNkMrbcXAyNlR1YqRnS/e9Pu8awuCofLLrjt0Y2oonTiuXw3hSeNOxilDeluXvVPnxGg9UZ9Bfkrg7uOXQIiWcrqEroTlRXIc6M3AGN2ZWdq/v4ms9q1yGpzlZu7kAgc5tYnC/Yv3yhsw5JL6EcL9YafmbE0RZV4DOkaeUCkPYiCJg9YZcpPgr9m0Wgf8V/SViGG9zJqMgeZEG3yKYuKDmMMbnl0wC+ONUJNcZxS0sJ1Hrxot8qKN+IqV+Rt4XzAdnjJNqSFfsAqGSqrtraDB5psXqUeYUKJG7H6Sub1KK0uapjUeyM+M7sTB7zUduoSR35jINiQ0aOdxEZ6jB40XSG2eDdIqV7XFRTXw0epEQeThPqFh+vNiTRyM4cyf1VaOL/EPA4cUiSC/2GJhEJL7cGPvWGPAUeI4mYMYyxi5jzOdphi0jKKaWfVuTPEwcQiqpQaYdzmSSuFLk0r30FMqmmLKOq1KbpkV42szCp44uu0fRCbpE4WKz3u9ihQZ8VE9RPWMbOKmI/3Yi5WRoWuVpjpWE1LO3m/33auIKg0s3vooJBruPWl7JDUiG9XmEjg7y0QnZ5H1FNSm1H+iJqWh/NJDmtXHCXIKBJtWub2+amwlZ8YX2JKun7/mr9Os8vYq9ri0oJLQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?T0RJQlFFZzZld0VwNGlxNng2aEVTQncwWGxCUEtSRjhaNGhVY0s4ZFk3dkJs?=
 =?utf-8?B?QVRUVVpxaEtGSEhMVGx5T1dEN3MwTGE2b2h0dW0vWnhpZWFzVU9yTHdUMVZF?=
 =?utf-8?B?eGx0NmxmbFYxcTJRdEovcXVxcE0ySXhqUi9Bb0NSR05WeTRXcVVNaW9Ebkdv?=
 =?utf-8?B?Y0t5cDkrU2wwaWxGaE1UUzNjM0p5dTlnWG9Gb0pZTVlTUURSWjQxNktYYUty?=
 =?utf-8?B?WjlpSFR2VklsWk9xbHJmU0NLTS9WaE1FcFN2NDFzM2t2elloT3hHZTI1MTRK?=
 =?utf-8?B?WkU3TFppaXo5ZUlZNkpSTkl4L1M5eVQ4MkhjNW9VaFJHaWl2Rm5XeUxueTNP?=
 =?utf-8?B?MjRwUWlUZHNQNDZxbm41TWdIYUZXcGZFM0IyVjNaSmZNWG16bW81VlpFeFRY?=
 =?utf-8?B?MHJVL2VMdGZKVnN0UFA1WjZZM3BlWFV0STlLcncxMHpoN25ieVJGaERtc09a?=
 =?utf-8?B?T1EzeG1ja09sakxmY2V5akcvTkc3MnpiYlhYNWVrVFMzdDlUYXFuRDkvWktn?=
 =?utf-8?B?ZGRyMC9LOXAvczV4emdrU0w1TmtmMnpabHpDblA3YjBtdlB1T2o0Q2RZWnY4?=
 =?utf-8?B?c21WcG9HMkNtZVdWMHZyd2FDRlpCT3E1MElpcVRQQ3ZWQmg3MERIR2dESWov?=
 =?utf-8?B?aWxRaVpNQmUzZjFTc2M4dFl5N2VST3RodERiUUtxL21DSjA5RGw3U0wvTXMx?=
 =?utf-8?B?VWdDbTJiaDhadTBZVE1PaE9KMmd1Q1FkOTJ1eFFtVVA4SFE1amRyYnZObUY3?=
 =?utf-8?B?T0tzK3lIT2tYMFVtN3ZJMjNCb2FSTHJRZ0tUMjVnZXZkbFFnek5DUkQ4OU54?=
 =?utf-8?B?ZTFVTCtlSHU3em1CUENPaTdSNmgzbG43KzE1T2NONzIzbThXQWRxQnQwYmhI?=
 =?utf-8?B?Z3h2bFFrK0wrUTUzWWRsS2hYTzZyakptVC9tWGUzMHZXZ1dSRVQxRHRHSEgz?=
 =?utf-8?B?V0Rpd1pEVGJtb3B6Y00rY2FOSDRldTJFeitxcjFtajR0bjJJTnA5RU1VRW5m?=
 =?utf-8?B?WEYxWWl6VDNhVDI0UGNVOE5IbzF4WFA5RXhWRlNOOWF0bFIxVnlTM2k4azdo?=
 =?utf-8?B?eUk4dHZteDRibkIwSGRLQWFPZTV6STRyck9RTGNDZ2RxQlVWUHpWVkdBSGRX?=
 =?utf-8?B?b1hOOU1jT2RvZmNLZGJhY2xuQk1HTWVBUzFnQ0hZNzRjaWxCUFp5YnNZVkV6?=
 =?utf-8?B?eVlvSXZQRmRRTGh1b1d2OFpnOXBlblFsamRwcXhQc1dxMkZkc2NXZUtWZk5O?=
 =?utf-8?B?a3hTeWd5QWs2MHUyQ004YVBERjRLZVN3M0NKWmpMYmNCa2NFM1ZJcFc1eUo1?=
 =?utf-8?B?TElPbTlOelN1VG55eVp5OW8vQmEwSmdyd1lIT3F3bDlidllwR0drVjh4UEYv?=
 =?utf-8?B?bk5QZ2pkWXVvS05jOHhJdlRTNzlkMlY4ai9Fd1VUWHlTUGhwUUFxeFdoTG95?=
 =?utf-8?B?cEZlaWJpd0l1K2FXY3ZRNmdtYkZORlRmYmxBY2NpTWRrTG1IUkdtNW5LWVVq?=
 =?utf-8?B?Q3A5Nlh1Y1EvcC8yZC9vcXpaWXV1cFFnNHdMSHhDcVZadEphRXVTc0lrRmxK?=
 =?utf-8?B?RTErekxCZDN3RTRqK1cxWkdsSzVGTmUrYWhtcFl1ZXpFa2d3aGQ4V1NwMEQw?=
 =?utf-8?B?NHZKQVdTckJyRXdRYTZKbkdCbHBxaStZeENKK3RDTEI5RGNKdUNNMVBFb0xk?=
 =?utf-8?B?cGkxejZldTBNZEhyaG9mNUMxVFJkTWV2eUNUV0grUnNodGxaRHNYTTViTG5u?=
 =?utf-8?B?TGhxdEFmUFhycC9VUkZDeC9CT0VoVERReVFwZ05UWmxZUHpaSjk0VmhzdW5j?=
 =?utf-8?B?TWdieU5RZWQ0SFNKRGhtNUwzeHk5ZXpkVEYwZVVUWjY3N2o2Zkluc2JzcFRv?=
 =?utf-8?B?NUloanRPK0s4WVpjcDRNZEFIanljZ0VIOVFHUkN2MGVUdUdCWldMVXMxNEpC?=
 =?utf-8?B?bFhEeDVxMHQzRWJkV3lld1JpYnJyaWgxU2JnS3B3c0I5b24yNkIwckw2Z1Y2?=
 =?utf-8?B?SnFZWXJmdGNGREQwNm5UcmZjUE5oMTN5bENRWXlva2dOMzZrUER0UXAyRk80?=
 =?utf-8?B?OXR6R3h1ZUE0SWtKUGNBaTZZQng0YlFoeklwNlJnbW53Tm5pYVE2OXR6QXBo?=
 =?utf-8?B?aEM5N1VvV1RrOXU3cFlHOUtNVGl2Rm5ob3FrRDRidVBDWENQbDkyc00vbUJm?=
 =?utf-8?B?QzFHKzVrR3Y1b2NTblByODlaUEN2MzNKR2tRakdJTTRXT1RqUllJa2gzS0Fh?=
 =?utf-8?B?ejcwczFyOTlLdVN4bHRodjc0eDNjK1IyNHF4YVZXN3hocGFTSTNhenRRTU91?=
 =?utf-8?B?MzBLcWVWbUk5MnNWeVRUUDRqRlE2TWx6NFB4QWV1cGVrazhmV1ZhUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed26ffcb-ac8d-4d9f-8ea0-08df13ceb6d5
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:26.2244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvnFX3nHZjesThhRVs5HTjyx/Z5fPIyLN/tOOv+nJ+i1Ikrlig5pN39kLKAAxpcSr8ZWYy2T7RlCT2/IzlMrgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
DWC-based platform glue drivers. These helpers are needed by platform
drivers that must program the controller HCLK divider and verify link state
during their vendor-specific initialization flows.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
 drivers/ufs/host/ufshcd-dwc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 0eceec543d14..7fe54923c6c6 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -39,10 +39,11 @@ EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
  * @divider_val: clock divider value to be programmed
  *
  */
-static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
 {
 	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
 }
+EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
 
 /**
  * ufshcd_dwc_link_is_up() - check if link is up.
@@ -50,7 +51,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  *
  * Return: 0 on success, non-zero value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	int dme_result = 0;
 
@@ -63,6 +64,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return 1;
 }
+EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
 
 /**
  * ufshcd_dwc_connection_setup() - configure unipro attributes.
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index d8673cd54d4c..53b523ef59df 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -47,4 +47,6 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
 int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
 int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val);
 #endif /* End of Header */
-- 
2.43.0

