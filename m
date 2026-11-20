Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186825;
	b=ttXxkfnhxedWyJEcPSQNtlT1yJGiRbeFY3aFhQVDTqakCvUdcNAbeNOlDKX1UWjt5QuF
	 OGsfXkuhgsAPQiuQhU+GTqeQegRuVppm51PTmZGqmxXlwdK87C9D+0Hpz26V6nGM7F9Nd
	 kHvDfJ+pilEp3negrc8IGFQsKMQ7bezlsXURgxz1QnfK9T/qHIJ9CCFZteRH2ZvV6hEfm
	 zOdP6/K8GnjrS3tpvgLRopM/wiHfnTjy5Xa8VINMsCaM72EU0qfGfC1N5skQuH6CWDh7z
	 fUytG3pMB9eMrTpMgHLfouBVoIaMcPzIV8RdAbHpZzx1MUqUJOw+EHBhsyQPM4FFFrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MbM7Fb7F7HpKuAgEbvtlhFE/2bMp/g3djRx/2v2Yl7k=;
	b=oS0kuzMFLrIJHFvf1Vw6MF+R/4XTtM7YryVltUTZ5YhHnrNqA3HqDTLES4cvggIKswu7
	 q7b2TBeIqk9B3tDyYPcgn607xPhT3xq7yvEEstiFk9Dz4Wz1LNkXJaHEPqAN9DkD+afnX
	 cUqNorcVQKPpQlmuI/OE5e1DuLAZRs3wVOXPHZbRRdI03mP5W9RthNnC9TIEhg37mDAd3
	 bvcgQPdtSf9gwCfalcyd95AgilKWwE+ZzgaNuvtZ/xeyqqZNoJ68WOV0OeEUMWQCRleCI
	 9vP788vURMKp+vZHZyWmHmksgeJft4BCHFeC2acsk3lJ04O+JhIencvbXm4mIA88tdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=S1I3kyPL;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24073606A806
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24073606A806
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=S1I3kyPL
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso760485b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186824; x=1795791624; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MbM7Fb7F7HpKuAgEbvtlhFE/2bMp/g3djRx/2v2Yl7k=;
        b=S1I3kyPLTe8T/pezAwNA4crwXZzTfDU4j+sOCte0DyHzOUGh4uMxkuK3ucpKsQWDII
         9e5b7bKKBTMAuIwro9lxfy6/Og1ur6s8uxVOpeFG8MeAYGUO8txU0wvPBkMlOAu0cZ9q
         qBGdU27/qHOr6WWEgG4uH06w/Oo7lvsm01x4+J9L/FfC5MDcWNAMcwM+QqaFF0O+viv9
         hSpjKw1mVFVHcwuee4FL/+K6GXYX9CR6c0906AyqccdncIyz/NFLCN/SA+ewmtepp8ha
         G454Uo476LOwm+FXOilzQKYAZdFYb4pb6Dy1rM7l+p8aoNo8hGIyWvwe+oOq6HzmAiWI
         6T5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186824; x=1795791624;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MbM7Fb7F7HpKuAgEbvtlhFE/2bMp/g3djRx/2v2Yl7k=;
        b=BPSrMLWSUZccwMhkRWMgptdL94YMidfKjLKbKARKndfNjc12rFNNWh9DRnDZQ/VFAL
         qbqZm+9t31sAXpKQ34IA8e4HTUASdSErAKsUkgg9LEhROTo10vSVLFuc6tGYbriQNbnC
         3TFnY2mkD/f6YAyIOqrZwN7dzYI3QrvLiV41f40bOMh2JqBlu4FrIPFA/l2B/FX/jwXo
         I7UyQ0plL7C4cxfJxZZCNqcXFvbiHoyRPjy/9t0edlcforC8g7L55vkL1H0gHMuxEx8I
         21pGalai5QdLPFz3EupWtXYjUd7jxVUr+DnTKxV5JlgWTA3J+Gk0UZLGE/Yh2kkcNUDH
         XlDA==
X-Forwarded-Encrypted: i=1; AL+hErGjzMdk4c4+vtDYdU6UQEGDM2ULWN/2+3pbVtOXeQ1pWPeMSfUYrm+pmFATR/KUgI5UfUhFo398qWWa@vger.kernel.org
X-Gm-Message-State: APuU4Z/B0sL2C5iy80kD3YgRUDTPmxtrkYxAc2pToGPzqwk+9g/JG80S
	JS/H4A2pgRGGKY7G9FoDKmO23WxO9fX6Q/1QKW3tyqK0anm3D88SbziJxM1IXdlmy24=
X-Gm-Gg: AZFdTZc10Tt8E+LvA0vXNMYunWBUPzap9w9d3Cszj/AM9tN+MYlQhfR0A9PoiyBtNu6
	5vXTQ9bkulMv22zh/14GntO+Ub7gwRSQIf13MmbWgfxdd2HaxfjBJLqScBTq24gk76lr47ny3zX
	FY6ztY3tw/iI96clS3n2qnOpkDIvK1L78zFy4lXVuU94be3lWX6iMGOtnESlJb5uwKMldKASVBy
	54vik+35P7Yng/c24ZsRKqTLCyRxdUvQF/6wcxKSN0N72JiLryAKzrX3eAlQ1BkWf7nO80j7JND
	C6LgFa1ibSRMn5LyeLIA1nwC54BzXCol0I9+fhJ7G9EyG9Og5xqeZI+xCC4bkBG8pQkaSYvz8Qi
	Zw17WIt+rD3fJ7qlHqksf4dPZkS27tZ5EQqfUjbiDDnN2xhFcPzkWnLcrtUXz+eC5TLNDKdnUjV
	qN6V/dTWQdMMKm/cQpQ1xfaw99P7iUAOFG0DKTFMUT2/FavtC9NTEIpbawrJJL2q4EYOkikSnby
	xE+1h96jeChS4mIF7mqc4wd+rDNRfeMmD/tE5Ig6Tmlrg+28y+2YG2ncH823FjcUhwpknxp4GkH
	7j3ZuLIBM2qP2vl7CeJLyQo+aQEEevXHLSV0okQ6/Bp0eGp7M+CEJAwpxIssSZFmgywEIpjr5mp
	r7MbQ1OjRPf10ijXAkeT1M/datF0QOQgg12KN
X-Received: by 2002:a05:6a00:3d12:b0:89f:3053:9af2 with SMTP id d2e1a72fcca58-8c87b4eeb69mr3337079b3a.12.1795186824478;
        Fri, 20 Nov 2026 07:00:24 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c873c1cf4fsm1598490b3a.49.2026.11.20.07.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Sat, 21 Nov 2026 00:00:19 +0900
Message-ID: <20261120150019.3128161-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 14, 2026 at 11:19:19AM +0900, Yehyeong Lee wrote:
> mvumi_hs_process_page() takes max_io, the two command entry sizes and the
> list depth from the firmware handshake page.  The entry sizes are u8 fields
> used as shift counts, and 1 is an int, so a count of 29 or more makes the
> << 2 applied to the shift overflow an int; a count of 32 or more is
> undefined outright.  max_io is a u16, and the sizes derived from the shifts
> are multiplied by it in mvumi_init_data() to size three unsigned int

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
