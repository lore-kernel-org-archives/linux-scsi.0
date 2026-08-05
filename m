Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3662A3749FD;
	Wed,  5 Aug 2026 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948620; cv=pass; b=c91OqPXbAK1vo63HdCFi4tkEjKtUerwrm4GUQUdUW1JnNckoxsICUZB8d0RAveKNH/lGC5OcVGv5QAMdv18SUuNvxD2cFNSv5Ox3e5vVseldMdPytGcLc2dOnZydGgYkCqwRd78ut0mcEgAqaDmgL05K6f2FKUyGhP/x5Wpram8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948620; c=relaxed/simple;
	bh=3Fe7TjICK6EhGtEemNKJb2wFuI6Y1kd6HDQ3C9IPGCc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kkgsf69bY24uDOD99Sz5qi87bmZ1z3bcfrZ9Y8wz8YunWHej8h/Q0GYzbvE8eWbo/PAS/etpqQB5qohb1Ptf1l5xzdCgBRZM0FDKf9DH5LB59x3VC3q91jeMYyNrQh2WHPl9oB38EqCm/tELiNif7OGNBaQephfNTECoWmGaOqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=MsIm95Bc; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=eb2DsBCB; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="MsIm95Bc";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="eb2DsBCB"
ARC-Seal: i=1; a=rsa-sha256; t=1785948596; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=gNH6yR0AH6whQzlTq8VU4IZNUFpq/sQ0FNlULJ45IZ/XyEnWZa37haFE5/o9F0jU8z
    gBqaXh4ZaOFFmQ/6Y+qYV8tipSOc4PMErrOx+xEdV5QNbRxAdCdm/9Yc6pvoo4914+6v
    27q8Q3LKnKDyUQKR5ItRWcH/bAnRWz402BIHdPK3A87drF/fx+FXtYKsQU75EL65BZ/E
    PscSoIopxfxAp+WvGW2Ch1Njw3kl/oMOvGj8O9qFuTHSe98dA0NKpO56/kwQ8NS/O2Pb
    g9JoBAcdv2yzCqW9/MSQj5n2SIIByonql17XNiGq8Y0i5OPnz6WLdoW+ixpRmYN3VfdT
    cBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1785948596;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3Fe7TjICK6EhGtEemNKJb2wFuI6Y1kd6HDQ3C9IPGCc=;
    b=Zu1wtMg39hUH/0deR19/gZ+o8dfjAT/HuqJLoNAvoEGsGfilPgC/yXx2p50B9HmksX
    bjsZXXm7Y/AGj4i6XgWnKhs5QHSUNu/alTXpyAbOc+9CL/4snh19xrCksAJ+lnF0Q81v
    KeTb2rk3Z4orjqOQlQH/iB2ImSHQuK6PhfGWZRJUt//o/fR+UXLzYxjQd4Qpbk6Lbs82
    ek8jCOwrZig5kgOTGzuaVjqFtfFh2k61C06PotTRot8y+2c2VqKGjd4mtHJ45DWbR2C0
    ovHYzAI6P+gd3qg7KRG7s85KjG8COLuFVk5aWNHID9ho9HG0QnyrhSipLGgY/RsrCt+B
    QKGA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1785948596;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3Fe7TjICK6EhGtEemNKJb2wFuI6Y1kd6HDQ3C9IPGCc=;
    b=MsIm95BcmpAOBMJrahFJlf7bPU2KkTP4tQyyqzvhKGOstokSTWCb8YNzlTslUJ7bgR
    O/0E550o3PEyK8BQYyKmagsn8cu5q8MaZvf2Jf4HzgBqfLtEZewc8V3226hVCnWl/Os7
    OOxk+FN2FSoxFV6fQ6TVZh+RBzgsoG1JHp2FXyArCVodskpFrXFq27LxQ0vHNVaLHvUO
    iPSLyLE/r2YB1u71Xm04r8uRVs6hF9KJ+2x/qDP7IRBDEy4XmMN7ZVqsILKd3FCNFpUO
    03fKCGZbmvBzk2gsT4uas4zUcthZ3HMIJ7+kxdSnOQAHqoBz2Eb40dyLZkasrZCVg7Ss
    1CpA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1785948596;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3Fe7TjICK6EhGtEemNKJb2wFuI6Y1kd6HDQ3C9IPGCc=;
    b=eb2DsBCBQ0Ods2FQmjM1uAeyfl66kcZYZWTnO8lKcOhMk8/ybpX0CUE8Fm7tHVWxlA
    Q/l2LjfCkzfkZRHF7HDQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc9275Gnt544
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 5 Aug 2026 18:49:55 +0200 (CEST)
Message-ID: <e83a4cdc8f2361d7be16358ef501b4d017078ac0.camel@iokpp.de>
Subject: Re: [PATCH 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
 sumit.garg@oss.qualcomm.com
Date: Wed, 05 Aug 2026 18:49:54 +0200
In-Reply-To: <20260715214327.1933560-3-jorge.ramirez@oss.qualcomm.com>
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
	 <20260715214327.1933560-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI2LTA3LTE1IGF0IDIzOjM5ICswMjAwLCBKb3JnZSBSYW1pcmV6LU9ydGl6IHdy
b3RlOgo+IEBAIC0xNTYsNiArMTU4LDcgQEAgaW50IHVmc19ycG1iX3Byb2JlKHN0cnVjdCB1ZnNf
aGJhICpoYmEpCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB1ZnNfcnBtYl9kZXYgKnVm
c19ycG1iLCAqaXQsICp0bXA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBycG1iX2RldiAqcmRl
djsKPiArwqDCoMKgwqDCoMKgwqBjaGFyICpkZXZfaWQgPSBOVUxMOwo+IMKgwqDCoMKgwqDCoMKg
wqBjaGFyICpjaWQgPSBOVUxMOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmVnaW9uOwo+IMKgwqDC
oMKgwqDCoMKgwqB1MzIgY2FwOwo+IEBAIC0yMTUsOCArMjE4LDE3IEBAIGludCB1ZnNfcnBtYl9w
cm9iZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZXJyX291dDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXNjci5k
ZXZfaWQgPSBjaWQ7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRlc2NyLmRldl9p
ZF9sZW4gPSBzdHJsZW4oY2lkKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2
X2lkID0ga3phbGxvYyhVRlNfUlBNQl9JRF9MRU4sIEdGUF9LRVJORUwpOwo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIWRldl9pZCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2aWNlX3VucmVnaXN0ZXIoJnVmc19ycG1iLT5k
ZXYpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
ID0gLUVOT01FTTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGdvdG8gZXJyX291dDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQoKCnNp
bmNlIHJwbWJfZGV2X3JlZ2lzdGVyKCkga21lbWR1cHMgZGV2X2lkLCBjYW4gd2UgdXNlIHRoaXM6
IAoKCiAgICAgICAgdTggZGV2X2lkW1VGU19SUE1CX0lEX0xFTl07CiAgICAgICAgYmxha2UyYihO
VUxMLCAwLCBjaWQsIHN0cmxlbihjaWQpLCBkZXZfaWQsIFVGU19SUE1CX0lEX0xFTik7CiAgICAg
ICAgZGVzY3IuZGV2X2lkID0gZGV2X2lkOwogICAgICAgIGRlc2NyLmRldl9pZF9sZW4gPSBVRlNf
UlBNQl9JRF9MRU47CgrCoAp0aGVuIHlvdSBjb3VsZCBkcm9wIGFsbG9jYXRpb24gYW5kIGl0cyBl
cnJvciBicmFuY2ggYW5kIGJvdGgga2ZyZWUoKT8KCgpLaW5kIHJlZ2FyZHMsIApCZWFuCgoK

