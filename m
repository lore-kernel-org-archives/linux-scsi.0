Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175045;
	b=ISOzj5RqB/YO7reKLQdkJTJs6dOwcWowaCPcuzuMVgVa/PgBCfvU00ByW+1ROOdKEQO5
	 VCQPdCt5PWAFiNNZbkT7HOnJwTxkUA/vKaqw/o13eZ/Kn4NL7yDe8ZQEB4kEfxbhzQnL1
	 MQRbl4HPi/3qRTMrESGDAyCvfksVrDzU2V+nmAzBTgdG2LLeeCA0DEXww0ae/a4qDJiHE
	 B/oJwgqTJubxh6g0lR1oIz4v+QSm2kYBvsig2kPetuSzlZSp7BjofNr8YTMGTnDagaA0B
	 4yPIvA4/9wshS7hxI/HZ0uRZRNi9c6C4/1z54ZU1I8W/won2hrPKALuR6ld7efwoOwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=HxLb8gZJ656Ot6lu9jvT7Dfyz2S4sn44TBsJ9Fqq2GebjyCgv8BiARRGJmzwlkGqKSZ8
	 ODXBuXqWB7HnZ+p1u1ugGS80xHrmkjOoufplOZgJgxAuq2eL3HZCSL8oUdc/NTw5gAC2g
	 9T6o1Sm36yDTm0Z9pWSQcuBa0LNUr3Cr5oy2y6vmtaHqgNV/g7fPHLkzTr2MLvZERDAOj
	 378rQHC5eQStcQ4dCgxWuESwwOemLzcQrpkSdkYFIKqOn1d2W9MSGYF4K98xukJMu+uIn
	 SmadhMYfrQwdmhjDxUphLfx2XiRCUBWTcsxFGuikjhpDDnaBHRIylAeSo7OZjNQAAsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FMND5e4l;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54CB60A2608
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B54CB60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FMND5e4l
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f020d0169eso3935825ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175044; x=1795779844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=FMND5e4levyrV54M2W3Z9b0/63Cp1Z8LA7LFKzpOOikoEbWZWBnk3tpTes+MF4OBOy
         A2GhBQGBV9kngsnIfLRoK4+pg/VbGFEkta7pugBMIHT0Uja1J+0kLkxGpcYZv8zGMAuO
         ZnBbIPmEscyssW4ct7v8oVRaUmcZykVH4SkeNdQsFeGS76VVRwt3/Ljnsxp0kFyy96c2
         JaionjPkQOIslL7/vW6vpfXrhaBghErnswxg3V9MwITUr7moREBIzW21wSehfP0pDLMi
         GCZ5q87WRxfBK7dkoXsrzLNWliyxmldyMGUNdI1pDgcpRhDg/PYRUqe+E/KK53DFnXY5
         gbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175044; x=1795779844;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=gWyrFaLRR4/cuKFwfgzwAyigFCvoBN7DGTNCw6xtr7f0ekmK/t6nJWLyymHPqSgCTv
         AnQaWnhqfZs4RHML32uvFfHSOabQ88g4lW/caakKir7WcA08NQL+iNN6KhLEEa+6cPPo
         116zUh0rgwESOMI0LWygmi1RX1WsUfO5OLdvqW6lXkfTYOSmZ705L3H07rN389ZHlr44
         fU8BL6FJbnRjN63fVoigFkeo5I3TmlZjglsuvgX4PFRmrMoXFF2mIAPlltGYX/fDw5wG
         bWM5JSCkVS0UnMQmALPexJYvIY7GicokPrIio1Cao9PFvfz4jCATTU05Z5qOKLzWH8oI
         28rQ==
X-Forwarded-Encrypted: i=1; AL+hErEc7z7uC/4IyyFx9SQoD9RCsFaTYi9g22n+QNWkocPRBk2b95aWTF0MB0bprCatGS9ajMtk1jcQOE4e@vger.kernel.org
X-Gm-Message-State: APuU4Z/XNGdJk7fhQIMSRIxig5TC+Tamx2h/L1q17LmjVNrD/2o/hW3n
	jxF16rd9N2OlFKWoa59qAtcq7Wu3LYT283G/5tnFS0JBDecs5WP4U+ZxDc7KRKcUhOc=
X-Gm-Gg: AZFdTZeGuIiu/HgApjGLPj3yViu8pNZOtTg/ibkVlVYNT7ijAdLrwGw1my44/YtxhUS
	F1rleMl6mYJOs18MQ6K+JzRaKA81kp9ZU1Vrq353h031oNo3a7lOG/azznDH7IOzFp57SWc7Qll
	k7mU2FslCia9MGZhcZV0E6bO0w57gku/5IYOFeL6j17Qq+SxD4qFlv95raPi5gK/StJyfPyCT6k
	pqt6wjaWXFdm0gnpJuEiSYVDxeYs7bVD61l5Y+H0DullLrz7K332KFuh8ea2Zex0g+XCj+12ORp
	ibHmqkLdW1mVinJAKKEBtfjrB08Nciq4fPzGtmldbphS7rMI1VxEdy2pqhPlQgnFldPFZEOV3JW
	0yWpnk9Ps0hDP7vCeNE9Vh3A4sqNyT0thWJ0zYv8y8LGCGshQy8AGjESXpWZ/6Ng7Hs9Ahap8S+
	R6UrjmgRUer5KKVxQbrjhZjp/l1xJ66DjohpCh3AiJo8Eq29W4C9czomlN8Lmqi26TPB2xCO+7x
	I/OH5KPhwZTy3ytK2pUtxMryvhzbh+tMzXLXxAWfDa9DzZ+aRAXTwSMiInzqVdgh8rj6Fjl9+Ht
	qCvIxMQ8YbmvpswQkGQdgpukwWgeV02wjICATGTC+vxL2MZVi8K/d89KRQ0pnCueTl33KdMoU/n
	v7cCKRyFHYbpedKCvD2aSzpxRPHF+BmIm+Xsp
X-Received: by 2002:a17:90b:48d1:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3b41c95b41cmr2537860a91.57.1795175044059;
        Fri, 20 Nov 2026 03:44:04 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm4101459a91.17.2026.11.20.03.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:03 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] scsi: mvumi: bound the values the firmware supplies
Date: Fri, 20 Nov 2026 20:43:59 +0900
Message-ID: <20261120114359.3072514-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
