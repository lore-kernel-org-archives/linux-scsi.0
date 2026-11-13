Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567926;
	b=GuTQPQtwKMftIdQY3DJWVEq8uNt15JBdD82SNEC1ZvjXFdEWjUg5RWk6LL04cEg/yhH+
	 6sn9tvFuWqo9S7K+JQ6BQdfWEUSjrsjqcM4gQa46rdPEjojYcwKyJrp5Q2l63VOYuqpcP
	 6GIn+AL+KwPW58zvgLU7Cj2rQ8BeuFY0KKWByjzNnMx83MdSA8n1aXUAU7smcI3xHQsjC
	 Bkb+E3B20IovrfLFwjjtk+9h4CeX2vfAEVS/nF2bh1FcKRpvQAXXZvYQGkwlWMIBoZx5D
	 BiLNXo7ZOgEFXUylZBdG6gyQmB5pn41ynA6aiTR9jsI9c0O/DDeSSk3ERmUGSxTNNRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xRGKkjeOSqGcAp5GlRiWRSP+3SQ9eykn8zcI3aD1Tfs=;
	b=Wx33ruu5re/Bg9IMj/yc9K/iA8vQ5OZyPXgdYPcMAusbqZ/uzSQjM0kIhvZv2qSaIgLt
	 RfQi8/2Z2WY9sShuQfPHQ25s1DEqUeWKG9uHvcXI9jV7W5CDM6j5rJcP4Ua88804+UFpU
	 9r9ePbUHdrCpE4li+bCsvXNMpFbMPIDGwGoM17cUiLXAKSexpngT0jhRJaeTTr2CqnDAJ
	 uF3psrnFVIWmupuHwRW8pE1/3jKb8ABqYQA3Tw//cUO2DciEauWnpOeKVL8XRB36qOiGe
	 SD8yapltaCoOj/Bw3wsY+HML8bj+ca7H1vJes6mcmatTVRUkBZObA8d9FUD9FMagA1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kLPWmVAw;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74742606A32E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74742606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kLPWmVAw
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3791619605cso1756771eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 03:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794567925; x=1795172725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xRGKkjeOSqGcAp5GlRiWRSP+3SQ9eykn8zcI3aD1Tfs=;
        b=kLPWmVAwBLnXC4fO18rxl2C1rfM+F9LVv0lB8MIzPOD3yECFfO6qPjIJLMysl1OPKY
         mYWEA9bBLKPPPfUkxOOJhm2+V2YofnCtu6qh1M08XN248lenH/sbNmSBG1SWGMkrd4Af
         Q+mOQfagGr/OLQM1lJ1yGeGtGGwlc1lIZ4mWder3EYbKmwWpPK4Sv/kofKZP9llFGrLu
         VOXf+e4UW+wcsR6lBWKkXwiPfEJcNA5maL+6wJjkhfdE5Mrz8WqkA/OTYgJ2sA/2aXza
         lCh7lGfE98GrAV0SfMjlbL6zhAkV23iv59bkGUAFKPi2JoHGBUNL9hyXkY/e6lIghd+p
         qrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794567925; x=1795172725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xRGKkjeOSqGcAp5GlRiWRSP+3SQ9eykn8zcI3aD1Tfs=;
        b=unswFbmYEN4YI6X+uBEnt6w2for2fs80vml2Y/xZzXA0uroG4zRzc6Se+g2VJ7MzJi
         gKt5dSXctgd5b86MjjP5K/pXoQ1uAaf14HrLMjw7K6rBVKEKYTJJC0iBEZrWOqGDOF1K
         1eUPBRcRdUOGtRuEvVY2DaaGQGRbEISjKhjYglREDRtdvQ48ONPs60yw89bX7Bmj3WI+
         /L+a7Q1iNQBXe96twpqjVsH4ne6kashNWY4ksKxRTMOvLtGyXUTs1R4FZgXcAkYR3z4D
         4BAm2lO0mr9IGhSK5NT8QzVddZMo27EPiXzLsRkw2xrggmnetGA55hYQnY1f2c15qGlI
         gggw==
X-Forwarded-Encrypted: i=1; AL+hErEFrSnhle/YaHHLbZtWgVVquhgKuDjaSpi9iZVGpXrCkusf2Ho6jlRzrvghpKMyk444RwMjOq2tN8NA@vger.kernel.org
X-Gm-Message-State: APuU4Z9lbCm/07puseXR6NhAvafkPXu/GVDBMVFINgZ2YqnTPS9+Jd1x
	nCoAiZS52RKOjAh6tVhYHbiAyarV2uEVMjZGEX7mrJ61GoUoLOsYi339I1pkv0f6Jm0=
X-Gm-Gg: AYBFou1+jNCZQ3Bp8jp+oSXGSZD3QOzcPEguU0X0E/1zXDr5qmun/VSPuctgaJ249Xf
	Kz8OKGdWP1jKbfTw3Lt76JHZEhW/9Nn8/83iCPitk9zg+gxqOKr9ylN5mRkmeg2Ajd/CjB1PFL0
	VHEbWMhIFhp8U5Ong8Jb8yRE04eb7TgtRdw3R1hboL2PAjlCF2PLChRmYlxbIHojHiczyBOn/3q
	ZRcTJKT53ysgjlYrr+7M8hXbzAzsqqL4Lpmi/c64daUU30KHXE3S3MrBKKUWhtvT9pi3UBgOMnZ
	rMf3C2hmh9FIAjVwEOA65LOb5tBYrq6/PMKvPfTwfL9nk5QbYQIv/E/tW0jOL9CRP+9whxowDDr
	iZ/hxO/odmst5NMgOHRhwMKjKUDMSHu3iXpqSlEsoEsuI0f7xqHZ7OT5ckrbQ6k9BXAljTKVqmt
	v2aIKy7B5+4KH2EDXC3cqEfzVowBnX2xAd0fcS71HROBX0OtDOs72sU1zHr4uc8vZb5p0shn2Mw
	9HgOr8HU90GBlpxuzJqCwj8gJqPM5flogYJNXEeZa1tK6T+TWZxDBnjgnsoixd5Thw1u++78G0C
	gioOyhF34nUshIBYDUPmPZm6Ui58FBas9327V/TkjE7bpRX2M2K82Zr4aEcf4B3YIDlqjDHn2Wu
	WCAxHY/jJxzlKQIYqc2HXY9AG5tzC4Qqmv3iDfw==
X-Received: by 2002:a05:693c:2808:b0:36d:f004:ae6e with SMTP id 5a478bee46e88-3796721cff0mr1863856eec.34.1794567925307;
        Fri, 13 Nov 2026 03:05:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7e8c:590a:782b:a57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379565d3e37sm7110033eec.24.2026.11.13.03.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:05:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: jgross@suse.com
Cc: sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] xen/scsiback: unbind the IRQ before draining in-flight requests
Date: Fri, 13 Nov 2026 20:05:15 +0900
Message-ID: <20261113110515.147043-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <353a0b62-0396-48c4-9e5d-fae5351d6abd@suse.com>
References: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr> <353a0b62-0396-48c4-9e5d-fae5351d6abd@suse.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 11, 2026 at 08:58:51AM +0100, Juergen Gross wrote:
> Reviewed-by: Juergen Gross <jgross@suse.com>

Thanks, Juergen.  v2 changes the code after the Sashiko report: it now
disables the IRQ before the drain and unbinds it only after the drain,
so I did not carry your Reviewed-by over:

https://lore.kernel.org/all/20261113110036.146860-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
