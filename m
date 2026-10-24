Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844750;
	b=C5rrd8OKMGmmb8vPnwW9PDhI+S5ZVX68G/Hk1RZ3fN53mCt539W455de7y3JGGL1Bwn8
	 lmhbOh9n9e6wxXPBFr/us5xY/kWbAm/7PVBJC30ZDTGBGgpgJMursjECKrLHpRg0xfOLk
	 MS3RdhdDu7BbH68r5/+80vwGOWISeLFCQIyhQOcE9Lryk+jAnPpBEhuJFuywUwBAe0e1z
	 Z3lwuJWSRkQGL1jxs9RexXaV3kieclg+c+OzirFIR51qhFZkA62hgCjAiX0g8/8rMxEvp
	 DwEqi/og8FVwJ2s24ZYPRg21KBwiaFx2aMolG1Pq8b3Bd0UcgK4a4BimBXtVUnhIJsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844750;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:
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
	bh=khuXjQS6Mj0XgL5YItREt8XVu/nFbq7rHTl2M+SzVyU=;
	b=tNGMI+cHfFEHDh+1Xk0dhl6v3i35ed91mznTpOjwEuo9JlTIxcCWKYcOZBFYukyjVe84
	 psQ7ucwV93xSWmYmRvu1ztrTG9KRgAA8sfq7NEMkytoaZnhxFRbrMkcmm4sdlamecBjh/
	 AvwJ1LnBBhd8/SxBJbN0yP5NVH85Od3iHj3bWuQICx7DvPAoXcvOmnClnakiuJSlI3Nqw
	 lpnPh+ezJV32Dp9F0P6tB08Q+uTctIbMdh1RbtQeqkVBIvTH+FGRtAjd3g/cLTpC9bgSQ
	 r3xH/tYMJhHp5yyPgykmDjD5nsSmnNzaTHCjbQ6McVbA07yI0pBDdvlwCTE1eQz70iw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=tw6jXD7E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.33
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013033.outbound.protection.outlook.com [52.101.72.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF60606A31A;
	Sat, 24 Oct 2026 12:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AF60606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=tw6jXD7E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kbhJZRM9NsZROEhK/CpmAa9nLSL5mOP/dtewBsRG11gNoo535d5vIsJnFcMF+DfDQ3d4ziJfTABgLyu5mhxxPvdpbJxAP8G2yx53BArKuuNYq0y1KrBRB4atoxsAPsD9dX/Aahsf7fbybhPXDd5rCln/ivrwRRd31L1qSzBNKnlQStN5b/M6p5xBn0wfppmwvbXjKpuzvgCy0Tk+edaFhiWvIXfQvRSnJ5BnDO5/Nswa9o4bSS86rk8svDQVlpZ9b0yAF81yR5KSmxYxYvQrFeM9XSHK3aVTapb21BXQhfaScpgCQ12rQLhVAlly2cDvCuEra+40bTJQhRdI67dCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khuXjQS6Mj0XgL5YItREt8XVu/nFbq7rHTl2M+SzVyU=;
 b=c5XVGAAXzC+5CMVMULIp06pxE4ImvWA6p+U8Ld1ITa35xCN4CrVck3Koo3THSNLnIEfnpVfSlbl2MM9kfawcYyhR2vzKwtBJJKAQ129upEIXzxz3DPLUq1ruGoQdRyuLJDXG1s3V1Vxqt2rn3GYM/w068p1rzMxzUqYPS1RJ0edUnXGFdGFgiVFq617jFPjJLxz4XjmAlS0N15sSNv5N5U0HpkLRqjNXeuxbccINxdw110LLMT28Sh8RhNPmnoKOKjNRbDwf9OddTk8ZWE+3uMq7/fv15uzvUoVRIZ8DZWF+kEfcapa3O+pqRZ4hM+aYX/Ov448zbR7xGav7nkCeow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khuXjQS6Mj0XgL5YItREt8XVu/nFbq7rHTl2M+SzVyU=;
 b=tw6jXD7EZEtCsd03XHfanaWymUeUagxb6ALjfgOqCz5xF47DAUuPFPydH3HeuJcp1oYHtDFYllUHe089M7do4yTPG+AT0lX0PMXd5CYG6fcvfw+8G/fAGMO9Vgqc2ALgAykcXO0d238x0hoMsDndapgFZvD3vLoSGGsq0a4EiqT0eOWhC7lQnCXB21zKHGqRQ+ojx5GV5XiRnp2n2GBQCesRpM1hT6vY8t5ZEOJrAU92rqmYexrB4vc2CmWLQN9XQ47UIuAS4UbXBL3z5wbuWiB7ikMCrk85uGtTS4+k7T/hRywUBu7ND8kk8iHKQ3yaVf96durJJOQ1fGgua+wWEg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB9687.eurprd04.prod.outlook.com
 (2603:10a6:102:270::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:25:43 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:42 +0000
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
	echanude@redhat.com
Subject: [PATCH 00/10] Add S32N79RDB UFS support
Date: Sat, 24 Oct 2026 14:25:23 +0200
Message-ID: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB9687:EE_
X-MS-Office365-Filtering-Correlation-Id: 62d4489a-a3f4-4052-215c-08df31c9ebcf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|19092799006|921020|11063799006|56012099006|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 ciiBKgF0s8fQ3ebPzdZzeIQOzPwzFNCbWviSSEkhc9/ExG+M7mOfWNv5qqe9zGNcPIEK3BjGzpdXEk3lVPhF5NwMBKsobhX93Wd+oe/CXOJzWfrs+SLTZ+z84shldxoP0SdHxBuudj2kY4wZtezWeHSBDw+xAbG4HcAUXz1ZMwBTdexcPdmXo3EZ9cnQyfX3DPfeEz3dEnBXMb4GJHF6RnKp5AzdOXPkZwUVlDCkCKurqABu0RC6DkXtAYL0WbFAexLIdLjPf/VcvNexWkrMRhnRIk2ZkXWHmHWT3YZgQDOgTweJm+FXmU328J4vLBsd891dyQV+7cOFonRnLYg0YZ2kyOpUY2Ocmirw3DcyKgKP/Z8A/muCp1HyqFic2SeGAxv9i2a9sqgtPdrZiJP083U4e/xGLG61Zh0/dAI1S/Ah1Xc8PvXnIrwDB+kVWkZxXFNRznE+AGLiSb4bBexrxb32nMSVS0CETpl63fWqFmIJQzH79Av7yieJmjkdG9/aLT91cn+LIYxEuBjbmuNl2w59Nkcr3W9eo+R/l2LvR7xSPZ7qF6MI+fa8+rCejlVoGyVx56IcW6jlR3z3NnQAE85q2REylaLTeDyeL0E8ceszr7+ou44Miztr3Ur5fnegkeEd5GUAHR0Ov3UD6Hsaws99+GtbhaiQRaXWMEyH52q8sLeNhNvHLxv9vhxKizryNiBY64UIANfcLbbNO99aiQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(19092799006)(921020)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MkRtWEUvSU1sRlFLbUxpelBWeTRrMENtWWM2ejltaTJRSHR5YVQrWHpCQlU2?=
 =?utf-8?B?aW4rRysyL2ptQXpqS0lMcEZ4aFJhTUIvM285aE9EQVI0aVdVZ1k3bTdCMXRM?=
 =?utf-8?B?YkZTWCtuV1B6Rk1HbVBGOThxRzhFOGM1MUpGdEtDN1RUM2t1QU5oOWZIRTg3?=
 =?utf-8?B?MS81aitueFc0QmV6aDBwME9tZXpkeE5WVmZ1Y2lWU1hNaTVCQW5HaHI4RTVV?=
 =?utf-8?B?bkl0QWpKM1ZEUW8vK3BPVFB3NmwzbVltclZXbnBRSnR3b0N5VUwyT1I3MVNr?=
 =?utf-8?B?RGlHL29oUC9qU0V6dWJEc1A4cDc0N0F3a0VITEJKYzIrVWpwWXZsdVo4RWs3?=
 =?utf-8?B?UWxCdVRzS0xrVmxpdkJpSVhPOWtzVFdkeVkydWszVERZdFB2UXlPRXo4TDFq?=
 =?utf-8?B?ZVd1YUQ0Vm9CZko5VXRhTlhpNVY0Qjl6SEdSNXZGT2MyMmQycXZ2cWJueG4w?=
 =?utf-8?B?ZDlySDFzV3dteTBucWU0ZDRUa25mRUNBcDl5Z01QSWFoN0RsQ24yN0ozdWJz?=
 =?utf-8?B?M2t0U01UMnZXMGRNZWl0bno0Ujh2TEE0TEFzT1pKUUtSSnVVa2svS0prQWtr?=
 =?utf-8?B?Y2J3cHNpN0ZsTCt2YThBQjhjTjh3M2E5U05tVEJTdjhHWHVTZlVFdzdUTk45?=
 =?utf-8?B?a0Z0YWRndk1hQjBHb2VtTVFseSs2dk5OdktzRmFzQ2xxTk9USEhncThRWllm?=
 =?utf-8?B?aUVyU3ZaMU9wZ2kzQUhmQUlTdGNZZTZrbmc3Rkozd1ZFV2NLenZlN0o3S3R4?=
 =?utf-8?B?QkpGTHgwazdEWmx4ZU5MYmVFNGVJdFUyd2lzeFdxT05WK2xIeG9Od3IzM2JW?=
 =?utf-8?B?Yyt0b3ZzNlF1MXo1UnY4U0FRdDNSanNGeXdpN0VHQllvUFFJa0VXWno4YXMy?=
 =?utf-8?B?YkdGdTV6Y29QbW9HV0IzdzRVL0xsQllZT1p1NlR6cnU2S1V1UGZEc2NZb3Vx?=
 =?utf-8?B?YVp0d1BXOTh0dUpSR1QxLzlIS1Q4OEVSZFVCeGgxNUEzZ3pwb1hhcFlZR1JM?=
 =?utf-8?B?YnU2b2JxaFlaTkdYQnJXUVZxTnBEMytLenRRM2cyUDhCUG5JWlRyWVloNm9h?=
 =?utf-8?B?QktQSk85WEZJeWJ2emVOd2hxMnV4cDZDQ1Z2TnIxaWxvMUN5eXdOOTRyNTdw?=
 =?utf-8?B?YlVNMk5aOVpaT2owL0NFZG82dGxDREZpVWY5TldqeVdUTUNZQjFtY254NFlN?=
 =?utf-8?B?L0lNdVV0b3lnUjFiODl4eTJqMHhmMHJrVEx3M1JDSlV6ZG1ycWlHeDViQmJU?=
 =?utf-8?B?ZUJpY0l0cnNraS8xZjNTSzd2eWJBVXMvbWNLeEt4dEZKOEkwWGFjNlZFcnhp?=
 =?utf-8?B?UEZ6clFwMEpkNWpmL0FEeTVtRlN1cFRSajZTVVZrL21mMmVwYXlFT2hxNXly?=
 =?utf-8?B?L1NoTUVjeStDRm9NN04wbXg5RHpGRUpFVU9SZXViNG83Y255L01pNHhKNldi?=
 =?utf-8?B?Q1JUWDFwVzBRNVU1SXpvajkwei92RzByRVNNaVcrRER0dExUNS92bEZHRUVy?=
 =?utf-8?B?YUR0WVhwSWJCQ3dDcGl4TkF2Um5NZDRET1o4Wm9LakhsajVYZ0ZrcnpsK1Jr?=
 =?utf-8?B?TEtENDJmd0NVVGdMTmw5TmdBQ25keVA5MHF2YnB1aVViZjFQc1VXRGphZVZX?=
 =?utf-8?B?TkFkekNrN29wUS9MaTVOckVLMWY5NmhWWEc1Nk1OdWZ4M2RsVlhHYzBsRElV?=
 =?utf-8?B?T3FGZWxUeEVxblRlcWp0V2tjSnMvQk4xQlZWQUg3VStFbGxVdmp4ajhqbGpS?=
 =?utf-8?B?LzN3M2d3RDYyVkhKMkp6WnAzTFQ0QnVkeGhEWjhDY0pocWN6c1hSTjFLNGhQ?=
 =?utf-8?B?QzZuYU5YSWhDOURycUxWd0RTWkpHNW9WRW9OYUJwSGp1WmhycUk5OEJwL2Er?=
 =?utf-8?B?Q2p0KzhONjJZYmpVMndpTEIxK29Ka0pLRStpT3NwcFczbE9SVnQ3VVRHemtz?=
 =?utf-8?B?K25qS1RJcU5ETnkwNW9DS1dNNWJNMDEvRnFNdmFwZm5FVHdsWFozNGZOb25G?=
 =?utf-8?B?SE4wQjI3NGs1YjBLMWE1dkJ0V1ZkS05GM3cxZFl4amtGYVU3aXVFaVRDV3Uy?=
 =?utf-8?B?ZEI0Mm9wOFRyTC9iMkFrbHVDL1RjeDg1Z2ZSUlRpM2lpTXdZcXFDRmZDZHNM?=
 =?utf-8?B?dExGU0xtTFovcWxUVEdZTHJ3VDJ4L0x6WDhTNXY3clFDNVdjSGJzWDJ4Qy9T?=
 =?utf-8?B?dkVyME5IUzNmQmRjMksvWWx3N0lFQlpIUENiaGpiblgrQlh5bnpwSzMvN2VX?=
 =?utf-8?B?QitIQTRRT01zbG1pQ2VHaFo0LzlHUnl1dUcwbWVOM3ZnUm1ZSWZVaEM0WjVY?=
 =?utf-8?B?OWtQZGpTR0NCMGdDM2xKblJPTnNpaXhGWHJkcllCcFVNTHlldy9Udz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d4489a-a3f4-4052-215c-08df31c9ebcf
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:42.6446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ud0+zQhkQkEmrM4H+SftQAiYPqimj1lDx7vEnGNAZdAGB4ROJPudbfb/4+nPD12h6UbznddsV4gxG4TMoJNF6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9687

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

Device tree binding documentation for the S32N79 UFS controller is included.
The SoC and board DTS updates that instantiate and enable the controller are
no longer part of this series and will be posted separately.

Changes in v9:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Prefixed the RX_STATE_* and TX_STATE_* enum constants with UFS_ to avoid
  polluting the global namespace, and updated the existing users
  (AMD Versal2, HiSilicon, Qualcomm).

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use the renamed UFS_TX_STATE_HIBERN8 constant.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

MAINTAINERS: Add NXP S32N7 UFS host controller entry:
- Added the imx@lists.linux.dev mailing list.

arm64: dts: freescale: s32n79: Add UFS host controller:
arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Dropped from this series, as requested; they will be sent separately.

Changes in v8:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Added Reviewed-by: Stanley Jhu.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Let the UFS core manage the core reference clock: declare it in DT via
  clock-names/operating-points-v2 so the core adds it to hba->clk_list_head
  and gates it across system suspend and runtime idle. Dropped the manual
  devm_clk_get_enabled() and the struct s32n7_ufs core_clk member, and now
  read the clock rate from the core clock list.
- Dropped the ufs_s32n7_calculate_us_tick() wrapper and inlined the division.
- Dropped the unused struct s32n7_ufs hba member.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added the required clock-names and operating-points-v2 properties.
- Dropped the Reviewed-by and Acked-by tags.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Added clock-names = "core" and an operating-points-v2 table with
  opp-hz = <0> (fixed-rate clock) so the UFS core manages (and gates) the
  core reference clock.

Changes in v7:

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Wrapped .prepare/.complete in pm_sleep_ptr() instead of pm_ptr().
- Fixed code alignment issues.

Changes in v6:

scsi: ufs: dwc: Return a negative error if the link is down:
- Translate a positive UIC command result from ufshcd_dme_get() into -EIO.
- Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- Added Reviewed-by: Frank Li.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Added Reviewed-by: Frank Li.

Changes in v5:

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- New patch. Split the macro reorder into its own cleanup.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Return the real poller error on timeout, not a forced -ETIMEDOUT.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.
- Removed the select: block and the clocks description.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Documented the timeout values as driver-defined bounds.
- Wrapped .prepare/.complete in pm_ptr().

arm64: dts: freescale: s32n79: Add UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.

Changes in v4:

scsi: ufs: dwc: Return a negative error if the link is down:
- New patch. ufshcd_dwc_link_is_up() now returns a negative errno on failure
  instead of a positive value.

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

Changes in v3:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, so
  real attribute-read errors are returned instead of masked.
- Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
  ufshcd.c.
- Drop the now-redundant dev_err() after the check in the HiSilicon driver.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Use devm_clk_get_enabled() to enable the core reference clock.
- Rename the family-level identifiers from the s32n_ prefix to s32n7_
  (structs and functions), keeping the s32n79_ prefix only for the
  chip-specific data.

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
  scsi: ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  65 +++
 MAINTAINERS                                   |   9 +
 drivers/ufs/core/ufshcd.c                     |  73 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  97 +---
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 540 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  86 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 16 files changed, 851 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

