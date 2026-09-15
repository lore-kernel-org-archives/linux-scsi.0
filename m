Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2106.outbound.protection.partner.outlook.cn [139.219.146.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244F470428;
	Tue, 15 Sep 2026 09:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463759; cv=fail; b=V0xL1U/Y4Zc9inkZNKc5rOWZll25KDTSeOg8jnRPx6fqeeDQKbYlmyXNXnXcEgyC+EmHSotNf1kwgD+WSVzv4By7jlkyNHYRk9QUTmq+J6mg1eHkp2k2QlvKfWGzD9a6KkGuHVPrG9H42DzDNBgyqFmz+UUkpHYtShjKx4ywAk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463759; c=relaxed/simple;
	bh=RrQIL0a0JAYvSdqeCjE3VDJNEVYivZKXbeV3Y2HHAY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sD0lWeRHG9Y5FM811n9176HwJa8036y1A12wSvS9oC6lj3CbxDv30NPuqze8GYUIIZNBuiogQLb8i2wUF9AcY1LJpDJJn4u+FYrF4dPzWvGdG4E9LZBme45X0+90dUZzlD3arFKQQ7mZbS2oORIfmXxpJ8xFOHQvEjCvGzH2ENI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzEwI9Px/dzDdbvILiNo8unKs8SKz0f/SqNLLw86QkiwofLJ7wnfvCiSbAcTeY9kBirqijblhZtx4kbAI5tMvRYYBlXnMYHkmWrI/MtIVsC9XpI0gVdsLlcl//cp1XA7XSIV43XFbnVLBqzqvduVJZeFadOK7eTTom8PzJJlLW75DQNMH/d7XQLKk0mrLUi0cnLxGlZ+eHVUN/mMIn9LAcaqW09j5qsBjGlkg+8HvfZ2CcALrkv4vZL4V47DbcxGx3VXxdnG1xHVY1X/S3s297oD6A6NW1Dzm8Ifu1vD+bh9a3yafkdShL+YXtH6eOUcoeGzdMW/Rl4D7zdgv+1LXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrQIL0a0JAYvSdqeCjE3VDJNEVYivZKXbeV3Y2HHAY8=;
 b=CWRlgR+A7UWqrLaww8gqP08ckaxgfYRieLFqwN8dttuCu0BdHveuj96RFS+TvvPLH2XjZNIoQRg8LcPz9NZlCtl9LE1qnJYl3r8wPSbc46gTrdAmBXyNerIU0rIiRAfD4/ED6ZmUj3PlTNjQuNbE4Z9VLoc7WdAmBl2+aC34PJAjYN3s6zXD/Hdogar2ji55l/hxBEKeYAKPoepxZEh8vB/x8Nr2BnzASjgfiSSnotjsuoYXvh1cXnH5MNWlZLusm8hFhqIh6roA/0aUppq/0Cz5G0v7xRegbEMGT+FMv6586sNMZ0Sr4VGzPp/BQYo03+Jb5EStZG2GtR5lOy++9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) by SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.18; Tue, 15 Sep
 2026 09:15:39 +0000
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 ([fe80::9b99:12dc:a115:b90f]) by
 SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn ([fe80::9b99:12dc:a115:b90f%4])
 with mapi id 15.21.0339.017; Tue, 15 Sep 2026 09:15:39 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, "James E . J
 . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, AngeloGioacchino
 Del Regno <angelogioacchino.delregno@collabora.com>, Rob Herring
	<robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Thread-Topic: [PATCH v3 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Thread-Index: AQHdQdewnHb9oCCp6E6SI0e+7xBo7bbKvngAgASjYyA=
Date: Tue, 15 Sep 2026 09:15:39 +0000
Message-ID:
 <SHXPR01MB0863DB4797EABB8056E6697AE6BA2@SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
 <20260911102359.83288-2-minda.chen@starfivetech.com>
 <aqUorPJziAtWeSG0@squawk>
In-Reply-To: <aqUorPJziAtWeSG0@squawk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SHXPR01MB0863:EE_
x-ms-office365-filtering-correlation-id: 65b4661c-c5a6-4874-8e29-08df1309e8e9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|3023799007|4143699003|18002099003|22082099003|10067099003|38070700021;
x-microsoft-antispam-message-info:
 anf7SawkRfJkY38R2lcsA5DzPFFRSiqpK0bQqqOArCP7WrxOEQTHTvoNMzVLEzf/2w1j5BJtRvBh2HrhcAMboAE5xCrbrXVskJnlSM3LO1muXAB/K/vTCeCTerZwehzfQJzgxhxLobn7Flik0KNC5T/TjA60q+BspMfziSQZmEV1HshedO1isErcWADVc4NIQFDIlT1LmWeF09vgnQfVxq62YH9INf29uFUGbuJyvlcB9FzHpCZO/x1kVRQ9Qc6HzRRjMuPCmvYLEhM1S8Q30WW//N5udHInp4kP8okyPRz2Jo+RddNlwwSt6NUVYx74Yd30HkyIfWh4XcPaAhFQvt6gIDSy8ndpF7/K5QBa68T7vz1xvHekFbUzAbTeayWl9PoYnM0hYZ6T45M0kceSToKxlL8AeCEgDwIo+u7gEm7k/vxA9+U11L3QgfL/DYcuyogIM2/JAOXHAX7L/Vak1/VV9W6KDTHIFJLxdJZofp4K473j2BNzJEqb4Szvu9npriYvF8/ed18BMBJzMjPYLvKN4RBMidehnsfz721QB0W++PlPJBSsNj7N8VBghxTA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(3023799007)(4143699003)(18002099003)(22082099003)(10067099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?RDZsc001NmhnUHVlNHd0UjFlaWlzcFpUS3BZTWVkdlNZMHhVUlEyQXlYM21L?=
 =?gb2312?B?SjJnYjlMd2lRWjE4RGpXbzZkMGhwallQTTUrZmwrc2tqUjRCQkhYNHgzWmNX?=
 =?gb2312?B?TXQzZVBuVTFZZzdRaHpEYnlrY1daYmV4OTVmUk44VmxxV0NVK3QwTVhPMzRu?=
 =?gb2312?B?RDVQblpNUHc0V2lVT2xZTWdobm9way9pTlQrVjEyK2lkaVZCZFBuNEZVL2NO?=
 =?gb2312?B?YVh3T0tTc3Rua3AwM3NNUHdMTEFldVRCVGlDZ0Qrdy9YaFRMUTRkY25mTDl1?=
 =?gb2312?B?RkU1eXFDVVVOVWNWL0ZzcTF2Sm1zc2QrTTQyZmdKOS9TVHRZUEhoOUhFYUF1?=
 =?gb2312?B?dGhheC9VWS9GY2dNaklRem9laEhlZ3lTajhPWGdlakhBakxDWit2UmM0T0ZR?=
 =?gb2312?B?Wlduek5RWGlFTjBBV0Z1UVk5b2Q4eU1ZNUNiV0RleWhZd3FRS2pXVG1uZkdX?=
 =?gb2312?B?UUdmVTcvMkxESmM0bmRoamF1bFFnUC8zYXVwQ0gxYUJxajRKS0FYVGdCN256?=
 =?gb2312?B?YWl0b2hJS1NZL2lTMlZHQUJGd1liZDNJNGlGU3lWLzRRZTZ6VGFJcS96UDhI?=
 =?gb2312?B?TXZaN2lpWU9DNXV4bUZsMWxBNkswVkNLWlQzMnNFRDZLd002OWFkYlNaNDZq?=
 =?gb2312?B?TlNxNUFRME9MS0tncUZlbTkrSnBQYUh1aVliTmtQbFE1TFBKb295a2JnQTBI?=
 =?gb2312?B?UDhTcmsxV0RQNE5vMEZraFMydWUyMlphK25Bdmpnemt0cDJqVzhDT04vZ3Jh?=
 =?gb2312?B?eGZOMUNGMlpHK0IyRDlGMk5FR0hyWUlyU1g5cUdlMEUyaW0rYTZBRGV2QjBo?=
 =?gb2312?B?TkhuVzJjMmhsQWhwWWwyTjRHdG5qNFlDaDFRaS90ZVBzOENnUmxBMWVyMmVN?=
 =?gb2312?B?aVVkRG4vZGJteDluemVQVUlYeHpZc2gxSFgyV0MxaUdpellUZ3lUMUxBd2tX?=
 =?gb2312?B?L0hnZ0JuUXRra2RzVFU1ZFl4NUsrK0NZRktFMDdmMXBiOEQyRWVIemMrV1FQ?=
 =?gb2312?B?NFlKNnhuekhkcjdIMVdGSjBZUE5yNVJLcUlPQVJqNlBVMW9xQnNEV1NDRjAz?=
 =?gb2312?B?Z1BIUkV6czZRdSs2RURoM2ZRbFRid2dDT1V1a1ZITGpndjdqMXlucmhxeG5h?=
 =?gb2312?B?ZHUwRkhTMkU2eHd6OUxMREdVbmh5aWVHbld1QkV3V2Yvd1ZWMWNPdjExY2lv?=
 =?gb2312?B?TUNKYktpYUZFQUYyWmRUY1R4bWdQa1MzZHIxWDZoZktFWjBaWWNUODhITFJm?=
 =?gb2312?B?c0l5ejNqNU5CWXVReEtucUhZVzhETTEwMlMxajlGaFpEbEpsWm95K0NYMldJ?=
 =?gb2312?B?RExNSEdsM01haWo3YXRMeVp6c0dZZnlseWg5bGZGYUhjRUFTNkl2S3Q5dVRM?=
 =?gb2312?B?RHphVkFGZG9QTCtNVzlxSHpLMDQ4MVhEcjJiWklXeEdCaWhpMGRacmE2MldV?=
 =?gb2312?B?U2huVkhnV2Jmd1RmbHZ3QXFvRTBuektlUXltaVh2eXJvL0lhYTdsWUdrSjRS?=
 =?gb2312?B?ZUFKb0NVckJoQmR1YUIySkMzSlZtSm5EWlJPRlRJWWlSVjdKV3NCK3hnRXJ3?=
 =?gb2312?B?VnF3RUMwM3lIcmhqSkM1aTdyRmg4REtyeVJvaWl0NVc1S01IcExDS3M0VEVZ?=
 =?gb2312?B?eWE0WFBhR1cvUW9Rbk1wQnYrQVFhUnFNT2tDeGNDaDJhUEhXeTI0aC82RmVI?=
 =?gb2312?B?YS9zazg4YzZZMlp3Y1JUcGQ3bHA2TzFmQXA5UWlQc2JHNXFtYXVlOXZkS2s2?=
 =?gb2312?B?ak5UVjlQUlBOajY2UnNTcS9FSWNqWk5vY0hBUmE1bGp3RzVFQmR4NFUxRnNz?=
 =?gb2312?B?MGhCK1MwWDkwRXBGQXZoc0JBek1SNW1lUHhBOXYwUk45dHZCdEhVOEtJSFh0?=
 =?gb2312?B?dnhQZTJsaTNycnlKZE8wMUJ5T3hoZjJJUGhGWjlFdXFHSEozRk4yM0JZRUs2?=
 =?gb2312?B?OTJVa3lQRHk2M3B0ckxJU0Y1R3Y4WG9VYitXNHVqVzBJb1lyWkhyWlNJN0My?=
 =?gb2312?B?Nnl1MXROYzVabFZLYVdza0d2VDJJU2FPZ0p5VjFzZ0dBaXpkVXhvWlBDOGNT?=
 =?gb2312?B?bjZYRmg3bUc1QjNBT3ByZUlSNXRaczFMQ2loZVFGbGxha1RUL2lwejNQMnQ0?=
 =?gb2312?B?N0tvSVFJL1BacnhoYnMvVHZ6YlU1Tk5FZzB5Q25VQ0tvZGE0MGtsbTRwSDFn?=
 =?gb2312?B?Sm1JYUlNWEpBSjNJOHV2cjJFMlEvWm1aKytTbmo3U1lzRjRzSEZTelBQVHla?=
 =?gb2312?B?bTl1TlJzdjZLbVNhcit3dXdFT2srRmdxVmcvQlhvbTdsTHFMUlRmWXV0OUJp?=
 =?gb2312?B?eTFMNEdmdzN0eHlRbjRoUFB4TVRzcWFnSE5LNFZidkVPRXUvWDRVUT09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b4661c-c5a6-4874-8e29-08df1309e8e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2026 09:15:39.3004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHWvyAqdqErg+19tz4jQoZZ3P1cruiRScGBvqVOwGSv16DbhwZff1B07WusudN2Sy9kQjQqMhljmY5sV1z8FL9zNPIaL6R0S4Jb+wS9HIkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0863

DQoNCj4gDQo+IE9uIEZyaSwgU2VwIDExLCAyMDI2IGF0IDA2OjIzOjU3UE0gKzA4MDAsIE1pbmRh
IENoZW4gd3JvdGU6DQo+ID4gQWRkIGRldmljZXRyZWUgZG9jdW1lbnQgZm9yIFVGUyBIb3N0IENv
bnRyb2xsZXIgU3RhckZpdmUgSkhCMTAwIFNvQy4NCj4gPiBUaGUgVUZTIGNvbnRyb2xsZXIgaXMg
YmFzZWQgb24gdGhlIFN5bm9wc3lzIERlc2lnbldhcmUgVUZTIGNvbnRyb2xsZXIuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBNaW5kYSBDaGVuIDxtaW5kYS5jaGVuQHN0YXJmaXZldGVjaC5jb20+
DQo+ID4gLS0tDQo+ID4gIC4uLi9iaW5kaW5ncy91ZnMvc3RhcmZpdmUsamhiMTAwLXVmcy55YW1s
ICAgICB8IDcxICsrKysrKysrKysrKysrKysrKysNCj4gPiAgTUFJTlRBSU5FUlMgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDUgKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3
NiBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+IERvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvc3RhcmZpdmUsamhiMTAwLXVmcy55YW1sDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0DQo+ID4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
dWZzL3N0YXJmaXZlLGpoYjEwMC11ZnMueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3Vmcy9zdGFyZml2ZSxqaGIxMDAtdWZzLnlhbWwNCj4gPiBuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYTY1Y2M5NDU1YTg1DQo+ID4gLS0t
IC9kZXYvbnVsbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91
ZnMvc3RhcmZpdmUsamhiMTAwLXVmcy55YW1sDQo+ID4gQEAgLTAsMCArMSw3MSBAQA0KPiA+ICsj
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlICVZ
QU1MIDEuMg0KPiA+ICstLS0NCj4gPiArJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1h
cy91ZnMvc3RhcmZpdmUsamhiMTAwLXVmcy55YW1sIw0KPiA+ICskc2NoZW1hOiBodHRwOi8vZGV2
aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiArDQo+ID4gK3RpdGxlOiBT
dGFyZml2ZSBVbml2ZXJzYWwgRmxhc2ggU3RvcmFnZSAoVUZTKSBDb250cm9sbGVyDQo+ID4gKw0K
PiA+ICttYWludGFpbmVyczoNCj4gPiArICAtIE1pbmRhIENoZW4gPG1pbmRhLmNoZW5Ac3RhcmZp
dmV0ZWNoLmNvbT4NCj4gPiArDQo+ID4gK2FsbE9mOg0KPiA+ICsgIC0gJHJlZjogdWZzLWNvbW1v
bi55YW1sDQo+ID4gKw0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4g
KyAgICBjb25zdDogc3RhcmZpdmUsamhiMTAwLXVmcw0KPiA+ICsNCj4gPiArICByZWc6DQo+ID4g
KyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBjbG9ja3M6DQo+ID4gKyAgICBtYXhJdGVt
czogMQ0KPiA+ICsNCj4gPiArICBjbG9jay1uYW1lczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsg
ICAgICAtIGNvbnN0OiBtYWluDQo+ID4gKw0KPiA+ICsgIHJlc2V0czoNCj4gPiArICAgIGl0ZW1z
Og0KPiA+ICsgICAgICAtIGRlc2NyaXB0aW9uOiBVRlMgbWFpbiByZXNldA0KPiA+ICsgICAgICAt
IGRlc2NyaXB0aW9uOiBVRlMgUEhZIHJlc2V0DQo+ID4gKw0KPiA+ICsgIHJlc2V0LW5hbWVzOg0K
PiA+ICsgICAgaXRlbXM6DQo+ID4gKyAgICAgIC0gY29uc3Q6IG1haW4NCj4gPiArICAgICAgLSBj
b25zdDogcGh5DQo+ID4gKw0KPiA+ICsgIGludGVycnVwdHM6DQo+ID4gKyAgICBtYXhJdGVtczog
MQ0KPiA+ICsNCj4gPiArICBzdGFyZml2ZSxzeXNjb246DQo+ID4gKyAgICAkcmVmOiAvc2NoZW1h
cy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9waGFuZGxlDQo+ID4gKyAgICBkZXNjcmlwdGlvbjoN
Cj4gPiArICAgICAgVGhlIHBoYW5kbGUgdG8gU3lzdGVtIFJlZ2lzdGVyIENvbnRyb2xsZXIgc3lz
Y29uIG5vZGUuDQo+IA0KPiBUaGlzIHNob3VsZCBwcm9iYWJseSBzYXkgInRoYXQgY29udGFpbnMg
eHl6IiB3aGVyZSB4eXogaXMgdGhlIHRoaW5nIHRoYXQgeW91IG5lZWQNCj4gdXAgYWNjZXNzIGlu
IHlvdXIgZHJpdmVyLiBUaGUgamhiMTAwIGhhcyBhIGxhcmdlIG51bWJlciBvZiBzeXNjb25zLCBz
byBrbm93aW5nDQo+IHdoYXQgdG8gbG9vayBmb3IgaGVyZSBpcyBlc3NlbnRpYWwhIChhbHRob3Vn
aCByZWFsaXN0aWNhbGx5IHlvdSdsbCBzZXQgdGhpcyBpbg0KPiBqaGIxMDAuZHRzaSBhbmQgbm9v
bmUgd2lsbCBoYXZlIHRvIGxvb2sgaXQgdXAgdGhlbXNlbHZlcykNCj4gDQpPa2F5IEkgd2lsbCBh
ZGQgc3lzY29uIGZ1bmN0aW9uIHRvIGRlc2NyaXB0aW9uo6wgVGhhbmtzIQ0KDQo+IE90aGVyd2lz
ZSwNCj4gUmV2aWV3ZWQtYnk6IENvbm9yIERvb2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5j
b20+DQo+IA0KPiBwdy1ib3Q6IGNoYW5nZXMtcmVxdWVzdGVkDQo+IA0KPiBUaGFua3MsDQo+IENv
bm9yLg0KPiA+ICsNCj4gPiArcmVxdWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAg
LSByZWcNCj4gPiArICAtIGNsb2Nrcw0KPiA+ICsgIC0gY2xvY2stbmFtZXMNCj4gPiArICAtIHJl
c2V0cw0KPiA+ICsgIC0gcmVzZXQtbmFtZXMNCj4gPiArICAtIGludGVycnVwdHMNCj4gPiArICAt
IHN0YXJmaXZlLHN5c2Nvbg0KPiA+ICsNCj4gPiArdW5ldmFsdWF0ZWRQcm9wZXJ0aWVzOiBmYWxz
ZQ0KPiA+ICsNCj4gPiArZXhhbXBsZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICB1ZnNAMTFiMTAw
MDAgew0KPiA+ICsgICAgICAgIGNvbXBhdGlibGUgPSAic3RhcmZpdmUsamhiMTAwLXVmcyI7DQo+
ID4gKyAgICAgICAgcmVnID0gPDB4MTFiMTAwMDAgMHgyMDAwMD47DQo+ID4gKyAgICAgICAgaW50
ZXJydXB0cyA9IDwxMDU+Ow0KPiA+ICsgICAgICAgIGNsb2NrcyA9IDwmc3lzY3JnIDQ+Ow0KPiA+
ICsgICAgICAgIGNsb2NrLW5hbWVzID0gIm1haW4iOw0KPiA+ICsgICAgICAgIHJlc2V0cyA9IDwm
c3lzY3JnIDEwPiwNCj4gPiArICAgICAgICAgICAgICAgICA8JnN5c2NyZyA3PjsNCj4gPiArICAg
ICAgICByZXNldC1uYW1lcyA9ICJtYWluIiwgInBoeSI7DQo+ID4gKyAgICAgICAgc3RhcmZpdmUs
c3lzY29uID0gPCZzeXNjb24+Ow0KPiA+ICsgICAgfTsNCj4gPiBkaWZmIC0tZ2l0IGEvTUFJTlRB
SU5FUlMgYi9NQUlOVEFJTkVSUyBpbmRleA0KPiA+IGZjMzIwYjM3MzY1Ni4uMTBiMGQwODM5Y2E0
IDEwMDY0NA0KPiA+IC0tLSBhL01BSU5UQUlORVJTDQo+ID4gKysrIGIvTUFJTlRBSU5FUlMNCj4g
PiBAQCAtMjgwOTUsNiArMjgwOTUsMTEgQEAgTDoJbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiAgUzoJTWFpbnRhaW5lZA0KPiA+ICBGOglkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1yZW5lc2Fz
LmMNCj4gPg0KPiA+ICtVTklWRVJTQUwgRkxBU0ggU1RPUkFHRSBIT1NUIENPTlRST0xMRVIgRFJJ
VkVSIFNUQVJGSVZFDQo+ID4gK006CU1pbmRhIENoZW4gPG1pbmRhLmNoZW5Ac3RhcmZpdmV0ZWNo
LmNvbT4NCj4gPiArUzoJTWFpbnRhaW5lZA0KPiA+ICtGOglEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvdWZzL3N0YXJmaXZlLGpoYjEwMC11ZnMueWFtbA0KPiA+ICsNCj4gPiAgVU5J
V0lMTCBMQVBUT1AgRFJJVkVSDQo+ID4gIE06CUFybWluIFdvbGYgPFdfQXJtaW5AZ214LmRlPg0K
PiA+ICBMOglwbGF0Zm9ybS1kcml2ZXIteDg2QHZnZXIua2VybmVsLm9yZw0KPiA+IC0tDQo+ID4g
Mi4xNy4xDQo+ID4NCg==
