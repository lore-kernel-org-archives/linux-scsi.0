Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026493DC85B;
	Fri, 26 Jun 2026 09:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782464674; cv=fail; b=LP6jknAVtWFtJe7frUt+jsQZ20FDFuZNg6+SprGsTEmIJBWEVJjjJAVlviWyCtEXFTjyx0xms2L7iUSdkCrhq7Jl//EWemJ8eGDa+5GpscEA14dJbdSDQA8omC5Y8ZTvJjF2RfDtIMLL9gY2BrDn0xMZSzToit4/5eQcgfymmH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782464674; c=relaxed/simple;
	bh=NknNx9+NlYzYFa0FyKD68gmJKNPdh3/kZ5iTqbbBkig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eSarPJ9+N9V2OjqDeOXP02m/9zOqGyQIteMa2X1D4ACw64Z4+iKa82X+HGh7xzHlZIY1i9Q4OG3hnQi7+rsSdpB3mYYbi/ouwNHbw+uuvoX5tLDk2GUJQBgN7Bi0gnJIr5ISCbGtU5yWGJinJJyhjhCuYld/KMYqBpUfdgWP5uY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VmixhLMP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CjPX7QEV; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VmixhLMP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CjPX7QEV"
X-UUID: 050a4194713e11f18dc8c9802ae25ab1-20260626
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NknNx9+NlYzYFa0FyKD68gmJKNPdh3/kZ5iTqbbBkig=;
	b=VmixhLMPTR4GVaIE9rO4TSlvQT3qZ7kc3M09BfpwYUoFj0LDm0GxgqRRfyYgL8e9mmXmPbBKt5jAZdDInYRkfNLFcIbHRvUYFNxrwebtUrkzb3NqEVmOeyf+/+F7PfNtI3edtBBHY8pRA12uGRjkpxPy2WTQclgSmVN1wDbpvT4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:a16d93af-5c7d-432b-9f26-5612e24fbf90,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:daee96da-5eb1-42d4-aa37-265f0625e786,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 050a4194713e11f18dc8c9802ae25ab1-20260626
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1717163252; Fri, 26 Jun 2026 17:04:21 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 26 Jun 2026 17:04:20 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 26 Jun 2026 17:04:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzF2XvceGAbJF7Guw+/L7ZW8L66cvYS9qL3jPm7sRJb+npA+YbjffXDHVXdLdjZhuY4XYAfuQtbgZ/3RFu+KqfMGf8AzXaRQBR3Sl7X/Y/6tC2KrhBcSYy2jmZjWNDzeAy3BCs8dwoPJzoUmKuySOePD/JbPmW7n5XamdleC2nr64N5x8zdgMk49TEGwrVcaXX931PNFRAHE+KfG1Bt3x/fPZy7bH1lpXKsBSLCjDoqVb5MyOo0eQHeZ+2pxgWEOqNXnd6G3JYaMSFMNFUNLuNOCh2aEaRTX/u2sGHCbNn5/upfxkoNH9d4NuT1l/+Fa0GMIF3K7pEPC3pArt56xeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NknNx9+NlYzYFa0FyKD68gmJKNPdh3/kZ5iTqbbBkig=;
 b=yzD0y9Psxv9FQ+cd41e8pfBahC8E/huse29XziA+cesiCu6Z2SeAVZnr+0yrbaEyPFeT7ImoehxvIbgTm52Rt1M5CoyfsjlwfVnFCHxaATz63cIy7v6QqK/OO1/poF5uXWuMTS51RsNeFhZap2twp2FzVJ75mgf7V9lZpKN+UHEebjwsDjvp+AOSJz6NHXS/CWmcJBuKM0KYN6K7tlUM+o9lOTqgA02zWqgxBfRL/SQoM8CwfJN3I3KyPLNC3RfUVI/HjrnPvv2/8zMonj08tEGRa+Xi18IF1058WlL1tv2Vrlhbr8vHC2q6s9jWPTEbrpE7xGT5MeFHiQ83jtKbXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NknNx9+NlYzYFa0FyKD68gmJKNPdh3/kZ5iTqbbBkig=;
 b=CjPX7QEVCc754z/zaxep9UxS7Eo/WFZ65EH3AAsUwVbHoTvCl4MS6buQtw2Sy9F/ymgwbHdg3cPRHvxhvOMDerrrlKk1JgAfdp9JByxOqZ4Jslt1ZalU+nynxM24EMe/VBcPWsiC5UFmnxnOQyUvKW6kbTY9a+doeDu88UQ87fo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY2PPF55FE3F4B5.apcprd03.prod.outlook.com (2603:1096:408::9d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Fri, 26 Jun
 2026 09:04:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0181.006; Fri, 26 Jun 2026
 09:04:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in
 TX EQTR
Thread-Topic: [PATCH v2 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in
 TX EQTR
Thread-Index: AQHdBJwlWuEGVmAwG0efwTNHkeytH7ZQjE2A
Date: Fri, 26 Jun 2026 09:04:16 +0000
Message-ID: <c70e1c5f62e61175171ce3801f56600f2b0afb4c.camel@mediatek.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
	 <20260625121306.1655467-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260625121306.1655467-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY2PPF55FE3F4B5:EE_
x-ms-office365-filtering-correlation-id: cd8dddbd-81b9-4a6c-5c45-08ded361e69f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|4143699003|11063799006|22082099003|18002099003|56012099006|38070700021;
x-microsoft-antispam-message-info: UnLFX6nDu1DEE044QS+U/4fCANVFoSlQC/3KpBtiBzL1K3cdBj84Voq/nrB771y2cyxp6yCW9sZLQtM0vusAO29d7G0pB9PLSrSMjmHc1/DgsJkQmNj+YWb3mBMUaBUe9pZxYjVDsl2WNgW7eIMTi4WF+H4OQii5Mlc9E0Pxl699JUq9n5Hd3jNbo1wpFHKFbbOUsKfX4rB59C8ABdxUSPNbyhFsYTjChPdR/FNOFF2ftPZOCM7l09Y6joKacDYfqhvIFZko9oOWoFhv2eOCDj1Ah8CR7RpzEAEE7iHjoVh/jO6foBDdcDHLwE5Vf5QaCBRXrVc+XrLYRkHxYeOUR68jcfuSBKjXJoTgF+9igPgVnVxujmvtjmH6HA1j1hqEbfwTgYUinDGrBm947b1qxNNlinpVqt+80q07kMR4dpcEan69rSHv5ltheN2xi6qda2y4r2+2SXXd26hRBwrKFcFRjoRjVChvl3LFtue4LlZAUaYvNdWfWakwr6OsF+RTDHdnRswRQWcTRhrOIHxviTQPwLXieFr2bhw78CuNTcllsrgkTHw5Kr8Q5lRa+3j6ZYO7jSrlBRQfOtxw9vBk7m70JDmmBR9HYwXjmjr843Ml4iOUw3E+78t36WG1/NlFPNdNgLM68T2xvr2OtL171GyYik/WV1xxOMLMUUO1A1pEZus9pRFMqYFZ4nuXBbwHXAN2OlLXA1G3XCUr7FEcQJckYGF9IS8V3D955hrg/Co=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(4143699003)(11063799006)(22082099003)(18002099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak4rZ0dvVkIxVlAvZmJ3Z1NIdCszNm1pYmhidjc0WFF4L2NvUElOZGcyNnhR?=
 =?utf-8?B?a0RKOTc0SlpNeEpSVUpuWEpjNHJyNk1WVi95NUJMZUxTT0pBbkg2dVFWQkpF?=
 =?utf-8?B?amxHcG5CdzBPZzlIajFYVkZPU2NHZUZjUnIxanpGTkxidUxSaUszOVNyekhU?=
 =?utf-8?B?L2Jlb2NiQlhHbGdpTkY4akEzYVJJcHRZb2RTWW13RVBhbWpQMlJLRDhSZlVT?=
 =?utf-8?B?a3k1T3FpZkV4cVZZV1FWakMwZXUrRFc0RXljZmsrdjRZMjBDR3FWNEpBRGdG?=
 =?utf-8?B?MzVWUUdYTmlRR1k5TGh5VU5OYTdCZWZYZ0UzemY0QzZTaE1ZVHRSSHlEK05P?=
 =?utf-8?B?RnpyU2xabnJHZlRkbEh1VFRsTXZqTGVjZDZGaEQwMXMvOTFkK2dpOTQwaFJ3?=
 =?utf-8?B?TDVjbFBkdmJNK2NxSy90QzQyNFpGalBlODkwNVRFTjAya3I4YTVHTzkwNG9m?=
 =?utf-8?B?SXhueFltL0FsV0RwbE9Da3ZrQ2Q2N3NVSDAvRmZ1Q05kVk45U0ErTnZuL2NW?=
 =?utf-8?B?bU42QUZrUFNZc2c3R05NbVhSTk1sSVEzNmVuUTlLa3dGNFdPV044WlY3VnV2?=
 =?utf-8?B?dm5YcHkvUU5FeEVWWUovODFuRktaT2pGeGdsU0JQMVVkVTM0Um5remxEVXR5?=
 =?utf-8?B?T1Bad3dmWDl3WVJPb2tWWUNYM3hUWitqVEk2OEE0V2NOakF0Sy91K01uMlNB?=
 =?utf-8?B?R2dJWmkvck5Da1VqUThVaHZNcUxJY3hZMHZneHhoanNDUEpWamsyVE9vZmpi?=
 =?utf-8?B?eURFb0srbTl3aGlwbnU0MkxTUk4wRlBVUzF4L041R2g1REVpeU9ZR016MWg4?=
 =?utf-8?B?NVFYSnlHZUphQmVzamNsVEZPTDEzV0p5ZFE0bW5EUzQwTUtBSkxqNG5LOVRy?=
 =?utf-8?B?SkpDbWFKS1M1bmtyMUR4aUJOQ3VMSXh0TGRPN0dPT290cGtuc3FGSHZYR0hh?=
 =?utf-8?B?VU1jcEFXQ3ptdkMvQzMyaVQrNlFGWTNnNzc0VzAwYlhlQjB3eFloMVVLdzE3?=
 =?utf-8?B?K0hUVEV6S0ltRUxwYWN4Q2UzSDFFSkxwQnFNVkVzT1Z2Mnd3eU8wN2ZOdDZa?=
 =?utf-8?B?dXE3YmlaWTdFeFM5MkxDcklaUWh3aXlGZTJsTFJ3VHpmS1FzS0NQYkl4RmdW?=
 =?utf-8?B?M25CelM2VDhURFhZYmMvZU9yc1pSWHUySE10YzhpZElDb1ZIbnpFeUN0NVFM?=
 =?utf-8?B?R1VMQXBGQmt1Y0tFbHFibE0yczU4dk5nRExSczU3eDkxc1NkQ25BNG13Mkkv?=
 =?utf-8?B?UkJjZXdBQ2hQZGpab2t0OFJkZjU3ODlLUDdPdFNkc01yY1pBbEx4OUpCcmo4?=
 =?utf-8?B?MVFRZ21SS3VSeWhEQUx6NjJHVkRIZ0pIMElVdTE1UEJNN3NNTW1ycE1ZZ2pz?=
 =?utf-8?B?WG03Y2JNU3hsRjFrZlpheC9wQUxxemdMTFY2bkprYW92ZVJ0eDNZcFdPbWl6?=
 =?utf-8?B?endMeHBwRlZFRGhBZ2t5Q0RaaUNobmZZeVQxNDhKK3F5TGJUanQzMU9mbWNR?=
 =?utf-8?B?MDNKa21SRTFEWExQdUhHbE5LQkJBbk9PQ1l0NHBZZVozMENxQm1vM0hyQjll?=
 =?utf-8?B?QXI4NUcvcnYxK0xsd2lzNlZGb1dPL3VTdzBLNmNrbUZ2clBialFROExFd296?=
 =?utf-8?B?L3JBT2lIMEFnbWFpelhxekgvamY4Qno2dkVvQktHYVFKMGV4L3ZHZ0hxTmZm?=
 =?utf-8?B?Z2RyMGdUUFR1aFNVREkrYTh2WkdLb0V4c0JmbC9FTXkxaWl1NHNyODJ1K2xE?=
 =?utf-8?B?WHgwczd2UHc4TitZY2ZyYWZDM0tGMWg4a2czQnE1dDhKbGc5VHdzK0Z0b2JS?=
 =?utf-8?B?WjhHOFBEeUUrek1aUGFvMmh2M01IbHhaZitxRUlwWHc1eDJlemdmL1BIcE9l?=
 =?utf-8?B?VGs2OTZPa1NhTGNWZWo2MTVvYmFnVHpJSkxWMjZHbTdGUmZGelNwVFhZTU9V?=
 =?utf-8?B?UnlGb0tmeUFEcmR2V0lhRzV1NVcwdzY2bG9VMk1SNi8rK1krNUk4amdWZ00r?=
 =?utf-8?B?Zi8xZHFHeWdKWWhITnZNaytSY05QR1RacUlOK2VZZGxVMVhNcTZheU42aXl5?=
 =?utf-8?B?Snl0QTBwdDgvQlRNZGxZWk8wY3dBbWltV3pRZUE2MlFRTjVnbGJGb0dOSUVS?=
 =?utf-8?B?RmhwS1JGSWpBSXRaSndJUUNvS0UvNG9RL3Q4WGJoZ29mSTRFQUdVNGRYUzNT?=
 =?utf-8?B?WGt1aml5Q2hnb3FXaktUVTR5ZDkvZnBiNnVnSWhxRmlHWGFyV3NzSVp6aStq?=
 =?utf-8?B?Z0pOQkxaQXBBT0ozeTFuRGlzQlBocFhSalE4dDhIYzR4VDduUmNNOEg5eWNj?=
 =?utf-8?B?SEpCMkU2ak1DZGZXTmZ5ZGhCRUw0aE9RZ1ZiQ0dlMW5QeDVDc09WYzVnZkRk?=
 =?utf-8?Q?RIexc11EKcGujH4U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <500160F75ABD2E4994A77DFC25DB2911@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: oXAG/ppReeH9ZKcl70SruqZxkXCxzLkh9tkQQZj86s/qiKshwBpCVImxtwxGAkTSn2lTO/tdEcmJ0uzueWSTY9NpIPwIrfWieKcWem8UDhTnxZJYlVpm4uNn/H8KGRoRtzXfy3D2JVYFfvPQo8czWR6jFcAyH+1tipsjZ4qDsKR50e8ztpJ4H//xsKUBBvQvjA8nlklWHCeE2mloDPAPtwhgHs+LowGBHW0RuB/YRXluujFgI95GtQ9COBrCehqzK+gqxN/5LX2YTeAW7sooAvM+vKwX1B2kRLa7iwwpPUv/ihUsc0VOpkoAjrErxe+xgTsiRu2ojpJzkW2awbsMxQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8dddbd-81b9-4a6c-5c45-08ded361e69f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2026 09:04:16.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BADH4r7z1ffuP+mQTC+Ig0epATjjPgN+eyzPzkfAQJTYSM+KMFXRC6txHb8GEJeVatfaEuGZqB0QXdH7agx/pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF55FE3F4B5
X-MTK: N

T24gVGh1LCAyMDI2LTA2LTI1IGF0IDA1OjEzIC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiB1ZnNo
Y2RfZ2V0X3J4X2ZvbSgpIGFib3J0ZWQgVFggRVFUUiB3aGVuIGEgcGVyLWxhbmUgUlhfRk9NIERN
RSByZWFkDQo+IGZhaWxlZC4NCj4gVGhhdCBtYWtlcyB0aGUgd2hvbGUgdHJhaW5pbmcgZmxvdyBm
cmFnaWxlIGV2ZW4gdGhvdWdoIHRoZXNlIHJlYWRzDQo+IGNhbiBiZQ0KPiB0cmVhdGVkIGFzIGJl
c3QgZWZmb3J0Lg0KPiANCj4gS2VlcCBUWCBFUVRSIHJ1bm5pbmcgYnkgbG9nZ2luZyBSWF9GT00g
cmVhZCBmYWlsdXJlcyBhbmQgY29udGludWluZy4NCj4gTWFrZSBmYWlsZWQgbGFuZXMgZGV0ZXJt
aW5pc3RpYyBieSBpbml0aWFsaXppbmcgZWFjaCBsYW5lIEZPTSB0byAwDQo+IGJlZm9yZQ0KPiBy
ZWFkaW5nIGFuZCBvbmx5IHVwZGF0aW5nIGl0IHdoZW4gdGhlIERNRSByZWFkIHN1Y2NlZWRzLiBU
aGlzIGF2b2lkcw0KPiBwcm9wYWdhdGluZyBzdGFsZSBvciB1bmluaXRpYWxpemVkIHZhbHVlcyBp
bnRvIEVRVFIgZXZhbHVhdGlvbi4NCj4gDQo+IEFsc28gdXBkYXRlIHRoZSBrZXJuZWxkb2MgcmV0
dXJuIGRlc2NyaXB0aW9uIHRvIG1hdGNoIGJlaGF2aW9yOg0KPiBSWF9GT00NCj4gRE1FIHJlYWQg
ZmFpbHVyZXMgYXJlIGhhbmRsZWQgYXMgd2FybmluZ3MsIHdoaWxlIGdldF9yeF9mb20oKSB2b3Bz
DQo+IGZhaWx1cmVzIGFyZSBzdGlsbCBwcm9wYWdhdGVkIHRvIHRoZSBjYWxsZXIuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5xdWFsY29tbS5jb20+DQoNClJldmll
d2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
