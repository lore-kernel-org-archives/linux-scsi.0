Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A9535979;
	Mon, 20 Apr 2026 12:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776688452; cv=fail; b=BNqMivGER8nisSWufLCZjRBnYEQgrk40/ZOE33X8sEwXiDj+30G5Hcbf5l0B8kebEGRFzNavZKHbifhnoJiMwDpug4xTizsfaBKhaRAr8PQSgPJGiA2PKM8zKLCB1Oyv4b4XUEgRcimyY4A5CHMmhGA2B1xCB3Anu99IKXj7Br8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776688452; c=relaxed/simple;
	bh=AC1l+nroX298b6E+HaQ6CDx4sMwjJEUHRfz5g34OS9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B8LNJtbz8Elw5mu1XbrUc7KS0/9cEKvIX5knvM5h8iKLhBQ1IC7l/cPIZvXsiiIKaTJsq0uNE3wVHQuZjFm24Q5r9wURvxkOIEh1QbcDnikKui2TYeM+jlnGRbHr8A/psrsJPf/pWnTZ5fEh1TEuSd7U0mAWXQaF620GUyIgGp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LLSSS36d; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RuoaSdq5; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LLSSS36d";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RuoaSdq5"
X-UUID: 32ea3fbe3cb511f19a16598d5ca7f8ec-20260420
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=AC1l+nroX298b6E+HaQ6CDx4sMwjJEUHRfz5g34OS9c=;
	b=LLSSS36dNCiHO3h9eNpbcQMs7AvfhORbZ/jjvk7MPFP3NVn99eqpGS9GJp+55rr16DNoHuxtj1/HyBuNmYu2x2EeFONZtEB0XcVKGoG9yIr1sdjwZ7Yz7M2f6fz5qsZIl2QvOO5/iSX+Kl3+jPTlbU5Miown9nhyzEofg/BjFoY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:16fcec00-b477-4fe9-9ce5-5cc3acb99ebd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:4804a28f-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32ea3fbe3cb511f19a16598d5ca7f8ec-20260420
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 913700112; Mon, 20 Apr 2026 20:33:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Apr 2026 20:33:55 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Apr 2026 20:33:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tzo4dRWY9KYl5Gpdi/9l3pKay2UYugJGr6HnH1yQHMRhDuUMT+Z4/jeZTISP1TmYB2cVe7M/Qz6JoxUwAyn0p8JdNi27fyfj7m5anVtKVNOLjAhQ4uOl+DUCrST8ZZsC8Q/HxOGb9Swo28KnjRGfZf+7RXvRigNT4DGdCUd8XaRpSQ36GEW5tZ102N4gRd1luONMPd3nKcnSWb71T4qwTib/nak4kfPYBokE/pErPq2owUND+qmQxJgw9qVZ24GVqh240WcmTTZw6KjsPa1pkrXGChts48Ka14yYwZPywhxws6Z6/f8rtO81Yw+hGvB5mFgXXw/797gyIqdRxSfOjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AC1l+nroX298b6E+HaQ6CDx4sMwjJEUHRfz5g34OS9c=;
 b=XUdVyc4nu/j0h9LLdD0vTRz9OXR+KHqHwnPztWzI8et30Gi/wX9KZvqwd8ksroQvEKgg5QyvFnm6z63I5y9Ey7S40KKFCBW4TU8+dv0I8xVvhefP9/ztjaE7uDD37AA51VA3tGAmFrD5kOdlog3KRw+R7Ea4Do6DKl1cVn9xNjlaCPBc6/YVUvHcJcf+gwCwiKrFwSyrNutrq6slM0jiw5b+EfeTzQ0pJGrdyXfHLW4bTIrDCqrUFvFX57tDgLzflAH09B43JTHZm5mHyIuffzSo0V9Ubao2phrse/IzzoRrMvgyBCdqlj4oSABTg0IY9zVKI5zeqjccSHiIMhkJag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AC1l+nroX298b6E+HaQ6CDx4sMwjJEUHRfz5g34OS9c=;
 b=RuoaSdq5uyzYR/1Lslnj7jEN79LDAGx3vqcGemTU8f7Vf+ajvBlK2Cm/FIqDabqkRjibRzpoEe0w25Ot5yIqdRs0dfab5ivsktxhxwgaUjingeabmjC50rOHqhrkZtePyqjMXLexxjP3ZfZbEFABqRDJkf8e2pn0S8NxvcHYv8g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6638.apcprd03.prod.outlook.com (2603:1096:4:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Mon, 20 Apr
 2026 12:33:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 12:33:51 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"vamshigajjela@google.com" <vamshigajjela@google.com>,
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store
 TX Equalization settings
Thread-Index: AQHc0AQUUHHtovDAkE62M31kjn02VLXn49kA
Date: Mon, 20 Apr 2026 12:33:51 +0000
Message-ID: <343283a8281e2fb0ee83622a15028d12e44bd964.camel@mediatek.com>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
	 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6638:EE_
x-ms-office365-filtering-correlation-id: 5023cde5-9c37-4091-364c-08de9ed91422
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: OZvyf+RRIGqZN+d25sXb7Q5gZi8JX1MfW36QiUA+1piMHaK4z//FOd+j/t2R7P9cXLHLrufALvnRfMIK+Q+Vgt042tXYLYHTHItM5QsN/Ek6IYuKzgW8kz94xJp2YpEkgHNUYHyWbNVMw/9kEgCCk0C6WpjZVrDm2KJHFu8VBgLvaBTU4PzG3qTPvHaVq7EezN/mC2UIcyLzLjHiwGhGokEKJV70803jYOdbbpz9v34z/lmAw3rwSvPL/Y3LFXJ1g5SZ9zRVzguScd1gg8iGOjE7PzFchfZkMkNAH8dWAW9xapgsd7B20AGNIhu+zgkBU1B522GMaBcrxmW4hsyg+rUg+sq8y+j+1KMspeQOmWSETy7uhbo+jRjiDNl71AmR+6CvylSQAuZfp4MzGe9XN1KV4niNF01F6oBeucoGN05QjRy3WpC8mC4HoVVF+1x+p3H7nj5c2WkMkVYOtmRZhtVbWDj6cwv9N2HwIvGyhIbrxqnnzVc4o/YyGEE6DpH0nawIKM5/4mE3mNVGTeIQGk1JKoRhuH2byNlf/pem3HJ+9ohqYq6qjBnRoSGf6tLbK9b4rmUIl2Ly2IOJPG5SkDaVbOWEYA+N9chhMXjq+S/5BaKYsvb/EbuULSUUs28zOXh4DfyjwjhNEXUwWNjXECCDItxHytZLjGnAbSI+FTL5avcZg5FZD6WEStWvFAsXpzu0JlWL3pQwlXSV28wAqWl1ZpBsdKmG3Qc9rAAUy/1Fe9GLgPR0PqEw9zaNUdoRwOhdI/QEXJn/h5Wx+23blrECo8X0+RH+H+HvgUlFe1s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk5uZG0wSUcvbGczUllvczNXaW9hdnJLUmx2dWxVQjhqWDFvdFk3enlyeUJm?=
 =?utf-8?B?OUVYanRQQU01UlBCTDFwRE9ZTm95dlRkcHBzMkl3Z2VRMnp2bU9SN2NSeWJW?=
 =?utf-8?B?N05WbDFvTmc1c2FaNmNwZWZhYkdsZ2pHdmljdGcxVDdjRS81bUN0NVRxNnEx?=
 =?utf-8?B?dzJZWkZEQXZaSWU2YkUxTFo1LytjZ2c4NlF5SzdpaGM2dnlqRkZNQjV0ZHRK?=
 =?utf-8?B?ZFhmcTJ6Vzk1YWxIWVZkekRLK3VSNjRweWh2V3lodm1Wcnl5Smk2cmlVc0dE?=
 =?utf-8?B?TWtFT1AzeXdaemJNcFFxL09LVEJ2ZDBmakY0WUtPK0dhdFMyb3ZZem9VU0JO?=
 =?utf-8?B?K3lENllKc2xVQmMyOTVzK0V6ZFVTQWQ3MVFFSHpOa2tlc0UrQ093Umt5MVVw?=
 =?utf-8?B?LzZqUXpIbmVLS0IyVzZoUzMyNWpicSthcVRham12T3BnbmhlV1RpRkp5aUtN?=
 =?utf-8?B?bTgwV0xNVXFGdGxMamRWa2dsVXV3OGJkcTZhOGNReTB5dzRJU1lLd0NpNzdM?=
 =?utf-8?B?djgzSnJzZ2pjRVNCOG5ZVUFoN2U5TjR2WFN0ZnFyWDNZWWFvcTBRaG5zNzNx?=
 =?utf-8?B?ZnloZUtDVGdRcndKaTFad0dqUFRpdURCTm5rRm9KUi92RGlHQWZ6RUphaVJm?=
 =?utf-8?B?dkU0RkhJVEl6TG15YlJLTnk3SVpnbnZhUUZSWHBqQkFyZnNLNXpNajIrVzdp?=
 =?utf-8?B?OVV3N1E0c0pKRWhUQmkrbWZ1VUNnTVhEZFNHSjJhM0lHRUpPZVBQQjhpNWg1?=
 =?utf-8?B?MS9mYnFWNzk3NlFGd29XVW5BeHI1TjlNWkVTVEtVS0xPbzVTbUJrL2dyM1RZ?=
 =?utf-8?B?U3pwcnhNWGQ0dWlDZlczUkdXMWVtWTVtVzJMTS8zcTFNNVpYai9xZ1JwUXdO?=
 =?utf-8?B?V2NtVUlpajI4TDZWd3I4S0tGWk1CN1hyUUpxM2NsY3BQd3ZJdlU2bzAwY1d4?=
 =?utf-8?B?ZWo3OHBHWmZZRmlBL0o1TDlCV2dTNUNYM3ZBV0NkVWI4UWFOZEdBK3B2TURj?=
 =?utf-8?B?S1d1UkVEdUFqb280RTZRNGxYcjA4RzQxQ3h4NHNzUHoramFPaWc3VGtKTUVp?=
 =?utf-8?B?NEJteEt4T3F4OUFWcW04U09VQk9ySFpXdGRBZnNKY2FlTVFGTkpMeVJzamJ2?=
 =?utf-8?B?SUJZekJKN29OQi93aDUwdm56b0pGTXhqVHpHTE1BY1NXbE5wTzdNOEdpelhB?=
 =?utf-8?B?dXBJbU52T0RTeTNUbDg1TUVtSnF6T013alNPK2RJQlFqenNIR29qUTA0MDVQ?=
 =?utf-8?B?cE5rajJVaXVKNEVzUHRmNDgvOHN2UjBERW8yd29FeUFYWCswMVJucStuZ0l1?=
 =?utf-8?B?MlJxMWViQjk3YTNqbmRZb1ZXTzJaRnFycXFQUWk2SE1PdjNjLzZaNDR2d3JI?=
 =?utf-8?B?MlVCZVU4ODZ0Wk9nTlZuZGxQa1RDYVZIZEVVb0F2T1dJSlBNYWk1bGRrSTdR?=
 =?utf-8?B?cWNtYU1uWUdweVJ5eE84Z2ozeTVwbHJTbk90KzB1TXRkZTNqTThCMmkwU3ZW?=
 =?utf-8?B?MVp3Z1Z0WXBCY2U3bGNnVlYvOGR2eU9nNmRya01EYXQrWksraUIwZDJCT0Zq?=
 =?utf-8?B?UStaUS9qekUwZHpBNFJOLy90NkoxZmhqc05XdXliWGVpc0VrUVFIOWcybng2?=
 =?utf-8?B?d0J6ajlEekFTQ0R1a2c3TUg2ZXZFcW5jeGhwcXIvcStxUGxqd1hGT3hQOG1H?=
 =?utf-8?B?S09STWYzRkFxYXdUM1YxSEhQT0RweTVvN0NNR0o4YzVIb0FxdElwYXZqejFL?=
 =?utf-8?B?bzJJOHNGcDc1cDNteWFzZTF2ckpWbC9zb25WSGduNjh5TzdMVnBNZHh5L3VE?=
 =?utf-8?B?ZGQ5SEc5L2tjdmR2Z0JuazQzcThCVEhwL0JQVzZYMytyenkxbHhDVXdxc3FQ?=
 =?utf-8?B?QmQ5d3oxQTRad1ovM21HQnVvMmFCeXRzZjVnc0hnNTBEN2wySjRzUWZueElj?=
 =?utf-8?B?Qzk1a2sxd3h5MkdNbkI4NFh3N3llNlhNbGMrZjNoUUtBVWxxZWZ3SGhUU1pr?=
 =?utf-8?B?MXVaY3psRmR2K3BUaVZtdmF6YW9qaUZxbGFoN0IySUpsRUNXV3lDWFVGRUND?=
 =?utf-8?B?ZTcwOFJlYXR3MTk0Q0l6ZmZtUXhLU01xYnhHd1k3RHNJSjhZK1VyVTZhbC93?=
 =?utf-8?B?YUs1bFF4VDRRQ2VGeGRsL0wvS3d3ZzZRY1hndkZqQ2prOEhVK0FTQWFNWi9o?=
 =?utf-8?B?R29RVFhkTi9XUFV5VDFUcmVOcXVMb0J6U01tYUNZVzdCL0hPYzBDMDdTa0Fn?=
 =?utf-8?B?aG9ucVVEQ1pqWm0yWU01bU9XRlF4ODI2Q1BYeHFqVVhQaHorU1VmM3dqaXVl?=
 =?utf-8?B?RTlQQkxWbi9CV25BMms3V3NsUjdoRnBvbm5aYXl0aFhBYVp1Y0ZSVFBMRFVm?=
 =?utf-8?Q?tLT/nQbiVzapOc5I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1900EB9C09AFD44098784D2F4B29AEEB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: WeN4WuSd0hhDDOUuNauD6h5Ul67d4R8OsOLNMNN0RHDsDe3KKHuBK74ZMpIESS9tdlj8XXXU1lNO28Dc1poyDEFl/7fz7vFwVxH7FXHKmNnTxXELEzipMnb1R5rzrKbqOFNrrfp6m8Bq8BzKtCtWRcAiwdsDc22s2fvvBz4NuLc8nq50KONajHYs4W191r9U1ts96oRqPYxGzfoDkeHSXk0P4kAjsur6UZepsR3Pu+IcLkUcRMYYsKqKJoPtCRwpL3vlwH7ZPmegjDrbRs/hjdteZFXUfk4aVE/8bKzkuZZlx3Fcu6tSvstcjo/KsWDR91qEwjFdvODyTZ9noWIgew==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5023cde5-9c37-4091-364c-08de9ed91422
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2026 12:33:51.5856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2nQ6Uq3Ex35IOwg0y84ztV5sMsqa3d1anoFwKdkWFHmMsrZQMwETaqwiiKcjid6WYLFKrODx6Cd0X6nLCMJvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6638
X-MTK: N

T24gU3VuLCAyMDI2LTA0LTE5IGF0IDA2OjUyIC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBBZGQg
c3VwcG9ydCBmb3IgVUZTIHY1LjAgSkVERUMgYXR0cmlidXRlcyBxVHhFUUduU2V0dGluZ3MgYW5k
DQo+IHdUeEVRR25TZXR0aW5nc0V4dCB0byBlbmFibGUgcGVyc2lzdGVudCBzdG9yYWdlIGFuZCBy
ZXRyaWV2YWwgb2YNCj4gb3B0aW1hbCBUWCBFcXVhbGl6YXRpb24gc2V0dGluZ3MuDQo+IA0KPiBU
aGlzIHByb3ZpZGVzIGEgZmFzdC1wYXRoIGZvciBUWCBFcXVhbGl6YXRpb24gYnkgcmV1c2luZyBw
cmV2aW91c2x5DQo+IHN0b3JlZCBvcHRpbWFsIHNldHRpbmdzLCBhdm9pZGluZyBUWCBFcXVhbGl6
YXRpb24gVHJhaW5pbmcgKEVRVFIpDQo+IHByb2NlZHVyZXMgZHVyaW5nIHN1YnNlcXVlbnQgUG93
ZXIgTW9kZSBjaGFuZ2VzLg0KPiANCj4gV2hlbiBubyB2YWxpZCBUWCBFcXVhbGl6YXRpb24gc2V0
dGluZ3MgYXJlIGZvdW5kLCBmYWxsIGJhY2sgdG8gZnVsbA0KPiBUWA0KPiBFUVRSIHByb2NlZHVy
ZXMgYW5kIG9wdGlvbmFsbHkgc2F2ZSB0aGUgcmVzdWx0cyBmb3IgZnV0dXJlIHVzZS4NCj4gDQo+
IFRoZSB2YWxpZGl0eSBvZiBvbmUgc2V0IG9mIFRYIEVxdWFsaXphdGlvbiBzZXR0aW5ncyBpcyBp
bmRpY2F0ZWQgYnkNCj4gQml0WzE1XSBpbiB3VHhFUUduU2V0dGluZ3NFeHQuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5xdWFsY29tbS5jb20+DQo+IC0tLQ0KPiDC
oGRyaXZlcnMvdWZzL2NvcmUvdWZzLXR4ZXEuY8KgwqDCoCB8IDI0MQ0KPiArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gwqBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC1wcml2Lmgg
fMKgwqAgMiArDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuY8KgwqDCoMKgwqAgfMKgwqAg
NSArDQo+IMKgaW5jbHVkZS91ZnMvdWZzLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDC
oCAyICsNCj4gwqBpbmNsdWRlL3Vmcy91ZnNoY2QuaMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
IDIgKw0KPiDCoDUgZmlsZXMgY2hhbmdlZCwgMjUyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy10eGVxLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vm
cy0NCj4gdHhlcS5jDQo+IGluZGV4IGIyZGM4OTEyNDM1My4uYWE5NDIwYjBkMWMzIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy10eGVxLmMNCj4gKysrIGIvZHJpdmVycy91ZnMv
Y29yZS91ZnMtdHhlcS5jDQo+IEBAIC0xNCw2ICsxNCw4MyBAQA0KPiDCoCNpbmNsdWRlIDx1ZnMv
dW5pcHJvLmg+DQo+IMKgI2luY2x1ZGUgInVmc2hjZC1wcml2LmgiDQo+IA0KPiArI2RlZmluZSBU
WF9FUV9TRVRUSU5HX01BU0vCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMHg3DQo+ICsjZGVmaW5l
IFRYX0VRX1NFVFRJTkdTX1ZBTElEX0JJVMKgwqDCoMKgwqDCoCBCSVQoMTUpDQo+ICsNCj4gKy8q
DQo+ICsgKiBEZWNvZGUgRGV2aWNlIFRYIEVxdWFsaXphdGlvbiBzZXR0aW5ncyBiYXNlZCBvbiBx
VHhFUUduU2V0dGluZ3MNCj4gYml0IGFzc2lnbm1lbnQ6DQo+ICsgKiBiaXRbMzowXTogRGV2aWNl
IFRYIExvZ2ljYWwgTEFORSAwIFByZVNob290DQo+ICsgKiBiaXRbNzo0XTogRGV2aWNlIFRYIExv
Z2ljYWwgTEFORSAxIFByZVNob290DQo+ICsgKiBiaXRbMTk6MTZdOiBEZXZpY2UgVFggTG9naWNh
bCBMQU5FIDAgRGVFbXBoYXNpcw0KPiArICogYml0WzIzOjIwXTogRGV2aWNlIFRYIExvZ2ljYWwg
TEFORSAxIERlRW1waGFzaXMNCj4gKyAqLw0KPiArI2RlZmluZSBUWF9FUV9ERVZJQ0VfUFJFU0hP
T1RfREVDT0RFKGVxLCBsYW5lKSBcDQo+ICvCoMKgwqDCoMKgwqAgKCgoZXEpID4+ICgobGFuZSkg
KiBUWF9IU19QUkVTSE9PVF9TSElGVCkpICYNCj4gVFhfRVFfU0VUVElOR19NQVNLKQ0KPiArI2Rl
ZmluZSBUWF9FUV9ERVZJQ0VfREVFTVBIQVNJU19ERUNPREUoZXEsIGxhbmUpIFwNCj4gK8KgwqDC
oMKgwqDCoCAoKChlcSkgPj4gKChsYW5lKSAqIFRYX0hTX0RFRU1QSEFTSVNfU0hJRlQgKyAxNikp
ICYNCj4gVFhfRVFfU0VUVElOR19NQVNLKQ0KPiArLyoNCj4gKyAqIERlY29kZSBIb3N0IFRYIEVx
dWFsaXphdGlvbiBzZXR0aW5ncyBiYXNlZCBvbiBxVHhFUUduU2V0dGluZ3MgYml0DQo+IGFzc2ln
bm1lbnQ6DQo+ICsgKiBiaXRbMzU6MzJdOiBIb3N0IFRYIExvZ2ljYWwgTEFORSAwIFByZVNob290
DQo+ICsgKiBiaXRbMzk6MzZdOiBIb3N0IFRYIExvZ2ljYWwgTEFORSAxIFByZVNob290DQo+ICsg
KiBiaXRbNTE6NDhdOiBIb3N0IFRYIExvZ2ljYWwgTEFORSAwIERlRW1waGFzaXMNCj4gKyAqIGJp
dFs1NTo1Ml06IEhvc3QgVFggTG9naWNhbCBMQU5FIDEgRGVFbXBoYXNpcw0KPiArICovDQo+ICsj
ZGVmaW5lIFRYX0VRX0hPU1RfUFJFU0hPT1RfREVDT0RFKGVxLCBsYW5lKSBcDQo+ICvCoMKgwqDC
oMKgwqAgKCgoZXEpID4+ICgobGFuZSkgKiBUWF9IU19QUkVTSE9PVF9TSElGVCArIDMyKSkgJg0K
PiBUWF9FUV9TRVRUSU5HX01BU0spDQo+ICsjZGVmaW5lIFRYX0VRX0hPU1RfREVFTVBIQVNJU19E
RUNPREUoZXEsIGxhbmUpIFwNCj4gK8KgwqDCoMKgwqDCoCAoKChlcSkgPj4gKChsYW5lKSAqIFRY
X0hTX0RFRU1QSEFTSVNfU0hJRlQgKyA0OCkpICYNCj4gVFhfRVFfU0VUVElOR19NQVNLKQ0KPiAr
DQo+ICsvKg0KPiArICogRGVjb2RlIERldmljZSBUWCBwcmVjb2RlX2VuIGluZGljYXRpb24gYmFz
ZWQgb24NCj4gZFR4RVFHblNldHRpbmdzRXh0IGJpdCBhc3NpZ25tZW50Og0KPiArICogYml0WzBd
OiBQcmVDb2RlRW4gZm9yIERldmljZSBUWCBMb2dpY2FsIExBTkUgMA0KPiArICogYml0WzFdOiBQ
cmVDb2RlRW4gZm9yIERldmljZSBUWCBMb2dpY2FsIExBTkUgMQ0KPiArICovDQo+ICsjZGVmaW5l
IFRYX0VRX0RFVklDRV9QUkVDT0RFX0VOX0RFQ09ERShlcV9leHQsIGxhbmUpIFwNCj4gK8KgwqDC
oMKgwqDCoCAoISEoKGVxX2V4dCkgJiAoMSA8PCAobGFuZSkpKSkNCj4gKy8qDQo+ICsgKiBEZWNv
ZGUgSG9zdCBUWCBwcmVjb2RlX2VuIGluZGljYXRpb24gYmFzZWQgb24gZFR4RVFHblNldHRpbmdz
RXh0DQo+IGJpdCBhc3NpZ25tZW50Og0KPiArICogYml0WzRdOiBQcmVDb2RlRW4gZm9yIERldmlj
ZSBSWCBMb2dpY2FsIExBTkUgMA0KPiArICogYml0WzVdOiBQcmVDb2RlRW4gZm9yIERldmljZSBS
WCBMb2dpY2FsIExBTkUgMQ0KPiArICovDQo+ICsjZGVmaW5lIFRYX0VRX0hPU1RfUFJFQ09ERV9F
Tl9ERUNPREUoZXFfZXh0LCBsYW5lKSBcDQo+ICvCoMKgwqDCoMKgwqAgKCEhKChlcV9leHQpICYg
KDEgPDwgKChsYW5lKSArIDQpKSkpDQo+ICsNCj4gKy8qDQo+ICsgKiBFbmNvZGUgcVR4RVFHblNl
dHRpbmdzIGJhc2VkIG9uIGJpdCBhc3NpZ25tZW50Og0KPiArICogYml0WzM6MF06IERldmljZSBU
WCBMb2dpY2FsIExBTkUgMCBQcmVTaG9vdA0KPiArICogYml0Wzc6NF06IERldmljZSBUWCBMb2dp
Y2FsIExBTkUgMSBQcmVTaG9vdA0KPiArICogYml0WzE5OjE2XTogRGV2aWNlIFRYIExvZ2ljYWwg
TEFORSAwIERlRW1waGFzaXMNCj4gKyAqIGJpdFsyMzoyMF06IERldmljZSBUWCBMb2dpY2FsIExB
TkUgMSBEZUVtcGhhc2lzDQo+ICsgKi8NCj4gKyNkZWZpbmUgVFhfRVFfREVWSUNFX1BSRVNIT09U
X0VOQ09ERSh2YWwsIGxhbmUpIFwNCj4gK8KgwqDCoMKgwqDCoCAoKCh2YWwpICYgVFhfRVFfU0VU
VElOR19NQVNLKSA8PCAoKGxhbmUpICoNCj4gVFhfSFNfUFJFU0hPT1RfU0hJRlQpKQ0KPiArI2Rl
ZmluZSBUWF9FUV9ERVZJQ0VfREVFTVBIQVNJU19FTkNPREUodmFsLCBsYW5lKSBcDQo+ICvCoMKg
wqDCoMKgwqAgKCgodmFsKSAmIFRYX0VRX1NFVFRJTkdfTUFTSykgPDwgKChsYW5lKSAqDQo+IFRY
X0hTX0RFRU1QSEFTSVNfU0hJRlQgKyAxNikpDQo+ICsvKg0KPiArICogRW5jb2RlIHFUeEVRR25T
ZXR0aW5ncyBiYXNlZCBvbiBiaXQgYXNzaWdubWVudDoNCj4gKyAqIGJpdFszNTozMl06IEhvc3Qg
VFggTG9naWNhbCBMQU5FIDAgUHJlU2hvb3QNCj4gKyAqIGJpdFszOTozNl06IEhvc3QgVFggTG9n
aWNhbCBMQU5FIDEgUHJlU2hvb3QNCj4gKyAqIGJpdFs1MTo0OF06IEhvc3QgVFggTG9naWNhbCBM
QU5FIDAgRGVFbXBoYXNpcw0KPiArICogYml0WzU1OjUyXTogSG9zdCBUWCBMb2dpY2FsIExBTkUg
MSBEZUVtcGhhc2lzDQo+ICsgKi8NCj4gKyNkZWZpbmUgVFhfRVFfSE9TVF9QUkVTSE9PVF9FTkNP
REUodmFsLCBsYW5lKSBcDQo+ICvCoMKgwqDCoMKgwqAgKCgodmFsKSAmIFRYX0VRX1NFVFRJTkdf
TUFTSykgPDwgKChsYW5lKSAqDQo+IFRYX0hTX1BSRVNIT09UX1NISUZUICsgMzIpKQ0KPiArI2Rl
ZmluZSBUWF9FUV9IT1NUX0RFRU1QSEFTSVNfRU5DT0RFKHZhbCwgbGFuZSkgXA0KPiArwqDCoMKg
wqDCoMKgICgoKHZhbCkgJiBUWF9FUV9TRVRUSU5HX01BU0spIDw8ICgobGFuZSkgKg0KPiBUWF9I
U19ERUVNUEhBU0lTX1NISUZUICsgNDgpKQ0KPiArDQo+ICsvKg0KPiArICogRW5jb2RlIGRUeEVR
R25TZXR0aW5nc0V4dCBiYXNlZCBvbiBiaXQgYXNzaWdubWVudDoNCj4gKyAqIGJpdFswXTogUHJl
Q29kZUVuIGZvciBEZXZpY2UgVFggTG9naWNhbCBMQU5FIDANCj4gKyAqIGJpdFsxXTogUHJlQ29k
ZUVuIGZvciBEZXZpY2UgVFggTG9naWNhbCBMQU5FIDENCj4gKyAqLw0KPiArI2RlZmluZSBUWF9F
UV9ERVZJQ0VfUFJFQ09ERV9FTl9FTkNPREUodmFsLCBsYW5lKcKgwqDCoMKgwqAgKCh2YWwpIDw8
DQo+IChsYW5lKSkNCj4gKy8qDQo+ICsgKiBFbmNvZGUgZFR4RVFHblNldHRpbmdzRXh0IGJhc2Vk
IG9uIGJpdCBhc3NpZ25tZW50Og0KPiArICogYml0WzRdOiBQcmVDb2RlRW4gZm9yIERldmljZSBS
WCBMb2dpY2FsIExBTkUgMA0KPiArICogYml0WzVdOiBQcmVDb2RlRW4gZm9yIERldmljZSBSWCBM
b2dpY2FsIExBTkUgMQ0KPiArICovDQo+ICsjZGVmaW5lIFRYX0VRX0hPU1RfUFJFQ09ERV9FTl9F
TkNPREUodmFsLCBsYW5lKcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoA0KPiAoKHZhbCkg
PDwgKChsYW5lKSArIDQpKQ0KPiArDQo+IA0KDQpIaSBDYW4sDQoNCkNvdWxkIHlvdSByZW1vdmUg
cmVkdW5kYW50IHBhcmVudGhlc2VzLCBzdWNoIGFzDQoodmFsKSwgKGxhbmUpLCAoZXFfZXh0KSwg
YW5kIChlcSk/DQoNCg0KPiArc3RhdGljIHVuc2lnbmVkIGludCB0eGVxX3NldHRpbmdfc2VsOw0K
PiArbW9kdWxlX3BhcmFtX2NiKHR4ZXFfc2V0dGluZ19zZWwsICZ0eGVxX3NldHRpbmdfc2VsX29w
cywNCj4gJnR4ZXFfc2V0dGluZ19zZWwsIDA2NDQpOw0KPiArTU9EVUxFX1BBUk1fREVTQyh0eGVx
X3NldHRpbmdfc2VsLCAiVGhlIHFUeEVRR25TZXR0aW5ncyBhbmQNCj4gZFR4RVFHblNldHRpbmdz
RXh0IEF0dHJpYnV0ZXMgc2VsZWN0b3IgdXNlZCB0byByZXRyaWV2ZSBhbmQgc3RvcmUgVFgNCj4g
RXF1YWxpemF0aW9uIHNldHRpbmdzIik7DQoNCldoeSBpcyB0aGlzIHNlbGVjdGlvbiBuZWNlc3Nh
cnk/IFNob3VsZG4ndCB3ZSBmb2xsb3cgDQp0aGUgSkVERUMgc3BlY2lmaWNhdGlvbj8gQXMgQmFy
dCBzYWlkLCBpbnRyb2R1Y2luZyBuZXcgDQprZXJuZWwgbW9kdWxlIHBhcmFtZXRlcnMgaXMgZWFz
eSwgYnV0IHJlbW92aW5nIHRoZW0gaXMgaGFyZC4NCg0KVGhhbmtzDQpQZXRlcg0K
