Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186782;
	b=eAmzYCqFZCM7ZFILT0QGgvLSpttBd7HaQMpTqeBm1oviFIasKOtzN9zt5PmSyKY7QU70
	 gg5a7r8In8i9Keq36CNnEAkzA86IJgd2FWsklmJ8k8Ery6+BubgNg5aqyr7EQGRoKpskn
	 p4zJoouErbovuUx73DaQ762fSIcSLcFbxkUqsjF3xzesYFdKONFOiFZdZYNgmESD4C3lM
	 hWVYFnKJnj297bMIylsPrRxDiVMSK0dAxN8XecSS5wIfj1Lk0kYo7dLbUYVN8Q3iM9QCH
	 Klf0R6g8A1PNDu2NRYDdXsLTv+EMAgEr3+E4WzmBDqwghO+zRVubwEJQL6EF711Og1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186782;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NPBcu9gG2nBjvQprQjdUT03YAkNr0CT+CriE3SaJLQQ=;
	b=3wCKZTzOrjZQWCCtRxKkXSMecLL/Acpu3uKsiE6XBqiQj4U4ugsYMtqjzu7Ht6iJlLsb
	 3EfLwQY2tR2zBPxzSbt5uj6myCG1Z+rBr+w6/t5o2jqYaqzTje7UVGlEanFjQQRR+Jwzb
	 WeSBs77D+9riyY0i+rvWS/ngqd52aq4tXTPoxkS0cO9VJ1X/qyU0pTr1KtsX3aznBpqdK
	 JkdUfEDsD4kt6TU7PnGWJxjo6LLPdlxkl0d2OsZJ//4hBYDT22pZl9F8CpDePbY7DM2KY
	 8u86iF1GWF/0+DiubDH9HvfrFITj901tOAi0Ns3odZzJrT+ZdehoVux9R8GaMY0O7BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="Fq/74hVy";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA146074D18
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAA146074D18
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Fq/74hVy
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so456213a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186781; x=1795791581; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NPBcu9gG2nBjvQprQjdUT03YAkNr0CT+CriE3SaJLQQ=;
        b=Fq/74hVy1H5DfMJeJdAJf9Yme6F3FwG+c+NGx8aZO6aEjIacj3quu0sOLtOBtXKFpM
         /t6i9RIgcI6A1LqziVasuGIXOUfLauW/16YJ6GpxubhW4PQzlHtmyoMa6JQy+tvo5p3z
         kmxr/GqAqQge/pdhL0tGcsmJqMk0t1s3DnVWs3QwWUq9gwyD9u7htr7wYm3OBW0dlaTV
         Kj8cNZhkUs8zshB6iF7LsT+b94w2JgZHoE0a+R34tagG7oN9e/aJupOnekBBkL5Fo9/g
         vZWRuSm9tK8iZ8CwYOAQ4yVU8b8/hOLdOhrK6GNMYVPJ3l9de5bi1HKfy/gn0n9pUAp0
         8RDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186781; x=1795791581;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPBcu9gG2nBjvQprQjdUT03YAkNr0CT+CriE3SaJLQQ=;
        b=Tk/djPI+VBLwy+hWeD81CDARwenhtc3b3vuoxd/3M9afdLWSgxRnMby5Zl7VdCH0RY
         XQ5a7TIQPmCl3KJQl5o9SD08HS/bRfLtoyVgTI4KvRC+3rOlL7YtHWFsQw5BvmKCvfE1
         LWXgvk5G2fBrvGJWQmiAz8xUl+7W/uGrOc8d+dxUE50eOVx9oGyh3wYTqwHjahR0YDbF
         Pwrvbz7F4xi/xvAFTST6zUyNaZahxSrwpJGCWMcrlGD99luvBRe825bD/AEDXzK/FKnQ
         d10pBdTRmmL5fq8sRzlOIaulsjYbrK4Yuyl4F7pF5LvSgHNbcH9C4ECs1hDQXZgROOMK
         sPxA==
X-Forwarded-Encrypted: i=1; AL+hErG8F0Sw/flv9CUYioPDuaIdjGW02jl7JNpeGaKv5SKw+pM0lIhwooio0kgrCM78TMETCdfe+6CN7+KY@vger.kernel.org
X-Gm-Message-State: APuU4Z+e0x3gUHwHi7bMoY50rTu9K/41O3Ys/Sm6/ryw9wk2EMt+/bqr
	28habOJrpvsEoOHCcO3QWbCfoXt+PJwCmjk9xZJs37P6aOHtyiT1zEnImj9RsQ/V7nQ=
X-Gm-Gg: AZFdTZcUDQilQA8iNGOqT5TI/LaPjzktb8ZFL8bqZzTok/bowSlUuORFsFYuOiXufWM
	X/vLO5XKR/U3WSPl6BjyUw2ToBrV9UK1RMBGIe4BBVAKc3uveDOFuMS1/ZPd6Xy1cFasPuDVIpX
	P/yJNjObT9v5skSQffxFpfFy77NqpWVks+L8JigGJpylzfuliD15o780kRrBSV8RnIhPYf2+PEG
	0/LJWQqx4UBBUPrNrVx+3j9/ubpLVhLVLe/2XBVj/GDeLW7vxmuVrJQE15VfPi/WOdhdFKXbW1/
	/kk9uF52IpFI5btOApY1BosaOnUhO+YvCVtVZ+S4xTu0RDE8HAfjGIdQ/0Ssb/e80dBzT2/BVWU
	BPxEjV/PMO2kfKkgRVmGopV5CafEBO4ir6ib0dhmZsvTD7q8odPIRZBOuxmDkpWJlpY8c8V0A06
	b1mK3JL66zRffROBre1TvdxzYIxuy4PTMp6h7Ukn/6YXwd4pAlTyjbgori49aZQ1FBlKANVGUYt
	CuIvQuMp4C5aJaHnjkiWVJGBguEt3XHAW5i9Dvmm7qgBnx7mFssdYVC+OlwymeuV3d3R1hjkp1v
	0tRN8wLxPpadkxjECwOuvdOHSOwUMdOndQ574uftLXXnbknkPfZbWGEqXyrCz358EWwcMaI0jaf
	Z5zXG2CxY0zZK3DYeKEcXURmzLqLVpyRMxbE7
X-Received: by 2002:a17:90b:2d88:b0:3b4:e6e:1aba with SMTP id 98e67ed59e1d1-3b41c96fdacmr3133157a91.59.1795186781357;
        Fri, 20 Nov 2026 06:59:41 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d63728sm8364718a91.8.2026.11.20.06.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:41 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thenzl@redhat.com
Subject: Re: [PATCH v2 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Fri, 20 Nov 2026 23:59:36 +0900
Message-ID: <20261120145936.3127939-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
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

On Mon, Oct 12, 2026 at 06:01:45PM +0900, Yehyeong Lee wrote:
> The arcmsr completion and message paths take several values straight
> from the DMA area the adapter writes -- a completion slot number, a
> type B completion-ring index, and an inbound message length -- and use
> them as array subscripts or copy lengths without checking them against
> [...]

This is superseded by v4:
  https://lore.kernel.org/all/20261114033810.549787-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
