Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844754;
	b=2RrWfy8pE4+NqK9HHueVwShWL68Qcv6H8RmiadafZophyOiGlE1Ym9O4ELgsi5thxyhV
	 F6Esf2WFWrpvHcsCYxrlbAHHcM7yB5vU3nI3D8cH8ZqWy64d30rneHC56Cc8L9Ml4ZtlL
	 gzJcFVLZO1CZaZMnR6gbjJVcjzNe2GDSQU+rYcQkYN7mTeJFm/II5jp4NAVLVka/J/3bJ
	 rem9v0mE/Qf2geE7MFpY5QPdZwuz1P9XuYYgWljKtpQB3WralWqLMbkYT+Yu43ijhPKXd
	 DVDRM8bdYI0BBjh7QiXhItX0VHKNnXxB2ubOfZURIahv/DADhcFPtNVA2YwhJA64rCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844754;
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
	bh=z+OoI2rN3KWppGz8+WmW53ZP+XzL4h5IzNMAq9FU0W8=;
	b=YkH9623Z+XVSKZCw1rJWzKQ+M/YfLjx+auQP/43/9oYezCnti7/hH2p1Wa+0rUVpPBoG
	 YaXYiv4xk1RwZAKZHD4TlAljBxEQZcC8bZe1hbgalc+Qjcr73EwWJdvCgSIqMlKdW4uXn
	 WpKheUWUPejw4Bc0tWnqJiYOpPxkWmER8I7LUCxhmt8g+5nBO3MC/Vh8+LgVVO8U65nNy
	 G5ihlFzoYMf8fLkJpAk+F2w72fkNJ74nWitmC9lWLlPZuNg5cez47HX5HpgTmAsC2NN5j
	 7CplRL4vHEmOd2iOviSqLq7xnH3d3TUwLcTHIEbEipOq2g1/rnmU2EVCtgOQSgElD5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=WqURwvlV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.66
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010066.outbound.protection.outlook.com [52.101.84.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A049606A32F;
	Sat, 24 Oct 2026 12:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A049606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=WqURwvlV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yP5+LO8v1Zfjwh3ihsWXd/7BDtpZGD2GL5IwWZHI5AaJDIzR0/6Bq31loSGMPMO1BZ8A3XaOK+YJt9zzuyc5lqIS3lK/tUZk0VwoY/WHSJ7zKbTlPcR6G1pTgI0qhCrAa+QeA5dqG1EZ+La5jkFRjqJo43cGOl3zXkGSLWml0toUolhcqRkH13Xko/fU7TjkX6DLtG6iM6sA43ZqCEWRgU1xVmHxIwx+9UX8+3SHnFi9CpAeIEAn3KkFFey0X05mInC4ww5pZXj41MdUkZBVxc6NJnLArgjC0EuJ3je/OyY00HFI2LCOTfjv0tg9bSnpd4kYdLXA7SHd6FULKB39+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+OoI2rN3KWppGz8+WmW53ZP+XzL4h5IzNMAq9FU0W8=;
 b=DunVTcZYQRIWq0QTD/9ofdf00hrs84WMkCzlm5uuf1YvWQDJNap6r1VugF8UklIZX/IHKv0+UGjXGEQY+xF6mFiSRj685f+caCHsNW23DOMQOMNlW3JZFLawfnl/ZKJVNdmpoWf2IkfRvrA7vOX1HsdxxXBv0mCGVPW2GF1jGpEEjEsYl20jMvzA/ZSCQg71BF53bgdbZeHODTPbSdKDa07v8Kr1Y+WqxELoncAblXyCYnk36oCoqUiGvNC4Oqupzw0Dlg/mhWkVDVpSY2WdD5vgq3ViEqg53MBA/JAQWK4EXo/qPQUo50qkhHq0a5Dt8GTR+bmXfDkwXG5hrL356Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+OoI2rN3KWppGz8+WmW53ZP+XzL4h5IzNMAq9FU0W8=;
 b=WqURwvlVjOvM8k1oupjyl+cJ4AgbOST6zrkrofABX+ija1BMO/wo9YMMokXkXkgSIkliYVuPuEI7+PGTaMTH/1EWKCJOxuVhwxlx77Pdj0T6e13xfxJUkPiwrnJwxwCdcL0+jhhbLIs6XUXq0SFIewSz773fpnqw0a34vAdnlu0n58wus1kCuvg1NaCP7yudcln8nlo20WeA+ivZ5rF7K2rTFnvDeKtmSJX7VUmedyUqOkxarCgWmQLwQzlNxjgFfqLzO3orPLFWH3oVKHzc9HvYaM0WKc54igRz6FmWvyDfJmQlKa/lI14dJvrznxWYSnDxq0aDXunnxadhfeie8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB8483.eurprd04.prod.outlook.com
 (2603:10a6:20b:34b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sat, 24 Oct
 2026 12:25:48 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:48 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 03/10] ufs: unipro: Add TX/RX FSM state attributes
Date: Sat, 24 Oct 2026 14:25:26 +0200
Message-ID: <20261024122533.3609180-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AS8PR04MB8483:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b89182e-3117-404e-0b03-08df31c9ef33
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|19092799006|23010399003|921020|11063799006|56012099006|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 Spb7prMhWj/8Hcfs6OH44jEy0SsjLLlgZZs+QBqN2TwSnPjQsbQFBPVoJKgZU7+fX/qNPWN+cYVyvoLISlLMlQqxI7oUndL64+nXaSeABT4kc1UFQ2Qs6omNIx7oGpXy4CeLjfFoI1MZ5JMEM7g4bKqjciSjSQVhTwY08urI3qdBFUit2LZ6nwrmezr8BOeFyqJEQYGEgKOQFUQ3gW7TLfglJRpegKOEgqqVXbWmCFdy3VvodqQTc6eCh2VZkOjLtzj1cJO9N2dKtb1QGdhvFMOF+jAOazBlr0a4fSsZx1GuVf8WAQT9TekugKiZP8ix8x278aQBpkYvpZZag4cpWzLdYkoNzVmiYDgvQ03MR8el6ZmsBLUtFbxUBLauAzFspapd4aWgKH6R+iGee1WDx7cDNPu0qATqPw1dDmUB3MlYqbCdNh1Rxj2k02BUEDBrCbh1CNfa1CVZYIYQyLuUagmkJG86GjFtOCYLR1aiYO6Xuwoqm18Qb3RpzgBYfsFK7oXC4dnnbK4aQ02HJkcRY5eAQeqRoMyQldBGqlRN0jBEtluqaN7clYMxw0dkldU8v8fuKSoDWNdYW02YnNDwXFHButoZ57HPpwdEGREm2cr0hhNU9JB40Odq6rwVqmk6TlEKvta10UGgxrU/nnvQijaWHSreEjKUWjAcDWLjYtoxTtDWodbqUqeEGqEvlMj9dwszl0M3LWE1XbqAYGLtXw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(19092799006)(23010399003)(921020)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YWNuUm9ZR0FZblkybnBpN1JhaW1FMzFmcnN5OUlqdnlkY1ZPMUlTNG5iUURn?=
 =?utf-8?B?dnBiQ291N21SaXJYVVNYL1dveHlMbStCYVdka2NQVUcranRPQkZUTHpUbEVJ?=
 =?utf-8?B?SC9vWjh0Z3dWcWNybkdUK3c4aG9GY1JESU85WlVad0RyZGtCZDZnYzB6QzJJ?=
 =?utf-8?B?bkxnK0I1cTRiWDlzdG9yVVVydWpUaUdBcHcvL1BnUnk0dmVOWHZFZ1JBcFBp?=
 =?utf-8?B?RXRLdUlrRDBjSE1FVzFkdk91SXd1SzZhV0xrSktLbEZ2QUo1ZG9wSE1sTXVm?=
 =?utf-8?B?dG94R3VZUnJpZXFXRUZWREpmZDJDM1lDa2hZd0cwUC9FQjZQY2VnV0Jhb3pw?=
 =?utf-8?B?ZkdGUFZvc01Ga2Z6YXFhT1RmdktqNGZrMXdlOFNnalNlR2NMY1FIQkRqZ1hL?=
 =?utf-8?B?WDZ0c21nN0lUSld6UmNCdkdLNG5EZWtjNFdCbURZY0NCZm9XekIyS0E3bmNk?=
 =?utf-8?B?T1lpdzVRQ1FqNnc4NXhtS0Eza08wY3htdjZvSlNrRThMZzRxaWNyZms1V3N1?=
 =?utf-8?B?WHE1SEJJSG5WZWlhWDliN0EvOXkrcUJKdnBqNld3cDRTYU11YnlleE43YVlw?=
 =?utf-8?B?TkhyLy9QSWwwTHZvRmxlL2IzT1BBeVIrMTMyU09WWHdsTGUxUnRoQnBWMStU?=
 =?utf-8?B?N2plQkdPRi9kdnZKbFpTdW1wRFZrbE85OEVXMkpGTytib21Bckg3ZW9zc3M4?=
 =?utf-8?B?K1BFTW1PalZOS1lFb2FJYUFLTm1US3JQV2hnbERvZEZsMmFhK2kxWEMwaDhJ?=
 =?utf-8?B?Tk5hN3hTaTJlcmcwVXM0TTA0VmRsdkdic240bk1lbjZraTd0VGtBTmhvNTFZ?=
 =?utf-8?B?TldKU1RJVjZFWld0bGJmenNaRU5oNGlFdWc0clZCMzF0VmdSSlp6SU1BaDhp?=
 =?utf-8?B?ZVlpVm11ZlR4V3FMKzZsT0VjU0QvdG5KZXRwYkIrUmRJMUtPcGtGK1dKV2JO?=
 =?utf-8?B?c0VMUnpWV25VOGUzcDQ4MDZWZ2tTZnFhTTFPcFdHcFR4VnBQV3M5dXFudUs3?=
 =?utf-8?B?OHZGaWVxcWxLaVQyL1FwSy9BS2lWS3VkcU9LU0VzZVMwczFKcnZGUjV0Zm91?=
 =?utf-8?B?akRqVDlmbE5xc2lSN2RIOUZkYkxuY1dnOVkzZzVGT2I3Yzlha2dDMVNoVHJE?=
 =?utf-8?B?OThjenJja1U4SHQyMXIrNVowQmpZSWRuMExmVWYxUHhmK1BMRUtFNGp1bVRQ?=
 =?utf-8?B?djFzMkYvZTVuZWdYV3dvY2hRbzhHdFdaSTJma1BZNFhTU1dLb0ZSUEp2NXBj?=
 =?utf-8?B?SU4rWTB4SHdjTnkreFFiSzNZTGp0ZGpIaUJvaGFBcU9CTWdweDQ0RTU3Skdi?=
 =?utf-8?B?VHc4YWZFNnlhUitUTGcwWVRxNmNhYXBmMUxTQ2FrN0ZTNjRwdktHQTNlVVYr?=
 =?utf-8?B?aW5ZaGVTbFNlM3BVcFZCZjVlV3dWbjlTekV4NFJnaWpXSTNaTk5RUHBXOUhi?=
 =?utf-8?B?VkhvUkNNTGFOcWFSQmhOOXJBa3NSTGcrYkdwSDlUREZWN0J0MkN1TGFIWTF0?=
 =?utf-8?B?eHFXczBBTTN6Q1BPQ0lpbVJBSko4ZnJ3Z3N1V1J1TERVbDhueTNadVBSRHhv?=
 =?utf-8?B?MVk2QmUxb3RqVjBYdFJiOS9rUTg1K2MvYzBLeEk3Z1lwWTF5Z1YyejB1UUV6?=
 =?utf-8?B?RUZ4eXhwTXBMZ3prQkJzUWhWQ3VZVWt6a0lNbDc4ZUYwQTk2ZnUwQnc2b3ox?=
 =?utf-8?B?L1hqNUJYYTBIeS9vUlJSSmhZcmdhWENaaXRURzNoNWxLYWVaQWY0YzVPajMw?=
 =?utf-8?B?blZadkQwczh2VWwzZVVmYkFjQjJUOVJjNmRoL3RIaFJnNFc5VXpNdEpXb0Vx?=
 =?utf-8?B?WUZpM0tPNm1haWF6ZHphWU04S0lwcTVXMkpNdDhHc0VBYnAySDJ0bHppUFBD?=
 =?utf-8?B?RGJDUXdqWEIzbkJ2Ykx1cERtUiswbW5USnFlRXBGT0VwUjQ2V2NVMEdhbFVw?=
 =?utf-8?B?dW5XSzA0a2JlVkdNcHUrY09sUGVRUElENS90NW1aVnZjL1hQM0RPT1RvVUZH?=
 =?utf-8?B?cklCMUhaODlFaE9mZDduMHdidWxZbzV5UUR6UytqczBWdzFuL0ZiNk9DMWFh?=
 =?utf-8?B?bEVQb2Y0NjR2OTZxT09Dc3JwaG5CLzZCNWtwMGI4TDhzRWFIbmZBTGZ4VTM3?=
 =?utf-8?B?NnpKMkVITVIrOFQvUXZORVdiWVEyc1BRditrSjJPNGZJVWVvZXJJanUzWHVz?=
 =?utf-8?B?aG0vc0kralZFS3lyUHlFQ2NyOGxjRUVHeG95bmJLL3M1d09yWjl3bWRqcmg2?=
 =?utf-8?B?TnhvdUYxQjZIaGFxUmd0R3IySzg3VnJPZEtON2hRMFVjdjNnYlpBaTJQTkpO?=
 =?utf-8?B?SndoRTg1cjVoUUE1TjhYbEVqek56dGpnTmlRam1Ud3B2TXF5ZkJtUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b89182e-3117-404e-0b03-08df31c9ef33
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:48.2080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTLa43pirw9C06LD5OoaflvweG0eFmmmFZvmfHn/RtRFftVd/vIshBk5xgY7PfSAG9g9QIxggv1qTkrk3e0+wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8483

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 7c0f102ffe7b..93755befb880 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index aaf66bfc3e70..fb44a776e9e7 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == UFS_TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == UFS_TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 69ec6327843e..d273e16313a1 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
@@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 3c6cb2281af0..1ec661277c1d 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 16b2051f7241..7adba11f4700 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

