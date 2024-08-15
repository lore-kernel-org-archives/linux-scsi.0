Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.122])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5FE1714A8;
	Thu, 15 Aug 2024 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727267; cv=none; b=jZAGXZ20wSuRXbKPCGjJ6OASqTOaueNtmXMQ2Ls6StlyWvqnhHpQRcaGw5W2OlESOu6CQ3Cs70MiqpUSV8/2nwcOPyblgmOstahGDBotnyvHtH8STaytqhOF1kQXm37QUBbkBIpi35RqABX2krFn3/2c4Qn9jB+/C1yrctTrPFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727267; c=relaxed/simple;
	bh=vly1wT4XrhXc97INn4caTGhoBFjIcE5gvgKZFhOQLXI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rz0GbwFmgylIZeqC7k75eoo6fEhVsxcQ+xvMr6hteKR9pZ+trQ9W2oRHUeeIuZuBbApaontBuYvUElMulZoq7rAG4PZbLDSleU3IRMGoGJVWBwZb1sIl8yKRIQ62RZeedvYk1zpDrPO+eSdc7E7or4XJ1TEOnWlukK+7mWMtyGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: TaGGtM+PTKibyu1xf22nGA==
X-CSE-MsgGUID: qWFsU24+Tq255oQw+tsfZA==
X-IronPort-AV: E=Sophos;i="6.10,148,1719849600"; 
   d="scan'208";a="119451388"
From: =?utf-8?B?56ug6L6J?= <zhanghui31@xiaomi.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.co"
	<avri.altman@wdc.co>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>, "Huang
 Jianan" <huangjianan@xiaomi.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [External Mail]Re: [PATCH] ufs: core: fix bus timeout in
 ufshcd_wl_resume flow
Thread-Topic: [External Mail]Re: [PATCH] ufs: core: fix bus timeout in
 ufshcd_wl_resume flow
Thread-Index: AQHa7YdYc9Ki7OjQ5EaL6aO/rOJ9D7IldP+AgAJSDwA=
Date: Thu, 15 Aug 2024 13:07:42 +0000
Message-ID: <baef8886-5ec0-4ba4-930e-cd1487ba3a56@xiaomi.com>
References: <20240813134729.284583-1-zhanghui31@xiaomi.com>
 <b2fbe277-2819-4af4-9b36-b7407618cbf6@acm.org>
In-Reply-To: <b2fbe277-2819-4af4-9b36-b7407618cbf6@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <A49E0C54580F104ABB40AE1C7CA81DF5@xiaomi.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gMjAyNC84LzE0IDk6NDEsIEJhcnQgVmFuIEFzc2NoZcKgd3JvdGU6DQo+IE9uIDgvMTMvMjQg
Njo0NyBBTSwgWmhhbmdIdWkgd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4+IGluZGV4IDVlM2M2N2U5
Njk1Ni4uZTVlM2UwMjc3ZDQzIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNo
Y2QuYw0KPj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPj4gQEAgLTMyOTEsNiAr
MzI5MSw4IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2V4ZWNfZGV2X2NtZChzdHJ1Y3QgdWZzX2hiYSAN
Cj4+ICpoYmEsDQo+PiDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNoY2RfbHJiICpscmJwID0gJmhiYS0+
bHJiW3RhZ107DQo+PiDCoMKgwqDCoMKgIGludCBlcnI7DQo+Pg0KPj4gK8KgwqDCoMKgIGlmICho
YmEtPnVmc2hjZF9yZWdfc3RhdGUgPT0gVUZTSENEX1JFR19SRVNFVCkNCj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FQlVTWTsNCj4+IMKgwqDCoMKgwqAgLyogUHJvdGVjdHMg
dXNlIG9mIGhiYS0+cmVzZXJ2ZWRfc2xvdC4gKi8NCj4+IMKgwqDCoMKgwqAgbG9ja2RlcF9hc3Nl
cnRfaGVsZCgmaGJhLT5kZXZfY21kLmxvY2spOw0KPg0KPiBEb2VzIHRoaXMgY2hhbmdlIG1ha2Ug
dWZzaGNkX2V4ZWNfZGV2X2NtZCgpIHVucHJlZGljdGFibGUgLSBpdCBzdWNjZWVkcw0KPiBpZiB0
aGUgY29udHJvbGxlciBpcyBpbiB0aGUgbm9ybWFsIHN0YXRlIGFuZCBmYWlscyBpZiBlcnJvciBy
ZWNvdmVyeQ0KPiBpcyBvbmdvaW5nPyBJZiBzbywgd2hpY2ggY29kZSBwYXRocyBkb2VzIHRoaXMg
YWZmZWN0IGFuZC9vciBicmVhaz8NCj4NCj4gQWRkaXRpb25hbGx5LCBJIHRoaW5rIHRoZSBhYm92
ZSBjaGVjayBpcyByYWN5LiBoYmEtPnVmc2hjZF9yZWdfc3RhdGUgbWF5DQo+IGNoYW5nZSBhZnRl
ciB0aGUgYWJvdmUgY29kZSBjaGVja2VkIGl0IGFuZCBiZWZvcmUgdWZzaGNkX2V4ZWNfZGV2X2Nt
ZCgpDQo+IGhhcyBmaW5pc2hlZC4gV291bGRuJ3QgaXQgYmUgYmV0dGVyIHRvIG1ha2UgY29kZSB0
aGF0IHNob3VsZG4ndCBiZQ0KPiBleGVjdXRlZCB3aGlsZSB0aGUgZXJyb3IgaGFuZGxlciBpcyBv
bmdvaW5nIHdhaXQgdW50aWwgZXJyb3IgaGFuZGxpbmcNCj4gaGFzIGZpbmlzaGVkPw0KPg0KPiBU
aGFua3MsDQo+DQo+IEJhcnQuDQo+DQpoaSBCYXJ0LA0KDQoxLiBJZiB0aGUgaG9zdCBuZWVkcyB0
byBzZW5kIGEgZGV2IGNvbW1hbmQsIHRoZSBIQkEgbXVzdCBiZSBlbmFibGVkLg0KV2UgaGF2ZSBz
ZXQgdGhlIHVmc2hjZF9yZWdfc3RhdGUgdG8gb3BlcmF0aW9uYWwgaW4gdGhlIHVmc2hjZF9oYmFf
ZW5hYmxlLA0Kc28gaXQgaXMgbm90IHVucHJlZGljdGFibGUuDQoNCjIuIFRoYXQncyBhIGdvb2Qg
cXVlc3Rpb24sIGJ1dCBJIHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGJsb2NrIGRldiBjbWQgd2hp
bGUNCnVmcyBpcyBkb2luZyBhIHJlc2V0Lg0KDQoNClRoYW5rcw0KWmhhbmdodWkNCg0K
