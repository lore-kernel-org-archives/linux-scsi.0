Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525D208B9
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 09:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="irI9EqrT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="FjNU8YWx"
X-UUID: eec5b1f4aae611eea2298b7352fd921d-20240104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TXPLSgReLm+aU3E/P7tyAn7Zmy8xAC4apIFAE7rzdlI=;
	b=irI9EqrT94y7Mi3b3qPTJNKxbTSgSg8KemhJ2NUefbdvLCptahPgYDh7ROthyNw7QqDAk8TfNZafcZOE7oR06Ob2GkAg3rcL4unqtXmF2ZQC+3PmGCALHQ8BvrRYm4BaZse7/d53cKkI2yCkQicCLkUgW3gMV+LnOF9l4RbWnWs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:38b33f28-2d06-4a8a-a7af-ace9417d0407,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:e4217c82-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: eec5b1f4aae611eea2298b7352fd921d-20240104
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 568642660; Thu, 04 Jan 2024 17:52:12 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 4 Jan 2024 17:52:10 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 4 Jan 2024 17:52:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8e1AEMOr/Z1ns+HD4PjN8BGvqi16kzZJIPu/AhiQoGgsNEzqkpaXnUrh1T/nN8VcVMR07gwzmQoZ2ppFsw7Rj6Lt8/7P2cltmeH/4LsMoANoucvwzth4S/pkhoQ2imMWszhHYiHfjpgm8wFF2dANg5DoMg3MTeTnMSmXIt+nR+nZMCX+lJGB1EWgMZ8cITdatai7Fmfeb1RDSRedOt601wHkukocEqti2Spx4aZcBQY8Y1Qnqi8yf3avTIiT4MRVm0ovWx/zR11GqJMpfgGyuZKYfsi9hjzWVLzxTb7uQEC211/LrDbQKfT5KxKa0Lbq3t7wB13qzIj0YOU492gug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXPLSgReLm+aU3E/P7tyAn7Zmy8xAC4apIFAE7rzdlI=;
 b=HsRw3QJTN01XXIO8HNs4HubN830kEV2vUVIIouCnH6MUmae3cwp3Jzp4iKfrTiJCYCaD84oP5b+Y7tLbTSeI44kJ4IaUmCuwGNwq4jSDBmuTgWCv6u/oSHrycb7hrTE5RMxS0t1rv6qh/UEbrqeaV/QGxjrawVxMarZNod9S37kRw7jZWGg+PT2y0ynB9zMJDnukP7ihAtnRlWDQjYgeTsFg1bzaFE1hZ7PBTbrK5ittTB9ylA+YrVe1PKSSGj8ZbTGZk0WMs8nhP1rJiN5W425N5AVWXdOQa1gwAZxYjnPSZmoihxoTKWfelF3FX/sQRWXF7h0kGTsFIG22AM/qjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXPLSgReLm+aU3E/P7tyAn7Zmy8xAC4apIFAE7rzdlI=;
 b=FjNU8YWxcCw+Ef+GzRmnwLISoEV/RsGhBs9+IrUcTat30ZJ+Qnu0QupaXwcwD9f/ONz9BtNpl0Ebvv8HyIePjEolIUSt7sTcRvtcvHTdrDchQn5m1RPIyFL0PBAU/ZnaijypwX4O5Ko5CTvJ+Djxh4hcRas6B1gN1YpofSlIkpw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7436.apcprd03.prod.outlook.com (2603:1096:101:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20; Thu, 4 Jan
 2024 09:52:08 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::4cdf:58fb:79dd:4b7f]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::4cdf:58fb:79dd:4b7f%4]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 09:52:08 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Thread-Topic: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Thread-Index: AQHaPvK5Q+ZsexHxP0yL3b0RbOoldLDJaXWA
Date: Thu, 4 Jan 2024 09:52:08 +0000
Message-ID: <543800c0b840ac1fd2943b1bc1fe909937be3e68.camel@mediatek.com>
References: <20230322195515.1267197-1-bvanassche@acm.org>
	 <20230322195515.1267197-80-bvanassche@acm.org>
In-Reply-To: <20230322195515.1267197-80-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7436:EE_
x-ms-office365-filtering-correlation-id: 4c35d6aa-0735-4f16-aeb0-08dc0d0ad0ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O03Qb3LVdPUMsSxemUs0n/yJ6FcomAmXbnyMLMwqzAgHdLX58U6nThzNMO28fb6SkIPVSyM+uEX5OqY28LbLXRI5k5PUh/aUnrmiT410Qqz+Rv8XxdQc2w+fvCDkXujaYJmf0WOSa6A5UgHU9ZfdQQEjqzAtbI3FhkYdwxYHxf2BFdfeLZs70dKTh/ib3q8FAp1TTpxz/ojTsNKT5OCfTj8+8LysseSlJDSLF5jyWAvDzsFOo7WavK8OctVVvFv6400Su/Q5M/r0DHJ2uY9fNRVFrsKtuID3ClbFppTghWzJpnV1bIIntuYXa9LqsXyZ2HV4mfd86lery3cBcCm4I1DFiUQSMmFp6vS3/+wKKswAyTqhUMU0hugElT2XXh/4T3sfY8RXV9Js3MT5qRdBbrEeR0r6F7HEsBHW1MXwW3vWe5s1PZQAK7kRB36P3LCGAovglmAkvkHZcbRcWhFzNQt33Ir3BjjmuHHobQqRlR5NjVrVx24jRde8ZbuT7QhmMhFDmbTVNatp31W4Qw2tN+NtUYgRd4G+OgV761Cc0YT9npRuSiuSHtXYhpGRqar327Eo/ghfek4MzyZSD1lNTuTj+Pkv0Hh4fWGY8KJCk/HhOrbB1OlXayXUaIqo9TaIj0VCBQWmlHyygMPScO4B4vN+P9oPvpbQ0LOAflgDL00ZX8JJwguFvjiINDT0gVpB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(2616005)(26005)(107886003)(6512007)(71200400001)(478600001)(83380400001)(86362001)(38100700002)(38070700009)(122000001)(8676002)(54906003)(316002)(4326008)(4744005)(2906002)(8936002)(64756008)(66556008)(6486002)(66946007)(76116006)(91956017)(66446008)(66476007)(5660300002)(6506007)(110136005)(36756003)(41300700001)(85182001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEp0M0ozUEg2d2luSkMwaEUvTUIwaUprckp4QWF6U2dhRStDU3JBQTlnNVl1?=
 =?utf-8?B?S3VoTzluUUtYZU50Z3MyL3VrbTJ2YzdpZFpKcnNqUzdBYWtVbnJ6eEdoclJB?=
 =?utf-8?B?KzlKN1FiUFVqcUc1RmVVamRlM3o2R0lIYWpzaG5sS3BmWEV2b0Zld2l2c3Iv?=
 =?utf-8?B?ZmpSRHNZWU9aR3R0KzZpbVRIK0EzUzU0a1Z1ZUg0SnFpNnNnMUdxNW91bUVx?=
 =?utf-8?B?ZXowNjJQT3ZhNTRFdVhjSWJaVUQ1eW5ldEJYVWQ3WDYwNFFjWlNlaGU3azlC?=
 =?utf-8?B?cFd6WGpxTktyalR3M25pekZ5MHQ3V1pFdTR1NkZySmFDODdSM0RwREFKdHM0?=
 =?utf-8?B?K0czZmo4UVNYZVNlTURxcjVETzZsdERySStvTjM3UlFuNytoYW1nMUFndzV5?=
 =?utf-8?B?b2hwTy9EVzN6K3ZQeFRkZCt2U1JVNXUvdWVYUkZJWGt2Z0o4Z0ovRGdCNnJU?=
 =?utf-8?B?MXB1Ui9kQXhFZmxoVjlBVk40ZVpYSjZFZ2NxQkZkWEFRdDBPYW81R1loSGZs?=
 =?utf-8?B?c2dNZmk1SndENUdiMGxzcUxLUHBIcUgvWHFTMjV3UjdLTUtHUUx1UzJnTTJk?=
 =?utf-8?B?YXE0QWszTUVRc09ON0tNMHdpK200OFRYTjBXblZCd3hQZXo5S3UvdzZZYmhE?=
 =?utf-8?B?VElmOXlkK0g0ZDQ4SGJWbHVJbFkzU20rWDIxQUk0S3FxZWdDMG5DTVR4WlI4?=
 =?utf-8?B?elNsSlZkR3lCMnZPWXdvblhFeVh0TkJ1UGdaNmkwVWpaLzhWZi9POEhISmx1?=
 =?utf-8?B?My8vRlhPMWoxdjNkcUtJWHVEZEZ1VXRIQVNRc2FUNDIwbDhoMEtpZTgwa3Q4?=
 =?utf-8?B?WXVONWJ3cEdUNWV0TThKYlh3VFdyLzNsemVOSlowa0NrOWJQTkkvN01FVHkr?=
 =?utf-8?B?MmNVRE8zUTQzZVZzQWthUTVnQTdHdC81d2VMaTBNWllEVXJ1VkVoSTREUFU4?=
 =?utf-8?B?ZS9teWg4cFBlZUxtMGwzdmJLYm82WUszWEw5cVNpcGJXR1VhY0dWcVFjVUFx?=
 =?utf-8?B?Z1pCaHRWc1JNa3kwQ3FMZklDM3JwWUxyYWJwaFNzZ3pWU050SFFlQnJBZ29H?=
 =?utf-8?B?djQ4amozQ2hESXRwcG9ZWEI1aTFQcnpCSDNDaUdrWGs2eEpOdlJHcGZMNWNp?=
 =?utf-8?B?dEJFckN5WHVmUW9hWGpwZ1U1SDY1elBqU01LUFdPY1VHRTVpbFV2NmlNdUh3?=
 =?utf-8?B?SmRkWGZ0a25HUHg4dURFa3U1NmM2TnQxRTFLcTZPTWNRTmxyYWtKSmdDY0dX?=
 =?utf-8?B?ckMzWm1XemI1VmU4cVlKRm9mUDc0WVNyODBxWkk3WkkvV0RlUy9uZUk3SHJi?=
 =?utf-8?B?b1V5anlwT09wc2M4TDQwM2NmQWtsL0FSOGx4cGpYZGpVbXBUYVRUNkJ3aWov?=
 =?utf-8?B?eVUvdnFHZXJjTXc4RE00OWt5eERZbHdDUys5bGtKanA0NnVoWGdkUXMyOVZj?=
 =?utf-8?B?eGYydmEzNW5Uei9YeGI1ZldIeSsxSGtoelNGZ0l6cVdOOHgwbjY1UkJsYnpj?=
 =?utf-8?B?d3N0eVF6bmdtSTZRc2FpSzk3K0JYYlhxbE8zTjVhVmhkeWNKTGFqeEZ6Y3h1?=
 =?utf-8?B?cEV0YnpaV05QZUdGdzh4M0dQT1NTRmxUak00K1AzVGVuei94Mm1nQlNTZ0Jy?=
 =?utf-8?B?UWRpRkt5enVxTURGcmRtMHdLbWYwZzI0ekhvbUFLTFk1SG5SbDVMOFhONWU4?=
 =?utf-8?B?MlcxQit3NkQ5dmZwT3pRVjlUVmc5L0pIN2Z0TUZHVGJUVmU2Q1Y0UThvRFU3?=
 =?utf-8?B?UUkwZ2J4ZFNENWJJeE9PMTdWZ2hRckFUcVhJeUprcnJYYVdkcjJmUW9tY0Rv?=
 =?utf-8?B?VEM3dTEwV0xoQ080RmNDTDgzREVDZE1KRkNyY3Q0eEMxVTlnSGJuc0l1MUhH?=
 =?utf-8?B?VlFWKzJ3THZGUkkwbDk4MTNOYUE2c1lJcG5HNTNTNkJ3cGV5SXdzTkNjTWZS?=
 =?utf-8?B?KzVMYmJyZ2E1ZGhTSEt1QlFTQUhTYWpBdUpFWlUzODV2eWltODlzdWNYZWdE?=
 =?utf-8?B?akhFVUJLdVBhQ1lQVHBSZkd6dDI3NVBTSzVpTFdxaU1ILzVEbHFjL1NtR2dU?=
 =?utf-8?B?MWJvR0lUT0dIcEJNTzF2bHEweWtKR3BaMTVVWmdwbnAxTE1SeXF0ZGlBSG1x?=
 =?utf-8?B?Nko2T1VjMUR4MlB2dG5aaHp0QkRZUTZpcXdpYmloazk1M3d4ZktnK0h3M0ND?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB34FD41A3914D408D0B83FF271E8842@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c35d6aa-0735-4f16-aeb0-08dc0d0ad0ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 09:52:08.0964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SsVhI//qvvf7ZY/UOMVkEFDUUa5ts7CNFlfvZoQk8KJHD3ei3Y4aCPl0uak2ygaI52KyK6deNoLzPxljZGE+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7436
X-MTK: N

T24gV2VkLCAyMDIzLTAzLTIyIGF0IDEyOjU1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE1ha2UgaXQgZXhwbGljaXQgdGhhdCB0aGUgU0NTSSBob3N0IHRlbXBsYXRlIGlzIG5vdCBt
b2RpZmllZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2No
ZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAyICstDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiBpbmRleCA4ZTdkZmFhZGM2OTEuLjM1YTNiZDk1YzVlNCAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC5jDQo+IEBAIC04NzUxLDcgKzg3NTEsNyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFy
aWFudF9wYXJhbXMNCj4gdWZzX2hiYV92cHMgPSB7DQo+ICAJLm9uZGVtYW5kX2RhdGEuZG93bmRp
ZmZlcmVudGlhbAk9IDUsDQo+ICB9Ow0KPiAgDQo+IC1zdGF0aWMgc3RydWN0IHNjc2lfaG9zdF90
ZW1wbGF0ZSB1ZnNoY2RfZHJpdmVyX3RlbXBsYXRlID0gew0KPiArc3RhdGljIGNvbnN0IHN0cnVj
dCBzY3NpX2hvc3RfdGVtcGxhdGUgdWZzaGNkX2RyaXZlcl90ZW1wbGF0ZSA9IHsNCj4gIAkubW9k
dWxlCQkJPSBUSElTX01PRFVMRSwNCj4gIAkubmFtZQkJCT0gVUZTSENELA0KPiAgCS5wcm9jX25h
bWUJCT0gVUZTSENELA0KDQpIaSBCYXJ0LA0KDQpUaGlzIHBhdGNoIGNoYW5nZSBzY3NpX2hvc3Rf
dGVtcGxldGUgdG8gY29uc3QuDQpJZiBtZWRpYXRlayBob3N0IHdhbnQgdG8gbW9kaWZ5IGRlYXVs
dCBycG1fYXV0b3N1c3BlbmRfZGVsYXkgdGltZXIsIA0KY291bGQgeW91IGhhdmUgYW55IHN1Z2dl
c3Rpb25zPw0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
