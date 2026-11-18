Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036591;
	b=bPs7ck+lFN7FKwQz1iQbuEk9/pHDJouykgeJGe+281H3qKadkZafWH5VAivQwXiF0mW5
	 s3O89eUJhwC33aVQe0UQF1KcwNDSHRhsT9dQPNlsJ0FzRmabAXG/gR1LEmM+GySn/f4LX
	 L9tCEVJdDRJZjZJubZqozU2G63ElvGIzLU9Lakcr7OXKvTBT1sb5lafQ68zxYiHgLBX8u
	 xmxjZ77MzSTJGWCBsHVjddu632ZQgld1oaCiNEL0MUhDcRHosPzxS+LrzKP4gfwZ/raLG
	 J3ifDCawcK10/1f/0Yaz7UFQpRCSdW2dywhGrFTC3gjYqgRLMfFEYCeAHRmlzLH/Ahw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
	b=EGecChzH1LU0GAz8uAxb4gvVwO39ocxdfO2J78/eMwOiFrQ3N1l35kzLBcmLpHDMmHPS
	 KrhgL8koJqYUj7IVPSmhkNdLOjS8Ky+PDq8oy4yX2tTbUa0NeI4ZrTbymomjNZ++KOgBJ
	 idMGDOB0oY31cZaZd2zMWzE4FuuZKQEFmTu7FxEAANykd+dtsZ2xT6ZitPejC2avU3jKm
	 Qyy+44hhKIxCTOQl6n+3AUosGDFiqf4Xibnm2/EbIXpA/AOc3hmdUTn85eXJoPExdMDA7
	 v/VU7oIV9DqsB69QRtgn4gN/K55vp8O9sd7wJtiDYkntfyQg6Rr2J+6u11+R7dRO6xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BC606A33B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 21:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A1BC606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b3c9820789so911576a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 13:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036591; x=1795641391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=tAKIDOonM/7tAl+OKNOFPyXrRjlTvzxrmWiMXNZVhliT++H88DRZp4VsIUQSlAau47
         6Spe9kGkx/9/L36JcBVgrovt+2ZIS4Cr6mD4O+TqZXkb+Fs8d3BHkVFjNRYauw6KUOLW
         pdZMZkVm1dlo/rRzE7QAqZrltbbI/Gm+XgjCCSuf3kb6HHmDw61HbQhBPAfAaLim7kcd
         KHhTUjMGyljf1cYXetfpnx+xFF8C6Hzq5WQIa6scbKxA9JGH3dzX3M6mnJbWax5CbQgl
         rVV82iAcZE4+QNEKxL/Fr+9TjwXagcNwTZIGgDnvPrebuhix9W35IoBv55MqzEQgj6nh
         xwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036591; x=1795641391;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=t0pjJth7WYvpq+HrlNqip5N3sM+TmJq5o/itINjgEPJm7WbWGIPPEPBMrBEnHkeuEh
         kI48OP5TIRoUvmcjdRjoNzeEiM8ijAaaB1vrYdqQEJSRByYLHsM9EhQbQ1SyMn2NW/nf
         u6rXyDCKwQLaNiGZDX7baBFFZV7NEFW/GEJ21KBBQaa9DsVcRzzN8JwQq8J6Gl4f2V8Z
         VyzvIjWTc3KQZCCNA5Az8FKHWxJGJfZYRU13Wt0lkctY1o6SNsyVxt1V8AnTkYl8VvEu
         2vUOCxESOBScpZu+64cMfFJ+8qcunnWjWSCPEvf3gn4UfSAGO3rx7zhB+PARciEM11OQ
         nAzw==
X-Forwarded-Encrypted: i=1; AL+hErHJw3J7fEvW8Ssq0Yu3r1SocHRqhQoqCvYULzJ14w7cjNAJJbov+rTwOz6GenKe3Z+KTLkGeOndTIoZ@vger.kernel.org
X-Gm-Message-State: APuU4Z+IcE4SN7+fGSEPsyte756oJJmv1tXQAxs+uVlg+JV0ofbC0J2o
	rITz7oeaLksQFHEheaG9MvYD0onpi7r6t7DTPdSi3SWLIPCdCqXLR429azl3/Uly98Y=
X-Gm-Gg: AZFdTZeixKoGGAdEBrm38YvyY4Q9Vu4W2p1J3YofrdApnXx5lKMmXPHM4SHc+VyieN3
	so5Td5Rw8O5ETuXYhqFHxHqbGxcBRWNC7eB+BnFuLXzAQ5KU5d+o2Kbwix6Ijs1IoGnHLzc7bF3
	f9UKddq+N+29bpFKhY3NrYk3QGhMCE/wl8yfpdQYQSAUFDid4zPi0B0+1BTWyHnnBTUpyHFDAkb
	l2PcGloU8Y6sNiThmmfiuIbJ/mf/L/quANQgcjvhBJHn6HtyHK5GUueGXriufnvPYBAX6+DhrCm
	Ps/T0iKNLMon5nAaWPjKL8eXI1FOdTwwjDItOvg6Hhm23FmLuPrTvXYlqBSBLOzw7MfdMshZH8j
	xfYjs+WZBbzho/fTrTmLneAe1aSWdIBcgS6pHZdAVv0Ey/fqn3SyyFpSvC8e1K3VM+9CNzx+51W
	SvxGUaf43hbNqWxzMEeofX6M2qpKxNJuouxOA5nrAxqQ0FCxDf3FAvDyPX6SSrdnmBhlTZF47bN
	dsm1e81eA7Q7yvytXwlUGJUhyPi3z5+YTy+Tq0OoFUcAlsXQ2k6OlY3qVQAwiYeYf3WzN20d8ff
	CoPXA1oCpJv4hh8WsBvVJHmNuQfcTkbuaavtqpi7KtK9sCsdDSmZCcotp3Sz4tZy4MLGZf8tN1p
	cHfqy1oc/DkLwPmhReOgyfaBu2p7aasapY36fHw==
X-Received: by 2002:a17:90b:5307:b0:3a8:545a:9e87 with SMTP id 98e67ed59e1d1-3b3d0759881mr3709135a91.15.1795036590739;
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f706dd83sm914903a91.14.2026.11.18.13.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 06:16:23 +0900
Message-ID: <20261118211623.2526894-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v3:
  https://lore.kernel.org/all/20261118211503.2526705-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
