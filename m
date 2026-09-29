Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011011.outbound.protection.outlook.com [52.101.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE4D50EBEE;
	Tue, 29 Sep 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676694; cv=fail; b=M+9ihS3cdBHDERvC3fVg1Y2baeZZWrVSbn2d7Kt6hf9Yp2JIUgduEPDQLIL7gt9XdP7Kq7TG6POHbZoHH4RgRE0qGCBBQL+wrGdLg6hz+Ux9w1/0OCg7CIem+fVd2kryKDHwxjSQr76BwC71dpRlBUEqRH9XR5qYQaewtz1uNBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676694; c=relaxed/simple;
	bh=n9bMaTx3+H2xHIuBmDiM3W8/wkrFyR1nvmM/uSj5kRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qOLddDV7kBCfjXR5tjHYMYYEaCAi6MpiIUCprf+qDJg+6ggpsrin1q3WywiWOjMuRjv77EhGZktP3UNY7LiXZD/2liGDcLFGLC6WlUh7sAlRE6K4eaav2PbozrQLC2Jfu+uSp+KM9Xunxtl7+1Uic74dVmdOltWYtEonQ7RyoVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Gxg/TW0h; arc=fail smtp.client-ip=52.101.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Gxg/TW0h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=De1YgPQbULohyICARQIpKskS2um+fKU21/XP4odVpjCbIpay3VTc05P33sFyevPBKVsgzWZcUzEEZAyRGOAelXdzAW9YY7P7ZnXHi6XRdlypr4B4OKewBhDTNV5PBnJqRrej/sDS5T20D+9Emqq40ApA3hjgsTdts/BDZ5z0X/8TeeoV9QJH4bK/L9Lk/vmrvLyNBajyIIi2dV/CX1ERqzz4GLSboQwAlWM8W+kXDqlVNnBLNgRW6RiDYvLjE49tthAxxB+1oBKvOgqhgAa5tx9h6A4wYUD4WyH5Qw7X4Gc4ZHa6tFcStFaj4gKbaX1gUc0RO1sWfXXYkEGR3rO02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSaaqcvzIG3gtQrB3GZiz0D+U3/x9O0Mb2u16no+DbA=;
 b=TO/+bNj84D9YGQia6k5NEnHoKIDZUsWQrRRG/buXH/mpHCj9dLS++reU219MoVqoQ7Bv1DbZo/G5xtL0NJ4Khaw2s0DSt/wrWM2Mzt8ajMXIugB8eSkgBwi/bs5Rp4vUEgeoVUJgCalog+n1ORziT/OwEL4nSesI4D6tTVCK17ufQaWUtxqShFKT6WYRk7qYZay/6rnipKKHI/n48VwnnyYt+muglOrTnlFaGUIVL+CBaA/buURau4ra7zJ/rlYMXBd1C80WRhXpbXmRywMfO8py5Tf+ceC9mF2ogMj2sXV35epUZZ6YQIMt0AQNG495NFWoYLXlWJd3jWSz9+x6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSaaqcvzIG3gtQrB3GZiz0D+U3/x9O0Mb2u16no+DbA=;
 b=Gxg/TW0hS2mRV/Teh5/BA/2JRWhynmgzNcZfy9STXh/FhO3ZlNlIL3DjRCXaKB/igogu1MhdDY9/IRRvtzVkO74acd5t7ByfGjTIUaTsdMXY3Hkmo6VfCiOfKIDCM47Egc1wp/0UI/xy/XVZEPAsF9gfXxJEZOBv8syZNvnEb7AOc43uuNpagCKMBUAIAhgeQ7Oo86KrrybbKMq7u1efjnYBkybSMnBZnUGjYiHPUfoBABtEOGqBdHcHGeL3wIYoaCQDD1cNqc6xv5ta2cjt2NC6GtpZc1m8GTOtAat3a5t/fGvUN8AUbmC7XXeZQ2C8sJj+bJs/tpVZeSPws1FFDA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:17 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:17 +0000
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
Subject: [PATCH v7 09/12] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Tue, 29 Sep 2026 12:09:43 +0200
Message-ID: <20260929100946.693962-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 5335a561-61dc-41ef-dd52-08df1e11dc9b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|3023799007|6133799003|10067099003|260925021911599003|260925022911599003|260925021311599003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 bL1kdzr/sJ5r0Tt4vlKFwG4UFSxCYHUTdh8teirhUQAQmL6yHDADUNKfRJ+rUec5VZ5BJvoZQw4fLWBly9wtVZrZGXqzLH7jjlZ58PuBa+nOTuZUxUbVFpMs5LzJAcr3UTYMGBKFnRPV6D3EQpCjtXWia6CHv8kFhaEVRI60i8AB+pdBDUzwWKgmuxjcCX+F2SE9QiWSaRv0MVFbvPKLC5U5gmVa6n0PyM+mre1A4ZJl4oOomQuKLQkGiiwwpCH6UnZKOAJZa9tD4kiOnSm5s5UhEeTYdt2SarnNxA44AaM+qX/PTakVMvtHofAIwalBB4OUDTUAQp2vRFKz5VbpuDcgaecYlwe8l2YRoQKgnBQ3DN3AwavFGr1cpAqaEFHvEAmdrAGfaowglvQFytOeHDQcU4AP14Oa3I+3uz0gmapm1etWhKfROs7zTzaK4EGBqwIH8ha6emAkQxDu8bCsBwQMKzYLRj0/0rE5qkY1Hs/Wotc0ivQxhL/yfYGoJeIsgzWy2FLy9xeozDEPwvsD81Q9mz3V5lDFoK17uNMKEGO+VKFSkhYeFqeSwtnKnNNES3m+lAsm0c07S+qglTB3j3F0T9t+T3bZmBz12VBj+BQ0NfY6Qc0NOYP6XUJUpCY7vUXaFqj4pYGV20GYs9fmT/gQM3vdh4hx1hAXaVRWuIRcNpBgVYExRct69FKevl8ShHgNrHUm+RsukVIRK+jRtA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(3023799007)(6133799003)(10067099003)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZUE0TEdUbXFHOG5VbWI3d1pYTXJtaTREMHVZeitISGhiMWxWUTdmN1o4UXNt?=
 =?utf-8?B?dE54cEU5Ti95Wkg4Wnl2akpHNWx2dHdxUytRdDN4RlIvWGZHZkhKa3NWUjVX?=
 =?utf-8?B?eUwyVEFiMHE4VFdaZGhELythREZsWi9HMmo4WW9KVi84VFVldHNjcU5QZnhM?=
 =?utf-8?B?M285WjhiRFkwRjF5YUcwZjhVcXVOa3JHeFErR21ZMGFIWU1oVXRieldWaENj?=
 =?utf-8?B?RkEvaW51WTAzQWY3Y1NnMzBzd2RGTE5jTzlXM2dSVmhwNGEvdlZJa2lNQk9l?=
 =?utf-8?B?dFFydnpzZUZMRUFwcDVXeTFhaW43WnFJTzJWK1ZTWHNSekQ4aG00bU45TXBs?=
 =?utf-8?B?TFZwODZianluYW5LMytOSW5RNHZsR09mNTh4NE1MeHp1T0JtZmpNTVFCQzJE?=
 =?utf-8?B?ZmtsYnpzbks0aEdpWTh1S0M2VGV5TGtTcmhpOW0rQ0NVVUMxU2luc2lTWWY1?=
 =?utf-8?B?U0IzdjgwQ0w5djE4TmVoVmVPQnRZc0NDckJtWkQvL2ZZdFhxdjRsRTZyOEtI?=
 =?utf-8?B?TWt3cmZGOE1KY1JybTNTN253Sk9JSDhsaDlxNU1hUXU0TUFnN1BpY243RFgv?=
 =?utf-8?B?eTJDRHR2R1duaGJWYWZqRzBsL1MvSm9RL3ppeXV4Z21qOUw4ZXF6R0pSUThy?=
 =?utf-8?B?T0QydWdrOEJleGNadlR2UTRwKzcxbERVYXc0alVFeFJiTEJxWmhteTlUMmVM?=
 =?utf-8?B?T0xHRGJteno4V3ZVLzJTam9TOGRNbitOeHNEckgwRWRUZERqMFBWcFp5ditN?=
 =?utf-8?B?NklmOTNWVzdHaHQrYllxWkFBWGQrYmdjZE9vVGRlSGYyZko0UnV2bGVtS2Qy?=
 =?utf-8?B?MEVuODdGUzd2MXJySHVtWHVHODgzOTMwVVdYZ3l0NHJ0Y284T3pQdkRUWHlr?=
 =?utf-8?B?OVlrTFM1Tkl5R0NnVTVzUzNTbG9GU2tWZTMzbkxwYWNJTW5aZ3cyZlRKajI3?=
 =?utf-8?B?anJNVjhhR1haVzBFSzVrdndmTGRQbVJ2OFpRS2NIQ3d1NHlnR1pxdDE1YUIv?=
 =?utf-8?B?VW5wR0gvMFF0czhydkZUMjVXRGY4a2hWbVJvelNUVVBwVnNKdWJNaTVrSVhN?=
 =?utf-8?B?Mk5IWWp5WmZDR05XaHZOTXl0cW1SM3dwSDBHUEdad0Jjdm0xUW9nWVZCOHd0?=
 =?utf-8?B?NldqdERzVGF4blNBSVVDc1p1aGdqRnF4ZjJadlBvVDBsRmxIalZrekQ3Z0hl?=
 =?utf-8?B?ZllzNkZKeVJZcWY2ZkdKaG1PaFE5NVd6WG1SVnRobGxBTitJNFRmM1o0NHIz?=
 =?utf-8?B?L0lmWEpoZ0VvQ2pvVmw4a2NuT09laUFkc0psTXUwdk9nSnJTWHMrWGlZZk8w?=
 =?utf-8?B?dEFINGFmU09SRDAvWkZDbG00WExqbEpUZVdGN0c4VXg5REpVU3ZGaGxzUUdH?=
 =?utf-8?B?RTA1RnNlaDJXUUlKTDg0RjBZVFdyM0ZvOEtZZEQxcUE4WHh2WE51WWl4Vll3?=
 =?utf-8?B?ZFhLWlM3aEJ3aTNXb2x5eTZiaUcwNERKT3R4RUxNdkpNcnVLNVV2R0lGNU9O?=
 =?utf-8?B?OGQyMXE1ZytWbG9UalB2WWxUQUtqWUxYZDdTalNnWStLVlpDSEV1YnFtRWt4?=
 =?utf-8?B?R211dDZTT2QxcGVlN0hLaVUvc3VJLzNzM1hjSnpOc2R4dmhITDdkMlBxVFhl?=
 =?utf-8?B?dXpweFdVMGtCM1dNSEpORFpBTWQ1UzExdEFqZDV4b0Jsa0REcjkzVitrVzYx?=
 =?utf-8?B?N21UbG90WlRNMW40cmR6SGJlNjB5aFg4OWhZMXFDU1VPU3ZHYjRCYi92ZHVh?=
 =?utf-8?B?SmVjWWVhWGwwcFc4ODFWeVBEb2ptb2t5N2VtNnNBNUJianpNbmJSUWI5Y1RK?=
 =?utf-8?B?amdzNkVtREVucHJyMnBWVTFsTEhOMmVlbGJVcEVBUlk3Mmhyd1FjSEYxSE55?=
 =?utf-8?B?NzVrVE5GandzME5rWlkzVVZSaUROSUc1N3NTNnp5R3hod2dRNm80R21wczVK?=
 =?utf-8?B?aWFING5wajFRUndvL2dBb2JBenhDN25lTHU4NkpBNnorVXdUaHVQVko1UkR1?=
 =?utf-8?B?UUtnM09TN0lhMG9aUkIwMUZsSTNlQkVqZkhYKytBVGlWelVjU2ZpOTNjMGRn?=
 =?utf-8?B?N1N3Tk5rSVJkdGo5T0RzRFMyTFdxUm9UQUdPeHZIbjdBNVIybCs4U0dTMTYw?=
 =?utf-8?B?djdFck80dy9ZcTNhZ2I3ZENzS2U2VU56aEtiWDlFdDRMWWFSL3I5L2ZMWkdB?=
 =?utf-8?B?VWYyUG9yeGw3MVFwVk56M2xrMHlPM3U5TzNIbzFIVnd5ZFFacjJWa1FZSTY5?=
 =?utf-8?B?U0hQUGhXcGd2anduT0ZRZ0xJKzZ3VHR6NWM1Y3dGS0hiOUNIUWgzNUlaZjBn?=
 =?utf-8?B?RThLb2d1c0NaS1FoQm94VytscG00UHd6SlgyZ0JDN1B5NTB1UngyQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5335a561-61dc-41ef-dd52-08df1e11dc9b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:17.5445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXOB4oQt6sRq4Gafyzx3SZnZX5GVkMMwyWxb5cfMBGsMyqOkkJCf6cU3BzBLyZzv/hWPF2VbQoS1wvb/KGLBKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

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

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
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
index 000000000000..5374662763b6
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
+					const struct s32n7_phy_reg *cfg,
+					size_t count)
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
+		clk_rate, one_us_tick);
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
+				       enum ufs_notify_change_status status)
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
+					   ufs->soc_data->calib_mphy_disabled_count);
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
+					   ufs->soc_data->calib_mphy_enabled_count);
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
+				 reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
+				 CFG_MPHY_INIT_POLL_INTERVAL_US,
+				 CFG_MPHY_INIT_TIMEOUT_VALUE_US);
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
+					 enum ufs_notify_change_status status)
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
+					   const struct ufs_pa_layer_attr *pwr)
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
+				       enum ufs_notify_change_status status,
+				       struct ufs_pa_layer_attr *pwr)
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
+	.prepare	= pm_sleep_ptr(ufshcd_suspend_prepare),
+	.complete	= pm_sleep_ptr(ufshcd_resume_complete),
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

