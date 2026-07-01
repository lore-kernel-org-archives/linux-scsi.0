Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2357A431E6A;
	Wed,  1 Jul 2026 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782940240; cv=pass; b=AMac+iUa7kqsi8NwGnfknEUdtfymsNuYPdv/wS2YamYQttq7pCGtliaE9TY0n1k+NjzDH+DOo3wCFeDFPCzvgcVyQvLSg1dKIPc03BpIbN86BIvIeyd01u2BMDwHa+C6ZttzIErGYimox9L+f20/9H0/HbcgabDJfd2dqmhm7dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782940240; c=relaxed/simple;
	bh=aiqXOTKHE3sZXOf1PSFhI8bzhXJkNQ2W3yiSNHwOFKM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PrLSUYQRo/bfEV2JMiXAiswobCxC9zLLHJYpKs7vcn2oEOngoEj5SeZ4+1TGOGdqypvvE4Y3zgiJtH+GzmWcmvR1MEfbkqUTrwfUwPaaaARm5kvnnWz/RlT+U2zF/Z8z7Eyle68wPHib6ibgFgC8pdYV44qw3qxOpG8U8Kd8qWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=LjtQwGDR; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ZmLepnAd; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="LjtQwGDR";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ZmLepnAd"
ARC-Seal: i=1; a=rsa-sha256; t=1782938795; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=tivsDa/Nh69RRBdS4bgwUkW0PcagsGcUxFeoBBTOvseA3v++Mk8c8R3sDwIxzRpwwF
    QKXcqYQGG9VxE2z9xmFxrtvpm623GT8QoRj61SAJutgmB8odrWwpDsK0vCi2gY8/2pI7
    21PgbYsTVB55sPzx163yp72HAokpOppJo4oIdfuZKxmvgXY62V99tFZNUYppDq9Cu/l4
    4HDlAWowX+rilasP4jJqJapOYNmukO2/r2p5YkZI6yyhxi0P2J6LxVpVVCJfA2l61TZo
    cGYHKug10Zmxg4lPRwZ/WVd3CEsa/zA6d2me6rc2lg4bL2RAcRS23B1bc9dFFiSqI2JA
    uqJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1782938795;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aiqXOTKHE3sZXOf1PSFhI8bzhXJkNQ2W3yiSNHwOFKM=;
    b=eY+RdFFElV/hHR+sEIrpduta2PFbBUMEsLD1K48P5lJ58H3GHWC6QNgUnsWf/TjK97
    Z7jJC0wg/gJYtcnrnbpXJCSh0Uh8EztnrQOIPctAULN1fPj1poaFJUv/0Wp16Xq9nfSp
    EhhcuN7/IMX0coOJ0X+jFwtpuWHaWn9qtdtYE/lYO1PnPnVIGzR34q52kFBIkvUjtdNp
    nsZI9eqKK9SfAevI1UtDJo4LMx+4Gr3SPrW106C4gmF/bsQzL4D5+g1tQdujn95ztYce
    xrWIVc1LygFzPO5Fu3UVP5VOsammXJn35JkLnv/elXEkykz9EGaICnJ46mLxp3h/ts/Z
    uEpg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1782938795;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aiqXOTKHE3sZXOf1PSFhI8bzhXJkNQ2W3yiSNHwOFKM=;
    b=LjtQwGDRF0/DfkAfsPwln41D9qmHIZKNRs/6H+kEe0N8Mh+c7YGnTR6NnaPsDTQnzF
    xFUwbeKXTuVWybSiHmllDS796pa3nRXC0qa+gx2UDfOEeKmIXNRMtxOwKzQhUdlet4JZ
    3erAZcT53RMY2xzjuOGXMzkJ3pmbyEVqAqZ9g7DevXnYZ2KVsscmcWbCemwSnCNbhXV0
    vipPJevXNrvpj4RqQU5EdbRlLPvreUUvtUyTpFNp1npyCe5qzArHBBdkncXHAzkseOY2
    EbC++YVsDIX/3NYI9Ze6osz+zRcy2JLQfC7c8uoQVRwoHa0qGh4HV2c22qjcTHqTQkCB
    AC3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1782938795;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aiqXOTKHE3sZXOf1PSFhI8bzhXJkNQ2W3yiSNHwOFKM=;
    b=ZmLepnAdlbTNm4wzdUaSnrmSwPQ0ZsuO1dFcA5CkkCSENJqjV0gFWc29oTlmltlTZ5
    1ufTpDQlzVDN3d2xhUAg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGWUpI6weUrZX7j5d8vw1ZwljKUZAZetExYucA=="
Received: from p200300c5871477310ac0be5030e43536.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d388261KkZVQ1
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 1 Jul 2026 22:46:35 +0200 (CEST)
Message-ID: <9dcf8995008d9e8f617b416bcefb60ef9b63aedc.camel@iokpp.de>
Subject: Re: [PATCH v2 2/3] scsi: ufs: core: Tolerate RX_FOM read failures
 in TX EQTR
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com,  peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <avri.altman@wdc.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  open list
 <linux-kernel@vger.kernel.org>
Date: Wed, 01 Jul 2026 22:46:34 +0200
In-Reply-To: <20260625121306.1655467-3-can.guo@oss.qualcomm.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
	 <20260625121306.1655467-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI2LTA2LTI1IGF0IDA1OjEzIC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+IHVmc2hj
ZF9nZXRfcnhfZm9tKCkgYWJvcnRlZCBUWCBFUVRSIHdoZW4gYSBwZXItbGFuZSBSWF9GT00gRE1F
IHJlYWQgZmFpbGVkLgo+IFRoYXQgbWFrZXMgdGhlIHdob2xlIHRyYWluaW5nIGZsb3cgZnJhZ2ls
ZSBldmVuIHRob3VnaCB0aGVzZSByZWFkcyBjYW4gYmUKPiB0cmVhdGVkIGFzIGJlc3QgZWZmb3J0
Lgo+IAo+IEtlZXAgVFggRVFUUiBydW5uaW5nIGJ5IGxvZ2dpbmcgUlhfRk9NIHJlYWQgZmFpbHVy
ZXMgYW5kIGNvbnRpbnVpbmcuCj4gTWFrZSBmYWlsZWQgbGFuZXMgZGV0ZXJtaW5pc3RpYyBieSBp
bml0aWFsaXppbmcgZWFjaCBsYW5lIEZPTSB0byAwIGJlZm9yZQo+IHJlYWRpbmcgYW5kIG9ubHkg
dXBkYXRpbmcgaXQgd2hlbiB0aGUgRE1FIHJlYWQgc3VjY2VlZHMuIFRoaXMgYXZvaWRzCj4gcHJv
cGFnYXRpbmcgc3RhbGUgb3IgdW5pbml0aWFsaXplZCB2YWx1ZXMgaW50byBFUVRSIGV2YWx1YXRp
b24uCj4gCj4gQWxzbyB1cGRhdGUgdGhlIGtlcm5lbGRvYyByZXR1cm4gZGVzY3JpcHRpb24gdG8g
bWF0Y2ggYmVoYXZpb3I6IFJYX0ZPTQo+IERNRSByZWFkIGZhaWx1cmVzIGFyZSBoYW5kbGVkIGFz
IHdhcm5pbmdzLCB3aGlsZSBnZXRfcnhfZm9tKCkgdm9wcwo+IGZhaWx1cmVzIGFyZSBzdGlsbCBw
cm9wYWdhdGVkIHRvIHRoZSBjYWxsZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2Fu
Lmd1b0Bvc3MucXVhbGNvbW0uY29tPgo+IC0tLQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnMtdHhl
cS5jIHwgMTkgKysrKysrKysrKysrKystLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2Vy
dGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzLXR4ZXEuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLXR4ZXEuYwo+IGluZGV4IDlkY2Ew
Y2QzNDRiOC4uZTEzMDJlYTlmMjdlIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZz
LXR4ZXEuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLXR4ZXEuYwo+IEBAIC00ODIsNyAr
NDgyLDggQEAgc3RhdGljIHZvaWQgdWZzaGNkX2V2YWx1YXRlX3R4X2VxdHJfZm9tKHN0cnVjdCB1
ZnNfaGJhCj4gKmhiYSwKPiDCoCAqIEBoX2l0ZXI6IGhvc3QgVFggRVFUUiBpdGVyYXRvciBkYXRh
IHN0cnVjdHVyZQo+IMKgICogQGRfaXRlcjogZGV2aWNlIFRYIEVRVFIgaXRlcmF0b3IgZGF0YSBz
dHJ1Y3R1cmUKPiDCoCAqCj4gLSAqIFJldHVybnMgMCBvbiBzdWNjZXNzLCBuZWdhdGl2ZSBlcnJv
ciBjb2RlIG90aGVyd2lzZQo+ICsgKiBSZXR1cm5zIDAgb24gc3VjY2VzcywgbmVnYXRpdmUgZXJy
b3IgY29kZSBpZiBnZXRfcnhfZm9tIHZvcHMgZmFpbHMuCj4gKyAqIFJYX0ZPTSBETUUgZ2V0IGZh
aWx1cmVzIGFyZSBsb2dnZWQgYW5kIHRyZWF0ZWQgYXMgMCBGT00gZm9yIHRoYXQgbGFuZS4KPiDC
oCAqLwo+IMKgc3RhdGljIGludCB1ZnNoY2RfZ2V0X3J4X2ZvbShzdHJ1Y3QgdWZzX2hiYSAqaGJh
LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHN0cnVjdCB1ZnNfcGFfbGF5ZXJfYXR0ciAqcHdyX21vZGUsCj4gQEAgLTQ5Nyw4ICs0OTgs
MTIgQEAgc3RhdGljIGludCB1ZnNoY2RfZ2V0X3J4X2ZvbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gdWZzaGNkX2RtZV9wZWVyX2dl
dChoYmEsIFVJQ19BUkdfTUlCX1NFTChSWF9GT00sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oAo+IFVJQ19BUkdfTVBIWV9SWF9HRU5fU0VMX0lOREVYKGxhbmUpKSwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICZmb20pOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAo
cmV0KQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIHJldDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJldCkgewo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaF9pdGVyLT5mb21b
bGFuZV0gPSAwOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZGV2X2RiZyhoYmEtPmRldiwgIkZhaWxlZCB0byBnZXQgRk9NIGZvciBIb3N0IFRYIExhbmUK
PiAlZDogJWRcbiIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxhbmUsIHJldCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjb250aW51ZTsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoX2l0
ZXItPmZvbVtsYW5lXSA9ICh1OClmb207Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiBAQCAtNTA4LDgg
KzUxMywxMiBAQCBzdGF0aWMgaW50IHVmc2hjZF9nZXRfcnhfZm9tKHN0cnVjdCB1ZnNfaGJhICpo
YmEsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSB1ZnNoY2RfZG1lX2dl
dChoYmEsIFVJQ19BUkdfTUlCX1NFTChSWF9GT00sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFVJQ19BUkdf
TVBIWV9SWF9HRU5fU0VMX0lOREVYKGxhbmUpKSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmZvbSk7Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkX2l0ZXItPmZvbVtsYW5lXSA9IDA7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfZGJnKGhiYS0+ZGV2LCAi
RmFpbGVkIHRvIGdldCBGT00gZm9yIERldmljZSBUWAo+IExhbmUgJWQ6ICVkXG4iLAo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBsYW5lLCByZXQpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgY29udGludWU7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KCgpMb2dp
YyBpcyBjb3JyZWN0LCBvbmx5IG9uZSBuaXQ6IGRldl9kYmcoKSBpcyBzaWxlbnQgaW4gcHJvZHVj
dGlvbiwgZGV2X3dhcm4gb3IKZGV2X3dhcm5fcmF0ZWxpbWl0ZWQgd291bGQgbWF0Y2ggdGhlIHN0
YXRlZCAid2FybmluZ3MiIGluIHRoZSBjb21taXQgbWVzc2FnZQppbnRlbnRlZC4KCgpSZXZpZXdl
ZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4KCg==

