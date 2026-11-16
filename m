Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794837658;
	b=NqawMZn/puqqclwAgQ7oosRm66N+rEJNX/A9iv4W5sA+Xf6/He9vS1o2WXYbR2vAlLYL
	 7uftjMEmLjEw/i2YJs2/OrpMfG/mceR7BVET05K5rOelHJu6G3ga/sdDwD34g70c3irfz
	 8/g/nk70Y6/g155LDi+c1o2YFAcO0JZKaD04LE9g/F54ZQkfGZVCF+F78tLrCotbOFUc4
	 q0q9p/bhSNEY0Iwg0boSt+xxv/O7GpNoXmg8S2nN5dR0jdRUSYxrsbQr7QUECw9i1WI8a
	 tXRck2x1rSwM9SrfSPlv813GTUBKfBotdimFaGFUfuBGizwo2om2l/1WZ3nh/OBSX/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837658;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Iz2UTzzevygEQJfoMo8z88opOxdoTMIWPGKJ1VJvcmM=;
	b=KjIhAIGF5GS6xorst3adCVhtsRPQh4MeLh3KQqH0It4tkl2WsqFEGIUOO6NnlAg5q6+j
	 //fvyNiRE/zy0B8QPo1FnVB32GfDSr33rHrXaPhcrL9jFbvXyjU+X8hKB4G3Z0/bCCAul
	 ISed/N2ZWls5cf3YtNxGSuYNQb87V+5WJrfnDV2sxLwL/cj4sju70vqMyLOaH4n8+uxnl
	 mcOlW0cpsO46lGrROCqfCTTrBLjWTMwym7et8MQvsbn+db61xq+2xcI3alFS2y8r/ia9J
	 qYcqnQYSyyKnW4z4x+rw4bc1b44u4nrtmsRn2gIDyQu3PI9eRWwtlKZtiAJ5LBWTXJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=GZ0EpYEv;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=ZsulkOhB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E0D606A33D;
	Mon, 16 Nov 2026 14:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43E0D606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=GZ0EpYEv;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=ZsulkOhB
ARC-Seal: i=1; a=rsa-sha256; t=1794837625; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lgVHsmdocWSs7r/FyeFoikXvqW8JIkDYyGAsxbrCU6G/MkekNirYkChR2B6Ub+JS7Q
    0hJ3ck5io6TO0Cc4OQ8Z+j6xQkjXEw/k3B2FyOlU8VjseWm8+BIsCq/YhgI+HDmZGUu4
    mS6boDMrZN1FEJwxXpBzSvEsyPAHmpviUTps1e/0zJQ+7p7omM8q7wZFgatfq1yqZctW
    SvotPd24Buo99EaU0cdBOa1KYxKQDOd3V/jNGY3i+CcDAXamR35fqLEQ4V8Jm7XhAYMq
    gnqAlVu0PIvLUCX97I0M5QvidkY0x9py4kRo8fQaDBNqF2w/wf9Ik1vRgcPsrgAsXUqH
    38BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794837625;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Iz2UTzzevygEQJfoMo8z88opOxdoTMIWPGKJ1VJvcmM=;
    b=T7aYHukIISyS1/iJO1RKFuVDHqfFK79O90tIjy9qO7YU8l0Z2kGMFbSwB39G7K+MMi
    t5IYDE5gg6afGnJa3YWlbZyvftHO7xgy1S2SPLO1tsRI8P4ngRuiFGK5Q/PRiwUWmxvb
    WHx5pGR0glt88C0GRKEbN7y1SWPmU8rWDQZ6Yp2pTxwgvxbS/xntN6XTu3jwpvXPd+Ht
    ypcMsi/0gyMAQWSMwd+9W9GtEESz0fwdtndHI+EUv5hS6P/AlccesK5+16vP9ei0fnZ0
    XAt9T9+e6J12shTUKs8Gm/6u49KUx9dXo3GNxI7r7NkzBD2uCNugI8uRJU80Y6kFyGuP
    fuDA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794837625;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Iz2UTzzevygEQJfoMo8z88opOxdoTMIWPGKJ1VJvcmM=;
    b=GZ0EpYEvfUFQzSBlQBulXGqScWt8COibJDcCkq/pewr9sREUqaUGAFV5GHknkmm2N2
    E0wIvf/ZUYDmIEbcrAz/ktWvq7i3eu1iWB5wH2BUhYqpkuvnCWirW8+5MIoUONifF9FO
    /GPq+NYmRnFna6ShpK17R30NoorE3kOcmrZPTOnMBlP4PxncgLNhU1qb6VQ1ybJvPxqU
    kiDioFzl9Pklwe+79m8160RD1em1Eh0zN4FSxSqluocFZW7pOhlw5iKK19zoac19VhEr
    bWyF4SUftyFlU2wBZz+nJWwL9vWDC4qia/Be97SKoazHWIQwjhioHAbkJE9YzECdT0ZJ
    xaiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794837625;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Iz2UTzzevygEQJfoMo8z88opOxdoTMIWPGKJ1VJvcmM=;
    b=ZsulkOhBrDtnlAgZniLF8HAIcYMCsFNbF9IjSTC6Kf2offCZtw1rJSi4wrrlxtsL0j
    gdRLJ9ZOs5WoHgRTMoBg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.78]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AGE0Oyda
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 16 Nov 2026 15:00:24 +0100 (CET)
Message-ID: <34fdf9f5a04e05d1713f57f63dcd2cd0b81ee959.camel@iokpp.de>
Subject: Re: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when
 get_cur_freq() fails
From: Bean Huo <beanhuo@iokpp.de>
To: chanwoo@kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi
 <cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, "James E .
 J . Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
 <avri.altman@sandisk.com>,  Bart Van Assche <bvanassche@acm.org>, Alim
 Akhtar <alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Bean Huo <beanhuo@micron.com>
Date: Mon, 16 Nov 2026 15:00:23 +0100
In-Reply-To: <a813b1ea-6971-4fde-b310-659a03963fba@gmail.com>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
	 <20260907192140.2701755-2-beanhuo@iokpp.de>
	 <a813b1ea-6971-4fde-b310-659a03963fba@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

T24gU3VuLCAyMDI2LTExLTE1IGF0IDA5OjI1ICswOTAwLCBDaG9pIENoYW53b28gd3JvdGU6Cj4g
PiAtwqDCoMKgwqDCoMKgwqBlbHNlCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoIWRldmZyZXEtPnBy
b2ZpbGUtPmdldF9jdXJfZnJlcSB8fAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIGRldmZyZXEt
PnByb2ZpbGUtPmdldF9jdXJfZnJlcShkZXZmcmVxLT5kZXYucGFyZW50LCAmY3VyX2ZyZXEpKQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjdXJfZnJlcSA9IGRldmZyZXEtPnBy
ZXZpb3VzX2ZyZXE7Cj4gPiDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqBmcmVxcy5vbGQgPSBjdXJf
ZnJlcTsKPiAKPiBJIGFncmVlIHRoaXMgcGF0Y2guCj4gQnV0LCBJIGRvbid0IHJlY29tbWVuZCB0
byBleGVjdXRlIHRvIGZ1bmN0aW9uIG9uIGlmIHN0YXRlbWVudC4KPiBJbiBvcmRlciB0byBpbXBy
b3ZlIHRoZSByZWFkYWJpbGl0eSwgY291bGQgeW91IHBsZWFzZSB1cGRhdGUgaXQgYXMgZm9sbG93
aW5nOgo+IAo+IMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgY3VyX2ZyZXEgPSBkZXZmcmVx
LT5wcmV2aW91c19mcmVxOwo+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIGZyZXE7Cj4g
wqDCoMKgwqDCoMKgwqDCoC4uLgo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZGV2ZnJlcS0+cHJvZmls
ZS0+Z2V0X2N1cl9mcmVxKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIg
PSBkZXZmcmVxLT5wcm9maWxlLT5nZXRfY3VyX2ZyZXEoZGV2ZnJlcS0+ZGV2LnBhcmVudCwKPiAm
ZnJlcSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIWVycikKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjdXJfZnJlcSA9IGZy
ZXE7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiAKPiAtLQo+IEJlc3QgUmVnYXJkcywKPiBDaGFud29v
IENob2kKPiBQcmluY2lwYWwgRW5naW5lZXIsIFNhbXN1bmcgRWxlY3Ryb25pY3MKCkNoYW53b28s
IAoKdGhhbmtzLCB3aWxsIHVwZGF0ZSB0aGVzZSB0d28gcGF0Y2hlcyBvbmx5IHNpbmNlIFVGUyBw
YXRjaGVzIGhhdmUgYmVlbiBtZXJnZWQuCgpLaW5kIHJlZ2FyZHMswqAKQmVhbiAKCg==

