Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523FF2857FA;
	Sat, 21 Mar 2026 03:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774064130; cv=none; b=kHsxwjyA2+XvuxTvkTXqt6nEaEZJpa304dmntvLxWa1Bj3U+3yruGJHtvK2i//+etK7WAvoYmLrGtbciBLgZSZIQGcQtlflN6hiNqEmHNCjkRXbPuquusvehRZKNRhm0t2aOi/2gSKeJ8cwCujKVs1BheXja4H2OrTXk643X1tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774064130; c=relaxed/simple;
	bh=tckkY/MOL/aaOQ2awWUaDNtBJwI8WbGCdSzk6xZv+64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S53FNlTOyLVAwebLLm5OzP/b72sqVsT4JBoxuPNpAG+OhuVrzhfvE4jEavPh1OhW7ZO8yt5WL1K35ENNoYbsDFND+GVH0pIQZY3jO0wa/d44l055KRLvTeSp6NaJLJTGdkKrTXdhQUZ0ay2bN2MJ4T8N2wu5URDy9YTbKEMpE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 62L3YJ8t011031
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Sat, 21 Mar 2026 11:34:19 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch03.asrmicro.com
 (10.1.24.118) with Microsoft SMTP Server (TLS) id 15.0.847.32; Sat, 21 Mar
 2026 11:34:21 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Sat, 21 Mar 2026 11:34:03 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "avri.altman@wdc.com"
	<avri.altman@wdc.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: core: Add a vop to handle vendor specific ops
Thread-Topic: [PATCH] scsi: ufs: core: Add a vop to handle vendor specific
 ops
Thread-Index: AQHct+U4HqntZoslyU2PU455JCW3abW4VByw
Date: Sat, 21 Mar 2026 03:34:02 +0000
Message-ID: <dc22d720deba4ce1b1c7aa229a685911@exch02.asrmicro.com>
References: <20260319093839.1854051-1-hongjiefang@asrmicro.com>
 <64cc22ec-4d43-45c0-b63f-0401776f79a7@acm.org>
In-Reply-To: <64cc22ec-4d43-45c0-b63f-0401776f79a7@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 62L3YJ8t011031

DQo+IE9uIDMvMTkvMjYgMjozOCBBTSwgSG9uZ2ppZSBGYW5nIHdyb3RlOg0KPiA+IGFkZCBhIHZv
cCB0byBhbGxvdyBzb21lIHZlbmRvcnMgdG8gZG8gc29tZSBhZGRpdGlvbmFsIG9wcw0KPiA+IGZv
ciBzb21lIGludGVycnVwdHMgaWYgbmVjZXNzYXJ5Lg0KPiANCj4gVUZTIHBhdGNoZXMgc2hvdWxk
IGJlIHNlbnQgdG8gTWFydGluIEsuIFBldGVyc2VuIGFuZCBzaG91bGQgYmUgQ2MtZWQgdG8NCj4g
dGhlIGxpbnV4LXNjc2kgbWFpbGluZyBsaXN0LiBBZGRpdGlvbmFsbHksIGEgcGF0Y2ggZGVzY3Jp
cHRpb24gc2hvdWxkDQo+IG5vdCBvbmx5IGV4cGxhaW4gd2hhdCBoYXMgYmVlbiBjaGFuZ2VkIGJ1
dCBhbHNvIHdoeSBhIGNoYW5nZSBpcyBiZWluZw0KPiBtb2RlLiAidG8gZG8gc29tZSBhZGRpdGlv
bmFsIG9wcyBmb3Igc29tZSBpbnRlcnJ1cHRzIGlmIG5lY2Vzc2FyeSIgaXMNCj4gdG9vIHZhZ3Vl
Lg0KDQpHaXZlbiB0aGF0IHNvbWUgVUZTIGNvbnRyb2xsZXJzIGhhdmUgcHJpdmF0ZSBvciBleHRl
bmRlZCBpbnRlcnJ1cHQgc3RhdHVzIA0KcmVnaXN0ZXJzLCB0aGUgcHVycG9zZSBvZiB0aGlzIHBh
dGNoIGlzIHRvIGZhY2lsaXRhdGUgdGhlIGhhbmRsaW5nIG9mIA0KcHJvcHJpZXRhcnkgcmVnaXN0
ZXJzIHdpdGhpbiB0aGUgaG9zdCBkcml2ZXIgZHVyaW5nIHRoZSBpbnRlcnJ1cHQgaGFuZGxpbmcu
DQoNCj4gDQo+ID4gQEAgLTcxNDEsNiArNzE0MSw4IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB1ZnNo
Y2Rfc2xfaW50cihzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCB1MzIgaW50cl9zdGF0dXMpDQo+ID4g
ICB7DQo+ID4gICAJaXJxcmV0dXJuX3QgcmV0dmFsID0gSVJRX05PTkU7DQo+ID4NCj4gPiArCXVm
c2hjZF92b3BzX3ZlbmRvcl9pbnRyKGhiYSk7DQo+IFdoeSB0byBjYWxsIHRoaXMgY29kZSBmcm9t
IGluc2lkZSB1ZnNoY2Rfc2xfaW50cigpIGluc3RlYWQgb2YgZnJvbSB0aGUNCj4gdWZzaGNkX3Ns
X2ludHIoKSBjYWxsZXI/DQoNCkl0IGlzIGNhbGxlZCB3aXRoaW4gYHVmc2hjZF9zbF9pbnRyKClg
IHRvIHN1cHBvcnQgcnVubmluZyB2ZW5kb3Igb3BzIGluIA0KdGhlIGB1ZnNoY2RfdGhyZWFkZWRf
aW50cigpYC4NCg0KPiANCj4gPiBAQCAtMzgwLDYgKzM4MSw3IEBAIHN0cnVjdCB1ZnNfaGJhX3Zh
cmlhbnRfb3BzIHsNCj4gPiAgIAlpbnQJKCpjb25maWdfZXNpKShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KTsNCj4gPiAgIAl2b2lkCSgqY29uZmlnX3Njc2lfZGV2KShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNk
ZXYpOw0KPiA+ICAgCXUzMgkoKmZyZXFfdG9fZ2Vhcl9zcGVlZCkoc3RydWN0IHVmc19oYmEgKmhi
YSwgdW5zaWduZWQgbG9uZw0KPiBmcmVxKTsNCj4gPiArCXZvaWQgICAgKCp2ZW5kb3JfaW50ciko
c3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ID4gICB9Ow0KPiANCj4gV2hlcmUgaXMgdGhlIGltcGxl
bWVudGF0aW9uIG9mIC52ZW5kb3JfaW50cj8gSSBkb24ndCBzZWUgYW55DQo+IGltcGxlbWVudGF0
aW9uIG9mIHRoYXQgbmV3IGNhbGxiYWNrIGluIHRoaXMgcGF0Y2guIFBsZWFzZSBhbHdheXMgc3Vi
bWl0DQo+IGF0IGxlYXN0IG9uZSBpbXBsZW1lbnRhdGlvbiBvZiBhIG5ldyB2ZW5kb3Igb3BlcmF0
aW9uIHRvZ2V0aGVyIHdpdGggdGhlDQo+IHBhdGNoIHRoYXQgYWRkcyB0aGUgbmV3IHZlbmRvciBv
cGVyYXRpb24uDQoNClRoZSBpZGVhIGhlcmUgaXMgdG8gZmlyc3QgZW5hYmxlIHRoZSBhYmlsaXR5
IHRvIHJ1biB2ZW5kb3Igb3BlcmF0aW9ucyB3aXRoaW4NCmludGVycnVwdCBoYW5kbGVycywgbWFr
aW5nIGl0IGVhc2llciB0byBhZGQgdGhlIHZlbmRvciBzcGVjaWZpYw0KaW1wbGVtZW50YXRpb25z
IGxhdGVyLg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpCZXN0Lg0K
