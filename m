Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844761;
	b=Oz5OAK4p0f6rBGl7mM4ygwhxjD5WUXW1btRqjQRjokBAcImxRzQRbXGk80j+FtdAIznI
	 QXhd9JoZ6ywEbNAWG3LF6Gv4/9b6mWsTSfXph4iDHsBg8CiFBluW0THPSSbwXcZopMEue
	 8PQdyBUgwqLSsmKZyOrbsus4+vFssArF+3hcgmiPzX/+9/P49XSxR29dcFig50sxaKtEQ
	 KjjK5cLoIJoFw3TAv+pqvvfirmNQofB9KQlhHwpRko7qt9XXQxLXTaHzqlWEKd0jPPGjQ
	 PGmbN5O7hud05+ybGKwzqFm6J04z50ToGH03t7/5Zc+1wA9cYFiYcPg4lisIUh0UPOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844761;
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
	bh=Wwyp8q1UtGroYyKQduKwlsB/9SuTIglgdarTPArALWQ=;
	b=TAJGcQU7TnxBaEOb8z8eKXEpJTWngYGdqAM1meOePnVPOBq5+hF/BSVet/sUKXa6Mciu
	 CrW7b8l+0EGOVlAs6t/cHJ/NSoqq9peXKUTjC+XCkyWzWxNyKZL41XAamWGDeSL0fYg3k
	 sLC/TrqqJ9vryYg0CIgQ4KnVftS4alPo23et0qsgo9N6RnaYOU0k0oX7lcKYmLc+3s37V
	 S8Til7D2H3hd9Oem0DHbqAETRdjvUXrddwbXJhjARLC32Gat4cbVmq07NV7+Cxmibznnp
	 E/jShkL+jZrqjbzXl14an/qbfHHTqEvcwEBn62MyWX1luBYRiJ0mk+23ZVX645Lr3vw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=hV1ZRqh9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.68
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013068.outbound.protection.outlook.com [40.107.162.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0160A2613;
	Sat, 24 Oct 2026 12:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5D0160A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=hV1ZRqh9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cw0eGnTOoBssr3YvAEQWoOoapPIWp6YHOW/v3GF++AjkD30ptZS9Xo4Puyv3ycvw7NWLnt5hVpplZy09rzbE4E3oTIgAFo5T8jiUIm+0WM1dXJ1JXLhMLwxSMcMThA6U/nf14apdsW+2RnrP9J5y5rijxGJKk7cU2iTJetcCbiWTIRzNZneOrvrvVQSh8yhlc2AgfsuwIDfY+lqw2FrIvYuN/UHUUABlI270qEvpGB3K7Q/LT8PadtU9xVEFoU/iuIdDCj2N+ejSgatFuvMyxTsHd/gJCbETzEKTXbSWXsG06Pw8exKyczM8wJ5z7vpTAK16q41OOWPEC0pLbyuFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wwyp8q1UtGroYyKQduKwlsB/9SuTIglgdarTPArALWQ=;
 b=tWSg2Cg0N/EmMpFUgExwfx209HxXJdy3O8HvqYl6ohvdmA17aBvF5De3ZdqIEUijHoD+JqkeSNv/ab8+JQAZ9n7Pu6kYfIwqmrq2hS9Q31oomnVdkLLfjNVvPJOhF0DaVEYo2iRj23S26fL4wf3hb/PO7291UepySIZnuuJt6vFIaxMUsOQ+0i4NO9tVZXHTnJCnbOqgTXNR6RHo+VpTRoClS0hpD2EPGQm5Pjdrs9DQnZVxQ8cxhdu76apbkh5bNuFFKDHIxAWSI5mRIqCotm36z/TwfL41BS8rej41cE8c31x2OFVMq2oON0+4FY9rweAbmWYCwkjQ0MTqqS4jww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wwyp8q1UtGroYyKQduKwlsB/9SuTIglgdarTPArALWQ=;
 b=hV1ZRqh9+7c8utxVHXLGXeQIB8/ObDG+bl8d8uf5kNQoZY3E0bnI7T7axd8TvtEJaIJf1gKru0DpYQy4NZHCrR4ixf6BGxfvS70ACG4fokQ/MyNjujnJgUf0aCxrKMTuHLknidlIj4bFXBL5CtNIrRtLtveByIXYPP/0Pnt6VLP7/2rt6VXEuUzzIFwvb+bdIWdL/VXUX+5fYTkm9eY5Kyjoba2pu3WwueE/5SXquY/X25iVyNi3lopZeC5OO42t4T7QLQhKSqivBuxTJkuLxZXTJ38HnefftoSKzTXzYmdoK1G3k80iBliEnMZ+Va5Gs/3RqvV16FOegZBQBOzNHg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAWPR04MB9719.eurprd04.prod.outlook.com
 (2603:10a6:102:38b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 12:25:55 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:55 +0000
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
Subject: [PATCH 07/10] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Sat, 24 Oct 2026 14:25:30 +0200
Message-ID: <20261024122533.3609180-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAWPR04MB9719:EE_
X-MS-Office365-Filtering-Correlation-Id: c95b66bb-d44e-416f-7f97-08df31c9f350
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|19092799006|261009223027099003|261021121427099003|261022105027099003|261022075727099003|10067099003|56012099006|3023799007|18002099003|22082099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
 b17umFdYAQ+IOm8l909bNtV0dlr69Zh2fpbLDLfuLAVnGCQOZsRbQOGRsjhw3dMlQPIgiF6cZvhznLWpltK/t7cM+UZ0NgmJ66sdnuPeGT65Bpfi2Elw1ow68L82v2+nmuMuD+oqf1pC69oGycwSu2cyI17mYsBjkAJaouzGuDxCXHSOEAqryHZTxwk0ZDtWqAgNPcqpyqOkCjivH+VdZxniLbe4SkEpGzQ06OgiP/DW3/ZkNry4cA1v79UP0iBT8iXc1XCcrEEOqouRiBwzcWTt+KOoLr+Qe0YuDCXslptBQ5KslP8VzqpnA2P6cXQ9bCDxBTTrKckl2IQ87RBt78lf+8+qHvMtKspDSxd0+N4W02r+Xy6m7q7q8ItQ47EcaltS72a8qLU8mEVb9YyfT1iqNd8vT3nADoSao0q4tDxU+yNIT+yWttR9Eh44NQEedE6xOgb+UqjSIXHKs/GsSsxKlc3q8pfStm+MYmobn+SOd34jOS1gA+maGAjiuc3g565DvDPHcWC7Q1q91wlWUNd2aCaNCydAIr5eDYE9sA+DTAF4ZAqDzNfz1FnojO0YwHhufEsazNl4jPRtfEhoT3t711LsAgode6ukOxbqhSNrh+JCl5y/e/UFHzwVEyC39Y58H/4e880865XLNihjttzuenwQxyvyjoAn/kji+Xg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(19092799006)(261009223027099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(56012099006)(3023799007)(18002099003)(22082099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NWplQ094M2dSYk83d0ZJaWtUcDBHYjQ0cTVoM3FPMXBRZmNGMnhwMy9reDlD?=
 =?utf-8?B?SXJEWnlrMmxmRG95RDRWRWwzemc5ODNTTUtlOEpyWktaQ3NnTHEwT0JWWXpk?=
 =?utf-8?B?TlJ6eHNVdFozOFBKZGlkUkRDY1ltRUx0L0d1TUlJQjRDQitBNDAzU2UrUkVt?=
 =?utf-8?B?Z2RKQ3hMV1hSM0RnbDNWK2NNRmE1QndmSTBXQTl4OUlWRkpVTWtURVk1Rkpv?=
 =?utf-8?B?d3h3VEpLV1MvdjF1WmNXQm9tTlFWSzJCOXBBVjRzTzZGSjJnbGZEQkdNSnZx?=
 =?utf-8?B?QkFvOThUT1FWcEZJdW0zVmVXN1FqYVkwTHVEQmI0V2JLVkk5K0h6OUExV2h3?=
 =?utf-8?B?SVc3QmZRZTNuRFNFV3NkaWNjSFFoSi9VUS8wWW0vMEZMZnhlV1J3cFpCUlI0?=
 =?utf-8?B?S1d6OFBVNDFCUWViMiszbGpiYXNXbGd6QmhJMGlmaEFtQ1pHNmdqUnB4b3Nz?=
 =?utf-8?B?RmFVSTNKZGpjQk1sSzJWeFl0UzBoWGdWWE9uU2txVklvYjFlYUV5cFdmRFpF?=
 =?utf-8?B?VEdiRnVZVmx1SjFoWTNSbHZabWpvTHk0RmZkSm1hZnFpRHNSaW5GNFg1NVZE?=
 =?utf-8?B?eE0yYmdib216SndpQXYyZlJCZS8rNjg5M213WFJxYURuQUMxTkdJM0hETkhn?=
 =?utf-8?B?alhPSENuZDQ3ODBQdG1xdWRrNlYyaG5FUjZxRE1uN3ZOd2RxZGZ6OG81Vzdr?=
 =?utf-8?B?YXVUSVVuQjNHTnBPcG9OUlRHdnEvTnFqVXBCWC9tbm12KytwSVZUc1hYZU5q?=
 =?utf-8?B?VVY4WThBUi9yQmZOa3diV2c1NnVEYWY3dmhXcVNFdDRYTS9GTlZMbnFNV28x?=
 =?utf-8?B?cHpMVjc2MWZUdjF0TWRVVUpIZVNTVUF2MU5mV1BYL0hrbWp6dWNsYjQwcWVJ?=
 =?utf-8?B?T09aMnlFdk8weFRna2RKOXU3MmRQaUVRajBaRWNtZkxPU3hLdzdGcC9OSlYv?=
 =?utf-8?B?enpGWXBCeDdyVEZKSzZKZDJMa3JBTmNidEtXclpCajQ4RXgvWXNWSkkzdjNW?=
 =?utf-8?B?M0tTVy9oTTdQZUdMUG1pSGg5bU02eUFSOThJZFlmcWFWVnpTQTlPa0l5MlNO?=
 =?utf-8?B?NUEzMGVnN1lkLzV1Z21RTnh0Vlp4ODhBTzYrV0lhMnB0MmZ6bXQ4RWQ1djlS?=
 =?utf-8?B?WDVxZm80LzNaM3ZaOHNnWC81Q2pNRTMzZU5oNGZ3Y0tkTkw2ZnhMWDZWRktu?=
 =?utf-8?B?a1RiNTJaK1A3dlBDcE5nN2dWRVBWZTFaTmt4eHJTYTFrajVTTjVGT1ZnVTA0?=
 =?utf-8?B?WkhMR0lqcXh1S3JkVkxpcC9pWjMwdjdLbUY5c3cwdmszQlJSOE5vK1ZTNGth?=
 =?utf-8?B?WGRsN0xnQnl6UEU1emszVVFDZ1RHaGNHTlYyMmJiNHBna3BRd2JjZWV3MmM3?=
 =?utf-8?B?bm1reHlUa3htU0RqeFBpV0RLYW1QWnZVSmJpUE91U3l5L1FacEFodTk1Q2Fq?=
 =?utf-8?B?YXRJejVETlNTWXdXd0JBL1dIVU8wNUVMZG45aVlGNFRRTnRPRG5oRUE3ZkFu?=
 =?utf-8?B?MGtybWl6TmVUendxQ0xocUVmVzN2Y2liSXhHNEd2bUsvVXpyb1pqaUUzbVdv?=
 =?utf-8?B?U3RBUUkydytJMVN3dXUxRlBCYVBRTDV3cklrUnZSdFlsS0tET3ExMHdHaVh5?=
 =?utf-8?B?UkNrV2hTNElIUzVWdVppM0JZcHQwK09ySS90UXdIMzlnbS9iS1d6L1dJUlVN?=
 =?utf-8?B?dVhvVDFXeS81a1BqWE9Sa1ZRRmcvekZrcTlpejQwMG1EUWZZOTBlMEN0d0Zw?=
 =?utf-8?B?RmcvWVR5Z1JmaEVid1lHbUdWcm1MWlZ0V2xYVEJMTDZOZUZDNUMveUFmTytV?=
 =?utf-8?B?aHVwSFRBT29qMnMyWk1oTzRkandFQVM1bXNHUTEyZ05JZ2o1UUUyMDdZTDVr?=
 =?utf-8?B?R3dpYm9HOGFIU3dudnNLTHJJUW5OejVHc0tzMlBpamp0Vnh0ZnhrY1piMVdr?=
 =?utf-8?B?TEF1OGQxOTUxeUxDZWFVcENPNzNsSVNtV2FUYldCaWZtdFUzOTJmaUJ3RTN5?=
 =?utf-8?B?UDQxRjBrQ3Z0c1RFaWlDeE1RaWFFWVFWNnZBWGIxSHNYb0Q4ekZhc0owL1Rk?=
 =?utf-8?B?dkxRVW9ZYXVJSlJ4aWlwdUlLRExoVjRLMXdsUXpRV21SOUVRei9qWHl6Z0VO?=
 =?utf-8?B?U2dNOXpVVTEwUE14RUx1K1U5K25ZZlVNMlBVSVk5U1AxV3JOUmkrem05ZmY5?=
 =?utf-8?B?eGFvYkNkMkVUcE1pTTBndEtaZGR0NEkwZjZRYlowbk11SVhKbUUvV3RwTVVY?=
 =?utf-8?B?cDRJRU9xM2gycHREM1pIUnlvaGxXdEViWVczNVpaNzVpc1EwTlk2RlRrcXlo?=
 =?utf-8?B?YndkVUpBazROU0ZIeHFyQlorLysvdENBclBnd3dJcUVDdUQzanh2Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95b66bb-d44e-416f-7f97-08df31c9f350
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:55.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJKd48s7GEZZ1JgeKgZw+HiJMnHQh+lntIH5mDmIme0Eu5R1omse309H9oMLGIvJMAZcYO540jZYpiRz+MG7xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9719

Document the UFS host controller on the NXP S32N79 SoC.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..14291c5506f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP S32N79 Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Larisa Grigore <larisa.grigore@oss.nxp.com>
+
+properties:
+  compatible:
+    const: nxp,s32n79-ufshc
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: System Control Module registers
+
+  reg-names:
+    items:
+      - const: ufshc
+      - const: scm
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: core
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - operating-points-v2
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+        clock-names = "core";
+        operating-points-v2 = <&ufs_opp_table>;
+
+        ufs_opp_table: opp-table {
+            compatible = "operating-points-v2";
+
+            opp-0 {
+                opp-hz = /bits/ 64 <0>;
+            };
+        };
+    };
-- 
2.43.0

