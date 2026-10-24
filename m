Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844764;
	b=oZ1fsWQJizl6rxRCx5IumjKithpaxuLhg1Ke4QrCGoeLqWUlEEZWDpg5kr3Z7ePXklxG
	 Gj75DI4RmolxBd75RbeTqX2Lz6OOkI5peJVkP2ZtVyDM0IrBmq5TdfMR09obZLlPBtND4
	 CngNOy5XEEt+QP58T+5LKKn9C2OcxX+PLvjBoRhtDkeF5tHitlSdDxkHNnD+WVDvYEGQf
	 asUi0/zm2LZxTmHdt2l7hGtOMSFxzla7m79dbC8nWc7KsjzycZrm9BmuLcdWWCY3MskT6
	 DtHyJGlOs7+GGtBn9r66YAvIHkaY+YGNov2mtZ+lRISac9S5LYzCbm/xK2iQTtqOpSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844764;
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
	bh=uC4vJfnPjB1x1u5qLDlo6eDSpEL8qkz7BUzUd6gqKRo=;
	b=h74GgifwUb0EbhDFVREQy1EMlq3yACyZlYbJkRZEGw+/0bEQC63g7VYxLQkPjUB46In/
	 ImtG8d7iydCi8lU3GJ2Tz7LavxLBxQgIzsBPXimlPijpqkzt7jIlTd8iO347G2mweMy+N
	 f+PvLFcmK9OQ02J8cBkEghaSsqiUPyI58vUS+Q3ibngzErHHMMU/A94oMoiL1qwN6sD6y
	 Pm2oq8HbqtQ9hv6KFPgA5RdQD5YRZMwYRejsrdE44aoq1MhXifbClTtPlC9v1tltMCHQ/
	 h9yvie8bE4hsYpofhumTpsUs8NGwakv67q//czTPWSWdtdz/DCDlHqOrl9AbYT769HQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=WZZej2P7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.37
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013037.outbound.protection.outlook.com [40.107.159.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7B260A2624;
	Sat, 24 Oct 2026 12:26:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D7B260A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=WZZej2P7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTlWrGgvZOTqZ7UA/+iM/DDm5s6VJFuicgXvx6IJxZAs+BY4Bb5mjYdYZHbLOeyQ2TCUIr7VQyce30zBts2zb+qZFOLkN48rvh3F3Ap93Ti7bALRA7GxV4ahjYH265MNYEQoJSlCHKjZcQ64mzO0psJEJgCFT61cBmnbwayMwo5L8pDpcR6O02AUtbk+/n8hXYzc4BkIaElI4lIcUjqnG5Z5aO668oMs9qYSYud1nxYYgKrtzCLYDjWXITakK74AjLZ2g5DMlgP61m9wPLdg96qjmcSbrhNL8jAGHlNhYGjkwk24cHkLXXy+4MXIEUh39xtjJw//WMghqkWoHbY/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC4vJfnPjB1x1u5qLDlo6eDSpEL8qkz7BUzUd6gqKRo=;
 b=IOCzel/hV8ZFgA5K2skZoTeFr+iN6viiNKGFv+fj85CAcBgiN8VlUsN+3UXLYfK3CyAZIEmgGDr8/y5FnYFjlXhdNFzkPyRUdqbxHE8HPsUGEp5RIdIjGImOQLdP9nUm/7ArbcoU9sc/SE717yosDFgn7jhmAIXWfg8xlkoEQSh8DgOxfGHLC4UjKVYTPPKiJ1GYPKsktJhaCARvPP/atbGsPWoxFfCs48UvDJzweNYUx7p223tKDx3oYBYZUOtCwbToEpNA6/bUoZPPXfS+LR9eV7XX738pDRVAEoLlcbAwISp59IItBKvo587I3xAp9sYtZ4KOdeoSfPPZTQzzhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC4vJfnPjB1x1u5qLDlo6eDSpEL8qkz7BUzUd6gqKRo=;
 b=WZZej2P75S5nBnFAhTuToxKsKhBcCF9FCEeM2sI2TWqffdZPYwRrSPdyvq+ARSoPAR2KsvNo9bmWMw+ub8Vrpy7h8+GmYsK9zPU5wpRXjGdf326XIoIXpmkdwuvKX8REgQOnrwkESh4Gg/fOWcdRoP5RlMyMiGuvgLSEe/qj79LCipT3//UYzil/coIdREI9+YbLiN1nBCQ893UxIaLSIVbFefOZMcFpdGCM5cBjM3V4jsW1Wy1MRYfe9Xll19Hxb1wqRCPH4M416S3oxwRyjUezFCl7uHeIF9aiQj9RJVfOP4vnVauSmAduHkCObofXw1RSFmYuHPhNlStnBmcgvw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AMCPR04MB12646.eurprd04.prod.outlook.com
 (2603:10a6:20b:770::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:25:59 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:58 +0000
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
Subject: [PATCH 09/10] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Sat, 24 Oct 2026 14:25:32 +0200
Message-ID: <20261024122533.3609180-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AMCPR04MB12646:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a4bbb58-33f7-4179-fbb3-08df31c9f564
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|376014|7416014|366016|1800799024|22082099003|6133799003|18002099003|10067099003|3023799007|921020|56012099006|11063799006|261022075727099003|261022105027099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 tZgEPFc6Je5yMozCha+BPH0mm1hSy6ZuhSj9l8bPOSHQsSHGZzlftVpBoS52YcSForRu57+bp9UF8bQrQqLz1DRfCLLHaC8vaEq1ONx75KE7yY4JRyy8E/ZA3Htl43PbpaXWc019HEEux1nL5Fxp3lpaUdGgiqhnKgQv3sqlXyywKWjum9qQygi7CaNbhP+K7SDWhwxt4vG8vab2bo+vXsVyeEc9uAqErkcMftalxLknOqg1UgfD6+1IYyUj3lX4HLW5xtcpuVTqIoyPq1vcr9ER/Zv2Sqyjyq2bnhVwtstzHgjhnBdPbJTEIbkBgipSsB/XBKB+mJmdIP38YCSlx8hNLwrn1Pr9VFyn4WzF2aUCvnhYFiWj25oVjRY1nYB41doSfGzFmgmOx/7MsXpjKP8A50mSqhKb+W6FdrlzQykogUIZGg8A0Hn9345ejuSpApcQsVl/3hOeDLLL+DBnvzYm7OowrtzvhBg3lrrCqx6tmnrRzXzIwT4ELWMMbQ1mjSuYBSVwAG0bSu+Vx7xPY4Zp3dM+CDeFQ4ziF/Uc3crMhUgzceP6vS8z3MwOAPbVjWmeWXu72FOklg/Gvz3xcxpe5eX2OoIalWbbYWDvpau4X+xZDGEF0Xy05JIbUhGARZGa0zxob7VAmYi2lSLnVf6qNGc9zG2s5tlXGK6lwAjeo2quQid+R01L3w9N0xluA3Z75458rACdkeq3MHnG1g==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(7416014)(366016)(1800799024)(22082099003)(6133799003)(18002099003)(10067099003)(3023799007)(921020)(56012099006)(11063799006)(261022075727099003)(261022105027099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VDRSSFYzNGgzMFh5TmhPU29GNDU0NHV0dlVPd0Fuc3ljd0s0U1BqUkxUYTla?=
 =?utf-8?B?S0RIdDhQdjJXTENReFMwa2JlM0hmRDVleUlMWFVrKzVkUVh5blRWUFNhK0tK?=
 =?utf-8?B?Z3MzNlVxbFpHMHpSWmVRbFhXRWJ1OGhrRFh2djNhaE5aNkVCVFBMdTZTTlZL?=
 =?utf-8?B?Sms1U3h5NDVtSEpZR2htd3pwbUhVcGNwQm0vRjVETVVGOHptZEFnZHZ2aEpT?=
 =?utf-8?B?V2tLTC9NNFpVcnZVbVppUm0vOGFwaGU2TURQL2p1S0xLMTFRd25LRmUweFEx?=
 =?utf-8?B?TGpQUkUxUURiM3NnRFpPRDV6R2ZXM3lxTUh2ckkzeXMraXdrL3dSdUtqRWxn?=
 =?utf-8?B?OEVxZFVwOFZndk40bXljK29tRkN1ekExWVRPMGo4NVRsWE9GYzRoODV1RkFB?=
 =?utf-8?B?K3hkTEZnS01JVVRoVUtrWkZxMjdkcHZFeXFGSGUxQWNTTVpIT1p3TTc4NEZI?=
 =?utf-8?B?VlJVUmtOWFhIcGQwSE5vN1ovU25xQWlQWS9xWHdwS0QrVnZ3WVhDVU1HaHVn?=
 =?utf-8?B?ZWZUdUF1Y0Npdy8rV2h2RWRUeDcxYVYzbFZEN05qQmxkeU5uUCtqNGZDMUM1?=
 =?utf-8?B?ZXViYjhOdjdSaEF2M3dGdHVLMTlRQUtwMS9salh5d0JOTU5nckNwR2pqeWNC?=
 =?utf-8?B?bTdwdjlpSVM5VmRVb1FvYWhKR0Y4RHhhd0ZvQ0p2Qmpvd3FNOW5SRU1aOUhI?=
 =?utf-8?B?T3MxZWdmaVBpTm5PaUN0NFVzZ1IraHJQQm51WFVwY3B4Rlhpdm1LTVVZUnVm?=
 =?utf-8?B?c04ycDlXQTB3OFJGV2RMelBRWmIxbFZRcVZuUjdrNlVHM3hwKy9TZ0dxSG95?=
 =?utf-8?B?amRHcFdyY2tseE5JTysxb3pKMEd6eVB6RER5R1NHelZEdzJZelIrcVpTaWRn?=
 =?utf-8?B?VHJaNG9iOTFFSTdiOXJsTTVaUlJGY2c0emFweW9kV2dlc2FxSXl2MWFURXV3?=
 =?utf-8?B?cXhYMHdOaEpOOU9HZ2tZMUdudSs4RTlLMzR2a2NtVXJjUzE1OFBCZ25La2VX?=
 =?utf-8?B?Tk9aVi9Vc2ZlZGRWOHl2Y1EwclNaMDhXYjRrdDlkYk1kSGswa0xXTFJneVFG?=
 =?utf-8?B?Vm5Rekc1NVcyZXVGM0Rkd2ZXMjFYUVlSTzgvcmg2QVU1MmRXbFF5aUE1UE50?=
 =?utf-8?B?WDhZbHRxSjJlNDlEa2VyNmRLSFFRSVkxZ1RFTW1yT1dzYlVuMFJYVU9iUHpn?=
 =?utf-8?B?SWxxejJ1SlNtK2tad01RMVNZKytlOWdLNmh1ZEFvRGZlVlR2NEtEcXZYTHBo?=
 =?utf-8?B?Z2RKbzRrYy9mK1dWTVVxREEveWFxU1pUa0lIbjBGZzVnbHlqWEY2b0Q3bEZU?=
 =?utf-8?B?alVua2x3bGhDNzA2L2FpWFdtMjZWb2UxUUpHbCs3TGpFdzlpejBZVUloa2o5?=
 =?utf-8?B?ZE5YSUtsNjNBazRoZCtPN0xvQlNoRkRlZ2Y4WXBIYXdOSTdHV0V5NVpFaExW?=
 =?utf-8?B?L3FlSm1kcERaNEdSNDdOU0dMVmZ2aUE0TStwM0I2U3EyZ3NVZEpjcEdwZnBs?=
 =?utf-8?B?U0doVi9abUFrbytOM1hUeGFsTGdadGI1SkszdVJMT2NDRVR2T3kxSHpFUnps?=
 =?utf-8?B?UlN6M2Z0UERpODRRdnJGckJ6N2pvS2xEajhLWURTOFRHakZQbG1EMGNrUVl3?=
 =?utf-8?B?enVEWVZJYUttQ3V5RVRKT3I2bkV0U2ZKUTY5TEw0TUxoRFNRYVZUSW9JTU9H?=
 =?utf-8?B?NXh1TXgrektCSVdpTENSRHZ2OXQ3aE13OTNDRHROZ3ZScHNCcGxvUGFMWUcv?=
 =?utf-8?B?VzRLZVBCYnk2T3ZmR1dxU0FScHRxckdmNFJYb0xlTVowKzZGdTZIUG16aUFs?=
 =?utf-8?B?Tkx6OVpOSWxwS05QUWlLNnU3SkFteVEvaTBGdzVsY2xsUERRNVNyT3VYalM0?=
 =?utf-8?B?dkpUY0FsQUlMTFIwdW9ZNXlQa3JaRjhNbVhHVG1kcm9MYkdmMVRyQnFaVG90?=
 =?utf-8?B?UmhSWDJXT1RGSms4ekora0M3YjJDK2g5aGdWVzhiZzNCcmtDSWdQVS94N3V0?=
 =?utf-8?B?Nkd2aGZvcC80MDlRSTV4bmdTNnJKR1hQRVNvaUJQRGRLWDh0NEU5NUYreGN5?=
 =?utf-8?B?Z28wUWYvSGMweFpJN29FMjZTdVZGQjBGNzd4elhUT1lXQU5SMFNTUXF5MkJS?=
 =?utf-8?B?VXFCbzFwdVBGSmN0bWY5dUJVdmVSVjdLSnY2S1NPdFJxOWxGYVgxazA0cHRu?=
 =?utf-8?B?RldOYzdpMkJFR1dKMXFUL2toOFRZMkUrQU8weTJBS2s2N29QTGxnRncyTGU0?=
 =?utf-8?B?V3RDQmljQ2pDZ2p6QmZmUWV0TFl0c214eHJHZVhSZlFta0NMZWhKbGw5aUtV?=
 =?utf-8?B?VHVpbDJVdkh1QytPL05OcTdUcDlYUVFZemQzaWpEcmJ4bnp5d3dMUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4bbb58-33f7-4179-fbb3-08df31c9f564
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:58.5899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkDAwC9L8s7EGYgSmUS4cQSwQsXIRbVIb9zrVyqv5P813t2vg/YDx/O4JqgzPymUWNkmP+Gr6JN+gvamNYeRDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR04MB12646

Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue.

This controller requires S32N79-specific initialization prior to
UIC_LINKSTARTUP, including:
  - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
  - applying the vendor-defined M-PHY calibration sequence, and
  - performing post-link calibration steps needed for HS operation.

The M-PHY supports several boot modes for loading its firmware. Only the
mode where the firmware runs from the internal ROM is supported for now.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/Kconfig         |  12 +
 drivers/ufs/host/Makefile        |   1 +
 drivers/ufs/host/ufs-nxp-s32n7.c | 540 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |  10 +
 drivers/ufs/host/ufshci-dwc.h    |   6 +
 5 files changed, 569 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..e8ee7dd05f1a 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_S32N7
+	tristate "NXP S32N7 platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
+	help
+	  This selects the S32N7 specific additions on top of the UFSHCD DWC
+	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
+	  specific configurations like PHY and vendor specific register accesses
+	  before accessing the hardware.
+
+	  Select this if you have UFS controller on an S32N7 based board.
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 7d8db67eb23c..a2f4a1d0b3ae 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -4,6 +4,7 @@ CONTEXT_ANALYSIS := y
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
new file mode 100644
index 000000000000..e7bfbefa39b9
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,540 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
+/*
+ * Copyright 2026 NXP
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+/* SCM Register Offsets. */
+#define SCM_ONE_US_TICK			0x2CU
+#define SCM_STATUS			0x30
+
+/* SCM_ONE_US_TICK Register. */
+#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
+
+/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
+#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
+#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
+#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
+
+#define SCM_STATUS_PHY_RESET(val)		\
+	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
+
+#define SCM_STATUS_SRAM_BYPASS(val)		\
+	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
+
+/* Driver-defined upper bound for the M-PHY SRAM init to complete: 3 s. */
+#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
+/* Driver-defined poll interval while waiting for SRAM_INIT_DONE: 1 ms. */
+#define CFG_MPHY_INIT_POLL_INTERVAL_US	1000
+
+/* Clock validation limits. */
+#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
+
+/* CPort definitions */
+#define CPORT_0				0
+
+/* Driver-defined upper bound for completing a Hibern8 transition: 1 s. */
+#define HBRN8_POLL_TOUT_MS		1000
+
+/**
+ * struct s32n7_phy_reg - PHY CR (config-register) write entry
+ * @reg: Register offset/address
+ * @val: Value to write
+ */
+struct s32n7_phy_reg {
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct s32n7_soc_data - SoC-specific configuration data
+ * @vops: UFS host controller variant operations
+ * @reset_config: MPHY reset DME attributes (programmed while PHY held in reset)
+ * @reset_config_count: number of entries in @reset_config
+ * @calib_mphy_disabled: CR calibration writes performed while the MPHY is disabled
+ * @calib_mphy_disabled_count: number of entries in @calib_mphy_disabled
+ * @calib_mphy_enabled: CR calibration writes performed while the MPHY is enabled
+ * @calib_mphy_enabled_count: number of entries in @calib_mphy_enabled
+ */
+struct s32n7_soc_data {
+	const struct ufs_hba_variant_ops *vops;
+	const struct ufshcd_dme_attr_val *reset_config;
+	size_t reset_config_count;
+	const struct s32n7_phy_reg *calib_mphy_disabled;
+	size_t calib_mphy_disabled_count;
+	const struct s32n7_phy_reg *calib_mphy_enabled;
+	size_t calib_mphy_enabled_count;
+};
+
+/**
+ * struct s32n7_ufs - S32N7 UFS host controller data
+ * @reg_scm: SCM register base address
+ * @soc_data: SoC-specific configuration data
+ */
+struct s32n7_ufs {
+	void __iomem *reg_scm;
+	const struct s32n7_soc_data *soc_data;
+};
+
+/**
+ * ufs_s32n7_phy_write_sequence - Write a sequence of PHY registers
+ * @hba: UFS host controller instance
+ * @cfg: Array of register configurations
+ * @count: Number of entries in the array
+ *
+ * Return: 0 on success, error code on failure
+ */
+static int ufs_s32n7_phy_write_sequence(struct ufs_hba *hba,
+					const struct s32n7_phy_reg *cfg,
+					size_t count)
+{
+	int ret;
+	size_t i;
+
+	for (i = 0; i < count; i++) {
+		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
+		if (ret) {
+			dev_err(hba->dev,
+				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
+				cfg[i].reg, cfg[i].val, i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ufs_s32n7_configure_clocks(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	struct ufs_clk_info *clki;
+	unsigned long clk_rate = 0;
+	unsigned long one_us_tick;
+
+	/*
+	 * The core reference clock is managed by the UFS core (it is listed in
+	 * the DT via clock-names/operating-points-v2 and added to
+	 * hba->clk_list_head). Read its rate from there to derive
+	 * ONE_US_TICK/HCLKDIV.
+	 */
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk) &&
+		    !strcmp(clki->name, "core")) {
+			clk_rate = clk_get_rate(clki->clk);
+			break;
+		}
+	}
+
+	if (!clk_rate) {
+		dev_err(dev, "Failed to get valid clock rate.\n");
+		return -EINVAL;
+	}
+
+	one_us_tick = clk_rate / USEC_PER_SEC;
+	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
+		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
+			one_us_tick, clk_rate);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
+		clk_rate, one_us_tick);
+
+	/*
+	 * Configure the micro-second tick rate generator based on core
+	 * clock rate.
+	 */
+	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
+	ufshcd_dwc_program_clk_div(hba, one_us_tick);
+
+	return 0;
+}
+
+static int ufs_s32n7_hce_enable_notify(struct ufs_hba *hba,
+				       enum ufs_notify_change_status status)
+{
+	u32 reg;
+
+	if (status != POST_CHANGE)
+		return 0;
+
+	/*
+	 * Clear the DWC low-power gating (BUSTHRTL) so a doorbell write can
+	 * wake the link out of hibernate. LP_PGE (generic low-power) and
+	 * LP_AH8_PGE (Auto-Hibern8) both reset to 1.
+	 */
+	reg = ufshcd_readl(hba, DWC_UFS_REG_BUSTHRTL);
+	reg &= ~(DWC_UFS_BUSTHRTL_LP_PGE | DWC_UFS_BUSTHRTL_LP_AH8_PGE);
+	ufshcd_writel(hba, reg, DWC_UFS_REG_BUSTHRTL);
+
+	return 0;
+}
+
+static int ufs_s32n7_phy_initial_calib(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	int ret;
+
+	/* Calibrations that must run while the MPHY is disabled. */
+	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_disabled,
+					   ufs->soc_data->calib_mphy_disabled_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Calibrations that must run while the MPHY is enabled. */
+	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_enabled,
+					   ufs->soc_data->calib_mphy_enabled_count);
+	if (ret)
+		return ret;
+
+	return ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+}
+
+static int ufs_s32n7_link_startup_pre_change(struct ufs_hba *hba)
+{
+	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	int ret;
+	u32 reg;
+
+	ret = ufs_s32n7_configure_clocks(hba);
+	if (ret)
+		return ret;
+
+	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
+	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
+
+	/*
+	 * The M-PHY firmware runs from the internal ROM:
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
+	 */
+	writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* MPHY reset configuration: vendor attributes set while PHY in reset. */
+	ret = ufshcd_dwc_dme_set_attrs(hba, ufs->soc_data->reset_config,
+				       ufs->soc_data->reset_config_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Release PHY_RESET. */
+	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* Wait until SRAM_INIT_DONE = 1. */
+	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
+				 reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
+				 CFG_MPHY_INIT_POLL_INTERVAL_US,
+				 CFG_MPHY_INIT_TIMEOUT_VALUE_US);
+	if (ret) {
+		dev_err(dev, "UFS MPHY init not done!\n");
+		return ret;
+	}
+
+	/* Start of initial calibration */
+	ret = ufs_s32n7_phy_initial_calib(hba);
+	if (ret) {
+		dev_err(dev, "UFS MPHY initial calibration failed!\n");
+		return ret;
+	}
+
+	/* End of Gear1 settings */
+
+	return ufshcd_dme_check_tx_hibern8(hba, hba->lanes_per_direction,
+					   HBRN8_POLL_TOUT_MS);
+}
+
+static int ufs_s32n7_link_startup_post_change(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val cport_setup[] = {
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_IDLE, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
+				CPORT_DEF_FLAGS, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_CONNECTED, DME_LOCAL },
+	};
+	unsigned int data = 0;
+	int ret;
+
+	/* Network layer: set Local DeviceID. */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
+	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
+	if (ret)
+		return ret;
+
+	if (data != CPORT_CONNECTED)
+		return -EIO;
+
+	return 0;
+}
+
+static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
+					 enum ufs_notify_change_status status)
+{
+	int err;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n7_link_startup_pre_change(hba);
+		if (err) {
+			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
+			return err;
+		}
+		return 0;
+	}
+
+	/* POST_CHANGE */
+	err = ufshcd_dwc_link_is_up(hba);
+	if (err) {
+		dev_err(hba->dev, "Link is not up.\n");
+		return err;
+	}
+
+	err = ufs_s32n7_link_startup_post_change(hba);
+	if (err)
+		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
+
+	return err;
+}
+
+static int ufs_s32n7_pwr_change_pre_change(struct ufs_hba *hba,
+					   const struct ufs_pa_layer_attr *pwr)
+{
+	/*
+	 * RX rate-select override sequence: assert the override, then deassert
+	 * the value, then drop the override enable so normal operation resumes.
+	 */
+	static const struct s32n7_phy_reg pwr_change_phy_regs[] = {
+		{ RX_OVRD_IN_1(0), 0xc },
+		{ RX_OVRD_IN_1(1), 0xc },
+		{ RX_OVRD_IN_1(0), 0x8 },
+		{ RX_OVRD_IN_1(1), 0x8 },
+		{ RX_OVRD_IN_1(0), 0x0 },
+		{ RX_OVRD_IN_1(1), 0x0 },
+	};
+	u32 rate;
+	int ret;
+
+	/* Rate change only applies to the HS power modes. */
+	if (!ufshcd_is_hs_mode(pwr))
+		return 0;
+
+	/*
+	 * Select the M-PHY rate (rate series) that matches the mode the core
+	 * has negotiated with the device.
+	 */
+	rate = (pwr->hs_rate == PA_HS_MODE_B) ? CB_RATE_B : CB_RATE_A;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), rate);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Apply the RX rate-select override now that the target rate is set. */
+	return ufs_s32n7_phy_write_sequence(hba, pwr_change_phy_regs,
+					   ARRAY_SIZE(pwr_change_phy_regs));
+}
+
+static int ufs_s32n7_pwr_change_notify(struct ufs_hba *hba,
+				       enum ufs_notify_change_status status,
+				       struct ufs_pa_layer_attr *pwr)
+{
+	int err = 0;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n7_pwr_change_pre_change(hba, pwr);
+		if (err)
+			dev_err(hba->dev, "Power mode pre-change failed (%d).\n",
+				err);
+	}
+
+	return err;
+}
+
+static int ufs_s32n7_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s32n7_ufs *ufs;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufs->soc_data = device_get_match_data(dev);
+	if (!ufs->soc_data)
+		return -ENODEV;
+
+	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
+	hba->spm_lvl = UFS_PM_LVL_5;
+
+	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
+	if (IS_ERR(ufs->reg_scm))
+		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
+				     "ioremap failed for SCM registers.\n");
+
+	ufshcd_set_variant(hba, ufs);
+
+	return 0;
+}
+
+static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
+	.name = "s32n79",
+	.init = ufs_s32n7_init,
+	.link_startup_notify = ufs_s32n7_link_startup_notify,
+	.hce_enable_notify = ufs_s32n7_hce_enable_notify,
+	.pwr_change_notify = ufs_s32n7_pwr_change_notify,
+};
+
+/*
+ * MPHY reset configuration: vendor DME attributes programmed while the PHY is
+ * held in reset. Programs the reference-clock, RX squelch, RX Rhold and
+ * CR-parallel control attributes.
+ */
+static const struct ufshcd_dme_attr_val s32n79_reset_config[] = {
+	/*
+	 * Disable reference clock gating support and override the UniPro and
+	 * application reference clock enable inputs to 0.
+	 */
+	{ UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x8A, DME_LOCAL },
+	/* RX squelch control. */
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN0_RX), 0x1, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN1_RX), 0x1, DME_LOCAL },
+	/* RX Rhold control option. */
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN0_RX), 0x2, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN1_RX), 0x2, DME_LOCAL },
+	/* CR parallel selection. */
+	{ UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1, DME_LOCAL },
+};
+
+/* Calibrations that must run while the MPHY is disabled. */
+static const struct s32n7_phy_reg s32n79_calib_mphy_disabled[] = {
+	/* Bypass RX AFE calibration. */
+	{ FAST_FLAGS(0), 0x4 },
+	{ FAST_FLAGS(1), 0x4 },
+};
+
+/* Calibrations that must run while the MPHY is enabled. */
+static const struct s32n7_phy_reg s32n79_calib_mphy_enabled[] = {
+	/* Write ATT offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x8E },
+	{ RX_DAC_CTRL(1), 0x91 },
+	{ RX_DAC_CTRL_SEL(0), 0x1 },
+	{ RX_DAC_CTRL_SEL(1), 0x1 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* Write CTLE offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x71 },
+	{ RX_DAC_CTRL(1), 0x7F },
+	{ RX_DAC_CTRL_SEL(0), 0x2 },
+	{ RX_DAC_CTRL_SEL(1), 0x2 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* FW Calibration configuration. */
+	{ FW_CALIB_CCFG(0), 0x100 },
+	{ FW_CALIB_CCFG(1), 0x100 },
+};
+
+static const struct s32n7_soc_data s32n79_soc_data = {
+	.vops = &ufs_hba_s32n79_vops,
+	.reset_config = s32n79_reset_config,
+	.reset_config_count = ARRAY_SIZE(s32n79_reset_config),
+	.calib_mphy_disabled = s32n79_calib_mphy_disabled,
+	.calib_mphy_disabled_count = ARRAY_SIZE(s32n79_calib_mphy_disabled),
+	.calib_mphy_enabled = s32n79_calib_mphy_enabled,
+	.calib_mphy_enabled_count = ARRAY_SIZE(s32n79_calib_mphy_enabled),
+};
+
+static const struct of_device_id ufs_s32n7_match[] = {
+	{
+		.compatible = "nxp,s32n79-ufshc",
+		.data = &s32n79_soc_data,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
+
+static int ufs_s32n7_probe(struct platform_device *pdev)
+{
+	const struct s32n7_soc_data *soc_data;
+
+	soc_data = device_get_match_data(&pdev->dev);
+	if (!soc_data)
+		return -ENODEV;
+
+	return ufshcd_pltfrm_init(pdev, soc_data->vops);
+}
+
+static void ufs_s32n7_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_s32n7_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	= pm_sleep_ptr(ufshcd_suspend_prepare),
+	.complete	= pm_sleep_ptr(ufshcd_resume_complete),
+};
+
+static struct platform_driver ufs_s32n7_driver = {
+	.probe = ufs_s32n7_probe,
+	.remove = ufs_s32n7_remove,
+	.driver	= {
+		.name	= "ufs-s32n7",
+		.pm	= pm_ptr(&ufs_s32n7_pm_ops),
+		.of_match_table	= ufs_s32n7_match,
+	},
+};
+
+module_platform_driver(ufs_s32n7_driver);
+
+MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
+MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 1abf2b1deac4..d62cd4c085ba 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,6 +13,8 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
+#define RXSQCONTROL		0x8009
+#define RXRHOLDCTRLOPT		0x8013
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -27,7 +29,15 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
+/* CBRATESEL: 0 - rate A, 1 - rate B. */
+#define CB_RATE_A		0x0
+#define CB_RATE_B		0x1
+
 /* M-PHY registers */
+#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
+#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
+#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
+#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
 #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
diff --git a/drivers/ufs/host/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
index 6c290e272106..c66f33391b65 100644
--- a/drivers/ufs/host/ufshci-dwc.h
+++ b/drivers/ufs/host/ufshci-dwc.h
@@ -12,9 +12,15 @@
 
 /* DWC HC UFSHCI specific Registers */
 enum dwc_specific_registers {
+	DWC_UFS_REG_BUSTHRTL	= 0xC0,
 	DWC_UFS_REG_HCLKDIV	= 0xFC,
 };
 
+/* Low-Power Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_PGE		BIT(16)
+/* Low Power - AH8 Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_AH8_PGE	BIT(17)
+
 /* Clock Divider Values: Hex equivalent of frequency in MHz */
 enum clk_div_values {
 	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
-- 
2.43.0

