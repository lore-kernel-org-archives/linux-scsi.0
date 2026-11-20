Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186842;
	b=fO4Y8HiuUFxMTq8/XD9WfsZF7rXzwWFWG9JakJKyOJ9cE09s9bCwb0bgCYZFccuWPVM5
	 a28iB7Sh5fiyNYvgqnNkBI5Wt4oHtYY/jb6KiGmX2iYOSFL41iK1GjlAleVCKZlmk20j6
	 LrB8DiNtcMQ3Oqvx8Iq2xQH+4Mjljy+GA9heAoPed3gjHLXSwuzWwgVR20p2y6SyMCiBa
	 6fwkQBEHYEOR3r4AzFcUqk1PT32InmqhMUjYD7CYL3/qaU7yQKahlANVvbu5gkM2+zSOx
	 vmOlVbjRrzsUTxm/hqmjTJuJaYoK/shd372jGrO3EG03s4g/Vn+qmDmlnVxexPzjrTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9M/YOMO9x/my0Rdh0CURVZWkEgZqlwEDWAQhtV+rWS0=;
	b=DD8jOOfPb+D4c5Kb6jG5YFCB119hZijkzDGsiiUck3XxbSlMGVRnGrLlhSOiq3XLdPyB
	 AnjdqbR1SqNcxkfcJd2wK595wBNk/4iRitr4neNJr/WiLkS3OGkXVyZsThq/vhI2emODN
	 jDa3J8HPfdZNf1Xd0dwPBJ/c50yO7FBETc0ogNdUsyxxgvUwZcSyvtGbRD0S4Ag4TmyXU
	 Cf0CLd9u1ilzJaSKU3rk+KLN7A4oDPYkpLt8NuvG4lvmYW6HS+xUpiuE7XFZL/CSCiGln
	 cCk61ObD5C2Zw3qiWfRvdwTaA+K7w3b5YRLyDjKzH3ZYVT6LhdZSw/41np0rRKq+ugA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hwExBKKe;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCB36074D1F
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BCB36074D1F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hwExBKKe
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso723299a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186841; x=1795791641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9M/YOMO9x/my0Rdh0CURVZWkEgZqlwEDWAQhtV+rWS0=;
        b=hwExBKKeDFUNolH3tey9lJmOhxRe9lP/LXNVo6v42Ou1ZYWgB0zSp4fYp+UwlT2q8R
         4g3yhemjCcccHdq0S4RhM0fZR2nLIWO+RSms+pEKTFJf45ZZIC6KkSSsUYlQTeysSq+y
         qWuP16+lcqV70heJVOkjzf5lI41MrJSlxN7X6qc28iNvpRgT+wKyDsJhDMF6GSN0RgaO
         meLkSDSupuh2EXBWw375NS831TDDsZBUn0DIRJOCI2z6MrnIEo9yttPxZ783OHB7WjIy
         jAvxGQj3eszobMEylS3beANdZBl11N5GxY0zqmHT0jKI6D6HuKaS+WyxBbZ7+KswQWTb
         RUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186841; x=1795791641;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9M/YOMO9x/my0Rdh0CURVZWkEgZqlwEDWAQhtV+rWS0=;
        b=c1fYpSp24DY3mEGHahG7Qy5TKf66QEZneUJffZtIbJ1sf0eUj/FoZpTXjyFqi4l6hx
         cE1+S0zNWIjTQG4+o42tPbdoFxKCGYL+hQBfIcZ8ZvsDX07YPMgB5ckPEah9NNYF1xgI
         PbVKosfS1hmQAgeV1M3wihaG02cKvuux8Yjob2RTC0xmeWa3UdsIFP2dTGXPF0Gz51XX
         7yl7TsBZ0fw3zGzcVvUHzY37T963P8e5kN79TnoRhXuIHp+zHHxPxzUWjnwE2s9aYxsk
         PTIUt9QTiG56K5UfHaGiTaW7aENyyaR7e8Vv4pV3t/ZlB+ExnYBMUv9ihhEfFBRyUCxz
         hDQA==
X-Forwarded-Encrypted: i=1; AL+hErHedL+jOrXqHNLDVrWUvEuaUjN34W1v4CjIzghI+cRVF40Xw+0hw6XML+uynR5ayTlSSR9lCNMaa8e+@vger.kernel.org
X-Gm-Message-State: APuU4Z8mUYFdEkV1e0O23fp/STXHriwBtGEHw17E+2d7srB4aHBLfI5V
	nezcrhXYHC15wKp3BF2odd5AAVDhaU4sK/15NV/j6oeHUVJErZ72nxFEhNzjLlWG9/s=
X-Gm-Gg: AZFdTZdT4AQmDGJdYgPh0U3UZErufdt+CskHeJ/1TkIhjz+Ewy2dLTQQGakhi7lmszV
	CsKhajlPkYEx38ZFe3huERFKv6DX0Lmq9Xf5p/9oSCWets36bGir8P3KDWLN0/B4WVzuWgR98xh
	GlZN5+CZ6j6cb0x1e0z5d1VOw89hH16K/9r0yICNd3CY4aArh8cyK+88Fx5qGMm4jEDaI1Uwy2q
	q5HMCmymLHwHa0Om2YvQH1E6Q0xW0ygTvQIsYrujRzuAZ7ujQK2h8lNYvRnyhU1RunULiYWd1lW
	WM0LZ0mGobbN2DBcuEVT13DOPTfiEo7h4clYUVc/qAvpo49pt+cFL5ZNgplQT/PabOac05ehr20
	em3HGPah69pGThPAIfio3gTnBsGu+RNKiO74RqDJmPRPzXqLW3OQspZ78bs3iISEfG4ZNA4Egvw
	gn00nqNWSHrvhgB2lCvZ5EKraSqnFTaYHgsyB1ISAnM59tYc6euWsyBXRnTtSlkHbondtTvH/NE
	x2+1Fuszooi1pvP5g9rTR8PZMs2hSBIx9tXxmReDQbpGrclWAzc2MtDB7fC3ueH9KEW+TCt1RYz
	wS35nm362ryRCzptxwQNO/Uimge8wKGrEXEhABxt6k+gErvbdD6aPOXzwYvWPnSIgR7sJlDDw8o
	7BW+lUZCYWRM16xRKEy+WeDHL8YziQ8JJZms9
X-Received: by 2002:a17:90b:3b52:b0:3ab:9c73:130 with SMTP id 98e67ed59e1d1-3b41c9e4b34mr3219603a91.33.1795186840711;
        Fri, 20 Nov 2026 07:00:40 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe23sm4652189a91.15.2026.11.20.07.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:40 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] scsi: mvumi: bound the values the firmware supplies
Date: Sat, 21 Nov 2026 00:00:36 +0900
Message-ID: <20261120150036.3128205-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 15, 2026 at 11:27:20AM +0900, Yehyeong Lee wrote:
> This supersedes

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
