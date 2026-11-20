Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186869;
	b=5HH/37OPoyDFjP75p8bajZ238E1B/wSn2mW5irpWZq65SJNnaxJZIXdln9Uc8N84rTlP
	 F2RU4+nyI6PhDxywAcldrvErcFraqJdkG0KGwEgvGJznjnbAK2VnOExGB2WWYryXFE2nk
	 yJQMqunk4yBa6++5VYmAD8teH4ZpcYoPd9WT7bf1WGCD8JMPxKxJeAv4fEYBTlwM+r2ZF
	 xvatXnzLei3UiNdd/LRK0M4d5wh2RjbvfB2MwJ+ZaVevjy90WyJ/vRJOHOxJtUHEFHUtw
	 MsdSWV49M4dKXp6kEUP1VO36WVJhVkV6WvMMGKY4ZnyID+y+uRlXO57pfgLptuEUcmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186869;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=L/5mAGH3aPwFpVY9BN4LZ1kZQhbM7xrsqE9PUw1UWjs=;
	b=tZJdGBxe9ExJKht6sTwNe8e2vhLCKL0S6YK2NPeAb7oyXffkPX0bn8FRanBo+fMhvvPX
	 OlTGFqa1/3jidXp5ZFGwL61ji7J+FtD5AlPyZ1BubGp3Uk/OsiUAlIlo3WHy/LAwy1syT
	 4WrdGG2GEtVE5BOjE0PVTN6VqLCMlFYdq1J6jh0UHmixiKlgNsTtJpcwiddn3JcpDS8Qy
	 C/yKYg2JZD1uH6taK3bCCTFv7HDPd9rxQk56EovWCenHQ3/s3HHgWCi796wsLMtO8i9WQ
	 UYZtlYchXHMf9OCkTDzT2o9O3B3MP9cMYXwAQ+4q3oqDnJtXl0vcYmo2ATLYkeUB23g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KAus31OG;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23E9606BC98
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B23E9606BC98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KAus31OG
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b421e8d111so577813a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186868; x=1795791668; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L/5mAGH3aPwFpVY9BN4LZ1kZQhbM7xrsqE9PUw1UWjs=;
        b=KAus31OGiJtgNAL+5jtXDvzZF46aa7xdd+zYHakqqAQlMcsa4bsxRLVTLfKoreU7H/
         TsBZqFvz/qvDslO8L/YcRM5bX2+q6wLeZrTmy1jHIzBe46CPefvhYE9RhlXJu+M/68Ik
         ULtvGlZyC9A3gpgz7SlTSWlN0Cn69YP6Ko6uUHgwVEEj8FBcmcGCWWtJeGuN1aD0zHa7
         E2R5/gt4YyK/NE0unG1APYiEVvmdhrLQVu7Zn+rCyPJo3j2rPGIxbpDoEmzeur0JLBOu
         yRIUntPZ8sKJ+KrUrLs/Z7gx24tBev7BZHdiLgu4wrZS/WvsLdx+XMs9AAAgtnucPisD
         S5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186868; x=1795791668;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/5mAGH3aPwFpVY9BN4LZ1kZQhbM7xrsqE9PUw1UWjs=;
        b=jUEMJZM35azQuZz7TK9ZpH3sMeUCis54aCD1k0ayfLFc6vvesZ9DBOLrEmPi7HVVPI
         d3zQMZ4mU8ex1/CsTs15DemGdHZHdWwVvXTt/t1xEPivgVuquxUVsWRBG8iRV2meSWF5
         GHPNrVcCrcd6osjcCTW5H1rOGxTURx2eeOVkI9k/TksJ1Y8EHRS6HUbKu1CtuVAYXBV/
         ENI8sTyCH/dg96LqawBvAhTJ1jp84/BhSmzWRJeAo+8agerzf80mhDZAWHERpiGXwLyv
         VPE5+aCQYyMCmlnq32Mw1IhWlvbjcwqa2E3+bYGqcG15HvzbO0p5VY+IHGpvlani2FFR
         8k6A==
X-Forwarded-Encrypted: i=1; AL+hErFHtMzMWGtQfZxYl8bxBQHDDYrYLoJfsw9mJyaGDcF4POasEyhu96PWmh6iDIplf8x7iYwxbCgJUBWd@vger.kernel.org
X-Gm-Message-State: APuU4Z/Rf5UddWsHcVhngIRNhAqowVJRjbL6JufTKzV256ZxuNPR7umM
	GLtTJWw7BLcUShzYunsIB05gIJFwbp9524VNU+4pLZM+MPQghUK/yV9ek9wQ0QPpTb0=
X-Gm-Gg: AZFdTZcF4Ek7jtQueglnagxXYjXGk0ohH6hJQWtMbYefJi8EJaiqeNi1wpUvo32BRvQ
	+VILL7BF+ZuvvSKyz8QqsC+WtijNEodc4CzKZ961g0btnMxRkvzSp4VlEJtxJ6zWLMnpJuhf3I8
	Qt4tZkUN5VTuT0yzLKdmtQCJL0jHVyC0WoEFNsYC8ScYRS7DZIjyGVPtc5VQjhanZg9jd8oq18G
	tjxhM81okC5aGvfQF6T3DDPPoOrG8+r4sj/Jw6dfgsvGT/VYAKrtwlhTEja5RQmQiT9vsTkxVcp
	Dwa8OBGpmOmFclS8ixyoU+gUbnP5pQZ6pZ7GOjdQg3Sa0ZQthG8SSnNe9HY8rfKY/UmDzoUAcIw
	ulddKLS15vOXeNngD2PZkByl+WIjpU73TMPohgW6o1ZOZbQm4DGa8Bky2gyTdMdCExflSZW2NeB
	MgeYNVzqnq6PEO8uW24uS819IsNrtjbWRxNDXFGu9uuFd+sZ1IZ+PRsgId+ZiBYehDWucor11F8
	j0F5fn0yU3ANqhvtiBOQVjCkbjXB8pcyqu4QLr9xytyxdTc7m5sjUglbFSYbndNqEkoROHSEg/Y
	N0rP5xhqCrCRf3u/EUbGeAi6bGGGjy0m8KMGSSVUOZ5YO6+IvMKqVGJBTmPcjwEU0IF2CvkKwaH
	Sy8qTlHQNyEo+5wvtI2qsz72cpsvo5NGHQwBn
X-Received: by 2002:a17:90b:39a7:b0:3b3:9ce9:f747 with SMTP id 98e67ed59e1d1-3b41c9b2d4fmr2978870a91.19.1795186867563;
        Fri, 20 Nov 2026 07:01:07 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d1361fsm7645554a91.6.2026.11.20.07.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:07 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] scsi: bfa: bound the unsolicited frame receive path
Date: Sat, 21 Nov 2026 00:01:02 +0900
Message-ID: <20261120150102.3128291-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
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

On Fri, Oct 16, 2026 at 05:28:15PM +0900, Yehyeong Lee wrote:
> Three fixes in the bfa unsolicited frame receive path. Together they close
> the length the path trusts, from where it enters to where it is used.

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
