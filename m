Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8832262FC8;
	Wed, 23 Apr 2025 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745401576; cv=fail; b=JSfGI6GYeGiTh0su+mPwCHIFTZzeY/l1uqswIAKlUtqgaJQfsWaxwmxcI5GSY10hDGZyBrWBsmLpy8OpgWDJvyj7UfBDlPcz//w55SuBjA5F/xDJov4032KjJOqUuobZmYv0J29hsT3MhQg0dzL9pvpzIAuOaNJOTXWXm0S3fgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745401576; c=relaxed/simple;
	bh=eVbQYlCs94Ry9/PjVMvC6dhDl+oHf/iAd1u4Jo1deU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b3fqbxROwqBPjW4xPxw6v4wairNgV9mnoWYMLCVmrBlZ3LtrWOeRyfE8+bXr8opIy1yEVwdsWnRdl1/tlVyP+jqZMrs64EuepnoAkodZ1HOfjJibU7sU+WRlgjP6rI9d2Pd32wo/raBzxjBujAEBuVUo1tQrPvOFVybR5ypSsVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gpuHObfM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CcjjvP9p; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gpuHObfM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CcjjvP9p"
X-UUID: c8e89660202711f0980a8d1746092496-20250423
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=eVbQYlCs94Ry9/PjVMvC6dhDl+oHf/iAd1u4Jo1deU8=;
	b=gpuHObfMV+5Seb0Srlv/KpLXoIpjQ44hUF4NTOV2eb6Gum+zdE5cdxV+iYjQJ1gGa/FuQaIkPUkOfDZfRayNfrK6SC2rPnl1D3/1KOMB1iO+eNVqzzWRF+pd9qs+N6uqDkcSvVix+vFDOAQJwaRW8R9TnUr50oc+i8EPPWtgcLA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:54203cbf-78da-433f-b6c4-a81eec73ea3b,IP:0,UR
	L:0,TC:0,Content:8,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:8
X-CID-META: VersionHash:0ef645f,CLOUDID:324cfcca-9427-4819-8156-f3ab5b7769d9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:4|50,EDM:-3,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: c8e89660202711f0980a8d1746092496-20250423
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2079204946; Wed, 23 Apr 2025 17:46:09 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Apr 2025 17:46:08 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Apr 2025 17:46:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nd3VmCfdwbX/VigccXj9Rxg8t/NfGHYslyDfbPvnPs+YD6ZVE3S35Ul43kfIPohbzU1T0kYhGeuNezf+b5GdCrvjgzShPGRcM/BgHT2aOHYtIw0pdqrHnwBcGOpeNxdp2JlMkGY28p6J4OaTSxTySyxgqeN+NK/ifRzn8Hz2rZu10LjRqaoTSiSNclnfypb27c1IGh5ihHqILeJhnTB8awcGWZ3ozvvNcsMG5CCM5xEFuAhu3fRxbXv4RaWW6AgBqyLusymwUbEq5+a3SK+lFRO2ZWS0u4wv9dlGHmojL3Md/ZrAm2QMUsoNzH2YYU/fzoJKl0Mt/e3JfgRkv2GsJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVbQYlCs94Ry9/PjVMvC6dhDl+oHf/iAd1u4Jo1deU8=;
 b=XFjrfi0s9B3MKMJYLM8oC+Jytp1W4d29Q0ZiYNG3OY8VMJ+Pvuduzo2OwGyiIEphcrQfbBhmDQ2oCHvslr1vmy951fmi8JjxpkkEKGghmZcdLg7V2Zquv5/CGpa+AA06zSNxxzoeRG3hTy1kNEYnGdVt8cAQaIsQKES0d2JCTuwyF44282gzEhb/X3of4ZF7XmeOIglbx7Vz9r7GZhkn8rTz5fqedJmEx4w+191W/+2aQyy9sT/da9EhmItiZrunjogE+J+/NexAiFvvLIAVWR7hORIJ5h94GCNXjpNQAkO2Iwkqk6D7v50WUcgyX6Asyu+ouzwhzAD3HSYfYNr1eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVbQYlCs94Ry9/PjVMvC6dhDl+oHf/iAd1u4Jo1deU8=;
 b=CcjjvP9p9w4uNoBGDRadJWI09h740/KL9wxjTjPFiJfocWjqHs2Kam5naa2YPA1CtwpytbMWtsRYnsXamoyhBK1twARCCGNjHHpoqxnzEStXMzGzRQ2Z43ce6h7qVCAMqyueUOMafQcKhCSZStEWXQMKJ/1ZtP/iEbz3tuKsm3s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8834.apcprd03.prod.outlook.com (2603:1096:405:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 09:46:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 09:46:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"tanghuan@vivo.com" <tanghuan@vivo.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "luhongfei@vivo.com" <luhongfei@vivo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
Subject: Re: [PATCH] ufs: core: fix WB resize use wrong offset
Thread-Topic: [PATCH] ufs: core: fix WB resize use wrong offset
Thread-Index: AQHbtDI/HH9BigKXckiqPh6s7QScsbOxAKoA
Date: Wed, 23 Apr 2025 09:46:04 +0000
Message-ID: <cba286b68390472e2f3413b58c1f223b38f0294a.camel@mediatek.com>
References: <20250423092917.1031-1-tanghuan@vivo.com>
In-Reply-To: <20250423092917.1031-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8834:EE_
x-ms-office365-filtering-correlation-id: 7f32a0e8-4ae7-49b6-2d27-08dd824baa36
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TStBR1VkZGp4Rk11U0s3MU92aFRzbmZjbHhJdXRCcytHYWwwL0dDdEl4SDRK?=
 =?utf-8?B?UUxMM2ZnUGpxbXRaTER1TlM1MU4xcmJocmlkZWJ1bFhia3FxWTdYcWJLWXBh?=
 =?utf-8?B?eDlpMlpZUEordUFtVm16cElnbWhYeUR5cGFjUWNYZEhmdEhBY0FYQzU4MHZV?=
 =?utf-8?B?djdLeG1nVDBIamtWUFZzcjAvVGhuVjhJcWo1QTFMRTd5UzRtcmNMbk1NaGZK?=
 =?utf-8?B?NlBiVE5sRk5SNFVnV3hPd21WbWs0UXhKbVNFalhhMUZPSmYzK2N1cTVKNUZI?=
 =?utf-8?B?c2hMTWg1cjhEdDVZU3pEenRZd01zTGEzQU1aREwvSFMwVDRyczMwZ2NkZytH?=
 =?utf-8?B?Q2NySENrZEhkRDg5bjJJT0RRNU5VVzQ1K0J5SmF1clNmM1dsVzRmVU1TZDlt?=
 =?utf-8?B?UUtmSmR2b3pWWnBEOEhXaDVlVUpMQncxc3lRbXRQSlQ2UHgwMVZiUVQyOExT?=
 =?utf-8?B?eDU0UisrK3JMQVJJRmNnK2I1cGZkNkdVMzhvUG5jdWdOd2hnL0RyRFpPUGpV?=
 =?utf-8?B?b1g4dnA3YmEyL21qM0tTdkNkeTFmczlFemhPN1YvY3dqWnRmZ0ExZDlIbGQ4?=
 =?utf-8?B?VkJRQUE4UWFNNXRMRldQbW5HTUZxb0I4R2VtbmtLajR5Q3ZpVXlxVHVhNVQ4?=
 =?utf-8?B?QzBla0taMXVTN3pLYk1lQ0s4MzhoQ1pxUXpaQ0tTb2pUVCtKakV2WlNqWXdB?=
 =?utf-8?B?dUViMms2WDQwVG1zZzBLbTlXSFovSEkwS0xiblpmM2hyS0hsanlEQjZNanZJ?=
 =?utf-8?B?M3RIVHB0cDhmYnE3eWxTM1o1U0FXa3luZDVmM2dIZlFJN0cvbEZPZmVjSkVi?=
 =?utf-8?B?ZkwxZnlwVnJkZEl1dENHNFUyRUtvV0o3T0dOTSs0Q1RFcjYzTmtRc283Z3lW?=
 =?utf-8?B?QmJHRzV6THBrN201VGNORzJxb3JXMGVXNUlCZ0hEUVRBQWZOVTdVMWhwU0t2?=
 =?utf-8?B?aWt4S3psUmVIRmd3MnZ6eHBWVTNWZGhUQXVBWVdad0cwTjdSblNtOVRqa0ZQ?=
 =?utf-8?B?dm9YWk82WmY3eFlIbmxlZDVFcFZ0ZFpZWUVXMnNBQ3FobkU1eHc1YktNcmJE?=
 =?utf-8?B?Q2xubWM0RzFDN2VWZ1dYN3g3Zk5DTHd0cUZJbFJoSTJvZVFPV3hvdTh0eXcw?=
 =?utf-8?B?OGxHUnpUSTNOeHcxL0YzUWltQmxFWTVQN29sRUtGVjd0YkNKSmxVbldrQ3Ju?=
 =?utf-8?B?MmV1NGUwOHJTSzVqd1BiM2ZJRG1PRTJRTWhFZ2w2V0ljMlBIQmpBUExqMHNo?=
 =?utf-8?B?R1Y2TFJmYjZxMVdSa0xIMm93YkJJazZnS2M0enZzWE9nMGZ3OGlKWHhKVVpp?=
 =?utf-8?B?UzRWRWJYZE5HZ2hpcTBBMTd0dGxRMTZ6bWNOc09JS1VJVnVOR014N2FRYXc3?=
 =?utf-8?B?dnl2SUlENEpLZzBNeFVHL3RwVDVQL0sydlRuUnU1UCtjUEdNa0RCM3BEd2hr?=
 =?utf-8?B?M0RUVnRDQU10aElZNFVVY01hSUZNM3VySkdWbm9Qd2x6bDVCL0F4by9WdGEy?=
 =?utf-8?B?MlprOWZmLzBwclJMdUYwU1paUlBoRUc3eS9hTktMeEY1d0RsL1laRERyUDBF?=
 =?utf-8?B?ZDhXVjJtcVQ5ZDcxTGpQZlNiWFp4K2EvSG9oTE1DaHk4b3pUaGFYb0E1SlAv?=
 =?utf-8?B?blZDLzhDZE10aTZGb0F0V1h0djd6VDVBY1NhZ0RVK2xkc3NMaUxxMWJJVVNR?=
 =?utf-8?B?TkNYN3M4Z3dZZHJSTCtmM2JDd1YrU2owNk9vaVRpVWpyOUFBZHBFa29meEdh?=
 =?utf-8?B?QmNKRTBybnlKeGZ0dCtyQ1lLNE8rNElhaXBhUVFmR2xsSzdDdGd5dWVoNmFw?=
 =?utf-8?B?WEdtK0ZjVy9mVG83ZzAwS0VoTmhuemtPK3BIOGN0ajZIL1VheDY3LytoN2N4?=
 =?utf-8?B?dTF1N016VUpmZU5XNjh4aDZ4VVVTUDRjTFRWRTh2N2ZXWFh3OWV3VWYwSkpq?=
 =?utf-8?Q?M5k0Ajw7SuDWUyRVSO0t5yC3JZW1poBb?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MU5tNC9nV082TjJ0V2V0ZkhFdUV1d1Ivd216S3RlZ2pVRTZOS0lxaU1RcktX?=
 =?utf-8?B?WlNiSmFmaG1TMlV4aU1OZm90eEI1S25MTDZKSEpPZnhSOW5LOG1nV3JvczVJ?=
 =?utf-8?B?d01tNnRwRFErTkdnUDQ1SjFJdEdXY215SkRYTXFXUklCK2F1MUxJRDhRem9o?=
 =?utf-8?B?VmhTRE5FZ2MrTjd1N2lXM0NkT3p4THRUTzNqVVBTdTVDTUNLNTIwWEtWWnEz?=
 =?utf-8?B?NjdqMC95SFk0K3Vjdi91QWRkUlc4Y3I1dVZnZExFaGI0WTJnYkpFSnhaUmtJ?=
 =?utf-8?B?STVtdHJGTkNDSFNOVlA4OTRqTkxKWGZBQnQ2RFl5RFcwN0xZQU9ock9hcUQ3?=
 =?utf-8?B?RjBYNGZxNWZJdlNXZUpkV2lEMEdMSWlHRGlVLzBidDhHUnFiTEprTVNLRUY0?=
 =?utf-8?B?T0J5OGdBVlFjd09yb3R4Y1lSQVRObG1qRTBuWWh5ZHpQYlY4SHp3bHhkV3hW?=
 =?utf-8?B?ZmRwb0UyU1A5SVBJTUVDUnB4ZXYzd1NHV3pFTGMxMU9CL2I2Q2hxUUEyL1Bt?=
 =?utf-8?B?K2c4VC9xVEt5Si9Kb0I3WGxFTzNqMXU0anFXKzJXUUxkTmo1RVJWcTFCcjIw?=
 =?utf-8?B?SUZQT2NCcVg2cVlPakNadUJQa3NQUXE0b2RuNGRqR3Erdm50MytLSTFVS0ZI?=
 =?utf-8?B?eG9CQitJcFFIRXVabmdFWHpXTXF2cWgwQWJHbC8rRCswdWMxYmN4WEQvMmNj?=
 =?utf-8?B?M0xXM3Q3TnpCS1pFQTVTbThjUXVpck9mQ3dCNGhJL1UyYmZIblFBaUluaHBq?=
 =?utf-8?B?RlArWXZKTWFjUDRTMW5PWlBPZW1qKzhobmNXVFg0VlpBOUR0TG44TFk2WlFT?=
 =?utf-8?B?TnlLbTRQUXpPSzBMNUNWYVZxUTFSaDhaYWFUNjRKWGpPT3d1Mm5rZ29TSUxa?=
 =?utf-8?B?Y2lLaCtIZzBZZDZCdWoreXNaNHdESFdOa2xCa0RBbHNqTjZJaG42dWtTZWpY?=
 =?utf-8?B?cEpybHZSalloR203S2NyMHFzLy9FNW1DaG9vVEQ4T25xczlXcTFBc1RVTDIx?=
 =?utf-8?B?a1hYYTFNYTducm1hVU5UKzBhVy9wOGNhT04vTnJWeWhtSm1UV2w1TGtYSWJ0?=
 =?utf-8?B?RElkcUQ3bE1BRS9uZ0s5ZXlaUEhneVJmVmVycUM0WUoyWGxGNmNIVmZMVXpn?=
 =?utf-8?B?N0lYVGxCOFJxSk1QaGRISCtGV1dXaWl4bjFqcTR1VU44cndGRlhTQ1Z4Y0Fo?=
 =?utf-8?B?VkJ4ZE5RdzFWMU5RaDJQdUg2RHgvZ0hWd0FQdGtrU3kvREtpTlhrUDF6YzF5?=
 =?utf-8?B?QlkrTktzZVpQNGdVczVxMWdZd2VCcXUvdmttVmpNdGhkWG9GaUx0YzJFNXJ3?=
 =?utf-8?B?NldVa1UveE1GSGlxenQyV2dKQTd3S3FvVVppVm5vbnEyUytZek8xWU40WlI2?=
 =?utf-8?B?N1JEcjc1L0ZrYzU0Y2FMR0tpSmI3YVVROG1QeEM5U1NWOGxtSk5mZ3ZQb0hn?=
 =?utf-8?B?M1hkUEx6NVZBM1NtOVRvSkRDS2pXWUpMS29mazJ4d2hYMk9VbFp5UU1ES0Np?=
 =?utf-8?B?U0dOQkxtN3YvdDYzenRYNmRsZ1FIRmV0bFdQbEJjakxlekdlQk9MYjRob3du?=
 =?utf-8?B?bWRsQ0U0TG4wQjE5TGY0NUY4N20wbGwreEFJNzErWUJjWlFTSEM1dXlUSVZj?=
 =?utf-8?B?R0dnRHJVcUpxazk2ZDFpVFdNeG5NZ3lLMWdvVUdhUGk5SGhDc3ZERjhXYWdT?=
 =?utf-8?B?eHZTdmliRVIwby81bXo5NVNWYThYMzB5UURmeVRVbGV2RDA5bWE5czNhT1pF?=
 =?utf-8?B?a1lLYWp1LzJFWmgxbk4yb1dHTWFmcjhJVWI2YjhWSmFjdkxCRWhnTStTYWZD?=
 =?utf-8?B?dHBwWXhIYkV2eTFZcG1TVUdVQUh4ZTQ1am8yR2ExQ0syZ2FQYkF3MnZneXIy?=
 =?utf-8?B?aHovNVIweVhPOC9YOTYyYWs0NUk0cUxLa0NkL2JBR28vUWVoTGtLRDdDNERM?=
 =?utf-8?B?ZTYvZG5tRGJFQ3JrMElRcUwzSXc3Yzl2YkNPVUI2allJbnBVbTNRdThxTmd6?=
 =?utf-8?B?am9QVDhRRjU4WjBzcktVSUk1MkFtN1J2SG5hV3l0dnhIdGkweWI4Y3luWSt0?=
 =?utf-8?B?dHJnVUZLT09mcVFTbjl0dU1SbGdybDNGamVFZCtXT2JXSUJ5YmdjVzdNZ21M?=
 =?utf-8?B?YTczOWpxY0p4a3dpaHdYN3I5b1BJN1JtOHhUODdtYWJYQnkvRDBKeFZrOVhB?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C85B795072E36847871CE44E4C4CC361@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f32a0e8-4ae7-49b6-2d27-08dd824baa36
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 09:46:04.5963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1J0IgyLblcFQXaCi2lSeFQRg8JIe8QlvPjmEX8ek0kSEPKndZFN+CV3erMj3C8PCa6NYd0IWL8KyFIUO/9HVmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8834

T24gV2VkLCAyMDI1LTA0LTIzIGF0IDE3OjI5ICswODAwLCBIdWFuIFRhbmcgd3JvdGU6DQo+ICdD
b21taXQgNTAwZDRiNzQyZTBjICgic2NzaTogdWZzOiBjb3JlOiBBZGQgV0IgYnVmZmVyIHJlc2l6
ZQ0KPiBzdXBwb3J0IiknDQo+IGluY29ycmVjdGx5IHJlYWRzIHRoZSB2YWx1ZSBvZiBvZmZzZXQN
Cj4gIkRFVklDRV9ERVNDX1BBUkFNX0VYVF9VRlNfRkVBVFVSRV9TVVAiIHRvIGRldGVybWluZSB3
aGV0aGVyIFdCDQo+IHJlc2l6ZQ0KPiBpcyBzdXBwb3J0ZWQuDQo+IA0KPiBGaXggdGhlIGlzc3Vl
IGJ5IHJlYWQgdGhlIHZhbHVlIG9mICJERVZJQ0VfREVTQ19QQVJBTV9FWFRfV0JfU1VQIg0KPiB0
byBkZXRlcm1pbmUgd2hldGhlciB0aGUgZGV2aWNlIHN1cHBvcnRzIFdCIHJlc2l6ZS4NCj4gDQo+
IEZpeGVzOiA1MDBkNGI3NDJlMGMgKCJzY3NpOiB1ZnM6IGNvcmU6IEFkZCBXQiBidWZmZXIgcmVz
aXplIHN1cHBvcnQiKQ0KPiBSZXBvcnRlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRp
YXRlay5jb20+DQo+IENsb3NlczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzdjZTA1YjI4
ZjVkNGI0YjQ5NzMyNDQzMTAwMTBjMTQ4Nw0KPiBiZGY0MTI0LmNhbWVsQG1lZGlhdGVrLmNvbS8N
Cj4gU2lnbmVkLW9mZi1ieTogSHVhbiBUYW5nIDx0YW5naHVhbkB2aXZvLmNvbT4NCj4gLS0tDQo+
IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCBk
YzU1Yzk0ZmE0NWUuLjFjNTNjY2Y1YTYxNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC04MTQz
LDcgKzgxNDMsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmEN
Cj4gKmhiYSwgY29uc3QgdTggKmRlc2NfYnVmKQ0KPiDCoMKgwqDCoMKgwqDCoCBkZXZfaW5mby0+
d2JfYnVmZmVyX3R5cGUgPQ0KPiBkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9UWVBFXTsN
Cj4gDQo+IMKgwqDCoMKgwqDCoMKgIGRldl9pbmZvLT5leHRfd2Jfc3VwID3CoCBnZXRfdW5hbGln
bmVkX2JlMTYoZGVzY19idWYgKw0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqANCj4gREVWSUNFX0RFU0NfUEFSQU1fRVhUX1VGU19GRUFUVVJFX1NVUCk7DQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoA0KPiBERVZJQ0VfREVTQ19QQVJBTV9FWFRfV0Jf
U1VQKTsNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIGRldl9pbmZvLT5iX3ByZXNydl91c3BjX2VuID0N
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRlc2NfYnVmW0RFVklDRV9ERVNDX1BB
UkFNX1dCX1BSRVNSVl9VU1JTUENfRU5dOw0KPiAtLQ0KPiAyLjM5LjANCj4gDQoNCg0KUmV2aWV3
ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
