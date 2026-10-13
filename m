Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BE94DDB3C;
	Tue, 13 Oct 2026 10:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887449; cv=fail; b=kiHlN+SI7jte71tvkLtjkMUMfLIl/Io0Wul9UAJJzXKT34MYGUzKzNIy9+LzeIVZ4Xv8ECNfdBEumQUVIyELFEDgp+mqmPxkW4l+n2j7Jsh7duxLC8rIEuZ2loV5kLz8HvrL29ijwVhe0HkoXEZKHwJj/eY0tq19LXlvCpUgD/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887449; c=relaxed/simple;
	bh=uSBBigONWjnMaqbMz06v7/0KmOUwapcZJ6//31oo4Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=afCnXMIQq1kBQSHA1zXCrEjRALJShCJJ+cgwhTDHKI4y7t6m9E2CF1kXSXvR36x0FzjCS2cmPWMI6mdNagRcEbr1AYD0C6BeK0vwhxnDF2rnJOEXNGWJ1tmSVB7qlLZNjyvSfiQIpNMdlciGv+K6hZ/XSF5RE9m45U5Vie/G/Js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=QARjhMOy; arc=fail smtp.client-ip=52.101.70.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QARjhMOy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUarwt2s0c6w9Dhg1pE31vQSZKbLFGE4JNl4swVmbar0NxdF7+ni9bIVDiGxpViaE8iTs5vmegxogtR6tuPQXgAD+5p5AGG7pxuh/S/JYXGufLCuQbpj83estcPquFg+Mz5/vO04IVQ7bt5dNOg2D9Vl8ODahXfSuMa2vG/OUhRdT/XCmH4wOwEHUWYuUMSgiOjEnJPwbpn+C9C5B8MmsBISWNostIeSdJWE/7WMZSGX3q+VrpGe8GR6IKfouqZIxSMNzvu4FSlsx6Z82a3aeDrgbGtXovP8mCKPDTXx/aqJNKEZ2j3pTw/kLNNu/7smJt0213WU+NuagdGYS3By1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC4vJfnPjB1x1u5qLDlo6eDSpEL8qkz7BUzUd6gqKRo=;
 b=wPv4poPlBTE8XMQ+OyX3Le/PAv1DB3AjX8dkdmx5twIu8CcuMHttHa+4WCKLJeLpMLQh3vXeCJqSn98foaXGgPCG24nmIBeD0FzrAmTCEtS2OyR8qbEr96ME/FiyK1T64m/ADtXDHe91n2xxOo7RmJaB01S+itFtwRNC3NleuE9CU3jEwAZChU4YHjJsO0GphgqZDDf+KvtDE0yk4cGcKkp3hWmBZpMf618Qs2imzKOeGIareXHkZkYvjRyad98D20noaUnyUYwVo72TKyh2kA1MtwF7KzYGbSRfj1Z15fdfnmAwLbdISBzXlrC4RgtggJn3IyRsHXQrbAB6UB4jLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC4vJfnPjB1x1u5qLDlo6eDSpEL8qkz7BUzUd6gqKRo=;
 b=QARjhMOyzy4mBEoMX0rp4F5K7YXN1nx8hsoC8v9siPK6klNxZ7YJ1QXzDUpsNu7mdj1bzj5Ad7k1M435/zEd8MJ1wsxT3reHKvBcHPHXNQiKn0g2g6ARG+2Fl5MxFZwYHXW5JXEIWK4LC4K61bB8vWQlHoOj1gtqbT2EIuSRhiIO3IyZMAsG06wLiQPidNkXbvFGsxcIULVunrmvP4RhkJCOiqPPr9MKnkiOj1WEpRFM/z+iyZvpB+zwGiIKVs1zs5hb66M8e7XagnSZQ75WikIIogEYwUlES43FZZRFMKOmagnnXFC3qH5mQL+AL85S3GM5L1FFcZi5Xvr7OM0L2w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:42 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:42 +0000
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
Subject: [PATCH v8 09/12] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Tue, 13 Oct 2026 12:30:00 +0200
Message-ID: <20261013103003.373156-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 0cc69265-521f-4213-8d7a-08df2915083a
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|6133799003|22082099003|10067099003|18002099003|3023799007|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 Oq33HbJISJ6s2gAE6hc8IO49+v8CDisMNa2nAkn/PhpLnm10QHpCwfZ38JwSQRXHgK6bMZI4ytVDQGnEGScYbGZOzLo5+EtIYPpWvIwywQjidSxi5T8d3iBpLyDPz15Zbat9CO2z0CpUWceYdaXDSCMKmFuIRpwg9F2pw+IVVfofK+l/CgClvgRRze3+ckzxOQY28VSkHSi0gK/Tp665Y6+FpB5EOCmj+kSFHddGIroPOQoXJkZA2CbuQ/yvN+JyFDCNfPeY9i5/FQ656Lj49J4qXZbdkdWho114425cnSUSd4Vd8OXmgoXkOumIi2B9Uh3+0/gk/KSoNwBpiKk+Ci+Ui+tFdL7HIo28WuIMp4xkF/Z8H+nEg1kIurozW1Ztjlr3huKT7NqJQeuxUu1TfcD9eLyC8sFXwRE43RNVSbJcULV1ELGCOr6veqsiCDMYeOSphAU/s4u9R8rjLNfjA62bRrq6TC8dAhYdDcOao88S+vxfvpmGBxCJ3TZFmrWTuZieyZjYwFVYroTUA5VScefaiGexEwN8lnV9VAPcJBB/4T+70fBtZe21cD/MLG9Uf++QRkqTA3JYABtbeatOvOeO02XhQ8i3xeDYvM/z9xqSdkI1SE/nzEjK2j5UC5hPgrFXZx86FvYX/TmqWQ6wJ4cRa+pzjLLKnFzhkakGV9zXjcLj124Ugvs+uumOKwdConz3zjb/wmUS05Jmd6B6RA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(22082099003)(10067099003)(18002099003)(3023799007)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ajU4eGF4bDdYUmh5M1RpYjBpUzg2citEMlNCRkpLZG5mQU8rcU04WHVoZllj?=
 =?utf-8?B?NnRPMzNiVDRKZG56VjArb09ORzc3MFV2elM4YmpYMFNmUWl3aXk0RkY2YjM1?=
 =?utf-8?B?OTVoRGZqNWxZaU9vM3hUQThYMkpDUGNzbCtFblR2dno1bmZYWk1sN2I4OTFM?=
 =?utf-8?B?R0lZVWNFaldGcmpSamVvbEFUWnREb2dNS3F4eHJ6dlMwWnJsYzhjelZZOXFO?=
 =?utf-8?B?dzJyZWJpdlg5NTkzN1NZQVpKdFBycEx3dnB4MkVYWHNPNzNYT1Fzc2Y5Q0No?=
 =?utf-8?B?L0JBMzhiTlFhdjRZVWxReXREclU1Tnp4ZlFGQ3F1SzJHQVkrbFlQcThuMU52?=
 =?utf-8?B?YlplRWtmV0FnWFRqRlBEYzZTUXo0YTlWNXl5WVExSGk2eHlLOWZBVmc2Unhp?=
 =?utf-8?B?bHo3d2g0RndFc1FzL0hjL1NPTm9oSGYwL0hJTTUvS2kwZjRxcE1CNitxR1VZ?=
 =?utf-8?B?UzJ2UUhCTFlPem1Ua2Eyd3dyMmFYb010UkFzcUx1bFcvVmYzb2pJOHFFbTZy?=
 =?utf-8?B?RUlIeGdEYkpKcjloSUdEaXd4Y0xCaFJVaVhpMlhzaTRnWFdjN0FaTHlUZHhR?=
 =?utf-8?B?UmVibzZhQUJVTWJGSElnTGZiLzd0NFBnTW9GZUJ5NCtoYWp2OXErSFJVZ3g0?=
 =?utf-8?B?Z1IzQWdpT2lWSk1mTnBqQzZybUZZY0NxZWxua1MrSkhHK0U3SXYrZFV3M3Rx?=
 =?utf-8?B?R25Cd2M1WjJBN1JMNDZwZzUzNXdSUzVKQzhnOVJuaWk4WWRsYWs0eGZGOXVH?=
 =?utf-8?B?bEk2VkNzY1E2dFNOZXcxcTlndFVuL0RKa1dpOElONGFpN3lBbDMwWDdKS3lC?=
 =?utf-8?B?SmlwRVpjWEg1dElpNmx3SnQvcENuUFlLK3VCQW1mT3BhbFlQY3gycWVzTzlK?=
 =?utf-8?B?VVUwVXN1NmRxSU5Pb3VtWHI1TitscUdLN0NPZkFNSGovUWFxT244Y3hnRzk2?=
 =?utf-8?B?T2lJQVNvUW96S3hnVFRRQmhHQlRGaXpzOU8waDZWb1RQSXRub1I3TnQxNlg0?=
 =?utf-8?B?MFVEM2lDK0pGa1pQMHN2V3FqWmxiUXRqeUpsS0JIbTdOdlF2UFliNy80akd6?=
 =?utf-8?B?bmdseEFsU1hGVDhMcEkvNVlSMTJ3QnVuNnovM0liamZPaUUveTFyR1JyTGhl?=
 =?utf-8?B?dEdLQnJoeWowSUt5QzFkeGltTFQ1SitnNjVYek1zK0FoQkJKT1RNVGNCckV5?=
 =?utf-8?B?eU14TE1BY0Fpa3ZxeURrSnpjUHNkV1VYWlF2MDhON1FkdnNoNFVEUXkxZFBS?=
 =?utf-8?B?QzBrdTYwQzI5VnA3YTdLdEFrc2lCRlA0NDdPbEdqOG9xN3haY3pHV0pnRmZv?=
 =?utf-8?B?Y1pZbjBOYkJSLy9mZkZmTDFVOVBtenZ4Q3BVMmN0SUhkSTlxTll6WHBScDNQ?=
 =?utf-8?B?MEpVcTF5dWpBOGVVMThGZGozTHpobVdNWFFlMXFtdGhTTDZZbUo1K2pTZkpq?=
 =?utf-8?B?aU1aUVF6QXpjRTFHWmVLeTdaYnZOUUlwa1JUaE1oNmttN0VMUW1qcHNHTXA4?=
 =?utf-8?B?WnZFWHVVempOTFF6WFpkeUp5enZmemFrNmoxOGJzU0ZMeHJTSis0MFFWR21j?=
 =?utf-8?B?SkQraE9JcTFQcEFUa1QwSmZOZDFmUEN1bFQyZFlmQ1hCUWQrZDEwVW1XaG8z?=
 =?utf-8?B?cnlvQis0WkI1ay9pSml3djh5Zk5qcmEyc3NMc2JCQlk2NFNTZW9YMnFuYng2?=
 =?utf-8?B?WGVqOWQ1bzRWNTRQRllUdGxGUjJhUGtib2llNnQ5WUxJNkgzdUVZTEhPbGtL?=
 =?utf-8?B?cXBJTmZkcDJEV1RBbUJqVmhvV3llNGNnZ1YwaGxhZUJCVUxydG04Y29JUGRM?=
 =?utf-8?B?K0VIaFdPR01nTHJIRXNCaVVwcW1hRFhVMk9YM2ZqemFqSm8zZkg1RlNZcE9R?=
 =?utf-8?B?dmdaeTZtWGNYTnZ4MDlPemhsMlpOQTNsVlhZbmVZcjdBRGdyT0xYWmVqemUx?=
 =?utf-8?B?UDFSWWZtSDkxOWh0MXRBVllCUnZhcnM4MVdRTE1WTGVwdU9QMkNjSVdsRUsx?=
 =?utf-8?B?UWpsNTY3dGdKUHcxT0k2eDJ2QlNWMFBlZSswdEV1N01IaTRudXRSN0s4QXRl?=
 =?utf-8?B?czFpVTQ2WDZqUi96Kzhob1BoRmhPT3IwQk54Y08zM3VvbFJOSldpSnJkRmti?=
 =?utf-8?B?VnREdWRpc21FUnE3OTh2NzNxNGRTbXZzbEUxYTJRdHF6cWxPNGRUUUF4c2Q4?=
 =?utf-8?B?eXlKRFlaMHZnQXJGZm0wN3ZkK2FOQ1l0U1dqVHd5dm8wS2NmbFFWd0dyajAx?=
 =?utf-8?B?WStmSHRnL0UvSnRUUlJZSWl6bVF2bXc4VXliRlRZZVBrQmxLSVF5K1BSeEpk?=
 =?utf-8?B?TGl1NjRKSVhpdUxLMmFRV2hhY0RhTzFRNC9qV0JBVndld2JXcHF6QT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc69265-521f-4213-8d7a-08df2915083a
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:41.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nan2ghokItQBkEoKR46xKPb3uf9s9spTyzq290zWkht1m+in4JKSveL6y9lqfowZfVOmMuweZvvuI+8k+e/vMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

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
 drivers/ufs/host/ufs-nxp-s32n7.c | 540 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |  10 +
 drivers/ufs/host/ufshci-dwc.h    |   6 +
 5 files changed, 569 insertions(+)
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
index 000000000000..e7bfbefa39b9
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,540 @@
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
+ * @reg_scm: SCM register base address
+ * @soc_data: SoC-specific configuration data
+ */
+struct s32n7_ufs {
+	void __iomem *reg_scm;
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
+static int ufs_s32n7_configure_clocks(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	struct ufs_clk_info *clki;
+	unsigned long clk_rate = 0;
+	unsigned long one_us_tick;
+
+	/*
+	 * The core reference clock is managed by the UFS core (it is listed in
+	 * the DT via clock-names/operating-points-v2 and added to
+	 * hba->clk_list_head). Read its rate from there to derive
+	 * ONE_US_TICK/HCLKDIV.
+	 */
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk) &&
+		    !strcmp(clki->name, "core")) {
+			clk_rate = clk_get_rate(clki->clk);
+			break;
+		}
+	}
+
+	if (!clk_rate) {
+		dev_err(dev, "Failed to get valid clock rate.\n");
+		return -EINVAL;
+	}
+
+	one_us_tick = clk_rate / USEC_PER_SEC;
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

