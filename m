Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD74BD34F;
	Tue, 13 Oct 2026 10:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887433; cv=fail; b=rVf6JdQXjdquWSzolwfbqGrmS3RQhI4EFPryQLw7eSqw5AiVc0xbasx72hdmvnisMNGC6EZi3jRPb1kyMoLGfA7G9YjWUzm7DOtdRMELcxE0y63uGVwY5vVC1RbL9i+RKNF7nv5vBuJxSE7a0adyddgEu14bnTM9VGWrbCZ4eGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887433; c=relaxed/simple;
	bh=9W9ITzXl1amZrWaO0vw2EVw+WWAuR4qNNzb0HC7zvQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VNT0JAkG7GpzeZlo2/v/Nvxmy7bPiCZEGx6BacDnAYuNcsuX/Czvz9taIPC7bixNc6inQYUcnoxMdG/JXut1eISgIeFiYv0DslRrv9HZwdOt3sfBMJRdGTE8ss7N1GoE4Wuu17ooUlTgHnIEXHJ5tZamml+3A4QjbWKF8RYu55Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=aNFb0Tqe; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="aNFb0Tqe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0lsq19hFH5htumQouEE5GA0wyL3Y8Palwzj3603wK1vSkFzmhx+FiIJCw3oTfithv48jcC7KYpY6xNlxdkdoy+TbWvJ4XwEDP3s1D+kCat8khxEJW4kmZqcIhJ1tETWarCSl35rAx2c4r/SMbbPxdPaeLR5X4qBGf+vCwVfoCtNxCjDnP6LVqnG/vcIR1PSwBIG3CggiNgpvWLNo3qhHmxhdGxfbDct3Ar/BEefoUFMuuQrmf82zEN1+FKXnSHQbsNSDu1YWd0n+PNeKDSHHCz34Dj5YArFhU1bMN4wMtVDgVowwBVQ0ZRJpa1dvXxZdL4guCrOX0T49guz6/sWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYEzPh2HCvulMM7n8NLZihzPYqqg9U+hllx69esfCrk=;
 b=FAj7sz53MHScl9e0jhuY9282Wmrn5Uyt4lIXlr5nEiiA8NjBkW9ItmgDJbtecfO8RZJPoqhp4k+RAujs3VchRpQxoCfFdmedGRI1Ykd1h7NLz6l4ywHbgMkWzz0OVPcu+nY2zu6dRQcPpEWT428bSnOpWnMYUe3cYwkkMRsNn+UZvmlOFi8hbyJh9MgK0frh1evnUrz2gKW1MB9A8ViVyKOETrJXKVAs5JJOdnZMvxQIgfjoqwi6jWv1ewcROJqGoi+VLVMncHwIidBKptIybtCPpp/J0wPUC8rhAHwa3m2cadIMMtVL2xLibOTAPclferiPDF/pdVGYFStdRbNOXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYEzPh2HCvulMM7n8NLZihzPYqqg9U+hllx69esfCrk=;
 b=aNFb0Tqe4WtpFASR7xiGlcVk6congxvgjKtDlxHWOkNbktEQHyRUVDeSGLtgDF9lMAfHqrosrFGOVfZe34IFbwDy5CPmgPfo7KRpM3z1FtZn2YPz75qylLz0W942S4NhF3P5j9W9q0FnzilQ/n0Xs/MfatsOqW2lgxMnFMHxoBM6b4OizP8t+SVnbozKlfUGFapnYhADKw0iuD+EWNO4CYAjuSD+TLTxXKMJAbiMTxYv0+7eaBOApD69C+TY1iaoCkuIiR9pwJWTcPJMw9CHggRehwn5pt3eZW+TsbrQmN5lWHi+ce1+epvBnlGDqrYbRhCHJxSnrzMQE4T9xSBTDA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:27 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:27 +0000
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
Subject: [PATCH v8 06/12] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Tue, 13 Oct 2026 12:29:57 +0200
Message-ID: <20261013103003.373156-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9522a4fc-de20-4990-e6a8-08df2914ff72
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|6133799003|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 qNRhUNrSBCEYMy6ByTbgoWL3jCwiE2jUsyImPgzOEMLUxcx0gn3DbaXlJIPr+ptw3rOcUXQLgxOsTbJ9APSAsglqD8OJWbvePFsJZrrarAo5zTRFBIXEy7dohS1ImZlWpbc2AQuDOU2Tf1V24RVqvVVFpAEaXxdA59O3Eklepi9LtwR8oJoKYQzhSbql0O3T9xnSbDaeQvcK9Yo6UaP0d5TFCKb/ANnQ1TyqAvwO18wXBvhVV99Hmk5sgfnvQMSKi9TycynMDPCNIi15+dDzQb+g8o+KYucjGPaHkPwONopBabnPL1E0NUxkzr9So5vjQkkcMoiKlN+pu8Dje+AoBMYRu8AFyGsSGWPg2NUYtd0jEpozkkS9F9BUUH5vqX+wb09qQ9Yuk7+YJhc4YYd1RlA9e2wOtCJaXhv/RcCgDRBgpAT21BcwDC6wslPisT1uYFPb7w2wBRmyYOcQp6MzKESpEnlSbLhhnf28vWdKi6/RDcUJGXJnXDN1wfmzAXX4K4NkMdunLw+qt8WIq+3lWZfMdLnNCaRGVEk45Y3u73CIA4LMLp1vHvqKiorKpiVizvyboF2zTqNq4lzN3qlEOY8EEFBFm1LyCwWRuPWwYqbK1Dzu0LqyB/ANU6vjEei3FenyU045UAoFrSVXfmyK2cdnK84AprWgHSPX3yCzKqghnwtHlEai+shjYETgZGwr/Ndy67ejzCDbz8JwBO3kTg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bmZWMmNqYkh6d05xcTV4VHRUWjRDQ3BkRlB2Znk2K2pXUUFVM1k5dVhkRXkw?=
 =?utf-8?B?c3czTWllS2h1RXA3eXV2MytTaFdvTUszYWhPbVhFdVlmcE1OOHJHYnNlbll4?=
 =?utf-8?B?aE9CbHdRaHEwWjQyMjBkVlV0VC9BVkVnQnNZU1lqOGtzNU5mZnBic2V0QU9o?=
 =?utf-8?B?Q0RCVXVEdS92bHlHKzM1UGg2dVdzU3Q5VHk2cjdsanBmUjYwQTJSR1pBSkp3?=
 =?utf-8?B?VllMQ1JQcW9meTdOVEdkc2NmWmovZ0pYWFdDWWxaWXdQdHIzbXVBSDFIWmhS?=
 =?utf-8?B?NVFsTzhRcnBqWHJESnJJVUdGVWd0MXB1UzNmUEtBcjFuYm9uNFN2MU5keW5z?=
 =?utf-8?B?eG10ekFaajBKQSsxWm1YL0psd3VzS3BSbmV1dHd4Qklmam1jZkI4eDNtbHVx?=
 =?utf-8?B?MGZ0OHVrWG44c3J1SnlCdTIzZklVZE9sNFcyWHpWNFd5dUdwR0ZJUTFiTHVq?=
 =?utf-8?B?OThqcmxRa3VrdG95aExnNTZ0TmpSY0t6UVZKOXh3VU5NK2FkK0phWmd4ZVBs?=
 =?utf-8?B?MXdEeXEvVWpvQTFyNjROWnpNQUJKZldFOE0rTGlVUnpOQjQySm1kM25iVXlW?=
 =?utf-8?B?UGxGYVFkNmlXTGRVYTZoMDZFWnpGUWdXeDFzdjJDNXY4Y0VHTzRaVHduWEhG?=
 =?utf-8?B?cFgrdk9QZDhYcDlVajIyNlBOVjRQSHpVMExwRzU2M0FlRGVSMWpVSWwwNTJB?=
 =?utf-8?B?bStGdGd5RWpmY2ZSL3ZMemEyZDFuSkhuaUp2V0VTWnJybmRCVHpUYXJoOUlC?=
 =?utf-8?B?MkJIaEZSRTBQeUVVQjJqN2ZhWkR5ekZyaG1JMmoyQTBKWWVnKy9KZ0h1QS9W?=
 =?utf-8?B?WmxZUW0xSiszUlpjRkh4cTdMVnhGWHcxU3pVOVViY3VDSE9TVGdlaTh4a1Vs?=
 =?utf-8?B?WHBmbSswTE9uZGhtUURXNzBWYjROaUZxbVpNZjREeVVEcDlBOE9iQ1RYdkRP?=
 =?utf-8?B?a2hmRENuYWFQRXZObDFGRnBsalJiMUlqd1J5OTIrcTcveGNlTnEwSzlFejl5?=
 =?utf-8?B?aHFjSkRxVFJRVXJVbkxMem1pcnJUbkpaVWRjTWJEV0FhQ3dKbENJLzZSMEk3?=
 =?utf-8?B?dUJVU21sblpmSy9EV1Q2Nk1lZ05tNGFtcUdFaGdDYTl5Ym0xaHlmYmtvbEpt?=
 =?utf-8?B?bjRVRWZGWGpmekx5L2w5N1V0NnJqdlVFVkluMUJxR1hKWTJQZUlQYmpIMTcz?=
 =?utf-8?B?RkZIMXZoM1BqdW1SUzUyMmdnVFpkSFF1RDBsQW9YUzRqK1NrSERiT3Azb2Vu?=
 =?utf-8?B?YzBqdDlmRHBibUJSSHJZNDV1R2xTWXd6dHpvekQvSHRTYUVoNkJIeVlRa1ZB?=
 =?utf-8?B?R2wvdk1PbHZCTDd2NEdvR0NjaHdFdHFiZldYeHdQYnUzRzRlemo1cWk5Rmsx?=
 =?utf-8?B?aVB2RU9lNDBIYTJHSmp4YXNna0pLNzFZOXpLU2kzQU9EYnpoQzduV3NVT1Bo?=
 =?utf-8?B?eHlFTmdCZFVhMnlZYkZyRHY4WWwyQlVMbEJVZ1FKT0FwcTFmcUhCWGdKTXo0?=
 =?utf-8?B?RFV6WlNMZWwvT2t0cGl3aCtBaWdpUDZnNTYwcVZ1Lzg4eXJ4N2NTMnVXemdI?=
 =?utf-8?B?bnFjTlQ5OHFhTTRMZVQzOGtvdFBhNHB4NGpWUDBTeDBtdE44dm0vRWdPMzMz?=
 =?utf-8?B?YlZYWlNLWWc0NkdOV09DYnFRQUpqOHVXYTNub1pta2d4eUpEZDlvNmJYcWFM?=
 =?utf-8?B?dmZMSFNDQnlQRG9HZk5wV2V6cURjSnJDQ09SVmtOc0cvcWNoYnZqRHlNTWpC?=
 =?utf-8?B?NW1IZHlBOUJMVlkxTWRTRHROVE5HWTdFUllzeHZ5V3NpWUk4OUowN3AxK1Bj?=
 =?utf-8?B?Ry9sMEFyUVZXT2EzTlNGVDNSblNEVlZPRXZldUNMbHlOWElQV1BoSUxEaWZ2?=
 =?utf-8?B?L2ViV0owWkNySnh3cDVycTE1RFFtT0h1YklIdFNkLzUwRWtUNzZqbDZMR0J3?=
 =?utf-8?B?V1FTdldrSnBYYVJxVFJ1Wnpsd044c0Y5aFg3RVd4dk94K3lpbUE1bXROUFli?=
 =?utf-8?B?L1hISGlCRlRObGlGY1hPanNIYzJ6VFRqdkkxYkk1QWZNbStDOTAxVXJvYkxH?=
 =?utf-8?B?WEIxMzBXdXU0WDdtSDcwNnZ2ZlBPSG50RVE5dWJ0RDFGSmd1akJ6ckJtYnpT?=
 =?utf-8?B?T1pPdUx4YjQvT1NvSVNJWmVCbEk1WkRJT3l0bkZLZ1h5cGNjSUlTV1E0OTNx?=
 =?utf-8?B?UmlxQVpnNkIwQVZwS1NxVE1GL0g0WHkyYkdPUFVTa2pybzJGekdrUkIyTUdU?=
 =?utf-8?B?UGVVRkFiUzBsZDdqS2NjazczRnp3OUgxZ3ZUVVhYbDA3RVN5TDdWWlY4SjBH?=
 =?utf-8?B?cGpNOWNwdEVSY21NVGNTTncrUDVYOVZDNG9nQWxVWG92SnE1M1pEUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9522a4fc-de20-4990-e6a8-08df2914ff72
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:27.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klY9q7VtNxn5+6g5av34rF3tJaUgzll1aMC/mVPi5iqeXTYWri7zGdzu0DoL3bcA/+NAMaAVeTey62ASBqrKcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

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
index 20b7174e9498..037b99d1148c 100644
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
  * Return: 0 on success, a negative errno value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	u32 dme_result = 0;
 	int ret;
@@ -66,6 +67,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return -ENOLINK;
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

