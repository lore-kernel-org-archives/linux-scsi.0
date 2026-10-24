Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844755;
	b=vM2XZHUE69qyaMLR/z6aKeVI5mMVCyFjRPNjRY7Rl9f0eOyxG1Nc/simCvOijZLklSSQ
	 zZPbF3KEG9iUURGLOgcIF+no+rwvFyFb6y70i8RIX64tLlauRl3XTSW1Dogg1xQK0Q+vi
	 6g76NM8IWBRZVPPDyPM9pMyC7af4hIm59Yx8XWws6tMQFGxqb0ZXwuogL7yqgbfoiJiW3
	 P+exjIRf/dmME97UqDYzfXO7KYzQobqj2/SWQC6kP/BRNErfeUJ4Gl09cAwCOrNeZK7wa
	 uotgl5PAEagpf7x/U3/btkZhKlG5mPAV+inSgG2xIHST3UpHZspSBYi7CgMdHsrBroQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844755;
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
	bh=bKszCIBeoOpE0GX0h5+5wHlpbP8hNFZX+77PX+wbTEg=;
	b=I80rc2sI8oQuwO6dpy+m8xKnZ2H+DbiI2+r+FVzfvbXh3/7M0GkgpuTeNMHFWaLmEOBU
	 GgOmqM1wrjdvPc8pLDC1Tc953uShSYHzoaONFesaaYhwQc8NFAaSSYPEwdDtDFXU5393y
	 +u4WwaGsCeRwvAjwEPUnZgQy464foop4+KB/9oiDZapBynERhUy0N5IUqqMxPr4HfH+TS
	 y0O3OkgIQAxhQqwe4YQI3aboU6qEyZBzlnLUBv8cdQLj0ghRrdtQrJIIUh0P0kX5ehTf5
	 +kE0Qc0YWQqvlK9dU+m+6xx8pfdxK1sboiRLAbpxACbr11Cz9c3KbrIPyFA0gVt5IBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=IzZLxW2m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.10
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010010.outbound.protection.outlook.com [52.101.69.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E3F606A31B;
	Sat, 24 Oct 2026 12:25:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E3F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=IzZLxW2m
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MyCueLw6NBNNEksyTHUKf8JF4bJY6an9O+LAWld79HLsVwth0f+RUjy3k0ROcpoPuQ6qN/OLtP3cQBj6xItRM0ZCWDQRIPBcZO2m8JUpk4WnCdcBpu2sWaKV/4eOVoICD/YkAdAo+v3r91lx8idalxfyKtFmBOi6goCnoacjSq3yuRtAybkbAvk6bs1GCCDYcIDJ0OEtSnbD+ximEpdgnze0debUa7sLW/5Z0jXGj0ymGCAe3gRV1W8lXXLUGPX9M0Lw3dbxHyPD/W0rV813ALLq1Yce0PIDzCjy39PPTMH5wVQbbdJhFOjVv5KUZ9mb7irTkfKq4MSyT9seo+Ol8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKszCIBeoOpE0GX0h5+5wHlpbP8hNFZX+77PX+wbTEg=;
 b=lzfSG39aM1M3+i/ssslO0FsKPWiBCEhEZABN0epk6r48RZeNR8bLxHcvkcMPH/fhM+NvD1Dga9u9XSfrH43B7oW7l9+egSKMyd57JCBHHPJAJ5n2wNWlB6iVMRq/iYNyl35id6uwM/YIT/36ieGDzv+jKNe56VmjS7lJLDmHSdr3wMicWVFeaG6ZuGkr9gHe8cg9USNTt9gzc70Ad5TlWM4H892x54iXXsh1K+eb+F2eMOlj6AR3yZQth8k1f1r8bqaYcTomyFZ4O0eBdD2TOb8P+7+7rk3XYEZyypyqhi5lrixoZXwtI+0jJ4TK6UFx7JO4eRJOlkI3mVUTP6Dsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKszCIBeoOpE0GX0h5+5wHlpbP8hNFZX+77PX+wbTEg=;
 b=IzZLxW2mfJe6uv+m4bbVCgOSdI02P0n8zQvlf60zGUdNkOxH8oXSxULRDtQ0nZzlWRGoCHj4LUvPqg0ogOV/HWC0B+2C8SID2SLS/W9WgZN9LS8vBU0YXdpl1q9joWrsPdP4srM9xH5XmS5azYlIItbZk46nkWlGO7pitUVP8PrY4PPUZNiIUo5R5Suu2M6B1sVkgbq5I2/8HBHQt9Ps9vqWPFvgM6t0y+H3galfDKTzVnNjleaKVybzpQlZLiOV02/Fy6t/4tyeoDANDioxRv2MG3cBkW8+1z3CHoitrYHbiP7+SqS8UpfBl28gtI4LTqc94di8ndODGukF8Hw8jw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7789.eurprd04.prod.outlook.com
 (2603:10a6:102:c3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Sat, 24 Oct
 2026 12:25:50 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:49 +0000
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
	Frank Li <Frank.Li@nxp.com>,
	Stanley Jhu <stanleyjhu@google.com>
Subject: [PATCH 04/10] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Sat, 24 Oct 2026 14:25:27 +0200
Message-ID: <20261024122533.3609180-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::9) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7daabb01-c862-4338-4466-08df31c9f034
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|19092799006|1800799024|261009223027099003|261021123027099003|261022105027099003|261022075727099003|261021121427099003|10067099003|56012099006|18002099003|22082099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
 GWMim0leUA67t+uPdoaDyoN+2NDjktQm2B91QO9sCoAB4B2ED7rgV15z1VlBtJjk6VRgTvRkNjbE3cNi8Kh6ym0PWznH5wvJ1SArAVrBOdE2dKbcqW711XTDyQsw28X6dU6uRJJJks7FkEufhD3ODIcRmm3QNuiIS1WhDAfw8L3OxaTI92J3o94dH4ECPWs74sr8grCVXStkiC4e25hQPB4oBYB5MIUjkYlbXbKczB1quL6UT069XRfvQ2Ebhpyx74QJMGhzthwF6h1ewrieK4usjj77k3w1bwYaqijV22hd0rqmyEw5eMGySVT34shIeIUuNetolu/UgnGqX2Ciq+eYld1t6gQ+nfL60yYeGdqzx+L3KZJ3Nal7SKRcYz+BygBBBwF7jGka9XUlevG5+6DT7CaViqaggmsBbvn1j+kkNyPPzDF3eW+q/nL3MFlgjV6yeOHv7knEVeXmudBmYKF5ubA/a9BHpI8eMlgecIZFmvaQni9ZHVqPo0R2cd4onQMPIlgJFLxRuckMj1zQlInMoraWtsLVYnv3lcRH04bMgMBZa9hWEDpivh2kxf9iLHEorjwMP0aqr7CknCYu7v7w3tgiqRNvjQ7VkdxS1TH4qRlSJTyXANe9QTS+JnWrr+2h97IeS9Wmi+lUc6wO1W1JmGWv933vd8liBBB2p/GP6kzJ70Quh//RNZCutfGuqQ+D9VE8ifabuXNx7zHgpg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(19092799006)(1800799024)(261009223027099003)(261021123027099003)(261022105027099003)(261022075727099003)(261021121427099003)(10067099003)(56012099006)(18002099003)(22082099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dFRTdXZndCtKNk1Yb2dCSlV6M1pDMlc1N0pLeDlnMzFzTjJ0R01OekxIemxY?=
 =?utf-8?B?cUVmSTlRRHdaR0dEdU5NYlRwZ2pGVFdGOEhoSjR2YkJmYnNkKzd5SWkzTDkv?=
 =?utf-8?B?c0RRbzZSWThaTng1ZE5iUEIrU0UvMUtaTEszL0RNRHFPSDVsa2RWU3hMWEQ1?=
 =?utf-8?B?QWd1OGJnMmYzWGtGdnAzVjltWkFrZEdWV1dEb1EzOHFDQmVkNTZTQndEY1Fy?=
 =?utf-8?B?dFFrRnFIR0pWM3k2ZVA1VGk1MWlGelBmYkJ5MmdwbHIrVzVxdktIVTMyeEJI?=
 =?utf-8?B?YWNQTWRJWU1yeWRkWUxIOWdlM3pZWkZjdTRSZHhxNzJmNDdnNEUxc0lKbE1P?=
 =?utf-8?B?bmFybWtiSXQ0bnF6Qm1hUHBCTXdNbGpEWnhTM1FkRE5oZmdpK0N3eFA1d0Qw?=
 =?utf-8?B?QW9pUFdRV1o2Ti9BZmNiVWJrUnZsZkgxc2laMldDSFpLREZ6ODNGR1BRZGFZ?=
 =?utf-8?B?cWVnU0RJY05BY0E3VDFJRW1WdUlWa2x1KzFxWDNOaktYZWZYSlBidGlHZERw?=
 =?utf-8?B?WENsblQ5NU5nbHF5STMzMlk0S090cXVKdVc4QUQ2YWpMd0crNTNaRDRoYy9Z?=
 =?utf-8?B?NVdsTmRMZ3M0dG84eEtxMWJZWkI0Z0UwaEE4cDFNUFpnamZNMjZ0M1hUSEF6?=
 =?utf-8?B?WkNGbldHSUhaOU5EdWc1R09Gb2ZyMUVJQUJhUm9mNHI4NVNDWnNqTnFQQ29w?=
 =?utf-8?B?Y0xIMFNBd3I1RkVQQ1lUSGt5aHJWZkFiaEErSllEd2ZOTlQySkVZS3h1ZGJk?=
 =?utf-8?B?SWZTMXh5VitXOHRnc21KL2dLeFVDQlY1VFBCNHpBV0dSbnk2Z05JRk05dFVI?=
 =?utf-8?B?RytkcFZDSnUvKy91NERXV2h3S2cyQmk3K0ZXRGx6ZE40dVNYMkR1bG82WHNI?=
 =?utf-8?B?UXNTb2tWL2RhZkI4SmloSWZBNkJtTkVzWFdDeWMrY21FTjZmVnNNbG9taFFX?=
 =?utf-8?B?RmxLd3lTZllIUDFNOTF1OE44bnNKeUQ1Mkt6VVhFdk41b3oxeXJaQ3Z5SlRt?=
 =?utf-8?B?QnYvQzlYMzJqVkM2ZW9xK1dJVmFOMUpHSm1RbHhoM2h3cHJBNEhMUGd6dkpK?=
 =?utf-8?B?SDd4NzhrQ1kwdWEyY3oxNnlxNDhnT1VERUZtMHVab1djQ29JR01Uek04TWEz?=
 =?utf-8?B?blF3ck5hMCt3VHBmWTkrNisyU2FBYzBva3J3UVBGdjBwRDVWRmpPMG43R2NT?=
 =?utf-8?B?THBEb05yZk9wbyt2ZThESUZWaFVoS1NLNzcxcVk0T3NoS2xzZjg1eFUyVlNr?=
 =?utf-8?B?bzRDbWJpT0pMMU81SnFscGJRd3FoVGx6UlN2S0wvNllxRVFjQVhySjM1dzEy?=
 =?utf-8?B?Mkp6TmtENXFUNnlrdHJyT3MyeE5PR09KeXJZdjVBOU1ZcTVXS0ZJajNoMXBH?=
 =?utf-8?B?bEhnZVFvUXlCQk1uTEU1OCt1U3p3MTlyWGtrZWxwVkk5bkNiYy90citBNDZy?=
 =?utf-8?B?NnhqYXphMHREWmFKU2FVRFh4cm5iYXllelRoMlpYMmdCd3U0cnBRVVZ3UjlQ?=
 =?utf-8?B?YlV4OXNoZnZ3V3VqQjhRamlndmVvQWlVQ1pXaFNPYk9xRnZLNW1YUGpSaFI1?=
 =?utf-8?B?ZVhaZ2RYTkdwZUF0c3pIQ3dmQ1VFU2VzWXpNVEtwaVdta0hnRWlkK3Bnc1lZ?=
 =?utf-8?B?K0MrVkE0V0l3Y3BJNkZ6akNlUFdQZXZGK2ZXZ0hBK3VuOU9yKytzTUtmOGpH?=
 =?utf-8?B?Qm90MVBQQnNHenFJK1U2M1hxa3BjVGxXWFhuV2MwdzhaYmFPTHppd21SUHBq?=
 =?utf-8?B?aW9NNmNMSk9KSjFQdVBxTnVUMG9BWUptaXBjQlN4dnI4bUJGSW9UclNsTzZt?=
 =?utf-8?B?SVZTaG5nNktzTFRudjBZNEtsSURGZ0tsdmpKSXN3YS9tZnlzNUV3Rnpkb0RX?=
 =?utf-8?B?cHF4bitoYS94WVltdDRrNzJOKzJOaEprVVdJQnVPaXkwM21UWjBibjZrOXlY?=
 =?utf-8?B?aXNRT0wvVUZOdmRCNVdtUWNBTTYxdGJXaXlyYkxYN3hqTEFMdmIzajlMVis0?=
 =?utf-8?B?WGMxRUl0Y0MyMEtpdW8rZWtYVGI5OUVKWVN6eWI2ZlFyNExWaWVYdGo0UXJX?=
 =?utf-8?B?ZUFYY1NmbDlLRzQ2RlNGaDRFYXFtbjdUMkYySUl0eUZtS2ZxUmwxb0cxWUpt?=
 =?utf-8?B?SzVUR1JZKzFHc0Q1OVdsUFY1SitqdWs1ajdPWnNaU3ZmTXFXejVUL3ZYdGZI?=
 =?utf-8?B?cHNHaHlvaFlQNXc3WWdoU0tOUzQyRWtCUUQ5WjVXWnE1TFBEWFJQYlhoazlk?=
 =?utf-8?B?Zmg3VlU3NXI3OUw1ZVNoa3lmNWNKS2Y3dU5hVDcrTy90aGpsS2Q0a3NsM25M?=
 =?utf-8?B?NGQxTEs0WlR0Y3AvTzRxTVV1R1lnWEwwb3l1NHdqTUFVM2Z0OUF5Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7daabb01-c862-4338-4466-08df31c9f034
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:49.8781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGyf4p7BQWZSFjSUlv+KuGJODlMoleLn0Bjs/o5XEwCwUophtElf/G/eo4bIsB6/fViYdxNYetwIAUYgUzibbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7789

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd so it can be shared across host
controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
This is an intentional, harmless change of the returned error value; the
pass/fail behaviour at the call sites is unchanged.

Unlike the initial implementation, the timeout error is now reported only
once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
per lane.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca8329052cbc..c8b7248a769a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
+ * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
+ * timeout) if the attribute read fails.
+ */
+static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
+					unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != UFS_TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: overall timeout in milliseconds shared by all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	int err, ret;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	/*
+	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
+	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
+	 * was hit.
+	 */
+	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
+				err != -EAGAIN, 200,
+				(u64)timeout_ms * USEC_PER_MSEC, false,
+				hba, num_lanes);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+		return ret;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index fb44a776e9e7..b84075dfe00d 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == UFS_TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == UFS_TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != UFS_TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != UFS_TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index d273e16313a1..815ca82a0878 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != UFS_TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..0d9d0a26eb20 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
+				       unsigned int num_lanes,
+				       unsigned int timeout_ms);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
 				    struct ufs_pa_layer_attr *pwr_mode,
 				    enum ufshcd_pmc_policy pmc_policy);
-- 
2.43.0

