Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D614F246BBA;
	Tue,  2 Sep 2025 12:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756816772; cv=fail; b=E4CWuz7RsiufI7EzEV9feCHLOQq5nBr9HihIzrgg/NCSARhIMIIgS2Ck4i/B0ixP8+N0ji1Ogd22vZYfrPnC1y2W2Eu3WmrrjFN0KEHxM12s85S5Y8Xl3xO2bswsz+qA5ZsFvH6/UdOHq0EACsL/kgf1SRP+OicZ+9pl6iKPII4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756816772; c=relaxed/simple;
	bh=FZTUqdhkTs1dgf2QfX6+vIBLVpeIwiCJ5PzxIUHwH+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aAWukOa7uqJWCxUKR696GUdnLKwFavLBE7XPJrS4JxfgqCe4GcWm6OnBqpmFl51FFoWoB5UIxFWuW+S2iBey00iP2BbbdGlpuI2VNYs1YYoHJ2bUbpBuYTKa3snyNrwKvMsgVKryzE9WSeGdXHOmamHFqx5C66kTkGxZLISEmb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cnOxyBMW; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Zt9XGpWI; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cnOxyBMW";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Zt9XGpWI"
X-UUID: d73f578c87f911f0b33aeb1e7f16c2b6-20250902
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=FZTUqdhkTs1dgf2QfX6+vIBLVpeIwiCJ5PzxIUHwH+U=;
	b=cnOxyBMWK6dyM8/R/yiKOPsqP7g0bP6rNG7DJOLaUqzShsP5JS1qmNwCBCti5Q0bWp/M+rutHqxdIpHLJ0l3lVdDCfcPYLBG6JLTDV+Ng9aEWDm3lod0+F0CZV12O7JHeaw6wOAobAh2NbYM22L2kHYCoqWaNusHCDsOZiU+PZY=;
X-CID-CACHE: Type:Local,Time:202509022039+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:24ad4ab3-429b-44e5-b421-c5de9818c1e4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:41371e6c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d73f578c87f911f0b33aeb1e7f16c2b6-20250902
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 42327918; Tue, 02 Sep 2025 20:39:17 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 2 Sep 2025 20:39:15 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 2 Sep 2025 20:39:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cExjIBoh7JXR426rZv2cNmtvCZEsEi8BY867guiIe5ZQ27b8LNt5rlEjMA65ynBvpbvkTS5Egoiq7ITOJnBS0TNLZ05Z5OpZMHWbz5bgVnTBhGUUHW4rO1/Fkwax5ax7mOr3zpCzz71xEeey/Sj+BHyka7XSlm7JbhYz5rPG0PcDeNb66N76rb93qHaVFmXYkXVfyQhpfUQmGkBy0KromeTUWzHckMPzbfh8LWTiD/Wn7QFLpgpbNqrP5atVoBG4pO18GKwkE1Hhik8jeT3UmdpcWrqu4bB9tyHilbNCJ/qcZBf7CQ3ehQDvgYDeUBxZ4Zw2kR5M3hMNCryP+qLHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZTUqdhkTs1dgf2QfX6+vIBLVpeIwiCJ5PzxIUHwH+U=;
 b=FG6xqw5c3HYrseEuM01h+63WFQvGi3wmi7F4Kx15Bhy6D/xVPnImiLOYC+EFbUH9GeXHorAyMk/ZI+TdilE6qFVimD894cVVj0msoRlQVih0dzFalDyyySk3WYbIHu9yywSJS38mDK2vi76Ehz+Cud4ony2c9tlqnpnSIPBQK0D7aWrXGiva1QFBXNFts1lmoRJ9IfFEuL7bDNXXBPhBtpoGDYK6spSW5KGJkkZAJPji+7u+xPrH9LTsTvCJ0AfmGpD9Lacz111C24jkIbr7YdzzvPje6/FV1Log+mzwwPCuEnp6yGr9BJl/DPCC2BngqVRqrL6WoGN+Em0oc3KioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZTUqdhkTs1dgf2QfX6+vIBLVpeIwiCJ5PzxIUHwH+U=;
 b=Zt9XGpWIIzXEAY11DnMV5gnKdOIzQCycoVj+3EO6Qial7p5jJdhFkFVUV4Ev0NaIYuMHZ2Y8twsg6DRxI7c8q4XG5Fdfjhz+Eh7M0VcfncRvvOftpb9NEaZB9EfNCPlsa9IQ33mg8cg8cja7J3Us8gUoPECXGH54z5EJed//xlA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7167.apcprd03.prod.outlook.com (2603:1096:101:d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 12:39:12 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 12:39:12 +0000
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
Subject: Re: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
Thread-Index: AQHcG94QCV1UWJLgY0ur9TH/oA5hjLR/1W2A
Date: Tue, 2 Sep 2025 12:39:12 +0000
Message-ID: <d8be2a553690ebcf915cd1ad395c3394158abd58.camel@mediatek.com>
References: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7167:EE_
x-ms-office365-filtering-correlation-id: 33f7bbfa-e228-4c3b-a58e-08ddea1db878
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MjdLZWNIQjFuMEpnbEJnaDNpV3NyWXdOMXpCVUU4U3lyT1UwZExVTVBDcDBo?=
 =?utf-8?B?aDZwTExubXZoYVF3eFhNR0s0SFMySzlkUUI0ZG9aSS9WbzNiYkNoc2Q5blZp?=
 =?utf-8?B?bzBOS0xnaHRjNFAvVGN2b2hGMEpsQ0U5TytqTGd0cVo1ejh6RWRySUxmSy94?=
 =?utf-8?B?N1ovY3U2M3hGR3lKVGtubGhSWVRrVDcrYVlnQitvT3M1ZXRWdTQ1REc5eDBX?=
 =?utf-8?B?VTdJR2VMeW5sc29aUDlLTThXUnF3NkcyejA2R0tuS29maTJ5eTBOTnFJTkVt?=
 =?utf-8?B?cTEyRXkrUjRGaGV1RktHWEU5OXg1QTZyaksxU2s1aG4xakpNVkJBSkw0MEVl?=
 =?utf-8?B?SVpUM3ZnUHpvaEZvcnBiMDEvVHo4UDRDQytTekFPRnY4Q1B1TkRYWDA1LytZ?=
 =?utf-8?B?aUErS1lkdGVhYktFYUo1Ull5b00xNXFtZHpMOERxUkVQYXg4SkQycEZRbVRJ?=
 =?utf-8?B?MGhqVVlBTG9uVktaeHh5UGdpU0JWblRXS2FlKzI3ZUtPWHVLTWFrWmVVb0Nj?=
 =?utf-8?B?Zk9hY1ZScHcySnpFWUt2OWRKNisxbjZBbE5udHFmSXRlUGNmTW1zNmxLQ2l0?=
 =?utf-8?B?OGdCaW85cjR5eHFmVitDdzNNOFhxZ0taSmpmQWpwaytEdDBmL1pGdWZwQ0sx?=
 =?utf-8?B?UWc2MVI1bEtUUFV5b0g0cGNxVnlhYXYzTUlvYUVqd2R6UEU2YTRZMVJYd0Ni?=
 =?utf-8?B?cC9KT01KQThlcmtSaVRDUkpXMmRzLzR6c3V3ZldVOCs0QUptc3RkTTBwQkVh?=
 =?utf-8?B?a1NZZjNvZTFMbjNYTWdBWis0c2RzWjQxdENUTXJtamZ4c3pLYStnTGg4aUkz?=
 =?utf-8?B?dzRNd3cydnJxZGQ1bE54WDBpZGtMWC9NMUlzQWZ0SFNMWlpPN1RaRFBXeTkw?=
 =?utf-8?B?MVpYb2NTWlFkNXliQjVYVER3SlJQQXNhNTVWOEpUbHdpMm1iQUJLNmMxcnlX?=
 =?utf-8?B?YUEwRVBISWc0aDdZdWdhODlzV0JNcVZ6OTVKaUYxRDd4ODJrZnpIaXJwazNm?=
 =?utf-8?B?RmhXaTl2WDN1K3dEWEFGUWF3aHZVUlEzMlZoazcvZjF3ME50MHQycEs3VG0w?=
 =?utf-8?B?cko5NUV6TWVlcEVWcmVUOHZOKzVQSG5pYzhTb3hNZEV6bktuUjZmbGc3bFN4?=
 =?utf-8?B?SW5oNU0yZG9lWHR2NDJSdnRIeTlPMVhWOGl2WXNXTG13dTBIL09uNlQxKy9E?=
 =?utf-8?B?aWxJWlRYaHlqOGVmalprV3AwRWJIN0k5U0tFQUF6OXJCeTdUc0JBSHR1SjZP?=
 =?utf-8?B?US9QTWRjRHdVZGl0aWp4TGZaaDd3dVVhWGdEWXNqekxpeFVzeTNzb3BnN0Rm?=
 =?utf-8?B?anFlT1VHZXBhaEZTWDY0d0drQnhsM0NDUUxzUnNUNVRaamkvVGI5MTRYR1Rj?=
 =?utf-8?B?M2Y5clc0NVVjWDkwcE0xS0RhblExNk5jUjhZdnhpb3UvRUJtUDBpZ2IxOXBv?=
 =?utf-8?B?c1BOOFB1d2h1WEdPUTV5Y0hmK0ZHV3I3VExSNXY1UGhUSlk3YXlHR1BEbmRk?=
 =?utf-8?B?S0FhN3hNbGVObEZNM0NocUd0eElLL3hNd1YzeGdhSG9HbXlNVnJvMERtT2Jj?=
 =?utf-8?B?bSszWXlwZnJ2TU4xMVRhOW9UMFNzRzF3Wk14RTRjT1pLK05jS3hxaFJ1Zmlp?=
 =?utf-8?B?aitHbVRqaFJTNWhoaU5nc2VDWjJUNXBOZUUzRDBpMkM2K2ZQWmdKdmVKSjBk?=
 =?utf-8?B?QS9OTjkrdXZCeUFhaXhuV05qUnV5R0JJcFlJUjdOa1pVNnI1NDVoSnlpU3hN?=
 =?utf-8?B?VnZVcDdPdk5vbUg1OVNtNlpRT2FORjVtQU0vNVYyN05RcGlKZ3RYMy9kckZV?=
 =?utf-8?B?S3RpOFZUTkVIQ3hyeVRSUFUrcDArNzdvZi83akZxL1cydzZ0ckhnQnBLT3d1?=
 =?utf-8?B?akdCT0s1ak9SWE9SdTNZMGN4NXZoM1A1NTd6bzRKbyswWi9XZkVTZHJYZlR2?=
 =?utf-8?B?czBkT05FSmFXMjhKZjNWVXNxWWVHcWprbDhwdUZZR2tTQUVPY0kydERITjZ0?=
 =?utf-8?B?UWw5QWhMRGlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTI4ZWx1eVlSalFycWIraVFxQXN4QXlkSDR6YTVBVTQvV0g5bC85Q0xuMUVy?=
 =?utf-8?B?TklHNDliM0k2a29wSTNFdmx4bGtrSlFpZ1pkWmI2R3RUWk40ODBMNVhRZ3gv?=
 =?utf-8?B?Umk1UXJOYTVjenQ0aS9hSHRJNmswWUQrRHVDYUxvSHl3ZnRDTXNycmhUbGY3?=
 =?utf-8?B?cVRac2RzSC9naWlsdWNYbDVudnl6bUxOVXJ3UHdNWlpKSGthbEV5M2VOaSs1?=
 =?utf-8?B?VmNxK1c4OGU4cTNheWNobVFDZDNWcEw3TnJyaHJIVFpFTmVocjBWREd1L0Fz?=
 =?utf-8?B?NmxnakJ5aGMreCtFamV0NEhERDFIU0pLMXFZbDIwSEFqWGNjcktJWXZrUkh4?=
 =?utf-8?B?VGFvOUhCSEhOQUxDdktaNjliSFpJTmNNaVZrenl3QUFlZEU2S0Rld3BvMTFy?=
 =?utf-8?B?WVhvL2hZMENHaHpDVG0yUWcxS2IydWRoUldkczROZEFQL3dIcXRiVm94TU9k?=
 =?utf-8?B?RHF6UE1Lb0RrZmQ4Qm5HMEpiYjVRVC9ndnJjYmYvakFLcGQ2cHdnVVpOOGRU?=
 =?utf-8?B?WEkzVzZSNTFWYWJLenV4bW9hdXdFa0RXaGxqWFF6WE1mNjhMUC9xYStSQURv?=
 =?utf-8?B?Y0pTZUEzTUEyT3hTODBkMC9RUFBwV1MzWjhxWkJBZ0hlN1NkdEVzaXZTbGVO?=
 =?utf-8?B?MWJXQmFmK2xqRGd3SHAyZmg2eHZ0U0s3SmYrQXNjWkpZSVo1QkZ3SkZZQUVK?=
 =?utf-8?B?RGRRVkdvN0FZcEIxSGRoVFVVenZlZjJUVjVCdHFVZXp1Zm5KOU1pWlp3TUxP?=
 =?utf-8?B?NlBBN2puaGpxQ25VbE53T29XaGx5R0NCbUkxM1ZmNmZWeUQyM2tPellRd2JO?=
 =?utf-8?B?N0Z4dlk0VW90OVJyTGZNa1JKNHQxZmdsbXgvRWdYYXowQVNwMkMyU3NLd3BY?=
 =?utf-8?B?eUdBOGdsczhCWVhNNjhqWXlsVngzS0FoMXNNTTBzejVwTkFPNXhrTmJiam9u?=
 =?utf-8?B?MisyNFNDVThONVF1Z2Q2Z1pPSUFVMG1VSDlnUnpXMS9UWmVrdmxjczRLYW5C?=
 =?utf-8?B?M2UrTFVUZUdyekRHVEk3QS9RYTR6Uitkbm9FWk5sekxhVXl0V3VOa3A5b0tv?=
 =?utf-8?B?eThCT010S3RJeGxRZFhvUkxiUko2a3J5QkRqMkI2Y1lCZFAzT1p3L0tDaS9S?=
 =?utf-8?B?aU1EcVFEUmZrR0tEWVh1QUppWk5GNnFPMXFUMFNsTE52dk9Hdm44YTFWYU9q?=
 =?utf-8?B?UHlsWlIzSmNEdElsKzd2QVkrSzFDdzZOVkZXU0xWd3NlQmFySTN6Wkh0MHUz?=
 =?utf-8?B?d1k1MXpOY0FwQkhTQzRyQnRHVWNvKzd4amZ1VlVta04yajNZcW52aENkQTRj?=
 =?utf-8?B?YjNnMXZDOS8rMzRGRDJUd3BWd3Y5cnhmUVJueWFHVUZGd0hpckw0NE03V0Va?=
 =?utf-8?B?d05yOG5QVW1hTXhRY1gyQVVmZ2ZFaEJudFFSSk1BS2Q0a3lrb28xLzE4WCtD?=
 =?utf-8?B?MGpwL3lOcEo5MVhzZHhzczNJSm9QWUxwVVdsL29aOWNQRGhCOCtLdUdwQ0lT?=
 =?utf-8?B?RHE3bWlXbUZjWXk5TTlFeXNnSzJmbHlwOU9neWdHQjhDaE5MODI5cDgzc1dC?=
 =?utf-8?B?Y01JNVR0S2Y3MDBTTG5lWnduSVEwZFNXa0Jockt2ekRYMjVLMEkrOXRlTWpJ?=
 =?utf-8?B?THR2SDhyVjc1ckE3a2FWQm1sR1p6Zk9LM2FhYnFjOGJUOHFIdzZZQVpNQWZp?=
 =?utf-8?B?ZTZXUzNPaW12UFluQ2dwUUNIWXpFa3o4d3F4N1BCQm9KVlhRc3E2OGlvT0tE?=
 =?utf-8?B?TFZLUEdXa0ZmS0tRWFJRMFZGWFVzQ2l6VTg5ekRHcUpKWUFaV2FrMWpPZzhB?=
 =?utf-8?B?cERCRXRtY2pWOWVqTzJhL0JaSFpBWTEyc2JoYXZtdnNJd2NKLzNJSWhFRXBT?=
 =?utf-8?B?L1pmeXJRN3FuZlJ2RWtvall6Nm1HT2xkSElySkRLM3U3Zm1ITGtrRkF4di9R?=
 =?utf-8?B?R0x5dldsZXZGeDF2T1lkZ0g4bEw3UEhiLzlGQm5RRFBWN0pzazAzQTR6N2p0?=
 =?utf-8?B?VjNScE9yRjBZaVlyWWJvd2ZFQ1BnN012VTZzSWVDeE5ITUw0d3VaV25lOGZi?=
 =?utf-8?B?elVaSlRDU3R4ZFZKU2hBc2Q2ay9vb2FHNjlybkdQQWxNc3F1K2hyMG1FUXp5?=
 =?utf-8?B?R2RIRU85bTUwZlZNSzJObDJiUEpORE8yZkNPU1NuU3RqMnN2dWkzaGVWSW5T?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C096CE89F11F4C47A8C37C0087D9EA39@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f7bbfa-e228-4c3b-a58e-08ddea1db878
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 12:39:12.5838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEzQCLGvA8zooHxQ/Cvq/XOR46IpQKXbaRGLW9E/cxr6LHTWSEPG5cYsL7aPFy4J3H8UqALGpYFz92ZuXpUeQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7167

T24gVHVlLCAyMDI1LTA5LTAyIGF0IDE1OjQ4ICswODAwLCBaaG9uZ3FpdSBIYW4gd3JvdGU6DQo+
IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBh
dHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBj
b250ZW50Lg0KPiANCj4gDQo+IFRoZSBjcHVfbGF0ZW5jeV9xb3NfYWRkL3JlbW92ZS91cGRhdGVf
cmVxdWVzdCBpbnRlcmZhY2VzIGxhY2sNCj4gaW50ZXJuYWwNCj4gc3luY2hyb25pemF0aW9uIGJ5
IGRlc2lnbiwgcmVxdWlyaW5nIHRoZSBjYWxsZXIgdG8gZW5zdXJlIHRocmVhZA0KPiBzYWZldHku
DQo+IFRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIHJlbGllcyBvbiB0aGUgYHBtX3Fvc19lbmFi
bGVkYCBmbGFnLCB3aGljaA0KPiBpcw0KPiBpbnN1ZmZpY2llbnQgdG8gcHJldmVudCBjb25jdXJy
ZW50IGFjY2VzcyBhbmQgY2Fubm90IHNlcnZlIGFzIGENCj4gcHJvcGVyDQo+IHN5bmNocm9uaXph
dGlvbiBtZWNoYW5pc20uIFRoaXMgaGFzIGxlZCB0byBkYXRhIHJhY2VzIGFuZCBsaXN0DQo+IGNv
cnJ1cHRpb24NCj4gaXNzdWVzLg0KPiANCj4gQSB0eXBpY2FsIHJhY2UgY29uZGl0aW9uIGNhbGwg
dHJhY2UgaXM6DQo+IA0KPiBbVGhyZWFkIEFdDQo+IHVmc2hjZF9wbV9xb3NfZXhpdCgpDQo+IMKg
IC0tPiBjcHVfbGF0ZW5jeV9xb3NfcmVtb3ZlX3JlcXVlc3QoKQ0KPiDCoMKgwqAgLS0+IGNwdV9s
YXRlbmN5X3Fvc19hcHBseSgpOw0KPiDCoMKgwqDCoMKgIC0tPiBwbV9xb3NfdXBkYXRlX3Rhcmdl
dCgpDQo+IMKgwqDCoMKgwqDCoMKgIC0tPiBwbGlzdF9kZWzCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCA8LS0oMSkgZGVsZXRlIHBsaXN0IG5vZGUNCj4gwqDCoMKgIC0tPiBtZW1zZXQocmVxLCAw
LCBzaXplb2YoKnJlcSkpOw0KPiDCoCAtLT4gaGJhLT5wbV9xb3NfZW5hYmxlZCA9IGZhbHNlOw0K
PiANCj4gW1RocmVhZCBCXQ0KPiB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQNCj4gwqAgLS0+IHVmc2hj
ZF9kZXZmcmVxX3NjYWxlDQo+IMKgwqDCoCAtLT4gdWZzaGNkX3NjYWxlX2Nsa3MNCj4gwqDCoMKg
wqDCoCAtLT4gdWZzaGNkX3BtX3Fvc191cGRhdGXCoMKgwqDCoCA8LS0oMikgcG1fcW9zX2VuYWJs
ZWQgaXMgdHJ1ZQ0KPiDCoMKgwqDCoMKgwqDCoCAtLT4gY3B1X2xhdGVuY3lfcW9zX3VwZGF0ZV9y
ZXF1ZXN0DQo+IMKgwqDCoMKgwqDCoMKgwqDCoCAtLT4gcG1fcW9zX3VwZGF0ZV90YXJnZXQNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtLT4gcGxpc3RfZGVswqDCoMKgwqDCoMKgwqDCoMKgIDwt
LSgzKSBwbGlzdCBub2RlIHVzZS1hZnRlci1mcmVlDQo+IA0KPiBUaGlzIHBhdGNoIGludHJvZHVj
ZXMgYSBkZWRpY2F0ZWQgbXV0ZXggdG8gc2VyaWFsaXplIFBNIFFvUw0KPiBvcGVyYXRpb25zLA0K
PiBwcmV2ZW50aW5nIGRhdGEgcmFjZXMgYW5kIGVuc3VyaW5nIHNhZmUgYWNjZXNzIHRvIFBNIFFv
UyByZXNvdXJjZXMuDQo+IEFkZGl0aW9uYWxseSwgUkVBRF9PTkNFIGlzIHVzZWQgaW4gdGhlIHN5
c2ZzIGludGVyZmFjZSB0byBlbnN1cmUNCj4gYXRvbWljDQo+IHJlYWQgYWNjZXNzIHRvIHBtX3Fv
c19lbmFibGVkIGZsYWcuDQoNCg0KSGkgWmhvbmdxaXUsDQoNCkludHJvZHVjaW5nIGFuIGFkZGl0
aW9uYWwgbXV0ZXggbG9jayB3b3VsZCBpbXBhY3QgdGhlIGVmZmljaWVuY3kgb2YNCmRldmZyZXEu
DQpXb3VsZG7igJl0IGl0IGJlIGJldHRlciB0byBzaW1wbHkgYWRqdXN0IHRoZSBzZXF1ZW5jZSB0
byBhdm9pZCByYWNlDQpjb25kaXRpb25zPw0KRm9yIGluc3RhbmNlLA0KdWZzaGNkX3BtX3Fvc19l
eGl0KGhiYSk7DQp1ZnNoY2RfZXhpdF9jbGtfc2NhbGluZyhoYmEpOw0KY291bGQgYmUgY2hhbmdl
ZCB0bw0KdWZzaGNkX2V4aXRfY2xrX3NjYWxpbmcoaGJhKTsNCnVmc2hjZF9wbV9xb3NfZXhpdCho
YmEpOw0KVGhpcyBlbnN1cmVzIHRoYXQgY2xvY2sgc2NhbGluZyBpcyBzdG9wcGVkIGJlZm9yZSBw
bV9xb3MgaXMgcmVtb3ZlZC4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
