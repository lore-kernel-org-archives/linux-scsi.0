Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBB133B6D4;
	Tue,  3 Mar 2026 08:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524888; cv=fail; b=bTY84Y6KVP5YH+awg2timZ3Ui7OLFNKXKyIN4tt61U4aGw2Yt4tZE4+fMjM5KNsRE8olrq1D0GGFDK/lxQoKhJoVEFcfrI6q12E90RNDrg3raoUK+PITCV+Qjv3bOPZHIqUMeADrqOUox7XCjlc7aI/+bIUqOcAzR/FGUvkHR+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524888; c=relaxed/simple;
	bh=3slQenzJgoEsE0HOUhXzOoVOnKIkq2pgZRZfekvfGgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FE1az0Cm3RdKAZUVZ/LujalR8AeUM8hu5D0Tia6tUw1uDusOSoxX1xjVlUY52pKk4/Tv6b0RwP+Z8YSrK22kIibHQcgizY8ObkxqwY7kVKnQDlMTT0qn8dSgWxrAmn+j6026HPIcTbHx13i7A3Bcj2EkOnv9eSu9JahCAAMQzFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aw25T0Yf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qJLhPQrs; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aw25T0Yf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qJLhPQrs"
X-UUID: 293da61c16d711f1bcd7499a721e883d-20260303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3slQenzJgoEsE0HOUhXzOoVOnKIkq2pgZRZfekvfGgE=;
	b=aw25T0YfOlON0zgWVwvWffGZbX9xN6jC7ennz+V9y4p3YxV1rkE4atxbdNAwaiQ9lsb8R5QtcF51+UUZIwWUqsfW61poCf33UALk2lFDSmcO1vux5xM1MombAH7SZC7BH6Iud9/JbL04l5/wjBIyu9kXMDklWOKnbTwKY2SkvKo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:274da4a5-e581-4261-aacd-e77e262c7dca,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:dc0c767b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 293da61c16d711f1bcd7499a721e883d-20260303
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1848414532; Tue, 03 Mar 2026 16:01:19 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 3 Mar 2026 16:01:18 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 3 Mar 2026 16:01:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGCC8BxaLXM722PgeB+aQhOUy/YUw19roHxIlx5/+/wBsbwbIZMLsHbYtDO1PRPia6l4iXblpvg1OxbSBrmsX2774vL/BtaBHBmOoDowyDggvW98CBnOa2XgHy0m8MwjwJbevs26NgpCRSegtKTkCmMipSJPMfOER7PAp7sBBpTiWz7LBxERKn6o7KX0i39nmmbsna4zaQbS+n0VKrkcR2k/n2qpkRlL6myt8r7Zwr2A9t+DfFvPRThcu4jXDmHUVJpohgsU3r/UjcYem7MnWhkYNpBuvtGNgpiBfS+r/Sn+iWen3X7AlzKPudnF3W/FkS7dbo3GyN43U19enz05ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3slQenzJgoEsE0HOUhXzOoVOnKIkq2pgZRZfekvfGgE=;
 b=GZWCYwUU8mYnqNLoapyf9ugKOtP1fXeBoPjoOV3OYqCobtDCZGjq/TMJxVhKT2Xw2RGvlx5DimlHH8IBAohdIQR/jwfx2T2/OchPEemRujl5iNekLoag/0RoIgS5HRpFs/F45Qx+JT3vmRkV9T84NNx1SbuHvlCyq9foAEozM11ZCZGmXZ4SXuw5l1nRhImWKKvC6T6UeUirIDS8RLnHKVEspSN4X7rfId4dX2sFA9F1mrnVZIXxq6pWWQfR2n3GN/k9wh/yF+UoSr9Gl1FMoTO+Nd4+aE4vnbNNxPgdV5DXxJ/MpzPSD1c0CbUx0vsGGrL54/WeMZTCLe3YOtS15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3slQenzJgoEsE0HOUhXzOoVOnKIkq2pgZRZfekvfGgE=;
 b=qJLhPQrs4Ho6TN+FC0EEcO/8rv76kOyH0zOLoEMxiPf65Y/fWTV3txlX3VrMtux1ZFBRAoTe0whMlIgEc6EUvtXLxbhcX2LQn1qXCOvDsnjJ0q/6+Pqn5bhdSvmZGYO8V5aLjPgFgZUyhp+4kAaYhmtlEXt0WhblwWAT48lpHOM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7654.apcprd03.prod.outlook.com (2603:1096:990:14::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 08:01:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 08:01:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
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
Subject: Re: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Topic: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Index: AQHcn0oP6tEnScLyfUKovG8pABVQS7WTRnGAgAAi7YCAAP0HAIAAcnSAgAewYYA=
Date: Tue, 3 Mar 2026 08:01:14 +0000
Message-ID: <0bef3e1592e64f74e6a6fd8ef59129ac71b307e4.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-20-b5f2907c6da7@collabora.com>
	 <5d9723fd6b4ff8430889efb33e0fc93a10c4a880.camel@mediatek.com>
	 <cad2e275-8b5d-4023-b3da-a191bfd065c5@collabora.com>
	 <6297edc9c2d6d1a323f188ef411205701a629d88.camel@mediatek.com>
	 <48e8f40b-f5f3-42b5-a97b-7a25d1dc0fb8@collabora.com>
In-Reply-To: <48e8f40b-f5f3-42b5-a97b-7a25d1dc0fb8@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7654:EE_
x-ms-office365-filtering-correlation-id: 69bad1b9-d52b-4a1f-6e73-08de78fb0b44
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: FGYtpgKUyOtLSfuNmT1rBusfX4Y9Ys2qqRiZ41/9g3GLwzrcm6QoGs4XuGzkzyJ8I4ul7ocLrocIh2GSpGJ2TZH/CA9iCnnddalwVRc72dvZ9sRfBVrYUa1viQTvN4vQ2MTzVEnY59QUX7lGiWzOfDzW0fD7TZzS0OqiYnkbhRysRMa+vYOeTCZaNvJVbd0hwIaRqBG+blvvzsX/+D4VE0SLHaDCYWpQI9v/a7bd4+LeHZbcqhC8CD23zOO/d3UqSizdBJm2JXIYgycnu3/wzfPuEu98XxqEqsRvDHS4CXnP5Lh02iQhvKonvKoWm7vZJcgqwlIZH3jH+0p8OVZk0aKSgHUgHAsrhvFpcgclyWbeUF8zQcwzzmRcypTZgfsy6VYv476xK0b19EztByZ/UY0EwuOi6oS4EgMxRNi1LWFUlE+EAdIXqdgRXMZK6ixBtOEa+q4NtcSwNMCf54gf3cKYx1oYoPI4A6eqKwXmOgS54cjyrFyRY095OqBEVwkI9eNq9HwzLpBPZGH0uF14M6Ibz58niVcEjpGc/bfOgJyNgkEAF/kPW/4K4JUkj+qPYLYtW/pIoFxnKZwyzP8pe4q0Qov6htO1uFHaM7hqBjW4pxrkJGU/IRMHRnvlzuoeAc2o9txuxs4/tDebXXIU3xhkByevT61G/p+ek9DT1F0u+eA7ZJ5O9UNVjNYrDQwr7HtHHoMTTSWcY2y0VL/qH8XES75SPhR6deVbuTivlkTVyFACvENeLcqWulbWSHwr9G2D68nUkoIUza2pHfUOGzAggkoMyHKJZM5U7cgZcrtlnCZbAh5ntO7fBBWwMPJb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkt6UUVvNEgvRXdnMVJLdXlGQVZ5cm9sb1VsbmEyU3R6L0k0WXAyVmJRa29T?=
 =?utf-8?B?bW9GN3IvWVBhS2lRRkppclVQRFFGdUFMRDhlNmRYT3c5N0Z4cTgyYWY4T0xT?=
 =?utf-8?B?ME5CbG1IYTRGV0FrNmgyTHpNVUh5bEtkMHBhcDhIai9ickkwMnBObFhIVWdY?=
 =?utf-8?B?RmxoV2tXWVFZaUU5dWdCcy9KaWdVa0Y1bVVuYzgwTTZ6b01kZVE5SHdlaTJj?=
 =?utf-8?B?bGlQY05FVDhpa2V0bnNoQittR0MxYjg1Rzc4Y2lXbEI4YWYzWFR1K0JxTURW?=
 =?utf-8?B?Uk9KYkpMSGloc1BHZEM5dEhLYTl3Q0llZng3YnBDMUFnNkYyaEVXV3grcUxV?=
 =?utf-8?B?NUpYZEVxeUdHMTN1ZFg4NUJMYVd5V3ZRd2tVVHJLRGczd1h4K1V5d1JZa1Y2?=
 =?utf-8?B?R0pDQXJNRVhSOWdIMDlPVzl5bzRxdUZ6Tk44c2NvZFVGUThCNzZMVHNscWhw?=
 =?utf-8?B?U0ZMZlE5cUY2Wi84QVRxU0JndzU4bW1mK0FYVVFEVjR3Q1I4SmlYSlVLZFE3?=
 =?utf-8?B?YTVRcXRITmMxM3FHbG5vUCttUERZZ3Z3blhoVlljZlA0SGtmTFZXMmNLajlz?=
 =?utf-8?B?N1VTS2dPc2phbkVWTVBNYzhkU2E2S0dLeEM1MzMrTzN5K0lnRmcvU2k3b3RY?=
 =?utf-8?B?NVA4dk9yeW9NOFBXaDYvei9JUUNXSFBmQ2pETW44U2RMeXVjZTFFVjRLeEJK?=
 =?utf-8?B?bzBnZUxKN1czdm0yclk0MWQ1Y3kzRU5Yaitod1EyTlVqNDBTbWRML0o2WllL?=
 =?utf-8?B?cWV6S29oQjU1OEErQWEwZWcrME1JMjR3bS9aVzhmQUNoVkUzZlF2V0RMa0pp?=
 =?utf-8?B?bjQvTGZEMlhIbmJSdnJvbGZCT25Yc2JQeXl4VHNacXdFa0p0a0RiN0ZaVW1Q?=
 =?utf-8?B?bVN6QklRZTJERFdQY05FdDl1ZFJWSnFKVDFPY2ZUYUlMWk4xT1k4eXRwVlpo?=
 =?utf-8?B?dnJidlZWdUVYZ0dDYmt0aXJUL2F0VjBhT3Y0b3NUdkZRa2liZUVjOGxDQUN0?=
 =?utf-8?B?QXE3dXZ2ak9sNFVQa1Ayc1hhRTRsWmVSTEpibm82ekROeG5zMHdaT3NJeUtY?=
 =?utf-8?B?bmk3UHJsc01OOVB6WGVEeEtRbEVtaHdyV0I4UFQyVzJIRGdYT1RHc2tmaDJO?=
 =?utf-8?B?ejd1Y3BJUmtMQ01zVW1SSzA3eDljUmtJWnBnVUhFVDBHUTdOMzZ6bE9RN3pu?=
 =?utf-8?B?WFJRZkZ2VEtHTm9SaTJKRmE0ak9NaTllYytmNktEVHY3Zm9yUnRGdTdUMUZS?=
 =?utf-8?B?Q3k1WEFMcHVuUUxyb2xLR29VMU5XOENhOWFqSHdDU3kvYi9iYjFpRU9tOUI2?=
 =?utf-8?B?U1haUjZWR2lWTEk5bjFvZ2tHeTZIWTJZUzdjS3dCZjNvVHVWM1VHMjBGWlFP?=
 =?utf-8?B?eTZja2lvWmZvTzRIUTE2OTgxam1CS0tXY0hRVXNhaWJiM2NMUVNWclR6Q1po?=
 =?utf-8?B?N2pBZjBIQ3BBdDlXR2JkZm9zVlF1N1JGYlF5amVON0htbVNOSEV4b3B5L05S?=
 =?utf-8?B?ZmNySWhHSTBHU0YxdWJlNWp1eXgyTnk5ZkU4RWEycDFBNTREdG5kOVNKWW0x?=
 =?utf-8?B?QzBDdVM3czNYbC9MVVhscGNHS3FGd2FBN3FuQzFGTjhvUzJJYnc1TER0U3p6?=
 =?utf-8?B?Y3B1SkdHUStnUEhmcUZWYU5tN0RSQlA2NnFPVzZ4TDJCU25BdEI1c1BxNHV2?=
 =?utf-8?B?NzAxWEdJMEhXWVZ1Wm1URkZ5dGhRUGFJL0tGS3Q5QWVRTHlDTFdvZWFWMlU4?=
 =?utf-8?B?U2NiVDN1eDZjN3c5ZksyNXJZUTJqNnRIQlhpZTJNc0VMWGdNS2RidG9zK3o0?=
 =?utf-8?B?ak92K1krQzFkN2Z3eC8rcUJlT2RLT1lZKzBuK1VtMWEvaUFXQmZDOFc1MFBP?=
 =?utf-8?B?VXVDNzdJOE15a2d5a0hpa0sxdjRVSnF0emhBbWNYUTEyUlhZZmFvdjA4VmQr?=
 =?utf-8?B?U2V3NGhpYWowQytmSUpYakxGbGpHT3lTZTVGMkVWM01MZmJWN0NaVUNMRzM5?=
 =?utf-8?B?QXJIanpCaldpc1VyQW9ERGFnMXNlamR6azFOVGJIUVhmblZhQXA5WmZaaGtv?=
 =?utf-8?B?T0Z1Q25IQ2toS2xWLzc2ZWpSVWJtRHdOOXR1NHRmVmxKVCs0aWpEdU10am5z?=
 =?utf-8?B?aVBhVG5BMm5uY2U3Q3ptbzJwVkkydFhtUytSMEpENjd2K1piSEFpZ2YrMW9D?=
 =?utf-8?B?OU1OYkQyVnB0b2cvL29PTi85UHl5QVpsRlJzUDhqN0dXYnhLYlNsSk9EVmY4?=
 =?utf-8?B?OXVDZ3diNUFNQ3VSWkVHNFc4YmFSaHBVY3VCMTZKT0k2ZjNzT0F6NThPTWx5?=
 =?utf-8?B?Y0IzeG04NC9Gd0d4TFFuYzBXQjNjOUcxT0xhOGdlbFR0aHE0YVJRWFVjN1JV?=
 =?utf-8?Q?89mVy9+KI+B/330g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07FDFD69AF16DE4FBF3EA0563FF4B836@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: o3B2R/WDhM8M5aUvtT7sAwO8mhxhw/9l03XtS18Neu301galLuVo9EICDeu9h8vHNJjMxNDb0x/1aY6Vw4vT/q7UxcP9KYw6q+Pq7vStWHb3d2vTNdxxn9pzLqhTM2FbxBeOIg4tsKghyjyptGuLN0A2DMSCYPCEmez0xTnXe0gV3Zd63EaBJZyGq4sfG4lh4MzujIVXlHnyorj+Wxu1yDix/HF0cXNnCUzmw6EOD0yEepAB//8al76vVzd0GkNbGkRFHk4HILCapNpnoYP8I3DXNnAc0wIt5eKCcK15jEPc/jD+huQFmGwKHktuXx6UsYHB+qIx3A7CW1/GNkHO8g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69bad1b9-d52b-4a1f-6e73-08de78fb0b44
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 08:01:15.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sakldx2YxOwGUxk7AU0A4tqmmAsTMEve0SssRKH8XZkdA4ar5wueVjHblPU7JELmjHniFBqqpC9SQSevqZ+6lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7654
X-MTK: N

T24gVGh1LCAyMDI2LTAyLTI2IGF0IDExOjM2ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gDQo+IE9rYXksIGRvZXMgInNhdmVkX2F1dG9faGliZXJuOF9pZGxlX3Rt
ciIgc291bmQgZ29vZCBmb3IgeW91IGluc3RlYWQ/DQo+IA0KPiBSZWdhcmRzLA0KPiBBbmdlbG8N
Cj4gDQo+IA0KDQpIaSBBbmdlbG9HaW9hY2NoaW5vLA0KDQpJ4oCZbSBmaW5lIHdpdGggc2F2ZWRf
YXV0b19oaWJlcm44X2lkbGVfdG1yLCBidXQgaXQgaXMgbW9yZSANCnZlcmJvc2UgY29tcGFyZWQg
dG8gc2F2ZWRfYWhpdC4NCg0KVGhhbmtzDQpQZXRlcg0K
