Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F56C40F74B;
	Wed, 22 Jul 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726019; cv=pass; b=lhdru1Fl9gTIle0ZlqIRpL8t8Df7hUZCcm/Ico2PMHFu5dg3FIVs4s+M5khKeoR/j4XHo9xgvB0aF9CYMThLA3di/urjyRv1C1ijkKZ++UjczUv/24bXfQ8ZOhEqlAR5DThBWD0D1MxTCIS3EL/sMng9zqHUSITomL0sSKW9K2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726019; c=relaxed/simple;
	bh=MDt5HUwFJEhaU7HQYiAoPqSXYNrIRegh74BGU8oMsUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B/L2PrJmAvcfA9wL7+JwBLDu17UEoRimsdqh1jvviziDN8n4pKJy0qYuj4DSwVkIJn29jKeBZEGWqs+Oh7Cq3MNaec1BOq2fA2WaJJiE9LYFGqDIpVMV7d1rDe85EnRyijyH7IcxkwMf4889YgWmMn4I8d3p5nND7VDGtUnAFQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ObwvR50k; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=qZyqzibo; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ObwvR50k";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="qZyqzibo"
ARC-Seal: i=1; a=rsa-sha256; t=1784723609; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GJ31aMg8TzdQVzzHELn5izi/gewqlM5NhzYJ+NucKa+CCmBIkOHuK5y7JdQeV3rC0S
    7IQ/KmO3PyG3OorAKSoFvij0u1BrbmvDqdCDEJ5H4kB9ClEP0U8V4C+/tb5ttEBODMDM
    01ueVCQrjuG3/nkqCqlretRQOWfYyLaU50ajUwX1w+eKqW9xiuGsBP6NmMdSliVyHyV3
    Lywdc4p45DkyFSGeOoEnV9QIhd+ETybal7yMIorpZMRdlcdlsn+u5X+/To9KXnBzaB/W
    HoJpBTWcqNOy2YBCGEIJpQ1DkF+G+c5aoYMuChKOjdn8AlRZXshbIc/rgQ/ve03Zj54d
    Kdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784723609;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MDt5HUwFJEhaU7HQYiAoPqSXYNrIRegh74BGU8oMsUg=;
    b=ne+j73jCn+KSBgwOm8UIp72GVCKxKRfAPT4/uv9g0NpYzB13U0Cxw98uRAdczi1u+O
    XMACMpM2lgS87MbE8YURq48ZMXjk9JtwuvbWLEiOatbf+8rAlCMDftfPgdAKfZHEikBJ
    qeRCESeCfpVzBdIc3SApo3UYmqyuoo33dJBYHtBOmYO6FzR+OhG92WP07HA+XSsZRyCh
    UVJRG9iot6zgIlxbvF1CCNo+ppT/fN3dA5WqU7FraRotEddUkS3YH9ewPwERNIxCj3Qz
    R09OMntQBTiwDc7/H/dsEb27Eea0xXW6K6d3lDaaxr9IFv7OnOvOggtCePh8trvozxn1
    IPLg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784723609;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MDt5HUwFJEhaU7HQYiAoPqSXYNrIRegh74BGU8oMsUg=;
    b=ObwvR50k+YAEzaD73KFeEena/UOmbZHqWYm+JXa9e9RypuMUft7RNpHA92EOEbzWR+
    OpJHnidYUVoUB5i3Z6N7BZ+x4hUAVrSoES7xS3zx5hZldoo7VoziY3/dGj0y/pyYzgfV
    G+D52VN0bIV27yGnxTtux+dM6Y3U/TuzWRtm3CB7x+ZPn53QowerPBtYunN9PseukaAa
    llO+uAb5yEd1zxeV8TeAXtI29BucR7XPZKh8YWHSy0x5y+suKvuZmRetbot6u+wWCQz2
    Z8QZLpejCrsxYD7LLNMFllZL+Z/i+keF9Cqg6B2OvZT6EnI2zdnD/2OqpXoNaiFVjkfb
    T1Rw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784723609;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MDt5HUwFJEhaU7HQYiAoPqSXYNrIRegh74BGU8oMsUg=;
    b=qZyqzibosXPRlOdKQZbSQdDIuLy6YbebUSdlbg+gViM/wzt1H7O8Th9HhxU8N42CUo
    Lzu4mYf7YwbS0B31FHCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926MCXSGjL
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 22 Jul 2026 14:33:28 +0200 (CEST)
Message-ID: <fd02332e6bd8630c8b3d7dd89e9f7502bb9d1166.camel@iokpp.de>
Subject: Re: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for
 RPMB frames
From: Bean Huo <beanhuo@iokpp.de>
To: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com,  avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 peter.wang@mediatek.com, beanhuo@micron.com,  can.guo@oss.qualcomm.com,
 adrian.hunter@intel.com, tomas.winkler@intel.com
Date: Wed, 22 Jul 2026 14:33:27 +0200
In-Reply-To: <20260717153914.26321-6-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-6-liqiang01@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToKPiBSUE1C
IGZyYW1lIGJ1ZmZlcnMgYXJlIHBhc3NlZCBhcyB1OCBwb2ludGVycyBhbmQgZG8gbm90IGhhdmUg
YW4KPiAKPiBhbGlnbm1lbnQgZ3VhcmFudGVlLiBVc2UgdW5hbGlnbmVkIGFjY2Vzc29ycyBmb3Ig
dGhlIHJlcV9yZXNwIGZpZWxkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IExpIFFpYW5nIDxsaXFpYW5n
MDFAa3lsaW5vcy5jbj4KPiAtLS0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzLXJwbWIuYyB8IDQg
KystLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
PiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnMtcnBtYi5jIGIvZHJpdmVycy91
ZnMvY29yZS91ZnMtcnBtYi5jCj4gaW5kZXggNDMxZjg1YjM2ODc2Li41M2Y2NmIyNzRhY2EgMTAw
NjQ0Cj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnMtcnBtYi5jCj4gKysrIGIvZHJpdmVycy91
ZnMvY29yZS91ZnMtcnBtYi5jCj4gQEAgLTczLDcgKzczLDcgQEAgc3RhdGljIGludCB1ZnNfcnBt
Yl9yb3V0ZV9mcmFtZXMoc3RydWN0IGRldmljZSAqZGV2LCB1OAo+ICpyZXEsIHVuc2lnbmVkIGlu
dCByZXFfbAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocmVxX2xlbiA8IHNpemVvZigqZnJtX291dCkp
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiDCoAo+
IC3CoMKgwqDCoMKgwqDCoHJlcV90eXBlID0gYmUxNl90b19jcHUoZnJtX291dC0+cmVxX3Jlc3Ap
Owo+ICvCoMKgwqDCoMKgwqDCoHJlcV90eXBlID0gZ2V0X3VuYWxpZ25lZF9iZTE2KCZmcm1fb3V0
LT5yZXFfcmVzcCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgc3dpdGNoIChyZXFfdHlwZSkgewo+
IMKgwqDCoMKgwqDCoMKgwqBjYXNlIFJQTUJfUFJPR1JBTV9LRVk6Cj4gQEAgLTExMSw3ICsxMTEs
NyBAQCBzdGF0aWMgaW50IHVmc19ycG1iX3JvdXRlX2ZyYW1lcyhzdHJ1Y3QgZGV2aWNlICpkZXYs
IHU4Cj4gKnJlcSwgdW5zaWduZWQgaW50IHJlcV9sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgcnBtYl9mcmFtZSAqZnJtX3Jlc3AgPSAoc3RydWN0IHJwbWJfZnJhbWUg
KilyZXNwOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtZW1zZXQoZnJt
X3Jlc3AsIDAsIHNpemVvZigqZnJtX3Jlc3ApKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZnJtX3Jlc3AtPnJlcV9yZXNwID0gY3B1X3RvX2JlMTYoUlBNQl9SRVNVTFRfUkVBRCk7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHB1dF91bmFsaWduZWRfYmUxNihSUE1C
X1JFU1VMVF9SRUFELCAmZnJtX3Jlc3AtPnJlcV9yZXNwKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldCA9IHVmc19zZWNfc3VibWl0KGhiYSwgcHJvdG9jb2xfaWQsIHJlc3As
IHJlc3BfbGVuLCB0cnVlKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChy
ZXQpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBk
ZXZfZXJyKGRldiwgIlJlc3VsdCByZWFkIHJlcXVlc3QgZmFpbGVkIHdpdGgKPiByZXQ9JWRcbiIs
IHJldCk7Cj4gLS0KCmNvbnNpZGVyIFNhc2hpa28ncyBzdWdnZXN0aW9uLCBpdCdzIGJldHRlciB0
byBhZGQgX19wYWNrZWQgb24gc3RydWN0IHJwbWJfZnJhbWUKe30/CgoK

