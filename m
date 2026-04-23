Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2109.outbound.protection.partner.outlook.cn [139.219.17.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B53B47EC;
	Thu, 23 Apr 2026 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776908384; cv=fail; b=e2Jp+2c9a3aeb8sjqlWriJsX4q9dC4/nByJKSHz6E7q4vsKE9FC912R25nVKAMM+KfB9QbtqjdKofv7UKOynTSLe10m+bVhQKHVNxJ979ZuFjjCcrYHP1g1IF4ghIfcxw/Lg0LM86IeUi5HOGFElShNYvX/YZZf0Wlx4iUiHTbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776908384; c=relaxed/simple;
	bh=U5hX8VS9xn4/cSrBqh+yEZPSn/t8L/rcjJHA8cVdpIc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B/FvdyQBFogjiePg9Q4Uugb9N1r1MACeUzg/R1yixkcfmXF+KffCfXlI8nyH6zXglVpDKuR9fNwEWD7IGKi0C6aZx9QBhJd4HNeVM7sbKhByIxhnWZOXNiTBDwMfigQfjWZJLYNdt3u+KeMNsST5nIwRYmBH1wC+fkFinf2m21I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGP8et/PWoWkMFb/1m0/NnXUdYCwidGeJdONHasu0rA+PA5tbqXAgdYVo2pKsQJuaIlccizQORrc4JAMxCrEBeaGKl2pLVwmRUo8zHuVMFEl3B/RPmfhHIqcDyqjkfT0cxGJgOvL66m68zELnNg5ELWlAmeHa/VQS3/mh/LacU3w8YHbwIf/HHZteOxbOWdzdO4xx+8eEl+tjMYpfcesoG/zfAAxiikakI6omXGIABLZ1YjYNmMydbvjTUMPb7a2UVBueImPmHxYU2Qm+OWhdvI9TXoyxChDlzkX9RAiJxL9IqwPDMJZ85BFSyzhzZH7qY+b/VM2SYwe92md6eVifA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5hX8VS9xn4/cSrBqh+yEZPSn/t8L/rcjJHA8cVdpIc=;
 b=DS59HkH3drEEb2iQRwUwji9cXXiID21nVTKJISYeJ/G9MHDoEzMHXiUJHHE35CC8Z+UQxxBpfN5n6pDBSFTPp9lbUtg3yk8tabPoJ/v5fI7lbDz+wvzHKVcQNviEbNYndBsl1JGgTXCFmsBrDN71PbJK+5UoIP8VdtZo8WRYBt5mefjnu0AtZp/BAI6Ng16Or1B8yTlLPWmYjyWxN4DNQxFYvuYrN/zzRma4JZTCZOmP/gS0yR0MOEVD25SEv3bAL8CFbPsaJza2afaMJljOwSP+PY2ctUgNCkZ6xzVG4lZ47mtdprQYnnWaFKqN38J1cV4OYFmJjQxPOhpNJ8OKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0808.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:1a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Thu, 23 Apr
 2026 01:23:21 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9846.017; Thu, 23 Apr 2026 01:23:21 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, "James E . J
 . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Arnd
 Bergmann <arnd@arndb.de>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHYxIDEvM10gc2NzaTogdWZzOiBkdC1iaW5kaW5nczog?=
 =?gb2312?B?c3RhcmZpdmU6IEFkZCBVRlMgSG9zdCBDb250cm9sbGVyIGZvciBKSEIxMDAg?=
 =?gb2312?Q?soc?=
Thread-Topic: [PATCH v1 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Thread-Index: AQHc0W74yy82rVma1k2GvS7u9EjKZrXpvsgAgAIdjSA=
Date: Thu, 23 Apr 2026 01:23:21 +0000
Message-ID:
 <BJXPR01MB08557CF6A2E31F7AFC64CFFAE62A2@BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn>
References: <20260421091215.120632-1-minda.chen@starfivetech.com>
 <20260421091215.120632-2-minda.chen@starfivetech.com>
 <20260421-appetite-vowel-ce0837f5625b@spud>
In-Reply-To: <20260421-appetite-vowel-ce0837f5625b@spud>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BJXPR01MB0855:EE_|BJXPR01MB0808:EE_
x-ms-office365-filtering-correlation-id: 3b14bf4c-8b4c-4f6c-e31e-08dea0d6e823
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 l7UMYhxubhCS0a8lxBJaZPFJYyDa6SXXpmte8GYUFceYk4zxfJvdaeAeZaHXksTDiLVhj9sfB3uQxWX/4mphMN2u9RmFBWbUTVs5n79GsNmxcpX8zpNiKk6XnCQikfrAGsAzM9zmjqVsVHFGL6JsIjDOnQpy2QYTcjFSf6+N4F9yUl3MhWyneKSEhQ8ruZC3zB2HHsQJJSW5zVknbgXZpJQXM17i4tnM0TyFS/i8s6q/5a4VsifKWSZkYmcpQ0CUdgzSoeMV7u9u8/L5T08SwnAGTppufcyNS4bjuvCleoX7ey7F1y9bv8fCaNDBHahfoJUwQeu9RIXzsc18TXj8d3JU4hftJ45r8AtFhlSlRJjOvJ8m7qtXJO1+2q7oQO+1+u34HlmrxWkRD7nBUGeTm+X8IPB74rAi8h41j93EMb6YwFPugCtBC7HeLgmKjxu5+QPwJ/lG8cMRXEmp6/Yg5Ly/oxU+cgaL4GerN7F0Ekimtxi+FZJSi9n1jXygIAIOmNuS/54YpKsZfyD+Cd76mQoAdO5goyVWO4Wrzq/JdEoRmPFnNg6yGqTuIpy1vlNKSTHIrEUFNGxQ2ueetjaObw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?ektmT2JyZ3hZaVdZNDlVSytKL1hFSGNGNm9TR3VqRFUxZms4N1hPMG54czJp?=
 =?gb2312?B?ZHNYVVJmbHUxSFBtUGN1eUtwaGRqSVcrMjJRUE5kNmV0dmFZSUc3RkwxTHp2?=
 =?gb2312?B?d2txRVFnaW5sZ210Um0zVVBYTWc2RHlVL2RiYmJZSVE5enFqRG5KMHM1dVBV?=
 =?gb2312?B?MUl2L1N6ZXpoU3p4ZWEvemRVSUVuRGxlT0tjRHpIOFhVTjFHd3JHcGRkRkFy?=
 =?gb2312?B?VHlXMHp5RDJHWTBpNzJqNUpIcWkyZTRkaFlMZEpWdU1WbGNmN2ZFS3pxS1Vx?=
 =?gb2312?B?UVQ1THpVUEdxRE96dll6UDQ4YUYrUFBtQktjMUxpWHhXOTI5WUVTZnhtVExU?=
 =?gb2312?B?ZG03cnVDc0lOQXhKMmFvd1NEM1ZGYkdFbXpZS01aV2pYMHlmWm4wYTQyQTRJ?=
 =?gb2312?B?NnZMV1N3dlk1Nkw0TFJQOGNkZHQwWk5SdVRPZDZFbTFnWCsvK0doQmdPYlBX?=
 =?gb2312?B?NTFXSy9oQUpoVlRpVHdZY0luTTIwWFhiQkErS0laWE1waVYwWDRhU0d0UGVB?=
 =?gb2312?B?clhWUlZxaFVUNWpWUVl1OWN5eG84RmU5ZG41a0ZDWDJKblBsK01jMUlYSWhW?=
 =?gb2312?B?YVI0blo1Q25DZTUraStlN1FVTWwyNG1ZRkJUWjhEQTIyVEgwamd0NjlDcGtW?=
 =?gb2312?B?eFJvUzlLaWtORDZwL0Z0Q1NjMWVkOEpMa055RXE0MHRoTUhHbHo5L29nQ29U?=
 =?gb2312?B?UFVKT3JrWFpYUCtXbnNaOTBmRW9yVkZySmpyN3dNSFFoRy9NSzczNnB4anRk?=
 =?gb2312?B?YXNSZ3ljQUxjZVArRE0vdEl1SWduMGRZbitueTBUSDBGaEtCaW5wVWJ6dk5P?=
 =?gb2312?B?VDFrN1k3WHNFNnpKbm1jOTdsekFpbTVjTnJLcDJNUStJazVycmtqdTBCL05D?=
 =?gb2312?B?WXZiZGZqMXNLcjB6aFp6ZGdXazRIczd6dmNPbzUwdWhTUE9GK0RZRGFaSkhr?=
 =?gb2312?B?c3VWaUpxVmd3aHNZSnpEUWZqYWlNYzZqb3NHb0d6OHdZQjEzL0ZjdFBQbW4r?=
 =?gb2312?B?ZHRJUytUQjJsQXNWUFhzQ1orazlFZUl6OWpXSm1UN1dYc1ZhdXpxKzhaUmpT?=
 =?gb2312?B?ZjE4eDFHN0NOY2tmRW16eFdrSXFXV1d4TTgweXBZUU5RTk9USmFrUkxYWXdx?=
 =?gb2312?B?NjVJcE4vcU5pdFFmVWY3dzdodGI1VHgwYnlVbmpMcThQQnEyQnpQRSs5bk1F?=
 =?gb2312?B?S3VENy9DcU03T0pHa0M2a3FGR0hQL3pBN1YvSWUwU0xjTE5hcjJaUjl4KzZu?=
 =?gb2312?B?KzE4Qm5oUGg2S2hBUTlyTUJnL2RnKy94bVg4bkJ6ZVBURGVrR01UREFvb29W?=
 =?gb2312?B?dzJXUk41MnlMeFE4SGZHaFByUWdPZllRUEp5SDJ2RloxZ1FtRWtHVURnRG5Q?=
 =?gb2312?B?M29lTmd0Tkt1SnlOVW52RUNZczl0S1RGaVNma1MxUXpkbWIvelg1d0lNVFB3?=
 =?gb2312?B?VUFGeVJYZE5TbFRTeUgwdTl5b0hnV3pnWmpyRi9EUU1NSTI5MGx2MGtINlFm?=
 =?gb2312?B?dXV5RlJLK05MY2VIZ2dZRTFHWlhtNElOMStMWnhJVExBUllkRUZoQjV4UDB5?=
 =?gb2312?B?bzBiaGcwVktRMWV6Y0hSOG9GK09NN0M0cUFyL3dLUjM1RDdzTWxtWklzMW9H?=
 =?gb2312?B?ZmVXMUJlaC94a29qYnBlOGJ0YnpucUxBSWlNNEZRSG1FM3JuSWNsSVljWlI3?=
 =?gb2312?B?SkY1aDlRUVVxWlZIZW5CbEhmUkQ4aklOYlNRbGk3UWpOWkJNMkpGSVpuT1Zh?=
 =?gb2312?B?c2hCaXpuWHJDT2xCUmk2TndTNStHNGRXaHBVbVpNcS8zc292SUtDVWhlLzVE?=
 =?gb2312?B?a3I3RmM2VVFkN09EY2hnS1BJcEh2NnNwVUg2RXVvVXlscmNmVENaNTZyM0ta?=
 =?gb2312?B?M2tFaWVUZjZpOGJTR2xiejYxRTU2T2d3M3p3QTVjbi9RQktLZ2RqcS9Udk5W?=
 =?gb2312?B?blh5cGg1MnJiRFBiSEk0cjk5bmNLdk52WVkzYVFVQy9oSlFxMkR0UUpBcW5Q?=
 =?gb2312?B?bmIxb1drUWtjSml4S0hrTnIwZ3dYWjIrRE03WXVJcVhaQ0ZrUURKUCtVYXBG?=
 =?gb2312?B?dDVtKzJUaHFkcUxndTZXM09rLzNkd1hFWlJYdzZrSXZoTXAxTCtGbm1NcEFp?=
 =?gb2312?B?RTlRZG1MY2pzSkhwWmthYzVBY0JKSExKZ1FhcUVlK1pibU9zVEpKTEZvS3NL?=
 =?gb2312?B?MWdkVUpHWGgrazErdXovSW8rd0hIcVFzalk3Y29SdklMTlczb3JqR0djdmZE?=
 =?gb2312?B?WkdGeXNEZTlGU1J6d3hCM3NLK3psZms5OVAzSlg2blR0bG5VMWJlcWYwakgz?=
 =?gb2312?B?cHFvdlVmVXdLNmtrczRQNVlIVTB5eWx4bVhUcDVHSjB6b3JHdFhOZz09?=
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
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b14bf4c-8b4c-4f6c-e31e-08dea0d6e823
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2026 01:23:21.0918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKfD1MvAg9PUNvsZx79dmaaYMx4GAa1W3ZPpkgeST4jEMxdTWvar/gUlctQ6Cmafoa6jNzjRrIRXdbObRSQuZ/epbKB2b0Qq3hFo3zI/s2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0808

DQoNCj4gDQo+IE9uIFR1ZSwgQXByIDIxLCAyMDI2IGF0IDA1OjEyOjEzUE0gKzA4MDAsIE1pbmRh
IENoZW4gd3JvdGU6DQo+ID4gQWRkIGRldmljZXRyZWUgZG9jdW1lbnQgZm9yIFVGUyBIb3N0IENv
bnRyb2xsZXIgU3RhckZpdmUgSkhCMTAwIFNvQy4NCj4gPiBUaGUgVUZTIGNvbnRyb2xsZXIgaXMg
YmFzZWQgb24gdGhlIFN5bm9wc3lzIERlc2lnbldhcmUgVUZTIGNvbnRyb2xsZXIuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBNaW5kYSBDaGVuIDxtaW5kYS5jaGVuQHN0YXJmaXZldGVjaC5jb20+
DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9zdGFyZml2ZSx1ZnMu
eWFtbCB8IDc2ICsrKysrKysrKysrKysrKysrKysNCj4gPiAgTUFJTlRBSU5FUlMgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDUgKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA4
MSBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+IERvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvc3RhcmZpdmUsdWZzLnlhbWwNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3N0YXJmaXZl
LHVmcy55YW1sDQo+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3N0
YXJmaXZlLHVmcy55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAw
MDAwMDAwMDAuLmM0MDg5NzNkZDBjZQ0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3N0YXJmaXZlLHVmcy55YW1sDQo+IA0K
PiBGaWxlbmFtZSBzaG91bGQgYmUgc3RhcmZpdmUsamhiMTAwLXVmcy4NCj4gDQpPa2F5LiBUaGFu
a3MuDQo+ID4gQEAgLTAsMCArMSw3NiBAQA0KPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlICVZQU1MIDEuMg0KPiA+ICstLS0NCj4gPiAr
JGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy91ZnMvc3RhcmZpdmUsdWZzLnlhbWwj
DQo+ID4gKyRzY2hlbWE6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55
YW1sIw0KPiA+ICsNCj4gPiArdGl0bGU6IFN0YXJmaXZlIFVuaXZlcnNhbCBGbGFzaCBTdG9yYWdl
IChVRlMpIENvbnRyb2xsZXINCj4gPiArDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gTWlu
ZGEgQ2hlbiA8bWluZGEuY2hlbkBzdGFyZml2ZXRlY2guY29tPg0KPiA+ICsNCj4gPiArYWxsT2Y6
DQo+ID4gKyAgLSAkcmVmOiB1ZnMtY29tbW9uLnlhbWwNCj4gPiArDQo+ID4gK3Byb3BlcnRpZXM6
DQo+ID4gKyAgY29tcGF0aWJsZToNCj4gPiArICAgIGNvbnN0OiBzdGFyZml2ZSxqaGIxMDAtdWZz
DQo+ID4gKw0KPiA+ICsgIHJlZzoNCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsg
IGNsb2NrczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGRlc2NyaXB0aW9uOiBVRlMg
cmVmZXJlbmNlIGNsb2NrDQo+ID4gKyAgICAgIC0gZGVzY3JpcHRpb246IFVGUyBtYWluIGVuYWJs
ZSBjbG9jaw0KPiA+ICsNCj4gPiArICBjbG9jay1uYW1lczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+
ICsgICAgICAtIGNvbnN0OiByZWZfY2xrDQo+IA0KPiBUaGluayAicmVmIiBzdWZmaWNlcyBoZXJl
Lg0KPiANCiAicmVmX2NsayIgaXMgdXNlZCBieSB1ZnMgaG9zdCBkcml2ZXIgY29kZS4gQ2FuIG5v
dCBjaGFuZ2UuDQoNCg==
