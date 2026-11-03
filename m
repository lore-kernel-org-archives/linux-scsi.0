Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712782;
	b=SisgOcmwUjkSWWzBM4un7RTDPgCZTdugiv3XLkioUMpBrRgRc61fTH0UAbJxuJOkKVg9
	 +SBCx8HsGOmMtLcUX/VEsL7fGAaigNPxr+vsoZQVJSw09fJDl8qNbAKfWbuVjiJYHC1ms
	 3qYxEJ5CtSbCPpAcADc1DZ9tiC5CKgebQ8jf1lw+Gxgpf3qfHSbAzzbJ1N/OB1ONUyc/A
	 gfY89DtGnofaAQOEH1NTdYovwrl8C06SWSChZIUxwcPFPbHBIBfNay26CXvlzyvJ4/82H
	 8+hziBfY5rY0pUezO/Q+U1wIIC5KvmB3jbuWovVKtfX97hhaNK9PGSIcyoEOu7Hc/qA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712782;
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
	bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
	b=ITFRBg1Ao7uDZ2gZjgfqBzPOMXC0jW+Sc53vWqm53gcw6fUBqeDJIA8x2Y0XMQ/o/oIu
	 CuMXAZLlZMPu+spRFtLkq+9di+gkbNNOFaZdMvjs24muWJGZnuWcg9btIDLBr2R5dCKHb
	 SJCYqGAv9tY52d72zu2O3t7CsSGjVNV4/aMN+7DBmdyGVLQ/cL+5L1/ZDnwiyYfy7T/A9
	 w4EJ83n/B4pQT+alVVQ+5+HJR3nbft2ghrolwXe32gFt4Jm0Kahfz4MZrMCTBH9sHt0KN
	 xMBqiF1pxhwH7A+vwgBreydAl02KaahAXPIVShVAaKJ8qM5+yCzgYL5pL4TlpB68qng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=bBFdAVvs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.20
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011020.outbound.protection.outlook.com [40.107.130.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1C6082BC0;
	Tue,  3 Nov 2026 13:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEF1C6082BC0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=bBFdAVvs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER4SvW06rcJ19TDMiR1H27R7du3ROqi4d18aCtvVFxu7nw2e2+FnDp8ga10WkEzFIIgbuLlmoIEM3X8QqgSRUMSTER2z0iZryd2jzDeVzTcb+P6MU46LS+Wc9yHQ15AK+fadkcnywCBIt1fNCbL0jq8zl9nNRLwoi/VBcyD7dLZi8S3/ha5nOcu01bAaZvI4DZRHMWdQjRXqSNvuUznu98owrasET3XthSAeSsK7JtWKhUytVtjcMWDLnZe+gP8qp9Hssv0DcEaRr/rvfiMEapkh2J7G+yRe47l1M3c5zRhK0TE6C4ylb4ZFmVECb1m34jIOMiZNcV8RxsPZm7MM6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=rC+9Fl9TnY0Bz+U4F1PqnzRU2HP0gqq3MyAkln5/GKeN/Xy3mXpsHGRrUCqfgc4nTXFZsy2BJn2EeXgT/AM/a1in73u/l+irEcLWLbktsjWABTmb4N1M3Cw7WjRzJXqSF/36zov6IZAeU7gmLzJDmI42uXrl/B5FNqdJixCkPxeJCFNLbpTxQrZycR6rC/Iog4yzbaou/2cf17xgz1RKltGY/EsJDv6QKxYYQoMYk/MBH3TUR56XvYtYf5lWt1XoRFi1gkR3pMC4WNrOY3UZA2Rn+Wj8V4cozxGE3D3qJ4XC7K/Hek+CNi3JATeBsJkz70KZISZlvVxk0WDZLdPckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=bBFdAVvsp8J31qT1SGR7LuQFV4UdNXjLQ5qj46JIQq997EXcevlTLtSdm2ZM1OcVjMVLBXxaJGbbhUZVHfxJtj8YYCjlDh2CNT4gu2PA8WkWKGh0lEy9CGvTooEZhPKNpKGsYT41C9rxKY1nDRzdapdDXL7e7k4r/qNhWVdlDcXzDzq5Ff4tkdN5wOUzAkqOdgfawW5499Jrkr4VbiioL8xyyL8zjQnGGZh0x5P/y4476Z5gIQfE9JuQrjVmm6CBpnqA3vwR2Cc8RFBTK6pXtFKCaktN3Q38N5neav175AmGNx4NXKC3aMeQsrT6S1Bp/EOXfrrfrERA7LzGuAgbgg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI0PR04MB975636.eurprd04.prod.outlook.com
 (2603:10a6:800:360::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:58 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:57 +0000
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
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v10 09/11] ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
Date: Tue,  3 Nov 2026 14:32:13 +0100
Message-ID: <20261103133215.1385823-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0524.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI0PR04MB975636:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b638d7b-bd54-4060-eac3-08df39aef8ee
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|366016|376014|7416014|1800799024|261021121427099003|261021123027099003|261009223027099003|261102123227099003|921020|261026121527099003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Q8sVAfNET+VgnUHhku0EYm8AQ+2ye1JmiNQkd3KlIWKPuEXxRI/MTARVnT7Vqp9zOUDOnXAlW9d5CWKJKeAhjjfBFAZ8OVNyiAqGxn54Wo1XJjidwy4VzgCy+jM+W4w1UWD/OcVtpiRJVHx4x+cMV84DwZk7vijkrUpcm0/RYNlPx7Ucbc/lo1O4wXKbqSoE8G5k/rPh8CiVuI90H9Fabs1uO+ir0iuQavuMKav0UBXeUW8xHPX5Jxb+pJJROGir57kxXOWTH6wbrv+p8QzVMlOemJGTPP/sB+pSqmaAIeSsPyEjFqW7ReSARxUYaoTLNwRZDEA4fSYbA2vV9divnCVxpkxNX0iSFqBsKhlZ2rAD6rdsmLniUMu97q6pW2nsHArMgbwyefUzxq77DxIi18aSb2n+EGh1D0qKBvzcaEa9ir2XJbocW6gaen1VTv6kfOFv4++zAR7XO9+NKo3durnixvNshVTDKdRT61xGQuQ5gyjL7b+kqHmEKqUtlX3qv7lZqDDAAsPUfTrDkshyus8Bi97y7EYX4srGiwAeFzSpkhdZ9u5wbnJvfHU4VpzMLYsgtRKCA7guNgj5qPZRrHXSDUOSrN88cMJkQTvBsM9wh65enNXJCPZJyOy30mDajklV4W3jjYHFMcubRmkz+KtrBsJ9DveTf0jXgcww7arh9/CUk3GugCODqOkuyoBbvdU2VyTtXgQSbZ02P7Byfg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(366016)(376014)(7416014)(1800799024)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(921020)(261026121527099003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UUFmT29IWFBYai91akFIdWhFUVk4TWtyVWVycTNPNVNDbC91ZUZNa3orSVN2?=
 =?utf-8?B?T1ErUmtNMno4YzBhYStuNUk0aG1yR09DZWUwSUFMVVlIb0VOcVAvbDdjQXIw?=
 =?utf-8?B?VDhQN0hZV0NwQkpLMzJaSmVHOWZLVC9OcEE4Vlc0UGRRbXhrdGwxTkhwZ1kr?=
 =?utf-8?B?VzdPbU9kVjBNcTVUSmo5b2NETFVJN0xQQ1RCekNnZWs1TE1nVlcyMFBHVS9I?=
 =?utf-8?B?Q01jbEpJemhXMWVsOEcxVVd0MDRuMGRjRUlOb2RHQjZJbTdibmdNSFppVzRU?=
 =?utf-8?B?c1Y5NUE3TkFueUVmZmFKSDduT2xnQktSNEpLUkNxU3BRQVJZdkQrR1RjS0hn?=
 =?utf-8?B?UnUrZkNVZFlob25SRnBabWMrSE0xVzFjak1mcU9kYTc3YTdDbExoMG8yZ3g2?=
 =?utf-8?B?bHl6akl0L2JQRlRWc1lDSVVsTWF5WE5VdGg5MjhtbU0xQ3lzZnJLTEFzQy95?=
 =?utf-8?B?YjBaQ1dUK1NkZDBpbEhWS014cUJHMzYwTGRPZTdqZjBaUE1Hdk1TZk9EMXdY?=
 =?utf-8?B?UXlsTDArZTVPLzJKU1NUTmRTL0VwMHl2cnFqakZLNVJaTHhSd1RLNWVQT0h2?=
 =?utf-8?B?ZTJqeDNWNENvTVUzODIvMHRmQUQrYlBlWU1FZ0NMUHJQZVFIYkhRMER5VVY1?=
 =?utf-8?B?WWNjSDl5OGFGbUFCWFdzK2dmdUplTDV5NW1MTk9TK2g3Sk1vVGJpNmszdk8x?=
 =?utf-8?B?K3JvUmszd0Y3VTJJTndPRTIxRTM5U25XbGJULys4bkNlbWlrSmtqVVRuSlV5?=
 =?utf-8?B?YlY1Y1V5eUF6Y1MwbkhCeng1bitqLzJRSmhwOHFrb2pCYXBSdnpKWUIrbWtK?=
 =?utf-8?B?eFVXQWxFTHJ1YVYzcUFWZHV2MUM0dUE5U0R2UzMzNHJaU2doUE5UUnRoN21V?=
 =?utf-8?B?enRWV1RhcjNMTEVTV1lFUlk5ek5FQXFOUEVKZDc2bHNUQ2N4NWtBSzNCcVpX?=
 =?utf-8?B?bHZBbVlKUjBxS3A2WW9nNkRibFJUb3dnbnJPL0FEV3VoNy9MdS9oUU1zV0lj?=
 =?utf-8?B?Nll0eWpZSzdOeGNTK3dJSmhnbWZ1TEU5OWc3SlQ5VS8wbVNMUHliNk9nckJ1?=
 =?utf-8?B?ZlExUGEwb1RWUEpTZmx3ejAzT2o4Ylo2eG9oSHdLWG1WZ1pqdnNFZG9qWmRk?=
 =?utf-8?B?NjUvc1lZcDBzZkhVNzBuTVFjcXBQdTdRcHFQb1V6RVk4WUI2dVVUL29walVG?=
 =?utf-8?B?STBYNm1vSElrVXJhODZzc1ZJeXJmanZPRHRIbEc1TTd6SWwyeEU4aW5MaDdS?=
 =?utf-8?B?U1BydU5NNVBVdldMR2V2NzhwRkN0dWY5TndXeEVTTDRLZ3FSdTc5Qmc0ZXM0?=
 =?utf-8?B?ZEU0R2lMM0xYNzNKOUVDR0xGUWdmeWtkVStJNW9VbHBzWlFWeHhJUHdzcnVD?=
 =?utf-8?B?eWZqOEhQVkZSeVZEcGI3SWlLUnYxK3NsUW5KR3NTTDF4UTFSZTZ6ckoweCs4?=
 =?utf-8?B?MFFPeTMxWkZLMXV3Q2dqeUtraHBaaVYrRDVyd1ZKdExFVGE1VGNEMlhGZkhp?=
 =?utf-8?B?UWJtQ3k4NG5EejlDaTRVUEV1QTd2cVNQa1Q5NDZlcnNFdkNLRnVscHoyM0Fh?=
 =?utf-8?B?NFVXRGk4N0MwQ284RFRUSzBZbHJCekhBR1VFTU0vc25vQUErWlFxOU9naEFl?=
 =?utf-8?B?VE5FVTlUVTFKU0RlSXpzZ1Y0WmZKay8zVkc4MzRIQ2l6bGRoZXFZTURwRzND?=
 =?utf-8?B?VTZKQlUvYSt2cnlWb1Jpc0hieDF5S3pTV2FBRWIwZVdrM2lGUXhHQnRBL1Vu?=
 =?utf-8?B?QnBwTjlFK0lKQ0FRR3pQYlN2dWp5cW81d0pJeDRaVFFrNm5hQTMvTmhvZGp5?=
 =?utf-8?B?K2lZdEllQ3dhMFF3REZmL0VtTVRkZUIzQzlYK3E4bzh3TmVoaU5yb0lCWjlF?=
 =?utf-8?B?SVVta1hPb0Z5VEFpV3BwTlc3SzNJV2V4aG9QbCtQcXQ0ZXJCazJja3E4bFdn?=
 =?utf-8?B?enNDL2I0ZmRYdkdhWWZWaGJnamQyUGNJZkdicmwwZDBmdjhiWC9RMVozbDNs?=
 =?utf-8?B?eUg1c056M2w0bzVtSkQ4YWNmYzRac0FZUkc2ZU96M3E1aklvOS9yeCtWWTRs?=
 =?utf-8?B?c1JadGVKRDFOUk5ibCtjWU93eStOclJXT25aT2h0RHJ1L003ck1iNk83VHlP?=
 =?utf-8?B?K1ZZdE5EY24rUURHa0JDSlNPckZIcTM1dTNoSksrcTREaXhsNkxMOVlhb3lo?=
 =?utf-8?B?ODlwNi9EVWhDZkUyZkJ3YVNIVkFFam83bThMb2FFdjFVMjRWdmVtNzZvK1pD?=
 =?utf-8?B?VDUyZnpFTmdCRUxNU25lSUJrZlp0NjFRaVJTNGZNTUFQTHhjMk9Ec25hYThY?=
 =?utf-8?B?UUYzS1lYM2VDSVZTSE9JWGl0a2YvMGRveUU4VzROcXpSN3NCZTRtUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b638d7b-bd54-4060-eac3-08df39aef8ee
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:57.4222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xqz4WuBwJWEh8CAPa6QdTRqEV1I2iDfX3tuLcwVfbTYRt8WU0o2D/EIqZ6GyDATWZRw5HTI9WGf3aQZxdJ9PRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB975636

The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
CBCRCTRL (0x811F) were placed at the top out of order. Move them down
into their sorted position next to the other CBCREG* attributes.

Pure cleanup, no functional change.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 53b523ef59df..1abf2b1deac4 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,6 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,6 +22,8 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-- 
2.43.0

