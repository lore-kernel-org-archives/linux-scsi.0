Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA0F156F36;
	Mon, 11 Nov 2024 23:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731367024; cv=none; b=rf6SXIPphXlMqnIc1O19zCG9uaJ1pQLf7J0A3kG5GJvoS1aeJ4jCCw8lmP2huMOPSm5mMEgRq8CjGY2VDvw/OhkoCsSsKdv6n1rIIOBcC/8eDozwQEAFjbHamDn0BVNoZiR26AKc/B3IROyjN8h4OhVygbxASX31/EJoZ3XTDyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731367024; c=relaxed/simple;
	bh=6ByKhrtnTdSeq5vYslz0IFBDSTan/9x2BpoAYQz8zD0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KBJeMjEhCYkhmyLvUgrTBYLC3rJDsfz1Dte4Ptix58L7pD6Oj7loCiTHt86q85cftdWgmMZLtCvgIil8D8PIfFJty8FjZWFE3fLLZCoZzdsJAdCYUhfSoRTprrA3DD1A5EtPpa7xIUYiTuB6rz4g9WaChKIigXdtruVPkX6Iu8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDup/3i2; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDup/3i2"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d49ffaba6so3355071f8f.0;
        Mon, 11 Nov 2024 15:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731367021; x=1731971821; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ByKhrtnTdSeq5vYslz0IFBDSTan/9x2BpoAYQz8zD0=;
        b=LDup/3i21LdbUHDNUku9sWJUSaohVdpzsXD3z4DNQogpbYPNP+CSCbKMG6yFr/YDPp
         PEy6wrOsQA3nvt8pZ6lOV+lq/l5L653vTuu3rghPUyXBEIKHG/E/mAmkFPcuKVxAWm7I
         bu+GKF9R3cwEUQXTOZBa1jCdmaSCGgnBRy+42bZkh1ByXRAcrhUvXEJnc+cfCMsPqjFj
         DjYYW030UBlJxajR0dIxLHheb0JfA2onEdJBBvBjcnynJp2W4QY0Ld97gw9pf5qyCJM4
         y+TgYGCNgjWgcq7QO1ldKf2GwgYWVVljzS1aLyLn2/TQdKhfKzLkmbC15o2D4WhMa2Z2
         a0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731367021; x=1731971821;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ByKhrtnTdSeq5vYslz0IFBDSTan/9x2BpoAYQz8zD0=;
        b=GrHhstKF/E5jF0Wbk+293wuiDrK8phQ8zaA9WD1talKSEHR8/gSdOBPMe4tC291Psu
         uKxLPZUdndyd7cbKh6VdELuwpdahphkgrzD/7v3yMoDF6lIDSdbA3pKQzlZ7g6sBjOqd
         rbjjRo2UFz2ijUnNMX+l3V+Au/SfT3sUcT6A3O3lklmUeKRzFKYMefiKaFxJHAn7Hfhq
         pSwygnrWkKE9V2IObwg5/OLdVWYs2LEtIUMEwA1/omS8G6En+928r8bvOjujaOxS690k
         CLLTzWcgEOWwk9uuo0qdzjQiSlSQkhQRZEf8HHLXcw1fd6xPYFDuPawcccFdYySMFhlM
         jJNA==
X-Forwarded-Encrypted: i=1; AJvYcCVBACEXRmatipdCUwQgADACAsxMsCjnLTBk8yQMXGVGYJYZaSujtnjNvGBC+NjwBs9TGpABLlp+k3E73FE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzABNLJ9MqPol2107r9L84wpvJl9jj78S1VCYwOiTCBAavguzVZ
	IfLnpPwIgdmDpkkwIYaInUy24kiNIHuGuQgrm2DbUmzpMq0nmhSr
X-Google-Smtp-Source: AGHT+IG5ti3h3me+DJUuyl1FQhWTw1PmIZ89CcgzTIS31zmkSMTfMmpkQDykkej6v1wyvZcbqouzKw==
X-Received: by 2002:a5d:59a3:0:b0:37d:3999:7b4 with SMTP id ffacd0b85a97d-3820811097cmr227508f8f.17.1731367020461;
        Mon, 11 Nov 2024 15:17:00 -0800 (PST)
Received: from p200300c58705a887af351ac25877d5c0.dip0.t-ipconnect.de (p200300c58705a887af351ac25877d5c0.dip0.t-ipconnect.de. [2003:c5:8705:a887:af35:1ac2:5877:d5c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c1a13sm189943475e9.29.2024.11.11.15.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:16:59 -0800 (PST)
Message-ID: <2d9aa1f9ed2e63d29dc2a7745fdd4f6db45d8db0.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>
Date: Tue, 12 Nov 2024 00:16:58 +0100
In-Reply-To: <20241105112502.710427-2-avri.altman@wdc.com>
References: <20241105112502.710427-1-avri.altman@wdc.com>
	 <20241105112502.710427-2-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTExLTA1IGF0IDEzOjI1ICswMjAwLCBBdnJpIEFsdG1hbiB3cm90ZToKPiAt
wqDCoMKgwqDCoMKgwqBzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOwo+IC3CoMKgwqDCoMKgwqDCoC8qCj4gLcKgwqDCoMKgwqDCoMKgICogSW4gY2FzZSB5b3Ug
YXJlIGhlcmUgdG8gY2FuY2VsIHRoaXMgd29yayB0aGUgZ2F0aW5nIHN0YXRlCj4gLcKgwqDCoMKg
wqDCoMKgICogd291bGQgYmUgbWFya2VkIGFzIFJFUV9DTEtTX09OLiBJbiB0aGlzIGNhc2Ugc2F2
ZSB0aW1lIGJ5Cj4gLcKgwqDCoMKgwqDCoMKgICogc2tpcHBpbmcgdGhlIGdhdGluZyB3b3JrIGFu
ZCBleGl0IGFmdGVyIGNoYW5naW5nIHRoZSBjbG9jawo+IC3CoMKgwqDCoMKgwqDCoCAqIHN0YXRl
IHRvIENMS1NfT04uCj4gLcKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDCoMKgwqDCoMKgaWYgKGhi
YS0+Y2xrX2dhdGluZy5pc19zdXNwZW5kZWQgfHwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgKGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSAhPSBSRVFfQ0xLU19PRkYpKSB7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT047
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRyYWNlX3Vmc2hjZF9jbGtfZ2F0aW5n
KGRldl9uYW1lKGhiYS0+ZGV2KSwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaGJhLT5jbGtfZ2F0
aW5nLnN0YXRlKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byByZWxfbG9j
azsKPiArwqDCoMKgwqDCoMKgwqBzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwgJmhiYS0+
Y2xrX2dhdGluZy5sb2NrKQo+ICvCoMKgwqDCoMKgwqDCoHsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLyoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSW4gY2Fz
ZSB5b3UgYXJlIGhlcmUgdG8gY2FuY2VsIHRoaXMgd29yayB0aGUKPiBnYXRpbmcgc3RhdGUKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogd291bGQgYmUgbWFya2VkIGFzIFJFUV9D
TEtTX09OLiBJbiB0aGlzIGNhc2Ugc2F2ZQo+IHRpbWUgYnkKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICogc2tpcHBpbmcgdGhlIGdhdGluZyB3b3JrIGFuZCBleGl0IGFmdGVyIGNo
YW5naW5nCj4gdGhlIGNsb2NrCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHN0
YXRlIHRvIENMS1NfT04uCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoaGJhLT5jbGtfZ2F0aW5nLmlzX3N1c3Bl
bmRlZCB8fAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaGJhLT5jbGtf
Z2F0aW5nLnN0YXRlICE9IFJFUV9DTEtTX09GRikgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaGJhLT5jbGtfZ2F0aW5nLnN0YXRlID0gQ0xLU19PTjsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRyYWNlX3Vm
c2hjZF9jbGtfZ2F0aW5nKGRldl9uYW1lKGhiYS0+ZGV2KSwKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGhiYS0KPiA+Y2xrX2dhdGluZy5zdGF0ZSk7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm47Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
aWYgKHVmc2hjZF9pc191ZnNfZGV2X2J1c3koaGJhKSB8fAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaGJhLT51ZnNoY2Rfc3RhdGUgIT0gVUZTSENEX1NUQVRFX09QRVJB
VElPTkFMKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuOwo+IMKgwqDCoMKgwqDCoMKgwqB9CgpJJ20gd29uZGVyaW5nIGlmIGl0IHdvdWxkIGJl
IHNhZmUgdG8gcmVwbGFjZSBob3N0X2xvY2sgd2l0aCBnYXRpbmcubG9jawpvciBzY2FsaW5nLmxv
Y2suIEZvciBpbnN0YW5jZSwgaW4gYWJvdmUgY29udGV4dCwgdWZzaGNkX3N0YXRlIG5lZWRzIHRv
CmJlIGNoZWNrZWQsIGJ1dCBpdCdzIGN1cnJlbnRseSBzZXJpYWxpemVkIGJ5IGhvc3RfbG9jay4K
CktpbmcgcmVnYXJkcywKQmVhbgo=

