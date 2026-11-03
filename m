Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712768;
	b=5cDKSEJ0WTe5NeTTcqjo1drP+hQvXwWXpzrz/mRQ7upEGdNqaIaIYvq4DgmN7i4qTKUn
	 SiXw/onh2IwmLPtBhehHPFm5xKMkIruG12y7+I+GU9K4wWlVy5yBx1p037oaX7/r9CIpk
	 k3WFBpNIU8Pa6794D6+8jcO1Mj2sJHJmnVenTAfcznAhnwG6mXkbGDiDSWGuQCwJjDwMb
	 MNiFBBgFgxobF/le+XRBmV5Q706mtLadGHcZZ1hK7L+r42+dhkwm6vAI90J3/eDBxthEx
	 BYQum/CRwoHJd1hh0/zX+0iTmaNgGqLZ4NFf6JwZ+yYy4a0I2UZgrlOlpkFx3pXqA0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712768;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ZKmPQrAt20uAwFRoGWtERbYzLb44rHsbWhpC4IYAdkA=;
	b=x9ayBJrAfMjgAe9v8pGBVu1KbVpbmkQb7hXXGYnAJGOjHO4P4iDjyIeSsZ/4dtWyY3t2
	 M896EeElF3KYPuzklH7pYuS83Ll4AKmlumiGf6NOcWI7LJHRd5spTQkpjrRNKbiAkocFy
	 0eloruRrkPcYWNSSY9Ne/5yGwhUgK/wIZZMp2N19+SUMkfswnGP0BP2Xzk6+XbBYmyUdK
	 biuBaGv8p3kD+504PklIUgsd1HzHagp6J9V3eYhqaZQM19N9cF+OPqG/baRBgsNOM/FoP
	 96f+VoYoD9L1nPhZHi+uCvRWdA0/YZ8IQpJ5soCAscwlmwt7WnS+g8olie2dsPswW2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LrHjr0fK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.1
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010001.outbound.protection.outlook.com [52.101.84.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5942B606A33A;
	Tue,  3 Nov 2026 13:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5942B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LrHjr0fK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZm/JyPCcadpeiYPWPtnC0Roc7Xg9naTfNeK7i//jiuBwPT+sdah7b/VbU0w9pAWcmEpQojGhbnaPV8BpwPGkOsfKUERAuralP4HScUDyXx0QLcYsADOewlassacmtJAaKg3B6d4e4IIeMypwbbRKzdivGFHlW1B1rH++oBenEVgkgF8LRHcsgHw/TGNP2qbu2QpJxxNwx1hctxvi1jcdZe97cAFfJHVk6sy+JTL2zhRwpXbkDdDDl6VYDBA4X5p0dTQ2JaaX3DMOzJ9uMuiiwjQfwCFSvjOtPloBtOsUC2PHfLOFBql3CK2PQ8+c7kvhmHdPVXN0uKM5EEjOCaYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKmPQrAt20uAwFRoGWtERbYzLb44rHsbWhpC4IYAdkA=;
 b=JIPmHY+YxcZWDlt62AVpxnunub1FeWC6II7DUYr3x/ojJ0THVzw6BSlLkukxskZ8MqmS82T/OpyKnbRznHjr1Uq1MRYvnWJF3h7ZqDtB4NhY7BN652Gdd/cHjOX7mKlLFIECkh+GhpAgMl1lj0VZKjYpS6uBjGc1SEj6X7b4hIVHSrmJH88St9xgG8wbuosq8zp2h1dcKhdAIMAEACNTbiYf8j0eRe5fLo5bjkC94DUh1Oycez7n3GC+J4DnoKzP7l4a6Qq/1cdVJEWAglBJcgECIm8NPB4/K9MWJsz4yCuQcemv+Zi6m2qNJ5UHNjKTT/D/gUVD/cm7GN9SWlvGmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKmPQrAt20uAwFRoGWtERbYzLb44rHsbWhpC4IYAdkA=;
 b=LrHjr0fK9KMpk9O91PICFNXUqpoHfV8Kbp7paxpGufN85OJO9KQRKp2xJi93mVy5NEjSqwh2kl2P2IeKakgJfRqy0DWNwOnIIhXcoGK9a3QkmXENoRKBEgr43gE+obtoidkwedDDg7DuxKZeLkNibHi1+2K4z2No2BTBGWpJ12k9ky9Lxo8F8e2NHNYjh5EwTpjiF2X5nCct7qbVYs8JioiJramCSnIBuRFhE+FaixNq+SCC/7pQ0KrBSAf1F45lNVjs8dqKHL8D3tiL16bd0fg4Jn9pGv90VDZBQTRnFREXj3R5i9TuXJzhs7L64cnRLpFoDSd5eBlFb3bd8YI8BA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB10073.eurprd04.prod.outlook.com
 (2603:10a6:800:1dd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:42 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:37 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v10 01/11] ufs: core: Return a negative errno from WLUN suspend/resume
Date: Tue,  3 Nov 2026 14:32:05 +0100
Message-ID: <20261103133215.1385823-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0015.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI1PR04MB10073:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d275c21-be34-48ca-f6ad-08df39aeecf8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|19092799006|23010399003|18002099003|22082099003|261102123227099003|56012099006|10067099003|261009223027099003|921020|261022105027099003|261021123027099003|261021121427099003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
 54W1iAirfdjrLiF63rMIiMSWtEmc6pxm6UVb1Hcq7pFJ81saBNlvCnWYhvHrCWBUqfIh8Fp+SlMCIPSNBibWMJoWujiwZihF9D38idxSY7cAnnYyXIea/Gt5POwV1+TX0/RogA9mRjUl789iyJLUgcW+SITrs/EGAbUO345f2Jbyk2wbgu+x4lNDajooruScwomb1OG49DHmdOwEZ/bvejpLZtHV9rWQgVdv/zXKaZM4MmtWBRFc/npw89s6P7e6AMHw5FPeHozM6+tjxBfUTvooSTqlxLz6h8LHseeWWJUlH83+Q0emTSajOpBrvx3+oqbFROHy9ST/AcPCZkE+Vs4uNf+40lUFQODWHuqyuqiULPE7EbrsEG6n2kbo1x9BvKyhlHnoyqdPQifCtTfIcb0IT67gfHYY/cB94rewiq7l5Him4kbsXvO5/QKsolL1GuriwuxldyYbrh5uufQ3jzBpWDgbvRqwyqExQa1KiKNRGbRerQebimotZwfqVNdYjQ2dAc24ivUHYXtSm9rfLE2ozWRD9t+SaaX6yfJNLlLzH/qXE3p+fBCT0fpcUKu7D1DhRf5O4/+cKpGsAcQhTBUc+f1sxU1W/ekf54LHMk1AoO7P1Hit90h+lAJucn3geBaLDf2fOZWvefcvl/uTUZICs1j2sX6sfg/uN79xnC8zEXX1L9Qwj5j2Sk8WhobB6ubiR6k+AnrEQuYgRl5wgA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(261102123227099003)(56012099006)(10067099003)(261009223027099003)(921020)(261022105027099003)(261021123027099003)(261021121427099003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dGo4SlhOSk84bHpmVkpyS0VnRmw3WGY1cVZOYzZaSmJOdGtJY0hkeWs2WjZF?=
 =?utf-8?B?bXJuRDUrdFBIeXlOMmVHWEs0RWI4TkZ1Z3hrbGtnQzFQdWJqTHBxdTZ2bmU4?=
 =?utf-8?B?dElMQWVOdG11Z1pma2swNEtEYmFxU3J5MXNjOUtVUEJqUjkvZ2Z6SDNLMU9J?=
 =?utf-8?B?UHBRUHh1Mi80QWNreVFOSDdzMU5xVEU5RjM5UkgrelgrWGdiNkZKaVhLVVRt?=
 =?utf-8?B?c1R6K1F5VjBpKzVPZy9mTTQ5OGh1UlZOZjZjYnRsamhWRm9EUkpRazhlS1B3?=
 =?utf-8?B?cXgvWGxXUnBPak5POUVYd3B3L3NTeXVLMVVZWHFnUzlDOWl4bDBnN1YyTUlq?=
 =?utf-8?B?N1BJNVJ3ZVFXMGxFKzJjQ1pubitrMmhJd25lQ1BXTGdQRzAzNDBZOWN0SGht?=
 =?utf-8?B?bzRWaUxibUkrbEp0V2owalB4UHJ0QnJNN3QrdlFzNVNkQ0ozUjh2T0pmdU8r?=
 =?utf-8?B?SzRJeG9tRDRXUkdqS0d3V0hFVWJROTZoNVpwVUkySHYzdlFVaEVadEFtRW52?=
 =?utf-8?B?dk04L3pzR3lMbDF1VXArQ0gvbmdFUzFhUjlEbVU0bkI5U0t6UDhFbWFIa3Mv?=
 =?utf-8?B?aW52VEZ3NWFwWkNTcVlyNFRiYXJ5VmlNMXU0MHBkUzZqZzg2SERZYitNdUhT?=
 =?utf-8?B?dUVMNDBIM1pmcFJnT2t2aXh0OExRZzVDU1hia2RYa0lYeTlmS2Y4c3FFbWpW?=
 =?utf-8?B?OTRYOXpTR25wQkQyRnlSR0MvY24vVUU5dFVaK3pBS3UwSXgwQXVkL294bFl4?=
 =?utf-8?B?U0l6MUlVNmpyODNrdDBxcXdoN0ZOb0ttcWxyZ01sdDVYZERLdnhXczNKL25n?=
 =?utf-8?B?K2hWVzQ0cUdhc1c2R0JKbnR3cDRqQVZLV3IzWjFSbFovbTh6RENXY3A5b0dN?=
 =?utf-8?B?ektjeFBNcXFwbllucDMwcUlmQXZOdkk5RkxMamJCSktZdlhHWW90NXRGQmxo?=
 =?utf-8?B?a3dQdGtPcTVLKzdVNTJnS2paY1hPUlByQ3NxOVA0alIvL29HOG9jd0YzSldp?=
 =?utf-8?B?dmhOdExNVHN4b2dtaHNwT3U3YWo5Z0VXejJKOTM4RjdQa0xLZUo4RkYrRFVT?=
 =?utf-8?B?eWVaYzQvVUFDRDVUQks3REtrL3ZpOXNuZjdrQ2pxN041dmpnWDJGTnZZdEJX?=
 =?utf-8?B?N0YxamtDZGxMZnZXbTVqbTg3WkpCbTROWFkydDNkV2FNTjVyandoWG0rblVT?=
 =?utf-8?B?bnlvaUtmRGxETWtmQk43RTY2ODJKc2psRTZxZmdjcVJndmV0eXVBcVVuVlhI?=
 =?utf-8?B?MnVGdDVjd3owaGRIaVZCcjNlVzArc1Q4a2N3L2NDRVRmK2VtMWpOUXh5ZWZI?=
 =?utf-8?B?b3F2dGs1Vy92MGtWQmFFbGhlRTBuTjhOUmZrZFErZUx5ZzlOSFk0WXI2MzJZ?=
 =?utf-8?B?SlhiNHExU01GUkhSMFlGc1pmKzljM1dZeVBlTWRtNTBwS21SYzFuSFZsUDI5?=
 =?utf-8?B?eUF2b21Ma0hWZ2VkaW84RW1YRHNTNFRUUWJXR2lqcGdjQzRqbGlibmJuT2Qv?=
 =?utf-8?B?SjRhd3B0WHN3RnZDOTk0OVZ2ZE1sMlQ2clVVQTBpU085OWRXLzFDWGVsK0ht?=
 =?utf-8?B?QjlYUW8wbFVhalBIak1YWnhqeFlWWm9IMlBHL2l1WUIrTmc4Ym44eWF3bTRn?=
 =?utf-8?B?aFVzNnJvUWhYc2haRTEvOXZxV0RzYng0c0FDaXlPeGx2ZXF5WDlyNGtIRFo1?=
 =?utf-8?B?MktiTWFSTEQyVVRMZEhLWnJBWEQwWUMzNVhzdDArSHBYWnh1akpYYjFWbExB?=
 =?utf-8?B?VFVpSW13RUF3T3l5WDVuUWZ4SEczajFYOVRhQ2M4NUVyL0pjaFBMRUpMTVZq?=
 =?utf-8?B?K09jTmVnTC9IZjdNeTZIellBZVZHRDVueE9WSkpsMWI2azVNc0hpaXRqa3lx?=
 =?utf-8?B?NE5EeVdWS1EwSWR4UVdjb1dzWUVyR0JwNlRva2JBcUo5TU51VDY5WU01bmNu?=
 =?utf-8?B?ZjRxcjNQcDlGM29seW1tWUJXWE5hbVVmbEhXREIrVTFadHJKOFVlR0hEbnNs?=
 =?utf-8?B?NERNSGRIV1l1Y1crYmhObWdJUE5ZcXVpUEhQL0d4MjY4TDJLa0tibnFjSjVj?=
 =?utf-8?B?TE9ObHU2Ly9jTlcvTG9qTzNOeTlnb2VEVXFlWGcxVWo1ZzFMV2VvR3psWTFD?=
 =?utf-8?B?NmFiams2bHkyMkcvWFFreGxaVi91cFdHK2NQQ1p6Z20zcWtXVnFkNVhmRzlm?=
 =?utf-8?B?d2Judnp4NE01L2I3SHpBcy9OejJ2YmU1OGVMS0lRbVhjZ2dBdDBnRmY0eXdT?=
 =?utf-8?B?Y0xCMzR1RENqUitoQmh4RmxCci9lOHRvOGcxRmxTS1dYcVFvczJJeHdnUm1x?=
 =?utf-8?B?R2F6SDhsUGt0MS95cGxObDFRNEdjRXkvd09qbmQ3aXdYN2dXd1Y5QT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d275c21-be34-48ca-f6ad-08df39aeecf8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:37.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVqEk8a2npdCdXhELo5M0s/H8UGP+sjX5YKUPlU2EVmQK1w8758XbYqgVv5rLxR/5gN/Xrat5Y6WjCqGonKI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10073

__ufshcd_wl_suspend() and __ufshcd_wl_resume() may return a positive result
code, e.g. from ufshcd_link_startup() when DME link startup fails while
restoring the link.

The runtime PM core treats any non-zero value as a failure of the WLUN,
but rpm_get_suppliers() only checks for a negative value. The LUs
consuming the WLUN are thus reported as resumed and receive I/O while
the WLUN is still suspended.

Convert positive values to -EIO, as ufshcd_init() already does.
Do the same in __ufshcd_wl_suspend() for consistency, so that callers
always get a negative errno.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..d4addb7bdf7b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10545,7 +10545,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_release(hba);
 	}
 	hba->pm_op_in_progress = false;
-	return ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 #ifdef CONFIG_PM
@@ -10646,7 +10646,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->pm_op_in_progress = false;
-	return ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static int ufshcd_wl_runtime_suspend(struct device *dev)
-- 
2.43.0

