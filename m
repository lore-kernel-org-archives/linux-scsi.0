Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D43E4C8C;
	Thu, 14 May 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767423; cv=pass; b=k/1eyAfY9QiwhiUNpu1pwAF9d6zMNgEYVBohQstPFUOAZ4LXKM5GR8yz8EWgtOstDhuPluv0VfVeCaBoe4C2JYRHPRjtGU0Ju/v4DmK8kJaW2t2+816RAEX9M4lO0RP9R6zXlTKKAT66zadTCRgN6n+mtMuO+DU05chtQkf3AEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767423; c=relaxed/simple;
	bh=5zlsQNmFrGu1k7mq2ASEAgKJY2ipxks2j90/Yg+S3/0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I/VkRv+q/cafuE4juVtxhx+vduT6ucuyvH3X5KTWQ6yk7B0CR5ApetDJ/LkYXcE2th5/gdnJzQdBcCkl9/o7SZWF8av1LfTMw1cQTs6wxrO0Qw5CKrbjyTb9kD3Z0K7VuB+smwx/RnGIy3Si1tsfbhhl49i1KVGXIBkesYs/AeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=FsUqm4hK; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=XLsx9mqk; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="FsUqm4hK";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="XLsx9mqk"
ARC-Seal: i=1; a=rsa-sha256; t=1778767049; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TpXXxd3uBUjkVK4eXICbUoib6qs6KyCJ/9e4vKzq7+By2qAExt0LYs43TgBBqiU7g1
    7FwP0ifNkxj/HaMeSfXOkhjMYjpboTADWxpeL5xryrvgBj/pAdjYtWyU3VdPp+9CuMTl
    9Ys66xVf4/2IEWoEJP2JkgFsfw8/GdMHCV9ib+IW9mKv1iWBUtW+lUYGyNt1O4yVUMYt
    VlO3nSERdRZMq4wjIoNiz8xQBx4J+f8wOjZaJXM2WsTVe38j5JeTS06y+PxGfxqOpmnQ
    VlhxYUfIbFw1MSqQs5P5EX6+PLrJzSr2On9iLa8sqQiDCobw+b+5a1Oi54DLCn/k02ge
    thdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1778767049;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5zlsQNmFrGu1k7mq2ASEAgKJY2ipxks2j90/Yg+S3/0=;
    b=pzroV7vjT/IDHvG5yS9ojC4j86iYhP+NvDUk9WuBcIIO2qa6HAvH0VWDCmyMR+i2HA
    lboJy/sllEJM/M7o++13eVacfHAHTXOqAU77nav1+xCN9Mpg37H7Qpy+YZQRtka55ees
    iQ+spZV4Aabd9i6zTHySdXbNiEUooHDsRNv2dba3tjVyGRtXW1GdYT5l2JB9fQ0DTBFs
    kmYiKFeVLgu7b8sivHBtjIyFzOA6zdy2hFnZfSGdgcJ7Wqcd49e50h8i9RY7VuP4mPL+
    +F28/MEovo1ddI67oG39HaO7wfIbSzmkFeRQF28I0bjSk/ioh/9iUDYetr1i1y+Shht6
    tw9w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1778767049;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5zlsQNmFrGu1k7mq2ASEAgKJY2ipxks2j90/Yg+S3/0=;
    b=FsUqm4hK2Kp5V6Km9dV3sh9qWNuWR76fZT259eXzju3jhb1ffd7JXSJ/OD2TDkRvFU
    2xL7Exkn6qI3HaBWYK++43bxyR0t2gXZBXS8Ne1JYE9Vj/BO4uBwiT6O0C3mLx0v3o3c
    VLa5Dp4yKE6qmobwIXgzGlkIay0BIJtcoYEMLpWD68nV0JIXl5G0Yd7gLJjz4nR2JVoB
    zWn0c0ZXcnj8w2eupl4U+Sk8Kj4FQ4OM6MOA8CxN8Cpe22tDhguilPrE2Y5TKiblM/+V
    KcEUb3wqfdfNaAqPDCubLWolzogXxfLm3znMDSfmc1LxSCGkkWFAb83cc+CaOKaaiPhn
    Pr2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1778767049;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5zlsQNmFrGu1k7mq2ASEAgKJY2ipxks2j90/Yg+S3/0=;
    b=XLsx9mqklh6u0AT9AD92V0Mj9B9ueqntPwUbo68VggOlWiAa7zwWvt/+1lR4hT6ygC
    5w1Xzv9vZkQu41V/CkBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGTFpI23sVs35ckqT7TScigq3UA8V5w4Hf54QA=="
Received: from p200300c5870e408d6dbae9edef800e6f.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934524EDvSkuv
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 14 May 2026 15:57:28 +0200 (CEST)
Message-ID: <a0347bb7c1b5902d236855c773d55e0dd9fc19c3.camel@iokpp.de>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com,  peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org,  powenkao@google.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <avri.altman@wdc.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Ram Kumar Dwivedi
 <quic_rdwivedi@quicinc.com>, Nitin Rawat <quic_nitirawa@quicinc.com>, open
 list <linux-kernel@vger.kernel.org>
Date: Thu, 14 May 2026 15:57:28 +0200
In-Reply-To: <20260501134418.863432-3-can.guo@oss.qualcomm.com>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
	 <20260501134418.863432-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

CkNhbiwgCgoKU29ycnkgZm9yIHRoZSBsYXRlIHJldmlldyBvZiB0aGlzIHBhdGNoLiBJIGhhdmUg
c2V2ZXJhbCBxdWVzdGlvbnM6CgoKT24gRnJpLCAyMDI2LTA1LTAxIGF0IDA2OjQ0IC0wNzAwLCBD
YW4gR3VvIHdyb3RlOgo+IEBAIC0xMjk3LDcgKzEyOTcsNyBAQCBpbnQgdWZzaGNkX2NvbmZpZ190
eF9lcV9zZXR0aW5ncyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLAo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4g
wqAKPiDCoMKgwqDCoMKgwqDCoMKgcGFyYW1zID0gJmhiYS0+dHhfZXFfcGFyYW1zW2dlYXIgLSAx
XTsKPiAtwqDCoMKgwqDCoMKgwqBpZiAoIXBhcmFtcy0+aXNfdmFsaWQgfHwgZm9yY2VfdHhfZXF0
cikgewo+ICvCoMKgwqDCoMKgwqDCoGlmICghcGFyYW1zLT5pc192YWxpZCB8fCBwYXJhbXMtPmlz
X3N0YXRpYyB8fCBmb3JjZV90eF9lcXRyKSB7CgpXaGVuIHVzZV9hZGFwdGl2ZV90eGVxIGlzIG9u
IGFuZCBwYXJhbXMtPmlzX3N0YXRpYyBpcyB0cnVlLCBFUVRSIHdpbGwgb3ZlcndyaXRlCnRoZSBz
dGF0aWMgdmFsdWVzLiBUaGF0IGlzIHJlYXNvbmFibGUgc2luY2UgRVFUUiBpcyBtb3JlIGFjY3Vy
YXRlLiBJcyB0aGUKaXNfc3RhdGljIGNoZWNrIHJlYWxseSBuZWVkZWQgaGVyZT8KCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0Owo+IMKgCj4gCgouLi4KCj4gwqAKPiDC
oHZvaWQgdWZzaGNkX3JldHJpZXZlX3R4X2VxX3NldHRpbmdzKHN0cnVjdCB1ZnNfaGJhICpoYmEp
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzaGNkLXBsdGZybS5jIGIvZHJpdmVy
cy91ZnMvaG9zdC91ZnNoY2QtCj4gcGx0ZnJtLmMKPiBpbmRleCBjMmRhZmI1ODNjZjUuLmRlNjMw
MmU4YzA2NyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmc2hjZC1wbHRmcm0uYwo+
ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzaGNkLXBsdGZybS5jCj4gQEAgLTIxMCw2ICsyMTAs
ODYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2luaXRfbGFuZXNfcGVyX2RpcihzdHJ1Y3QgdWZzX2hi
YQo+ICpoYmEpCj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoH0KPiDCoAo+ICtzdGF0aWMgdm9pZCB1
ZnNoY2RfcGFyc2Vfc3RhdGljX3R4X2VxX3NldHRpbmdzKHN0cnVjdCB1ZnNfaGJhICpoYmEpCj4g
K3sKPiArwqDCoMKgwqDCoMKgwqBzaXplX3Qgc3ogPSBoYmEtPmxhbmVzX3Blcl9kaXJlY3Rpb24g
KiAyICogVFhfRVFfU0VUVElOR1NfVFVQTEVfU1o7Cj4gK8KgwqDCoMKgwqDCoMKgdTMyIHNldHRp
bmdzW1VGU19NQVhfTEFORVMgKiAyICogVFhfRVFfU0VUVElOR1NfVFVQTEVfU1pdOwo+ICvCoMKg
wqDCoMKgwqDCoHUzMiAqaG9zdF9zZXR0aW5ncywgKmRldmljZV9zZXR0aW5nczsKPiArwqDCoMKg
wqDCoMKgwqB1MzIgbHBkID0gaGJhLT5sYW5lc19wZXJfZGlyZWN0aW9uOwo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCB1ZnNoY2RfdHhfZXFfcGFyYW1zICpwYXJhbXM7Cj4gCi4uLi4KPiArCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmFtcyA9ICZoYmEtPnR4X2VxX3BhcmFtc1tn
ZWFyIC0gMV07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhvc3Rfc2V0dGluZ3Mg
PSBzZXR0aW5nczsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2aWNlX3NldHRp
bmdzID0gc2V0dGluZ3MgKyBscGQgKiBUWF9FUV9TRVRUSU5HU19UVVBMRV9TWjsKPiArCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAobGFuZSA9IDA7IGxhbmUgPCBscGQ7IGxh
bmUrKykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cGFyYW1zLT5ob3N0W2xhbmVdLnByZXNob290ID0gaG9zdF9zZXR0aW5nc1swXTsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmFtcy0+aG9zdFtsYW5l
XS5kZWVtcGhhc2lzID3CoGhvc3Rfc2V0dGluZ3NbMV07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJhbXMtPmhvc3RbbGFuZV0ucHJlY29kZV9lbiA9
IGhvc3Rfc2V0dGluZ3NbMl07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBob3N0X3NldHRpbmdzICs9IFRYX0VRX1NFVFRJTkdTX1RVUExFX1NaOwo+ICsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmFtcy0+
ZGV2aWNlW2xhbmVdLnByZXNob290ID3CoGRldmljZV9zZXR0aW5nc1swXTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmFtcy0+ZGV2aWNlW2xhbmVd
LmRlZW1waGFzaXMgPSBkZXZpY2Vfc2V0dGluZ3NbMV07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJhbXMtPmRldmljZVtsYW5lXS5wcmVjb2RlX2Vu
ID0gZGV2aWNlX3NldHRpbmdzWzJdOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZGV2aWNlX3NldHRpbmdzICs9IFRYX0VRX1NFVFRJTkdTX1RVUExFX1Na
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBwYXJhbXMtPmlzX3ZhbGlkID0gdHJ1ZTsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcGFyYW1zLT5pc19zdGF0aWMgPSB0cnVlOwoKSSB3YW50IHRvIGNv
bmZpcm0gSSB1bmRlcnN0YW5kIHRoZSBjb2RlIGNvcnJlY3RseS4gUGxlYXNlIHRlbGwgbWUgaWYg
SSBhbSB3cm9uZzoKCjEsIFdoZW4gdXNlX2FkYXB0aXZlX3R4ZXEgPSAwOiBzdGF0aWMgdmFsdWVz
IGFyZSB1c2VkIGRpcmVjdGx5IGFzIFRYIEVRIGZvciBIUy0KRzQgdG8gRzYuIEJ1dCB1ZnNoY2Rf
Y29uZmlnX3R4X2VxX3NldHRpbmdzKCkgcmV0dXJucyBlYXJseSB3aGVuCnVzZV9hZGFwdGl2ZV90
eGVxID0gMC4gU28gd2hpY2ggZnVuY3Rpb24gYXBwbGllcyB0aGUgc3RhdGljIHZhbHVlcyBpbiB0
aGlzCmNhc2U/wqAKCjIsIHdoZW4gdXNlX2FkYXB0aXZlX3R4ZXEgPSAxOiBzdGF0aWMgaG9zdCB2
YWx1ZXMgYXJlIHVzZWQgYXMgdGhlIGZpeGVkIGhvc3QgVFgKRVEgZHVyaW5nIEVRVFIuIFRoaXMg
aXMgYmVjYXVzZSB1ZnNfcWNvbV9nZXRfcnhfZm9tKCkgb25seSBzd2VlcHMgdGhlIGRldmljZQpz
aWRlLiBJdCByZWFkcyBob3N0IHZhbHVlcyBmcm9tIGhiYS0+dHhfZXFfcGFyYW1zW2dlYXItMV0t
Pmhvc3RbXS4gVGhlIHN0YXRpYwp2YWx1ZXMgYWxzbyB3b3JrIGFzIHRoZSBwZXItbGFuZSBmYWxs
YmFjayBpbiB1ZnNoY2RfdXBkYXRlX3R4X2VxX3BhcmFtcygpIHdoZW4KRk9NIGlzwqAwLgoKPiAr
wqDCoMKgwqDCoMKgwqB9Cj4gK30KPiArCj4gwqAvKioKPiDCoCAqIHVmc2hjZF9wYXJzZV9jbG9j
a19taW5fbWF4X2ZyZXHCoCAtIFBhcnNlIE1JTiBhbmQgTUFYIGNsb2NrcyBmcmVxCj4gwqAgKiBA
aGJhOiBwZXIgYWRhcHRlciBpbnN0YW5jZQo+IEBAIC01MjgsNiArNjA4LDggQEAgaW50IHVmc2hj
ZF9wbHRmcm1faW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LAo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoHVmc2hjZF9pbml0X2xhbmVzX3Blcl9kaXIoaGJhKTsKPiDCoAo+ICvCoMKgwqDC
oMKgwqDCoHVmc2hjZF9wYXJzZV9zdGF0aWNfdHhfZXFfc2V0dGluZ3MoaGJhKTsKPiArCj4gwqDC
oMKgwqDCoMKgwqDCoGVyciA9IHVmc2hjZF9wYXJzZV9vcGVyYXRpbmdfcG9pbnRzKGhiYSk7Cj4g
wqDCoMKgwqDCoMKgwqDCoGlmIChlcnIpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGRldl9lcnIoZGV2LCAiJXM6IE9QUCBwYXJzZSBmYWlsZWQgJWRcbiIsIF9fZnVuY19fLCBl
cnIpOwo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vm
c2hjZC5oCj4gaW5kZXggZjQ4ZDY0MTZlMjk5Li4yZDM4NWQ0MmZjZmYgMTAwNjQ0Cj4gLS0tIGEv
aW5jbHVkZS91ZnMvdWZzaGNkLmgKPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaAo+IEBAIC0z
NTksNiArMzU5LDcgQEAgc3RydWN0IHVmc2hjZF90eF9lcXRyX3JlY29yZCB7Cj4gwqAgKiBAaXNf
dmFsaWQ6IFRydWUgaWYgcGFyYW1ldGVyIGNvbnRhaW5zIHZhbGlkIFRYIEVxdWFsaXphdGlvbiBz
ZXR0aW5ncwo+IMKgICogQGlzX2FwcGxpZWQ6IFRydWUgaWYgc2V0dGluZ3MgaGF2ZSBiZWVuIGFw
cGxpZWQgdG8gVW5pUHJvIG9mIGJvdGggc2lkZXMKPiDCoCAqIEBpc190cmFpbmVkOiBUcnVlIGlm
IHBhcmFtZXRlcnMgb2J0YWluZWQgZnJvbSBUWCBFUVRSIHByb2NlZHVyZQo+ICsgKiBAaXNfc3Rh
dGljOiBUcnVlIGlmIHNldHRpbmdzIGFyZSBzdGF0aWMKPiDCoCAqLwo+IMKgc3RydWN0IHVmc2hj
ZF90eF9lcV9wYXJhbXMgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdWZzaGNkX3R4X2VxX3Nl
dHRpbmdzIGhvc3RbVUZTX01BWF9MQU5FU107Cj4gQEAgLTM2Nyw4ICszNjgsMTIgQEAgc3RydWN0
IHVmc2hjZF90eF9lcV9wYXJhbXMgewo+IMKgwqDCoMKgwqDCoMKgwqBib29sIGlzX3ZhbGlkOwo+
IMKgwqDCoMKgwqDCoMKgwqBib29sIGlzX2FwcGxpZWQ7Cj4gwqDCoMKgwqDCoMKgwqDCoGJvb2wg
aXNfdHJhaW5lZDsKPiArwqDCoMKgwqDCoMKgwqBib29sIGlzX3N0YXRpYzsKCmlzX3N0YXRpYyBp
cyBhZGRlZCBuZXh0IHRvIGlzX3RyYWluZWQsIHdoaWNoIHdhcyBhZGRlZCBpbiB5b3VyICJBZGQg
cGVyc2lzdGVudApUWCBFcXVhbGl6YXRpb24gc2V0dGluZ3Mgc3VwcG9ydCIgc2VyaWVzLCBUaGF0
IHNlcmllcyBzdGlsbCBoYXMgQnJpYW4ncyBvcGVuCnF1ZXN0aW9uIGFib3V0IHdUeEVRR25TZXR0
aW5nc0V4dCBCaXRbMTVdIGJlaW5nIFJGVSBwZXIgSkVTRDIyMEg6CgpodHRwczovL3BhdGNod29y
ay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtc2NzaS9jb3Zlci8yMDI2MDQyNDE1MTQyMC4xMTE2
NzUtMS1jYW4uZ3VvQG9zcy5xdWFsY29tbS5jbwoKSXMgdGhpcyB0aGUgcmVhc29uIHdoeSAiQWRk
IHBlcnNpc3RlbnQuLi4iIGhhcyBub3QgYmVlbiBtZXJnZWQ/CgpJJ2QgcHJlZmVyIHRvIHdhaXQg
dW50aWwgdGhhdCBkaXNjdXNzaW9uIGNvbmNsdWRlcyBiZWZvcmUgdGFnZ2luZyB0aGlzIG9uZS4g
SQpob3BlIHRoaXMgaXMgb2sgZm9yIHlvdS4KCktpbmQgcmVnYXJkcywKQmVhbgoKCg==

