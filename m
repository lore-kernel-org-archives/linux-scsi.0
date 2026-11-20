Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186751;
	b=B2i4XG0MacM6v48Cu/kjMs6aecdCDw0Z91N7MmNaeuGE0+6SJV3+xtBtiPEyO2N9sId6
	 i2sUN0WnSfjXWysx2oMBmGKcRQgGhMl6bs7zhArTmLq9mSzEqTbaBQ8gtysnU51HeyDEH
	 n0FHcYZqch291z9moGNkOZ0YBxhoW3aviOcShWas2S/3IOk3Syrzp7fQXZQAcTGleVa/x
	 tXnS0T3VeB2BkPqLlXB4xHApTuBZsf38ZT3vMR9Oj9OeEQqSV3b7VQhQi9VwjjJEOOFk2
	 8/7XdTdfAUcFBt6XOyL/gr+Dnbu30tbQdPEGfDMcoFwEoxCSovPEg56Mx6W8z6tge/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pMe2S28PksslU2TATwAXSQ7xt5SHC+8MLW5NfFejHd8=;
	b=d60QrzH67ETrOF5VRMicTJKKr6OVoDPcbq75lkoVQ5wTYeUJiXTM1HsRu8nSis9NvxnX
	 bRI0inwUHGtk43SjVKIG4rCAsWiAx/3F/+btrTaYzwEH6WdaoUwmruJzRhQVJEfpNbZP5
	 tVupMliAm1qMBD6WPAm+S8WEl7Gu9OPdOQuauR4+Ebt9Ia389s6pwhLWJvOF3dxckTylm
	 lK3yFS2d+jhZ9NYlCPiaSXtfqDkw+2jm08hpMYeWBqixrfFv4ytgtn0F26lCiHJ8HXbGN
	 fHAELdjMrJiXnFBiw5yPjLanpl0PVDmT0JKTTSBTut/8vsRd7bpuQQrYnhHf/KjnvBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C6v9ihqd;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860860A2615
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2860860A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C6v9ihqd
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f04e3bf46dso4431225ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186750; x=1795791550; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pMe2S28PksslU2TATwAXSQ7xt5SHC+8MLW5NfFejHd8=;
        b=C6v9ihqdT9v5rMTejN/oj4JCfpRVIyJYlpBGuA4jfdxOYpcEuR599DnDOtaf8US0+r
         m8zuIq3lUsM5l10wrfYVw9YIDqLRL5d0lFXI4BHmMV0Tf3RmYGcaroO2t1R+4S0nJTf3
         Xu+teZ87Q2dfhZTmgl2VpRySiOwfRmxcqCA9s3q5M/jxJ3TvdILUdvybKO7kxLd07ht2
         AOuTUP+tNWR/pveAo8LVPr1IpvbgZztVXn+DGvjSaUgY7Kv1t2+K5hx4tbLYyZpzGEIO
         1f6ZG4tKheJdPd5BofGkDcZz5ZFz2iOftsYRzW3LNmd4a8wTEJsLnkfL6Tz8Dd12rDZ0
         6o0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186750; x=1795791550;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMe2S28PksslU2TATwAXSQ7xt5SHC+8MLW5NfFejHd8=;
        b=Dhak0T07T/bG6RJ//5pEgrwqprqIrvnHT5hnz2TusvindXjScJh9Vo680g3aurt478
         0DZUdMDh7hIcX2yKXbohfl7aMEtB+WL7kue3VaiOIRe9ZDyhRgO8SsDroOYEQm0waiH5
         +l8nvFXK3YKX+20qzssFNRWm/t3EtjCo6swsfJz8tt3Iiizk8enl7ilIapIHUYTdtIG9
         sqPof4ZL24cJzdQzLDJ/e9YUvHGCyigajlZeIHM/awPfaw2BBk2XeYIN/Hhr8d3RagqH
         Xj7qOSh9I58A47TcYaPeb9REQ/+z4aMMKgzEa9LQSpMhdVW68CuUgsWDN2quDW55HDqv
         JQOg==
X-Forwarded-Encrypted: i=1; AL+hErFJVr03Ql2exD+Y/veH6MexrLMN2nWF2AWZn0iYHnhPgA3sM1jq3yMKulncoCcKIdMCsL/lFtTh4a2L@vger.kernel.org
X-Gm-Message-State: APuU4Z8GF1AQ+nDWhRoVqTP0fO0RUyFTyjqIuIAGxo8D2M941O7p72eS
	b36/6Ez32S4aSm88Xm7X/3tfd2Shoyt+mlmyjTYj6Xbdd7eH2Jnr4ugmEHp9ekVCW/aDR4AeC+y
	oT+4danA=
X-Gm-Gg: AZFdTZfOgHRVJcghe2zCUJ5NPdknuGtIA36VSI+uaH6sKGgpH0rw3X1JINPHHdRu4Vl
	IOsSJghGVXA3rPvXEe2bWlN6zXPTKc/b5ET9LlN+aSR3Yh2lVB4Hm7ZmSif5J9EpTAEzbP1LiVv
	Fj91khebpYUc8mrnGK0GjdRHp94t5c2rKd8oYiVAyqOPjbPnwALUeE5Zj1sLGZZFDKL6jxuaHPx
	m7F1m8MoW0BF+6tMpofx5KbERWzpQQ5f3Vq8XYQKXPnp7XFNNueFYK7e3Ultkjl3hb+AuhRQUx6
	6M/mn13cMsOg0wOgXtcZPycf4A3xEhnSnfOcMXU/Pbzk9x/e8vHiGmdxSEqBCX7cpypw9EAHG1s
	8RcV5bhJ1MqEA2bl16L5r45t0GISXJcodzj/2VRehSBjzKEA1a8NBFrT5RlV4jahNd666KQdL6N
	Ylw4qV4hSlmggHQ+U37sUENS0CY2N7OR3WN/ypVIs5D2qzgpSQTUpCeM4rQ7VkDpWj28MREIOF2
	YTOTB8ULqfDQGms0BuQ9RRhu4wMqbOL32THstxvD9uGcFkRn+/qrdih8YlV9nENqkTyj2v/IBDf
	FIQ4t7rfpYP3zPyffMtVjByXJ5+VX1npj38hxtq6UmTi7xcuuLz8WvVGLsEok8yU5KL+TZlSLx2
	vkRQMLqnNg2TPn3J8qPue5rX7MlhkOKJZvRH8
X-Received: by 2002:a17:903:2285:b0:2f0:41c7:9a40 with SMTP id d9443c01a7336-2f041c7b268mr32731505ad.4.1795186750654;
        Fri, 20 Nov 2026 06:59:10 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84364sm16171165ad.5.2026.11.20.06.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:10 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] scsi: libiscsi_tcp: zero the unsent part of a short read
Date: Fri, 20 Nov 2026 23:59:05 +0900
Message-ID: <20261120145905.3127833-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
References: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 08, 2026 at 01:01:29PM +0900, Yehyeong Lee wrote:
> A target can finish a read without sending the data.  iscsi_tcp_data_in()
> bounds each Data-In PDU against the command buffer but never adds them up,
> so a completion that declares no underflow is believed and the command
> ends with DID_OK.  The pages keep whatever they held.

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
