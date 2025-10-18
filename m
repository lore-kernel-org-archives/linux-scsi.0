Received: from cdmsr1.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F52EBB88
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760783388; cv=none; b=mTDbFR3yG383UW/QUJhG0U+dqgaLIUu4TyQUNemPtEKkZWNYHjtu9hdp6eXtld0by2JLBMTu8OOBY5ScNh/9HI8wSwjSxGSo6/aewO69fN5HnHynwQY6+6LjLo6CF6zeiXoiJjt/6dQ24jMeaOAVqZOulzmOMeINP1kffvD+28I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760783388; c=relaxed/simple;
	bh=68LmKgyzs3ay7cCLLofsy5KXzqCb9K/BN8uHvHDGETc=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=RMCT8jVI2WFKzqbZxrwfY3RwarW0wn0odoefzFOJWnUthpQ9yOnGCxjDMHVJBWaVkNtrmvzFnDoOchvGxWwcd5SK3Og8ioTKKUg+zdKseGiBz8i5u2BexXNhowRIzJiC5HY48K9d/HUP25NzQAFx6ZfFj7+ThC7IffAoUryfHj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net; spf=pass smtp.mailfrom=ms29.hinet.net; dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b=AyhRu4tL; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b="AyhRu4tL"
Received: from cmsr7.hinet.net ([10.199.216.86])
	by cdmsr1.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IATgmQ866983
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 18:29:43 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=ms29.hinet.net;
	s=default; t=1760783383; bh=aG7rl53W0FS44wa7Q2BDn85VRPY=;
	h=From:To:Subject:Date;
	b=AyhRu4tLTvi58sQZe9j/GjGX/ngOsjvGliLusy/fmf/SwBmX8MP9RoP0WI/EtX/1A
	 aJz6VvkyWWnCV+2Rnd7XfBGEr2xXmChno3xy1I9dErj4W9gLINkVhH75WWozkAMkH7
	 HtIimCZSVRcwJOGGlAOfdpqRuIQkDtPdxSQgp404=
Received: from [127.0.0.1] (1-173-52-52.dynamic-ip.hinet.net [1.173.52.52])
	by cmsr7.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IAGCFm305900
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 18:23:35 +0800
From: "Sales - iGTI 291" <Linux-scsi@ms29.hinet.net>
To: linux-scsi@vger.kernel.org
Reply-To: "Sales - iGTI." <sales@igti.space>
Subject: =?UTF-8?B?Rmlyc3QgT3JkZXIgQ29uZmlybWF0aW9uICYgTmV4dCBTdGVwcw==?=
Message-ID: <0c17a9b3-9d1c-559d-728c-6ab515ec335a@ms29.hinet.net>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Oct 2025 10:23:35 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-HiNet-Brightmail: Spam
X-CMAE-Score: 100
X-CMAE-Analysis: v=2.4 cv=KMH5D0Fo c=0 sm=1 tr=0 ts=68f36aa8
	p=ggywIp0tIZrEgnU2bSAA:9 a=bms3psZGNEWHF9wUkq/6dA==:117 a=IkcTkHD0fZMA:10
	a=5KLPUuaC_9wA:10

Hi Linux-scsi,

I hope this message finds you well.

We are a diversified general trading company with multiple business streams=
 and affiliated sister companies. While our operations span various sectors=
, we currently have a strong focus on the resale of general machandise and =
services on several products to our partners and associates in the UAE and =
UK.

Having reviewed your website and product offerings, we are pleased to move =
forward with our first order. To proceed, we would like to align on the =
following key details:

-Minimum Order Quantity (MOQ)
-Delivery timelines
-Payment terms
-Potential for a long-term partnership

To facilitate this discussion and finalize next steps, we will be sharing a=
 Zoom meeting invitation shortly.

We look forward to your confirmation and the opportunity to build a =
mutually beneficial relationship.

Best regards,
Leo Viera
Purchasing Director
sales@igti.space
iGeneral Trading Co Ltd
igt.ae - igti.space
