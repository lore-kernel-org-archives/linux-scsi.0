Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6987F49219D;
	Mon, 14 Sep 2026 12:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390212; cv=fail; b=mAf5aHilv8LSEIRI9C48LV40RT9cLnIRrtFZXY4XqvdUTRG58Ls/a8Rp04t6jXDPjReq/mrXRzr7nSVxvplsQTOUXLt1gKWaWzz66EJ8gUPtWlVxS3HkdsD1KXcsRXoW2w5qVxlwdqEa2nTNjQqdMh7Z6MuPUdkj+3wb1qbsHI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390212; c=relaxed/simple;
	bh=hVBAzQ4JwSD1anAQZeisqPQCM2zG7rT0tZOYN9Wat0o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jnYenl6kyAiQxdbVekhyGvQKu7cYaVTiVpu1XvRsShjiQ2Fu2UEGxiegORnezd9bT9Uf1Hk7+ltpQe1lD9cC6PYnh2+giKWEWF2xNZEEF3nS3TwOW3sOsdWrsPTku+J5+m2Pk6tVZPNB8S2Y1YqtHddpNFYEwQ4KtVnYJbtv8yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=kuUwcKtN; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="kuUwcKtN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3IgG8pE2Gi3E4svLC9YsTsgt85nasZDhdyraKIhiha08eNQZD6fbn9CFTrC2Nhf6enuyWBmd5BpdVWuVnHQP8rrKYVUQaVP7WkJtl8TYayV0gaIHxFwAraVn2FCU6tWSgSpReRedpreJBno5CpmYc4SAvXoVEO6+zE3fD76X9B6L/a++KxyUPXYTnlfTHQFguO/97ApDg5KmJRfSykZUFKtMIE3E18aihSUnpbx/FkCx8U6SctHKterdw53TerGXSceYvVUkhIr+OT2r7AhVBufTymubgpFahRz84XyT9xWD/z1rG8drpv4JGsvQeH0kuSvwnlckn4J+1yo79kBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+9q6jhFAEXAqhIktemGbHT6o3/sofXbUrP7eHdZqhk=;
 b=KK7IwSoUS83bfZaRQtZZMwiullTlpZ9Pg8N09KnGs096QO9Gri3lf9MzWIHQQk+/dExThBFl9rO9ZiujjfIQvU2ghhJFjpKeU5cpohpJDfgyHU82lmFzy1EGJJDT0NpG/PkRBJMTZUofbB91Ekx6qn9ecZasysC+hTJs16rCOKQgbMBJerljveeh1Pz6zefIj4iU9laIkh7cW4nVaUDEq+EIUtpEXQ22wIosJ770OnsRQ9aOYzv6dGzlp84R4r+UlhKTVl7sPyLlLC5xKUmZTrn0ln/KEnR7YQMwqUxJWUszdB/n9h6X7zkMzItXyfkwCpPiS7OiLs+3VhL9DqB0xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+9q6jhFAEXAqhIktemGbHT6o3/sofXbUrP7eHdZqhk=;
 b=kuUwcKtNrmk0ezsfzQ09XYh4OEwoyyE5ZMAJFFnGmLhm/SNbmaYTjzdVaC3DHQD4ZlmF7iQNdp7jDFlEfXWzy05y73beGVgy3a2TeS6cLuNrkBHsACt42+V7GgZdO1YbVDAP2uJO8LzU7DGzI0ydzrRJwBoC71/Q3pXehHGCOyQIXWtya6jKy5i03gBPvGCODyrT2hWCI66RbAZxggb0cKwbESIRj7OhO/tsnW0f0bdZS6dcr873T/zmY4/QXD/bXgQI5pxbxMqJsETAfh0Y/mbMNqfmwG4fwmWmck57VvI5LrHkAeBydpEuF+h/Fq3aSExYcZ1+E2wPgIumvezoDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8971.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:04 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:04 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v2 00/10] Add S32N79RDB UFS support
Date: Mon, 14 Sep 2026 14:49:50 +0200
Message-ID: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: ec603e7b-bd40-4f6e-afda-08df125eb299
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|921020|11063799006|56012099006|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 CE9Hb2oyiY65MhpGfD7etJBf+W78tUwrOvmSawAYHjK6AhYE4xbH/jdD5u7zmOq9ILP+HD+1JmHisz6r8sgSblvZkT1ZGG9iyZlyzXMV8lktjxRnP5XA9ZwEi1EUn1FHF9/1rWnO0sE9LL+qdMQ2Pp2xFqIrjvxrv1ak2b1t8P2knM2A2L8oY3D1wSdCABVHMOKcWqgDdu829awpl4Di6ole223+9fjcG6xyf25+lear9boraj3mgoBXCmtyH5Eq/hkoPmZPfHGaYmEUutz3vLKqy1pPXcO5z9t5Ro1Q2+qUXAFaeYMpaafh/D3402JUcL48dTfocKkzw/3DU7SzGaPpjFP0C3wYfri3aT+anG2IG9YEsQVfi2ABTptryR7elqXkXfhR+BmRX4Aev0TZjuELGIRp273ZolZ/3wBVQOG4wfu9a751d5p5jRDswy6kIiyIlk0OcYwJDfM0e3XQDvONeQ3eYEqbmOZokXTO+nBmYLW1O+V+0bcKG+1hHyS49FpWh+7GN7jLF+KAHZrsqMg92O7AzOn8Lfs15c2fyynCeU65Xdj2n3Z6IoEdAz0no492rosppoWVDBEvkutUw/oB90jvsFcNw/LAA/zQUWW1BfA9AxZsc/sV/ivdvfOIfrJ+2UXFQZkFAj/2brJa7izgt0jfmZ+3Zg3e6ypqc7mS52Tf8SRJ+S6qIZK/g6dswZ34u8dPR0M+inKERmNgxw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?b1BWYjhlMGZ1aHJsL3RqRm9takF6WlB0VWc1K3d4ZTN5M1puSTNTN2RKbnZv?=
 =?utf-8?B?QS9tbm5hcGkyUGFsWEd5SkxzMCtuTnYyNklhS256Z2dWUlhQTzMzY2t2bWZ5?=
 =?utf-8?B?bzFORkU3am1zVGxaSmtLbkhudUpMSlRHVFBROUhBUUNuYVBaWXBlK2Mzajlr?=
 =?utf-8?B?UUJOdGhVM3BpV1hJaldBY3BSeG1ZVU9rRTFzdlcxNlBhakh4dDNWWjFjQ2R4?=
 =?utf-8?B?K0MxRGtqa0d0OVM0LzRoRDdwS3EydnFCS0JVR1BKKzF4dTZoTzFhbVBUUkdu?=
 =?utf-8?B?MFpwemxyV04rRHdubWZOSmgzUG5oN2NXTDBWNHh1MkR2Qi9idUJKVmJhYUls?=
 =?utf-8?B?cHg5djhZZEZiNk1YODZhZFc5NDFxSElpdTdrNFdwM2ZlSHVtZXFZMHdDTWZY?=
 =?utf-8?B?MzFOTnQrWUVDZkxEZHp6T2hXWXQzWm1ZY3lrL21Wc0RjNHJJc3dUL2NkaCtr?=
 =?utf-8?B?TmhGWUVsOFk1Tm5hYTRyMnhuMm5IWktVcWRmZDI4K2VmVFVVb2dER1JRR3g5?=
 =?utf-8?B?M2ZudGtPeDZ4K1FuanJEdnF5bjY1K3J3cU9QMkRMejQwdTltSHQzLzBvWnZR?=
 =?utf-8?B?eHpSR1Bhem82a3dDVXBvWVdFdlEzL3UwVFk5YXhIVGJFYW5meWVvdnFRLzhP?=
 =?utf-8?B?UnRQWFBPM1AzTFIzMEE1dGZHMkE4WVNnUVF6Wnh2N2s1dlVwSUJOajlkSEo1?=
 =?utf-8?B?L25YL2VUTHNXVUl4SWpZbzJBYW5YaHRKaEVLWVNuVUEzUndkL2JUKzcwS0xT?=
 =?utf-8?B?TElLNk9EQWFkaDhiK0FaSzhuT3Y5aUNWUG9YcU0wYzB1UzlhK2d6dExweHlG?=
 =?utf-8?B?RjhZck5jKzFZVzRwT3BFZHB6TnlWU0dycEtxOFBOZmU1T05iZW9IdU1Sd1RT?=
 =?utf-8?B?aTZjWW9QbGQvSTVROWFtT01PL1Q4SVluWkdIYmNYbHNzUDJWekdKamxKd1Jy?=
 =?utf-8?B?Mk0vM1FFeTVRZm9mRzBhT1JaanNFVE5oaXZhZ3dGbjRJblJ3WEJKWStCYjFr?=
 =?utf-8?B?Q1FDOWcyZ09TRzZoamdxQXh0cDBJWXkxNTdxUExNa0pWYkxoL1lTcSt0WXk1?=
 =?utf-8?B?RzRUa04yYVpEZy92ZzRHdlVLa25ZVWZTbVJlQ0NiakorUWNBbllJd25TSDVm?=
 =?utf-8?B?MjlIdlpQeElnc1NuKzNoS2dJSDc5a09Rd2t1U0tuS2xzZTNaalh1U3p3MjJy?=
 =?utf-8?B?NWxwNDl1anZONW5PYi9GbnEvUjh1ck81UFFKMkF4ZVBnbFlVcFQraDlVRW9m?=
 =?utf-8?B?ZGljUno4aXpXWCtYdWNLZ2FpaHQvU3Brd2kwc1hGcENYV0NScEdGWDlocUI5?=
 =?utf-8?B?Y01CODdORXdWbitjcEw0aTRSMU5TLzdUb2xtZkFnN0w0cUFpazBHNDdrMzZN?=
 =?utf-8?B?VUJSSXRPbUVVdTBjZ2JwMENxK2JDN2hrK2YrZEVHeDJ4T1hURTlaUGZuMmpm?=
 =?utf-8?B?Qk1UbTV6YkJFMks4eCtRU2F4RlFnMGlVZTNQVUI5NmltWGM5ZUU3L0tYc2kx?=
 =?utf-8?B?c1BveUpBVENIR0JXZWZhaHFIWGlpSmVjRUZjVEhKbTVGRDYxdmVmYm5sSkU0?=
 =?utf-8?B?MkNtVlREVWlrN0RhZk4xbml1MGVIMENscXc4YURSMTBpa3M3SWtzOFhFNWtE?=
 =?utf-8?B?KzN6M053VzBjemgxTkdGMlNIdndwOWR1VEdaOXFKK0xsRlgrTG12SEhjYjVx?=
 =?utf-8?B?VFM2a04zQytVbnJ1bk41b1k2c2hMN2lYK2d6N1FWRldzMCt2YU1kQWZPdnlG?=
 =?utf-8?B?N2p2WjNHMjdaZHBjNTlKc01ZQTllRFgzYUh2SmdTd0NOQVc3MWJaYU14MU11?=
 =?utf-8?B?ZWFSMXp1cmZzeEd4bEYxNllVZWZwMytNQ2VDYnRwUWFkZXlaWXd0VWFvSExG?=
 =?utf-8?B?ZG5hcWxabEVXaEcyRzFwZ2hLUjg3RGlpVExaYWFEMHFkQnEvQ3h5Z1NMbjRR?=
 =?utf-8?B?eTMyUVRVWXFKUTQ3a3VwSjVFRUIzZDIzdHhDTFh5OG9BZVY2S1ErVWRIUFUz?=
 =?utf-8?B?UjczQ3RqNDNIUFFWaDd3eFpvekw0cWh4WHV5SUwrN2xCRy9wZE5NMyt1bVdF?=
 =?utf-8?B?cDJGbmpMcHc3RkRHblp0U3VWUllQNFJpUW1lOGgyTWVFZlhoWXNmYzdNNWZp?=
 =?utf-8?B?aXFVeVlUSGhjMURJNm8zc044OEFHSUlTaUJ3aEhpVjdWQTh1QllPMjNDQUs0?=
 =?utf-8?B?T2ZGYWo5VHhWbmlRSzR0ZFZZM3YwU3JVUnB2VURuejJzdVZaSmc1Y2t4TlNp?=
 =?utf-8?B?ZlNoVmF4SVRtb1RWcWJPTjdtUXVDUEV5Mk0wWGViL05Ic0NoSE5kL1Z5MFdB?=
 =?utf-8?B?b3poQWNoRFJCWld3dUE5Y3V0cUxBeXhVajRZV2YrTWM0S0srQ3dtZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec603e7b-bd40-4f6e-afda-08df125eb299
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:04.4756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGu6TELnxR95fZ1IO672ETjBhYYhJsKLFN0KNUMHQPo/AFhQnPhgtLHzEIcutNO5LOdg8pJ1GzOeg//EyVBWxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

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
 drivers/ufs/core/ufshcd.c                     |  78 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 538 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  75 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshcd-pltfrm.c              |   1 +
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 19 files changed, 855 insertions(+), 191 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

