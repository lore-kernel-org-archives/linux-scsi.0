Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794257255;
	b=beNwu/NZuWn64SGPgNOMhETmkMFMGl5ErwpnE8+GVb32c1X/4v3770uaYQB4x+JWyQcv
	 aTGb3Vg+L55RQOUvODHzQWL3s5AxrW3zZvIRq2qB3FhiAXBUc3qhVufD2Si7jA6g0SQ1P
	 GV9TcVUt1iHAHfNhuRSLxwFhA8DHjtNFD98NhlCP+/ZHJMnBLthmHxLMx4QUBS2SIfSTo
	 SoY8qYV37xPaEkJg/FhelUbN3lhZAHg3BkPTWZ8FX1ltrPaDryvbYuD8RxbroMzs+tFOX
	 frFRL2x1vOdUn95rS6SA9LNKvMvAYMEUlFN/D5Ch1i0+Q/shpsAShU50/WCemEP0OHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257255;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=3fktfSnbONW1pBYDfqxavVMcQZ0ONRl0Taf94gPS0KA=;
	b=wGC/NfG+7DKIIPjGOSBxzkbGdS0klxdSaxIZSmeJDAE3SRR0TV2kkdOcIWauc4iQrVs1
	 550sihdMFi4EsElnlCrAxww+QQ13R5yUFFsVvVBvShZIy85xU2AZsHaU5x/C3tTb0mOA8
	 xX+8/tYm+CBJ+zT8vdjxdE5ZoK3B8ZV826Jf6dy2f09kfYcNEX1Y8WAur0pWEcMUjsv2n
	 pOXqUg+FUMkGniR6NQndA+ix4zfY8QC1VkFZoOeuSXCRuUM2PMcuTJTiHgFc+jUUxzJ5i
	 8D/gaACnhqPYQjwiUzVfVUDRpVswMCy0NSv+hS0z7KMcH5Rij5PK3vicCYFxa+wDCVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=pxEyvftf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.54
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013054.outbound.protection.outlook.com [40.107.159.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BF606A31C;
	Mon,  9 Nov 2026 20:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E5BF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=pxEyvftf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YUbnz7YvmUusT3Fzv7p+F2ahwgglotk+tDoHdPTfgYBxmpNjqZtUJJ+xkRy2sNjuKTG9l5wFBNRsicAHuY+yBi5uqK9pOJBANidM3bWZp6C3s2kbFBjqQFOXOYzbNwGfLIm8fLJOc/BL/wDRk3y5BTLwsaVTi/mz37TlJCDMd+FFxjWhWVXpuGgH5vawdE5YxA10crrJDA8gT+QBn02d1ehijRSilRHJqVxN0MHbaj+niVbDkE6rXAXUOYs/kuehNB1ggYWqR4HsYVTMbpTzPf2Yk5DgUiGTqlk7q4VsezRzkTVzALvRu2skQ+/fI5/a7b6V7L4jYaDFCxBFZcm1Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fktfSnbONW1pBYDfqxavVMcQZ0ONRl0Taf94gPS0KA=;
 b=pCi6OzT4Donzf2qLOqsZ/aBVCZI7nUz3PcMZ4EqxTMhwKh2rCAMv2N6E8MyRIP//rn8hgSR2Ubik060BkUXgXH35u+fc5ZOL0wt1WQlAm9P5WTwT83OzgOedFDHZ3d3Inm/Nnu4hqi5QfGJCK/cJxNfyTtRRa4puXFR2GcY1qQmjTjHzPm0IrcUGeF+WavgVGT5NnH8oQN/Vxtt6lZBSGAm7oAF0sZfBt8KSrzTDE9mAQ8KOdBYAlacQBxj2jb2ShMSjO7tV6zsEcf63juJ38Z4sPqT6E7cf8627opT0iU8h12JCRcqL0/dVvDVHO+axmFCnvk4dedZepf2/PKAVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fktfSnbONW1pBYDfqxavVMcQZ0ONRl0Taf94gPS0KA=;
 b=pxEyvftfyn6GMR1eDiegCTHi6/GdNRfpNiVN7RRSCXBhafv/sgpqVfQfVV5zoFSKXsB+pNJUzPEgfjgAV0iFTphmjzS3VBO4hdfjT9AdCD0+Dimlm29o6P0JOtKCy0NO4k+X4EfUDrsOLBBOked3IQWo99JQzMBQQzHn/kmkyLE91mCkN2nytvdwPY+y1wHMAg8xkZV5y5K5ra6V+7nxlfY2XGU/TkXbC9m8GlYFvGwE2/YzPctdcAPH8b17qE2kCmF4VEGLmjRk8+Pxru+HvUhnpsWHmwYgLtlhvWDbt3hqkXN/ZbGmLc29xRzW7dR1M4J7FpM0GRPJwks1pshY8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MA6PR04MB189634.eurprd04.prod.outlook.com
 (2603:10a6:250:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 20:47:28 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 20:47:27 +0000
Message-ID: <02fb96e2-391f-4fc3-8d41-ab8364a9b07b@oss.nxp.com>
Date: Mon, 9 Nov 2026 22:47:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/11] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>, imx@lists.linux.dev,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
 echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>
 <20261104-holistic-loon-of-agreement-db7b8f@quoll>
 <4e82a4bf-e2db-4a3b-bebd-9f9c473817a3@kernel.org>
 <17b24b80-c3bb-40a1-ad12-06242ca09c22@oss.nxp.com>
 <0820de78-679a-45c2-baf1-2905490ea926@kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <0820de78-679a-45c2-baf1-2905490ea926@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::13) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MA6PR04MB189634:EE_
X-MS-Office365-Filtering-Correlation-Id: 419f214e-faa9-46db-ac42-08df3ea2aa1d
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|19092799006|10067099003|4143699003|11063799006|56012099006|261022105027099003|261026140227099003|261028144727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 HRlPz35wut3SPlMKUZs1nvIvQRt+egEPT97wgbubdW9sbk9WDkTe2baoWlaeaVIf3Fd4hTCJ3CIducDZ/h4iAfTL4s+IUTMoyQLsYB5SHNvP/lHAXrkyANN9+2JBiIOC41QWck4aht6n6ThybGc7KMETnsk7aKbgtrtmKWe+t/qBnpY49stB/1t6qi4+wJWVBOTduofI9I/fXhaaTg2qXhVY6+wWXiuBxEvY5wmMoNSRu8suojJBhPxc0+OAyQHBh7DeJy8r/nmkW+bE1NnImL0kAodWuCUdq3XhEf30TBpldCwpAfYSt0u4hEC9taBRA0mA0D7AcvvIa1QXKLjQC2NPYeopdfdZCa+mo4RDUt1vTJw9x2o6hOD5wxIEd3G/1yWmegykZrvfb+eqthZPVGtt1VTZ5MbMsL1F1uzWaVvQLFK9b4xK6oUDyeKWy3iQh4pY6KaoQhQjIvXnfuhdYbLPkk5Flidk49tIWkOn1Gr5ixCd4tAWtk3z5aLF98ejwIm9aW82O+Jz/WPHxD2TDEuPFqQaZtTGjqcHhaeplvXy7fSBB6Sw2ulu+8DqqGttC0ZAYMMAJYIcz+oTwM55fp0ErtZ5nYWe4pe9MBSy80jub1uSqxcVWc1k9mfd2tsX
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(19092799006)(10067099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c3hpSGxuOVRQa3BYSnlWc2lNWDZkQnVlZmF2NVJSd2o2TTArYmlURkJtT0d1?=
 =?utf-8?B?bmwzNkZyRlNWSFlGSzNCTE03eTNEV01QMVlEVmpjNjU2VGZieGF2QTIwTXhS?=
 =?utf-8?B?cjJDckt5eUswaXNDZzZMblpvVVpXbVlGVDlYcURGZWhtZjVDa2FaZTV5czVq?=
 =?utf-8?B?NXduYXVMcW1iZnZZSDE3R1h1YytKWEU0SjRtNUVhby9yMWVqelFpUFBrUmMy?=
 =?utf-8?B?aE44Rk9CNm9ldS9PNXVlNnJ0bFRxclNFbFVBQ2pCUzdUcEp3TmFHaGs0SGVn?=
 =?utf-8?B?NUovakZCeDhMdXJ5REdvcnduMW54dzhpSDhNamlWRy9OSlFtOHlRL29reDUy?=
 =?utf-8?B?Z0ZCQnhuVFZiN1Z1WDhlY2ZBRHR2bWdkN2RRTjJ3TStZd3hXWU40T0VrUFkv?=
 =?utf-8?B?NUMxUzV2Y290cHJ2bXdDQndrdWx4U0NjUXVYc2hvVXNXZDFXZisvMGhXL2JK?=
 =?utf-8?B?ZldnTmNVOHJrb1cyMUI0WXV6Z1JHZFNIUzZVckZsVWwwWEYvUnpyYkd1SExC?=
 =?utf-8?B?clpjR2hjOGZBT1Y1ektIekZ5YStkT3RBaEVBb0FsaDFWNU81MWpmSEQxU29I?=
 =?utf-8?B?b2RvYUthQi93TUhvQXI3ZmhZY0llYlhqVDFHck95NXJKc2tyM0RJeDhVaUhB?=
 =?utf-8?B?ekFnemhYeGxOWXhkUTNSYURHUXdKdytvaStOTC9vZTBFREU4V0VibkNoMTlJ?=
 =?utf-8?B?akpad2tGK0V4U0x6ZUpQY0JGZk81bmh3WFc2ZzlSRzAvQjE0RVMrMDdxYlgr?=
 =?utf-8?B?cDloVUN0dFl2bzJ2WkhZQm5mMzdtOVo0OGlFSkVTb3BGTzVGMzgvMTVYS3Z0?=
 =?utf-8?B?ejhRMHUweDhKcVhuTUVzbXo1VU95NnNpU1Z6TWhLM1JzOThhd05OcjF5NEYx?=
 =?utf-8?B?WTZ6RjhHYnF4V1Zacm1SUTlKTU9tWGk0Q2hjc1dCWERhTUtDVWZFLytCcnp5?=
 =?utf-8?B?QzNPaEFKVDBhTGFBQ0pKcUp5SXBHc2hzRk5vT3NKRFYxTmFNbzhzV2hHdkN4?=
 =?utf-8?B?RHlML2VaU1kwRnNFUndvaGRGbEUxTURzdDE1dlZhcFRnRzgrQytQNXZmVzh2?=
 =?utf-8?B?YjArMTVHZEFJVkt4cnVaR1BiN1NIeit3VEFQTStWYkNySkQrbnNFQjhaN1h6?=
 =?utf-8?B?dFM0dCtQRisyaUlMb25oTENGeG9RdlZLNGFXSHB5eWFJQzZnSWRsUEpIREN6?=
 =?utf-8?B?RVRqenp4dnlNTnVIN2Y5QWtQZTFtRDZHZ3QvaDlFUk5PRHk2akV5Q3F5cDRF?=
 =?utf-8?B?R3E3OWI4V0FQdk1NeEFidFpKdkR3enpvQW9VNE1ramNaN0RneThyR2VKTXpX?=
 =?utf-8?B?NnZnemc5SkNlNzdTNVN5OFRBV1JDNXdydUF4cXFBWEZzekp3M1VNL2Q4WG9V?=
 =?utf-8?B?NGtOQ3lzZC9qa0tmTm5reEVFSHdKc3ZScnNmWGxqR0gxS0FTbWswUCswZm5L?=
 =?utf-8?B?eHRYZ0o5cmJicjlsS0s1TEttVDh5SlNhdkI5WHZIZVllR2czdVdxendhei9G?=
 =?utf-8?B?elQrUHNqeVNLa2ZTd3ArNTN0Q0ZiSk5pZmZMcWZ4TXZBeHl6RThFdFJ0UzZI?=
 =?utf-8?B?OUxIZlNoMmEwQmg1UzhiQ0ljNy9HZWVIOUJmMUdYVW9jUXBTOU1aaXJSZ28w?=
 =?utf-8?B?RmE1MHpjWTV5YlIvYUVBSTY3Z1V4bzhPZGd5N3VlcmxJTVgrbTZqZk5vcncy?=
 =?utf-8?B?cUNSKzVKSmczMERWV0xDMlAvdnhiZ3FURkVOWTdxVzJLajI5NDhtYWx0aFUv?=
 =?utf-8?B?YjFhWDJTUXhhLzI1MDhGVHFQZktxeHkvcS9NTXhvK2xNYVRJL2ZWTW9ZNWY3?=
 =?utf-8?B?VHdXbVhid01lYTVJV0s1SUU1aVhzNkRlR2U3Y3dWRzVVNFA4Q05mTWNpanZT?=
 =?utf-8?B?TU9sRFNxbHFKM2U1Sk5SdFNhajBCcGt6RFFVUXVzaGVwUFRhYWJDQ2hqelQw?=
 =?utf-8?B?S0VJV3hyUktGeW8xWEtjMTE0dEpQMXJQSWl6UE5IYlhPUVU1bnZNdDZPWGcw?=
 =?utf-8?B?M3hBVml5L2dFUE4vaFJBNkFjVjVIZzhiRVpOekZxdC9yeXRHTzZ1RTNXeVE4?=
 =?utf-8?B?NGNBcTNveXF4d3pENkZzcWpmU2xtaUFDaWVPbHY1K3RSUnZkK0dGdHBCZjAz?=
 =?utf-8?B?aTBHZytKQUQra3JocndUZmUxSytqelJYTlJ2eFp1U1I1QVRMenV3QUliOE9n?=
 =?utf-8?B?Zm9rYWFkVWtpZUpGcjBIanFha3hLY1VZOU1hQ2JWQ2gwYnhBdUlhUE50VE1N?=
 =?utf-8?B?TW1QaXg5OXcrTzF3Y0JRTmpVNEtiLzUwM2gxSGlLNjRWRXdhcXR1QWh6amRT?=
 =?utf-8?B?SURLVG1xVitkUERXczdaMDZBbHdFU2pxYlQ5YkxtRUhpT3RpZFpIUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419f214e-faa9-46db-ac42-08df3ea2aa1d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 20:47:27.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHMQYUueGrzT3+HVaZ4duIAqmb+wxZlbTh2JTr6Uny3golWgDBIEemxCzDdxpN5EBYlO1/z2hYDWc23CSkXKJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA6PR04MB189634

On 11/5/2026 8:28 PM, Krzysztof Kozlowski wrote:
> On 04/11/2026 10:41, Larisa Ileana Grigore wrote:
>> On 11/4/2026 10:40 AM, Krzysztof Kozlowski wrote:
>> v8:
>> https://lore.kernel.org/all/20261013103003.373156-1-larisa.grigore@oss.nxp.com/
>> v9:
>> https://lore.kernel.org/all/20261024122533.3609180-1-larisa.grigore@oss.nxp.com/
>> v10:
>> https://lore.kernel.org/all/20261103133215.1385823-1-larisa.grigore@oss.nxp.com
>>
>> Regarding your comments on v9:
>>
>> Frank's Reviewed-by was given publicly on v8 [1]. The series only looked
>> like a v1 because of the wrong version number.
>> The tag ordering was changed in v10 since the patch was changed.
>> The single 0 Hz OPP entry: as discussed on v8 [2][3], the clock rate is
>> set outside Linux and is not scaled. The OPP table lets the UFS core
> 
> That is not the purpose of OPP table. OPP defines performance point.
> Performance point of 0 makes no sense. You cannot use Linux limitations
> as reason to add some DTS, because answer is simple: fix your Linux
> limitations.
>

Hi Krzysztof,

Thanks for the clarification. I understand that an OPP table is not 
appropriate here.

Existing platform DTs, such as Hi3660 and MT8195, define freq-table-hz 
containing only <0 0> pairs. This allows the UFS core to manage clock 
enable/disable without setting their rates. With freq-table-hz 
deprecated, there seems to be a gap for this use case, beyond S32N.

Could you please advise on the preferred way to address this?

Regards,
Larisa

>> enable and gate the clock. As you suggested, v10 explains this in the
>> commit message. Let me know if you would like more details there.
> 
> 
> 
> Best regards,
> Krzysztof

