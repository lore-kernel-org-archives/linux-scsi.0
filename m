Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC93A1A50;
	Mon,  1 Jun 2026 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780308423; cv=fail; b=MlA68kAwbajzWs8rMnUEc+UY8Zrb5DY1l95LyNn/fmnxiuNOtRcruwwGlgEnhh4Ua/mXEI2GT4ZMSjhmfOB+RncgZdzJtw1AFiZ1vpj5MfMFNz9ovGTuHopu4owXRKQdrGV10oOxklje/j8UUe06h69Hv8sBbMr+xybh0D+Aypk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780308423; c=relaxed/simple;
	bh=TIYr5+xj//T7xECbsD++8S8MG+MXfy2V1deYvQdLUzw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=loQ/UzEid0W3yvH8x81S9w0b5/pzksYhQZANamV0MgMWASo/rPCbFEWAEGBHHJYoYROY+G08tKhO2XAT4QTA8dlvoQ1U7kC4rIMvztCIaUO/c1cKiBN4hfNOMPSDtfUlWSJXgcPffvvZX55CV8wXxE+TddD/GHHiELfaBqjZL/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SBaOukAp; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=m6s+/PfM; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SBaOukAp";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="m6s+/PfM"
X-UUID: 99de890c5da111f1b1788b6acf885367-20260601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TIYr5+xj//T7xECbsD++8S8MG+MXfy2V1deYvQdLUzw=;
	b=SBaOukApBqKBrF1473Wgb8HxwwQ53xk6ck7aDOkn5Qb/peh4zhXJ/hg11o8k8bu9sACcyO9QpZtoHZpxtLO+zs/ZObvzD0m9+1t1OYK76xNktfX63pkLw/2INyc3QrPgEAxKU1BVMcQWAHAifMMCAxF4zHq3b3GEZA2MgADvqQ0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:2564899c-7d3c-4134-8b73-67e2ffdaa41e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:64e7adc9-9273-4096-a0ce-fc7a6a4f85f7,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 99de890c5da111f1b1788b6acf885367-20260601
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 626371841; Mon, 01 Jun 2026 18:06:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Jun 2026 18:06:46 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 1 Jun 2026 18:06:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0Cpda0avlQkkMfhOYjZFHxoMGBYpKLTKriLa+gKc/e1E1GcCAx8E3dpOyR5Q+TkufKOl8ARt3Et+yUuFFgJBZwFFxEE8tCfP6OepX/EC8r1/zjIi+poOOcG2rlIqmaxtnUpYi0K8NaWIZuU/X+H7Vv1nWNCUFd6sWhL90cfHwDVibnBmuMXtkatBH11im+zXPmTA3Co6EftxnloJpTt/ggFgyx+pLKKwPDHx8jTdmsZnf/lsjGBaaNtZ82Pn8VMbaQ+MSWJJOPUVY3FzPuB7THiM8NNumGd3gX0lvudRdffmr86Z7uUmMtcu3+NrnDMdMtyrQj5XMCfe4dEaOipQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIYr5+xj//T7xECbsD++8S8MG+MXfy2V1deYvQdLUzw=;
 b=TCY+Bke92EQLrY+OdhvEEPme7ARGSNGwHd+gVqyxFV+oX27MJ9aZQXGcyaeS7qoSKu7Pq6FGQNqWQia78xa+3uSHX3Di0CdmwSzgTJ4iEeKEhuYzJp+FUoVM9/9qs2ddZSfaQKztF8yjpDXyigV7ntt48sc1uGi8k6A78s7bLh/roRbtgLp6dgzZVleFIE/kADwKglD6rG6ds/yeqrYtv8RZGbgb7/EVqGCf8mJ6ifN82M+b3ltIA/GmURLKlZ1W4yQpIE6qUOVMuvf733zre5sRhAwj7XLaBdOIDJdniQRLr0XR7sQpZ7NtxzFi2rDne0ryuzhClgmEoom/rnuEFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIYr5+xj//T7xECbsD++8S8MG+MXfy2V1deYvQdLUzw=;
 b=m6s+/PfMrrRV/xbIgglvCy/UOjYN2aN8WMzOVhGfef3uOWVA6PhJ4ze/DTf2NXLAn2tkNKrxKvNQHlXl1x+Vo5I8la/1L+zJ/nNCmJ/nNX7ZzonfKZ6InFqCoUA3zHQOIqU1Rw4dodCrfD6CkpKbzGEA8xGes8jZXmpFqfD3OGI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU4PR03MB9831.apcprd03.prod.outlook.com (2603:1096:d10:7b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.4; Mon, 1 Jun 2026
 10:06:44 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.005; Mon, 1 Jun 2026
 10:06:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "hongjiefang@asrmicro.com"
	<hongjiefang@asrmicro.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI EH
Thread-Topic: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI EH
Thread-Index: AQHc8YM5kTD4w00lK0W0zHRuj40B8rYpeauA
Date: Mon, 1 Jun 2026 10:06:43 +0000
Message-ID: <c3f4df6820edbdcaa04622f7fc06fa706a685163.camel@mediatek.com>
References: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
In-Reply-To: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU4PR03MB9831:EE_
x-ms-office365-filtering-correlation-id: e06cc202-9e0b-4824-5306-08debfc57baa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|56012099006|11063799006|5023799004|18002099003|6133799003|22082099003|38070700021;
x-microsoft-antispam-message-info: hmS9EzS8pzjnS4kbaPzAgWIGvJc4nXqoenwLxypcX/XuTD/aJ+oLqvHb+xoZDIX4zoRS2h0Y7DbH/n6ao6zDsMxs1vHXJ8Qj4bWQeHHJxiWLSYmmmp7FLKX+BaK5l9dmyIm6VBGYel/uK3hbAkPBgirGrJx8gHOQfyGHout+ZeJX5UBa+ok3tNB0Fm8PcsrGfcqXUSKU0NaO/SHzXz0LlnDtvm0d8ZZaAyABioXJI5cEDrw7+Ayox8Oqt/b6onwm/kZ+6Ha0GUwVG+vNG4WiFxTEuFY0t8X8WxVjHXgaRDmbFpU3RYy/Q2wjNTz7IsoFI9zFntEPx8eVbwzB2ohI9PQUbEh2ZEbt4CqdPSHnEd8DQpinDqcO44sR4YmsRZCw9JAY0kS8rnlDykmEVeEMqiJleRIjHS/9moSR4yJ6RsA5DExFHqfi2Y5R6VUPrHZ5mr1k2Zg4ctjJTnKkdBVuWzoODubqVBDnc4Gu95VwFTs4+v3CBzE0aoDTivbc+Xk35GiJ0IkYY/U6Ed8ReIgPERzBxYHGW6QAGfTQI2Y2jg6KoJZbCNUMSYutcLEvPv5rZEXgIIXUCp5NwXTSdm3rNvA6r4Ix85c5RwcLAdWo7g8g+cKUuiP553fZVGHc1ZzBWhnowFn5pkKXe373whsQUKsrKW/WEOwNeTFPMQazb3I/u/D6huTLp0oLCGv8b/bYzNaYDyIJWTOF6VpS3+dAXFhVgLr4hgF69CwvF63joJOU6bVQAKWAU+qM5NdHETR0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099006)(11063799006)(5023799004)(18002099003)(6133799003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2N3WVhOb1Z3dENLYWlaVzYrZG1xSkU3OXk5MzBScE5ZTThPL0pub1M5TEts?=
 =?utf-8?B?ZHpJVkxveHlkeDB4WmUwQm1nUm1mNVNDZS9QQW1JR0NHUU83OWVDQWlXcXVL?=
 =?utf-8?B?ejdXczhwdU9lNGZWYjM3a092NjdOVUxCVk03MmJmeDhVakxzMFFDQzR2ckxP?=
 =?utf-8?B?dnpPVmg3ZkoxRFdVTDF3dUdRRTlCTWY1ZmtkZDBGRnZEdXd4WWlJRDk5Szl2?=
 =?utf-8?B?cUhOVytLN1J2aU9DYndjWXBLYTVla2pwUS9Fa2FKclV5M293bFBpajYydXlp?=
 =?utf-8?B?bVBvSmJNcjdUc0J5cVhUUlZSUFdxOTRRd1VUbVVRQU5RQVAvQVg2cXFrb213?=
 =?utf-8?B?UHpBMW9ieFpkUDh1SndPdytnMDhJZFBHUUE5ZXJxT1VJUkJjSnQ3eDdSV3Zt?=
 =?utf-8?B?dEZadXM3N3JwcDBGbFk0TUJtME44Qm5Scmc3L01sVjBRMjBSUUR5VmU3a2pS?=
 =?utf-8?B?MllYWVdIYU9lYm43VGtaL0l4a1hUczQrQ05ZQmp0WTVJbHM0NDdlSC9EQkJC?=
 =?utf-8?B?eVV1OHBZN2VJMUFBdlo2dTllNDNJT0R2UXE4cHpISkhLTzhNT2pBSXJpRHNM?=
 =?utf-8?B?SVJLb0NOT3RWQ3c5a3JMRytqQWl2dGswSDJOYXprZ1lQZEg2Zkc2d2lKR0Yv?=
 =?utf-8?B?VlZKWEZmR1NNdnppOU1pMnVLQ1BpUm1SbVprdmJxQSttOU5tc0YwSW1aN0pt?=
 =?utf-8?B?VERIL2RKbmoxM1VBejJKTy9NUVFHSFFYSFJVYXVjRUdEODBDa1FleGNBUjdq?=
 =?utf-8?B?RUhIOE5ubGFzYlR5U0krWVhVeEgzcjdwME83cHpWc0JnTnVGNXdKalUxaEZ5?=
 =?utf-8?B?eEJvTjF4SmZTVURqZ204WHVYLzFnVUZYL09pVVNFSVowMC9ibUZPbUJVZk9E?=
 =?utf-8?B?ZE5pN3c1VHNMRk45YnJnVWlhbUNzL1BQaFBCeTZLRlZIUlQ1bThGLzJ6S3Vk?=
 =?utf-8?B?VG9IUmd3Z3drUkZ0ZlJscHNselVkNldlQ3RobjZBakJKZnM0a0hXeTR2cGRv?=
 =?utf-8?B?cHdNUkpPL0wwUWEveVUzUXBhQW9HbThCTVlwQzRwRnZNNUk5MG82TUZjQmRV?=
 =?utf-8?B?VFJBdnJ1NUxtV1lNbDRTNVo1czNIRDZab1FhampNS2g2TkZGOE5JeDYzTGdj?=
 =?utf-8?B?d1pZbHB0cGR5RS9QcW1ES3FhWTJ0QldBaTY3MlRsdkdaV0h3OHgwMSt3L0t2?=
 =?utf-8?B?L1g3OUtMM1RnMEVpaE1KWE5TeDVURVFibmlaSHJGRjFmajdkVEdHcTBsNnNk?=
 =?utf-8?B?SWVTeTA4T1ZKSXVaMlcwY0dWZjV2alFQZjNTTjV3akhZOHQrWm85SG9QUk1i?=
 =?utf-8?B?WkgyQzNqMDhtVFRGRHpnWnk2SEpGaStTYm5ncjVVcUhZcEVvREcvcjZJK3RN?=
 =?utf-8?B?YlZ4K0hRd2F5VFJYRnlTeVArWFJkMTBuYldhZEZpZG9lMUlPVWs2bnFTclVw?=
 =?utf-8?B?S0Y1dFM0SW14WnA4ZmhnQVc4SlQxQkxjTWxJSmVrcnp0d1E2WXZ1VkN2WS8r?=
 =?utf-8?B?Q1dFV3djSWNXTDhZMWNxMEFNYkZYZndSN0gya1QwVzJOZnJBZmNEcDhTZWJt?=
 =?utf-8?B?eXhSalJYT2ZvVTJvQXIybDk4Vk1xc25iZS8zWVd5QnJRWVpGYklsVWlqcERx?=
 =?utf-8?B?YkVPbjhpWU9heXN2NmFNUUNmRTRHUGN6UGVrTVJEcW9yS1FlL1ZnSFE1Tmsy?=
 =?utf-8?B?UkhZYTExaGNZOVN3MUhEMlFVV0tJYURoaW1mRzgvNmphMHlGbFNabHlHYnNH?=
 =?utf-8?B?OHJDOEdIc2E5Q0xqNWhOZWZsSU5vOXlCTitxT0Z1b01ya0lBY3d6b3J0TWQr?=
 =?utf-8?B?bWg1cnhtYldlSCswWjhKbFMvLzFuK291ZHplSkZqNkQrR3NCcmxEWmF6b1lO?=
 =?utf-8?B?V3RYTDlESTM1V05malRFT3hnZzRPNThmeHdBUEJCZk81ZDZZRHJTc0dkZDFC?=
 =?utf-8?B?TUtVU1FSdWlVVlFmRDJRUVVyMEhDZWt6TkRwWVRHNTNEWk84K0pUdEQ2Zk4z?=
 =?utf-8?B?NUZiOWt0VnVJRmpRZXBqKzY1QXBuWk1yNXdmZFVoaDFGK2t3cmdjN0JGVkVo?=
 =?utf-8?B?LzJXdFgvOHkyd2doSmtvTzF3Qk4wWFhBVFpRZnliQlJkdE96RUQ4MHBZSTZS?=
 =?utf-8?B?UFFEeGhlMlJJekFFSmgxSFpxSVlnMlE4KytEaVFyTVZORE9pdXprRXBWbmp6?=
 =?utf-8?B?bWNkV3J3VnlEdGJWSnQvTEthR2VOZ2EweU5RUlovNEsvUU9TUjFLTHowelB0?=
 =?utf-8?B?T3dLVzJuV0g1bjcwZDBBaGZUekdDVzY0OXkvNWdpOTh3N3BPcHJCTUtTaGJR?=
 =?utf-8?B?UURaREQyaHJCVFRXUXFabU1rWWI2V3JTSGRKaUZidmNsNTRTL3pSd0pGSmdy?=
 =?utf-8?Q?PLt4iZG94x+ba8Z0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBAEEF921D3AD64E95A84498B8C254E9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QB5UqVZU8kQMZbVF1sXNVn4vdsKYUHMvOMkkhlOZw+an1i6r4ozjW3ul0JMGkn6tJux9fQBLoLE54kKCibWej/EjCivvpZg569Jq9LIWKmT+n0lzRXhMjb+3Ms/GLDRZm0Sg9P/CCFv2kkjAY98TjQ1E81appkFFFsM3It+ENkbCYyVEx83gaDxd9z7SNdyzzc4Q3cDTjH6YhnOZWmFQkKqpvMBnnKlVDMyQK8mrfLXbDStE6oRSFI45skM0TWUPSE6N6nDypmCTOUDS/36Q9ZUZVb2/XKfUA6zp+b4n6X91OCMFvnbKSynwpWF9SgeVl9aon+x/ibIFgUFGCTCxOA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06cc202-9e0b-4824-5306-08debfc57baa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2026 10:06:43.6963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dl2uO+A4b1JoCo9lLLMcA8pT365zr/J/UH8P34p7cieJhwdG2GohFTuiANc4OHdz6G9lhYnEizUnNX3dio6NkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU4PR03MB9831
X-MTK: N

T24gTW9uLCAyMDI2LTA2LTAxIGF0IDEyOjU2ICswODAwLCBIb25namllIEZhbmcgd3JvdGU6DQo+
IEBAIC02NTE3LDYgKzY1NDgsOCBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfY29tcGxldGVfcmVxdWVz
dHMoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgYm9vbCBmb3JjZV9jb21wbCkNCj4gwqB7DQo+IMKg
wqDCoMKgwqDCoMKgIGlmIChoYmEtPm1jcV9lbmFibGVkKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdWZzaGNkX21jcV9jb21wbF9wZW5kaW5nX3RyYW5zZmVyKGhiYSwgZm9yY2Vf
Y29tcGwpOw0KPiArwqDCoMKgwqDCoMKgIGVsc2UgaWYgKGZvcmNlX2NvbXBsKQ0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfZm9yY2VfY29tcGxfcGVuZGluZ190cmFuc2Zl
cihoYmEpOw0KPiANCg0KSGkgSG9uZ2ppZSwNCg0KV2h5IHdpbGwgYW4gU1NVIHRpbWVvdXQgaW52
b2tlIHVmc2hjZF9jb21wbGV0ZV9yZXF1ZXN0cyANCmlmIFNDU0lfRUhfRE9ORSBpcyByZXR1cm5l
ZCBpbiB1ZnNoY2RfZWhfdGltZWRfb3V0Pw0KDQoNCj4gwqDCoMKgwqDCoMKgwqAgZWxzZQ0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCho
YmEpOw0KPiANCj4gQEAgLTk0NjYsNyArOTQ5OSw3IEBAIHN0YXRpYyBlbnVtIHNjc2lfdGltZW91
dF9hY3Rpb24NCj4gdWZzaGNkX2VoX3RpbWVkX291dChzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQ0K
PiDCoHsNCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0X3ByaXYo
c2NtZC0+ZGV2aWNlLT5ob3N0KTsNCj4gDQo+IC3CoMKgwqDCoMKgwqAgaWYgKCFoYmEtPnN5c3Rl
bV9zdXNwZW5kaW5nKSB7DQo+ICvCoMKgwqDCoMKgwqAgaWYgKCFoYmEtPnBtX29wX2luX3Byb2dy
ZXNzIHx8ICF1ZnNoY2RfaXNfc2NzaV9jbWQoc2NtZCkpIHsNCj4gDQoNClVGUyBpbnRlcm5hbCBk
ZXZpY2UtbWFuYWdlbWVudCBjb21tYW5kIHRpbWVvdXRzIHdpbGwgbmV2ZXINCnJlYWNoIHVmc2hj
ZF9laF90aW1lZF9vdXQsIHJpZ2h0Pw0KDQpUaGFua3MNClBldGVyDQoNCg==
