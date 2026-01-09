Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E544E248F47;
	Fri,  9 Jan 2026 06:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767939547; cv=fail; b=uNpViSYDjWmrQ4ND7KIfQcsgH2Xs/2yKFMNLJOKGK5Js4dnURpCQa8Gko4TRmwcfbvHOxr5cD1M8Em4pequYETCh9uUca4BoJmgO/eIPgQmEvPpLGLB8qdefU8Npgy0K3VgcVdHSYA77Jo4H30JpDBYVm5z6jWQfTDA8+dqWYzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767939547; c=relaxed/simple;
	bh=ykGNuMd8b2D04hNrFq7rK9zP5/8CXzD/Czo1me2TIU4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DSIpuB75SYCVBYOAyXFthQDxnlWkRTITr718ei+24vbP7l27IUE8NQM5a/Dek+gyKfmUfPy8Nju8DUWOdtMPk+N41UCqyXRmbsV6NwL+zVg7OnPkVKMskt2B4g4wigMzLFxDqWJMdCKxslQKTdr8alhjFRzBbIWkj0DKancOCQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CXPEd4MQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Os8XmhS6; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CXPEd4MQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Os8XmhS6"
X-UUID: 139fdd94ed2311f0bb3cf39eaa2364eb-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ykGNuMd8b2D04hNrFq7rK9zP5/8CXzD/Czo1me2TIU4=;
	b=CXPEd4MQb80+awVmwtZWlv2WEPmMLISEXf7iIr1h33OaXzjxyvQTVUSVqBt7N4d8WkGLbe+Gv8EDEiKyeGKYr7LRDHuFiSYqp1X4GO36HNBrypRmKmvzMs/uovGsqcYkVnLoSxmLS1JLqmWHjuHRc9H38Sw4JySo3hx2fNBKLz4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:4066129b-cc4c-4536-9e15-7540481e6db7,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:441b9779-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 139fdd94ed2311f0bb3cf39eaa2364eb-20260109
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 370237830; Fri, 09 Jan 2026 14:18:55 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:18:54 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 14:18:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fhBicih4S+7e2SxfLHIMNTW8zRINGFwN9UvQft0QD8G5Goursc+XEWeSN1Fu3BazDs7mLC7gfKvIXRJ8dfs0FUXgltX0ld8gjGKGQO+Q8+GfmcfzxlBmH1nf1N/vkq5V5l6qyeyzU7UMLlsudxg72bfVDNUwMfPGOSl8Ec/CRyjUl3oFbJ3TfL8kRzg+qAIur5kQLcq6VcU5ydBs6kEC9od8pUo31AkFX95U9tFOEVfUr/U9yO+DIeU/qniytqN4Vq+2qcdet48hJbutaEyIECPp4Hkpch+qcB6Yo6GHAwB+HNj2xG4qONBQE8+BwwUWv0bC8GM3V0xuVD247lFkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykGNuMd8b2D04hNrFq7rK9zP5/8CXzD/Czo1me2TIU4=;
 b=s3kWW/OTcJsr1wmo+EJmaDbKQ9hXy+94KxKo+PzAA78+eMZc9ZmuS0IbpHZ7s9pmrDI0IqtNI04Xtogj47Wo5i0NqzU66di21l/bz6BBOH0W26AfG9JVnhvWqYAoneJnOWEpCAPxqu9oZZdgqFxz1ZWN7FfvpymQtC7Y2nHagAiXm2AcOt2F/UVNZsPuPw17CNWF1nJQDiWznRH02dhenNKmpCm7JeRcc1sWmWvTNsal3GOI7OLqE2cMtbljuU9SUWZivEZviAYdZM6VrucdUeAGimnFKDE8Uev5K/2m71MmP7VnBMiBwQISniwLWadNJbRKEU4qrHQCql6cqw6oHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykGNuMd8b2D04hNrFq7rK9zP5/8CXzD/Czo1me2TIU4=;
 b=Os8XmhS6L1FWWSl03LEi1N3OshieX2FBd5DiOTTQ9zCdnvTwTBrnidZ0Q5Zxv4JniMtEuFXB4x13w/Bcd9RKcuPDrWUAmUTi12Vd0ZbXCLl5fALDaCl3t4zFUb+5qNgI91Uw3GPw8qfqtC9pA6+7o0czWtJcS0/iTn0x4YiJ7ZM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7662.apcprd03.prod.outlook.com (2603:1096:101:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 06:18:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 06:18:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
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
Thread-Index: AQHccB4RyL0BA8NNcEOn+0trE2twG7VFPzEAgALfBwCAAWEtAA==
Date: Fri, 9 Jan 2026 06:18:49 +0000
Message-ID: <107c551e65aa3e5666a7410f3ed8049920960ada.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-11-ddec7a369dd2@collabora.com>
	 <213d3077835fc86d15579c0a0a91f64fd84b1059.camel@mediatek.com>
	 <5992593.DvuYhMxLoT@workhorse>
In-Reply-To: <5992593.DvuYhMxLoT@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7662:EE_
x-ms-office365-filtering-correlation-id: bc8cc76e-c12b-4ec0-7e40-08de4f46f433
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NG5VOFNjVVN3cUg0aU1XVHdqUW14Kzl3NzVYMnVDYkcyNFl1cmR6SVFkRCtu?=
 =?utf-8?B?b1lGN3NoRVlySnE5QUlxMTY1VllsZ3dCK0Q4QjhjWlNxbmJTQkdValJTK0lU?=
 =?utf-8?B?djJyOENNTWI5SGxwVkttWXlmNi9iMnpYQzc1ZFJNVlAyNjNHdGJUVUdtQU41?=
 =?utf-8?B?ZWVhRXIyWnEzWDVYWWlycWtsUlpwOU5zSk5vblVSK0RqOGN2ZUFkUGp3Wlc1?=
 =?utf-8?B?S2t6UmkrbjBIUEIxYlIwaEFLeXBuc09jdGFCbk1TMFFtdXA2Ri9DNndKakJi?=
 =?utf-8?B?U2J5b3R0eG1XMFk4dWRUL1RnSWN5TmRyQVhyVHZPUHZ5TnJyZFZic3RZOXdv?=
 =?utf-8?B?NjdzQXlSYk5uOGtSd1h6MHFIMDQyYVBGZ2c1am1tVHczY2hOci90ZkJ6YnZs?=
 =?utf-8?B?RVIxWnpEUnpRMFpMRlU4MjJMQ3M1QXZ4N1RnMjdEUlBJSlBsTkxuTFpvdXhJ?=
 =?utf-8?B?MlZ5SURGUjFPOHdDQjllbVVxY3lIeWdDQTB4U2dvNzRFRndqM2QvaFBGZndV?=
 =?utf-8?B?UHlPTzNrSE1zRlNlT2s5UytjSWR2WlFMdXd3c1Y1VGtLNlAwZnVsR0RmR2Uv?=
 =?utf-8?B?dzZCNDQrYjd0QTNiY3Jub2dGcFBEVDAzUGdiclR6UVAxYmRXZlJ0RjErZWw4?=
 =?utf-8?B?dWlFQVhUQ2ZIbHFjQzI4MFA3WGtOSDk5R3FmeVg1Mk0vWU1yRGUyZ1hGSnlD?=
 =?utf-8?B?L1JEOUpmaVdSem5uNTc3djA5Y1BWdkNUYUhOd2xldk5LSlpUbDNLSnU2OFVq?=
 =?utf-8?B?UXQyQkpaaHpQYU5BdTJWMWRHWmJ0UTJPb2Z0WVVjQ091dlRyYUdNbm5DcFNY?=
 =?utf-8?B?UVV1OVhlem9TZjk5MVRFcjRGRUJ1RGhsNldETGhycTh6NjdPYUthUENFbUs3?=
 =?utf-8?B?ZlA4eW5NRXluZ1FBcllCQU1oMkhOSFJrV3FEcStZcE55cnlaVzJCVzdFM290?=
 =?utf-8?B?cTVKTHdxSlIwNWlIWEZ5SzNpUE1FYmRSZ1JHdEhaVnVLOEtIbHFDM1JSVWta?=
 =?utf-8?B?RGlGUWF2ajdRK05vM2JxTDNKaHAxNGVCeUhLSkE1VWhuMmxnYWpoaVBTdmNG?=
 =?utf-8?B?ZGo3U3BPTWZkR3Q3MXVwbDJTYldSWVFmeTBBU0Fod25Vd3UyVk9VT3dZK0pK?=
 =?utf-8?B?Y1lUeXIya05ZckgyMVhaLzkrK3EwODlYZmlXRmE1dEd4RURIUWx0c2N0VmxY?=
 =?utf-8?B?eVIwK29zS3EzZnROMUtXUVJrMHJSbHFBRXVRS3F0bXdKNG54Q0JOWGVkdHMx?=
 =?utf-8?B?VDlkeFJjRFo1S1Jsb2NzbUxKaW0wMllwcHZyYmFpZGN5ZXRwcXA2bUVjUmtv?=
 =?utf-8?B?WE95eTVqYlZ5QkM2Uk54WlFjMTJDS2dLZDB5ZmdobnpLdUwvM3Y2NHdxdnJi?=
 =?utf-8?B?K2FEWXJuMis4U1ovOGJyUFNHKzFGVlpYUEsxMXo3dm5ndzJVdHNPQmxmK3k3?=
 =?utf-8?B?WG0rVDJ5TG9wV2U1TzVQRVR1V3MxUzBOeWVUeGVRMkVONHhhbm9pbW9vTkZt?=
 =?utf-8?B?dGUvV29vSDhGRUdDbUIyZlI3OUpIMjVUaXVaZE9MNUlGeG9MQkdoRkpxRktV?=
 =?utf-8?B?bXhWM1FyeVJGY0oveXFGUzNzS0dQbDBXdFFBZE9GTTg2OXFtV1RYV0o0V1BO?=
 =?utf-8?B?YlVYOUxrQldLWHRxdXBlbmZpbTVVZUxCS1l3SlhuWGhHdDlvMTZyZFFEWWND?=
 =?utf-8?B?dGk3VENIL1Z5aXdSQ2JmYUlqNitycG1VaVdEa0FGejF4MCtzLzVzQ2J6LzZy?=
 =?utf-8?B?cXVXV2Q2RFhUbWJCbHdaUEJFcEluZHZtUlYvbitUQzVwM1FHdks1T0V3d2Rk?=
 =?utf-8?B?NDVMU3ZNNXJ0SzlZOGJ5NnlaSjZmTHQ1cXBuVFQ2TmU2VGFlalBFT21hVnZl?=
 =?utf-8?B?ZTBCUjkydVJjcUFxNTlUUWZUV0l2SFVtRHRQOEtjR0Zqb2xTamdwcjRzdEV4?=
 =?utf-8?B?WDgzQ2tYWTZlQ3E1MDVtSENWeWFyUFdZUUpJNzRRKzFJbHc0NXdSdzA1UG42?=
 =?utf-8?B?RmpIQ0IvTElRVEVxUlhPMm56Q21Zbnh4V2k0NytQWTZYdUZPa3RwY2pieGM2?=
 =?utf-8?B?M2poZGMzbXMwQzNpNENaWXVmN3dOTWZKRExTdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2dYZGN5QVVEQlB2T24zMGNYOHlIYUtVQWRHeVowL0NLcDQwUjU1aGx6elJp?=
 =?utf-8?B?b0E5enhpVjI5azhNSUhlVVJLSUw4ZmdXbWFHSkpsWWlFSjQ2TWZESVNOMkY3?=
 =?utf-8?B?d1JWYjhRSytDK2I4NnViaVZlRzZ0RnhYZ3BTeElPZ1EzK1lrWVVNdlJCUnR0?=
 =?utf-8?B?emhjaHRQVGVkQndZYVphTGxVY3pUMU9zZFpKeENRUmdvRkpsRHV5dGtKcExa?=
 =?utf-8?B?SndjWmhHTFZJV0R2ci9CU0hheSt2b1N5enBQWkdnK1pkQzQxcDdxVXRMQnYx?=
 =?utf-8?B?S0pZaVBSMFhXaThnZklCbC9GbnN2NC92czhXY0ZYOVVucFFZb3M1Ymh4aEl0?=
 =?utf-8?B?bVFBaEVIS29PSXI0MHZuM3V4bzJUNCswM1MrWmJ6WFlZeFRMQmgwZUUrd3hR?=
 =?utf-8?B?ZVZTc3YybzljZVhNR2tDbFE3em5EbkY0d0diYVBCVTlscVU3UzAvZCt5SlVT?=
 =?utf-8?B?bm1VWDZOc3hqQngwQXVWa1dXdnhIKzhacmlBUkdack02Tkg1K0ZPRmwvMGJC?=
 =?utf-8?B?enZjcFA2ODhJbVhDSitMUSt2TDBMTEtBNFlMeUJ2R1NaNXQvY3VDTTVCV1gz?=
 =?utf-8?B?TXQ1R1RsSGZnaHJPVy9BT0JaVWRLdmhmRGsxUXR5U3Z5djR0OFNJTllvRzYz?=
 =?utf-8?B?WDhxTnQ2VXl3Wkc1ZFhoWkk3dXRQOGNKaVVacXlBdTIxN3RhTnFOU0pRRHdD?=
 =?utf-8?B?aXVkazJuZjRsMnEzOHN2NG8rQk5nV091ajJxZ0g4UFdlWWdZOGJNdy94Lzdm?=
 =?utf-8?B?WUMrQXFoeFUrbWxPK0ExMDBNNFVOei9ZeVp1UlFzdDRqYjJNTmtscVl3MDdE?=
 =?utf-8?B?WlI3aFZrNW5IcE96ZTRTRCtNTDFHK0o1b0l5SDBDMXBYMXhLRHNYVEF1Y0Nt?=
 =?utf-8?B?ZUwvVGN2alpwU2RWVGhOOURsNGxDdy9oT3BzTzg3Nnp5YTg0bjlaSW5CWUkw?=
 =?utf-8?B?RytiYlh4YnNicVVrc3FibjlQSW15dTQ3Ymp4YkQzZ3g3cEFoQXoxYWFhaTBW?=
 =?utf-8?B?Qk5SdjBaYTdGZUk4RWJVUWZPU1BwN3R0SVBiMnB4UjhBNWxoSmR1aWJmZW15?=
 =?utf-8?B?TndtZXBZTFlCVHFGR3hjTjFZRlNtUTRpTGU1cXNGN3liaTFMYisySk5qcldy?=
 =?utf-8?B?SndJVHAraSsrSjZRb2dlR2s4alpvZGpvQ0pWZ3p0UDFydVVvOC9mczdwVVgy?=
 =?utf-8?B?aGNoN29Ra3RKK1o5VmVEQWd2aTBweUZrcEFOZEVOcjd1R1I5L1hRTXgxWk5o?=
 =?utf-8?B?eUlnTFZTN2pta203blRkMWorM2k0Myt5SUFqN1psNTJncXlLVVJSak9ZN1J6?=
 =?utf-8?B?OVhNVG85ZUVmTkJiMU4xS0R6ZGNaSHd4ZnFqVnpPQUFwMU1FVWgrdjNJdHZo?=
 =?utf-8?B?YlIzV28zaHNTR2pHcDFRSHpVRGhHRncyRWJuK05IUFNiaCtXem16MDNJbnZ3?=
 =?utf-8?B?azhERzRyQzFzcE85Y05oZHJQNER6eDdtR293SU8vVDBRSU85UDMyV2ZVTDlP?=
 =?utf-8?B?bjB0QzZpbEJCL2U2b1doSVJxVTd3L2xHRk50TjZqT3BPMXloK1VwUTd3WXpG?=
 =?utf-8?B?ZmxFejlESjZmS1NPZnh6L1N0MTI4K3phMUtEYjhRQUFkN0cySU1YRkJ2dDFQ?=
 =?utf-8?B?Rnl6d0EzbDB6Y0RGekg0a01RQkt5bHNqU3lSWGJaNVY3YnFLVGt5VUJ3NGM3?=
 =?utf-8?B?ZXdCY29wMFFleklCcS85R244L0NBT3ZjZlN1WGRLeUlvV3h0cjFRUHM0djIz?=
 =?utf-8?B?c1ZmMVRYUnA3bEtycU9hb25NWkxtVWVnRkx0Q0Y0c0RiSTJsTXFmRkc4UWQz?=
 =?utf-8?B?MjdNSkdLNzAxbHhEelJWQllyVm5WWlM5Y29yeEN0MVVOV2lpYnRJRkxXdG4z?=
 =?utf-8?B?cXhZa0VTOXZoMUxtM2RGQ2p5Sk00ZVV5Sk9XMEcyK1pzMlVURS9vZjQ5MTlN?=
 =?utf-8?B?dUlpTi9IcUR1OGpZVjYzNERKRUx4M1YzemVQRUUvUmtzcmNScEJBNTR6VVp5?=
 =?utf-8?B?RGxLWGszbEl4RjZiYTNaSXJMZnBDNm9XbGMwQVgxR0lBQnhOYUJuYkJ3SnRI?=
 =?utf-8?B?cEx4U1dJVitJVzgyTmlGN3NDdWc0S3FiZ1pkMDlnVHo1QTNFZGo4U1h0WFVB?=
 =?utf-8?B?c2Ryc2RVNHZrUE9vT1NpekRNTjNHajRINkd2ckNNTXNnQitWeCt5SFRRVzJC?=
 =?utf-8?B?TFJpMDlNZHBBNWw3TzdVQjd0NC9ZSnZIWitWUHZkQ2JqZXN3bUZ6Z0ZLMzNl?=
 =?utf-8?B?M01rbXRUSGMxdXd0ajdnV0VKaCtxVWNmZk5nM1dHUWpKbjR5QkcwamFhanFP?=
 =?utf-8?B?a0VvRWJXekhrNUhjYXdURWNUNDNYekxxOC8yRU1RRXd3UklHMjVTUEhmS0hT?=
 =?utf-8?Q?BSrrxiNrOpZ7BEVs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43553312DFCC1F469679B4476609FDBB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8cc76e-c12b-4ec0-7e40-08de4f46f433
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 06:18:49.5360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BHIiodu1YxoBQ6YBVD3Pf7TbLWsEhgPCYQRWSg18MqFgap3wo+YadeW9WuwipVh/XX0cvmsmFNK60qI9mvf34w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7662
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDEwOjE0ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEJlY2F1c2UgaXQncyBub3QgZGVzY3JpYmVkIGJ5IHRoZSBiaW5kaW5nLCBhbmQgYXBw
ZWFycyB0byBiZSBhDQo+IGRvd25zdHJlYW0gaGFjayB0byB3b3JrIGFyb3VuZCBub3QgaGF2aW5n
IHRoZSByZXNldCBjb250cm9sbGVyDQo+IHByb3Blcmx5IGRlc2NyaWJlZCBhbmQgcmVmZXJyZWQg
dG8gd2l0aCBhIGByZXNldHNgIHByb3BlcnR5Lg0KPiANCj4gRXZlbiBpZiB5b3Ugd2VyZSB0byB1
c2UgYHRpLHN5c2Nvbi1yZXNldGAgdG8gZGVzY3JpYmUgYSByZXNldA0KPiBjb250cm9sbGVyLCB0
aGUgVUZTIGNvbnRyb2xsZXIgZHJpdmVyIHNob3VsZCBub3QgYmUgc2VhcmNoaW5nDQo+IGZvciB0
aGlzIGNvbXBhdGlibGUuIEl0IHNob3VsZCBhY2Nlc3MgdGhlIHJlc2V0IHRocm91Z2ggdGhlDQo+
IHJlc2V0IEFQSS4gVGhlIGNvbW1vbiByZXNldCBjb2RlIGNhbiB0aGVuIHRha2UgY2FyZSBvZiBw
cm9iZQ0KPiBvcmRlcmluZyB3aXRob3V0IGV2ZXJ5IGRyaXZlciByZWludmVudGluZyBpdC4NCj4g
DQo+IA0KDQpDYW4gd2Ugc3VwcGxlbWVudCBkZXNjcmlwdGlvbiBpbiBiaW5kaW5nIGFuZCByZXZp
c2UgdGhlIHJlc2V0DQpjb250cm9sbGVyIGZsb3c/DQpCZWNhdXNlIGlmIHdlIHJlbW92ZSBpdCBk
aXJlY3RseSwgaXQgbWF5IGNhdXNlIHByb2JsZW1zIHdoZW4gYW4gZXJyb3INCm9jY3Vycz8NCg0K
VGhhbmtzLg0KUGV0ZXINCg==
