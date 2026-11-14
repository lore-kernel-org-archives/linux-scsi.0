Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627617;
	b=JSatOsJqPCaX2gT+BAdxdbyuJLlVwKddS52SR3f2QPZ/9yO4FmMZbm4pH0hk0SThLoL8
	 vHd+jzWbEoIHYxF4+BrQmCg+/KdT5/xeD/g2G1cC/bC+hZ7QHQLpx4u5vsxqO4ZUFveAV
	 P+kh128mF1Zpai3cjl68uWDQhve19eze6XGGKaLwKXskhlwS/AOHwwauDe3NWLa2PoUNm
	 LTTVAUqw72XGUCX5Caw0PCAx4/qgHER40+NT7k35AYa5V2Dg6GVD082rf2Tz16NZ0QkKE
	 1dNkYEm/MPZDRb+x0WXLj/PgqTStlaS06vJqEJ8ZVfIjqPDkW6gslk/GEN57Cbowv6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627617;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=E/QJ/KMx5WyVj2J4TdNqaAQXU0rL7hIGOlDe9g33IzE=;
	b=YJOtfDtUcod6yFLIh540G5ApJ9+BMKAtDIiy1aTdqDiOcgfKca63MAnFf8Iub91vW56w
	 Q7G3/hK1NuleV5OAwl/IM/lI4mm6qfAH/LvZrSCCf5FLu9aa4r6Tk0stsTVR0gWTngqNT
	 uo5WNuDwUKbcMPoKNDOaeLHBe16mJrbjKj9noVDRQcmtso33h8EzYul+8d0VwrEGga0S7
	 ScAjg5npKa6zCXG06cAa0f8qxi/e3ymfAmNTNtYmA1orVF1jxZOuDU79C+fBUdw3C/ny+
	 3nPRek33sR7DmM/LLpti+ML5xFOmLlolQDWsmIXknX4DRIZipVMuOcLNf8IAUcSLlFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Swbm8bhZ;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC02606A32D
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FC02606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Swbm8bhZ
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so718768b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 19:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794627617; x=1795232417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E/QJ/KMx5WyVj2J4TdNqaAQXU0rL7hIGOlDe9g33IzE=;
        b=Swbm8bhZoLVt463haIQp+R3/P1wcnkOFskVWDfwhp0AZfE6Lxuem+EtPdpusnoeQH/
         8UoqDEMI0SE7yJDpFCdUfDgFebiZL4vQMVax+1ZFiCivI9JJUgP6SYwRueJ4F/i2roat
         jsOhxPQ5dkrwm8pm87hdstcKmZPXz3MRilSiLkAQlC2529WYAKjtDkdkT9zeLd52WX8I
         QA18p6gOIHq32OxypSxxTV8xkTYdzzuTLFKeiBURfrVblVnDKJ7T8dG/eIerAe8d3Ziu
         568M9oQF/MXiyFbArVgE/fl39OQELrkco+txj1RRz+5YiBOiBrmwNy28OQOQzGEISnNP
         mp0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794627617; x=1795232417;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E/QJ/KMx5WyVj2J4TdNqaAQXU0rL7hIGOlDe9g33IzE=;
        b=2xLa5cuO+I+BXcp/5dum+3hfxMUzQEY8ZcUa136A0k1jLJVv34rfRdgiIgZFl0s7fv
         FGPCcSeV7B6+xz6ScvmZ9nPkZydgSN0qq1g7yWcgfk9MRFjG9AQLD5NubPCPwhKdiKpv
         qIpiUxpVT5XtMlOiGEXQNFKN+uXWTLYGMLS73AMNrO69u81fgHst1Ray3x1RA5Lfy2gl
         fun+5TJ1M0nN8AACVrRKcjRK08NGnBEyLLF+4nBERclyfq1KfyCsuJOqYgG+csYPPN2k
         sldFrl+aKpJmWr65Re5jG3W+cCEM56YwjOz+MXTovMg3xG9LTcN+Lx8o8GX3vO3BKzcD
         Crtg==
X-Gm-Message-State: APuU4Z8RHtges7cpWTehNPmiAIv38/SqPBtHrcG0wMSIYHSsv0rom4M9
	8B69J4BKJCla9KyDS9GtKgdgwoFEYFDZDdNlpuKxZUkiBv6V6+x2Ge/YS+dGqwXYHbQ=
X-Gm-Gg: AYBFou2oVHinMnceqd+VjXcV/j83AmpjPIWJf2WQD2APjtLFWmG8hBm1z9Kuo9+mAsW
	1IJ5ESYdBXziXKc435MCAPOqalNAAMHeAgILokt8RvgrPgR3CgunyQvnOGWDc5KGuZrqqSRxqaW
	Ozs3hI1w8oJH+5XM0ckc4vS0kkMb62/Z4bWFV8WHjZCFKghRgUbZe6r9fCLvdqFlKCMWMscLg0Q
	2yTRT/QlAyXppm4463SOW60cZpEIE1WO23iAFgxAdavDicDF0Gv1RlnVEV560nI7jFgPX4pbS1p
	89MYQkYIBz5z34Ua5pppLw9gIbO/3VdjBJkvZtkup0qt587ENP0OGYUtOAJxznYSJ70cO62UvZ/
	jA1nJV1fn5CN9U0/9wvJcSPdsw94M/V9svvBfOEHUhAJk8vtSAgnm/EqulZfPT4VJzdEz/xt4Ai
	T27ljgqUQxnVZt50T56xsaoVv2dVHDZX0LSqNSz2wisVVmj6Xea7Al5y8HZq6z2wFusrIYtvGX3
	4iQRvoehD3zEO4f1hRXe7ySISC4FhpMAG1eXt9SYkwlRMBD7ec2fGapK8qav3Ex72kNY2y+V+u/
	mkPx8IAIOvFdkArNcOOAhnzAiZfUc8iLmV2pQo70cogol2LntecULSJ3LNAuzme5SG8JU/PrXRh
	3qPFYOtSAZAie0Rk46RdDjSHvzFx0ENJkBtIbwQ==
X-Received: by 2002:a05:6a00:1995:b0:8b6:d2f:72ae with SMTP id d2e1a72fcca58-8beb53d9ea2mr4567673b3a.18.1794627616742;
        Fri, 13 Nov 2026 19:40:16 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed263b648sm1705244b3a.46.2026.11.13.19.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 19:40:15 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	erich@areca.com.tw,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Sat, 14 Nov 2026 12:40:02 +0900
Message-ID: <20261114034002.549899-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
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

This is superseded by v4:

  https://lore.kernel.org/all/20261114033810.549787-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
