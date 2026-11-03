Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712784;
	b=AwmhoIAI3JBMiJk9wEAVDKwWNvxcFNN+TdqP5XYQHsTu5MkGEwCa3DnTpq8WK2UrGcHX
	 FRNmkxwqE71IFbYVDg3UlVGvP/bywPqUO2OI6i/10Tnx4+pFhp+yen/aJPLqTqAMmioVC
	 4VQ9n0H5XyNwgSaLnQHUrmRkYFcF3qqxRgcu3ydneeD+dB5PBmk4kRWPpHNb97nNQLkuD
	 hAiPrCZV4BIEQAeHCsC8loFaObW505ptWmrBAQdPq0wZ4QTa6qCbsIuNPNSVnvFgXGvZx
	 8SMhyoZX9TQ2/YlWc8tXsYs4Oj1GoazGOkTmWTgmFMKsN0Gq0ChwMAkjPS04tCxkFnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712784;
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
	bh=oL6Dmw3uU2gtyIcoRXO0m+O8UV811QM92MmWjel3B44=;
	b=fOXp5Z10OfPEIel59ta9QLdKrKnACxddqohDR7uCSeHDx0MhVBy4apJODcSM4DpMZqtu
	 Z7laGTJ8W1r+imbXSOV+ucHSTAVhXbXhut5rGUTUwhWzb23f3yHCGBhZgQNbnAYFqpuyv
	 tFrzmfV5EWIR3ydvzMhmZImVc6CuxiRBZ7PIyhFoEUE5Cl591AnNaww7GEgF6EbjRfN+X
	 gUAbjXXfdg5VaWZ0pYK6KOnO2QMiOqSMN7O8a1MD66O/CqIDbufCtKYeTRmQoFENRD9dH
	 Q/8kKx5cgjt2JVQf6SOHzz00EqdvDwJdPQb46F7vr1CUhKEagMZg3quM/L76odwkHpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=SqGqhjNU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.20
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010020.outbound.protection.outlook.com [52.101.69.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88096082BEC;
	Tue,  3 Nov 2026 13:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B88096082BEC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=SqGqhjNU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNZqSyrF2xcgYYP1Yceu/nLwx5vjhE6RC7S6K3ItuZ21wos850YlpHFrj06hsOXJvMhiB1XdFXYZ8tO0YyPEC/ZYVhNBBnLS8L6EKMg1sJMLhi9HZpgTNA4EIFUDadjVQiyKnebWA4G70claVZCSqm6HxxIiQfr88YSBjkmbgpxgCRCTf3wTqTug2tf/fKLjlItD5E6w3bvrNYb6PKwlvKcPpufv5q3gmaPlXVqTM1Y3QHCx6ps1gfxSdw2afhmwZRcya4iqLEvtQckHWj1gslVTqZgEIOmgjZuZZbNElsJUk/fpFPc/DSc4l6QMhWzJvTWyqrKfaVyyn+kczYHFOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oL6Dmw3uU2gtyIcoRXO0m+O8UV811QM92MmWjel3B44=;
 b=rPs52+w1BAgFdctqD4wJk4Kr2X+nP9UzJlSBBVX46ESwRJJEjEVUnZISLUz6R9g1FJG9B+y/Jpivre2Dww2hPgYmAyXD85a2FunPsqQlyr97YQLN/llbVwvqSPYsiI0qRsX2aL4wRS5v8aIns1346rICxYPgA2lJEokcdzw01U7WWIpM5uJft7hwQU2gACeSNN9QFL9jUpyXdRSWM1N0YlHgpjPDzPdrt1kdz79Ho7ZW86xWakopDbTumdjMS/wDlH0HldUEKxlLIftEpSNcnDJlUqtB4hmvBfEGDrS9EzErU/Yr6MNi3bb56P2qIYbsAXJSLJKFvaqckpemo+Up7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oL6Dmw3uU2gtyIcoRXO0m+O8UV811QM92MmWjel3B44=;
 b=SqGqhjNUpP1yUAtLxiSFndFSnGGT2QFd+B/AK9yqmr5QIoFQtmEJPLU8f5P+WVczesN5TodCbE/ss727Qg78OuMoI+uyCjPgHvCWb7mjnWkbkce+Mpwssa+vXYHQDYuqCnZDKe7+RwUpQU3G2HlDZVSlbOVKCaqD0HuPhELuCOrNUCDsZQ1yPKoRd0AKeJoqne/8nPfVzfiIhM8WUuIZ+0+XvZTQNjV0wnxAORTUUBHAJFfB+r60H9tjlc16R3mphKaHKONvQjyGImrOHF8lXDJ7sw11GjwCu2WZJL+Y+W8Gxv6ksucOf+lgrb/gSdpDLpBGvDCfDT1kvjKCNZWV+A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU4PR04MB10838.eurprd04.prod.outlook.com
 (2603:10a6:10:581::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:59 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:59 +0000
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
Subject: [PATCH v10 10/11] ufs: s32n7: Add NXP S32N79 UFS host controller driver
Date: Tue,  3 Nov 2026 14:32:14 +0100
Message-ID: <20261103133215.1385823-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0511.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU4PR04MB10838:EE_
X-MS-Office365-Filtering-Correlation-Id: fab19063-da01-4180-8f73-08df39aefa18
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|376014|7416014|261021121427099003|261022105027099003|261009223027099003|261102123227099003|261022075727099003|921020|261026140227099003|261026121527099003|261028144727099003|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 bNYPxmlraM60KHih2XZ8aKnRkz6qaR828w5gqNQPjAdCSpWNcdXBthMTqRNnA7B2JfKdpYmSGAgFa8vhMRSt2T1Z1B73z6N9fq8uPklReuuFmy69p+gHIkAxQEyfUi2OGA7WjiLplC1SK+9vRpj0XUq3mjaSzjxQ7ZSBsDErxj4o2ysxUmsBg/4k9rSa1Dc1V/XXtgICbyMkgPDuOJQalkDDDOAYB3IB9CCR9EmRo0bKPLmj3qTUPT1NPQgqJjVXQtcaJv6UHW9ucJvmdvBqhK/zaQEAS0euNPzhzUGbcRgY/NcUUlpfm1/+7OkcIyWDVZMD38rqiPXUMIN7YycNdwsARWKM2k1KQC3D4eX6Mb3u8Oe3pAaCmJir89Had7eAI5IUL71HMwAoF7KqbAh37Rh/qgkt+vn9UpRxaljB4J6HasRoDVoRx9HaxkOa4Mme3ER57fCh/L/XvQecd7x+sCEK6xdCWf1xaiMrTQW+L/K6/4z7s+HNBk2rP+ijJSZADUwCOJXPDHw7DIAAC70ukFpyDp/fb+WKm/xHB0YsGfkeLmE/8u+dhup8G9ugPr4kGKT8XmOe6RwyGwjLvMZDalbeG7tbrEpFc+0oD2g26zugfdlokO6DNNslV8d/p+U0gdDhr62InT9EjnQUmpRlaKxKKiE1fnTITKpR6p+BAZ6MCw5XlqIw5P/WeFX0o0TxFiN4hCeXTyAkTFGz9vRNug==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(376014)(7416014)(261021121427099003)(261022105027099003)(261009223027099003)(261102123227099003)(261022075727099003)(921020)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZitDWEhENlVGRmVYTjlNUU9TMm9wcGorRzlEaUJHckNkUGxDRDl1WjFkMElk?=
 =?utf-8?B?K1ZRdUI4TDZibld5aFNsWDhyUDVZbG5oc2duOGhyM2UxbEYvUWFQamw0V2p1?=
 =?utf-8?B?cFFBaGdPcy9TMHB6LzZyVXlpRWRVcEw1TWtmbHFlaXFnL1V3QjhMeEpVRnp3?=
 =?utf-8?B?R0RRWm95TUpySTRUaVVkN0ZHMjVWMjQ4T0JLeVkrb0dmS0JrUnpoczFpWkFJ?=
 =?utf-8?B?UUhnWGFjZGViNmlUS20yMDY0WU8zYzNlMTdja0N4ZDZqN3JHRmFzc2JucGM0?=
 =?utf-8?B?Nm91bnY5VHdZdHJ5NjJvQ05LcE9aTTNoczdKSlo4N1FtWnBOQ2RLc1RGWVpx?=
 =?utf-8?B?am5xT28rNnhLaXk4cUt0ZzJuMVFmNmpBbFVwVXdOOHZYcnBJb2phamFGRGw1?=
 =?utf-8?B?Qlh0ZVZXVUVibUYvOWVLNXk0Z2RieWxIbmZxY1k5MWFQT0hHZHJvc1d6aHJX?=
 =?utf-8?B?cUMwWUEyYmp6aHF0dEpFMklscEhFamJ0dGZ6Q1IzUnFZZXExakJTd1VpZlY2?=
 =?utf-8?B?eHNQNVRacXpJcGhkZHZqY3lHUXgzVjRPeUQxbndvN1NqTGpDaHRqVEZETHNm?=
 =?utf-8?B?WmlnSlNkY0ZjSDIvU0lYYVNlRElaRjJnQlM1K0JVcUZTaVlydGdHQy93amY5?=
 =?utf-8?B?bm9yb2QvZTNuaHoxWEhSZFEwaUU0K08yOU9haXM0dllmVFIyWWswekVLMW9X?=
 =?utf-8?B?NUx5WFo1ZFhRSzhiaTJGdENsWXB5Y1RzcENXZ2tjckhtdEVFbUd0MGk2eXlm?=
 =?utf-8?B?RlM4OE9KdkZDVXBqR1hXMklsNVkzemtkZVpLRnBwUGdUS25MWmdheFFRZ0Zz?=
 =?utf-8?B?UG05Rkhva2x2TXZwWW9NUlhHN1lZbFR6ektTOXFnUk5QQTNENTU0QVVtRWt2?=
 =?utf-8?B?WUlpR1dRaVNLSmRaeUtqanNJR2dXSnBJdHN5UHVxKzF4aWxrcDE4cG1qeXZX?=
 =?utf-8?B?NkhJWTVXUWJpOUo4UzBMT0hSY3ZGOG1IZnhWWmpyTFZOSGdJWkFSblhsSTdV?=
 =?utf-8?B?YXE5bm1RUHR1eFpsMG9pNjlQb0IzUXJlWEZueGI2ZTQ5UHl0RUEycXJTbGRi?=
 =?utf-8?B?MlNWeG1MaUJNM1hTWGVBM1JNUVpMS1lLK3pLVWlMSVNhaFg5WXhoZnl3S1dB?=
 =?utf-8?B?UGpBWlFxbFpKS3VoQ3hLTXc0OUY5V1FPTWRvVVBkMnZrU01PWEM1dnVncXdJ?=
 =?utf-8?B?a3FyRGxtL2hZeHFjNnBZOFVFV2VPdUtITHZxdWhPNXUraEZ2aUcvajloN1gx?=
 =?utf-8?B?T0tSMnBoT0FOS3NQcUNnbWIzM0VZZXdWKzNrRzFmR3NmcmFMcUY0SWorUCtl?=
 =?utf-8?B?NWZuQU1OdzZ4RVU5Y0JTMHo2bzNxamdVRFlsYkpLeHI0MFhlL3JvSUl3djV0?=
 =?utf-8?B?VkVVV2hMZXFUOEcraGpZMGtNbitTaHJsS2Q1VksxTEphR2RKYU9IbkFxNDVq?=
 =?utf-8?B?Rk9acGlZTHJVUDVzM21xKy81RDFJSzMySVZROHB5ZVcrMnk4NFI3YUVDNG93?=
 =?utf-8?B?Vmk0VGNSamZ3YU0wK09jU2ZreFByd1YyQUZWMFp4SUtadGRGQVJ1aWdua25z?=
 =?utf-8?B?K0RXTVVocVJKclNoQ0NrRlhIMHJUeEFUaDF0ZmNBR1dSTUFJdzNNSjg1OEZY?=
 =?utf-8?B?NFZYM0xnOU5UOHRWeFlENWJGS3ZUVHQvVzJiU29WSTB6ZDYxclU3RVFZZTdR?=
 =?utf-8?B?bTM5MDJNQzl2RUZaK042K0N5dDhVT1RZM3QwU1M1RnBmTjA5R3dPVC80d1NO?=
 =?utf-8?B?NkpVQ1RjaktFQWd5TmdYMVNmRHNZVVNlMWVRUVU5NEZxck92U1FmaUdEMzl6?=
 =?utf-8?B?OUNDdTk2Mk9wNXRDWDZscDdaajVrbUVRY2VEMDR3c3Fobzh5dkh4NHlZWVhx?=
 =?utf-8?B?QzEzdWdRTFVZWHJ0M0xzK3ZOWk90MkVJRzRXbGdRSHAvYlo4Yngva3QyY2Jj?=
 =?utf-8?B?VTNaSDVURWJ3NHNhbXVrK3kyTnhQdmJIaUIzQW9kWEgyN1pzUVdsNlVkV0xx?=
 =?utf-8?B?YVNIbmNOL1Z4Mm1TRnpiMUpmQzc1KzZDdml3VGRBR2ZoejAwdjU3Yitna2Nk?=
 =?utf-8?B?NzduZVdGYVdhRkRxcVlaWEJYUmlzSWxZbG92MG1ZMy9VWVJ1YnJmbGs4WDIy?=
 =?utf-8?B?aDlIL3JJamU2R1UrWVB3V3Bwamx1cVVrTlRKOEdTK0crbXZBbWgxaUloT0RS?=
 =?utf-8?B?c3k5UFNlRXlMMkpKekZlTW1MOEpVME1hazFBMUxHR3JUMkI4am5haXlQNGdJ?=
 =?utf-8?B?U0FGVjBDamJ4MENJa3JjRjNXU20wVlJYSFcxYkFaRjJVQzFIYnpkMTBtaXlU?=
 =?utf-8?B?L1RleUNQK3hxKzV5U2pvU0ROTEtkZThTUkhhQXMycjMwTVJUZUFUdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab19063-da01-4180-8f73-08df39aefa18
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:59.3813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swZPBNAhIUMeNO5xIi3fn7yIvII+y0SC+SBzYmdp8FZ6Eu3nrOmLbratTuADfTdAXVzi8rme/c0hMHem9dQRJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10838

Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue.

This controller requires S32N79-specific initialization prior to
UIC_LINKSTARTUP, including:
  - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
  - applying the vendor-defined M-PHY calibration sequence,
  - selecting the M-PHY rate series and applying the RX rate-select
    override before each switch to an HS power mode, and
  - clearing the DWC BUSTHRTL low-power gating enables (LP_PGE and
    LP_AH8_PGE) after each HCE enable, because power gating is not
    supported on this platform.

The M-PHY supports several boot modes for loading its firmware. Only the
mode where the firmware runs from the internal ROM is supported for now.

The connection setup done after link startup follows the Synopsys
recommended sequence for this HC/M-PHY integration.

UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE is set because the link_startup
PRE_CHANGE hook resets, re-initializes and re-calibrates the M-PHY. A
single DME_LINKSTARTUP is sufficient on this platform, and issuing it a
second time would needlessly repeat this sequence on an already
established link.

During system suspend the firmware removes power from the whole UFS
block, so neither the device nor the link state can be retained. Set
spm_lvl to UFS_PM_LVL_5 (device powered off, link off) so the core does a
full re-initialization on resume.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/Kconfig         |  12 +
 drivers/ufs/host/Makefile        |   1 +
 drivers/ufs/host/ufs-nxp-s32n7.c | 537 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |  10 +
 drivers/ufs/host/ufshci-dwc.h    |   6 +
 5 files changed, 566 insertions(+)
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
index 000000000000..3fe873bcd797
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,537 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
+/*
+ * Copyright 2026 NXP
+ *
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
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
+#define SCM_ONE_US_TICK			0x2C
+#define SCM_STATUS			0x30
+
+/* SCM_ONE_US_TICK Register. */
+#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
+
+/* SCM_STATUS (MPHY_RAM_CONFIG_STATUS in the RM) register fields. */
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
+/* The M-PHY sequences below program exactly two lanes per direction. */
+#define S32N7_NUM_LANES			2
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
+	/* Reset SCM_STATUS to its default value; keep the MPHY in reset. */
+	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
+
+	/*
+	 * The M-PHY firmware runs from the internal ROM:
+	 *  SCM_STATUS.SRAM_BYPASS = 1
+	 *  SCM_STATUS.SRAM_EXT_LD_DONE = 0
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
+	u32 data = 0;
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
+	if (data != CPORT_CONNECTED) {
+		dev_err(hba->dev, "CPort 0 not connected (state %u)\n", data);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
+					 enum ufs_notify_change_status status)
+{
+	int err;
+
+	if (status == PRE_CHANGE)
+		return ufs_s32n7_link_startup_pre_change(hba);
+
+	/* POST_CHANGE */
+	err = ufshcd_dwc_link_is_up(hba);
+	if (err) {
+		dev_err(hba->dev, "Link is not up.\n");
+		return err;
+	}
+
+	return ufs_s32n7_link_startup_post_change(hba);
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
+	if (hba->lanes_per_direction != S32N7_NUM_LANES)
+		return dev_err_probe(dev, -EINVAL,
+				     "unsupported lanes-per-direction %u (expected %u)\n",
+				     hba->lanes_per_direction, S32N7_NUM_LANES);
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
+static const struct dev_pm_ops ufs_s32n7_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	= pm_sleep_ptr(ufshcd_suspend_prepare),
+	.complete	= pm_sleep_ptr(ufshcd_resume_complete),
+};
+
+static struct platform_driver ufs_s32n7_driver = {
+	.probe = ufs_s32n7_probe,
+	.remove = ufshcd_pltfrm_remove,
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

