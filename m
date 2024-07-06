Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2079.outbound.protection.outlook.com [40.92.102.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64E282E5;
	Sat,  6 Jul 2024 12:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720269970; cv=fail; b=YwCbbhT0wb6rvsCfn4YqII83BANUx+ab6wP3FGI0Qzhgg431+jqcPr8JvNyj33ebD38CnNnWkl2DPHiqdFKtJ9j1CPzJf8xWGy7dCXhmi84VzQqkFtqnkAJYVaGmEhFJke++fgPichU9Yw/9vE4cQnXFdoC1T9Rnp1fnnVSWmjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720269970; c=relaxed/simple;
	bh=8ASrhxXBfXHKD1J0zExhTBJ7jzLf5rzKx0zAaIiTQwY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ym5qH4h1+aF4PMrON5rAjOkFPoGqFsj11vZPwxS4hbpvAlS1JvpneHc6OvQshutLO0UH5kDasFK3tHUANh2OvqkZMShBpLrgYfEgeFKxPzAe5SREVapB8XJXC4Efxmn+076dlW7UWkMvk6n8/w5oA/AvTlaniguZiCC2FNkRVJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=JBl+3+lP; arc=fail smtp.client-ip=40.92.102.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="JBl+3+lP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCQGjjpEK4z6zs3N9lQPPUR5X1nNNmstwrYXmH7CPysC/zq2Bu6ONLkiFNLzNQnO7PHkmVZjg5RpFGV3Erb0jivsaxA6w+SuoxHswTevORMDJRJGzPRBy83jjhFFyFji7sDjvIlsTMEAtkk4Dbw2lHUM4HvAABOkiTqphVM/x7FImM/XvmIYOPOlG58aE66O7y//NAfwTvI+XqtIAihy83PlnDxTSDKu+VO0w3V4mqDUHyW35PC51ODeqEvnKd0D/XbYvmJlhfJd2VUpdDW3fvV3zkhlQluXEpLvN2yLs4ttbx7vZnL8ZbZHRyyUDwI6BSyhA8ex9vTp+XvU+y4gTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ASrhxXBfXHKD1J0zExhTBJ7jzLf5rzKx0zAaIiTQwY=;
 b=SROAANB8n/M8v/ScWykoyoWmM2S+JZyIyRvirBMg/NFJ77qJc11IxiIMMRzCA3E2FQVx1Np3zgnMFm0eN+bHOdLlFhPeKVMNofNzcsVoLe66WvSgWek81kfBMRUYCxPMUOpGE9iPfoTJPtyNnXrt3J5bd/GlT5TkagwoP5Yo4xjJzq/aANuEn+ZMniPgsmp7FQW5tMGDoDnY+LShdVXu5b1F3UgPQr65p5Joek5ty0i57tDVCLaT4vH2cesxlBFIkK8IzOXCyMDdQ684sVY+6I5Z7JzhhHtRazl7HbRPeCYQzoIv5gyDr1YjfN1BPK+bnVzyrh5TLco0Fi+Ifqaa/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ASrhxXBfXHKD1J0zExhTBJ7jzLf5rzKx0zAaIiTQwY=;
 b=JBl+3+lPnkrdMQLUzF5vA/kjs108VnzoUM5f99r0SyBqjFAjhB+5Gtgs6Fk6Y53p166EXQtwywThuP70DKS1rxte/U3vIq2c0iPViStK1dGI8dRttAn24azKOau1ft7DAF4LkUI/3+Mk6J9aoau8Cv5Uif/2uRupttV0/QhN1QJGaWr7v20RFL7qOeGk6JZlOIR/YOe9aKUkFa77TNLGVU7sqG5k0cGnYf0WGKEq3X2xMfK3psBVdhPOd+kB9acIGljsX9WD8zsZP9ZQIS6hXdaRzkVoCXduaIytL464iNJ0mN08kIvxfj7SxhSaf7ZwuhZqe/mr0CkHMC9gQ3839Q==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN3P287MB1558.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:192::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.30; Sat, 6 Jul 2024 12:46:01 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:46:01 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>, Kerem Karabay <kekrby@gmail.com>, Orlando
 Chamberlain <orlandoch.dev@gmail.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHaz5yAS+i+TdTeKU6c11DkRXEKIrHpoxgAgAACioA=
Date: Sat, 6 Jul 2024 12:46:01 +0000
Message-ID: <1E1BF62B-E8F6-411F-B06C-4A28C96B4897@live.com>
References: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
 <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
 <2024070612-squealer-wackiness-c885@gregkh>
In-Reply-To: <2024070612-squealer-wackiness-c885@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [pEoyCXca0E32kE7s0kQFJUnOv8Az5JvU0XDsCSZLilkyWZngszhPUvnh3McrIilfUTmIHjIfY1Q=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN3P287MB1558:EE_
x-ms-office365-filtering-correlation-id: 938679ab-eb41-4f84-9963-08dc9db9978a
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|461199028|3412199025|4302099013|440099028|1602099012|102099032;
x-microsoft-antispam-message-info:
 XKpzyjXHyqgccha5yXnW3t1zl0s6PPTLqorAdnyXnC8NlCnhYpe5ftILEDsjEv4Oj20Wdm/q/NA7KBSGG6Z54NO8cpbPt78Cze/M+737oP+nlw7dN1aRgaETEQJMvFjdM2kUctdMJEolfTbNGT7yE1XICRJkJJhOzjvaxHHlDj/4Y4NDCquws0/z1rwBi8tJ97agH5bTJ+6d7s7evKNliCzUMLybTAS0T+2vwIecyqVYOvPq138SfQCYAQjGhpWFpydVQRFAWOVEQcvGa1SKFYMqtGfnnWHRiiRnBTkKFdpEytBda3L0+deUle2pSpT9uhQRZ2SX6xvdA2yd6KJTe4IVEEx5yAAzEYazNIXpT6Gry3zqzpA3xXxHDYDd7+TDi8WPLxk438TX1Uj/mGVcbw0K+Cko9I6bb38ORPG2v8X1d6zicE59QmXvu/pdUKhjRPVtuTwV71YW2ha1bUsVtcLvBQ9FhyhRLZP+k2rT/ZPpyLkhvj6Okj9C/dMav61QclImjAPykR3WIRGLEDu3N4SO3PmttbuOq64vpqP6Iq4r7VurB7d0PghLeO/Rr5GYvsCj1xOIUC2kA3raxzqJxGFNG14CW25rX6t/o0VpSVe4Hxgi02nFbCjKIx8XHEzMIQMVor5vLH/FXdhv72Tp/SP+tsI8boiwlzZmuS2049zJeoHsMPgY310yABgc8AIDqJAFHweDzRKYiUzvvOxy87OcycSLs5RNhg2D4NeJqGcO4j66B4Iw9VxdMqi9sXG5
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MDU4OVRBTDhVWGVXM1pvMnMvZGp3U0JsVi9xaDJjaXRlYmpuOU9mamR1RTFl?=
 =?utf-8?B?UWoxNkRycUpYRTg1WkFZTkVRcTN3dDJQZncrVzZtR093VTJqYmVyMUprSlRD?=
 =?utf-8?B?VjVpQ3NGZ3JRTjh5WWZVSms2NmFtM3NOdERYQlJTaXo5RjdKYUpwSjdLWm5X?=
 =?utf-8?B?RXhpODlCQmdkbVFOY1JzSk5heTNyS25oY09weWpSbERVcXVqRU9yMXViekdM?=
 =?utf-8?B?K21zZWxsMUR2M2srYit2WnR1eWw0OHh0eitpVVZmQXdTOW00S3pKR1lCVkFE?=
 =?utf-8?B?V0dkK0YySFA1UlExQTFaMGhPYjFhbnhOMGNPTTMvMmNIVTdta1l0dURMTVFX?=
 =?utf-8?B?bUpMMkRFREkvSVUza1JwbW45UThFQ0pIWUtjM1l2Nis1NlYra04vWEQ0eldV?=
 =?utf-8?B?VkhTR2VqMnRxMUpOb1FTNGtTTDEybGp4aml0bVptL0lyS2xOSTZDNU9xcVFl?=
 =?utf-8?B?aXZVbjY0eTZLQysyTU1oNUZkYTFZYUNPNnRIZnkwd1p1NFRvUzhaNnlRcUZw?=
 =?utf-8?B?L3paUHdYYXIva1d2Y2VLOGRrYWJ6UDBteHltZzZPVlFKMUxQNXhoMzV0K0ZL?=
 =?utf-8?B?cE5tRTI0U0JreGFHYkZRbHZGbWQ2VHhsUTQ1QUtzcnFmNVBPK3FKWVMwNk4y?=
 =?utf-8?B?S0xrT1VSUDFYYjFTaThBcjhiUHEwSHhUOFRxWEw0N3dCTGZuR2RUWEsvUml1?=
 =?utf-8?B?V0pIWHhwaHliWWtibHNyOFNXZGM2VVpNQWY1TVgzZEROZTBsM2REOXJrdHFw?=
 =?utf-8?B?VzdoWDcwQUlsRGo2dWRHcmRrVTZicWdzRFk3S21qQlp1eW4zQzY1amR6WWtq?=
 =?utf-8?B?amU0KzF1dk43WlIzbWdMVHZ4blNnSmE0a2ZLek5abnJURVhpYVltSUJVUy9L?=
 =?utf-8?B?Ynp5SjczNWxDRllxVlpSa3V5ankrcmNyYlJZNWFaYjRmVXRrZHppTkZYTzlH?=
 =?utf-8?B?RUoyUlFWMkhUVWR4OVpMcEtqeWhKRDJRVDlNcVVPWjNjMWViZFJXMWhCSmVt?=
 =?utf-8?B?U2NESmE0Ty8zTWFtT0lFSGN5Q2ozYmF0Y2FrTUdLQ0xXTjk1VStRZEZIV0JT?=
 =?utf-8?B?WVNkWTAxT1A4S1NJaDkxeDZBNk9RdHN1MDBnT2x4REVOK09BSDZ1U0dNTjFC?=
 =?utf-8?B?bHdrNUtRaWZBUVRtRVhoaHBqdW43djJ5NjNrTkZlOUxadlkvMndjUkZsVWc0?=
 =?utf-8?B?eitYaGZIdHh1L1I5TnJLeVdRbG1SUXZyRm03QVY5VW5oaGZadlJhR2toV2FU?=
 =?utf-8?B?SE5meWhHdDlmbkZidkEvejM1KzFGdVNzaURUdmcxMFd3Tkdud1ZFUG52SWcv?=
 =?utf-8?B?di9CN3F0Q3RaSHEzRHB5MDZESzBrU0lWWlhPc0wrVzZQWGp4ckc1ejQyMkQx?=
 =?utf-8?B?SkpraVJ0T2xyMGNmTkFnUkdLTFlpaVo2SVRRQUo0aWFOTzZHUXVwK3Z5VXBW?=
 =?utf-8?B?ekdsYnVjcDRObDVKa3F2aDA5aHM1UTBLTTZaRjl3M2VLUktDZnVSRllEcWdQ?=
 =?utf-8?B?eFJYRlpIbkVBaUxyMUVkRm1sMkJTMEIwSnVtM05ZYS9POWtLaHk1SEpTRlc1?=
 =?utf-8?B?WkU1akllVFZxb1U1NFdac3h0bDl4aGc1VUVCZUowUmNDVEFIcmdwTnB2WW9W?=
 =?utf-8?B?S0JPZlBDYmJBM1A5QktuUm9MRk5kKzFnVHJvd3N0bEJzclhOM2tBbFN1dHBB?=
 =?utf-8?B?OUczR0Vmb0J0M1ZHOW43NDRrWmNMeDhzU0swQ0svQ1Q2NENEMlQ0bU1iWEwr?=
 =?utf-8?Q?6JZOKRxRhw9oOlaTAn1yFPvm4Yiye3ogdWLxM/z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8BE792C509C324D92E1F0A727074514@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7719-20-msonline-outlook-24072.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 938679ab-eb41-4f84-9963-08dc9db9978a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:46:01.6184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3P287MB1558

DQoNCj4gT24gNiBKdWwgMjAyNCwgYXQgNjowNuKAr1BNLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gDQo+IE9uIFNhdCwgSnVsIDA2LCAyMDI0IGF0IDEyOjAzOjIzUE0gKzAw
MDAsIEFkaXR5YSBHYXJnIHdyb3RlOg0KPj4gRnJvbTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5QGdt
YWlsLmNvbT4NCj4+IA0KPj4gQ3VycmVudGx5IHRoZXJlIGlzIG5vIHN0YW5kYXJkaXplZCBtZXRo
b2QgZm9yIFVTQiBkcml2ZXJzIHRvIGhhbmRsZQ0KPj4gc2h1dGRvd24gZXZlbnRzLiBUaGlzIHBh
dGNoIHNpbXBsaWZpZXMgcnVubmluZyBjb2RlIG9uIHNodXRkb3duIGZvciBVU0INCj4+IGRldmlj
ZXMgYnkgYWRkaW5nIGEgc2h1dGRvd24gY2FsbGJhY2sgdG8gdXNiX2RyaXZlci4NCj4+IA0KPj4g
U2lnbmVkLW9mZi1ieTogS2VyZW0gS2FyYWJheSA8a2VrcmJ5QGdtYWlsLmNvbT4NCj4gDQo+IFdo
ZXJlIGRpZCBLZXJlbSBkbyB0aGlzIHdvcms/ICBBbnkgcmVhc29uIHdoeSB0aGV5IGFyZW4ndCBz
dWJtaXR0aW5nDQo+IHRoZXNlIHRoZW1zZWx2ZXM/ICBOb3QgdGhhdCB0aGlzIGlzIGEgcHJvYmxl
bSwganVzdCB0cnlpbmcgdG8gZmlndXJlIG91dA0KPiB3aGF0IHdlbnQgd3Jvbmcgd2l0aCB0aGUg
ZGV2ZWxvcG1lbnQgcHJvY2VzcyBoZXJlLg0KDQpJIHdvcmsgYXQgaHR0cHM6Ly90MmxpbnV4Lm9y
Zy8sIGEgcHJvamVjdCBhaW1lZCB0byBicmluZyBMaW51eCB0byBUMiBNYWNzLg0KDQpLZXJlbSBo
ZWxwZWQgaW4gZGV2ZWxvcGluZyB0aGUgZHJpdmVyIGZvciB0aGUgVG91Y2ggQmFyIG9uIHRoZXNl
IE1hY3MuDQpEdXJpbmcgZGV2ZWxvcG1lbnQsIGhlIGRpZCBzb21lIGltcHJvdmVtZW50cyB0byB0
aGUgSElEIGNvcmUsIFVTQiBjb3JlDQphbmQgRFJNLCB3aGljaCBhcmUgbm90IHNwZWNpZmljIHRv
IHRoZSBNYWNzLCBidXQgYXJlIHVzZWQgaW4gdGhlIGRyaXZlci4NCg0KQXMgdG8gd2h5IGhlIGRp
ZG4ndCBzdWJtaXQgaGltc2VsZiwgdW5mb3J0dW5hdGVseSBLZXJlbSBzZWVtcyB0byBoYXZlIGxl
ZnQNCnRoZSBwcm9qZWN0IGFuZCBpcyBub3QgY29udGFjdGFibGUgYXQgYWxsLiBGb3J0dW5hdGVs
eSwgdGhlIHBhdGNoZXMgaGUgY29udHJpYnV0ZWQNCndlcmUgc2lnbmVkIG9mZiBieSBoaW0uIFNp
bmNlIHdlIGhhdmUgaGlzIFNpZ25lZC1vZmYtYnkgYW5kIHRoZSBjb2RlIGlzIEdQTDIsDQpJTU8s
IEkgY2FuIGxlZ2FsbHkgc3VibWl0IHRoaXMuDQoNCkxpbmsgdG8gb3VyIHBhdGNoc2V0OiBodHRw
czovL2dpdGh1Yi5jb20vdDJsaW51eC9saW51eC10Mi1wYXRjaGVzDQo+IA0KPiB0aGFua3MsDQo+
IA0KPiBncmVnIGstaA0KDQo=
