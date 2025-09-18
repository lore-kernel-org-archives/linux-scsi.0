Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E783F9FB;
	Thu, 18 Sep 2025 03:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758165377; cv=fail; b=lllJwJ9EI/vRZnMZaP6a96BhePn4VxPxWgYEIAcnznecia0C44yFhn+YswdayzXe1rkyzcC0RrRdnhO7o5WNvm+qieUWEBgjlkBlJkYDUNYlGG0nuZ61XvGbzeBI4sYiiQ7vkArYRbwIpQ0FlzcXkntImJISIKpKz/YBIVNKWqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758165377; c=relaxed/simple;
	bh=7sXQ9broE0UQ+11jZ/jsejK11YSV9LwAHK+8BkJQsvE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YnplYIubRXQxz/kaUBwybbiwL+lBpre+zBbdM4H2gyT29nW39yUIJgBVAbdfD5hufMlR9YIPlwyNw4u3WdMI0XlQHH5zXkt+VIxU6Yx1fKjlIEXrXm9qe2F49YZG4lKn4N3bjrJYFJvVd+jsKuJc1uoEEQTgrjxqyh+cAPZP8wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LasDQW4a; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=o9zQbyL1; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LasDQW4a";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="o9zQbyL1"
X-UUID: d1e9d83e943d11f0b33aeb1e7f16c2b6-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7sXQ9broE0UQ+11jZ/jsejK11YSV9LwAHK+8BkJQsvE=;
	b=LasDQW4afrTKluNH3tkzt6rkuQLG/Nas1pFooNG7pu5VBmDFyEMTfDXf6sjMkSlXJKeG1miFKVMFxbrt0wmGD7UOHawO4LetUWEwL7UhjWsB3bBAay8gE78/cAC1usSbPsuQuROyUjQ+s/KYdyw1ey/LOEOqFgvqy/7KLWgvE5w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:87e6ed13-2be2-4c26-9dc5-74711ec6ffca,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:5a216cf8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836,TC:-5,Co
	ntent:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d1e9d83e943d11f0b33aeb1e7f16c2b6-20250918
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1867262620; Thu, 18 Sep 2025 11:16:08 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 11:16:05 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 11:16:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+9Jhs2HfzhcPlydC77+Ar5LmwMQMtRrznGbYrEgY6NueqR17XrkYogSG/Et6Nbd1COBDpRPLeotcyIqVmqjw238G9ZWXCIjuZpEBeGKL7FCkSYPhE57WgYOpBAN6rLgCzOsB+JSKtsUwp5SlHUkyOlDPNTcakRmqOikN2pDlNKrK72sSL0NdLSCScEXqh+JipDCqVoRPLu+DIi376CQh3tgJ0fWpnXmnW7nfNUq/CdleCJfgtm/ms7PvOv9QL54Jp3UiPRzTDxWzxx/dcRVLfi0CBEptzRqHIigL7WZYcP7ONpY54cdGUlc8JTyO/Yw/mweAIB5Z1vz5i5AljJ/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sXQ9broE0UQ+11jZ/jsejK11YSV9LwAHK+8BkJQsvE=;
 b=pWofMVhcj58gPjQjMgQcYGOEW7ewkVcuKzTMRbm7xrBXiKZm/N7/ZIPuEW6wCYPbEGsP1IjyM1p76+rsiFevUmfoRnsZQlOaHOro2NFOD0q6dTu5XB97z/sRE5wzXFro1Ha2DHimb8XbSge9D8EepWp+zxD0n2u8aOc+q9e6695B3Ys2d0K2Wk4y7zKTjMyw+IqDcq0SeYM+NDiMMMWTx3z66Um2A1Xz0A6UURN3mrt4vqrGLIuMSZj/NCqb3FBkBJfDr4ymODjr/3d982us+sAoQqEb/oa6/JIb/ToxjfY07KuEAnOailPgGVQDoJP14bKUBaHNJjPAhAa5Px2eCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sXQ9broE0UQ+11jZ/jsejK11YSV9LwAHK+8BkJQsvE=;
 b=o9zQbyL1Cxl+U66wH0G4bTJVGXYXeb5m1s4zmL2zVuFI0U7hXNCZVEDcw1tlrTRZJMscOu+Tc6zk28DTo4Vl8wReoApUPiKsmlmx+yi08NtAWE5Nk27nS5gLccgTyE8w7mNeiT6PK2aZRCOy8hdc9xmPwOju+hdHkgLAflS60eo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7644.apcprd03.prod.outlook.com (2603:1096:400:416::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 03:16:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 03:16:02 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"zhongqiu.han@oss.qualcomm.com" <zhongqiu.han@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
CC: "tanghuan@vivo.com" <tanghuan@vivo.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "ebiggers@kernel.org" <ebiggers@kernel.org>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"ziqi.chen@oss.qualcomm.com" <ziqi.chen@oss.qualcomm.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
	"nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "huobean@gmail.com"
	<huobean@gmail.com>, "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"liu.song13@zte.com.cn" <liu.song13@zte.com.cn>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
Thread-Topic: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
Thread-Index: AQHcJ7detYez9OxiNU+xiPCXv7yphLSYRbAA
Date: Thu, 18 Sep 2025 03:16:02 +0000
Message-ID: <c28785e6db14f383cecea3e2b047adf0e928c4cd.camel@mediatek.com>
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7644:EE_
x-ms-office365-filtering-correlation-id: 529db228-c06b-4e10-5150-08ddf661b2b5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OU41Rlp5YUVSbkJBcHdCWVUwS05SMlpTV01XOHZmVXRqcHF1Q1ZEOVBhalIw?=
 =?utf-8?B?TkZTVi9wTlNwZU1jZS9mVW9RMmtuaWRlaEZHMWNWeGs4QkkvMmsrYWVFVTZJ?=
 =?utf-8?B?dVhFNWFybDhQdUNaYjhxT0czVXFIS1RRU01BWEg2VEx1TlRJQmFNWUVUNEVu?=
 =?utf-8?B?TzRSRm5IQVJobExEcVR2OTgrbkhPd0xIZk5mS0ZUSFAvOEpmdzkwcEpBM0VY?=
 =?utf-8?B?QWJHZTIwZHRUdFpnTWFtNngvTHlKcmlWWmU1SFZIRjJ4dHVNSDk5WmFYYUdM?=
 =?utf-8?B?QVYzNEdqVDBTTHlqM29SbEc0OSswTjNCcHRnN1pucXBNQWIvcmoxSUlsNTJw?=
 =?utf-8?B?UGR2RnpMQ3oyR3J0dkdxbG9CNmRUUk54aXFrT2tBbVkrL1BBbFNXRXdlNVg4?=
 =?utf-8?B?NjdIcVFJbkM5R1NHL2FUbk4wNFBmaExjU1l5MnZJZFdiZHJlNm5tVlJ4R2M2?=
 =?utf-8?B?YUlqdWJCK05iTUNkbkRzOWJvRzZWL0E1NUsyQmh0bjNaZlJjK0tmNHhmSUQr?=
 =?utf-8?B?c2NSVHNFM2RwbXNQNHlyeitQd3ZNclAzSnBmemE0am9xakJYdWtqUmhIaW9K?=
 =?utf-8?B?bzVQbHY0MDdod2d3em5pWmVkMXF5N1c2S2pyVkJZd3o5NTVUdXhJcmhDZGNV?=
 =?utf-8?B?QnRteWF2dGs4WVZNQk1uRm83SVRZWXY2YmdHb2NOcUJ6ZEpURGJTYWVBdXhD?=
 =?utf-8?B?U0ZVMFdoSE04VUhuNVFHVytCbGJzaDIrdFhxRE0yMERpMGJ2RmtwQUh0T011?=
 =?utf-8?B?OVA2VG9mcHJKMThNeDFNRXRPZUZGWEQ3Z1c2azdtcUhWUUo3OUVLUnZFTnBt?=
 =?utf-8?B?L0c0QmlKTlk1WnlOYlBYTjBhSENLZ2FEcDhzNWZFdHc4czlJSWFyQmwvbDRv?=
 =?utf-8?B?MmQ1ZG5rYlJ1UEpIVjg1VWtxcmJuRm9oYVU0Nmx2bE9KL3BLc05pN0tLek0r?=
 =?utf-8?B?bXA4elJkTDFhSERac1NmTlR4WHF1SkxaaEFnS25Da1dYRk14bzVLT053K0xx?=
 =?utf-8?B?UWtxMzcyRUFsV0dja2lHdkZrZnZWbS9NbzVnaloyTm13VCtjNzZ4TnRscllp?=
 =?utf-8?B?c2UwQjBJQ3ZXWUZlOFhDektTbE9tU3dtdHVzcjBvaGRFYkxTaHdNNUl0N2RV?=
 =?utf-8?B?YmRjK3dKU2lHc0ZOcWZveStwVVg5QmpjalBhOXdFNWV1RGxIdVZaN1ZYRm9p?=
 =?utf-8?B?NXN2ZXZTaXBSM2pRR21uRm9naW94T3Raa0cwVjk3YWIwMWxlcVBSOXJUME83?=
 =?utf-8?B?V0NwUmJtbVZRVjB6QjAvZytsNE1ZYzd5b1VBQ01mT3VOdWFnSXBTNEREeVZL?=
 =?utf-8?B?ek51ZHk2ekF1L1h2YWNOMmNNc3lkdFpvYmNYQ2I1OWxCQTNsK1FIa1JFRktm?=
 =?utf-8?B?ODJobkphRXVkakRIY2VIcmNmZUF3SW5MOUFmTlFHVmJoNHZ1eHYyYXpCbnph?=
 =?utf-8?B?UC9oT3ZCNFF5NDZoRVBBdzZKaDJXaXQxSXlBTlNmZnZkWWwvSlRsUTd3MVMz?=
 =?utf-8?B?QWJzYVNBdkRtZDVRaWF0U210Y3dZQnJaZE5kcU45UEwvN1dobS9rNEsxM3BH?=
 =?utf-8?B?dEpBRU9id3Q0bFdQYjNOWEIzbEFnSXorU1hBdGVoT2xuMEIyYjVnRk1IVTBr?=
 =?utf-8?B?R0xtakdDYWhTVm9TRkVLeGppUmR4ak1rWUd4Z2k4K1lFR0pQclpRUFlVUDJM?=
 =?utf-8?B?WE9FNkpBODE5VjFtZGlUR05oaURteCt2WHlBLzdJVlhSSXprcVc4Y1FkbllQ?=
 =?utf-8?B?ODU0Tmw5WEF2OUYxNDJkSW54S0tYRXVKNzBvNENNVllKQ1ZRVmdzcUFYSnlY?=
 =?utf-8?B?YnFjZ1NTK1d3cFZnTEliak1ZV2Y2UVlscGJzNVBwbUFzbHdzclA4alkwczlm?=
 =?utf-8?B?NkcySHVRbGZ1L3Y4M3BlVHFqZkM0VnFFdmNheG5GT3BMK0Z2WjdsODg4dW5F?=
 =?utf-8?B?Q3BpQXp6c3ZaM1I4VzdURThpbDFMUldZdTNlSkQwYnZuUUNBU3hqTEhwRktB?=
 =?utf-8?B?OWdWOGZaY1VBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czRBWXVnUFgxemYrQzdqcHl4TVAwd01mUW95NTZrb3k0bTMyem5wc09XUTFB?=
 =?utf-8?B?enUrK3hDNjNtc2tQWktjVTNCVGw3NEswWHpISU03MUVBZEl0cjNSUk01TXFt?=
 =?utf-8?B?VGpnYUZxRmtmaFduSU1FTVRjSEllbnBBNmR0SkEydjJObUhNOG5zanFEQURu?=
 =?utf-8?B?WTBRNGtwUTdKZWhxWTNNK1dyL3BFemJzaGk3YlRubjJMdTZXdlN2a3JEenFN?=
 =?utf-8?B?UU1hUEFnQWFtNnhqLzRhMnh1WkxGOWJWZFhkOEJWcllVTU1MN3N5ZDBxN3VP?=
 =?utf-8?B?TnlIRkNyWWFxbVhvaS9KRXJuek9HZlU1bzVUY0xYTHErQWxReUpadHBLOUY1?=
 =?utf-8?B?Ry8yc0NMRGROWEpIZk90SC9qcGk2N21xSW16SmVvTHRNVW9MQk9XZnQ0RlZD?=
 =?utf-8?B?a2lQczIydzNSajZhUldSRVcvVUVWb0ErVmdXallqWVBpOGNLRHAyclN2VnBq?=
 =?utf-8?B?enkxSWtKYTdKeTZ2SWl1TDhrRTdEUit0VUx3TFJVY1g2OVF0cXJNaVByQll4?=
 =?utf-8?B?VjdONlNINzJSdEZLWGtLNVZqd3FPUVk3STd2WVFrNHhKYjJVU3h6K2phekZ5?=
 =?utf-8?B?cHRaZDBxc1FhbmxHMVpGQUJZL1ZpNXJvektxZXJ1dzJIRzdQQzZVUDZNOWZy?=
 =?utf-8?B?blpBcEIwNm1DbjgwSy9qT0FsOHdBTW4yMkRpdCtLSm54V3VrRDBlUFFjQVZx?=
 =?utf-8?B?cnUyTGpxWVVSK21NV3JyeXdFT1BzWmhTRlFsU0tjSFpnOWdpL2NMWlZRZDhj?=
 =?utf-8?B?WU9nL1FrVDdpMHphRlliVlZUODNLWlE5U3YxWUgvdEFQdUZXYXJ5dG1JZHlN?=
 =?utf-8?B?L2xabmdvYVgzTHduOHMzTGlWMlJ2VlY3MnVyNjNnZ3B0TlBXV3M1bmMvU00r?=
 =?utf-8?B?YXNyUHRQWTFndVZ1bFhOUEVCdEhFaEx6WURDcCsvL05hUkx2WWZoZjFLTEt5?=
 =?utf-8?B?VitlQ3ltemlTeTJiY0FERSt0NHN2Y2M5aVNGZDNqd3REYlozL3BUeXA0ZlZ1?=
 =?utf-8?B?aUlSa1AyWXJtNDBLVDg4Z0xVeXdPcmNzejB3RG1McVpjRmcyempyNjZldTZ4?=
 =?utf-8?B?cCtSZW5FdmpMNTdsSGQ2Sy8rbjhrVEN5ZDNCRHluOE92SjNXaVJCNEE5QjVQ?=
 =?utf-8?B?dkVxc2tYNW9OR1NNYUVkWjl0T2k3U25RSXo0UmI4dDdIZmhra2lOejhIZVpv?=
 =?utf-8?B?eWdrblFlSDFGMnZ0N29OT25wNGdKM0FBNXk1MlQxMkhNUWROTUVlem5TZHlz?=
 =?utf-8?B?dFlWUklpcTJTczVPamJmWCtvanVoRFMrVUYrazdGc1AreEpERFhJZHVoRFBV?=
 =?utf-8?B?cnlOMzVveWc4QVRiRTIrdHA4VFlUSklwWWlzNjJ6ai9NSjI5QzZSeWh2QlNo?=
 =?utf-8?B?NXJrTUJYa2g0UEFneFBnOWg4VXZnVWJPcld6eE5zd25ha1d2d2ZlVG9jbFJV?=
 =?utf-8?B?d3U4cDFMclQ2bFdrUXovSFRYb2hicWhwdTVKNnFhakM2YnVKZ3luWU84VFZK?=
 =?utf-8?B?TktHbUkzckF3WkIxS0tkWERXYitsd3lQcXE0ZmFKSVNnWDZ2aktxM20wSzVo?=
 =?utf-8?B?RlN0T0xYUFludTlCSmJMdVFVQm5PM1h4bWI1VWg4LzNwMS9VMyttb3NIaitO?=
 =?utf-8?B?b3NrczBERkNmQ29ZM3JOWUFyNnRRUWw1U24zb09SeHRMcXhYTllxeHErOE85?=
 =?utf-8?B?c1A2RzhaVDh5V3hSMGxxNTlucy9FeEl5U1ZrbGV4bXd3Ly81Wnc1S09PbjdW?=
 =?utf-8?B?TTBVSHFTdEZCM0YxS0tQcWs3SE1jUjV5cG8wYlNqSGQ0K0ZxdUgxNXBtNjlz?=
 =?utf-8?B?bmZnOWxha20zS3FKRWJjdEVjSmlZTFU4L0ZXSzE3S0RseHZCcEZRc2ZYK0Vu?=
 =?utf-8?B?VExDVUlpYXZoMFN2WDJ1LzlXZVpSOXc2K2VxdUVjY3k4Y283Njlaa013WFpr?=
 =?utf-8?B?SG5FTUZXa21RZFJsamRGQkVEOHZrRFViL2tXc3BhaWMxMjZFSHYwQkZVMysx?=
 =?utf-8?B?UEFyTURBZWttdnl6V2tMMWxDVDk3a01USUFpZ3FxT29EMWE2ZzFlc1RXaC9u?=
 =?utf-8?B?eDF4VklSVFJGTVFON05hVitjdXo0bUUyS044ejV0b0xkSTlYRU1EY3gzNks5?=
 =?utf-8?B?WFgrYlZkR29EaUsvSUNYT0JRUytvbk5wSExSbGdvK0dqelpuLzduRjNHVlFo?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B2CCB0E5F68EE4F883E0221715ACC18@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 529db228-c06b-4e10-5150-08ddf661b2b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 03:16:02.6852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UO7kevIkMZWszq4qjDeZ0Nd9STAOcGlkSHr/AMSPAcsdEzuTFllhlkscKZXtESJv5BAsI8JQQdpUjh6s54J8CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7644

T24gV2VkLCAyMDI1LTA5LTE3IGF0IDE3OjQxICswODAwLCBaaG9uZ3FpdSBIYW4gd3JvdGU6DQo+
IA0KPiDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfaW5pdF9jbGtfZ2F0aW5nKGhiYSk7DQo+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+IGlu
ZGV4IGVhMDAyMWYwNjdjOS4uMjc3ZGRhNjA2ZjRkIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3Vm
cy91ZnNoY2QuaA0KPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBAQCAtOTM4LDYgKzkz
OCw3IEBAIGVudW0gdWZzaGNkX21jcV9vcHIgew0KPiDCoCAqIEB1ZnNfcnRjX3VwZGF0ZV93b3Jr
OiBBIHdvcmsgZm9yIFVGUyBSVEMgcGVyaW9kaWMgdXBkYXRlDQo+IMKgICogQHBtX3Fvc19yZXE6
IFBNIFFvUyByZXF1ZXN0IGhhbmRsZQ0KPiDCoCAqIEBwbV9xb3NfZW5hYmxlZDogZmxhZyB0byBj
aGVjayBpZiBwbSBxb3MgaXMgZW5hYmxlZA0KPiArICogQHBtX3Fvc19tdXRleDogc3luY2hyb25p
emVzIFBNIFFvUyByZXF1ZXN0IGFuZCBzdGF0dXMgdXBkYXRlcw0KPiDCoCAqIEBjcml0aWNhbF9o
ZWFsdGhfY291bnQ6IGNvdW50IG9mIGNyaXRpY2FsIGhlYWx0aCBleGNlcHRpb25zDQo+IMKgICog
QGRldl9sdmxfZXhjZXB0aW9uX2NvdW50OiBjb3VudCBvZiBkZXZpY2UgbGV2ZWwgZXhjZXB0aW9u
cyBzaW5jZQ0KPiBsYXN0IHJlc2V0DQo+IMKgICogQGRldl9sdmxfZXhjZXB0aW9uX2lkOiB2ZW5k
b3Igc3BlY2lmaWMgaW5mb3JtYXRpb24gYWJvdXQgdGhlDQo+IEBAIC0xMTEwLDYgKzExMTEsOCBA
QCBzdHJ1Y3QgdWZzX2hiYSB7DQo+IMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBkZWxheWVkX3dvcmsg
dWZzX3J0Y191cGRhdGVfd29yazsNCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IHBtX3Fvc19yZXF1
ZXN0IHBtX3Fvc19yZXE7DQo+IMKgwqDCoMKgwqDCoMKgIGJvb2wgcG1fcW9zX2VuYWJsZWQ7DQo+
ICvCoMKgwqDCoMKgwqAgLyogc3luY2hyb25pemVzIFBNIFFvUyByZXF1ZXN0IGFuZCBzdGF0dXMg
dXBkYXRlcyAqLw0KPiANCg0KSGkgWmhvbmdxaXUsDQoNCkkgdGhpbmsgdGhpcyBsaW5lIGNhbiBi
ZSByZW1vdmVkIHRvIG1ha2UgdGhlIGNvZGUgY2xlYW5lciwgDQpzaW5jZSB5b3XigJl2ZSBhbHJl
YWR5IGV4cGxhaW5lZCB0aGUgcHVycG9zZSBvZiBlYWNoIHBhcmFtZXRlciBhYm92ZS4NCg0KVGhh
bmtzLg0KUGV0ZXINCg0KDQoNCj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgbXV0ZXggcG1fcW9zX211
dGV4Ow0KPiANCj4gwqDCoMKgwqDCoMKgwqAgaW50IGNyaXRpY2FsX2hlYWx0aF9jb3VudDsNCj4g
wqDCoMKgwqDCoMKgwqAgYXRvbWljX3QgZGV2X2x2bF9leGNlcHRpb25fY291bnQ7DQo+IC0tDQo+
IDIuNDMuMA0KPiANCg0KDQoNCg==
