Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745483;
	b=RZVOr9UrDtd50TtKrMJncSaXufyu8Rf/qMDnqdE/msMbORl02S0mfOJnAivuUXGKwNWw
	 0iRCJh3ui0iCrL+KxCiPszo3aALtvS2rDEpGJ7JbJGcIN3eFZO2DehmpBJQIYbPt4VNZz
	 efWk/ngbImPR463Vu0Vaq48t3QPvAahia0xZniOAfNW9/YbCCzXoljb7H0nKGrjpCzzdy
	 X3aYPId+RjYh6ASfejgcBVtrXfQ/I+rtIWv1eB5nvUoGfAwIPDmPDMNXx31XN84LT6duv
	 cKWwN1WsiW8gStQPO6O5Eo3GtWzK75awjeP1yfePZCVHBZkSSS5uuh/B20s4wfJ4H5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=dQeEdUb5WctY7WhUyxm+UbBUn6wGpNRQb78S7LtXpL0=;
	b=wPlnl24uBEUnCHkGfwNbGBHBRgdHjeEk3ONRyuadvNYnf5im2dL10/nvYjS77lMviYUV
	 ngTtKVsqSxz6zJFLAog4SR64XnJf/GZeqM5KRV2B9OFfoWul9it9kvdaolvPxsT6U2ltY
	 HqKdsrJ1dhILBJ5JWeyJLc0rCMWwNB3ROsrH4FF3EU5ZhzJr3v9Ytm763/lmIKmndzbRL
	 Fk2Dt10stIPaILmZ/rmCGT3U1fiG9Kul5Zo9RBQB2xpJn8oFgSnDFqlxWxU9O9iykE/9W
	 uPFS/lcbUUD+qnD/IA9cHrLiJkxfSC0jHYaJXT+YjTq7ywCwlCsMLHXdXphdWy/k6Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mkbshFRq;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC38606A31A
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BC38606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mkbshFRq
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0b3438540so2203942a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745483; x=1795350283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dQeEdUb5WctY7WhUyxm+UbBUn6wGpNRQb78S7LtXpL0=;
        b=mkbshFRqlbPWSsPZT8XaHyIMifNRB6pxVZHt9QipD5qOBoIhUdWRvBJYbZKYswnB1x
         25mmXMSYkrtegHBQzn5L/D0Gl/LpImeb3HtkKhGmXdj+E7aJ4A3sCeUnvFogscUaDpbl
         2kZUjmNiDELSEye71UJ2t12eM/tds67LjYa2HQsyIYsZ7V4+/zds7j71fUL9Ao0fUZS2
         TTg46ZMr4cDl8njTkBdMsrcP0qvDk5zlB3pR5CwidwDRnN3dF2sE9xJAPhIenf+CIjiN
         SmTGqbb8Vv0L3LQXzxoTxS22Ko6g2iUxjGVcYS1UIO5syQuAxrKzhacgOnVpMFngePPm
         O85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745483; x=1795350283;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dQeEdUb5WctY7WhUyxm+UbBUn6wGpNRQb78S7LtXpL0=;
        b=NS1EBfJmmkj6CdqrxNwoeAoaR9/MhrGYq5bbPXkZW0msHMb3oPyD5Sv5qlNALHnfku
         iBO3GMeQLG8A8kJMn5AHlhTzlnRRApmgqkqsrXD3zVRF/auGlEQSgMM/VnfBgi0WOF3B
         XPoH0j0WyOhqCYiO6iFbnSjbVNSpxC6dTbe4ysRKlpNzKqGe7wsqDFhle8ui53lkT1O4
         AQi0Pr7JmRQuQ1dSA+4NNSQcqCY6fv5vYbqL0/0TmFHscHscQsebdGu3hlQFERV7kacP
         zdzoadjYJq+xxe5c2CAaqdo2KidtG0RqyAmeTrYcVFMzcBRTONel1XCXHLLR8TVjt5i3
         ZriQ==
X-Gm-Message-State: APuU4Z9TSytaQCzry+L9FtJwCHkruHoAfqj340Hpcw6Pz/BkeRrolK0f
	rXUbiW7msj0m7QeejiwsG0Y4teBmgO464VJkT+ZDH3VlCRCka/wGrNEYI6N3nEy5AxKRm4+96ji
	hAStW
X-Gm-Gg: AYBFou0nmF4nbkkd6d4FhMyzEic3j/l4mdntoF0MZev+VQ3NV86Jc39HIloH2b+I7yT
	9oluC7GKcYHXMDQwVR4hUyl+NXQXYX3rwFqM7mD11borORL2ZZ8PwXB9DAUEm3M2vcUFbtAVg0d
	347tvOIGX726KpAGGFljlebCnJJdSWzvnRA/CqIY3Us5PADlsV8dAeqlJTB9DgLcHT3v3R2qaQt
	izWMYlMvBGWgxbpGUSu6Kb/uNxz/2A51pjzsEpe6HppBoARTeAdfj52zjjmsgktgdU7g480ozQc
	nZVo61dYJUlDV9F1i83ZMkyDiFY/Qj4CoZeSn5wkttSgZkmPRwGy4q72yx/s/OK0sYRrvnsNeMn
	dxcZzuFgJ7c86arrvMMxaSroFaSR5gtlE3CKeXIV2Gg2uaJBNzpkNj78NFKpl+Bti9d7k9NlVf8
	DYmfzB7hcvVrC23cql5vJvFjlCNCN7Jz7h0mrbYp6r82KtTwyiA3aqOYOCKklvz6iplPHnE+EkU
	88FeEV5dO7m4p/inR3QW61iQ1JNPWR3XX/j0JXIKE/PaCO9PU2IGzTqU7jQU+s/BSEHkO3MXmYT
	UGxKdP5IrAvZwzuEq5Z7//nDHYt7tZS/PIAQ9nD3BSvy3ukXJ/WjzmQ8/CShcZZqvsybi77dh6U
	tBIwkdq6Nf2G5mGuPTnH8XUznW2dJlkCmajmMlA==
X-Received: by 2002:a17:90b:2246:b0:3ac:9d14:feb2 with SMTP id 98e67ed59e1d1-3b1b0a0e12dmr8088877a91.35.1794745482838;
        Sun, 15 Nov 2026 04:24:42 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec3af2dsm12253371a91.9.2026.11.15.04.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:24:42 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: mvumi: do not free buffers a timed-out command left with the device
Date: Sun, 15 Nov 2026 21:24:35 +0900
Message-ID: <20261115122435.1446891-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
References: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2, which answers the review: 2/3 also stops the
probe loop from reusing a timed-out command's buffers and frees the
command on the duplicate-wwid exit, and 3/3 waits for the event work
before the host is freed.

https://lore.kernel.org/all/20261115122153.1446810-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
