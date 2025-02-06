Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B558222570;
	Thu,  6 Feb 2025 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738832162; cv=fail; b=ri40HRmP1UpQUMYjcMvO15DB69XgcaCWfz1wKTc/wohVX2iQuFQfAJ1nWjt5we3DsuWTjES15uqfyOcNq1Tc4vlXeSKiX+A3GNX0m62ZG7x9jvvF++VzHf0ygpXz40H9T/itaaDBDURz3yZbr14IvWSpZi3W2g9Z1YNFAAQlzW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738832162; c=relaxed/simple;
	bh=JsxnEhhEF22uJi3Eq9JfopgqB2x3VQEO4YYTbHa2Tzw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iumxw+LDqlxTq8ZEAeM82s5tu3RuHeWHAD63CPpezaxUkj0K35rMYaQPO5nYFIwaBmB0ZHnJZjb6mA01v8dOaVcprJTAMkaYlt+RP8WPfZrvAYVcF+DyrydtMoXJfxMESjHNlzQDy//A9fi+FpTDAuGuky8/NddrYM+Un1u4/oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NDhULuTO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dIs53/+K; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NDhULuTO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dIs53/+K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738832160; x=1770368160;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JsxnEhhEF22uJi3Eq9JfopgqB2x3VQEO4YYTbHa2Tzw=;
  b=NDhULuTOvc1zxYEVk6s2guHOey52jy83eUaDwXuMF9YrZwJtSteWKWMc
   YZQvOasAVD+6rfbqyuqoUSrKKHHre96HcSdeonB9fOx7QNkdWW8tp5/jR
   ybbv1NLnE9ixV4jL8DBx20dS5T8DQpZuA4ydyIlDhHMID/OCV+/911oMy
   ij7UxRVZapAtEw8paGsVRvFRmW86UYWaSHfhULhiTAEb1Tb4c8MR4UhXl
   alMqygwqEOe4dm9Mguafi0vEmBGwZmwMcIE40reFQK7ndxBy7x/yyVuUl
   yfV8B7qBcuby2dIjo40dSl2+pQyccuBYPD7IrYmzUobAJYUNZ1OEFEQ0V
   g==;
X-CSE-ConnectionGUID: uOAf0AJUQQu9tjNSCeFs0g==
X-CSE-MsgGUID: AxIfPYOHRBaOFppgDP127Q==
X-IronPort-AV: E=Sophos;i="6.13,264,1732550400"; 
   d="scan'208";a="38762809"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.8])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2025 16:54:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEomo3jZQmSopCbP/NnBNKr9U7TMN73MLSgTafPSgoC2PpyEiTi5r/MTdhj/vHGL492NwhKVin9XRKaZOw7JkTnPn0tPmy1GweyVyL5zWqB1jS8O/WZvEeIevnvkcJ1c0M1w8SoHyGXhdGqVHa5ppDTrIawhw5qO+RyVx77ZX2vHKupDK+yPmehHlV6KKe7X0rnIgHAvIZw7Loe1SwrGnjxCM6oXufi5onLUN5g46WCevwsgwjLWQyh9lDPirLNl4U3U9uysML5Z1tjHqpC+hAdni5IMAWWneNOWjHXUPn3Bc3M0X/ObR2QFrpsj7VL/FJE1dGGwwztQt7626gu5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsxnEhhEF22uJi3Eq9JfopgqB2x3VQEO4YYTbHa2Tzw=;
 b=QLPN9Kd3LnO/bYFAzjRdvMTQQ2FYw/YwGSFLRFobk6+AIW7ml/nYcOpqv8NT5ZKnTgwfioGczfspGNRy29/eOV4hZWeYyhWsONxu2kSkmCLr0FoFFmC1wHx87YNRZuv65ILw3MZ2OoDPdmpjvmUBAZcS5k08ryFfahLgmyARpqcMGqr1lSFkrEm+yX3vEm3Icj2HaxF16hIl2giD1a7ALY5zIfOxmSj5groNkmad/0LWyFcZ0zTAABFi1aj/VV9TFCPLGy/GURViZoYaGO4WyzJWvH8PEu4jBS4vuCMSW+NZaVW/6Yf2x3h55EXP7J8LbP0zsdQdEKfwBim57iv1VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsxnEhhEF22uJi3Eq9JfopgqB2x3VQEO4YYTbHa2Tzw=;
 b=dIs53/+KgVVzCmpGgzF2R2tjDMyeHNy0XP9PcYtn0Ay9oidted9YEFG4HoYHqSJ8stoJ5B6VSlwLm44ZcK7Rwm2asYKYLry22i6kQmvtqD46LTTxVAtrLg4zCo/Ijchr7Z572IvurGTS5ZgKweco++pzOyeG0pXN/fbPkTaBh9g=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.11; Thu, 6 Feb 2025 08:54:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.8398.027; Thu, 6 Feb 2025
 08:54:28 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: critical health condition
Thread-Topic: [PATCH v2] scsi: ufs: critical health condition
Thread-Index: AQHbdxHmvf69B4w9AEaXxutfZEUuCLM5AagAgAASWaCAAORSAA==
Date: Thu, 6 Feb 2025 08:54:28 +0000
Message-ID:
 <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To:
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7761:EE_
x-ms-office365-filtering-correlation-id: 555889ef-07d4-476d-3ecd-08dd468bdd3e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TWVkSTVLMVNQYXNmL0RqUFBuU1psRWFlVDFxMEc2dWF2dWtjaEJ5NEJnK20v?=
 =?utf-8?B?TC9JcCtHWW1EdmFWWWpMYWRqOXJ1dlBVa0FERmtjRUpLN2REWWZtemRIWURJ?=
 =?utf-8?B?cEZpNFdha1pnYmlQNEhHY2lIUUFCaGZQOFlERjNLV3hiQjNSc2hLMzFxM2Fp?=
 =?utf-8?B?T3hnbDVhZXliQU5YVmYyZnJXVzdPTnRnV1Q2NG5NS2U2Y2x4cnpVYm1IU0h1?=
 =?utf-8?B?cG9lTmcrVS83OW9GM0lQZ2QxRTcwU1o3Q0Rhd1RiYnl4T3FMSml5VHc0WDFm?=
 =?utf-8?B?Y0txTXg0NlM0eUJEMWpqQmQvbzVkZ1Z0R2QvYXYvZFRlQWhza3R0SnRPS2l4?=
 =?utf-8?B?d3Y4NVc5Y1JLQ2NmMDcrK3dDRUJRT1B0K2dwSlNmZ2QveVdQVWNsaWRvK3hI?=
 =?utf-8?B?Qk8rSUI5cWE2K1dpZnVKUlU4ay93czJPRzlaeHNPc2JMaDlSMTYybFNrZzFC?=
 =?utf-8?B?eTFrc2k3WWVJNGhqb3lWSGNxckVlZXd4eUs3RWJnalBNNGc2ZFNwTWd4bVVm?=
 =?utf-8?B?NitYRURqWWpIeWluZHZGSFlNdXJPY3hWMW1CQmRlQjl1Z0I4S1dVcUlWblJ2?=
 =?utf-8?B?TytLcjFqMzJtRXdyLzVLYUE1OE5tWWtTci8rME5UTzJnTm1VVEJmSThLT1d6?=
 =?utf-8?B?TEYxaDFWVDFRZzUva3o1T2V3SDU3U21DSXBJVmlrbGRsaENWV1BuK2lJUk9v?=
 =?utf-8?B?THRFejErMXJuTkpUM3JCUmswSGpEajY5bE5xRmU2Wk1BWG51c25VdkJWaE5Z?=
 =?utf-8?B?WGE1a0R4aC96YWhveGVkL2dzVVlqUEZxNXA2Sm5VT0IzcVpWYUplYkI3OFNY?=
 =?utf-8?B?cDJRdTRocXBGQVgxa3BwRkZ3YS9kbnhxb25Mc0FlYlVCejFTWENKWCtKREF5?=
 =?utf-8?B?T1YzeXU4OVBadlVYMWpkbnI4UUdWazl2UXBmVkdlczVIVEYvUG1xZStjcmxu?=
 =?utf-8?B?QUk4YnlzcmFlcU9Ma0xBK2RBWXhuNnE3USt3bTBLOXhrTmd4ZTVDQm1WOUV2?=
 =?utf-8?B?K09QalV0cjNGYTUwYjhab3ZweUxNRkhEOTR4Q29mbjFxZ2lXRlRpbnQwN3ZH?=
 =?utf-8?B?WFM0L0dYZlYvb3djendNckpjWUcwSnQ5TU5rekRiMlJCRnVXNmFYOTZtVTNi?=
 =?utf-8?B?eEVGbFlDSUpTaVVGb3RmcDlKRGNJVjhaWHdFaEdvaFQvdzJxcFpJWFpVNVZK?=
 =?utf-8?B?OFQwUWhCSmdIOUR1cFdiTFZ2a1QyYVgxSUwyVTFnbmd5UFVYWEhKb1lsT2ZI?=
 =?utf-8?B?WWpKYmFkak95cmY5ek5Xd0tUQU4vazJXanRBZmFRK281cyttZm40bDlKYlRZ?=
 =?utf-8?B?eGU4WGsvZm1jMVJ6bDhIdGRhZ3hjY0JIR09CVjloWlNPNlgzKzkxSDAzc25o?=
 =?utf-8?B?bHMwR1pHdllLNy9nQkIyZWV5eCswdUMyU0ZadFFUZENMOWkwU0VzM05BVHJt?=
 =?utf-8?B?cnQ4bVBHd2RmTWpKTW9pZTRBL0xCUE9yVmt6dHlWYUs5NTJEbDhnMUZndFpx?=
 =?utf-8?B?SXY3cURLUGNabnlTRUl4a0dJeWJSV09PNkc2SmkxMnNFblI5c0tLY1MwYlpT?=
 =?utf-8?B?UmFJMUZ5U0JYWVllSW42a2dqcjByWE5BdkJNN3JOaFA2aWJuNGJNdlhEWEhX?=
 =?utf-8?B?dmYxUmU1SE9NUWpEeHRmL3VadTI5M25NemVML2d5U2xOVWhod3ZhVklpa1lz?=
 =?utf-8?B?Mkk1RzBJN0xnYmFCOTNxa2doR2Zqb1c5KzRjZ1c0MCs5MEZCRUFFRUFxZkFw?=
 =?utf-8?B?eC96ZGNUeUN6alZxSDhhbnhjd0NLelFoR0hCZkRFS2JPUHpGcFkwVUdNVkFY?=
 =?utf-8?B?Ly9ITDUzengzMGZtMHA0UmxGRUFZQ1FuRVVjbnFFb3dndEVJUFZHZ0YvSHp2?=
 =?utf-8?B?YjVSQmgzVVdrei9VbnJPMXVIbGMzZkFTZW5IdGNKbFRwZXFZeU45RWRGeHdz?=
 =?utf-8?Q?mWBrIaC2dbP6pFmgxjJL5mJv73PWAiK0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R1JaOEFnN2YwT2tNanV2blZQOC9aL1hFYW52aWFWZ1d6cEZISUZMNThzSWtq?=
 =?utf-8?B?Wjhwc3lZNDB2S3FqTklIT2tLOUdwWmJyc2pmNVdKeS9WMU9ycVR3SUZzNGNi?=
 =?utf-8?B?T0hSenFIK2o2bkpOUEtiTURQenpUSkZGU2VXTVdmOHZlbVlmbnBQTXNsbElF?=
 =?utf-8?B?RC9RdDZ6RmNWMkh3bkVpamZWWXMzMkpEcmRVSmNiOUNWM0FoS0NJRHk1UVBy?=
 =?utf-8?B?UFdBSzkwUWtBMUlqbzFtVWtEaVdOby91YmYrOHFoNjJZMlBxWHdBUHZwZmF3?=
 =?utf-8?B?cEV5eU9VZS9oelFmODF0NlUydVZ3bG93c1M1VlU2amNLb3RsWHhmVjVrM1ha?=
 =?utf-8?B?N2c3ZEZIMmo2Q1Vvbm1YeFhERWpwbFZ4SHBEN2p0SjNqdWZkZ2g5Q3ZMVXl0?=
 =?utf-8?B?K0NEaTdDREZDOWxibmpEd1RTVWpZbk5rNktvYjY3MlpJZForRjc1VmlJYlhR?=
 =?utf-8?B?eFN1dUNNZnFoMndhRHVPVnoyU1E2c2VuNXN2TjFncTY0S1BMdzRZNVB1b2k3?=
 =?utf-8?B?UVpPaHZKS1VhOHdNb1ZxV1lLREYwUk44YVE2dHJJUTNZMUY0MnZWWEYxOW1i?=
 =?utf-8?B?YTJDK0d5VGgxODZlbDFvODFkZE0wZHlJR1hwQmhiVy81M25Ed0JkeThqSk5H?=
 =?utf-8?B?aFlhdTZXMUhDcnRpbC9TMzg2VXJESmJZcnpoaG1ONWo2Q0NONUZsN1kwaTJF?=
 =?utf-8?B?ZC8ra0lyTGtpZkVOYm1nTnFncHFtUDl2Z1lNaFBaeUxCeGVDaVp0cndPQWQw?=
 =?utf-8?B?d3k2RmhFbE9yZ2FLVjl5ZE5NRStDZmdSMmozYUx4d2dEMnJDanVOVXBBSGVL?=
 =?utf-8?B?YVFLNHI3aW1HM2FiMnB5OVRLV3Z6R1dndXo3dTRnN1JqZDg4SFRXNkx4aU9K?=
 =?utf-8?B?YUlWRHR2cDBUa25lZDQ0TTFHSVVGNFRBVzZYV1Fsclk3NmJLeWpuNlJYbkFm?=
 =?utf-8?B?alp1Y0JTRlNRNGZCcm5QODlwSmkvNDdwUW5aQ3hoQm5PK2ppWkZiRDRLVkh3?=
 =?utf-8?B?OFlKbFZoendxc3QzVlMrN1ZLRjVDVmxoYXhQYWgrc044dUlQVUViVzBicGZS?=
 =?utf-8?B?Y2ZDVzJsYndETDZnSTNxbXhPMmxiMEJoUzZwbGUreWxYWEZGTjljMTd6RWlX?=
 =?utf-8?B?d3RSeS9jelZVTjQraEptaWxvU3lGTW1uTlJRRzJ0MC81OHJicEV3elVzM2VD?=
 =?utf-8?B?anQrSWZRYlJoYWJDTkRldFFBK0dGSUhCTUhqYVU4N1I2OTJFUFhsOGZNWFQx?=
 =?utf-8?B?eHR1bm94SHFkakdqWTFNWFZxYVVLVHdYREd2Z2RobXJWWW51Q2JlQldJWVR1?=
 =?utf-8?B?R1IzYmpLNThDNUdVeGlRVXBKLzhWZzdKeFB1Rm5sNkdBdCtjekVQT0FrVlhI?=
 =?utf-8?B?VHlPNitKeFVCdkhkalFzblBOSElXeGRxclQ3OTlwSVpSQjAwQ2dOQUlQOC84?=
 =?utf-8?B?MVlBd1ZUczJMaWlqVEJEU3FxWEdjOTJRUU5kQ0d3MHFBMit5S2x6UzJwY25p?=
 =?utf-8?B?bTh4RlhJN1lxRDd6cDhyZnY4TzhxL1hYS1dOaVk3QWhTMU5oTWNEUk4rd2gz?=
 =?utf-8?B?TlVYdjl4OWxSa3pZVmpCSWRad0cyKytUYitHYnQ1N1hPTFRrQi9ESlh4T3Ur?=
 =?utf-8?B?L3g4VGlMWnJjYm9VQTFnbFJIZUxiVytWblV4Z0tESFM5anhsbWYyeWtNS1Vj?=
 =?utf-8?B?OThHdWRFQXFleFdzSlY1SG9JcUI2U2pJRUMxNStucWMrdnhkWlpVcWRBWGhU?=
 =?utf-8?B?Y0JFSTZWcGVGb1RHS29CR3pkM1hEaDI1UXFVY0RNRjBzSmZ0ZjIrSHpyMlZI?=
 =?utf-8?B?L1NQblNHaDMyQ1JwYTRXa0VST2FTTTNDOXZpYTRadnZiUmFxMUZ0NW15b0VJ?=
 =?utf-8?B?WUorUFNNdDZqdm1qcjRIbGxIOUt2N3BBcUlrVUZWYjhxajhsbmt2MGZsdHhR?=
 =?utf-8?B?MnNrTGkyNXQyNmRsZVNFVFlmdVhuZnR4ZXVpeWYySy9aWG1Ea0dLL0tDOVpE?=
 =?utf-8?B?UXZvdXZwRzl4dUh0V0RLWXIrTjBGVU5mdHJsNEhYWFNsYm9JMFYxam9JRlJz?=
 =?utf-8?B?eWlNWXNGYlhRWjRmM1F0V1ZOQTVMOEZNM3ZxVGEzMEVvdXV1R0xHZlpMY1hr?=
 =?utf-8?Q?vs5qumFXBhljwqtkdSHrtFiK3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TtjPmey2JWjFnbcXP+bTS5c11Z1j8nwEh5uD3suOBSuWGfyGnfJ5cOydlnPSdO/zOLVlREuOAL5WknnzuZ4VhXLuDlSq0eedOs3P+fjbgaPVmjSJktsOOjGFdW3yRGUbbyQ30CQF6JSOLWEYZUwyDoOepUkolt7ZZHTVyleOnxwOuErsBZIRWKHsCEt4UboCnWNNt9Q1hKC7G9GTqhkygC2nRxqaxKNhH2V8wvr1VrucTDlwdXxHruMEuTZ5YW92hc4eOf4hzDjxa9VNUYwVVhzdD5XtbXB1rV3o/qY0trgY9Nsb0YFTr1DSgvT1Xk3pxoUbCaD9tyLE2jb7EV130nVP0bX0DTNQyVfHzTTmh9kTBohCrJbgI5/9PcCMdsvw/S/dtHopLmAXoy4IxWOYaYmGhDyqbJHm3ditr1VDgm69WQb3CRkWy6hX7Psmq7GAaMAeAxa8BqnvUqkeKyUCrfCGhzywV5VygHo2GFyiB4+XdzsopAVkp70wqRBDtSz/GZnlTxENv0Q0uB74Rp5o4n1GFuaX4zv79WMOi5YzzHInqcqM0AfJCowcarfy3gicIq/Fodhu1w46xs28xgQBin2pEoLGcLZTYT4Bjv09jNO+xyqx5OIcbTsmiR/oD3kG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 555889ef-07d4-476d-3ecd-08dd468bdd3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 08:54:28.2674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BW7J4xk9Rc47WRgAb9hZJ8MeOmwFHVvkYlVfbm3T8exKKDoGgF9QZYxVcbrR57LM3lcQLSwg6uSiw2GBQJYw5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761

PiANCj4gPiBPbiAyLzQvMjUgNjozMSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gPiArc3Rh
dGljIHNzaXplX3QgY3JpdGljYWxfaGVhbHRoX3Nob3coc3RydWN0IGRldmljZSAqZGV2LA0KPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlICphdHRyLA0KPiA+ID4gK2NoYXINCj4gPiA+ICsqYnVmKSB7DQo+ID4gPiArICAgICBzdHJ1
Y3QgdWZzX2hiYSAqaGJhID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gPiArDQo+ID4gPiAr
ICAgICByZXR1cm4gc3lzZnNfZW1pdChidWYsICIlZFxuIiwgaGJhLT5kZXZfaW5mby5jcml0aWNh
bF9oZWFsdGgpOw0KPiA+ID4gKyB9DQo+ID4NCj4gPiBIaSBBdnJpLA0KPiA+DQo+ID4gTXkgdW5k
ZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBVRlMgNC4xIHN0YW5kYXJkIHN1cHBvcnRzIHJlcG9ydGlu
ZyBhDQo+ID4gY3JpdGljYWwgaGVhbHRoIGV2ZW50IHJlcGVhdGVkbHkgd2hpbGUgdGhpcyBwYXRj
aCBkb2VzIG5vdCBhbGxvdyB1c2Vycw0KPiA+IHRvIGZpZ3VyZSBvdXQgd2hldGhlciBhIGNyaXRp
Y2FsIGV2ZW50IGhhcyBiZWVuIHJlcG9ydGVkIG9uY2Ugb3INCj4gPiByZXBlYXRlZGx5LiBIYXMg
aXQgYmVlbiBjb25zaWRlcmVkIHRvIHJlcG9ydCB0aGUgbnVtYmVyIG9mIHRpbWVzIGENCj4gPiBj
cml0aWNhbCBoZWFsdGggZXZlbnQgaGFzIGJlZW4gcmVwb3J0ZWQgYnkgYSBVRlMgZGV2aWNlIGlu
c3RlYWQgb2Ygb25seSBvbmUNCj4gYml0IG9mIGluZm9ybWF0aW9uPw0KPiBEb25lLg0KQWZ0ZXIg
c29tZSBmdXJ0aGVyIGludGVybmFsIGRpc2N1c3Npb25zOg0KVGhlIHNldCBjb25kaXRpb25zIGFy
ZSB2ZW5kb3Igc3BlY2lmaWM7IFRoZSBkZXZpY2UgbWF5IHNldCBpdCBhcyBtYW55IHRpbWVzIGl0
IHdhbnRzIGRlcGVuZGluZyBvbiBpdHMgY3JpdGljYWxpdHkuDQpUaGUgc3BlYyBkb2VzIG5vdCBk
ZWZpbmUgdGhhdCBub3Igd2hhdCB0aGUgaG9zdCBzaG91bGQgZG8uDQpTbyB0aGVyZSBpcyB0aGlz
IGNvbmNlcm4gdGhhdCBzb21lIHZlbmRvcnMgd2lsbCByZXBvcnQgbXVsdGlwbGUgdGltZXMsIHdo
aWxlIG90aGVyIHdvbnQuDQpIZW5jZSwgcmVhZGluZyBjcml0aWNhbF9oZWFsdGggPSAxIG1pZ2h0
IGJlIG1pc2xlYWRpbmcuDQpXaGF0IGRvIHlvdSB0aGluaz8NCg0KVGhhbmtzLA0KQXZyaQ0KDQoN
Cj4gDQo+IFRoYW5rcywNCj4gQXZyaQ0KPiANCj4gPg0KPiA+IFRoYW5rcywNCj4gPg0KPiA+IEJh
cnQuDQo=
