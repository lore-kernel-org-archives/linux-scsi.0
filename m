Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B24756BB;
	Wed, 16 Sep 2026 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548269; cv=fail; b=bsZ7ZFqBuXI8RPJq4lg20x40zK8GBcVviQ5kQnSLxnRKfU6g6BiJNgg/b/ClYSpXrpHepruWqyTeWcQFkdQMDj6wzPDEfYOAXgmTnR3pXOxNYTkc6kTiEVeKTsiz+Uq8T+0zDr+vQNyFZpSKj1uriQByAJZ4YQaGoM1Nga1LoWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548269; c=relaxed/simple;
	bh=g0lXaTFIJegxlQXv4CxdO+TFPYmlb7cSUJ524S6+g6M=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ei4BgNaNda5VYYaL1g2FgAOXbnldBgnd7DNiim3300sv/wBIOLAtKw8g+sf7Fv9fY9ZNHkwRsgYvAubStlqPB3jmUUJrT/8d5ch1efjBMzCrLvzMlCLlbbW1boXNSlcdgtsb83MAondPDCPvQJTfXHzfrK6PXAIwUUtQMTynG64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=q+GApyRz; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="q+GApyRz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yiRsxOFQP3fLPqtnv14OauDBWRqJt2Bdsg0wu6AiTsr9iuoi7pyoGTb5kOEuZQ0EX2bio7pWGnkhTYrt57aCYXKxd0DqOJw6x90blOKhh8vjqL2xjVO+XRvIrw3LAfwLxY/jNsUlAuTu8NapGJP3AMbt/Jl6PgOoOWohu1MMluduJfkkiNhu5WiOYPDFhg4HhDgS3SMM4P5Q5Y/SHuGrHBR+9Hsfkp0VGtNqtN6sVxIr0Km5aoPJ3lJbVhkolR1M5Mi5nehqR0lhvXQVmcYN9W6f0F5H68rgA5SyZYd9Bu5X9sryrCCskt/g95LA9p0yYrRVAO7ZHKOU9KoJFqpzqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+zSZfihQ+yb6+PPlgdPiCsX3AmK/hDCB7yz+if8huM=;
 b=abHtMttAMTsahNVS/FG6ZL/iGOENCk/xwCzCUiLhuhZ435VF6sc7tTUbX/n/uK2v3JT+ytw1SCWzZcERlAWG9/AOxG6V24lFOsG4WI4bjfPGEcVnDz4zhLGXNeaiF7wnOxsdX09chmhS3A3D4HSI/M9GDDLTU5eiDVNM1MZugfp1Ne0tQzR46rPBIkYV9lB2HYciC4CU0qXeGz3/vfXHE95zENO7VRpSVu/Djp8jfgnKjvg2bnGAWTmfJ1gWH5EQKhoBebMCiqjluN+GacYJYJ6Zq8+3kLeJjxyvXYrAawoVhVk+MH/1sqgtA90kQDypBvBaF9GNxWOzwFy/LwilNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+zSZfihQ+yb6+PPlgdPiCsX3AmK/hDCB7yz+if8huM=;
 b=q+GApyRzyshp8/H2OgA/VF24NIXHr7Frux5X23399icsquHZxpZq/ChJ8lHbsDtGOvNfVuqisqxk4+3RFW9sBRzrkoARJayBLNen6Z3z2Wss0UIXNQZKYd717o7WymUN1mIOWhuBwd5uE9UO6KHCgMBrENXA2A+uXlQogR1edyEx5ATP5bQQidjrCcRbC+U8P4SPHGcvJt0jk/SZvHKsVCuEqg2TEEfsHeL4G3ezRTRzPuXJ3Kry2eh25zo+FNfoVGSVftX0scoTjA/4rwI37eE4+2c9RfCEh3fybZG8f4GHgaHNgNoiY8zz7qqPp2CbY81OR5ECcuh/ey6QYgVclA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:16 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:15 +0000
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
Subject: [PATCH v3 00/10] Add S32N79RDB UFS support
Date: Wed, 16 Sep 2026 10:44:01 +0200
Message-ID: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 0405dfec-a979-4365-a263-08df13ceb07f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
 LUOwi2aeCtYqYwp6tGXTdKAPmK8R5sESO8Mfh6xDk55GGzfqmz14vgU6YVnW/IcSm+TPzQuUZ/tgpnVc0/qmzcv9N9YkTaAMzfvjC+wiLCOHLB5/rJBRPuzmaIV5zo7y8lQf7mr7LAS4M3+Hv51C5lBz1KZkTbcddt//iw3KBbnsyG8Kav3A1OwsDqay8X7rnd34R2JhlAdqy0qxwYn9w8pg4jKf0SB13ayV2LPGXDuueYGF58udRA59YvIyiDk9a8HkSKAnld8PY4vEFvv0ALUU75YP0Y9bi5gR7f0MNvilH+mVDWGgTN5tvqQ5CwTp/dmSPmlz2gQwktRNKRAglvqvF2H5ItcskJJWx6oIoAG02EI7iQblHizFhgT1PU0A+0nhI5TWudHZKmS+XNOcMJSE44zpUKG3CbpQELuLT4hOB3O3xN6ukwJ7bggSbqzITFJtw7cqP/TZ1qMd7LP02bmyDo6aCEkRRyEohSSfv2U4ILiRe2wtvjrwizH0quPLQS/HO3+2Q/R6f4TJ1eVjNt23RxTT/Ak2uUbyOUk3ZHIY4/yhKiqEVFOJ/ZWeKRLueMU2wOts8pmKcXraAFtmwSMiej9oymqulW7hbtSOtj0W6ux+ZijwJHm9329+3eW9N5s76bnD5/91ksuFw6il140EGRjb6TuPpmnZKqpHGzg20AAoFArGNidKMj65zd/Zqq6npJIMKm1XhggiGjHI+w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ODJsbFZNcEtCeHVwUVZzeW1ZTnNPWFdUMFVFbk80RFhFb3Vnb04wZTNKWEtI?=
 =?utf-8?B?SGwyWWNQNHpsTUtySUNLd3BpOFp4YkhZWXk0dmNUdmNmVVpjVlo0dkNQbDQx?=
 =?utf-8?B?L3N6eE5IYnc4d1UxWmNteklvOXN6MGNJeU9rRWRVTHdsVjRMM21Lek9MdXkw?=
 =?utf-8?B?Z0hzWnRBVlg2L2d5ZEFOVzNIeXZvTVZUR0M5Ri9WRGlBVjB0bTk4bHMrdUZI?=
 =?utf-8?B?Z2M5Q3ZxSDlHTFhUZHRPOHEvMnJsMmVNVi92Q1IyZGRqVFBvSGZKR3h4a2h0?=
 =?utf-8?B?WDBiampXbFVaU3J6OStqbDVIQVJmTnEwUFhLYXIyMmlQZG8zT21BemkxWTVP?=
 =?utf-8?B?QUpJSi85a2RMZUxCa2pSV2dJYzBPTVdGcGpxQ0hveGZGQ2UyUmtJN3pqNzVx?=
 =?utf-8?B?TTZGREhqRkg2bG5ETVFiSEN2aHpFWW12ZzVHa2dYWGpURC9zU3ZKZlFTT01Q?=
 =?utf-8?B?blRDbGdpQXgxcVNIWEM3WXB3SW84QzF0a0xSR0pPbWRxOTNmeUNFd2VreG1s?=
 =?utf-8?B?Wnh4MlNzb1VyOGIrVnZLdEc4ZDBnOEprV2ZHTmdkNXRYNjNpRmtvMU1aVUZm?=
 =?utf-8?B?NTJsNmxYbGtDQW5FdDRvaXA4Mkh6b1dzdExoaWdXZDFKcVZnc2pRVytSbkRB?=
 =?utf-8?B?WkMxd201dnZ4R1dlZlZlYTQ1cm5kamNRckFjUzErQnY3c3RGY2d0TFl5VVhG?=
 =?utf-8?B?NnhCbjhZQlBSQzNMSmJwTDdYRXltaXNkY0pzNG4wRThCcGdmaHBQL1U4bkdX?=
 =?utf-8?B?eEQ3RG5BSlNDS0JPNHFuTTJIM2lGb3lQOHMxUlpZRXNrWkxqcXRwYmRVYTBL?=
 =?utf-8?B?Y1ZldVpYTzdIcXJldFo1VzlHYmwwWVFBeXJTTXQwbUl2a2dWNldVaiszbnFM?=
 =?utf-8?B?MyttcS9tZlpVVW85cUVLNSs4Q1VMTjN5WisyZFAvaWxobzlsR1lOVWliWEc2?=
 =?utf-8?B?QittOFpZQ3ZyZHZva2NwaWFTczNqSWs0cVhiYjBsbStZaWNkYm50SWc3UGha?=
 =?utf-8?B?YkRxSHAxQ2ptVmdPeDVadjJwQUVPdlEvbW1aNmhjajVINW9hTEt1ZWNFd3dz?=
 =?utf-8?B?Qm9Dbmt2U0lVK0k2ODY3Z0xML0M2UEJWQmJKNHJYZGNRcVREVUtUb1JzUUc0?=
 =?utf-8?B?SDFSaEZWcGtqcndaa1hoczd1WnpCV2JKWVlGcUJKZ2JJek85TnpBSXQySFZa?=
 =?utf-8?B?NitTejJwbU9IRWRsUkEvenRRaW1HTGlZeWcxODNpS3RiOHhFczBQZ0drTkVy?=
 =?utf-8?B?bVkxa01ZYTAyZk5UR0RxOGthckhLazgvVlE5aTRSdGRwM0FnMnh6V1B3UGtl?=
 =?utf-8?B?bEc4VmoySmw1dUk5ejN3azA0L01tMUZNdCtwaU91dndja0pwY0owbkw2aitP?=
 =?utf-8?B?OVZWY0xaTlkyL3B1d2ZveWltMk10NTZaeXQraHBDWnZSUWYrSEhYR3NOZUkz?=
 =?utf-8?B?VkZOM1NjSEYzUEM3SDZUZ1pEUmdqU2J4TVExVzRFbFNUclE0a2xxa2g0VEFX?=
 =?utf-8?B?Y08zeFhxa1ZSeUdJSEtrcm5lNnhoRUQ5Y3c4Zmx0STVmUk53VTcvQ1FsRFRN?=
 =?utf-8?B?UVBrUExYdkl5VEtERFUxalFTQXA4YWYwMWJXOFk1ZHF1TGl4b0VsV0lkZmJH?=
 =?utf-8?B?bjJ1dXVrOUpMSWtWZ3hwK3grcEoyK2FTVE1wQnM1WXdVRm42Z0VpZGhPRXRP?=
 =?utf-8?B?UTVhZHdleGxJaFFaNmgvNk96ejV6dUp2WkI4aFhXOVhGSi9SM1ZMRVdJYkc4?=
 =?utf-8?B?VUYxcnlwdi9LTGk1MmVONjd2emRvSW5BUlBMUGZ1ZmlVSWhOekNtU1dGV0pn?=
 =?utf-8?B?MWZzZGVMcXhYZ3BsWFhwSUJ6Zy9mUFhUYVFTMjF2WGxCSUt0Y2tPcjhBQncy?=
 =?utf-8?B?bGhBbzhsOWwrU1hSZTNUcmRaVjgzZmJJY0MrQVdqM09lRi9pNndXcFc4RnM5?=
 =?utf-8?B?bUl6YldVcGJRRkNFdHExZ2NmMjd5SVkyK00vTTZGeXkxMmRVcVZQL3ZSZVZR?=
 =?utf-8?B?MG1CNEhOV1M1L0IrRzFva1RvT2ltcm9GdDBjenlVUUR5VW8zZVVCa2UydXRB?=
 =?utf-8?B?a3lsejhUbGtTWm15dThjeHh2d0p0UTd5dmpkRXZWdi9Vek45b1ptMUF2SzdN?=
 =?utf-8?B?OVpUTGVJaEh6cUY4WEtYd2htZHBmWXovK041bXZmU1F2TkFSV2FFR3lBUnd1?=
 =?utf-8?B?ajNPMTlZcTZHdXcwbXF6Y1AzVVJ2Z29SVkRBWCtWbjZyekllYm9JaUU2UzRn?=
 =?utf-8?B?UVNUNVp4UXA0bFd6QmtWNWZzSkt0YnJuOExYYTlNc3pIMGMyMjNaS0M0bkY1?=
 =?utf-8?B?REt6VGlmWXFqV0t4Y3ZSRjBIOFZrT2RSajVjTFhvK1FDZVFQWndDZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0405dfec-a979-4365-a263-08df13ceb07f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:15.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orWgVfokzyTOpyoehKKf0dhSsyx2934cSEBMqxx9Yd8G/DUVC7SAfvs0/og4Z9JY4h/4BDleisJwW9N9tI/b6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

This series adds support for the UFS host controller found on the NXP S32N79
platform. The controller is based on the Synopsys DesignWare (DWC) UFS host
architecture and requires S32N79-specific M-PHY initialization/calibration
sequence. It is compliant with JESD-223D "Universal Flash Storage Host
Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. It is
compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is compliant with
"MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PHY is
compliant to version 4.1.

In order to keep the S32N79 platform driver small and avoid duplicating common
DWC code across platform glue drivers, the series also refactors and exports a
few reusable DWC helpers. In particular, M-PHY CREG (CBCREG*) register access
helpers are moved from the existing AMD Versal2 glue driver into the common
ufshcd-dwc layer, and are then used by the platform drivers. The series also
introduces a generic Hibern8 TX-FSM polling helper so that multiple platforms
can reuse the same pre-link checks.

Device tree binding documentation for the S32N79 UFS controller is included,
along with SoC and board DTS updates to instantiate and enable the controller.

Changes in v3:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, so
  real attribute-read errors are returned instead of masked.
- Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
  ufshcd.c.
- Drop the now-redundant dev_err() after the check in the HiSilicon driver.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Use devm_clk_get_enabled() to enable the core reference clock.
- Rename the family-level identifiers from the s32n_ prefix to s32n7_
  (structs and functions), keeping the s32n79_ prefix only for the
  chip-specific data.

Changes in v2:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Improved the enum comments. They now cite the MIPI M-PHY v6.0 tables.

ufs: unipro: Add TX/RX FSM state attributes:
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Moved the helper into the UFS core (ufshcd.c).
- Split out an inner per-lane poller, ufshcd_poll_tx_hibern8_lanes().
- Expanded the commit message to document the -ETIMEDOUT normalization done
  when converting the qcom/hisi checks to the helper. No code behaviour change.

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Made the DME attribute arrays const. They are now initialized inline instead
  of by later field assignments.

scsi: ufs: dwc: Export common clock divider and link status helpers:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Renamed the patch subject and simplified the commit message.
- Renamed the binding file to nxp,s32n79-ufshc.yaml so it matches the
  nxp,s32n79-ufshc compatible string.
- Removed the nxp,mphy-boot-mode property.
- Made reg-names and clocks required.
- Removed the conditional if/then/else schema.
- Removed clock-names.
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Updated the example clocks to <&clks 0x92>.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Removed the nxp,mphy-boot-mode handling and the mphy_boot_mode enum. The
  M-PHY firmware always runs from ROM now.
- Added a struct s32n_soc_data for SoC match data.
- Moved the calibration writes out to static const tables.
- Renamed struct phy_reg_cfg to s32n_phy_reg.
- Moved the rate-select sequence out of link_startup_post_change() into a new
  pwr_change_notify() pre-change path.
- Used devm_clk_get(dev, NULL) and dropped the redundant core_clk NULL check.
- Switched to *_PM_OPS() macros and pm_ptr() for the PM ops.
- Clarified the Hibern8 poll timeout comment.
- Enabled Auto-Hibern8 instead of setting UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8.
- Reworked and improved the M-PHY initialization sequence.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Removed clock-names.

arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Removed the nxp,mphy-boot-mode property.


Larisa Grigore (10):
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  61 ++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   5 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  10 +
 drivers/ufs/core/ufshcd.c                     |  86 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 543 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  75 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 866 insertions(+), 192 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

