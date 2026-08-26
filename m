Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085F9435537;
	Wed, 26 Aug 2026 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751682; cv=fail; b=MntcRyUkAWVQYCFhb9P+VaTPVc24gqEwiM26cLMDTI32yIBY9Hz4jBawpOMnTFLZT3CHUsBaR22v8+lkcIgovCFTLTSqCFgwGsKMORw2zUiQqEjSB/Hal5IS5Of2t/OWkubwQn/Rfo1l2hlyyNchjYPtkyai+zC0Oaj9kM6HBFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751682; c=relaxed/simple;
	bh=SnH0QB5H8TiKNUVEwEWVGb5fKfv2fgAfLJR4nGbh6yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Es6O9xv5l7bKN+4HKomVpL4rB2GCKH1ycKFMgeSt5N8P/wR8uc+C6DY5sbrCATyDW+gV66KpgsqY4cqghRDGVZOWm409qkkOWmOhCu+OQu24rUmRi+ZTDooS099vI8rssWv44FIxL7rbwAkGu0I7dmcQGJlxeY77EiF2F858ZQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=beDh16TU; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="beDh16TU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xg1Th6rkvSKlLziuVfPnfdwNFY9XWovQBlhujk8R4T73AhS2fCBufwbsK8+AddTxC+aCdC1wN/7r1uUddpd8+yq/m6BBXusIogwh0Hy6+/Gpn0ec27Uoyamu+8zlLUugNxhW1EKXUrj5tns0w1aSMVRXtbxUtBGIG35mJYm9Nvw5m76Kcz3YkvQiG3SNY/zF93oP2/HlaHDa9HjEzlcB5gSiXVR6KcFWb55LcsBOqiOwErXsrV1yk4BTHeNJvqRZ6P+nh3aSzhMdd2Kun9Y4kW2gb7NmGJGt8iJncLOSwE/0yt5oC5ed3PqYYRu/JMM5KW2VpKeHdBc2gh6lZ2qFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAvOtGO6ZIr5gVmKyEZHuuBkbeiVFbXIs5EqZR4RwFc=;
 b=nGSN7azlwofbnXO24/qOqKYsgsuBDhITcXjnepran2owDKrXaTUAUqTesZtMqOY4HA63kUBPJu7RlO/UWhFqsdPPGaVibz1JoAq3RItFDJeq4eQIY5ncMxAjcoVjoD7YKWITuzOD72LgtKr5QB1CI65UKXB8CCmBLUK5dexLqHvTCou97d4CVTt5Qk7HzmuZykiHcDl1fIkim1Vfkx50ptOixCXrQ1AY/pw0xV2/mplUk3vASZCLGFDoVt7tRbizonzYusOEhiLuMoel2iNdcfbdwIVsN/y+ZLRtxZzFNmP98KUgizvEHId53MOVh//Xj+NfFYxXutHvodeW4Dvq1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAvOtGO6ZIr5gVmKyEZHuuBkbeiVFbXIs5EqZR4RwFc=;
 b=beDh16TUx1hKkosc74Qi9NT+A1GD4x7NwfFc6U8dDcSTM+KCV3ZbA0DCPG1/YoUXfZJueqH5CnMjfor4wl6VP7RL8rERWPKu9scSbnsEae5E8NefmTXQW7mCekMcWwVoRJXBaiOK10dPUpNRvtAHSlELmm2r2XPzMrQ2dWqXWtBlDroT+qr7aAqf0Y3Qb0RE5bO89x49Qqw8z/ZOiFJU9iU7BDMcbNsJwMX6nofipj9tEonZdn59/qxyttnW08uzkV/EXe6oKCWcxjrS+cWzcXL+WmIa6+RCeE2vRMc/T/gXEy1wBxpOSGWtAsUhAO2UVeTIBo1YDcNjAla2fDsbGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:41:06 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:41:06 +0000
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
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 07/10] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Wed, 26 Aug 2026 15:40:45 +0200
Message-ID: <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0429.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GV2PR04MB11862:EE_
X-MS-Office365-Filtering-Correlation-Id: 785e1f6a-239d-4a14-ff1e-08df0377ae03
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Y0Ua4iCWyU8J5aqlgaP+RVGHqHSZR+tmFJAg2XdUpd4G3EU4cQ+XgmyipHIQ9IYZ2kyB6eTXpz4OWrKnYoocNYxW8+PBN4RMQySsh0+xwGIMNfjoZ1u3bGYBj82wKFDK+Bvzg8V5r1HuGDJyQ+g2UpIKUiiUQ0eFY0QxpHoSSwQKft2G+7D4cFp0mqCoI4rxkUQCKmXWvexW8WxGHsRkv6RiQC3b/ORjGjzW7EIqffA+mCmLWZCwO0D0OEm8KYN4hoYnQzP8cUoVMcWEw4ilAsl2PaR9daJs3TqFG3nqxj/bAeVPkiG5eeR98dI40Scy16vUHQ7xHtRPhEcg6fbfY6X/Yv8fAio29XCoqQPmmuPvbsEeCy+VHdKYcpny6xAKHQOpe1aSPEk/u3xsNBqVDQre3/hT0n3ldEkJ2Opy7QQv29amrNLzbw2g4cz3a8OgfNTPeFvBgCyzNVV+LLC76CPRbYu1bkWcz6F+TpQ+byp/Y7Z05zYIf2CmR2mqOLbfoh7EFDMrmTMSm8/JUEwzpQBiFoHuk1SI3dh8EyGHkuJTf49RWHbO8I2QjFRsGnshE09pyfSOvtIMNEdvfla5rDw58J2dOhEf2sVfI1YTaos7hx/vHzPfymBpm2jvWnGL5dT6H2wJJKzughKYZO0+YCs8bolPYbx3ql/FuxnXPJqeOs+B3j3japV6mi63fsyHqIwPkmYInI5a/G0WWXG/Vw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Wk5KellaTDVqd0lnYjh2YmVxQTJoNWdobmc4T0E1WDdSQmJjQVJrNnRDeWNh?=
 =?utf-8?B?ZlRFeXZpWlpKczlWVVY0VFRuRTJiandEaFVuRkFDNXRpdjNRVnhRZmtBQ2RH?=
 =?utf-8?B?UG93blFYZmtMTzFBRGdqN0E2UFB6SS9HZ3NvN1YxTlBEWFpPOFBCRGx6Ynph?=
 =?utf-8?B?d1pVbCtVTnp3dmFJUG51aE80UktyQkZpNERWcm8zbUNvNk5JUTg3eDhwQ1Rv?=
 =?utf-8?B?eEhuaURnYXVyM2RhNExpMFFHZlE2NThSYysvdUZ1eHV4T2YxK1Z3aUF4MTYv?=
 =?utf-8?B?RnQwdVcwczl0NkpwbUlmMFZNdGdVL3YxUEZ3S0lmZUxvQ3YvZERUQWxsN1ow?=
 =?utf-8?B?TTJOZmNUN2tEZUIxb1lMaXRuZmgrNmV5c3JmRmsyUVIxRDRHZmZtMGhzZUJj?=
 =?utf-8?B?VTN0aUdYT0E2YUNEZWFPcWxoSmdjSS9wWUEvVmJHYmJ2M0RUQmRhbFpqRWdl?=
 =?utf-8?B?djNUSy9MSWlFL1JwRFRxV0ZOS09oWS91bGVoRGs3Unkyek5KTDRMZlN5THVV?=
 =?utf-8?B?RmxDWkVoR3U1ZkMyV3JKYU9XVlZHUmh6YXp6aVlOdnpjZVN3RUtraSsrSUFX?=
 =?utf-8?B?OEg2UzBuNGhqMDhncEV2SFFSNXFSclU3U1J6TWJ2Yzg1b1A0N0hPZzd3VzV2?=
 =?utf-8?B?NWJyclZwZ2JrZHFWYkdLaUtYSlZEVVVZRlhwN2RvSzJzM2wwblFPNXEzVHZz?=
 =?utf-8?B?MkN2Sk9vZG01ZFE2aDVmSVd3ZG5qWHg0cDd2d3hSaVNtWDJhZXB3NGtqVkVY?=
 =?utf-8?B?cnlFNGQyT0ViVmpEb0h0V1ZiLzBiWHdjVit3aFllR2pGY0RrRUxuOUJTQVV3?=
 =?utf-8?B?cEw2djVCdHRDZ3ZMUDRlbm5vclR2T0JObzFFaGxlK1V6dElaUnNHa1VqbkI1?=
 =?utf-8?B?T09JVFhUeW1nQm1mTUJQTGpRL3FLOG1RajFSdmVJaWZyNmVqMDBNNktlUTc2?=
 =?utf-8?B?dnJJTEY5TUh2ZDU5Nml1NGNLbk1kTm4yaGFEaHJhZm1aUm1YOU9LVnE0bC9T?=
 =?utf-8?B?dFdydU5vRjNjeHV6RXJyZXBpMDNPaTNraHZaRy94TjA1TXN0NzZCNkRmZTJw?=
 =?utf-8?B?VHZuZmhWL1U2MUhPbjRvTzBPc0pJRW9QczQwSUpaYk4rdlBBMlM2SmtZZ2NZ?=
 =?utf-8?B?T1YxWUZyY05kWTdwQlJYalNrNXpCdDlrQ2VoZlYwMzdDdkNmSlhKaG5aVXJX?=
 =?utf-8?B?d3JrZmFpdkVtQUg0RTVrWG9qa1J0ZHVVUUlST21IMENMNzFEVjF3MDVDWmpo?=
 =?utf-8?B?Q0hkMStJNmEvQjU1MUprdlpKQWVLZFRKQU5UcVJWKzVCa3h2VVpJUXU1OW9y?=
 =?utf-8?B?RzVYc20ycW9QM1U3M2l4V2tBQ0xqMGhwaWZOSVZnd0oyM21MMXdqZzB5aG9P?=
 =?utf-8?B?NzB0enJsRGlNVUdQRzBya1RuTXFucmtWUkRuMldsdzcrMjVhT1BRaHZUcjJP?=
 =?utf-8?B?ZDR0WmZYZUhhR05HN3NiaGphT1YyRU5EbVlzTmxDeXRaVGQvQTYyRko1d1Nk?=
 =?utf-8?B?VjdpNmpTV3JlK3BaR2ttMXlKSmpwNG0rV2xrai9tRE9qUm8yTU1ENXBIdGE5?=
 =?utf-8?B?Nzl1cHVYUTkrTUdsYU1YNUdDZ0tQT0paUmhaOHQrbXN0ak41WnY0RGhFTklC?=
 =?utf-8?B?Q29lWUpzNmttMzhrbnJrZ2t3amh4Tm5LU3NrYlcwNUhqRENiSWZuMTFXQk5r?=
 =?utf-8?B?UUtsalF1NTVqUUk5Si9TV0ZZdlp4QkR1VFI4S3dXN1JXZ1kzUDVXWitZZXU0?=
 =?utf-8?B?dlJuVnFxR2hYdWVYK0FWVmJEU25ZUUFqZDduTThsVkszcCswcjdPM0RmeFh0?=
 =?utf-8?B?dG9XSkJ4NDVFNGtvMGltdGxvbGw2dzhMa0dSdG5mNkdrWDlQR1FRbytlT0pj?=
 =?utf-8?B?WEc4ZE82ekN1UWZDWWU3bGFZVUtEc3ViZHUyZ1JEdW5aTHM3Qmd5RFlVNlpr?=
 =?utf-8?B?R01oRVkyRTRyMEJsNER5dCtNdDdNaVNxa2M3MTk3NHJqQ0dFQi9FWWdEdlNx?=
 =?utf-8?B?ZVVmUTFzZGQrdUw4WDNNeUVmTENHTlh3WTM1U1c4YU81Z1VZREJhRnhTZHdl?=
 =?utf-8?B?NVZjZFo4VktTSXVqRGYxNjRmNW9ZTUZVbEphbnFjenhYZWpuQ0U5UlFiVkcy?=
 =?utf-8?B?N2ZxL2NNMUdBQVllUng3Nzdwdm5tY1pMOHdpN3FqT1I0V2hzSi9aZTR4a3ly?=
 =?utf-8?B?MVpqaGVsMEZJVktWUGIxNnA2eXhhdG9seVBZT2dMaDdrNWc1Q25pSURiRGVy?=
 =?utf-8?B?YXhzRDQxWDVBUWZMaDEvRGVJYVF3aHprdVVnNGVnOGxPR3FGb1QxRXBUbWh0?=
 =?utf-8?B?R2NPWEVXbmxIUi9MVFZlV1hrdXFnK0lNWHh2UFcyLzBjaWNhdjJkck5ndGxU?=
 =?utf-8?Q?ZZPehEpaHfyI2cuo=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785e1f6a-239d-4a14-ff1e-08df0377ae03
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:41:06.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oop8A67q51bFbwrfq0dums1QOAUfN8RoeSVWmAYcEp0l7ZxWzOoHdZUbkrd4X9aOI1LNIHqXSeCYFve+mSufug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue.

This controller requires S32N79-specific initialization prior to
UIC_LINKSTARTUP, including:
  - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
  - applying the vendor-defined M-PHY calibration sequence, and
  - performing post-link calibration steps needed for HS operation.

The M-PHY boot mode is selected via the 'nxp,mphy-boot-mode' device tree
property. If the property is omitted, M-PHY initialization is assumed to
be handled by external firmware or by a simulation environment.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/Kconfig         |  12 +
 drivers/ufs/host/Makefile        |   1 +
 drivers/ufs/host/ufs-nxp-s32n7.c | 464 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |   9 +-
 4 files changed, 484 insertions(+), 2 deletions(-)
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
index 65d8bb23ab7b..0381750a35d3 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -2,6 +2,7 @@
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
new file mode 100644
index 000000000000..8a125105536b
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,464 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
+/*
+ * Copyright 2026 NXP
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
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
+/* Timeout values. */
+#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
+
+/* Clock validation limits. */
+#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
+
+/* CPort definitions */
+#define CPORT_0				0
+
+/* Hibern8 state poll timeout. */
+#define HBRN8_POLL_TOUT_MS      1000
+
+/**
+ * enum mphy_boot_mode - MPHY boot mode options
+ * @MPHY_BOOT_NONE: Skip MPHY initialization
+ * @MPHY_BOOT_ROM: Running MPHY from internal FW ROM
+ */
+enum mphy_boot_mode {
+	MPHY_BOOT_NONE = 0,
+	MPHY_BOOT_ROM = 1,
+};
+
+/**
+ * struct s32n_ufs - S32N7 UFS host controller data
+ * @hba: UFS host controller instance
+ * @reg_scm: SCM register base address
+ * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
+ * @mphy_boot_mode: MPHY boot mode configuration
+ */
+struct s32n_ufs {
+	struct ufs_hba *hba;
+	void __iomem *reg_scm;
+	struct clk *core_clk;
+	enum mphy_boot_mode mphy_boot_mode;
+};
+
+/**
+ * struct phy_reg_cfg - PHY register configuration entry
+ * @reg: Register offset/address
+ * @val: Value to write
+ */
+struct phy_reg_cfg {
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * ufs_s32n_phy_write_sequence - Write a sequence of PHY registers
+ * @hba: UFS host controller instance
+ * @cfg: Array of register configurations
+ * @count: Number of entries in the array
+ *
+ * Return: 0 on success, error code on failure
+ */
+static int ufs_s32n_phy_write_sequence(struct ufs_hba *hba,
+				       const struct phy_reg_cfg *cfg,
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
+static unsigned long ufs_s32n_calculate_us_tick(unsigned long clk_rate)
+{
+	return clk_rate / USEC_PER_SEC;
+}
+
+static int ufs_s32n_configure_clocks(struct ufs_hba *hba)
+{
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	unsigned long clk_rate = 0;
+	unsigned long one_us_tick;
+
+	if (!ufs->core_clk) {
+		dev_err(dev, "Invalid core_clk.\n");
+		return -EINVAL;
+	}
+
+	clk_rate = clk_get_rate(ufs->core_clk);
+	if (!clk_rate) {
+		dev_err(dev, "Failed to get valid clock rate.\n");
+		return -EINVAL;
+	}
+
+	one_us_tick = ufs_s32n_calculate_us_tick(clk_rate);
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
+static int ufs_s32n_phy_initial_calib(struct ufs_hba *hba)
+{
+	static const struct phy_reg_cfg initial_calib[] = {
+		{ FAST_FLAGS(0), 0x6 },
+		{ FAST_FLAGS(1), 0x6 },
+		{ RX_DAC_CTRL_OVRD(0), 0x1 },
+		{ RX_DAC_CTRL_OVRD(1), 0x1 },
+		{ RX_DAC_CTRL(0), 0x8E },
+		{ RX_DAC_CTRL(1), 0x91 },
+		{ RX_DAC_CTRL_SEL(0), 0x1 },
+		{ RX_DAC_CTRL_SEL(1), 0x1 },
+		{ RX_DAC_CTRL_EN(0), 0x1 },
+		{ RX_DAC_CTRL_EN(1), 0x1 },
+		{ RX_DAC_CTRL_OVRD(0), 0x0 },
+		{ RX_DAC_CTRL_OVRD(1), 0x0 },
+		{ RX_DAC_CTRL_OVRD(0), 0x1 },
+		{ RX_DAC_CTRL_OVRD(1), 0x1 },
+		{ RX_DAC_CTRL(0), 0x71 },
+		{ RX_DAC_CTRL(1), 0x7F },
+		{ RX_DAC_CTRL_SEL(0), 0x2 },
+		{ RX_DAC_CTRL_SEL(1), 0x2 },
+		{ RX_DAC_CTRL_EN(0), 0x1 },
+		{ RX_DAC_CTRL_EN(1), 0x1 },
+		{ RX_DAC_CTRL_OVRD(0), 0x0 },
+		{ RX_DAC_CTRL_OVRD(1), 0x0 },
+		{ FW_CALIB_CCFG(0), 0x100 },
+		{ FW_CALIB_CCFG(1), 0x100 },
+	};
+	int ret;
+
+	/* Clock Control */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x80);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Initial calibration sequence */
+	return ufs_s32n_phy_write_sequence(hba, initial_calib,
+					   ARRAY_SIZE(initial_calib));
+}
+
+static int ufs_s32n_link_startup_pre_change(struct ufs_hba *hba)
+{
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	int ret;
+	u32 reg;
+
+	/*
+	 * There are two supported MPHY boot options implemented:
+	 * - Running MPHY from internal FW ROM:
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
+	 * - Skip M-PHY initialization when it is handled externally.
+	 */
+	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE) {
+		dev_dbg(dev, "Skipping UFS MPHY init.\n");
+		return 0;
+	}
+
+	ret = ufs_s32n_configure_clocks(hba);
+	if (ret)
+		return ret;
+
+	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
+	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
+	if (ufs->mphy_boot_mode == MPHY_BOOT_ROM) {
+		/* ROM Mode. */
+		writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
+		       ufs->reg_scm + SCM_STATUS);
+	}
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1);
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
+			1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
+	if (ret) {
+		dev_err(dev, "UFS MPHY init not done!\n");
+		return ret;
+	}
+
+	/* Start of initial calibration */
+	ret = ufs_s32n_phy_initial_calib(hba);
+	if (ret) {
+		dev_err(dev, "UFS MPHY initial calibration failed!\n");
+		return ret;
+	}
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Set Local DeviceID. */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* End of Gear1 settings */
+
+	return ufshcd_check_hibern8(hba, hba->lanes_per_direction,
+				    HBRN8_POLL_TOUT_MS);
+}
+
+static int ufs_s32n_link_startup_post_change(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val cport_setup[] = {
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_IDLE, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
+				CPORT_DEF_FLAGS, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_CONNECTED, DME_LOCAL },
+	};
+	static const struct phy_reg_cfg post_calib[] = {
+		{ RX_OVRD_IN_1(0), 0xc },
+		{ RX_OVRD_IN_1(1), 0xc },
+		{ RX_OVRD_IN_1(0), 0x8 },
+		{ RX_OVRD_IN_1(1), 0x8 },
+		{ RX_OVRD_IN_1(0), 0x0 },
+		{ RX_OVRD_IN_1(1), 0x0 },
+	};
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	unsigned int data = 0;
+	int ret;
+
+	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE)
+		return 0;
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
+	/* Post Link Startup Calibration sequence */
+	ret = ufs_s32n_phy_write_sequence(hba, post_calib,
+					   ARRAY_SIZE(post_calib));
+	if (ret)
+		return ret;
+
+	/*
+	 * Performing MPHY configuration for rate change:
+	 * CB rate selection: 0 - rate A, 1 - rate B;
+	 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), 0x1);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* End of Gear4 calibration */
+	return 0;
+}
+
+static int ufs_s32n_link_startup_notify(struct ufs_hba *hba,
+			     enum ufs_notify_change_status status)
+{
+	int err;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n_link_startup_pre_change(hba);
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
+	err = ufs_s32n_link_startup_post_change(hba);
+	if (err)
+		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
+
+	return err;
+}
+
+static int ufs_s32n_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct device_node *np = dev->of_node;
+	const char *mphy_boot_mode;
+	struct s32n_ufs *ufs;
+	int ret;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufs->hba = hba;
+	ufs->mphy_boot_mode = MPHY_BOOT_NONE;
+
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
+	hba->spm_lvl = UFS_PM_LVL_5;
+
+	ret = of_property_read_string(np, "nxp,mphy-boot-mode", &mphy_boot_mode);
+	if (ret || !mphy_boot_mode) {
+		dev_dbg(dev,
+			"nxp,mphy-boot-mode property not found. UFS MPHY init will be skipped.\n");
+		goto init_out;
+	}
+
+	if (!strcmp(mphy_boot_mode, "rom")) {
+		ufs->mphy_boot_mode = MPHY_BOOT_ROM;
+	} else {
+		return dev_err_probe(dev, -EINVAL,
+				     "Unrecognized nxp,mphy-boot-mode property. UFS MPHY init will be skipped.\n");
+	}
+
+	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
+	if (IS_ERR(ufs->reg_scm))
+		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
+				     "ioremap failed for SCM registers.\n");
+
+	ufs->core_clk = devm_clk_get(dev, "core_clk");
+	if (IS_ERR(ufs->core_clk))
+		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
+				     "Failed to get core clock.\n");
+
+init_out:
+	ufshcd_set_variant(hba, ufs);
+
+	return 0;
+}
+
+static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
+	.name = "s32n79",
+	.init = ufs_s32n_init,
+	.link_startup_notify = ufs_s32n_link_startup_notify,
+};
+
+static const struct of_device_id ufs_s32n7_match[] = {
+	{
+		.compatible = "nxp,s32n79-ufshc",
+		.data = &ufs_hba_s32n79_vops,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
+
+static int ufs_s32n7_probe(struct platform_device *pdev)
+{
+	const struct ufs_hba_variant_ops *vops;
+
+	vops = device_get_match_data(&pdev->dev);
+	if (!vops)
+		return -ENODEV;
+
+	return ufshcd_pltfrm_init(pdev, vops);
+}
+
+static void ufs_s32n7_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_s32n7_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	= ufshcd_suspend_prepare,
+	.complete	= ufshcd_resume_complete,
+};
+
+static struct platform_driver ufs_s32n7_driver = {
+	.probe = ufs_s32n7_probe,
+	.remove = ufs_s32n7_remove,
+	.driver	= {
+		.name	= "ufs-s32n7",
+		.pm	= &ufs_s32n7_pm_ops,
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
index 53b523ef59df..747383cfb839 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,7 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
+#define RXSQCONTROL		0x8009
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,10 +23,16 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
 /* M-PHY registers */
+#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
+#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
+#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
+#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
 #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
-- 
2.43.0

