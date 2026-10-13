Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FAA4E1C98;
	Tue, 13 Oct 2026 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887458; cv=fail; b=C//T5uMEjxRp9DzICDIxXbTw9X1KP1RFSetP5Qo4UJFGg5DZP7dk/dhTJf+Bf3PkN8K2kcyY0AM8ZCJRovccc5MyldOGd23SMklclW54uuRYYi2ikP00GmUWlENcAHwlRKqCGkPm+lDKcNVPue9FFKyqzb0c4EacfFlp6/WoEoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887458; c=relaxed/simple;
	bh=5S8yezaaVq3x4V9XvhhZUAqqJ4FppRDVPfG2kafm7Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uJznHiOS5Z4XOGtFnltkqxAs4TKy7HvgTSsolI0Oz1diPOG2PEtgDavWDsxsCYsxLCARvq+59WchLO89bYQRQTDRTGwoCOTTubQLKwjfNLDcyJdmBH2ybBBfsRWQyXNyjo5n7QAZU9uKNNVe2n4C30tuyI6YZTTfQ/2qlZw7+FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=dbZYR9dy; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="dbZYR9dy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3Lr9+Rk4WHWc+nnBjd6vqNHQY35zEK59+lhNSe9zcGlgw7bpzI32jqiOOuP6ZFv5Mp+kEkCx9t5v8lbDPXEnPAVYs//pA+F09NSEaFHtSbXkcqc1LNV48W9d9zJqxePeN1dWBif/raQpW74+pv3H2K/SYStabG1zhCRVhpvK34UlDHBame5GPVhWrvNEgyYj2oBsvUd9bDqYfCEjVXtg99+ar2Re2RelQKgbRXbQrEQtOM5kTQumxzb0IdAE8e2bnXIgj5oPF6x+IlGHTDuY/DB0HZQCxKMQS7SJHy4h/Kl4TzCZkJvCU4/N1d0/Jftcj2sl/xKeK0AXabl1g2JVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqIXuEW/v4IJHMIv735G/E8X4GFZTbvpFQ42FMOrKfU=;
 b=YF7whESXO/RAWz0En63itDN5aFY2ObehrEJ0U393giXtKAlSKZwuODKs0K7PEdRF/bXD3O/KlkB+kBAwjpT7UwwiIe8iKKicmAgv50tMgaKpVyS0TRGKS7J3+6JjaKlEt4QobftAKNU2LTwTH+UG/bDc3dk53Kv1RSTzX8ZYtpIwlYE8Q5B+J/uINVa/59ptlbpVMvJUs12haA0GlQyUHVx2qt1aFJZE/KBo0ye355RMqph/Aluy1+RkRGTiW9MXu5Suolp29ffnWKFBPYts8LKusQJxVO+CN3OSwSMZNDxEAADJs1wVV6qp0qpflV12WN5Ai0B0ZqXg8r1anysYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqIXuEW/v4IJHMIv735G/E8X4GFZTbvpFQ42FMOrKfU=;
 b=dbZYR9dyxeHZoxoOGtAmNDCffTAlTdm1sLuDGsr0eFh3kzJTP120fdXsBtm6ATqYiwGsPQrCP8gKMsXrzgQprGc4CfZC6mR4H0HyEpXaJ6D+d4hCk4dD55Tz/hd7u7nl0JQtTX95PqpjrjxFys1KhjerBX2bNpsZaHy8sUsJLan/NVTZJOEmToI6dRELomZfBhpf4LDN/QmaiN/QWXSh4ZX5MtW6h9RP4LmERiVZTA01H30cbA3C9gQQS7FeSZHow+Jl981QJjuDVr9ombpMhxNPoI9JqJX1dx0TTqPXujJA+a6HZvZiWvCbDMS0KY4yfKn7f7dEcHRqO/TOAtYJPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:52 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:51 +0000
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
Subject: [PATCH v8 12/12] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Tue, 13 Oct 2026 12:30:03 +0200
Message-ID: <20261013103003.373156-13-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P250CA0009.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 72f84de3-109c-4be7-a451-08df29150e22
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 09hlBqmB9TC0okJXNz14O1nlmzTf15M8AM+8MNucEFC5XhgBpTLgzhdbmwP1S6Ie0Dm0s/DDSpRMDbJC+xiMRAAmXFpBTkdVfbCdaNCWAb3JFIYPXdBEDyiM2454KsIThWmCmvCNsK9N+RZxZzWodlUgxYtOc/Bh0l2Gyuk0BWhGXz9hEHAf5VpIWTwxr5jTcabkqBZhwKwXE3HYDs7BCw7Hyhsl9GpAfjPyVvOvIsgRJLb07AEtx2CmIF0OmR6f/rygV/1cqEDUrkmWiurkpU49LQ26vkoCFhRF3ZwsWc2Eu0hDpNTYoqEgZLx9sWrei5keFqK+OXO/5Le7LOTFzylsQUlDn8Vb7fNJj1VKqCJ8jsNwVqqw+AlyVs/lRx1mOyNF3BqhF7oVesLMQK7yWc71JpdZPZ5HxPBV7hf3oFTqhgOFkvxYDcHyabZkHsNOENfSPtY6nEkpHLACBAIYcZlaoF3zv+A++HpddEgchdQywu0gMsSiTVskq1yFdYEQghzCwUGCTXu3boMPSizRD21Vgbsx7K085L4k02/N9UQ3ri8uevIrxJZ3QdLG6vunx7gEc6smtKXRzgoMZBEZB8sFCfWvTPLLUqzysCu1Ln0eCnrMYEIhDO+Y+8ckYkFr82onDq8oBEhKya1+4h1zv8Eg5bD5H6pYbagAa4d6Whz1Ikd1uR0e5gm8aaNR4ohqyZB455rNHCkLfFKwYSGSTA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TkZBNmYwbkNQS3RaWTN5dkpsRUcvSzBYcEtnMXh3NHJGKzVkN0hreUJvYnN6?=
 =?utf-8?B?eVo0NUVmaUF5Ni9ON2xyUkxDZWNSZXRyQWw1bFBTbFlqKzA1L0kwMUJwTXh4?=
 =?utf-8?B?TlIxWHh5TEF1UWdVbFRmRXBwcnRPN1dLMnM5Y1Z5Ykk1RlNjMEZ4b0hmaC9w?=
 =?utf-8?B?NTQwKy9BZEFxZlZOVGk2akJ4aDdpWURuMFZiTDNWTW9zT09kdE5oWlpMc2hV?=
 =?utf-8?B?Zk82MmVtd2FhaVk2Y2VzMHBmcG1yRjU1cEgvaXZZQUZvY2tQZjREa21RaXg3?=
 =?utf-8?B?RGh5cmZlNExDSEFpbmQwNk5yN1ZwMG9JZXo2d2loT1NoUnNZWjJSUzIvKy81?=
 =?utf-8?B?dEd5bkM4b1N3QmhFQmtnVkx6ck1yc2JBYUdhUTRFM1kyK3VhZlVSdUt5NjRG?=
 =?utf-8?B?STF4djdYMS8wMVFaZ2N3S2x3K212U3BOZVZYOTY3cFZVeGlXWkw5QW9TM3ha?=
 =?utf-8?B?TlhCR1BGdVdGQXRibU9peTBQV05wNmNFaFlnUW0rT1gwQlVjQXo1OHNjbTRs?=
 =?utf-8?B?UG5LWDgwam1xRkMxRkFXRXo1UWdmRldNcmhsdEl2cTI3UE8zYkZub3R1cWZB?=
 =?utf-8?B?amY1eEVwWWV6UHR1aVF2QVlxRkFSWTlTa05pWTRNenA4ZmJOMmVWTGdmdmR2?=
 =?utf-8?B?YkxVTlhMbFRJWC9nUFJRMXB4SW1oQlRNZS9yM1M2YkEzN3YreCtLMks1dUlG?=
 =?utf-8?B?QXEvbzV2a1NYQTgvSThadXF2eEsxY3FUcW94SDgwT014eW5hZXBvc09hQ2tO?=
 =?utf-8?B?WTlCMEVIeEpReUNaUTZaNU1ZWU91WWcwNmRzcndiWXk1R01qOEtZLzN5cjdj?=
 =?utf-8?B?d0Nsam94czU2aFBaZWNGdWd6aHVXcUJPcTkwUkNtWEFSa2VVNkJ2dVVRU0Ez?=
 =?utf-8?B?eVdTdUxrN3NwSFZ6eGJEdGZGVWROQnN5VkxaQlhvVDkzUW9VT0FoaCtzTy9P?=
 =?utf-8?B?dEltM3RGdnF1QTFQcVlOTVpFL2liSWRMRkhsN2hpU2VVdFg2WkFGT3l6RlEv?=
 =?utf-8?B?RlZ1Nlg4QkZSdGZISWFRaVVVWGJYT2tNbzRyYWJISUwwTjJjTWtSSC9abWs1?=
 =?utf-8?B?Z2hLQnpSQldYSzAwZHJYRlQwTWJ5c0d4Q2JEU2dZa3JOU0xKcWZNREl6bFZP?=
 =?utf-8?B?ajNkUTljOFhyY3BSYzVxVUtybkNOdE16L1ZpZExUY3NieXh4aDVWY0VCV1kw?=
 =?utf-8?B?M0RoVmNOT0NrY3VGa3lxMUhyNmNtQlA4ZVlWUEJCTmNTdnQ3UHR6UnYyaVJ3?=
 =?utf-8?B?TUxkek1Nc0MrbDNET2g1WjF3aDF2MDlxRlNUc2FRUEZDeHNCMytOMjBMTTFn?=
 =?utf-8?B?SlR5K2tOaHBqVkV6ZHdtbWR1bUgxTGJFWjNYTnNhNjM3VjcvOUY1L3hqQU9Q?=
 =?utf-8?B?UENRWDZ6VDhsYXZkZXVDeW5LUitSL0ZIWStpSy9Rc0x0b0ZTeXB2TlBJTkhK?=
 =?utf-8?B?Z2FSWk1hRnlvdEYyTlN2NEtxNm4xZHUweU16TEFXWnFFVG45VmNzelgzWDNu?=
 =?utf-8?B?UGx1ajZaNGw0RTZBOGY1ZHA4c3ZWOVVFVWprcTBPSHAxbzExUzlOQzNwNmZT?=
 =?utf-8?B?WjRIelhSOFJCcVhDK3hsRUROOXZ6R1dTaUEvby9BNnJaRUpvaG1YbVhjSzk5?=
 =?utf-8?B?UzJDeGYyUU9OVG9sU1FMUVVtN1VUNFc2a2kwN01lTm5hUGlReXdUTzF5TTNE?=
 =?utf-8?B?SFhnY1ZCbmNsVFFGQnRBczd4MUVCekFsWjRBMG5vd0JVcDUzZDRuRG5YS1V0?=
 =?utf-8?B?aFloUkxxR29hdWI3d1dSNWhHSzNWUkM2dXhUV3I4Y25kUjF3WGNGczRkS3gv?=
 =?utf-8?B?a3k0K1hEcHpOUW9CcEJLWFhUb1d3ejVTMkxmQ3E2d01NK2JpSDJDa2YyOVdN?=
 =?utf-8?B?UjZwRysxMlhMUERVSDFWM2UzY1I4MUFycmk1T256My90SUFmMWZGc1ltckVq?=
 =?utf-8?B?b3dtcVJWYVNuQ0FRSUplRXF6akd5aXlMMlQzWTJvUDRWaS9lUXVHaU5wYWkr?=
 =?utf-8?B?SzA4dmxtRlZzT0F6V3BudXJrVUpLQXRac1RJaHB2M0RBRTZSWFpqb3ppWC9W?=
 =?utf-8?B?azNPaHU2ZlJsaUxjdkZaZFBwYUl1U2FrSVphUmpFUURPaDBiNlExeHBONVNz?=
 =?utf-8?B?NTFUZFJJT2NFS1FORitYMElCcnRCeHFoRmdWMDY2RStEN3hUa0pRa3d4dTFK?=
 =?utf-8?B?NjA4bHY1WWt3dHMvNmpjRFJnUTNUdEZ1LytDNi9tQmVOSzJ4VWdVbEhtcGxl?=
 =?utf-8?B?K1REUWc4YlZpRVRQT1RaN3ZUQjM3L2pjZllUT2xPNE5kM1djRHpKR3E0c0RS?=
 =?utf-8?B?eDZGSW9CRGNwYVpWS0tNRkxCNWJDSXZCeWhCWFhMelB3WmxzaTFUZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f84de3-109c-4be7-a451-08df29150e22
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:51.8884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0mWqfwAZnecig/mN9t7JzM0OfhrDGSZXVUmC/qJXVnQyk6V21mH852YWGOuoWMimYgb2q5k0BMupMWMzDPRmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047aa8d3c..16f1dbb763cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28119,6 +28119,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

