Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1141EE031;
	Tue, 22 Apr 2025 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745308312; cv=fail; b=DS+CDrwPTok52hWZFZTfpekgS6zOqXLumHyPpEGBEEkuo6G8rrS5K35DGI0C7DivCSvnxQk9ejkG0SiGG7nf2ugt7GNpWfCSIzEkDGtzPPOBmnazY+yv+bXFxAWPHgfXhgoQV1hLcMTlN85Y5GkAWdUD6gv9te+/5yQcE2uommc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745308312; c=relaxed/simple;
	bh=d2ELULppAgqTyi2F8NHPMu/4PPqKORCXgh51GO06k4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RFz9thBRtk0HaOcrvq8rz7EmDC5HcE5FiFfFoYUfPaajVzyagelDGNcbAY/QRMUUWdLq4j1C1dhXJGCYnozLV2YmVg0Yeu0qgfP91tQZ0Dz4jaAnW9A5p3jgHnCOK6ZNWPT0ceUuzjId9B8lnJKZQg+uE2MjofmZFZQ/UaMZLb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Pam6X5Bg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=eWskCw7q; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Pam6X5Bg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="eWskCw7q"
X-UUID: a2701c9e1f4e11f09b6713c7f6bde12e-20250422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=d2ELULppAgqTyi2F8NHPMu/4PPqKORCXgh51GO06k4A=;
	b=Pam6X5BgnLe0Gls5xTfNXj35GKA3SsnsbjKEUepDcT1gYUJixz4DIW0uPaESD/rSPb/oIn0iq8aRYdr+lK7mhee0Zha9rxT14hnA/8cVq107apfUZnt5XHwhCmJs7jsHcONOPA3i0XcrFYbXbaUyZB0cgpd3ijDuvwpYljzcyGs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:eb0f2f1d-1383-41e6-bb71-96032bac7de9,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:1ae1e48d-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a2701c9e1f4e11f09b6713c7f6bde12e-20250422
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1263700169; Tue, 22 Apr 2025 15:51:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Apr 2025 15:51:42 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Apr 2025 15:51:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CA5WGnguj3d2w3LgsRi3E8OeTCgFdoQaBo05I/lxM2UDUlim3XaNXz5TRQ5yihbjv6LS94I2fdqWA+umyc1MJUzYgXw+U9hYXAFbIpht2D5efEZf2o1Ee25a0R12Byvu924FIEBKIQWzg5l/ZDQZwgOBZTyavNCnuYtXWO6j6pXCJiO5+1P3aJn1YpCMT3XNeuJ7Kt+3BH0rzF8EyO9T0qC8gp/ezeaeOK3MJ32Gml52fFuRTafajD4T7vVqnUfIoDOe8/+NuefP/Kv/is5Cql17OPqXEY1ZeWlI0KxmjryTXvXD4R0x5xniSOtsYVo0dv8PKp0bQUpH7sGT8/hvuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2ELULppAgqTyi2F8NHPMu/4PPqKORCXgh51GO06k4A=;
 b=SMeFhYuSXz6d1FgB1M/1GtsQfRLMGqNcO6r7Ju85JzGo5nmvFNPRB0nuhUAy27F6URthZgsSPn6/ucxr/cjqibh90mb85jRzDc0jPxAyXJ0QjjwhzwP6kd5dHZOwwG+55XlrSv2TBkiLoGYRYrn++O6/hkrmamqLPWl1SpyFpXW2zwkvP/NelMX8Sfb22Zrc720GjPhYjoOP9PPsZ44Ca8tVj06Y+XdswDz/f8YFGVrLHaXGvAdRr66Tuj8AjouFYM9dMyM3Vj0qQltyyGgnla1Y0TS/MsGnMYfZl66AUlC9I+rydJ7Sm8VnQ4qdhA8HQAquArvK4yBcpsMfPipD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2ELULppAgqTyi2F8NHPMu/4PPqKORCXgh51GO06k4A=;
 b=eWskCw7qrfdJu/g5QvDUgwuten4+Q/CUN2mN1BEktvo2nJpXH4Ibm9KfoqGJB4NIePmXqWcMupGE5yhr3W6p3lWnpdBsxsYo58YhyyTYxHB3bNGXFM7c+xfR5N3lmMDJCXbLiNoXFOT/cBnOB7zPK14ya1qStYzUSdq4kvHK6DQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7498.apcprd03.prod.outlook.com (2603:1096:400:413::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.32; Tue, 22 Apr
 2025 07:51:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 07:51:39 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "tanghuan@vivo.com" <tanghuan@vivo.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Topic: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Index: AQHbssSSR8RDBDpfF0WntZunJXCCD7Ou/pcAgAA6rYCAABf1gA==
Date: Tue, 22 Apr 2025 07:51:39 +0000
Message-ID: <ada5e578b647b71e85ab1a7eccd7401f7b4d2700.camel@mediatek.com>
References: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
	 <20250422062555.694-1-tanghuan@vivo.com>
In-Reply-To: <20250422062555.694-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7498:EE_
x-ms-office365-filtering-correlation-id: 8268f7a4-75cf-4863-8c81-08dd81728420
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZGd3TDdjUTZpMi9XNUN6aGw0bDZCRmxOSXdKb00ySmpUeHRkUDMwb1YwbTFx?=
 =?utf-8?B?RGp3WVJHRTVDYUlLa2MxU3hnODE2MEZnRG1FSzZDK25RT3ZhRjhZN0dWNHB2?=
 =?utf-8?B?eFVkdTdpRnh2YlhSelVqYTB2SnNCLzIxSmxzR01WYmoxYUllTDhKZ3JTeFI4?=
 =?utf-8?B?RFV6TTVIcndhc3hUc0VLVjhDUnhOZmFxL25tRDlITlJlNmpnelQySEx4N3FN?=
 =?utf-8?B?MnMrRmkrSlNWRzhNTUFrRmNjQXVJU3U0MmhJMVlTSCtLVHRBdDBEOVVUZlli?=
 =?utf-8?B?UGdyakhFaHNPdExzWnFWU2tzazJWYVlPTEZna3FGN2F4aG5UdHYzVWcyUWxz?=
 =?utf-8?B?SzY4NlQ4bzZsSE1OaUMwNzJKa3lPKy9KUkQ1Q0NJUmJGSk9wZlBaRUt3STBl?=
 =?utf-8?B?UUJvRDFPcnR2N1RqNGJNQWNWWktuUm4vMlpsUkRXVWdsbDBZVy9rMlQrbkdu?=
 =?utf-8?B?TmJUNkJlbGVSN2R0T3QwVjZ5ZysrYncvTXhBOVJ2cCs3RWRMbzVialZ3VmVk?=
 =?utf-8?B?NGJTZGQrRDNheFBQVktMNGFMK09YTVR2eS9ZQ29NKzlqVW9WMjhJak5ub0Fl?=
 =?utf-8?B?dVN1endOdWN4ZlRoQ0R0NHdRQ1F0OWk4T2YzSHIzckhHdHZ1N0RFTmVZSzFq?=
 =?utf-8?B?YXdQTHluN1RyR254d1Fta3N6N2VzRmtEaEQvbVZFWkZ1UXJCYmsrdmUyN0RZ?=
 =?utf-8?B?dThsMHdGVGxHREpZZXRucE9leitZWGZRT09Qc2Z6WlNyd3RDeEI3VlVXdWkx?=
 =?utf-8?B?SDUrY1FHVko4cEYvdWcrWHY5dXdPSXhrN2JWK0NlOW9EeEF2YWhzRFBtWnB4?=
 =?utf-8?B?a1QrOUpKeW5CS3BHZHFvakY2dDFCaUdJYWZpODFkRUphNWpvejhKK2Y3SVFv?=
 =?utf-8?B?K1dRdzU1dXBndHpvUGhuM2Q3YTZxMTRoa2NzdVp3eVcxUHRmNUU1TjZsZU54?=
 =?utf-8?B?SzJpM2dPTGNScm0zbXN4dmx5UVArMjg0VEVIci93Z0svUkFOVE5uOFVxN0Zq?=
 =?utf-8?B?ZDZlaHRDbFJwcFErTENncXBoaTJQNTVZS0UzMS9wVEM5NlRaNm1GME5PS0tN?=
 =?utf-8?B?ak1KYVhwbFYremN2YXZybkxyMFBmSUNwRWo0UExtc25jWGFIVlNmR0ZQUFUy?=
 =?utf-8?B?RXdTeDVieWNwV3NNYjhFZ1FnUkxtWnNGMFdqNWd4YkZlRXo0SnY5MXVSUnJJ?=
 =?utf-8?B?MXBxRld0eE5JbFpncU0za2xPN0I4T0JpVzA4OUMxZUxQOVJsamw3NlZrVkRT?=
 =?utf-8?B?NytKWGo4bXVZZEp6K1hrYVZCdGhNSzNXMHMwajBDWHUvTjYyajViRXB4dW9v?=
 =?utf-8?B?WE9RTW9Pa0h5T0FxdmxFTnRid1h0V0k5dWRwUVdGRXJkYVNVd2hEbGpadUdw?=
 =?utf-8?B?TFNFZFhoTC95dnpmdTlJL1JUbmpDaURFSEw4U1NpTS9zVXJESy95VVdkajVr?=
 =?utf-8?B?WlJGY1Zlc3pyL1pmbHhxZUlKU3RpUnhxMlJjejFub3hEaTJzekdwN0NSTVQy?=
 =?utf-8?B?dXdxZVRMS1U0b1Y2RnpteHk1aWhYWm5KOUpSN0p6SkowalpwYmdNNFM3d3I5?=
 =?utf-8?B?Ujhhdm1XbWM0RWxvVnN4Qk9SUVFmZkxvK0szQ0loTVo2QXhzazZONS9hRWMx?=
 =?utf-8?B?amg0UEVFRkFKZGJhOHpEVkJSMjF4dnh3RDh6bUI3eW1Lb1dqdEorZllObTNN?=
 =?utf-8?B?WUpxWDUwL0NNbHlLdVI0NGs4MlF5bzBjUHg3Z1Job2IwUjNEd3kvelIzWWRZ?=
 =?utf-8?B?WVRTWERKRTg4OWRtbjJ3RW9HWFpXZTNhLzY5RndhemZjWG9uZU40MlZEZC9S?=
 =?utf-8?B?aERSVmtNM0pITG5jc0FBMXlSOFozMXhtaStES0xBaW5hejBaTmlzL1BLNEF4?=
 =?utf-8?B?eU9NWkF4OEVRZC9FR1dzNjc1UGNia3VoWDYyclR4U2tIdStqdjAxV1JhZCt6?=
 =?utf-8?B?TUJWekVTbHhRamFWaHRqcWg1OUtpRDV1cEFmUi9jL3VFQk5weStaODlMVk1S?=
 =?utf-8?Q?TLhxxb9puWxbwI5rqq60iPejQargXo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3RUM1ZleUhvdmg1SHZVWnhDYjBPZ2ZvT2dhQVM4ZEhWMVZCdStETC9pcEEw?=
 =?utf-8?B?Nks2TU1ydW5JaDJGNG1ZRUc0QjIza0k5ckhFd1VVYk9tWm1LbXpQRkRuZU9n?=
 =?utf-8?B?MHoxZllhZXBBdkw3em83K3dRUEJ2ejU0bXJaZEZnSkMraGt6STdzWU5TSVNN?=
 =?utf-8?B?SHc3KzJxUENxUy9XUkM4MHQrWDRncEVPQXJUM0xiaFYvV3RNb3BoODB0VnVw?=
 =?utf-8?B?MUJ0RDhjUlAzUlozRWJoTW56bmplMUVwRDY4S2FaaU1xV0ZYeW5WaGtENEw0?=
 =?utf-8?B?OEx1OUpFd2xGMzdZbU1WT3RTbkluUGhONzlvUUJ0Wm9DTkpSQXBpZnkyemJW?=
 =?utf-8?B?cXNqVkVyR00zaXRqMGxpOTREbWplZmhxdXVKdUtWK1EyVXRYODJTVzl3QVdo?=
 =?utf-8?B?UnUzUmdwWHFldkd4aHVsMmFqMWkxK3VVNEt3T3BCS3lIZXNSM0RDSW9lakEr?=
 =?utf-8?B?R1Yrc216clhQcjh6Ymd4YnVXR3cwcmI3QmRXK3RqRVhXcXA5aFRwMllzZHNC?=
 =?utf-8?B?MTQzTkR0NXFXZDVSY0o2QkVhOHRvTVQrenYvNWFFL0tTVWVFakswdGU2c3Qw?=
 =?utf-8?B?VWxUQVF4bWs0Z3h1dWJNZWlmOThzc3lndUhLSE5TN09PQkcrelV3VkFiYzNL?=
 =?utf-8?B?SjhiSHV3bFFDS3gwQ2pyUlNoOHVYdHFSUXNNNGRUOXprMG9ZaWdvc1JBdlEy?=
 =?utf-8?B?Z3VMS0FxQmc3T1BlSVVQVWxhaStVQXFiOHVDTmM0THFEOGNmZ2x1c3RCVCtY?=
 =?utf-8?B?T3VDK2gvN21Bbmk4OTRBdHFBLzhaVlJGTWU3QlgvcUlLTGpsQ0cyOHNpaWw3?=
 =?utf-8?B?dnBReEtBYzVpOU96WG9acDQzZTdiV3JLR213RkFKdFdGY1R5bHU4am1EaVA1?=
 =?utf-8?B?T2V0aXJTUFh6RlQzQnI2SEEvclZlWjN3aUEwSXhJYzgxbHRuZ2pPZU9PODVo?=
 =?utf-8?B?RmVRaTQ1UlN6aXZwTENqeUhnWEQ4Z1BxUzJsRnQ0R3M5alc1dWowdWtSUTc1?=
 =?utf-8?B?MmpraWY5dko5WWZ3dkgxRWhuZGJ3OWpwSEl1VE1lNHhkOURMZFdpODF3Z2ps?=
 =?utf-8?B?N01qTTVUV0ZNbHlsK2g2N1ovMlFzYWZXcXBhcmt6YnBSNkZSMkxIWjJUbmt1?=
 =?utf-8?B?MTRCQjJZa1lsV21DQmxQWnhReldCaDFjY2xOSTAvS2VaUGxSRTBjOVN0Q0VW?=
 =?utf-8?B?SnR3bFY4M2YvYzBibDR5QmQ4R2d3Vm14M2V4YmpMdDNsUnFYZFhlaXJLTXdV?=
 =?utf-8?B?Z3YydnczK1JZaWpUeTdPUEFWNmN2Uzg4eFBYeGNPYXJsVnRiTmdNZlV1QU5V?=
 =?utf-8?B?QWdTUXhtYUNmbjlZMWllU0I3eDFuZVZiaGVUVzRWWVBzV3cxMGx1ZWFTWXpW?=
 =?utf-8?B?YS82SEJtTHpMRTUxbXBEWjRFbnFqdGdKTnJiWVRwUG1ucU1sU3JZbFpObG5i?=
 =?utf-8?B?a0dzait5cnRQNWZNTE5JMUxKZG5kcDU4cFM2dVoxZWlGSzBnSnhGVjZHL0pi?=
 =?utf-8?B?VTVHS3lpUUdIaEJ0R21jOWsvSWpDZmxaZmoyTlBuSnoraGxudnl6QlBGZ2VV?=
 =?utf-8?B?a2lpWW0wc3pPb2V6emlYK3l3czlWaTdaY2Z0YUM5ZWhyZTlRSHlXR0NVVkVD?=
 =?utf-8?B?SlNmQVJDUTNLenR6QWZ5SW1RVzBTV0V6MlJBNHBvTCtTMnliUElRV04ydXVG?=
 =?utf-8?B?NnF4TDYzTTV3Nm5ESVBxSjNGRWR6SGdCdStZMEsxS1ppcHc1ZUxnOTRjRHNL?=
 =?utf-8?B?aGdRaGlQaktIeGx1djNxc0VLUU9sWVhTUlpzQjZMc044MDNsNy9RUG5vRUly?=
 =?utf-8?B?OGEwNEJVaHF6eWdhZWJ5dEs5Q3Nvbzg2UHZlRkZxZWgwRDA5anB5UzMxU25Z?=
 =?utf-8?B?RkFpTFAwT1M2enVsSkFHaS9sNS9Hdko4cDBsd1dwelU3QU1PRXExOUU0SDdr?=
 =?utf-8?B?aGcxMHp2aUVPcVlJbktLRWZTUkV6RFJzQWNjOEF4bjJrWlVwWTMrMmVlQkEv?=
 =?utf-8?B?Y1ZYSnV2c2dKdzRTaUFseUFTQ1VTcGUrQW1hQkFCb09SdVJiU0IzS2FQK1JO?=
 =?utf-8?B?LzhRTzluWUtCSmJvQ0lXWCt3S1lzaVdTaHJnRjkySnhtSUxFY1dFa2w4YzBZ?=
 =?utf-8?B?UW1ZZkFYYUhEaGV5M3E1bmxNMFVrbDF1bVlqWE1kSVB4TW0zQWJCNUJMSHhY?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D20BE05F44E6D40B9BD6840DEE5E7A6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8268f7a4-75cf-4863-8c81-08dd81728420
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 07:51:39.9162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zeG6vxlAK8jFQcnI3DB2s0ytvAiiQZ6lfzYAEc6CDyb/lXdrYAXOj65BQc6R+7C2Q3BW0amfDJ8TYs+NNjebCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7498

T24gVHVlLCAyMDI1LTA0LTIyIGF0IDE0OjI1ICswODAwLCBIdWFuIFRhbmcgd3JvdGU6DQo+IA0K
PiBIaSBQZXRlciBzaXIsDQo+IA0KPiANCj4gDQo+IFRoYW5rcyBmb3IgeW91IHJlcGx5IQ0KPiAN
Cj4gSSBmb3VuZCB0aGF0IHVzaW5nIGxvdy1lbmQgVUZTIGluIFNvQ3MgdGhhdCBzdXBwb3J0IE1D
USBtYXkgY2F1c2UNCj4gDQo+IGRldmljZSBsYXRlbmN5IHRvIHJlYWNoIGV4dHJlbWUgdmFsdWVz
Lg0KPiANCj4gDQo+IA0KPiBNeSBpZGVhIGlzIHRoYXQgYWZ0ZXIgaGF2aW5nIHRoaXMgcGF0Y2gs
IEkgY2FuIGFkZCBoYmEtPmNhcHMgJj0NCj4gDQo+IH5VRlNIQ0RfQ0FQX01DUV9FTiB0byBkaXNh
YmxlIG1jcSB2aWEgdWZzLXFjb20uYyBvciB1ZnMtbWVkaWF0ZWsuYy4NCj4gDQo+IA0KPiANCj4g
RG8geW91IG1lYW4gdG8gYWRkIGEgY2FwcyBVRlNIQ0RfQ0FQX01DUV9ESVNBQkxFPw0KPiANCj4g
T3IgcmVtb3ZlIGhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX01DUV9FTiBpbiB1ZnNoY2RfYWxsb2Nf
aG9zdCwNCj4gDQo+IGFuZCB0aGVuIGFkZCBoYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9NQ1FfRU4g
aW4gdWZzLXh4eC5jLCBzdWNoIGFzDQo+IHVmcy1tZWRpYXRlay5jPw0KPiANCj4gDQo+IA0KPiBU
aGFua3MNCj4gDQo+IEh1YW4NCg0KSGkgSHVhbiwNCg0KV2hhdCBJIG1lYW4gaXMgdGhhdCB5b3Ug
bmVlZCB1cHN0cmVhbSBjb2RlIHRvIGRpc2FibGUgdGhpcyBmbGFnLiANCmhiYS0+Y2FwcyAmPSB+
VUZTSENEX0NBUF9NQ1FfRU4NCg0KQnV0IHRoaXMgc2VlbXMgYSBiaXQgc3RyYW5nZSB0byBtZSwg
YXMgTUNRIGlzIGEgVUZTIGhvc3QgZmVhdHVyZS4gDQpJdCBzaG91bGRuJ3QgYmUgcmVsYXRlZCB0
byB0aGUgb2xkIHVmczIueCBkZXZpY2UuIA0KSWYgaXQgaXMgdWx0aW1hdGVseSBjb25maXJtZWQg
dG8gYmUgYW4gaXNzdWUgd2l0aCB0aGUgVUZTIGRldmljZSwgDQp5b3UgY2FuIGFkZCBhIGRldmlj
ZSBxdWlyayB0byBkaXNhYmxlIHRoaXMgZmxhZy4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQoNCg==
