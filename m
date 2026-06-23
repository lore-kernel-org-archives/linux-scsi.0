Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D8A21A92F;
	Tue, 23 Jun 2026 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205534; cv=fail; b=OwZz2WbvCfxeF4cVZroRhItKj26y1Y15XpfgI1dKQFyO0su+MKX5GoL8HA93L6B07JsarRRw1jPfralxTJFecsvFSIVLCS3hTu0mQdLhndaYJlCd5nH2KAW+eRCWf7RzXTGIzrM/TgsyxYLm2IQhkDu2tkFlmDjfv5vI+eMnyLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205534; c=relaxed/simple;
	bh=oTkqJwA3sru2BMKUaCUSH/lX/gv5HmXV9vMe7gcYfIM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lvskXEn/oJzemnHm+PXGJizuidPeyzVODAiYPPf2k0wk4i+CtZAnG3L8f2Zuppfbr3qCORItTrhx2LbPOiAPQvQ6MEqQ2XwV5jnU/C/+r3wEqMRWgry359Y7XaAjjbr52vXIilm42782fv3bfGPeTotcPafANwB/qoUlXuzW7u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nSKg32Po; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=F6w6qv0c; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nSKg32Po";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="F6w6qv0c"
X-UUID: a8c375c06ee211f18dc8c9802ae25ab1-20260623
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=oTkqJwA3sru2BMKUaCUSH/lX/gv5HmXV9vMe7gcYfIM=;
	b=nSKg32Po7078xOADA41GOkvLbnwJ/gUQUX5UJEMnWzKKwnq7mmREix7jfIMywLHG+iff5wK3Vg2lNaQgJQitG+3MI0+qg4Wf0Bl8co6G5AG3XVjvL9vNjHTJ8iRZPx/rBb2Y8q/tsMCRHu7Q19I2sKTAPCwPPM5FyCCYjMhgeOQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:eb1496cf-ffb1-4d50-8b98-8fb1b1c18065,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:5ee93299-95e5-4675-922b-bef7ef5635f8,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a8c375c06ee211f18dc8c9802ae25ab1-20260623
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 884916797; Tue, 23 Jun 2026 17:05:19 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 23 Jun 2026 17:05:18 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 23 Jun 2026 17:05:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lGmrIXO0Fu8YK+PsAAWp5qDIdxc4dV0AVzkLMsAvl6yZDx+IIeQTKKtHv+OWZ8Ewq8cPXWsFUIIMcdC7XgNDhUU9OM8jTlRr61Nv0UiQbMOu1r11w+xZWxm+q53FdxUOSPfU/ivWAJhizv40hx+GpAgdHpCkmuzSedzR2aDxFjfy65TrcYzShLpxkpZ409XKaOvGJ27C07BA6ch/jSbzb8GEl8ybORPnHTqTdxd4iMDAktccHkLMu7aW2DpHG+b2+pTHDktbUfU4anXljE7bO2YNi2EBNZSHTF8LLg+psOOUBORv46RgFQ7U4Boi71Trj2RyVlKIzT5eTbcM5xLSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTkqJwA3sru2BMKUaCUSH/lX/gv5HmXV9vMe7gcYfIM=;
 b=VQsXGPm7jr0Yvkx4rZcYqn+LEOs+SUyywQnHXm3P47jogOrbbTG5HZFf31WyMzQUE2LG75mSuq1Oy6xFe0bsFEwDw0R5bN5yFmD6DJzlm7BJnSRYfeIkNJWEGYYScaIWxAVFkTpy743SeIqZy5qR8PowD8omTuykifVwbaSzRU93mO2FbzgpFq+JhdHrwyXug2dJvAnByxW6tR2IMn6BX9/xXpvft1Rg+3OFgCvQxBMl5re4u5wjsoUageJawexe5/3oQO4eeOEhYfeleKblr8T0D6lVcvTNDX0yeUGf0gNzvxaj28aEvtl64uYPHd35zUCyzgwVcdWLGvQmw7DRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTkqJwA3sru2BMKUaCUSH/lX/gv5HmXV9vMe7gcYfIM=;
 b=F6w6qv0cV11IqzcKaeXy3ILGoV9r1ClLH2ekiAni8F/XwG7Br0sYBzlFAHuwj4e4gIy05HDGcEk+Ncpi8fQcZqFFCYRqYlyQITYjTNCgiC+CTEvjJK4ByYNscGqS8edN7p5h19D4LmztdKaftI1jDD/WukpDi/969b9Rn8ok/8w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6730.apcprd03.prod.outlook.com (2603:1096:4:1d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 09:05:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0159.007; Tue, 23 Jun 2026
 09:05:14 +0000
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
Subject: Re: [PATCH 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX
 EQTR
Thread-Topic: [PATCH 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX
 EQTR
Thread-Index: AQHdAItwR/Nxo0lEbE+ajLPB+rv+ELZL3bWA
Date: Tue, 23 Jun 2026 09:05:13 +0000
Message-ID: <bd4c01727a6a3f0b4d1cb716caa35662fae7d41a.camel@mediatek.com>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
	 <20260620080322.3765210-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260620080322.3765210-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6730:EE_
x-ms-office365-filtering-correlation-id: 3489a32b-4d2e-4b74-2cd7-08ded106897c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: TTPAw0wURn8DsEJ5pTTbhtSpyonfKbK7tdb7cq4j7+U7RKiZNrsBbkBlSexBzwKTBqa4e2ky/CbUNdxJson8kFjTjV+eHROEgIPeiGyR5GUMbxeT2+c/ROCJ1M/GCmLnuGVMuc+FvjmylKH8JtwRM4chiPsxCztAA9IHVOwjhuRmqTsD11qbOvnbQjewzmvvq9IKfFkR0DtQMYR8gQhUIHsEC3qSFiEHWzTO6sl5JbHvA5J7fuAZFRm84zbUpbbbuzcbd6RXXFaAVXURbwY96Y14PExlAHztu+fG/K9KBSFxaNi0sq3uz/HK+r2kdMvvGyoATGegNEBgx4jzFT1LoGUZk+BhNiWjApqF4Dh7IH/pBscfjfrrbqcUSX3z0XVkVv99U62ZOhJdVj0NrLCc8ocOXfre+mOZBS5d5oCDcjw5StXZ8I2i9NlmWRutKgWkPSb4ePzan/YbIZfQrPkRflgQkAWhyFn1lJou8x7k7I+jkN3hZSRvzPw5o3xy5kr/m4NRzuupo/zNOqhV9AcaL6uoqs592CuaiSMT6arXHQyDRpGcKKh3bk3jMiGmB3jB4obyhmHWZXgXXE6h9PLT1w8CmYMtavBoBkht2Fi/Tee4asZ5fRdFvLwvLgrw3fiuxpk24756sMYaaf7gJCPSUA+NcjIvIMY1vqpJeaCZUxqTcy2hPw58ZLAeD/9A89GWAaMxSeQNFz/tFrjaNvUkRiVM5W+uposNkplvtQm8HAk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnBpZGZtM1dmT1JSREM4aTdBRllzSWRuMkdUcnlSMHF3c01abXZzMzdyRG9X?=
 =?utf-8?B?Z1JSQnVmY2FnRnFrYmRteFUvSDUzN2VQRXpQRHgxNG94Umh3RHBVdk5JLzFE?=
 =?utf-8?B?aVNNTEZkdk80WjcwMmxsVXZqVkExZGdERVJaaWgzTm1HenRFdS9laS91ZG10?=
 =?utf-8?B?R1hkK3VKZG9OVHZkWHo2Ymc5RTdtS1VFbDM4M3h3UkZWR3RadVZzWlFhbVpT?=
 =?utf-8?B?VHFPSThZWVZmd080bGljRGh3VFJ1ektZWUtscXg0TGpwR1hpeTlEM0oweFFH?=
 =?utf-8?B?bmtCSzFtNzJSRFpFT1FxWXNQV1BweEhqZHJlRElRcDFaSGE4N2tZcDBOVTQ3?=
 =?utf-8?B?SFprKzRCbXFWeEVtUlZzVndrbitKcUw0VnZhWThXTXg4YnBxME42Y09HRGRC?=
 =?utf-8?B?cEc4bEhZRmF4QlFjam5zT0NLSGQ4RmtsNHZiUVVnQlQweHRoTE1zYlpaZklY?=
 =?utf-8?B?R0hPb3NIT0IxQXRNaWRIWDhzUUx2VC9vSHIxeXMxNFpMc3pYa2hIaFBDZGE2?=
 =?utf-8?B?bmo5eWsvRTNoWW0rQklYQzlXdTZZRS9pdHE4aEg4QXZXNU00aWV0VWlpVmJi?=
 =?utf-8?B?bW04aFdENURUd09FWFdDcUZ3MDN1S3g4S2JZT0VxNTN0YWVmQndZQmNOU0Nx?=
 =?utf-8?B?NThqQjREZHYwM1BDemdrUHNzeVQ4ZXVGNjNpVWNTSnYxeS9Xc1RveThuazZs?=
 =?utf-8?B?d28yQ3lJb1JVUjl1R0JqUGNCRFAyMTkvMU9xN211emFyeVNLTWhlL2REUTZI?=
 =?utf-8?B?V2s3ajVjR2FuVjhqS0dxSmx2TEtodFRnNmJDMWd2em44WHdxTm4zQVE5WjJY?=
 =?utf-8?B?Rk1DdkdlWHZncUJodnpWZWQvdlo3d0FlSFNqOU1GTkZYdFBrZ2o0blNDbGVR?=
 =?utf-8?B?TmZUemRJcGZXbnZzVHRGd0YxdXZMVk1DY2laNnZJeUFDcVRPcmxwVVdFeVJx?=
 =?utf-8?B?c1JEdUN5eE1ndFRWTnpMK3drcE9hVmp6bUY4Z1RMVXgwSThEOGl5L2NqUUxo?=
 =?utf-8?B?MC9PNEJIbkxSanh3T0RQcE11ajhOUFlCcklnVEFUbnk2QUt6K3lsOFRrY3V4?=
 =?utf-8?B?bHlwZWRxMlRnaXZCMldsZ2lOZXNOUnVDOURVVzJaOS9JS0pTa0RPcjJNUDln?=
 =?utf-8?B?Vm5GYlM4aTA5THZEdVZxR1E1TXpRUVdvM0NQYUNPbGNTbmJDNXl4K2Vrb0pC?=
 =?utf-8?B?TlJwY3lUTllJT3JVbFd3VE1USTZncVZmSXd2Ynh0bnVYUHJucGlreGpJb0JD?=
 =?utf-8?B?OE1Wdm1FUy9OVGRZVW9LL0RDd2tmT1FFUkl5SXJiUXFvdUNHbTJSQ2gxc0w3?=
 =?utf-8?B?b29EbkdWN2lUNnNHTGN6L2ZuR2tPN05jaFJqNWwyZzl3dlRTR2RzUWMwZlpV?=
 =?utf-8?B?ZzlDQ3N4VDF5YmdmdzJOMDNaTjcrTnBTV1RrVG1TL2krbU05cWlaSkhuUXda?=
 =?utf-8?B?OTh5SnAvK1IzT0Z2TWJnelNuNC9vdytqR2VyZjVzUHhGV0EySmk2WWltdkZy?=
 =?utf-8?B?QlJ2ZDNUOFJobXRxYkpqS2lRS21CbWJBK3FXWTlzTUtPSWJKWlJqM1pGclp5?=
 =?utf-8?B?ZS9INEF3cEJCc1FhM0xPSmpCK3pzYnFaQjlOQ200UUxiM0ViRnUzc3VwTU43?=
 =?utf-8?B?N0FNY1I4MzBPcWRqQ2hWMCtYUitiVWV5Wllrd0t1NVVCNUZERG05ODlsaVpL?=
 =?utf-8?B?YjQvR0UwTGRicVJDYWsvZ2dKcnBYNnErOGd0WDdXNml4MVdrbDJJcE1EUDVx?=
 =?utf-8?B?OUh5N3dlT0NnYW9SY3N0QmlXckxuZ0VMRFBKcWRubEQycHpSWGJCLzlvcHZu?=
 =?utf-8?B?Qm42L0RVTGRjc2dheDMzVUVBMTVXYTFSL1JvdjcwNDgyZnVCTDFnR3BwZmxW?=
 =?utf-8?B?QUlJOGY2ZTZCb25mZTl3V1ZoVHVsMFh3eDRjbEdKR3FBRE0zUUxtWFp0Z2hF?=
 =?utf-8?B?VUFZWUVDZGEyVXRyL1REVmtvcXhzYmtNVmNVQVF1aTFVMHN3eUU2N3ZlT0FO?=
 =?utf-8?B?TVh5OEdHdldxdmVZTlF6d2piM0t5YWo2MUJaSmlNaXYxaEFNZ0g3QUQ2aSsz?=
 =?utf-8?B?SzdUVjdrc0xJbVlhRFNKVExnQnJ0S1FqaHZWZ2NEV0FDeS9UU3lUZ3VibGJj?=
 =?utf-8?B?b0tidlIxcDkxZ0Q2T0xtTmdjZ3YrZU5DOUh4dVdaWmM2QkJpOFY0Skh6TGVx?=
 =?utf-8?B?YXl0L2tZMWpvczFrT3N0UnFWdFVZMWVCVnVpUDBQUkh0dUpVNWgvZXphOHRh?=
 =?utf-8?B?aDBCcVZYWFFFV2FCR0hRdVJub3J6TEZoK2xwZGV1Z0pxSXhUY1pZM3NqZDV4?=
 =?utf-8?B?bmgxWWhkbXkzQVNxR2ZZeFVNNWgvcUYvQWpnY3lhcEFtRkt4RFhrbGlpOUh2?=
 =?utf-8?Q?vtAVp0c92wAP0jTQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0B283E2426CB54097E16AE61B5331A0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: LUcSpvNaleUirMLUHc3cMgL3WPjQ5PQ+2xCRUMXhjpo6jBz7JuZhvPWL8eLXNE4zZHHdlwArkge+QYCjpJ7T6pL05QcQwZSwbMlJSxZiVw4CLOJkNxk/aS5SqeTx3hn4mXucW+uJahxixJQQ5PJDEuRGXoK+0nq4LoESYjEs+3NWOPildOlwCNZkumvRvys0+n6yiL/o2RAeTtv1iJN0+F1iG9x3baG+F0nZSSgCzOdu5YgtmNLeKrOpPCkJf3LMQ5QOluTdXrykYh9nPWlCkxm+ZosHuAj1tbxWM35nStikOPxsARp8GdRAjZyoQeDqNAr9mYX6fj5ISWX+LA+b5w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3489a32b-4d2e-4b74-2cd7-08ded106897c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 09:05:13.9683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v1Mq4LaG1i9YyBATMuQ6cDGeSZbDmIgC/GUTgrHZ+KP17KMrrHLzlAtYEGqFMSuM26OvyRhkeeKekBGx619p5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6730
X-MTK: N

T24gU2F0LCAyMDI2LTA2LTIwIGF0IDAxOjAzIC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+IEBAIC00
OTQsMjIgKzQ5NiwzMCBAQCBzdGF0aWMgaW50IHVmc2hjZF9nZXRfcnhfZm9tKHN0cnVjdCB1ZnNf
aGJhCj4gKmhiYSwKPiAKPiDCoMKgwqDCoMKgwqDCoCAvKiBHZXQgRk9NIG9mIGhvc3QncyBUWCBs
YW5lcyBmcm9tIGRldmljZSdzIFJYX0ZPTS4gKi8KPiDCoMKgwqDCoMKgwqDCoCBmb3IgKGxhbmUg
PSAwOyBsYW5lIDwgcHdyX21vZGUtPmxhbmVfdHg7IGxhbmUrKykgewo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGhfaXRlci0+Zm9tW2xhbmVdID0gMDsKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0ID0gdWZzaGNkX2RtZV9wZWVyX2dldChoYmEsCj4gVUlDX0FSR19N
SUJfU0VMKFJYX0ZPTSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gVUlDX0FSR19NUEhZ
X1JYX0dFTl9TRUxfSU5ERVgobGFuZSkpLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmZv
bSk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9kYmcoaGJhLT5kZXYsICJGYWlsZWQgdG8gZ2V0
IEZPTSBmb3IgSG9zdAo+IFRYIExhbmUgJWQ6ICVkXG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGFuZSwgcmV0KTsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+IAoKSGkgQ2FuLAoKSSBzdWdnZXN0IHNl
dHRpbmcgaF9pdGVyLT5mb21bbGFuZV0gPSAwIHdoZW4gYW4gZXJyb3Igb2NjdXJzLCAKYXMgdGhp
cyBhcHByb2FjaCBpcyBjbGVhcmVyIGFuZCBpbXByb3ZlcyBjb2RlIGVmZmljaWVuY3ksIApmb3Ig
ZXhhbXBsZToKaWYgKHJldCkgewogICAgaF9pdGVyLT5mb21bbGFuZV0gPSAwOwogICAgLi4uCiAg
ICBjb250aW51ZTsKfQoKCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGhfaXRlci0+
Zm9tW2xhbmVdID0gKHU4KWZvbTsKPiDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gwqDCoMKgwqDCoMKg
wqAgLyogR2V0IEZPTSBvZiBkZXZpY2UncyBUWCBsYW5lcyBmcm9tIGhvc3QncyBSWF9GT00uICov
Cj4gwqDCoMKgwqDCoMKgwqAgZm9yIChsYW5lID0gMDsgbGFuZSA8IHB3cl9tb2RlLT5sYW5lX3J4
OyBsYW5lKyspIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkX2l0ZXItPmZvbVts
YW5lXSA9IDA7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHVmc2hjZF9k
bWVfZ2V0KGhiYSwgVUlDX0FSR19NSUJfU0VMKFJYX0ZPTSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAKPiBV
SUNfQVJHX01QSFlfUlhfR0VOX1NFTF9JTkRFWChsYW5lKSksCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICZm
b20pOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZGJnKGhiYS0+ZGV2LCAiRmFpbGVkIHRvIGdl
dCBGT00gZm9yCj4gRGV2aWNlIFRYIExhbmUgJWQ6ICVkXG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGFuZSwgcmV0KTsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+IAoKVGhlIHNhbWUgYXBwbGllcyBh
cyBhYm92ZS4KClRoYW5rcwpQZXRlcgo=
