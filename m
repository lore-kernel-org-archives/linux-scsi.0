Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194553DAACB;
	Sun, 18 Oct 2026 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347712; cv=pass; b=bx1wVyiJ2pmzShfoRIhFVrk0YPHTeomqMFBhHFOALDjUAAw1kL5KjxxtQj3/A7qRpZls0PbqZl1mD/ZMiWKFcXCpBjmMGdcvzDFlBbokAQMQXdfNdXxln5kPvBkgQ5RXGI+ClF8mGSXJYPl8dA/g9ntDSV89N0i53vZLylCCdcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347712; c=relaxed/simple;
	bh=3pKT3x2ThQdMxHZhCFYPZjzhmVUEvaSkjCmS5Kxzclc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rK0IJSXI3NA4FPHToh/vtFpQpYyRyzQAIosPPuHQsDDXWNqmvyBS1UMJJfUgqpey5O2bSqYqAOL1zQz1FpGVZlhIi51Rf1cAif88KLU3kjGFuzo+amaWqUlRaTYAg7zMM4F0wGu7aCHE5f2euROOQ2ml5o4FzJ7CGVIiD8PIqKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=iFh4bgYo; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=3ymZfxcJ; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="iFh4bgYo";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="3ymZfxcJ"
ARC-Seal: i=1; a=rsa-sha256; t=1792347701; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=p/cYTrrHL9DsBsr2+ou0E5MsJhCzYv1XJsvePJ1grYsACz0MhqI851j9A8AqEzG998
    j/ClzCw9Uz6xKp2FidDallmUheg8u+L8qsvg/cMFJ9R6mY8ryY8RyFyQQ8F31Kb33v86
    BHbhWrCPVC5GJnx+95K0V8YsCjsI1NmdY8yU2U3/EhQLf1l8vyvqktG2OfYHIOeE5kR+
    ghd44FoUj1Skj3gOdhPyJ2x50Hn9YYAE4jGAczanePjlG2/REhcWeV8OtSH9j+MOFhPH
    0i/hwU+mEqxSdX8CpuwCDcfbuAPrgMrxVNggH3pjr6mMj/VK6YNMXDV92F9W0ijC3N5Q
    zozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792347701;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3pKT3x2ThQdMxHZhCFYPZjzhmVUEvaSkjCmS5Kxzclc=;
    b=WWoRmwSn9ezX1Se+lFpGoGiKtgRVOvHMCy5mdrYfDlJlq5gYQEvk4u/G0bd9XAG7Wc
    3xlLHzqqhKkpY3Ibb5G2VMe7gSQPJjsg2ahuxYkgGOV9Mx33xJMbIAXCKPs4NnEev5sn
    G6mSpxuUO4eR5RI2tMF3wq0tcX/BGgdu+YfPf3VtGfopjiBjOjB8hlDOGj1VPztr9Cn8
    0gJuHy/lgABsfKPZNRZyvS1H8kL/YBwjuel2vR3DYX3NRd+srA6h901DzTF+XhbYauPH
    6AC1n1bOMP4JbQ8WhPwlmefjh/L30OzKQV28+UCHnyomBjufTxCTAdOgTsEDadTF+ehv
    ZrBg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792347701;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3pKT3x2ThQdMxHZhCFYPZjzhmVUEvaSkjCmS5Kxzclc=;
    b=iFh4bgYollk2iwNasoW0IxYJs0TaN/p2I3hQUuPQh2kvNGXtI0u1docBIO6HuiYyZq
    cGR710G9NnE4Va1BEq5pzJ+O49+vd+afSCW1ecMZFl+Mnpjn8XKZkj/kQ802fPs7C9AM
    whInmkwvXVWLnC3q8hWgUtbdATysOejTxpYKeIxk9QeGivjbkpWh9rw+xqnnBt/wSw1z
    HHg5qHW62ijkyWPXRW8feRB/rv7ra/KkHoGyLge4PD5l1CMp+th0Yd+YeiLCNxDMcT60
    V9wpePX9BgJ9UQA+P0o4+SfwNuPeNJ+OYo/Sd9spzHOmvER2LsFYCCruH+DoIZxoB/wl
    xBDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792347701;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3pKT3x2ThQdMxHZhCFYPZjzhmVUEvaSkjCmS5Kxzclc=;
    b=3ymZfxcJgFv9ZRBiLMwcWu9Tqs0gK2Q8yhaq6SqGMmYOqfHOLWEfnl4zWFG5O1SuEY
    sx5PJTzN69pDq6NFLCDA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IILeHJa
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 20:21:40 +0200 (CEST)
Message-ID: <361e83f8ae479909597238b4ddf9b3a1e40ef0c2.camel@iokpp.de>
Subject: Re: [PATCH v2 1/5] scsi: ufs: bsg: Complete the job on error
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 18 Oct 2026 20:21:39 +0200
In-Reply-To: <20261015001855.3450573-2-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
	 <20261015001855.3450573-2-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI2LTEwLTE1IGF0IDA4OjE4ICswODAwLCBTdGFubGV5IEpodSB3cm90ZToKPiBp
bmRleCA3YTY2OTE3YjNmYzAuLjE4YzMxOGQ3ODEyMiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc19ic2cuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzX2JzZy5jCj4gQEAg
LTE5NSwxNCArMTk1LDEyIEBAIHN0YXRpYyBpbnQgdWZzX2JzZ19yZXF1ZXN0KHN0cnVjdCBic2df
am9iICpqb2IpCj4gwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9ycG1fcHV0X3N5bmMoaGJhKTsKPiDC
oMKgwqDCoMKgwqDCoMKga2ZyZWUoYnVmZik7Cj4gwqDCoMKgwqDCoMKgwqDCoGJzZ19yZXBseS0+
cmVzdWx0ID0gcmV0Owo+IC3CoMKgwqDCoMKgwqDCoC8qIGNvbXBsZXRlIHRoZSBqb2IgaGVyZSBv
bmx5IGlmIG5vIGVycm9yICovCj4gLcKgwqDCoMKgwqDCoMKgaWYgKHJldCA9PSAwKSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgaWYgKHJldCA9PSAwKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgam9iLT5yZXBseV9sZW4gPSBycG1iID8gc2l6ZW9mKHN0cnVjdCB1ZnNfcnBtYl9yZXBseSkg
Ogo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2l6ZW9mKHN0cnVjdCB1ZnNfYnNnX3JlcGx5KTsK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnNnX2pvYl9kb25lKGpvYiwgcmV0LCBi
c2dfcmVwbHktPnJlcGx5X3BheWxvYWRfcmN2X2xlbik7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+ICvC
oMKgwqDCoMKgwqDCoGJzZ19qb2JfZG9uZShqb2IsIHJldCwgYnNnX3JlcGx5LT5yZXBseV9wYXls
b2FkX3Jjdl9sZW4pOwoKU2luY2UgdGhlIG9sZCBjb21tZW50IGlzIGdvbmUsIGl0J3MgYmV0dGVy
IHRvIGFkZCBhIHNob3J0IG9uZSBiZWZvcmUKYnNnX2pvYl9kb25lKCkgc2F5aW5nIHdlIG11c3Qg
YWx3YXlzIGNvbXBsZXRlIHRoZSBqb2IgYW5kIHJldHVybiAwPwoKb3RoZXJ3aXNlIGEgbGF0ZXIg
Y2hhbmdlIGNvdWxkIGVhc2lseSBicmluZyBiYWNrIGVpdGhlciB0aGUgbGVhayBvciB0aGUgZG91
YmxlCmNvbXBsZXRpb24gdGhhdCBiMTNhMzUzOWViMmEgZml4ZWQ/CgpSZXZpZXdlZC1ieTogQmVh
biBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4KCj4gwqAKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4g
cmV0Owo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+IMKgfQoK

