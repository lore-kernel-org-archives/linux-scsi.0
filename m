Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EE53254A3;
	Tue,  6 Jan 2026 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767705850; cv=fail; b=ndm1ZJ7m1c1UWl4gZ7d1MPnddbH5b5GQfNL7J2EULgIRGUuhw6Hph/AMZsTFLGPTZ1p9upztBAWMCaZz6illNLbL1DWP7HJDxv9l6GdrCm4g/AIGsR2xGgWEPXQCXGg+TUhl7izF+VvJSRT2HGBkhR9mdffgQy+MkTIldzbQgN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767705850; c=relaxed/simple;
	bh=Oo033lm1ycAPbD3gPRFbqjnH8PxxmWVwrzOcHslgZWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZnFZIhum2gj7fg2mVB+O0tfYwFTWoBRPJYEJuei8gZCKjNzUaIPId56xXndGTecRBVqW4zzkleBQxjKALPhqU4l6VSbrHgoRBGiTuzn3ObJqpOxmorHSuDKqcyMaYfb1Uyuv3GuLl1ZpnwSjxgzpjkkcCoFqJn00La2aUIDdVh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=K1QGO+yE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=APklaBQd; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K1QGO+yE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="APklaBQd"
X-UUID: f7dfede6eb0211f0942a039f3f28ce95-20260106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Oo033lm1ycAPbD3gPRFbqjnH8PxxmWVwrzOcHslgZWc=;
	b=K1QGO+yECDuBFjBWLgpjK00qn5EElVXDhInqlsPQI2H2W2pk12LkxUnezNSsWe4zIeGfnBOSRVAXR9SGzC4VSVnT/q4t5YKeUZv5BRMKg45Z1hQtOKOPYlunzH5bsfcKSCzaXGUlRd/GuB/xAnqXaeZZEwy9EsMuJDCVyiAt9rk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:635d4b1e-1779-45a6-9271-5a926529a78e,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:5047765,CLOUDID:22cd261c-569f-4a0f-9948-b21a1d8a5571,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|110|111|836|888|898,TC:
	-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f7dfede6eb0211f0942a039f3f28ce95-20260106
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 527003283; Tue, 06 Jan 2026 21:24:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 21:24:01 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 21:24:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0ojRb9dnkcCSNjv1hLTxtJ1AmDk8IVw3Gr99ohtVDFVBMSoqyeemnftDR9fQ0FQwes9cP1qTi2BlpQhIOcqavlER6FBT1R4+COZeBXCwe09gCT3R+/oumKVzs88xMObx0RMGElz0+LP3YcVXbv7x2wY/gE+RPEdWdLbDruWL+ni4nvIrFBXqNbk2bQK/avK6hJXC4qcenuho3B5OnRF2ulDixdw8Y9wqxSF444a0oKvqcmdwxot0FMKN6rMlzhkAZNub1tIK5sh+974oLk1DdbWqxwW7lOIFh/n14eCUjY5e+vJphRiR4bLqGdoVayhxI5afdnVxYfaAJLjO3pSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oo033lm1ycAPbD3gPRFbqjnH8PxxmWVwrzOcHslgZWc=;
 b=NeBWvxLbX6bU0XvsbPlul2iSysh0jjwrIRzkCUvULbgY5EU604lNj0LHkCWa0EH0KfYUfWmI79l2fXm/TSezXKM0zPY/lrJ0y7FjieboAppeXgYEyBJv9EXfrA1Z5AoOndn6dS3wKMS0JvUHpkDANCZMn+0cuMEGYd8Qkkzshs4URxBr/ybDcnCk0QNqQEO1VgGaMKIj6WJUTdYy6cku4a/DC8D3kmhEbDBoHWfZrQimRFET6MJ0/DcoV34bX1dLvc1VIlHCamd0eg8X1ay4sO3Cug/H9FUuR7x3+91fJYrwaJ/voQ4x6XOLp9gjY/F7BFHFti2Vk6KpHGAcw2GRFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oo033lm1ycAPbD3gPRFbqjnH8PxxmWVwrzOcHslgZWc=;
 b=APklaBQdu2ZhIVqiVKiJmpGzy7i02RoR8VQeREM1JUv/XIth9lQS69eY1FP+odf6OoGOvljTWwFh1blmVpNuGKBbUikawaWEXZKW2xWVWa6D5U+BPTn0LY0IPV/8O+9KayxEYW8q5KV52BVX4iphHCMwKKfQlejTTTvg2JwwBXw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6826.apcprd03.prod.outlook.com (2603:1096:4:1d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Tue, 6 Jan
 2026 13:23:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 13:23:58 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v4 11/25] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v4 11/25] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHccB4RyL0BA8NNcEOn+0trE2twG7VFPzEA
Date: Tue, 6 Jan 2026 13:23:58 +0000
Message-ID: <213d3077835fc86d15579c0a0a91f64fd84b1059.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-11-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-11-ddec7a369dd2@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6826:EE_
x-ms-office365-filtering-correlation-id: fd6198f2-6aa0-4f30-b402-08de4d26d99d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?d0VQK2VJd0RiSkNSRzdZQ0d3TGlNNlVNQzdSUE9SNGpWc0t6aXZUN3Rwa0JB?=
 =?utf-8?B?Uit6aTJQelIzRlFlZlJOQjlaRnlzWHhjV0FjSGNyL3pnM0l6cTlrN0lpSU5K?=
 =?utf-8?B?Vy8rdStYN2M2aGJZTGYxcXVPVHpmVEdEME95Sk9LVy9vZUhzTXdNZDNrQmFD?=
 =?utf-8?B?ZFN5TlFVVTNEa1VIOVhsYWRvUkFoTW9tQ0ErVFBwOE9xcGJVVzlYRmdCUWx2?=
 =?utf-8?B?aVlTb0p0d0VlQ1V3MHY1ckhKL3F3eDd5ckkxRDdXdUlCY2hUSmR6bXZJTm5T?=
 =?utf-8?B?WlJKQWNaOVViYVI1RlJnTkJ6aFQ4NXhBWFBCVkoybWV5NWhiTWRJNzRwVHYy?=
 =?utf-8?B?b1ZFZFZ5OVBVS3VuZk5KaEptMDJzbDZvc00zcVNRL1lIU3VzQU5VTkJGZDI2?=
 =?utf-8?B?RHY4aUhZV3p4K2ZnWUdtZkpTUi9wU2JaM1crYTZXeHNtdmpOSE42YjJGVXov?=
 =?utf-8?B?YThrZkl0Tm1ZcWZyY1JwbmhhdEo4SXh2emtzbVFOZ0pScW9BSjUxcG9CcTNZ?=
 =?utf-8?B?UDE3eTVPUVg4aUhGb3Iva2poZ0JNQmdwbStjZVI2UElvYXJIL3dEbTRXVEk1?=
 =?utf-8?B?S3J4N0oyQ1RCWGtGMlZ0eXNteFo3dHRqbWZmcUhvTDNwNU91aEp3bmgyTmhi?=
 =?utf-8?B?K3Q3Nzk3MU15bGFnSG45TUc5TDlPbVBwK0JJL3JocFp5cVNFMUx0UkR1T1FW?=
 =?utf-8?B?M2ZGVzJiZHBrSUo3SGhudEo3Mkt4TE9JMExuM3lxQThTbGVGa3QxRG43cTkr?=
 =?utf-8?B?c0RJcTVkUmQrYzRmc0tNUGd2WEN5VUd4TE13eFZUVy9POHlxVjRPMk1YUTR3?=
 =?utf-8?B?eWhPMDQrQ0ZsUHYwcFRJMzhBOFpsVnMyNEVuNDVPS1dGazRFZXZoM3pFWVZE?=
 =?utf-8?B?d2lsZlRPcXc0TDN5dGYxNXE0R2VHRGh1T1JYUlE5UHdxTjFWUzRYRFhtYjgz?=
 =?utf-8?B?UFhwOTFTa05oa0tZY0RJZWtpNVBKWjljeHNwUDNQVWI0YmZLOUdlVGU1MGdr?=
 =?utf-8?B?bFJHa0ExWTdwdExpWmFGWndhWXBsZjZkVzZLUTQvc0d5ZjlXT1AxSS9aK3pS?=
 =?utf-8?B?dS9ZMVdjaHZZZ1AyUGRXN3dOZWZMcWNVWkFWMnk1UHNVYmdOTFhpUytSelIw?=
 =?utf-8?B?ZlZXQndLSFhUMUw0OGhNc1dZaTVOTVB0dW9ZSm9tME1ReDBZSm92Z1NjQ3V6?=
 =?utf-8?B?MXZacEZjclBsTmJhTjFjSnRqNmFqUDVxWTBtQld0cHQrUktHUTJXSStpbjc2?=
 =?utf-8?B?cy9IbWNiSGJkTmFIWVNERHNiMWpZcENVVVFWczYxenVlWk90ajF4QWZwZ2pm?=
 =?utf-8?B?ZjVDY1Z2SFlnQitoN1Jjc0NhNXFRdktvbGJWbzc5ajRCem5wRlNhZHVldFo5?=
 =?utf-8?B?SmNqbzdZNjcwUllaRjB2SXpBT3d3SHFvNE1LUHU4a1ptOXF5WUh3M052WVRk?=
 =?utf-8?B?bXgzdEllNUFyTHpObEsrN0N6eVZYUkZCNzZpK1Q3REo3blJzbXRsWGxGKzk0?=
 =?utf-8?B?MGludXduVmp5RHZVTVFWQ0xTZWlyLzZRUStmVWd5cTU0dnZJQ2tzb2ZuUVlq?=
 =?utf-8?B?dDVHSlJFbDd0UTdWUStzdXVxOTR2MHRqQlpPT3FCZVRqS2hIN1BBeFBSZkRm?=
 =?utf-8?B?ei9CYnNSMGpvb29TRGx0RWlaT0o0dUdlcnBnVlV5dTlQdE5tdzZETkhPRmdW?=
 =?utf-8?B?QXJwY2ZxTUVpWGIwUmZPRVdtZlNhNDIwOXdPZWFPOVNqeTdNTERaM2tGa0xN?=
 =?utf-8?B?NDJzcW9nb1p6ZDZwSnVmSS9pKzVOWXB4T3BTTmpYYVRUVGRYR2JLM2hDUkVZ?=
 =?utf-8?B?bzd2b0UxQVdvNjVLdTQ0aFZLL0RybXVDbCtsNUQrRTJZZDIveTl5RHNrWVVL?=
 =?utf-8?B?MHk2aS9xRmRTRENINDB4eHBVR2c0QzNkV1I0aWJac29NM2dBMHNCbENSYkZZ?=
 =?utf-8?B?WTZnUC9qVTNCR3MzeDlqc1d3SVQvajRaT2RJNklVVWsyc1UweHM2VzBLNmdn?=
 =?utf-8?B?RWk5c0ZMWUZuVEFDOUNMTWFmeERXWjU3ZFg4T2hRbDNibzVzRUpJZDcwZW4r?=
 =?utf-8?B?NVVwNDY5YzZlS0NPdmU3Sm5uOUUweU5IYTZhdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MG9QSE1XZEdPR0wwdXFCVFNMWVdLRDVZMExOV2dMa29SNFRrV0M3SHRWd28z?=
 =?utf-8?B?cWgxRnBpOGJnUlhwczBHUGNMWjljVHNqcVpncUFHdHNza2VNZ01FZHR5YlBQ?=
 =?utf-8?B?OHBWN1hWd1ZKbVRYVFlpZzhNMU5MNk9xQXp1aVN0TzBlZmtJdzZucnExcDFt?=
 =?utf-8?B?WUhQOUs3dHBhSjh1R0FsamhVL2J3QWFhYXNuNnRXbXNMaTdUTVRmZ0h2aDNR?=
 =?utf-8?B?aE13dTU5eTRBOU5BQXRYRmI5bGRnYlJLWDZ1T3p1YW5kQ0pEb1V5Qk1OK2FP?=
 =?utf-8?B?Q1diNUVaNmtUb2xMWHZYd1pjamVpVHlEQnFEMFJzMlRzQ2lxSDhweDJZQ2pC?=
 =?utf-8?B?bnJCVTRnVnV0dmp5K0xkSzVFZjhjNEh1NDBXMXVkTGJXdHNZcmR0bUpFOFFk?=
 =?utf-8?B?bmUxaDJDT0VkejZKc1FxbUlEN3dhVm1uNlJoQnUwU0h1SU5NSnhpeWJQRVl3?=
 =?utf-8?B?cUo0T3VabExKcTBUbmxZclNJN2U2WUFpWTQwcUlWQjlSZlUyTkkvK3NnUjF6?=
 =?utf-8?B?QWwrMlVNK0ltTFZlTjd2OXFlenhlajlScytYNTZLbG9IZlB0WjBnb1l4RjBI?=
 =?utf-8?B?SE9PYXozQ3NvZUJoZ2k2RjZwVEVpRCtSYURIazI1clJ1ZGcyY3RMUmZidHZu?=
 =?utf-8?B?bEZFeGpzQlRzN2YwQ0NLRm9RcTdFQ0xCWXBQcmsrZTl0M0VBNjNZd1V1QkRs?=
 =?utf-8?B?cC8vamxGam1vcTZYY1hSc1N4VmdhZW1iRnJWN0h4SG5JRHFkMGV5QytHOTY3?=
 =?utf-8?B?ZDFjVjRhL0FJdUdyZDhhbzBwVWxLTjZwZFhxK05RYjJDMGlnSmxMOVJSU0cv?=
 =?utf-8?B?cHBQWHYyNXNMUjFrTlAwb0JZUFJONEZwYlViZTFJR2traWNpZnNwL01vcDBq?=
 =?utf-8?B?dVdtS3VtTGthTVhnbTVVU2hKUXd5RXI1RW9ydTl1aHFCa3NFZGF3Qnp3aDBI?=
 =?utf-8?B?K3dLRnNEdFJQbUtFcEl6Vm0rWEJ0NjNkZjhZdDY4aWRoSXdPdEtsdkZNY004?=
 =?utf-8?B?VkZ6RnFtNmYvMU9lSHNDckF4dGZHai9XK2EzUitTcUVDN05vVTBFU0xTNHF2?=
 =?utf-8?B?Z1NZaVBqQ1Z2Rkc2L1Z3cUtrYkFaNE5Ydnd1RDhFZ2hYK2Q5eENMZ3lYcW84?=
 =?utf-8?B?eFQyUkNUUFV4b2dSOE52Wk5iamZrZDVwUXFVa2ZGTDdROHZNdlhRVG1MVitM?=
 =?utf-8?B?S0ViRVpSL2I2aXZnQzEvWEIrZkdUVGRDaEF0c2xtSFdqd0EyYW9oSGhSeGJY?=
 =?utf-8?B?Rk41azNCT0JjTjZVa1FTeFZFY1d4RlFDMVpjaDJxVUsyRE5ianA5MllEa3VQ?=
 =?utf-8?B?aWdoT3lSLy96dkxVNENheXF6QzdKeXN5WWJKSFRQN1J6Nng4ZlBnSE1VeVM0?=
 =?utf-8?B?ckkzZWVJYUFoY1M5S01pSFdsU0pOb1R5OXRTMkVHdWdEUnRnQWlKT0lSK2tT?=
 =?utf-8?B?TUxERUcrMlArekxkUWc4M1M1ZUdjTnpyamh2NU14MjYycmQ4ZThCeUVwRGJQ?=
 =?utf-8?B?WlZZWlgzY2JJWjl2TWJRVTdneHBoL0ZibTYrbXhiRzlSdTl1c2xGV20yWHJH?=
 =?utf-8?B?b0NaSEVwdzJTTGpmUVJsM3dTUEN6VXB2cnZzMkoycFREblh5RWNOTHZ2cUFt?=
 =?utf-8?B?REhXT0R3c1JBdDNZZEFqQTBkZDdhaCsrSWxYL1Z5dUowT1RTNSs1dHpFaThK?=
 =?utf-8?B?NERwMXIzS3FxWTJ0R1FXTUZXbFl2YVoyeGJINGpwNjlnaUl1M1FZSGdHMlFo?=
 =?utf-8?B?Uzdkb2REcmRnRUZJc3Z1dzRacEFEaXNQbFR2S0M2d0x0NTlUQU1CZDZCbFJO?=
 =?utf-8?B?UElLYWpqNWNNVFlIMVZMZkZPdU9pencxVCsxMkxKQklMTVZWQzFCRkRUV2hG?=
 =?utf-8?B?ZjVFVjBVT2VLR1pQbDlLYjBQejhHcFFWNnJqbHhJUytQRmVBT3g5a1krWUIr?=
 =?utf-8?B?OVlzYkJUTFpJSWU4bGVDbjdLTDBwbEtvQ1pKOWpFWGhLaGJicHNIZEhwUDhX?=
 =?utf-8?B?Vnp0Yld3YnFMMWdsU0pIQ05uc0Z2Wm1RSXVGWjZhbmorNXBSa1ZqNVQ4NkU4?=
 =?utf-8?B?YnpvUHZXemhQRnpCbm1pSytrYytudGNJQzRRZnl2OEtLMzFnaHR2YUQxeVdS?=
 =?utf-8?B?OHV0Qzl6bHVwK3JIbUgxVjFGRzJra3dLZi9WRXBzK2VPc2E0RHlJOWREMFRt?=
 =?utf-8?B?Z0V3U1d1Qi9mN2dML2dqYTc1MVdFSmhtV0Z0bzZ2ZTJoL3B2cmVpUU5JSDQ0?=
 =?utf-8?B?RFBlOXMxS1k1OXFYUlJxYTBFZmpBN1pjT0FoUStPRjRlL2xDSW9yZWpuZWk0?=
 =?utf-8?B?YkZwM3BzQ3BpQnhKTytGdmNwcUlYVWpsTWNzZjFWL3BHOFN3MEthTVZtMjZO?=
 =?utf-8?Q?B29Sdhm+j+i3f7Bg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6150AAE40574DA48837846DA63E9B318@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6198f2-6aa0-4f30-b402-08de4d26d99d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 13:23:58.7752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptlUJ58WoZR0cJZfLgqwMPCwHeaGHj+iQzyjXUaZUTXmw7NDjlqQxxMdj8qCmwRbTFztY8Y6DDcCGQlT7AtcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6826
X-MTK: N

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IA0KPiBSZW1vdmUgdGhlIHRpLHN5c2Nvbi1yZXNldCBjcnVmdC4NCj4gDQoNCkhpIE5p
Y29sYXMsDQoNCldoeSBkbyB3ZSBuZWVkIHRvIHJlbW92ZSB0aGUgcmVzZXQgbm9kZT8gSWYgYW4g
ZXJyb3Igb2NjdXJzIGFuZCB0aGUNCmhvc3QgDQpkb2VzIG5vdCBwZXJmb3JtIGEgcmVzZXQsIGl0
IGNvdWxkIGxlYWQgdG8gZXJyb3IgcmVjb3ZlcnkgZmFpbHVyZS4NCg0KVGhhbmtzLg0KUGV0ZXIN
Cg==
