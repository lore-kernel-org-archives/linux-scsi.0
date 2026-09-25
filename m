Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013052.outbound.protection.outlook.com [40.107.162.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C94ADD96;
	Fri, 25 Sep 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347012; cv=fail; b=aihDh//nAiU4X8V9PbWXuctYLNR3scBk5a1R9aH0UMODVQ8XhQEf13Wj+NmOVdXRl1n9MTZ5eOdnuZCYFENT5B2ThW8S3hdgwKT76EuyMJIgOy0KeC5yabHo8g5gaxc74vcBWerT4rf2WnuLZn14OYhfA/LAM2ke9rHWeQUMOKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347012; c=relaxed/simple;
	bh=LiydfnBSCbaC6ctdXNoUtIqguXL1GmghnZ76b6Rwoao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t+MUKRFrpto0l4qKTdmY+j8h46pvqIBq+J1eVOZWq3kvMuVo0xVXvABnGaY26wpr/sKSZRzS51DMKWGut/MU0dm3Ae2twTxmN5/4dUjNuOisKdIO3SOJ6m0Dnr7mapMjsGpta867JKxrXI3Oc6Y5Ur1AyeQr62qtzw9hOT1Cct8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=s+Rt/CZF; arc=fail smtp.client-ip=40.107.162.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="s+Rt/CZF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rd7wvHjSQoASXkOwJtuieFQbGDrH2ST2/YRkABzhbSMiMP7L+Ro3bsaed61YIHbZ45itec1P7Y+tgN49HexquIuOtcS7JcH13uOx1/NRGR2G3N/tS9P1Vws5AqpdLA05w4OoMMaMETv+vOdlVU6jCBbN09OLUohifbd7hSd8uWQWxg7u5oxNSvgQxs2eWHJkuRGvHlXlL8yocgB0KTNns1b3l0qqoJl8VhKdGw6S0migYzdSRj4a9RNUp2qA0p94VZ24z8UAJhQsaiU0pQyCgxNXSMm8nnvErZcNdJLYND0YfLIIMqktmU48ECdnq4s/ACaJFEPlCY/NU697S0M/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5JTGofH6bI4hQoWyiJFS4BdifH4FuCvsp59ipl+eAw=;
 b=jzGDwJUG2moR3iFIoGWJDn3YW3o9pwkYADJBdrFKP3a7uTnaWNzuXdo3VoLxrdzHPlQidNsX3hEOa9UwckFJ8JSzHxXUeg7J2yAMz7pBUD9EtTKMLS+m/uqjY7GasyhRF611hEf55VZcoLTOiTFco83ZQu+rxkffE3UJ6g15XDPsTqmFsn1CMuLyJEeepS57akt3kLH8PdVs4U4Bys0Rpkavxbi6goCFVkrnpg7ndnLrvtY9YR3+YFsdbJwVNyjvpq0OWOwwkIFAbCBGajRM6nHUyp0kTRQCkIxKbBrL6kV1lFXbSeyk+tM/XH/wsdolqGEDLMaqGT+2FsdQuqxYmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5JTGofH6bI4hQoWyiJFS4BdifH4FuCvsp59ipl+eAw=;
 b=s+Rt/CZFXKyVzY99rwCD1bTYoUD6E38AjM5Cqb9uO5Mhg09MhNv9TgHnp8s6eZzPw7XNX0IYFmvjencrOjKb3ZIS7tVwBS7rrBROMJtc9le1sflMF4Nl3adw4YKcQjmjSaOsPjQMvvLAaW66Icjk0LqJMSDIFjOEGqxg9WU18sLsYKziI6SXDVbxYqFbEeXrneCAYw/DP4LzGvUDhsCEkkRlQw8yX/N4TDwO7jsS4iqgGa7QtYDibJ8VMj8HzJPcel6jjJxsTHpFu+tKCjcKYe4VxF0CiOYK707BbjZa0w4ACQwLjogSYCsSHRYDDyfaDS7bDJq7NsJQBkDm9rlAHg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:36:02 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:36:02 +0000
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
Subject: [PATCH v6 09/12] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Fri, 25 Sep 2026 16:35:31 +0200
Message-ID: <20260925143534.3298540-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|BR2PR04MB800621:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b9a8a55-e369-479e-6534-08df1b1252ad
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|6133799003|3023799007|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 WPTuDvLKFNt970CGGEAP4LlfR0UMEzb4P+KS1Z9Im3SJD44Qd+t4cSp+LzkDEd6r71lIk6HVdRx9i9YaIKGQsbNQUUXr+QUgYMIn26vz3PYZQfavFQWzBivmU4Yc19aFlnfJq6zPt4jC4c7fUmHHFrT9XYpMzgEaoL1jvy0hWVDJyu2uopPYqoUH2p39bSB9+sOOG4gbvSIHH6CCWI7CkbKjghB5KcEGoecSmcRWe6fQiigcTGONxWLWH2YWCdsw4/6/ZU2aANxxNyGdDJrTa/QmYgbf/VdLWgntRqZVgHr0Jle5RQ661sfReSaC+D4pPNyUF5n8wlHWEorJ3hK70MfWhWU9nhsczP+v4AVLIcu46+CLTiYiCJKBZnkIA6H7vJU+z2aPc5w5BtkcAUwG2IxB9ScI8DTYGt1ilXyR0msCkO5/v1nZ+6x+1IRxlQlPkx2V10/8v+qYrqVAZxN9NsqCl751BHSR/slAYaXhVLwWj1ZR6VklvJbQBXSJooHoNUTJ7ILc2pfjg3MUPXmb2mVrADesiPH6/SH6O1RwTvI8BVTZzeBogq01Oo17rxjyMBxqUDwMlBl2lFvKZoz4OV/5iB/s4QMl11a2B1UiEORX8MlgsTaE4EJoqSwyFYJOI70vXVR1vNzHkUohU3gWJMmZ6i5DUjtgs/mA61b6Yz6/L+shzG1+0vSkASOk7cN2mF2G1qiT2ipxRIw6NUiZ8g==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(6133799003)(3023799007)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MWRwam12eFE1UTh0aXgyU3h4S2lyK0MvUmp1V2ZiK0tPQldHOGRDTHh0NDl6?=
 =?utf-8?B?Y1lLRklMSFFyQlBUVGlwMzRHb0ozYytYVTM4YVNiZGhRS2l6dEE1REk2ZFB0?=
 =?utf-8?B?bDVMSDJQNmlFWG90QUlhZlBlU29NdGtUdVdoQnZSRDdOMm1IU3lJUllCcnpP?=
 =?utf-8?B?Qk9QZldzREdKeklOM2UvenpFbmJ3eG5oZzdLWU9mS3RqcENaU0dFb0RnNlll?=
 =?utf-8?B?RTRaL1h0SnR3RitxemtDeitZWlFwUGt4OVpxUExCVlhWQ2wzNTA1QTRRNTNE?=
 =?utf-8?B?K0E4dlpIVG1nMkQ4SUtNV3FzQzVkVEVNR0pkVGNVUzlDaVpSbE5BcGdWTHo3?=
 =?utf-8?B?WU0yMXJMcUpqOVlLZTdxMFJVTnRiZ0lqMEhtdTZleG15VEpUeS84RVpOUVBJ?=
 =?utf-8?B?QWppKzN2b3NYSUY2MWs2QWdyeCt5WWk5RWtVQkgzUGxnVkppcGR3TkpVVlp3?=
 =?utf-8?B?T3BOaU1pS2t1Y2JPQkZlcFhsSEY3QXYwYTBJdVVxZWduWU5mTllzTk1FMkJk?=
 =?utf-8?B?bjVNd09YRE5peVNSTWNNdi96M1BMNkZ1RDlHZnByYm1QL2VQQzJROFRYSXVI?=
 =?utf-8?B?VFRHL0dxSW43UGFobi9keGplQzNDWTVWdXJ2MVRVSzNrMGR0QktWOTVycFJT?=
 =?utf-8?B?VGRaWmRIODJIY05qUk4wSkZnSWI0UWE5T1RmbE9DOTV4QmFoc3dSS3FQTHd5?=
 =?utf-8?B?SmVqYnF1bGo0OExFejZySXZVcjNvbUVvclR5K2xFYTkxZUpjZTZWR2gxTWxN?=
 =?utf-8?B?eHB2L2VLVDFjaGRGamZsdXI5b2ZoZktjWkNuQkY2QmVzdHgyWDJuRHd1MUpl?=
 =?utf-8?B?YlR4cGlJYzFaY0JPVDhFRWlBU3RpMHJEbUhGMmRZL0o2MWZoZWR6aUwyTzRT?=
 =?utf-8?B?bE1zOXQrZmJUV1RvaHBUVnVsbVpheWR4bWxGengrVndtb0xyLzgrQi9KKy9V?=
 =?utf-8?B?QTJoQkF5RE1aZGx2U0Fnc1RScWJDam1MUndadlB0M0VEUzF1QURUVTMzUDYr?=
 =?utf-8?B?UVpMeGtJekJCaTY5OE9ZMTBQbDF6SHYzNVJYeU5IUmVHWE1jWHF6NmRxQ0Zj?=
 =?utf-8?B?NDcrSW9NYzQzVUNuT1VhOFZxRG5oeDVhV28vV0pqS1M4OGgyLzJZdGtwakNs?=
 =?utf-8?B?Y2Y5SXY0MlQ5MWpPRTRrdHhPbmlrV05QWTZqaXlycTNNUjIxL0JHMHpFWVl6?=
 =?utf-8?B?R0VCL1h6YldSMjQ5NWlmZnpGZENtMzU3T3NlOG5JaUVwYWVlY1Y3emJlbjRa?=
 =?utf-8?B?WXVkUStvU3ZSMVlqMGJ5VU5Ta25KcFpuODY0NG1nU1pEK1pQbEg5YURlNXBU?=
 =?utf-8?B?K2JpRE9JRzl1ai9DUFRvNUxJdDY4V2V3T2llZG1HZXQ1RUdxaWx0c2g5Mlk2?=
 =?utf-8?B?Q2VWVlpBZm5lcnRiajlWTC9QRDM0dGp6UlJQZmZxV0ROY3JzRDZVL1JvcHhZ?=
 =?utf-8?B?ZkFZRmtHOFdma2NBdTFWQm02T1hTemRhWStGOHZjWC9rNlZML1Fva2tmcndP?=
 =?utf-8?B?aTRyY1FIZzV2cWswUEdDUEVxeHl4YXhnSUVPMCtLMC9mdE9SckJydUROdWtO?=
 =?utf-8?B?SitGQ1VLaFFGeng3SlcxTE1xY1o3MDE3c1h4NXdnNmpuSFZML0tBenZsN2dy?=
 =?utf-8?B?eDZ0WGdUUm1GNlI5NWpDQXlYTit3OWt3cVhXRXBEcjIxc2hacG9WMTJtaFNE?=
 =?utf-8?B?S2tBd3l2K2t3RktnQS9FNm9VdzNwbW5YZnhsRXVRVkVxckFBVU1aWktQYkVQ?=
 =?utf-8?B?QUMyTnVKTXZiZDQ4VjJpd3p3bEt0dCtJOFp1cnpYVERPQ0RObkQ4M1pPUUpj?=
 =?utf-8?B?YUd1bjEyZEV1UDFqWEV2ODBNcnFwbDdmR2dPaGh3U3ZTbTgvNlI4OU52dFow?=
 =?utf-8?B?NmxlWkRIWSt5K2hVaWRaampraWFaQzV6VldpTTlubHo2N3p6RHRWTUxjTWpO?=
 =?utf-8?B?UFJ4MVVlRHRCTmxuNExOM3lFY04rbkNiVDhDdjB0aktXZ1plaFVWclNiNVkw?=
 =?utf-8?B?dng2dmNSRE94Mmx0WkNHNVFLQnoyWmthaTg2aEF6UjBDYjB0NEwvSmZRNlhW?=
 =?utf-8?B?cVhTMTJpZnZsMXNqZitaTGUwcEJFdXNqcmo4aFZacDY2RU5qWXdIa3I0MDQ1?=
 =?utf-8?B?bFBOWmVldUd1S3FjcFZvZzJabkpDYjVFbW9pVzU1ZVJtZjV2bm9jUEw0S0kz?=
 =?utf-8?B?WFIxclBsaTd5alMzVlcxOFIwT0lRSG5tMDYyWklzQnhNQ3FxcXdSbFBxbzhQ?=
 =?utf-8?B?VjJaRi9vbUNkVVVYaThFakRIcXVlSitGWU1jV3JaZUVXeSs3QmJkOVY5S2Iw?=
 =?utf-8?B?TFFaVGdqZ2g4Y0dpQXJremJOK25kREpaY2ZyWmhSbllmR244U1RIQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9a8a55-e369-479e-6534-08df1b1252ad
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:36:02.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OId2hxJtHfYtjnASnUgM8PLyv24VCJAepXXijEOYqFeT/fkDLa0IZpsi8kVbWZhgX6jgeXHkrQk2UorGkFfbWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue.

This controller requires S32N79-specific initialization prior to
UIC_LINKSTARTUP, including:
  - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
  - applying the vendor-defined M-PHY calibration sequence, and
  - performing post-link calibration steps needed for HS operation.

The M-PHY supports several boot modes for loading its firmware. Only the
mode where the firmware runs from the internal ROM is supported for now.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/Kconfig         |  12 +
 drivers/ufs/host/Makefile        |   1 +
 drivers/ufs/host/ufs-nxp-s32n7.c | 546 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |  10 +
 drivers/ufs/host/ufshci-dwc.h    |   6 +
 5 files changed, 575 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..e8ee7dd05f1a 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_S32N7
+	tristate "NXP S32N7 platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
+	help
+	  This selects the S32N7 specific additions on top of the UFSHCD DWC
+	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
+	  specific configurations like PHY and vendor specific register accesses
+	  before accessing the hardware.
+
+	  Select this if you have UFS controller on an S32N7 based board.
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 7d8db67eb23c..a2f4a1d0b3ae 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -4,6 +4,7 @@ CONTEXT_ANALYSIS := y
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
new file mode 100644
index 000000000000..f7a017a6d9ae
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,546 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
+/*
+ * Copyright 2026 NXP
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+/* SCM Register Offsets. */
+#define SCM_ONE_US_TICK			0x2CU
+#define SCM_STATUS			0x30
+
+/* SCM_ONE_US_TICK Register. */
+#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
+
+/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
+#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
+#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
+#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
+
+#define SCM_STATUS_PHY_RESET(val)		\
+	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
+
+#define SCM_STATUS_SRAM_BYPASS(val)		\
+	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
+
+/* Driver-defined upper bound for the M-PHY SRAM init to complete: 3 s. */
+#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
+/* Driver-defined poll interval while waiting for SRAM_INIT_DONE: 1 ms. */
+#define CFG_MPHY_INIT_POLL_INTERVAL_US	1000
+
+/* Clock validation limits. */
+#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
+
+/* CPort definitions */
+#define CPORT_0				0
+
+/* Driver-defined upper bound for completing a Hibern8 transition: 1 s. */
+#define HBRN8_POLL_TOUT_MS		1000
+
+/**
+ * struct s32n7_phy_reg - PHY CR (config-register) write entry
+ * @reg: Register offset/address
+ * @val: Value to write
+ */
+struct s32n7_phy_reg {
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct s32n7_soc_data - SoC-specific configuration data
+ * @vops: UFS host controller variant operations
+ * @reset_config: MPHY reset DME attributes (programmed while PHY held in reset)
+ * @reset_config_count: number of entries in @reset_config
+ * @calib_mphy_disabled: CR calibration writes performed while the MPHY is disabled
+ * @calib_mphy_disabled_count: number of entries in @calib_mphy_disabled
+ * @calib_mphy_enabled: CR calibration writes performed while the MPHY is enabled
+ * @calib_mphy_enabled_count: number of entries in @calib_mphy_enabled
+ */
+struct s32n7_soc_data {
+	const struct ufs_hba_variant_ops *vops;
+	const struct ufshcd_dme_attr_val *reset_config;
+	size_t reset_config_count;
+	const struct s32n7_phy_reg *calib_mphy_disabled;
+	size_t calib_mphy_disabled_count;
+	const struct s32n7_phy_reg *calib_mphy_enabled;
+	size_t calib_mphy_enabled_count;
+};
+
+/**
+ * struct s32n7_ufs - S32N7 UFS host controller data
+ * @hba: UFS host controller instance
+ * @reg_scm: SCM register base address
+ * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
+ * @soc_data: SoC-specific configuration data
+ */
+struct s32n7_ufs {
+	struct ufs_hba *hba;
+	void __iomem *reg_scm;
+	struct clk *core_clk;
+	const struct s32n7_soc_data *soc_data;
+};
+
+/**
+ * ufs_s32n7_phy_write_sequence - Write a sequence of PHY registers
+ * @hba: UFS host controller instance
+ * @cfg: Array of register configurations
+ * @count: Number of entries in the array
+ *
+ * Return: 0 on success, error code on failure
+ */
+static int ufs_s32n7_phy_write_sequence(struct ufs_hba *hba,
+				       const struct s32n7_phy_reg *cfg,
+				       size_t count)
+{
+	int ret;
+	size_t i;
+
+	for (i = 0; i < count; i++) {
+		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
+		if (ret) {
+			dev_err(hba->dev,
+				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
+				cfg[i].reg, cfg[i].val, i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static unsigned long ufs_s32n7_calculate_us_tick(unsigned long clk_rate)
+{
+	return clk_rate / USEC_PER_SEC;
+}
+
+static int ufs_s32n7_configure_clocks(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	unsigned long clk_rate = 0;
+	unsigned long one_us_tick;
+
+	clk_rate = clk_get_rate(ufs->core_clk);
+	if (!clk_rate) {
+		dev_err(dev, "Failed to get valid clock rate.\n");
+		return -EINVAL;
+	}
+
+	one_us_tick = ufs_s32n7_calculate_us_tick(clk_rate);
+	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
+		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
+			one_us_tick, clk_rate);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
+		 clk_rate, one_us_tick);
+
+	/*
+	 * Configure the micro-second tick rate generator based on core
+	 * clock rate.
+	 */
+	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
+	ufshcd_dwc_program_clk_div(hba, one_us_tick);
+
+	return 0;
+}
+
+static int ufs_s32n7_hce_enable_notify(struct ufs_hba *hba,
+				      enum ufs_notify_change_status status)
+{
+	u32 reg;
+
+	if (status != POST_CHANGE)
+		return 0;
+
+	/*
+	 * Clear the DWC low-power gating (BUSTHRTL) so a doorbell write can
+	 * wake the link out of hibernate. LP_PGE (generic low-power) and
+	 * LP_AH8_PGE (Auto-Hibern8) both reset to 1.
+	 */
+	reg = ufshcd_readl(hba, DWC_UFS_REG_BUSTHRTL);
+	reg &= ~(DWC_UFS_BUSTHRTL_LP_PGE | DWC_UFS_BUSTHRTL_LP_AH8_PGE);
+	ufshcd_writel(hba, reg, DWC_UFS_REG_BUSTHRTL);
+
+	return 0;
+}
+
+static int ufs_s32n7_phy_initial_calib(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	int ret;
+
+	/* Calibrations that must run while the MPHY is disabled. */
+	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_disabled,
+					  ufs->soc_data->calib_mphy_disabled_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Calibrations that must run while the MPHY is enabled. */
+	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_enabled,
+					  ufs->soc_data->calib_mphy_enabled_count);
+	if (ret)
+		return ret;
+
+	return ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+}
+
+static int ufs_s32n7_link_startup_pre_change(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	int ret;
+	u32 reg;
+
+	ret = ufs_s32n7_configure_clocks(hba);
+	if (ret)
+		return ret;
+
+	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
+	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
+
+	/*
+	 * The M-PHY firmware runs from the internal ROM:
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
+	 */
+	writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* MPHY reset configuration: vendor attributes set while PHY in reset. */
+	ret = ufshcd_dwc_dme_set_attrs(hba, ufs->soc_data->reset_config,
+				       ufs->soc_data->reset_config_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Release PHY_RESET. */
+	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* Wait until SRAM_INIT_DONE = 1. */
+	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
+			reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
+			CFG_MPHY_INIT_POLL_INTERVAL_US,
+			CFG_MPHY_INIT_TIMEOUT_VALUE_US);
+	if (ret) {
+		dev_err(dev, "UFS MPHY init not done!\n");
+		return ret;
+	}
+
+	/* Start of initial calibration */
+	ret = ufs_s32n7_phy_initial_calib(hba);
+	if (ret) {
+		dev_err(dev, "UFS MPHY initial calibration failed!\n");
+		return ret;
+	}
+
+	/* End of Gear1 settings */
+
+	return ufshcd_dme_check_tx_hibern8(hba, hba->lanes_per_direction,
+					   HBRN8_POLL_TOUT_MS);
+}
+
+static int ufs_s32n7_link_startup_post_change(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val cport_setup[] = {
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_IDLE, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
+				CPORT_DEF_FLAGS, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_CONNECTED, DME_LOCAL },
+	};
+	unsigned int data = 0;
+	int ret;
+
+	/* Network layer: set Local DeviceID. */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
+	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
+	if (ret)
+		return ret;
+
+	if (data != CPORT_CONNECTED)
+		return -EIO;
+
+	return 0;
+}
+
+static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
+			     enum ufs_notify_change_status status)
+{
+	int err;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n7_link_startup_pre_change(hba);
+		if (err) {
+			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
+			return err;
+		}
+		return 0;
+	}
+
+	/* POST_CHANGE */
+	err = ufshcd_dwc_link_is_up(hba);
+	if (err) {
+		dev_err(hba->dev, "Link is not up.\n");
+		return err;
+	}
+
+	err = ufs_s32n7_link_startup_post_change(hba);
+	if (err)
+		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
+
+	return err;
+}
+
+static int ufs_s32n7_pwr_change_pre_change(struct ufs_hba *hba,
+					  const struct ufs_pa_layer_attr *pwr)
+{
+	/*
+	 * RX rate-select override sequence: assert the override, then deassert
+	 * the value, then drop the override enable so normal operation resumes.
+	 */
+	static const struct s32n7_phy_reg pwr_change_phy_regs[] = {
+		{ RX_OVRD_IN_1(0), 0xc },
+		{ RX_OVRD_IN_1(1), 0xc },
+		{ RX_OVRD_IN_1(0), 0x8 },
+		{ RX_OVRD_IN_1(1), 0x8 },
+		{ RX_OVRD_IN_1(0), 0x0 },
+		{ RX_OVRD_IN_1(1), 0x0 },
+	};
+	u32 rate;
+	int ret;
+
+	/* Rate change only applies to the HS power modes. */
+	if (!ufshcd_is_hs_mode(pwr))
+		return 0;
+
+	/*
+	 * Select the M-PHY rate (rate series) that matches the mode the core
+	 * has negotiated with the device.
+	 */
+	rate = (pwr->hs_rate == PA_HS_MODE_B) ? CB_RATE_B : CB_RATE_A;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), rate);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Apply the RX rate-select override now that the target rate is set. */
+	return ufs_s32n7_phy_write_sequence(hba, pwr_change_phy_regs,
+					   ARRAY_SIZE(pwr_change_phy_regs));
+}
+
+static int ufs_s32n7_pwr_change_notify(struct ufs_hba *hba,
+				      enum ufs_notify_change_status status,
+				      struct ufs_pa_layer_attr *pwr)
+{
+	int err = 0;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n7_pwr_change_pre_change(hba, pwr);
+		if (err)
+			dev_err(hba->dev, "Power mode pre-change failed (%d).\n",
+				err);
+	}
+
+	return err;
+}
+
+static int ufs_s32n7_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s32n7_ufs *ufs;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufs->hba = hba;
+	ufs->soc_data = device_get_match_data(dev);
+	if (!ufs->soc_data)
+		return -ENODEV;
+
+	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
+	hba->spm_lvl = UFS_PM_LVL_5;
+
+	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
+	if (IS_ERR(ufs->reg_scm))
+		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
+				     "ioremap failed for SCM registers.\n");
+
+	/*
+	 * The core reference clock is not managed by the UFS core (the DT node
+	 * has no clock-names/freq-table-hz, so it is never added to
+	 * hba->clk_list_head).
+	 */
+	ufs->core_clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(ufs->core_clk))
+		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
+				     "Failed to get and enable core clock.\n");
+
+	ufshcd_set_variant(hba, ufs);
+
+	return 0;
+}
+
+static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
+	.name = "s32n79",
+	.init = ufs_s32n7_init,
+	.link_startup_notify = ufs_s32n7_link_startup_notify,
+	.hce_enable_notify = ufs_s32n7_hce_enable_notify,
+	.pwr_change_notify = ufs_s32n7_pwr_change_notify,
+};
+
+/*
+ * MPHY reset configuration: vendor DME attributes programmed while the PHY is
+ * held in reset. Programs the reference-clock, RX squelch, RX Rhold and
+ * CR-parallel control attributes.
+ */
+static const struct ufshcd_dme_attr_val s32n79_reset_config[] = {
+	/*
+	 * Disable reference clock gating support and override the UniPro and
+	 * application reference clock enable inputs to 0.
+	 */
+	{ UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x8A, DME_LOCAL },
+	/* RX squelch control. */
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN0_RX), 0x1, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN1_RX), 0x1, DME_LOCAL },
+	/* RX Rhold control option. */
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN0_RX), 0x2, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN1_RX), 0x2, DME_LOCAL },
+	/* CR parallel selection. */
+	{ UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1, DME_LOCAL },
+};
+
+/* Calibrations that must run while the MPHY is disabled. */
+static const struct s32n7_phy_reg s32n79_calib_mphy_disabled[] = {
+	/* Bypass RX AFE calibration. */
+	{ FAST_FLAGS(0), 0x4 },
+	{ FAST_FLAGS(1), 0x4 },
+};
+
+/* Calibrations that must run while the MPHY is enabled. */
+static const struct s32n7_phy_reg s32n79_calib_mphy_enabled[] = {
+	/* Write ATT offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x8E },
+	{ RX_DAC_CTRL(1), 0x91 },
+	{ RX_DAC_CTRL_SEL(0), 0x1 },
+	{ RX_DAC_CTRL_SEL(1), 0x1 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* Write CTLE offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x71 },
+	{ RX_DAC_CTRL(1), 0x7F },
+	{ RX_DAC_CTRL_SEL(0), 0x2 },
+	{ RX_DAC_CTRL_SEL(1), 0x2 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* FW Calibration configuration. */
+	{ FW_CALIB_CCFG(0), 0x100 },
+	{ FW_CALIB_CCFG(1), 0x100 },
+};
+
+static const struct s32n7_soc_data s32n79_soc_data = {
+	.vops = &ufs_hba_s32n79_vops,
+	.reset_config = s32n79_reset_config,
+	.reset_config_count = ARRAY_SIZE(s32n79_reset_config),
+	.calib_mphy_disabled = s32n79_calib_mphy_disabled,
+	.calib_mphy_disabled_count = ARRAY_SIZE(s32n79_calib_mphy_disabled),
+	.calib_mphy_enabled = s32n79_calib_mphy_enabled,
+	.calib_mphy_enabled_count = ARRAY_SIZE(s32n79_calib_mphy_enabled),
+};
+
+static const struct of_device_id ufs_s32n7_match[] = {
+	{
+		.compatible = "nxp,s32n79-ufshc",
+		.data = &s32n79_soc_data,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
+
+static int ufs_s32n7_probe(struct platform_device *pdev)
+{
+	const struct s32n7_soc_data *soc_data;
+
+	soc_data = device_get_match_data(&pdev->dev);
+	if (!soc_data)
+		return -ENODEV;
+
+	return ufshcd_pltfrm_init(pdev, soc_data->vops);
+}
+
+static void ufs_s32n7_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_s32n7_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	= pm_ptr(ufshcd_suspend_prepare),
+	.complete	= pm_ptr(ufshcd_resume_complete),
+};
+
+static struct platform_driver ufs_s32n7_driver = {
+	.probe = ufs_s32n7_probe,
+	.remove = ufs_s32n7_remove,
+	.driver	= {
+		.name	= "ufs-s32n7",
+		.pm	= pm_ptr(&ufs_s32n7_pm_ops),
+		.of_match_table	= ufs_s32n7_match,
+	},
+};
+
+module_platform_driver(ufs_s32n7_driver);
+
+MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
+MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 1abf2b1deac4..d62cd4c085ba 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,6 +13,8 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
+#define RXSQCONTROL		0x8009
+#define RXRHOLDCTRLOPT		0x8013
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -27,7 +29,15 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
+/* CBRATESEL: 0 - rate A, 1 - rate B. */
+#define CB_RATE_A		0x0
+#define CB_RATE_B		0x1
+
 /* M-PHY registers */
+#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
+#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
+#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
+#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
 #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
diff --git a/drivers/ufs/host/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
index 6c290e272106..c66f33391b65 100644
--- a/drivers/ufs/host/ufshci-dwc.h
+++ b/drivers/ufs/host/ufshci-dwc.h
@@ -12,9 +12,15 @@
 
 /* DWC HC UFSHCI specific Registers */
 enum dwc_specific_registers {
+	DWC_UFS_REG_BUSTHRTL	= 0xC0,
 	DWC_UFS_REG_HCLKDIV	= 0xFC,
 };
 
+/* Low-Power Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_PGE		BIT(16)
+/* Low Power - AH8 Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_AH8_PGE	BIT(17)
+
 /* Clock Divider Values: Hex equivalent of frequency in MHz */
 enum clk_div_values {
 	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
-- 
2.43.0

