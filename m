Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519F43AF667;
	Fri, 29 May 2026 09:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045785; cv=fail; b=MgDa79Y0p68xH3XmG+1tEs/hALPfSp3mjqpob7Amoa6K/bNPqyrvC31eAap01CG9PE8rwQQlRBCLZQQNbtP//L4jucstIyRQYBBipBQu1sj+5u4dNgTWiCzE7atv8akhKPBcqykdXdfnQjEMtbmb3SqryxEPshDk9Y6JWIz/m9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045785; c=relaxed/simple;
	bh=akiL+i8CiY8roHr16P5l8/NTlzB7fllQn3TCjdCE72g=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XqwqCiBBSs1mrPsrF4pliqYZllWO5YZwmxi3wpkZ7Jyck6tbFbL4Erdkuev7MLuRHA+miGWteDzbvTzIs8TJd56e7C+SC0cQuK6Q1jTXvbNQOsyiC87rGL0MpsxbOefY7xtMtka5kKkC3U8ytam7IMgjnNhhyNmWqjDziSKY5PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VH4NNjpd; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=QlIIwWgb; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VH4NNjpd";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QlIIwWgb"
X-UUID: 1e488adc5b3e11f1b1788b6acf885367-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=akiL+i8CiY8roHr16P5l8/NTlzB7fllQn3TCjdCE72g=;
	b=VH4NNjpdcdUrQb8XiESzkcGXhiBaiMCXU8PvFDqiEq94H6Zm4i8dL+hDwqQSGWKiJ0+arDzYjR5sHPeauSPrSJlkvEr9E/OeNoM2CKalcPNXBSaiqfH8vktJwO+wJR7jSZuGorvLaX5Z1jVFfo/T8Wp3nB8x8Unxj2JxV8/hpA4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:8b37aa1b-f6b3-4c52-9d6d-02464e409088,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:435b4501-8ecf-400f-ba4f-4c5e0901de3b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1e488adc5b3e11f1b1788b6acf885367-20260529
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 113361183; Fri, 29 May 2026 17:09:37 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 17:09:36 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 17:09:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBf0FvhhCB6u3uFp2YELa0dsBmiKoTkimEdqfU2zaM6ClTjq2XeV7tk5wvCvAHwdiAV5pZmYFhJacNDEnjtArhnlso9qnTYgRTiOkSKUc20mAPmBoy5L8cztCf6KsPO3ign9dk4KZi9oMqYnaMoPkg6bPKqGT9OLbryYGMrZPPrbpGjmmZsXU2fmgY+bTUd98By9NZn4zH83a50wJyTdD/O4QDSO5hJL9jfD0QAKK0QXjJcwh8q3Sv/XT24LB83pBO49SnudW76b+cpgfWkT0oK6SQhVyBiEgsv9NlREFMrIlD5m+si7xiX11rOox5ar4hTc/dCjYwPZtNpegfEh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akiL+i8CiY8roHr16P5l8/NTlzB7fllQn3TCjdCE72g=;
 b=OfQtX2mepf9PERRp5Semxyf0pHBu1IpbVVHGyToMVh28ORBSm+ncC7ecmpOKBrL0ngGB0BwDOsNZ3TuvdVW4m1Rwav8//0bqZJ42aavwVR3q50wSHzi+qBAlpwhmyb08aHu0qxNUSzpOI8aXdRmeU5S607Hc9mmxSN0x7juyj6VUIWJYMME6C9YJXMGpRFLtCYwnPxWolJcqFlOeQH/oB85qohLtIFh43vXkYXsEJ3LW3dn3Xyvs2dRqEw4tjwbrRRnWP9QmC5fjrSSFvLIFtN+X9gayk8qr+GQxNSfnw72b8xfgbd3XS5eFdl9kOu9vqgsS+1MdOAUSFnGsL0DJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akiL+i8CiY8roHr16P5l8/NTlzB7fllQn3TCjdCE72g=;
 b=QlIIwWgbFUZhAfnkEv3hwGu+8O0mL3RcLUZXQlDpOe9uhGQ3BbVjkMN42Y/F1N1W//7cLCzTD/Cz/HRbtlnui3xI+HAHl86dvR4aR7181vayE3kk2sveINQQ729+8QS5p3+otejE2O2gTB3kcBJCBksYUFg8LkBXK79lgKqcNuY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8740.apcprd03.prod.outlook.com (2603:1096:101:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.5; Fri, 29 May 2026
 09:09:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 09:09:33 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>, "cw9316.lee@samsung.com"
	<cw9316.lee@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
Thread-Index: AQHc7websQasB6rn90u7mHW8qJZGObYkt6kA
Date: Fri, 29 May 2026 09:09:33 +0000
Message-ID: <ef9303ff3cdfc1f8c37f40740ca5e1619b82b9c0.camel@mediatek.com>
References: <CGME20260529010749epcas1p2bf38209e55149f0681550c220e541e92@epcas1p2.samsung.com>
	 <20260529010739.295391-1-cw9316.lee@samsung.com>
In-Reply-To: <20260529010739.295391-1-cw9316.lee@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8740:EE_
x-ms-office365-filtering-correlation-id: 508f6e0e-e7b5-41ec-2cde-08debd61ffce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|18002099003|38070700021|921020|56012099006|11063799006|4143699003|6133799003|22082099003;
x-microsoft-antispam-message-info: mRyG/bJygHJNVGw1ygpEwkOIMrorIvaG+v+r5FLXa5yJox/w7d9N1B6DJh0QAmB4NibNHn5BlYF6V2VOZSKPRpmdOs7y82tX/lZ75z2+8fde5kYj0y8+KDKLxwTBxVdUYlTgKUZlVNDBVKIFauBiSEYI94WF5daH8mj1ROiNmHPrZkFbR4ZAbjsdjiYbFgs+e5QW/ZBgGKI8/EmfeRkQTG7jeC/BVLCJHNYD5+wL00TcosbkEkeIrhlrjUshyHj8QXRlu1Dhas5YOgldKryKX9GBC9Zl0uNROIxyFvpBq+V8XcUHU9vLw7xIuecYd6c9tSMcMFJf0K+vdEl0zKoqQqX4wq0sIVgeQrFqXFwqjKJ+YMNPRST0gtj8Quk9go3JfBsrd06pesDZkpUT4h+3hokTcGLWIAeu4tBHme71siVNEyLGTLLxZ0ZwkUlQSzcS4v8hxd/KpWhIQZ+gTSmeFDfewsQfQEcX7BBlEmxgjujTtxv7EgPtgi6llXGJlufghPFc9QBH5bQ0bKV09pJErMSh3ZnBPaOgs6BCUEZoobPtaKwrbIpHQW6iLgxLHubR8i9bByZJjUwTA+bmipRPVw+ViFP/meP0yIcJS/YS1tRMgFS9aH/RdNxdrvygRLzdjguLLkw7xn/y/NmVZWu4cfLMjo8cq5YWjXAsySbk6XIQ+YWNsVpmozGyCv9BjAiWZmPlUOHrkAzC44kWYVCHNQKSrGuGwRT1W0NNQo8aAsFp7c4y64bNoEc2Kl6VQERfa9haIbCp40pZ7jhsGApJEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(18002099003)(38070700021)(921020)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUlLNDNucDIwL280cDR6eHVzMVdHdmlwdlBVNGplUE9Zb3B5cU01cG5scWVs?=
 =?utf-8?B?K29KZk5YVnlkckUvdEdBVEF5SVVRdXpQWjFYSFcrQzdOWitGS2dYZ01GMXZj?=
 =?utf-8?B?Y0FBT1JLTzVCZDhybDJ4S3BKd3RjN3FiZjFMMjM4WmY3QmxWKzVvbUxGckg3?=
 =?utf-8?B?bkRMdThmZWVBODNCKy93bXRhcnZuSy9ST2ZTSjdCeC9QYkl0OHk3MGxmRHVI?=
 =?utf-8?B?eVFVVmVjOE5hMksxaXBxWSt2R00zSXkxUk1lWnJNcktmU1o3Q1UwQnh2bkRr?=
 =?utf-8?B?dCtERng4Tmp3VjJNMVlPRDBDOHJRRDJGQzlJZXFIeExIQlR0RkZ2TXBPQWxM?=
 =?utf-8?B?UGRObkMzYk9qMnl1eU1UaVM5cCsxY0tSZU5WSGd2dldhODRoelcrc2s2MklM?=
 =?utf-8?B?Z2NQM3BtdGwyZGhOd2huOW1lem4zbzNpNU1JVE5QQVJmMWV3OUpUQUZsQ3pT?=
 =?utf-8?B?aG01aXN3WVJyY3hHdlhqTS9jdkd4ZFgrb295c2wxcVVmZGpLRXFrWHpKbndG?=
 =?utf-8?B?d00rN0VLd09JdmtKKzNKVWI4b2RuQmovdVdNQkVBbGJxbENVRVl5cEo2L2RG?=
 =?utf-8?B?YkJYUFFDb3dsWW1VdTVaTTlocFFjNXh5MEZ4eFBOTmllNUxIMjVnTVFJcWxL?=
 =?utf-8?B?bWhaK3dtdmFVRjhtWGNtM3FkZ2NBVEVSTmsrMk1Dem55QVhRNEplSHk2TXhj?=
 =?utf-8?B?cFlzTWVXRnRDZ2lNemRmZDFwYStRRjZSNU9GYzBQdjY4bXAzZXZOaG92VHk2?=
 =?utf-8?B?RjZ3dVBpK0xQT1EyVEljekFYaEtuL0xmTEdDclZpU2cvR3NsaUNDemdBcng4?=
 =?utf-8?B?T1U4d0Z3Z3J6ak1xRXI3b2drMmd1MUdibklWUXZTcndza0RPcVBvbU1YdkNE?=
 =?utf-8?B?M2hXS1pDc2xPNjE2Vk8rblByMmcrRmpPYjc1OE5wdGR2d2orejNqMHdyc2pL?=
 =?utf-8?B?dG9zK25BSUhJNHE0RDYvbno4eXczbkZ3ajY0UkRCTmRZZURvcnYyd1NKdzEz?=
 =?utf-8?B?OENMWXVuRDJLR1VJZER4VS9IOWF2bUI0TEZ5NFdZOEozRTBQVHIxaThtVmlW?=
 =?utf-8?B?eE1Eems5YXo1Q0ExUWxHN0ZVUXUraW8xME9sRi8yY3RDa0VMQU1GZFJSd1Fv?=
 =?utf-8?B?TzBxckI2TmVUc1RQRmZTNzlWRnlDRXNxNHZqTHhXcU40Y1Q0VXhQU3Bpcm8r?=
 =?utf-8?B?TjRiKzBwUXdmWHFzY0RxTExlcW9KR1k3TnNkUURCeTVKalNLdHJVMkJDUHlz?=
 =?utf-8?B?ejN5QktTdWpoTFpSTHU4Z1NoVkFMdFkra2NTakc3dVVNWHRMeVRNUGdSUmd2?=
 =?utf-8?B?eDNKeDlOM0puV0JGMVZuM1hLdDFlVGU2UE9HeEZ3K0NzRUltZVJsekpRYlF4?=
 =?utf-8?B?S2EzQ2VoNjUzOC8zdkplbFpTL056a01OQmZmTHVHWHp3QThUdzV5ZlR0OVFm?=
 =?utf-8?B?SHdiOTF2a0pNSkNReDFSVFU1bEF6MWpWdW5wR0dhU05kd25SZWxweVdvUlVV?=
 =?utf-8?B?SUpIcW5weFhid1BJYUtWUXBGanlvT3dOcGZ1ZEt2Q0d5NUJLYWUrSDFWeVVj?=
 =?utf-8?B?cmR0bldOVUprSjFDWnVFanJVdk1hV0tXT05OTlA0WFZ2M1lORFJBSCt5aGYz?=
 =?utf-8?B?RDltdWoySlU2bVR6Vm42Z1FqNmdRcnU2cVdOaDM4M05oaVZ5UGg4MitjUkp0?=
 =?utf-8?B?N1hNOFQ1RFJmRWVmTFpzcG9EZTVjZlNqc3pVQ2g5OEVuUzRMWVc0bS9raklp?=
 =?utf-8?B?M2hQNGV0SUZtWFZRa29HL0tHS1JOZ1g3d0xzWHBhNW5IY2NEQnl0VmlCbnYy?=
 =?utf-8?B?MUQ3L0tvVXhWaWF2cUt6UTBZSnZkdGVjVlo3elk3VkJzTjFNVlg5N1JvMkxm?=
 =?utf-8?B?UlFMalpueFBaOS9ma1phN2dSOVVVZ013MmpFemp0UHUvK1FsZlRGT1R1L2d1?=
 =?utf-8?B?UmtOTWxBbEVmNEtzU2xyc0F3eGFGUm14MDBKL20zVjNFLzB1amRtOVlUWHZo?=
 =?utf-8?B?U2J4cWlyYTRhWlk0UEJjYWJnMUxETU5iT3BrYXU5eWdhNkJ6ZE5jZjBYNXBC?=
 =?utf-8?B?RFZYakMxY29xTHFwVEpraDcxa1BWRG9vckhKUFdqT21sSXhTSVhsd09yTWs0?=
 =?utf-8?B?dlF4eTUzeWZVVHpYWlNOaHV2d2wvRk1pckp1VUJETnNsV2IvYnpxUlQ4Qnk2?=
 =?utf-8?B?VUN4UnNMMmkrWXZvR0JWeGlRbFNYbEpFaTlFVkF1NzRXVmRTSEVoSkdKaUgv?=
 =?utf-8?B?c2NSeURUVEd2anMrRUprei9Qc1pUZjYyL2ZTSHYrbjkrWjUzUFZwNFBsaHlJ?=
 =?utf-8?B?YVhoQktlMDNEZmEvbjJLS0oxa1hEa1M3eDVacElNeFpmTEN5ajRCTHdmWkhr?=
 =?utf-8?Q?4H5EEqEDfhjU2cP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3532F8C18332AD409F877C252DACA0B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: nF1xkjDz7ObVdArBNaFYbu2gio26N61KiX0SsSbvGm7gqMhxDnaSDVRWrAvsaVT4lktH9VWAoV9AnYhSS1YbsYO0wBZ1DiOokPx3T0VNxCEk0JipHWSk46NEut7AuSjXh7KAY4rYeEncfg+doRAHKCbYgWNVr/hTwNelixZzct0JA9KkbJMHvgoGqott++olT+FrS3i8+gIKbSl8RY5vhkZ8nf9GdHUgAVEE71OdXjI2jDQDxkZscBZIN6UEMKIjVtIiL+pCxrXqPdtUqB+51kewtIcQPopdMWj6Li922sTEOM/MunnJRfxH2A7FJv2t0G7iyn4SYZ/fC+N6UeW63g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508f6e0e-e7b5-41ec-2cde-08debd61ffce
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 09:09:33.4292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFugePQaoL/8TD/brnbFgNdRpVAKw6K2FR8d32HzdzpXQyemmorT62LC6jVTnYHU75l+if0VfdiS0FoOAX3J2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8740
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTI5IGF0IDEwOjA3ICswOTAwLCBDaGFud29vIExlZSB3cm90ZToNCj4g
dWZzaGNkX3RhZ190b19jbWQoKSBtYXkgcmV0dXJuIE5VTEwgaWYgbm8gY29tbWFuZCBpcyBhc3Nv
Y2lhdGVkIHdpdGgNCj4gdGhlIGdpdmVuIHRhZy4gSG93ZXZlciwgc2V2ZXJhbCBjYWxsZXJzIGRl
cmVmZXJlbmNlIHRoZSByZXR1cm5lZCBjbWQNCj4gcG9pbnRlciB2aWEgc2NzaV9jbWRfcHJpdigp
IHdpdGhvdXQgY2hlY2tpbmcgZm9yIE5VTEwgZmlyc3QsIGxlYWRpbmcNCj4gdG8gYSBwb3RlbnRp
YWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLg0KPiANCj4gRml4IHRoaXMgYnkgYWRkaW5nIE5V
TEwgY2hlY2tzIGZvciBjbWQgYmVmb3JlIGNhbGxpbmcgc2NzaV9jbWRfcHJpdigpDQo+IGFuZCBt
b3ZpbmcgdGhlIGxyYnAgaW5pdGlhbGl6YXRpb24gYWZ0ZXIgdGhlIE5VTEwgY2hlY2suDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBDaGFud29vIExlZSA8Y3c5MzE2LmxlZUBzYW1zdW5nLmNvbT4NCj4g
LS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4N
Cg==
