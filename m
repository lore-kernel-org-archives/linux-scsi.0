Received: from cvsmtppost09.nm.naver.com (cvsmtppost09.nm.naver.com [114.111.35.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB639D6FA;
	Tue,  6 Oct 2026 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279664; cv=none; b=t+B/Ij4d3zg/fBDGnp7b2RdHlERcS2A2a3iXkxVe2+VstdneXaIEYAOzskRg5jVPZik1Olhlsa3C9t97bIn20iyAQYNdo5L2t6KvoZXOX+X40cWqJcl2rRxvGMDdr9PLj7fSOHsTAv9oXjC1R4QWcpLLjUWJGwsLgRJPhc3QB60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279664; c=relaxed/simple;
	bh=YYPZaLYh/AGF2Mo2RrRIfqQEFxAd2U5C3TQJ9SjmAzk=;
	h=MIME-Version:Message-ID:Date:From:In-Reply-To:References:To:Cc:
	 Subject:Content-Type; b=A/j7qu0YFiZCgY4xMoHlX9DzQJSP8GCL08qY+G3Bq9BY/iMONNJrQV8+HLlFbRj5zFJUJEdzOJ1N6eU4STcHuo8dnbrrW8churc60Oi1uiOuQFTkMaFx9JvDwr0HmEaljhmiYVEFBDK6SK38ouViNNMpr1nXejXKdPJvrZ9THWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=n11hUOUH; arc=none smtp.client-ip=114.111.35.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="n11hUOUH"
X-Works-Smtp-Source: /rbdKoulFqJCpNmdFxUXWHF0
Received: from nv1m-hmac-real-21 ([10.174.201.121])
  by cvsmtppost09.nm.naver.com with ESMTP id c9Bh+r3PRjG7ZDJQ5A-oNw
  for <multiple recipients>;
  Tue, 06 Oct 2026 09:40:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791279654; bh=YYPZaLYh/AGF2Mo2RrRIfqQEFxAd2U5C3TQJ9SjmAzk=;
	h=Message-ID:Date:From:To:Subject:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=n11hUOUHRB1drTEsa1j68h69xM7Ja0kgk95iaRCzZVa1/eccp7RAXnXO+qdvs8MMl
	 gbv/o6r66xYJB3AFKGUNr30VWSUYR0ZCZkIJ6A5ze5fmM9VRjHs0cE0FFXYEsa1hsY
	 di5EwRIfU6f4SJuAb+iBcMNo3dHYcOnpnvZ08LS0C4IWdssW0QoYU8LLCNTwYAqHcm
	 XfOty+xHIsZ0NBDyUYtwGNkS7IhSp3Gis0EcloGOFh97mPeBrkect/mPoDMW9vIPNb
	 Pm2bDXKtAbG80/9B0zAjVRdUpPHE5mSiQN9zVF0v2AgY7AuabHC6cb2v06GpRzmHyn
	 H9LJYjXSFa8rg==
X-Session-ID: de6069da94262c02ccc43bde41baf2b12ad3d5b5b4f1cc355529d536c6ce9173
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <96622e4086e5fb77b8148631fa6ca16e@cweb003.nm>
Date: Tue, 06 Oct 2026 18:40:54 +0900
From: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
In-Reply-To: <20261006052300-mutt-send-email-mst@kernel.org>
References: <20261006091138.827988-1-tjdqudcks0424@naver.com>
	<20261006052300-mutt-send-email-mst@kernel.org>
Importance: normal
To: =?utf-8?B?TWljaGFlbCBTLiBUc2lya2lu?= <mst@redhat.com>
Cc: =?utf-8?B?SmFtZXMgRSAuIEogLiBCb3R0b21sZXk=?= <James.Bottomley@hansenpartnership.com>,
	=?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?= <mkp@kernel.org>,
	=?utf-8?B?SmFzb24gV2FuZw==?= <jasowangio@gmail.com>,
	<linux-scsi@vger.kernel.org>,
	<virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>,
	<security@kernel.org>
Subject: =?utf-8?B?UmU6IFtCVUddIHNjc2k6IHNob3J0IHZpcnRpby1zY3NpIFZQRCByZXNwb25zZSBleHBvcw==?=
	=?utf-8?B?ZXMgc3RhbGUgaGVhcCBkYXRh?=
X-Works-Send-Opt: OsFwpzGdjHmdKHFOMr39Ko3YKHm/jAudFqM9KqMqFxIYkEljxBmwjAg=
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

WWVzLCB0aGF0IGlzIGEgZmFpciBzdW1tYXJ5LgoKTW9yZSBwcmVjaXNlbHksIGEgc2hvcnQgc3Vj
Y2Vzc2Z1bCB2aXJ0aW8tc2NzaSByZXNwb25zZSBjYXVzZXMgdGhlCmd1ZXN0IGtlcm5lbCB0byBj
YWNoZSBieXRlcyB0aGF0IHdlcmUgbm90IHN1cHBsaWVkIGJ5IHRoZSBkZXZpY2UgYW5kCmV4cG9z
ZSB0aGVtIHRocm91Z2ggdGhlIHdvcmxkLXJlYWRhYmxlIFZQRCBzeXNmcyBhdHRyaWJ1dGUuCgpU
aGUgZ3Vlc3Qta2VybmVsIGhlYXAgZGlzY2xvc3VyZSBpcyByZXByb2R1Y2libGUuIEkgYWdyZWUg
dGhhdCBpdHMKc2VjdXJpdHkgY2xhc3NpZmljYXRpb24gZGVwZW5kcyBvbiB3aGV0aGVyIHRoZSB2
aXJ0aW8tc2NzaQpkZXZpY2UvYmFja2VuZCBpcyBjb25zaWRlcmVkIHRydXN0ZWQgaW4gdGhlIHJl
bGV2YW50IHRocmVhdCBtb2RlbC4KCldvdWxkIHZhbGlkYXRpbmcgYW5kIHByb3BhZ2F0aW5nIHRo
ZSBhY3R1YWwgdmlydHF1ZXVlIHVzZWQgbGVuZ3RoIGJlCndvcnRod2hpbGUgYXMgYSByb2J1c3Ru
ZXNzIGZpeD8KClJlZ2FyZHMsCnN1bmdieWVvbmdjaGFuCg==
