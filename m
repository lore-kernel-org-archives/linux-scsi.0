Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0BA3DE43F;
	Tue, 29 Sep 2026 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676630; cv=fail; b=q8M547fBCZrutSgINex17J3hAQ/wKUJl/29lZwufmMZeDlsAiBVkDQrjvEuOxDQNYoRu6f4qtFV4IeRNxA7CB4AqeE6ETSXFxBwfVfU9n3E4bbxu3RSjOZGH4GQRr5Go467gLzX+mUm40oMWZVTpxm3K8+sSL0keNp0aFQxANSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676630; c=relaxed/simple;
	bh=etCHDNNVri2ZU5kTVav4S88A1M7d73eND1kHGAlYXDw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=E5NiK3boMSVTy3T+W3x+htDxRY8UcKCyVIpk+tpqMcCNUaF8fHx53227rEyjZsIQDBjBZZPUPKGrVRTxCJaGoj0gGeFzVDZaFKSAdDiyX9X3h31PpZGU31/tyvvEXr7glfrqan1VnykAisSg2UQgj6aXH1YcOAv/G6l4F+At9EQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=f+3y2k9+; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="f+3y2k9+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWADgejQyT0G7AmHW4vQcsRCbBdsp/z+wr6OFKkIRaXWwLPuLF6aV7mIHhCBBty6GONbr8oj5KqqCw9c5hhoycQtHMaAmXB9LTCvKAVVBEa3b7FA7XmtapRZ4J5nX46MSPo5bUlL2JvWa1NopGz2lz7TFRY+kbosu2Gx9Fi3aSIBzlqJ0sb5/t1fg6xdarIKi/6dQ3SSphzqsvpuH077+poxMa1kjHdB7K4nfejYoxiDq/I6eJQQiP6Yc2FwkDFRERhKLEJBedhm6M7kx84qF4USUeqZKbiDwROVsVL6ovSaMPKeqXl9G0mx1LvFoMc+g7l0XD2KgIPORvTQ2/quJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSLB3IKsBv8WUNM7pcmKQKYgjPIfM2LMQHALKPwfgzg=;
 b=JaF3HSuOrxqhmgGBQs9TPyFJ5A6sdn9Pg9Xdek/hC7jt/XAb0Y1zhKnCpz9m+2P089zXuScWS4N0/Ad36OxzmaACxKewwP9i2cXeiR0I87L41IFNqrhPa2+poWOvGtVTAEN/ZdQFrVb4SCJj2DF2hzlFEww9uKKjaY5b9mEeS5dMXbYLpOwvnidYm3cNnGJ5dLy60Mw0XmULbHN8I14VAmXAkfWnWt6CW2zPErdzWdwa73yf8E0yd+/N/lR8+dRjs1IP1115bgSl14yPI9lesucb8IFOuDBAc1Bgvflps5zSEKkgLpbxHmynDqiBg7bLf+Dk5PQz1LPlkaHbtVKzEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSLB3IKsBv8WUNM7pcmKQKYgjPIfM2LMQHALKPwfgzg=;
 b=f+3y2k9+UoXC4YKP6xDHBP1ToVsy6YDe6CuxQInZbvfRi5ZySqPoaXNAqwbuM2NOnRDWulAMSH3WQXtQCRrbo492rZaH9PfIhqn7KuwyHv2yNdfdbK5dFROoziQSvxny4hIg5LKwZJme4IGCSO7bw2h/MD31VQtdTY4FvIdbjwCSeRh6WOJb4UjR/hVTJm2r2TqgSvguw2E1NagvQMHqQvcXKe/ewRtvoe7O2fFz5nOALlwAItU3wDIw9Rk4ph93KikgjpyOCvPA63RY6+HiHFIl/MlBVNb3UHv4mic19Qh53757iuuhMA52Kg53i8uB6IjvUoApismPSuJ3UdF3hg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:09:56 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:09:55 +0000
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
Subject: [PATCH v7 00/12] Add S32N79RDB UFS support
Date: Tue, 29 Sep 2026 12:09:34 +0200
Message-ID: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 86002f2d-60ae-45a4-dc7d-08df1e11cf92
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|18002099003|921020|3023799007|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 ByWqsjf12zQWqo2M8hXWtnaYXUXpa3/E2FMd6dhJHD9gY04YqN0UIoObOJyddidYU7dI2GSu56EMMkeha3fJ32o6BT4k3PCjZ4sVZa+UtQcT7HzBzq6UdeTvI8KWbw9Nas6U/R/ixQ4ON5elp+OFZL18D7M2TSywEIOfUYFqBKtU7BZbj/BtnxSxRaeTJt1jxFID+dV7cjFdZQN0dmyWNqe76ujCG5eaIL45mpKRC2irepNvQnzHwbljWIUfUxlTyzV7dIEP+Z57Cq+wWwujV6VAkfihZi+AVa2DKoZkngawLczjs+GEPWIaAMcrDdie/YKSK0c/3HW79IjqFza6+SpFKR4+4zWea9qs10LNWhk5bwVFS7wepVf95M7y5iwNJGkIty2nDKXpMie6lS+PzQhKNNqGAmhaWuUptkSkc2lf27jxLo5Sn4w4cWU90eVT3BslpZc2tiV7lLZUGknRNgW8iZnOwrZ1FK40JeppoZGMB2TikQ7SHmgT26VSel/m1rJWuYFdzRK3hYOqcqwB/h4dTTbzlCTUJhEEjsFbWKMvnM02eKlfrpltwLdIGLzLqwJvQofEE0eSewIyGGtm0hQ3MJlOc5V+5KtXNROs0tnFMOvQzPckM19p2lHRVHKz+RnaeJhPjTPI4zNWUN8LNpZl6QQIxJrvxrbBRgsC263vQCyLk4T6egFmYQIka9lz4Yzr/ugs8nOESX8Ds2BF0w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(18002099003)(921020)(3023799007)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SElKOG5zVUxPSzV0UEJReFcwRTFzcmNlcWJMNFpRL3pTZkV3QURsdlJpWFJQ?=
 =?utf-8?B?TVJ1dFdZblgyaDkvcDNxdmtiSS81bmpra2RGWG5MTVAxcDBiT3FlOC9SSXp2?=
 =?utf-8?B?ZEpDbHJPMGd1NHo0MktNN0pDZDJYdlI4UHF1akZZYW53M0RndVkzbTh3WVc3?=
 =?utf-8?B?WnZERnhDMjNkZDBqa3QzYkRaM2lIaTR2c0J0VW5kYXV4Uy9qOUJZVklXV3Yy?=
 =?utf-8?B?NlZMakdiY3ZFbG1hWjBkODlnUU5iYWhOc3JrcHFJU3cxckM4Zk4xcHl4VG9x?=
 =?utf-8?B?dUxodThWTlRRZkRsOGEyZVhmOC9iMTk5NWtiWmExUGlvOWRCYlFnTWV0UlJk?=
 =?utf-8?B?RE51VTlxZW1oSnpGd1c0M2hrazVZRjBrb1JkWlBEdWg3R2JKaStFT0F4dlNG?=
 =?utf-8?B?c1NkREFZUEI4SkxSc1ptcE9XMkpJWE1tMmh4YTVtNXd5czcwaytKZ0R6VzNV?=
 =?utf-8?B?cW9PQjQ0citGSXp6R1ByT2NlNUJrS05vTmNuL2RzaFMwZmNEc21jYjlNMGtL?=
 =?utf-8?B?aU5MY2o4Q0VtQThJNFFtSWJsSmZscXNOSGw5TFAwcEwwVXM1VlhhbEwvVzBp?=
 =?utf-8?B?QjI0bWhaV1IwQmkrdkNDVnprR09kSFc3dXpyYWY5SFVJOGkrck1rUXpOVmxm?=
 =?utf-8?B?NS9JbmJ6ZjdwZnFBZ3VsTDBFeHQ3T2VjWWVlRW5vNFFoRmhHZVVZNjBzYUR4?=
 =?utf-8?B?OE5YU3VZTnlRSUwrTWcvSTI1U25lMkVVNWZkaGQvTXhkVDI0WW54aGdKUkZm?=
 =?utf-8?B?cWVKSUNOdFV4QjNEOG5zT0NlL1RUUnNHeDhwZG50ODZpUWpDTUJHRnBoYnRl?=
 =?utf-8?B?ZmJtYlllUng2TU1HV3RCMUR4T2ZPQUcrQnBrazNEbG1lOW1lekQrbXVBM3Nv?=
 =?utf-8?B?WXBTVHFkNWhpRy9mdVlvd294Q3EwVHorK0s1RGltVkQ3SnNGZndBQzRwaXB1?=
 =?utf-8?B?K1NXQ0VwbXNOL0xOdXV0c2Q5RTVEenBWM3Q4aXdWeXFtcTM3dUdtOW5acXRX?=
 =?utf-8?B?QzJHM0JQR2p6Tyt1Z2ozZjJIK2xFZFpnNXdQeUdtWnJEZHRXNUFzUXZoWVFB?=
 =?utf-8?B?ZHFMdUZhVVR3ZWRHbE1sK05xS1FweVpyNjBqWVBIMkNlUlh6ZFNNVVNCVDVU?=
 =?utf-8?B?U0xBVHZFV1l0cDd4WVhjLzRnV2dHeU55cnNtUG80SGFrQUlqdllRdXMvSTRY?=
 =?utf-8?B?MVRoMXdVTXg4bS9WQjlBaCtjdmNoaUVUK1dSVkpNTS9xSGxKdEJFUkp4aGIv?=
 =?utf-8?B?aXNPVXNSdXQ5OEJGcDJ2K2xqL2xNTWp2ZFBQSjU4L0JyRTkxb0NBdkxZRXc1?=
 =?utf-8?B?QWNjR282YUZLcE4zRU9WMHBjZGt2UTh1MU1TMVcybStueURtMmFaNXlqeTFl?=
 =?utf-8?B?dktTbEVEdnhOY01xNFIxZ0UyaHNnNHlpSklWUGxqU3BUNGFUbmF0aW83M2Rw?=
 =?utf-8?B?amtpT3l2bFZkSDlBbVpKeU5ING1kcjV3S1FQdFAzTmRJb0xvZVkrY2hkV2FX?=
 =?utf-8?B?TUJ4NnZjVW83cFBORjhlZ21BWUJ6UnQzYTJJUkpuanQ3SGRGSFdrZGdxVFZi?=
 =?utf-8?B?Um44WkF4V0NBMXFib2xybTErZXI2ZWU5ZjArZWZxcWs3bU53dngrOTNocGRG?=
 =?utf-8?B?L3lzN0JaTGFkSDVkaEtYdHFLMmE5dWdaTmNTZkd6RnNhaFBsMXFyMWRXVHZt?=
 =?utf-8?B?MVdsR0J5OHA0RkZkcCtxSllMU1FkaXpGMTNOZm5CMzJ3K3QrMGxsUW1LK2Qz?=
 =?utf-8?B?cjFielF4L1FMdnB3ZXZaZkJGRVNxS0JZRm05SlBodVQrR0Z5WjdrWDVtQmZl?=
 =?utf-8?B?cjlvQ1ZJYWY5L2pCK3p4TlpEclZDU1JPUTN3VEQrc01XZ1JUOEN3bElDMFBp?=
 =?utf-8?B?ZS9VMjg3Um1RdzZEcHVSM0FDdDdLTnVJbHZFd291a25lMmVBaVQxZTM2a2VU?=
 =?utf-8?B?OE1xTUlOS1A2VUFQK0RteVlYMVF1dGh1VDhEbjQrZ0Y2Ni9idkpVL1VzeWtC?=
 =?utf-8?B?RmpnMW83c1hLTTV0a3o5V0YxOG1mTFByZkVaUXFxZWlBeWtZdUZhZHdzc0VN?=
 =?utf-8?B?V2RmV3FvREg5cm9PTnIxT2dLKzE4aFI4RUR5OXNjSWlJbGZLUjdMQ21ZTWw4?=
 =?utf-8?B?R1NIS2dLWllvcUdVNGtMUkFLeEdSLytoa2hKaTFHZ3BZWUJRa1FRenpxYysv?=
 =?utf-8?B?VjBkR2N6WmorVTZ3UE9xUTNRWktqOEJ3S3pUSlJ3UGlldWxkWDY0WGlUZVUx?=
 =?utf-8?B?M1JPRm5LRHRTZngvSEZ4Uy9xZTRRcjJHRm9LbXd2NWJOOE55U0Q5QWFickx4?=
 =?utf-8?B?Y1ZERVhDUStVaG5aNDJUMUI4c3ljNElja1BoT3JocnBYMjZYVVRzdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86002f2d-60ae-45a4-dc7d-08df1e11cf92
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:09:55.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZei+2JLBKZr/vG5/kE6hnmJEkRP6TpHSyApRuO6EyKuPDIQ67yNAuVDfiWP7HCj8+xV7DxKue4ME6iHkqw30g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

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

Changes in v7:

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Wrapped .prepare/.complete in pm_sleep_ptr() instead of pm_ptr().
- Fixed code alignment issues.

Changes in v6:

scsi: ufs: dwc: Return a negative error if the link is down:
- Translate a positive UIC command result from ufshcd_dme_get() into -EIO.
- Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- Added Reviewed-by: Frank Li.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Added Reviewed-by: Frank Li.

Changes in v5:

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- New patch. Split the macro reorder into its own cleanup.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Return the real poller error on timeout, not a forced -ETIMEDOUT.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.
- Removed the select: block and the clocks description.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Documented the timeout values as driver-defined bounds.
- Wrapped .prepare/.complete in pm_ptr().

arm64: dts: freescale: s32n79: Add UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.

Changes in v4:

scsi: ufs: dwc: Return a negative error if the link is down:
- New patch. ufshcd_dwc_link_is_up() now returns a negative errno on failure
  instead of a positive value.

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

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

Larisa Grigore (12):
  scsi: ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  49 ++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   5 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  10 +
 drivers/ufs/core/ufshcd.c                     |  73 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 546 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  86 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 851 insertions(+), 196 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

