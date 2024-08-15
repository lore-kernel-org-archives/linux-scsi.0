Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.122])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E908F19F462;
	Thu, 15 Aug 2024 13:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727664; cv=none; b=Ei9udhFca1GpZY2+oOCi8FPvUX264fQRbOlvU5D40Xj6nv0+wxu9B3ZphItGqJzpb2q34weluiAIZT5/X3x6DRMDFNN6z5sMsxx7tgl+okpwfESng0e08HeSKM5dPEq33cIgH3QWQETAbrZh7sz2Z2CMRw7NWeXpPIm9XFkdOtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727664; c=relaxed/simple;
	bh=xK81SCJet9OWcNbkPj598ufd8Y9tG3VHTlqcbNbLCh8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NK6rPtcj3hsntGHPaSe4Fvgo7vAKBiaNDIwxEnhRjfRFpdhXcSrquviM7Rm91DrM3d1LfVDCfcbVHklgrMoKvX/kprYNtBs7OxqOyKubTw6tFQPTmAkxPYCsxzd2BI/Ds4hOqUh/kWi5MX2fohGkGKoJoiF1EM8JiVHG4+xnQps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: ysuD4FvjQESPyVZtHZq1bg==
X-CSE-MsgGUID: UyOh9GZHQk6T38EMZcVvtA==
X-IronPort-AV: E=Sophos;i="6.10,149,1719849600"; 
   d="scan'208";a="119451810"
From: =?utf-8?B?56ug6L6J?= <zhanghui31@xiaomi.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.co" <avri.altman@wdc.co>, Huang Jianan
	<huangjianan@xiaomi.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [External Mail]Re: [PATCH] ufs: core: fix bus timeout in
 ufshcd_wl_resume flow
Thread-Topic: [External Mail]Re: [PATCH] ufs: core: fix bus timeout in
 ufshcd_wl_resume flow
Thread-Index: AQHa7YdYc9Ki7OjQ5EaL6aO/rOJ9D7IlyESAgAIAogA=
Date: Thu, 15 Aug 2024 13:14:18 +0000
Message-ID: <8c96dc60-1977-4109-a625-ff74fdd005ad@xiaomi.com>
References: <20240813134729.284583-1-zhanghui31@xiaomi.com>
 <58c2bf59f5190f6ef527c1debffaf73cd0752311.camel@mediatek.com>
In-Reply-To: <58c2bf59f5190f6ef527c1debffaf73cd0752311.camel@mediatek.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <36FA0C062066114B95504A7F8AFB2E6B@xiaomi.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gMjAyNC84LzE0IDE0OjM5LCBQZXRlciBXYW5nICjnjovkv6Hlj4spIHdyb3RlOg0KPiBPbiBU
dWUsIDIwMjQtMDgtMTMgYXQgMjE6NDcgKzA4MDAsIFpoYW5nSHVpIHdyb3RlOg0KPj4gRnJvbTog
emhhbmdodWkgPHpoYW5naHVpMzFAeGlhb21pLmNvbT4NCj4+DQo+PiBJZiB0aGUgU1NVIENNRCBj
b21wbGV0aW9uIGZsb3cgaW4gVUZTIHJlc3VtZSBhbmQgdGhlIENNRCB0aW1lb3V0IGZsb3cNCj4+
IG9jY3VyDQo+PiBzaW11bHRhbmVvdXNseSwgdGhlIHRpbWVzdGFtcCBhdHRyaWJ1dGUgY29tbWFu
ZCB3aWxsIGJlIHNlbnQgdG8gdGhlDQo+PiBkZXZpY2UNCj4+DQo+IEhpIFpoYW5naHVpLA0KPg0K
PiBJZiB0aGUgdGltZW91dCBjb21tYW5kIGlzIFNTVT8NCj4gSW4gcmVzdW1lIGZsb3csIGlmIFNT
VSBjb21tYW5kIHRpbWVvdXQsIHVmc2hjZF9laF9ob3N0X3Jlc2V0X2hhbmRsZXINCj4gaW52b2tl
IHVmc2hjZF9saW5rX3JlY292ZXJ5IG9ubHksIG5vdCBzY2hlZHVsZSBlaCB3b3JrPw0KPg0KPg0K
PiBUaGFua3MuDQo+IFBldGVyDQoNCmhpIFBldGVyIEcsDQoNCiDCoMKgwqAgdWZzaGNkX2xpbmtf
cmVjb3ZlcnkgY2FsbHMgdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUgdG8gcG93ZXIgDQpj
eWNsZQ0KDQogwqDCoMKgIGFuZCByZXNldCB0aGUgaG9zdCBjb250cm9sbGVyLg0KDQoNClRoYW5r
cw0KDQpaaGFuZ2h1aQ0KDQoNCg==
