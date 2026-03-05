Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E914C3033E6;
	Thu,  5 Mar 2026 22:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748171; cv=pass; b=MHghO81sC+RedTvBdYNgqSYu4BZNnp5I79BqJqtbS/PIqZlRLMcroD9DirEjehUDxruIyGtCWVFznK/SA7CI27PouashJJbgrGN3B7JpmVK3BjNLIDRYR7C6MfG5QE3Tzi6/gOV5mKroLJWdKMm7EL++hXHmKH/+GslSpWHSa7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748171; c=relaxed/simple;
	bh=5HPVDRnbKdZj2bwJhIpl77iEYmg4hR5fTyCpCyySCFk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pb3lqlx9I/sPj5U+xw5dO4FHxfy+tnv4+gQIJp6DFJ3IrfdJe4OWn87MoLokd7hppMcbmlOmO3nGGVzlGzImsn0CbPjVcdIUVxIbjg5JPFhG4CQdm/XnpO71Rgqb/icQ9IAyQYLklA1Wf8xdjQEhU93JoGads5dh2UxsCI57wz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ohgSwQLS; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=K746Mkm1; arc=pass smtp.client-ip=81.169.146.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ohgSwQLS";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="K746Mkm1"
ARC-Seal: i=1; a=rsa-sha256; t=1772747445; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=RjPIfuFrn/fi/VrIfO1a+Ar2Wt6vM18J9qMIrCUhyrzq5SD6CAnTvGbK6YazLYhhw2
    fKd2bJVzMAyTAtyaW8L1g7A1UmOMK3AE+WjjE2Wp7mNT4xDGahTP7uIvGpFQ0V5eCj2n
    nvY69B0eiS0fFN8qzM1mF86IQoKlUmm3ER5i4I4IUKHvHTdKM/RD2sMIJI6mAsRVvaZT
    nAUYAkZtJiI0a3YP+WRaFktTCCm1PiMrz/jmMuSj3VRuIo6XsSA5foMT15901Hy1fRQN
    GasH7mLnUghUOh3EoZEdtWGJCKLwj9RO9he9mFVkrprPCmJ9VdWt7+gqaNlOeYu3VUIL
    OY5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1772747445;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5HPVDRnbKdZj2bwJhIpl77iEYmg4hR5fTyCpCyySCFk=;
    b=XLjmm28BvKE9Ljf9BL5zVV0ZPd+mmWOJ+e9xaHGk0WnOxXMS70jb7ifs7iIpEmjX+V
    Mg92uGEkuSFZCbPf0M43q7Le3A34eglHZovm/1EkHsBJZg8+zq3ZIquLTDP8p068xhbj
    pLL39RMaogOuSPeyNL4JojvjbC89cohPDXpJy5gaFeEkUQS780PPH+osCGNAc39SIKDT
    34PjJbTYTt+4p9Bm8jvtVT29szgbk/0vM+LPb9uCLCKfH+llGe7eZ85XmTiJaU1GUYqP
    tE2o/Yc5kOlmCmb8AxV2pM3t3x0x0r1KuJSNhbn+RBsobetFHB55U5NRgSHxBC6FG3Qj
    aGsg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1772747445;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5HPVDRnbKdZj2bwJhIpl77iEYmg4hR5fTyCpCyySCFk=;
    b=ohgSwQLSk2WLTOBQQgFf28/Yp0N54JuNhnRdxd2W5oxAV6BuZKk9vPRqC8NmOExlrc
    tUUC/Zh3DzQQMFHAOthA68j1nJrwpHrHpjxLukDstaPA3EoaPrFpIc0/JRY78FDCCeK/
    Do5rSHZCpqh50UP1a6gBuZCrBCV+/o1DxlMmLzKQjMcn07cg0Erp30cdmR5zjesYjdn/
    7DZO+i/DyUKI5XDqyopygxIdUya0NfIsly71KNQw/Gx+FM+XGXQwglV0mlpOpsUK4Noj
    FQdMp18TNj67N2ApMkSB2o4U1EggSrhX1KAWONvwcsKxBBUONs9m1GU13ruxtV65skzQ
    /3IA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1772747445;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5HPVDRnbKdZj2bwJhIpl77iEYmg4hR5fTyCpCyySCFk=;
    b=K746Mkm1mYOLyWWE5sUbeGRsadfOwHmaaPVNLC9j8CQ9Yd1F91p3WYMdyIHv8lcSxs
    schp4TR4Bh5cC3V8yiBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGSTpN/lG4EkH1OcwzJ11G3m+XGf4kwpD3TrkAw="
Received: from p200300c58703fb9bfc647aebea4a424d.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z79345225Loi7SL
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 5 Mar 2026 22:50:44 +0100 (CET)
Message-ID: <5f998c89c2939baa2939a1ad8942b015d3ccccfc.camel@iokpp.de>
Subject: Re: [PATCH v2 04/11] scsi: ufs: core: Add support for TX
 Equalization
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Thu, 05 Mar 2026 22:50:43 +0100
In-Reply-To: <20260304135313.413688-5-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
	 <20260304135313.413688-5-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDA1OjUzIC0wODAwLCBDYW4gR3VvIHdyb3RlOgo+ICsgKi8K
PiArc3RhdGljIGludCB1ZnNoY2RfdHhfZXF0cl9kYXRhX2luaXQoc3RydWN0IHVmc19oYmEgKmhi
YSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHVmc2hjZF90eF9lcV9wYXJhbXMgKnBhcmFtcywKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc3RydWN0IHR4X2VxdHJfaXRlciAqaF9pdGVyLAo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
dHJ1Y3QgdHhfZXF0cl9pdGVyICpkX2l0ZXIpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqB1MzIgY2Fw
Owo+ICvCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmICghaGJh
LT5ob3N0X3ByZXNob290X2NhcCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXQgPSB1ZnNoY2RfZG1lX2dldChoYmEsCj4gVUlDX0FSR19NSUIoVFhfSFNfUFJFU0hPT1RfU0VU
VElOR19DQVApLCAmY2FwKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJl
dCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biByZXQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoYmEtPmhvc3RfcHJl
c2hvb3RfY2FwID0gY2FwICYgVFhfRVFUUl9DQVBfTUFTSzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoGlmICghaGJhLT5ob3N0X2RlZW1waGFzaXNfY2FwKSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IHVmc2hjZF9kbWVfZ2V0KGhiYSwKPiBV
SUNfQVJHX01JQihUWF9IU19ERUVNUEhBU0lTX1NFVFRJTkdfQ0FQKSwgJmNhcCk7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+ICsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaGJhLT5ob3N0X2RlZW1waGFzaXNfY2FwID0gY2FwICYgVFhfRVFU
Ul9DQVBfTUFTSzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmICgh
aGJhLT5kZXZpY2VfcHJlc2hvb3RfY2FwKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldCA9IHVmc2hjZF9kbWVfcGVlcl9nZXQoaGJhLAo+IFVJQ19BUkdfTUlCKFRYX0hTX1BS
RVNIT09UX1NFVFRJTkdfQ0FQKSwgJmNhcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGlmIChyZXQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gcmV0Owo+ICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaGJh
LT5kZXZpY2VfcHJlc2hvb3RfY2FwID0gY2FwICYgVFhfRVFUUl9DQVBfTUFTSzsKPiArwqDCoMKg
wqDCoMKgwqB9Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmICghaGJhLT5kZXZpY2VfZGVlbXBoYXNp
c19jYXApIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gdWZzaGNkX2Rt
ZV9wZWVyX2dldChoYmEsCj4gVUlDX0FSR19NSUIoVFhfSFNfREVFTVBIQVNJU19TRVRUSU5HX0NB
UCksICZjYXApOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0KQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsK
PiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhiYS0+ZGV2aWNlX2RlZW1waGFz
aXNfY2FwID0gY2FwICYgVFhfRVFUUl9DQVBfTUFTSzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+
ICvCoMKgwqDCoMKgwqDCoG1lbXNldChwYXJhbXMtPmhvc3QsIDAsIHNpemVvZihwYXJhbXMtPmhv
c3QpKTsKPiArwqDCoMKgwqDCoMKgwqBtZW1zZXQocGFyYW1zLT5kZXZpY2UsIDAsIHNpemVvZihw
YXJhbXMtPmRldmljZSkpOwo+ICvCoMKgwqDCoMKgwqDCoG1lbXNldChwYXJhbXMtPmhvc3RfZXF0
cl9yZWNvcmQsIDB4RkYsIHNpemVvZihwYXJhbXMtCj4gPmhvc3RfZXF0cl9yZWNvcmQpKTsKPiAr
wqDCoMKgwqDCoMKgwqBtZW1zZXQocGFyYW1zLT5kZXZpY2VfZXF0cl9yZWNvcmQsIDB4RkYsIHNp
emVvZihwYXJhbXMtCj4gPmRldmljZV9lcXRyX3JlY29yZCkpOwo+ICsKPiArwqDCoMKgwqDCoMKg
wqBtZW1zZXQoaF9pdGVyLCAwLCBzaXplb2Yoc3RydWN0IHR4X2VxdHJfaXRlcikpOwo+ICvCoMKg
wqDCoMKgwqDCoG1lbXNldChkX2l0ZXIsIDAsIHNpemVvZihzdHJ1Y3QgdHhfZXF0cl9pdGVyKSk7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGhfaXRlci0+bnVtX2xhbmVzID0gcGFyYW1zLT50eF9sYW5l
czsKPiArwqDCoMKgwqDCoMKgwqBkX2l0ZXItPm51bV9sYW5lcyA9IHBhcmFtcy0+cnhfbGFuZXM7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgICogU3VwcG9ydCBQcmVT
aG9vdCAmIERlRW1waGFzaXMgb2YgdmFsdWUgMCBpcyBtYW5kYXRvcnksIGhlbmNlIHRoZXkKPiBh
cmUKPiArwqDCoMKgwqDCoMKgwqAgKiBub3QgcmVmbGVjdGVkIGluIFByZVNob290L0RlRW1waGFz
aXMgY2FwYWJpbGl0aWVzLiBMZWZ0IHNoaWZ0IHRoZQo+ICvCoMKgwqDCoMKgwqDCoCAqIGNhcGFi
aWxpdHkgYml0bWFwIGJ5IDEgYW5kIHNldCBiaXRbMF0gdG8gcmVmbGVjdCB2YWx1ZSAwIGlzCj4g
K8KgwqDCoMKgwqDCoMKgICogc3VwcG9ydGVkLCBzdWNoIHRoYXQgdGVzdF9iaXQoKSBjYW4gYmUg
dXNlZCBsYXRlciBmb3IgY29udmVuaWVuY2UuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDC
oMKgwqDCoMKgaF9pdGVyLT5wcmVzaG9vdF9iaXRtYXAgPSAoaGJhLT5ob3N0X3ByZXNob290X2Nh
cCA8PCAweDEpIHwgMHgxOwo+ICvCoMKgwqDCoMKgwqDCoGhfaXRlci0+ZGVlbXBoYXNpc19iaXRt
YXAgPSAoaGJhLT5ob3N0X2RlZW1waGFzaXNfY2FwIDw8IDB4MSkgfCAweDE7Cj4gK8KgwqDCoMKg
wqDCoMKgZF9pdGVyLT5wcmVzaG9vdF9iaXRtYXAgPSAoaGJhLT5kZXZpY2VfcHJlc2hvb3RfY2Fw
IDw8IDB4MSkgfCAweDE7Cj4gK8KgwqDCoMKgwqDCoMKgZF9pdGVyLT5kZWVtcGhhc2lzX2JpdG1h
cCA9IChoYmEtPmRldmljZV9kZWVtcGhhc2lzX2NhcCA8PCAweDEpIHwgMHgxOwo+ICsKPiArwqDC
oMKgwqDCoMKgwqByZXR1cm4gcmV0OwoKCnJldCBpcyByZXR1cm5lZCB3aXRob3V0IGd1YXJhbnRl
ZWQgaW5pdGlhbGl6YXRpb24gd2hlbiBjYXBzIGFyZSBhbHJlYWR5IGNhY2hlZC4KCj4gK30KCg==

