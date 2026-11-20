Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175034;
	b=tYAnvn+fJ1uVQpI7oLgnJOVCmNfgD6r7vP9XfMelYjP6LoB7wDEu2LnXTJ7idHCIknSX
	 fG+cFbq3dhYOgYP2ZACVyZRhJCfBoHipZnSr9K+Yme8E9JXhHNOCk+ZxWYC9Z0CosncNh
	 Fm+5c3F7ta07DLSRlyLcjzyvaAHN15przpnSNY3eozn/oYYp249W9zvHfBaVvA5yMnpuL
	 B+H+DY5IeoyZyNFKh5ZmPGtlphLxRVJmdAfuTLFVSQKDiuDorRcYCTMTqlBHBc1zKPMG/
	 o3CkOnv4ApGZbG4wjtNMsk+oL5DFbFn4137rBLQTWoLMCooMw3rXtnKjmT1+AHdkafw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175034;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=hsXwGMod9YDIQF3xCJFGyB51Bwo0tx/uH2U/fmyFp0qaVCMfEwmB39u/8LkWsYuzF7bQ
	 qiXlwQthdWzbe79NqeBNz6OBCJS7bM077TCljaBSqAw01sEXoDLuQxnnJZFBEuFoUI72N
	 +ZAT9fAvm9XuplLz5GHFwdkBoCoMnwjiaK+3/EPzpVTmqnEn0PpWO1j/EHYvarDX3s4ZD
	 fObYx9ckNU4yBappFAAAfNZ18BtYpOlgq5AgY3sHZi7spIAxhbRoMmxFAXbPxQVNWQPVE
	 Gu/8oJ7NzlIG0ZvnEguAmpSyyyw8CuttNESSxsDjm7OdzbVdGvOoMI2tN4EP+PTuFig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CBHtOKrZ;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FA4606A339
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13FA4606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CBHtOKrZ
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdba1bbde0bso358712a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175033; x=1795779833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=CBHtOKrZRyOZQ4x3vdWvUDHPd8uBb7gOvMzo3ESEYY66ItUOkqljSL8DaYyjuR7bZ+
         Oi6ROgg4CXMGtOqsO5irktwdbvEPpP4TV814fyIoncQEBDA7gP539xL01WNBEw8eTP3T
         RijWJiyFAcjR7ADfMvhpmRUIatmiT3/VsfBdATneunc42NXnGnuJJMTumIjYQUW7jr66
         IQFo2tDe6NGBymG9BcbGyo0FpGcc6/BllWytU1EclPjnXfKP4tlzNt62CM0CNPLNW0M9
         aJE012BKx6iLuIIWutE8E/92l0MS2hJoLcRO52m3SpPPVAReZaZ/Bstm+Eh+0I8mLiX/
         dCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175033; x=1795779833;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=WFXSU8ZKZQaitioY+rrIhO5APX2ha/3Fw92F4iLLVs9k69nE4vzc0Hyv63lc4xI9lz
         Riffk3vm48uWqkWeoJOPwrBwN4L9rEBA7/AjY1Rsix55/03Vj42rxk58vri/XmcQj1aF
         HWNSdawyjRQJYGuwwmQA8aGFXsMBp4SsvV2UwuhYPJTGi2gbu8rkuk8QGfTekAK4y/qk
         eSBpwdwO/OdoscuDJr/C2NDoqqMMszDp3bKc+WPxF6SR67lUVmRBmKG0Z848rNAxKkev
         GcofN1Yx7gc+Wu0WclYVztfLM1Rcx+sxfT1d3AmTTnjCY9TxLKNV/CL4ZnJgLA6mYF5s
         Ykeg==
X-Forwarded-Encrypted: i=1; AL+hErEU5CPtuosWHyEbQAZWUDZw0OXksO4FcEiD9PRW+ghbSM8D44qABvAZZ1IuqSB4g3CE/f7kQg9Vnq2E@vger.kernel.org
X-Gm-Message-State: APuU4Z+zhRXjo1xgl1hjmsVgSTeYL7cqI4bXIQ8a5cr+SBE58/SSVjmO
	j7sqSjTN5KxQnGxbHCx3cPgNhMeynJCAr0f0iCMSSkbQFXxZrm2iUT6jGCLvuBNfMR3APKD2ncW
	2GxaDO2o=
X-Gm-Gg: AZFdTZdt0RZ5PdFOEH3DHR3xF4Vpqv/9tnoNKMjSL5eY9Ti5yvPjUFNpl2q6b3/zVbV
	8XdTGR54OB4G9nH9xR1TUMgOADK3efDP1je3wIgxiKrGpmqYVatxJiTPKYG9niIEs2bAwpLJ1kQ
	xXqNoDGahJFVlgCf6IIuzQhIAfYIaeu9/iMerMuVxLaGLsUwleNnRpfHrKTKnmbMUEWB0bQNv1z
	Ab9r9phKLlJGUpDQwlkXtl63qAbmPqvUnyO08P5+pEtFvcs3tai+ibJ/1BUO9bQxahgzku3+uCV
	Ius1fktZq1atrILdlfksrKcCSLrZFzzdU2AHYom/0sUmeDgu3KauD16ELA5g4N/0rwzzfxlteIM
	s0xFq35zpr+1U//79Keyen939EJGoq2lR/ZqMpjoEvWU5CffbPA2JyoM+JuFAL5uGoUJL+QurS1
	rQGWU5VD4qxyRS9mo3quYY64wAx7tajRzZYf3GMvesFGcv//nk+4qEsuXL4UVZC7g0b3Yq9FtoP
	0zGd5poU/waeJa/hYdbN3h+KR5gmpXiPyfr9ndf9IzQq/FPDfM5pyHx13UiIXQ+vZDHSMFxvEAc
	SgsyZ7kLwWPTZbjGed316OhbWdblfJyLSLEdL3gPZp+thWqN/wSaM5TBElS7QT4rbsTkK7XI2b4
	L7ZK1KLdogZiXd4HZTln7AeMW9JLaHhjroUcz
X-Received: by 2002:a17:90b:3d92:b0:3b3:b621:4026 with SMTP id 98e67ed59e1d1-3b41c55a4aemr2773111a91.0.1795175033553;
        Fri, 20 Nov 2026 03:43:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm7306025a91.10.2026.11.20.03.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Fri, 20 Nov 2026 20:43:49 +0900
Message-ID: <20261120114349.3072404-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014021919.3486362-1-yhlee@isslab.korea.ac.kr>
References: <20261014021919.3486362-1-yhlee@isslab.korea.ac.kr>
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
