Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062A1CA84;
	Fri, 11 Apr 2025 02:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339289; cv=fail; b=OyqtADFxchDfMSYxFlGbJ7fYY3vTIMGcXIb4TvMemlijlmzNE67T8yb+tCn06gfw82K+nFh8gJVmH7CVSnBYTb+K9VvwGlNPn1/JVtpyXRCaPUpiXuDLrqlrZhL122h8SzGKECYCBj0P4OV9beoN3I6HKzriyYymLjSd9VKppmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339289; c=relaxed/simple;
	bh=jGtfRL8UlRJL6/GPAwCuaHvJ2nCerNN4l9+0LO4ZDHs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mk1AdUqWdNKJNtFa/vybb8mGFyAlAr9yz5HtC6Qu8PRY8xQbDK4+M/0lTkWU3T5PZyw/ahIDXWwKPAbWVHjentPMZqNCyCdf/3u/nqLkAZthF5y6fzPvqx6wCrqM2biKJng63ksjlGBSomHoy0jWO6w0C5lhn4pUkqe7L9wPXek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=G7ZxXNct; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VZC9oht+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="G7ZxXNct";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VZC9oht+"
X-UUID: 73650f32167e11f08eb9c36241bbb6fb-20250411
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jGtfRL8UlRJL6/GPAwCuaHvJ2nCerNN4l9+0LO4ZDHs=;
	b=G7ZxXNcttFIDmEW5K9SSOzz8B0okedWyy1oe63w+zlqNLC1gK7dr1DswX9D2XQhUZT7rpZnFfhIhQuZEJeNyRkVUMqKxPdxkhdX/uN9bHHf5beowDbR3Qymq6kNkjOqoQoJzbwXJX/NYi4WUmlMisEBCnzDWATkE9eeJsDzBCPY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:6f7a5381-0dc2-4ccb-a33d-8d9a92576c29,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:8f44798d-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 73650f32167e11f08eb9c36241bbb6fb-20250411
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 291070531; Fri, 11 Apr 2025 10:41:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 11 Apr 2025 10:41:19 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 11 Apr 2025 10:41:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oiCVtYmzFeu3ZieWhffCc38rWZYkmRedRmhEtm9M50wr6Ad9JqnxzmPm1NleJ9P/vqedNtltrVya+oWe8MNssVqCUXDIntYaP61GzKeKPNBa1ETMm8UHgGUuWaAkU1bF0IaAils8tWEnU+y+JjCbNBoY0n5xFBlCuhAmd9JcPjiRupzUPIrGWuxiUnIfzobYMAHY9DXw+k38QFmDy3dP1+uVyKt0TUyf4P3p37/YBoxWnT5nJiTV55PqPe9012ShKqO4tgkN1f7h/xW7330BHxVnEUw6/XlJfVqsJGTH+hOvt74JTz81POTanVzqdXNwWTLAKT5wTxbt9p5VhaO20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGtfRL8UlRJL6/GPAwCuaHvJ2nCerNN4l9+0LO4ZDHs=;
 b=i8rLm8hrrhRdrmYhTTTWbHRmY0VP/VMTCV+sTZ/BiYWJPS0fnKgYAoqAOOEUV7V8vCQe9ePsRB2+3LLhYOIL4cSHzE4ACz2w+y2BJ/fyHYAK3J1zMcgTEmZoLwvERUlhM6TrY+c7acy+UsJPATth5uhn3lQy8JzKEMPqrVlcTSHKHNRIn4O6GQuJ5ZeJtWhXleyn0eqbVXU7cVTxgXCxwlr/2NztbhugTXb4VY+1MHgZiyFciVFhFOdyhgp8gj2GV3yfb5ly2nRNF1mg9Y8+giLOx0JXMsXF1psuBVnFocS+QU+0oFhio7JOiO5X/0kWi/urn/smb6lC+YrDnkZ0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGtfRL8UlRJL6/GPAwCuaHvJ2nCerNN4l9+0LO4ZDHs=;
 b=VZC9oht+yRGXR1CoW+C0QkzLwZBPAPmuiQvxrLzPFJnJjDjK3kl0XhKD9vX1/ASj2CP0e1ISPf+dQjXqM4y9QMEwHI5rcSSy9sALJUNGi+IcT2QMmVji2KWF+2BFdw7tzMyeX96ugOBQfuezxaFcHjSv/mWy3WIIAOed3/YIJP8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6809.apcprd03.prod.outlook.com (2603:1096:101:64::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Fri, 11 Apr
 2025 02:41:13 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.017; Fri, 11 Apr 2025
 02:41:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
	=?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= <stanley.chu@mediatek.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Thread-Topic: [PATCH v2] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Thread-Index: AQHbqa1tbx1roHMV9UOUyhOl5cTUkLOdwt4A
Date: Fri, 11 Apr 2025 02:41:13 +0000
Message-ID: <3b0e14cb3162cc1bf6ccd3ccc5af7434da9960b2.camel@mediatek.com>
References: <20250410001320.2219341-1-chenyuan0y@gmail.com>
In-Reply-To: <20250410001320.2219341-1-chenyuan0y@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6809:EE_
x-ms-office365-filtering-correlation-id: f97fa3b3-bf14-4b31-bd1f-08dd78a2531b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?U05DUk1YZlpJam1JTnVFNDBuanFmMnArWmNWWTNYenpnSFV1S09HS28wTkls?=
 =?utf-8?B?MWc4a041ZXQvTm5OTUJkQk5FYTFmYldLV2lCUlVjcElpTXpFV3dpbiszcWQ1?=
 =?utf-8?B?QzJyUTFxMDhndzZKYUZzK3JZZzFpQXprUEJrcFpwVmRlNzJrbHZibDVoNER6?=
 =?utf-8?B?NklNWjgzMGJ1VDlpQjZ4OU13QlRpVmwxZDBiU0d4S09UMVVFcGJ1WlIyTFVk?=
 =?utf-8?B?cGE2dHFTZUFUWUR0WW9IR2gxRXdBYXhlV0VXTDZMNGJ2L3ByRVBSdWM5RXJm?=
 =?utf-8?B?TnJJeEh3YnUrMUFZWEVNOHQzS1J4dlhUMy9hV1ZQcjBYZ2VSRVlsTkNQeWZQ?=
 =?utf-8?B?UFhHd3JtSFU5Nyt6SmhzZGFHdE9xSytCWFYvRDdxRHV5U2tmcmJIczYrVE5U?=
 =?utf-8?B?Z2VwUTNvM1lqQURpS0hMWlBNaE9zb1ZiN21BWkcyYk9yUi95dUhwdWR2cmRi?=
 =?utf-8?B?MXZDeVc0K2VoQlFzYjhoeVFyQmxtbXBMQnljaU16L1BBOGg1YVZmUW55eS83?=
 =?utf-8?B?TlNWS0lxN2RuVlBER0h6K3BJQm5yUWMzNER4QUVDRTFpQTQ3QStWVDhieTVt?=
 =?utf-8?B?dGpIOTlrdUlhK1daVlQyNFpJVmp4bkpCQXJRNS9yN1A3dTBVaXFYbnhUZEcx?=
 =?utf-8?B?MlFsbTJhMDBCU2NzWkMrYzdMMVhTcFprdW9KRlZiMjVZaDJsU0REZUlqNC8x?=
 =?utf-8?B?WDl6YkNlcHRGTU81Z01MZFo2TTBRbUJhbC9HRDJBODdRa1YxODlLZHdwNlZy?=
 =?utf-8?B?M0QvQklWMnJqUUtvK0llVUZKby9LTmx1Z2ZhZlhMTkdMaHljbG1raDd5VXlO?=
 =?utf-8?B?NndKL3hGcW83aVlsaHIxNXhIYWF5R1B2U0RNWERLT0traU5la3hESU12VDZ2?=
 =?utf-8?B?bWRzd2hQT3g2Q2g4eVpFSG9EaHl3QmIrUlkvWHovNTNwZHE1amhoVWZGTjNw?=
 =?utf-8?B?THlHZTY3TWxHQVZZdmtyN09DMXZCRkpkNXJzOVh2Z0ZnNW1JMVRiTGpHZ0di?=
 =?utf-8?B?OW9ZMUEyOStvK0poNjU3V3IrS3lMM3ZSQzl0Tng5QTRpQjVKeWFjUExEM1Nx?=
 =?utf-8?B?M25heXUyTUN3Wmczb0pvdERFcjdOUE4rb2tsK2dVY2JnQTFTT1ZOWTA2LytR?=
 =?utf-8?B?V253Rm9LV0ZXVERLc0tjVUZURmJQNlJSSU1VYmdVS2xFS2ZuTkNEcEZtcGpZ?=
 =?utf-8?B?ZWp2ZmhJanNVVEdFcXc2SUMwb1lEZnZRanBJamhTQlRsRStwNk1wTmVsNFVi?=
 =?utf-8?B?eXo4TFJZK251SGtTOUNjcFJlam5TYm1QdWFLVkk2Q3JEckhuL3FkVnd1aHZ6?=
 =?utf-8?B?T3BLVXo4Y3FOR3NvbFlTS3Jra2UzTk42TmFFMFFycXlwWUs1T2hxUUh1Zyti?=
 =?utf-8?B?bXBoQkJ6UzVGcFYxQ1RIS21ZVmg0d0lTbTc4NDAzVUo3dTdDSTZHcTA4Yzlv?=
 =?utf-8?B?dWdIWjVXMkk2NWdpOGpDVDhGaHpwbHNaY3plVnFRYmttczZIcWhiZndlY2Y1?=
 =?utf-8?B?VG1WOVZqTVJ1WDNzWDdrY3hEeE1MMjBUcU9IbVhIeEVoVjdRMkNRUmh0SFJL?=
 =?utf-8?B?MDJDNTZiK1BGTjd6eHBLcUw4RXZoczlNR2NVQjlpYWYzbjdjVTEyMXQrdWQ1?=
 =?utf-8?B?bVAvVFl0azJISE9OZS9md2s0blBuUTFueTZMVEtkeElCbzNxYlhsWkx1UGVo?=
 =?utf-8?B?YXNIYlJKVUNmQUNkbk5yQi9QQ2JlQ2RHcStQS0lRMUQzTWdDYkY1MG9wbEJx?=
 =?utf-8?B?NjFYT3RBRmZvM1lsYk5yRndwb0xEMDAzUkFtMlVSWUduYWVPcUU1OXlxU1Nq?=
 =?utf-8?B?a0VVZHJraGVUby9GT2tSUnFCaFhDVmJLbzNDRG44MmVUcm9ucStUajZPMkdu?=
 =?utf-8?B?RC96QnhZTmNydDk3K0ZEbzBoVlFlVTdnYzkvSVl4T2J6cXZDemc0S1RNM3Ny?=
 =?utf-8?B?VFFxYjdkUUZyVlZNamZVcEZrbHdoOEhCTlJHTzQ2d1lRaDV5dWxrYnJQWnpq?=
 =?utf-8?Q?oiteP442sIAZrNdOBUjBtpRSj51xoM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXRoSFpsOTRkWSs3b1hvdzc0RjB1VGg1VUwvZmdyOTBPSEc4eGVTNG5rQjI2?=
 =?utf-8?B?K0MrZTdBWS8vMFlDTXVIang3OFQ5ZTF0STJNUUhXQUVIMmNaWWxzdm9SUVVm?=
 =?utf-8?B?MEpsZHV3bkMveStEVU0rZ00rdGRRbHd4WGtQWTFXWmlzMG45eTZoQVJNSVNU?=
 =?utf-8?B?ejhuWm1kVjRmTUlFUWROMnZCaW1ZNDNXcThaNWlCOGx1U1NjVStPc2NXbE5S?=
 =?utf-8?B?T1JUam9oaHpJS1NQMFN3TkNLTFNMMUhZV2JMSUZqZkIwYTU0THF1SGlZSDl4?=
 =?utf-8?B?ZnJjSlljMS9OdUJaekkwOUZkd0N6K1YwMjJLdFZ3TTFNQmpoQ3BiMVJWWU9G?=
 =?utf-8?B?dytnQXVTS0NYVEZFcGpTdkI0cVUyYUhVVlQwTnU2bklqczZudDlpNS94OVox?=
 =?utf-8?B?TkFSVnZUb0ZSQlE5MHZBSUE2YkJuQ1c2cGx5UEhYNkpNa09qTytieVdWd3E1?=
 =?utf-8?B?SDU0UDV4dUlBUWlubzQ5SHlDL2xIWkIwZ3RleHJia0kxSCtWTHpXYS9XQXdO?=
 =?utf-8?B?S2VkMHdBck5CbndkV0dtZ2RNSU1pQmJFcHdhbHRvSzNCajBncVNrUzkrb2VV?=
 =?utf-8?B?dzlPUW1qSTVLcHpqMzhoVnp6ZEg0Umx6SWVGN1FaOEhMOUI3OVVVbkl4USta?=
 =?utf-8?B?cy9NNmFEL2JZZTJybWgwOVNtaGRqS0RUL3MrY1pYSnJPWkxlNUVwaFUrT1lU?=
 =?utf-8?B?TTZTeXRoKzZkU1hVd012K3kzQzl2K1R6Zkprb0JmdWVaQ1hueFNaVHNSaU9k?=
 =?utf-8?B?NzhodjU5OGE2dDZFbVd6ZlVZS2w3K1diVFo0eUVDdFZ1RVI3a1RBanRQdjNo?=
 =?utf-8?B?QkR2QTlUTFBWT1JiT3g4SEl4YXZCcFhVdUJWYzY4ZnhQT1NCSFlQL3BmVGhH?=
 =?utf-8?B?djVQVTdkN3ZWZzRkM1prODRpTldiK0pZUUl4bWQ4Vk1qeDJTMTBoZ05HcW1D?=
 =?utf-8?B?TU9uWmh5UWpRU1J4WUhqdTdIeG9YM21JRXNncTJlc0dORVIybVI1WVg2b3lI?=
 =?utf-8?B?cTFxMzhmdVBVei9OUWtYMGdaYzFSbFZtaWdBSXVoaTFtYVpLUkVpbWp0Z0Iw?=
 =?utf-8?B?WkhFSXEwalJxSUJ1SW5VMUtYVzdHTHcxK2ZlMzFoYjd6Wm5qUkNHbHc2aERE?=
 =?utf-8?B?SWVnc3QxUzJLbzNmczcrN0FmaUYxNytjUFpsS1RUaXRTdmxteXpLQk43U3ZK?=
 =?utf-8?B?YnlvRk42VThNV2t2NTNXVy9QeVc5QXkxUmU5MzN5ZFAvTGZJWVVqeGI5cG9i?=
 =?utf-8?B?R200NGFRQmY5MXlCeTVFbWxoSGFZZ1dmM2xqZlhKQndLbWlhVlJsRDN0UDUx?=
 =?utf-8?B?Nmp3MmxRQzIxWjFid2hqUCtNdUQwVlJaUktQWkRtNzZuR0REajhWMWZ2Z2xs?=
 =?utf-8?B?REdPaGs1dHV0dGc3T2haVFBJMGRsVllYOUNiU1lxTDdJd1dPT0FBaUhOLzZr?=
 =?utf-8?B?S3FHR3B5bk1iemUvV2FtM0NMZko3SXQ3bzBwMzJOZGcwczNkL1oxY3RsK0pY?=
 =?utf-8?B?TEh1V1FiSWY1aG93M3JSU1ZINmFkSEZzUmlmczk0WUJCTE5GQjJkbVNUWDFG?=
 =?utf-8?B?M2pUUkxWUk9EaWhLN3VmYWpwanQ2eWQwQmJFVkRuVElMRDh1RDRKbUdaeGE3?=
 =?utf-8?B?L3ZxVHE0VDFFcWU2OU9QQjRuVEovK1dRTEdEZW1UMHBMMGV5TVZuOUZXL0FS?=
 =?utf-8?B?WTRERlU5dlc2Z0pzM2ZyY0ZMdlBzVys5cVFyWDlEVGNtUlZyTUhPQkdKcEt4?=
 =?utf-8?B?Qlo0MHhrNmxmNFRzNDF2bkxWSE85d0RXdXRMUit6ZnpaSzE2MnhtTVNlanVw?=
 =?utf-8?B?UktRWE93T2NHc0hMNUhGRFNuMG1CRnJRaE1lNTNOSllLbUozTTlwMVhuQVQy?=
 =?utf-8?B?dkt4NnA4bXgrbzJaM2lrWGNmRnlXWUtaQlNESy9FcjVmb3FEL1pzMnpUY2FQ?=
 =?utf-8?B?SkZvakl6bzVOb1h2ZU5ETWVVYjdpYXB0cGcyVy9oN2ZFUE9NemJWOCtoYTd6?=
 =?utf-8?B?Zi84R1gzc2h4ZWtnQ0FLdmxaUmtkT1ZyNmFzUURYemlZWGpQQzR6K21PZnFp?=
 =?utf-8?B?MjdoamVnZHFVSlpqMFAyVUV0alBxM1h6KzUyR2N5MFFhZHh1UkxjbGFlT2oz?=
 =?utf-8?B?NDRXay9PT3RQUVI4M3ozWGlFaWZqWXBRR2YxU29uejhEVHN6cmV1MTNJTUh6?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6B91AC47015B048AB76FD9B23571AF8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97fa3b3-bf14-4b31-bd1f-08dd78a2531b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2025 02:41:13.0514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcGs9P4yQjrSBYeHVr41/ui72Oq97Jsu/iwnYo0HPwFeLwrmpAYrKBpoaRgbXb4RW5CKTWqmoK9Brmzky/QZZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6809

T24gV2VkLCAyMDI1LTA0LTA5IGF0IDE5OjEzIC0wNTAwLCBDaGVueXVhbiBZYW5nIHdyb3RlOgo+
IAo+IEEgcmFjZSBjYW4gb2NjdXIgYmV0d2VlbiB0aGUgTUNRIGNvbXBsZXRpb24gcGF0aCBhbmQg
dGhlIGFib3J0Cj4gaGFuZGxlcjoKPiBvbmNlIGEgcmVxdWVzdCBjb21wbGV0ZXMsIF9fYmxrX21x
X2ZyZWVfcmVxdWVzdCgpIHNldHMgcnEtPm1xX2hjdHggdG8KPiBOVUxMLCBtZWFuaW5nIHRoZSBz
dWJzZXF1ZW50IHVmc2hjZF9tY3FfcmVxX3RvX2h3cSgpIGNhbGwgaW4KPiB1ZnNoY2RfbWNxX2Fi
b3J0KCkgY2FuIHJldHVybiBhIE5VTEwgcG9pbnRlci4gSWYgdGhpcyBOVUxMIHBvaW50ZXIgaXMK
PiBkZXJlZmVyZW5jZWQsIHRoZSBrZXJuZWwgd2lsbCBjcmFzaC4KPiAKPiBBZGQgYSBOVUxMIGNo
ZWNrIGZvciB0aGUgcmV0dXJuZWQgaHdxIHBvaW50ZXIuIElmIGh3cSBpcyBOVUxMLCBsb2cgYW4K
PiBlcnJvciBhbmQgcmV0dXJuIEZBSUxFRCwgcHJldmVudGluZyBhIHBvdGVudGlhbCBOVUxMLXBv
aW50ZXIKPiBkZXJlZmVyZW5jZS4KPiBBcyBzdWdnZXN0ZWQgYnkgQmFydCwgdGhlIHVmc2hjZF9j
bWRfaW5mbGlnaHQoKSBjaGVjayBpcyByZW1vdmVkLgo+IAo+IFRoaXMgaXMgc2ltaWxhciB0byB0
aGUgZml4IGluIGNvbW1pdCA3NDczNjEwM2ZiNDEKPiAoInNjc2k6IHVmczogY29yZTogRml4IHVm
c2hjZF9hYm9ydF9vbmUgcmFjaW5nIGlzc3VlIikuCj4gCj4gVGhpcyBpcyBmb3VuZCBieSBvdXIg
c3RhdGljIGFuYWx5c2lzIHRvb2wgS05pZ2h0ZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hlbnl1
YW4gWWFuZyA8Y2hlbnl1YW4weUBnbWFpbC5jb20+Cj4gRml4ZXM6IGYxMzA0ZDQ0MjA3NyAoInNj
c2k6IHVmczogbWNxOiBBZGRlZCB1ZnNoY2RfbWNxX2Fib3J0KCkiKQo+IC0tLQo+IMKgZHJpdmVy
cy91ZnMvY29yZS91ZnMtbWNxLmMgfCAxMiArKysrKy0tLS0tLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdWZzL2NvcmUvdWZzLW1jcS5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMKPiBpbmRl
eCAyNDBjZTEzNWJiZmIuLmYxMjk0YzI5ZjQ4NCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9j
b3JlL3Vmcy1tY3EuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jCj4gQEAgLTY3
NywxMyArNjc3LDYgQEAgaW50IHVmc2hjZF9tY3FfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21k
KQo+IMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gwqDCoMKgwqDCoMKgwqAg
aW50IGVycjsKPiAKPiAtwqDCoMKgwqDCoMKgIGlmICghdWZzaGNkX2NtZF9pbmZsaWdodChscmJw
LT5jbWQpKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihoYmEtPmRl
diwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIiVzOiBz
a2lwIGFib3J0LiBjbWQgYXQgdGFnICVkIGFscmVhZHkKPiBjb21wbGV0ZWQuXG4iLAo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2Z1bmNfXywgdGFnKTsK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gRkFJTEVEOwo+IC3CoMKgwqDC
oMKgwqAgfQo+IC0KPiDCoMKgwqDCoMKgwqDCoCAvKiBTa2lwIHRhc2sgYWJvcnQgaW4gY2FzZSBw
cmV2aW91cyBhYm9ydHMgZmFpbGVkIGFuZCByZXBvcnQKPiBmYWlsdXJlICovCj4gwqDCoMKgwqDC
oMKgwqAgaWYgKGxyYnAtPnJlcV9hYm9ydF9za2lwKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGRldl9lcnIoaGJhLT5kZXYsICIlczogc2tpcCBhYm9ydC4gdGFnICVkIGZhaWxl
ZAo+IGVhcmxpZXJcbiIsCj4gQEAgLTY5Miw2ICs2ODUsMTEgQEAgaW50IHVmc2hjZF9tY3FfYWJv
cnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQo+IMKgwqDCoMKgwqDCoMKgIH0KPiAKPiDCoMKgwqDC
oMKgwqDCoCBod3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2NtZF90b19ycShj
bWQpKTsKPiArwqDCoMKgwqDCoMKgIGlmICghaHdxKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZGV2X2VycihoYmEtPmRldiwgIiVzOiBza2lwIGFib3J0LiBjbWQgYXQgdGFnICVk
Cj4gYWxyZWFkeSBjb21wbGV0ZWQuXG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBfX2Z1bmNfXywgdGFnKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gRkFJTEVEOwo+ICvCoMKgwqDCoMKgwqAgfQo+IAo+IMKgwqDCoMKgwqDC
oMKgIGlmICh1ZnNoY2RfbWNxX3NxZV9zZWFyY2goaGJhLCBod3EsIHRhZykpIHsKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyoKPiAtLQo+IDIuMzQuMQo+IAoKUmV2aWV3ZWQtYnk6
IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPgoKCg==
