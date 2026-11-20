Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175055;
	b=UR2R4q4cmGIKEIHTcQJ2GUUxEJ2LRgMzRrPTz5BJ7A0KQjTu7l4ujESGnk3jBPuCJYH/
	 uGTcBHl2+BpiCQBiLL0W8yDnUIyL/uBPqSpXGEz40OIj8uWdCXvJWMm6iOOzgYR2efgRQ
	 y3RHGVjSMviMYCc4UjtQ5jcUtqpPHD/SJzmSSCRR8ye6ZRX5B+T9ise1Iqw8iahkpCzJt
	 f2AOaL7koMTuEJuInhcCZTFb3hZSqxwNxG70O5FDocW7RWb3pZb1+lxK2s7qaX22sobJ7
	 RwvJrwvgcF1LHm3CLralFe7GynesMMa8ldrQjNV4F2Fk9oBER7nzjDoCVCgdz0Y5lag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175055;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
	b=nHHfm5TVklKtYmfFfjGfwuDBZjp19biQjQEXnXDqO25XlLvpYTXAR87i3V/owgdffiCC
	 RTHTdHYh8gN1V6DD4TGff/b06PEvSRWy65/TucXPzON+FR3YzrSz75Z7/fOfXb/G5xuMW
	 LzBVP4j0KC4fZoyE3ceKdA7kpMr49XofIsv3MEh7MMwRVx2Vx2X41PRCfjbLieIXeC9DA
	 vN/TeoHhq1PbtSdcZCFH6FYAbyVii+uE3qG8JWwdG70vs8U30St4eTY30DorbZPbjw9sE
	 ooaaIyaWXhwWxljQO2tupF8aanlhK+G3lbYpoFlNshF8v3qJZOLPRcdzHinibEwuRwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="l2PVeRE/";
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF36F60A260A
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF36F60A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=l2PVeRE/
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc147d86bebso452379a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175054; x=1795779854; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
        b=l2PVeRE/+XPysPPJhubEdgs4VP2M0Ha738NYuCgWvaR7wwTsmszuKbIlHdKEqIgauc
         3rcfnKqHMAwd4FPbK/HOto6KylyAxraMHKhBQvQ4MBycF7Q6LQdWQKyyd+jwtoTNAVIY
         5/io+tVoUvV5zQmlkNm6KE5KWBun668SA8M/ZDuSWE6Iam8sKOx8yOlMaR2fzFq7dIxW
         Kl+9fehW4s/hKmA/gjjUJZIIDChdsFcWgsmt/x3gLSjOHWtPHcVoIVdKYUN/upnGu9co
         Gal5knImfdASeGx8UcT/Qzo1PiMeWJj6uahqooUfqV62DePySn2+Aw6dYieP18k7xHqn
         +1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175054; x=1795779854;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkFRpq+JqVl3CgqxrgMexsAA7SJ5z2muFrI47UuRcq4=;
        b=s6BH7IL4S7W3kHKbLx552evGHjUmd6uKYmQD9x62nxzQnrg4nybDa/Dlkft5AHU2Ts
         lXJn7rdBLrPB9tkvtqTMLt+S/wIszxW5hGzu8s9dga7C16VU3Vdrv0r63mzkRwWK0ppr
         NRmmUldDJ33YeABB7353kX/3CrqRpr6QK+P8M1nWEQnvLP7lrxjU4f/NLiRc6d2nWjcg
         iRJT6ZZ8AJZWpgBBdnMpN9PQ0b8Tf9Gv3g2P7IKm41PaEbjGHDHCQoB7peav4UPiLMym
         wIbCyf8zMV6kkS0/pniV7h7y+HrWPfQYO4EU7NSACBBGL0ITDg6jOvTmrnQ2UHyW9c2c
         2sDQ==
X-Forwarded-Encrypted: i=1; AL+hErGaobnf/hQAt1gcF/ZJFR5Jnu3PMpgu/oU6IZkCaSBnbdbhHH1dO6LuA+52QJpJpWLwmJt17FE8E0be@vger.kernel.org
X-Gm-Message-State: APuU4Z+f6rDtuzXOcDGhKRcsMC5ss1SJHS/aDASJ5iwTlpq3/9MubXLY
	b5hFK1iJ2PWFlYZ1wKWGEgoJBiYr3u6v61+hp2FJTvdXLhiivhFaXX752DGJkNk4h/g=
X-Gm-Gg: AYBFou1Owg6Vo/uFgYagml7DFe/wU35Kud652OiJxmqR10KT+4egr8LQWpGTv2Z/Kea
	ZbTn3EG8RAE+a6UmlO0086RPvQ6chKtsudka/r9JG++vv9p6GPYJLjzbYTX3lW2q+9YFI9jWbZP
	aFB8CkVQQ+QAI0Acs0mvk8FLeiUN36n1+wjO+cQYMRpNQHveyuaGoYQwbY1mGrhEmkYhgndcNyF
	TKaD3gLU5gfimaVie0b7UkgstPItRAQk0wDL+nIx++fiUKWG9+BHvBpAB+LxRK13VaX3yDYNDke
	rmyGOlkN0a/aOydl3VHqBwBOZx2luBYmOfvPjgj4uT4DZ8oZOCrcXXT135EfceUSQBlnICZpv2p
	/87oSwd16W84oHjVsziu2OojmYpEp5cOskR9W7YJbYgGrHZxANuGLauRSwwJENCD8yozclZw/lg
	9FBkarqgb/niB7kaDFg/9xEVdgIc0aSinj/MKn3EiuXdU5AJ1OdVadGbvUXYpS7O0VVKH3DauMm
	rkncMsqbz3BdcBieDEXye+2E6fVJ+4ReGvVwFPoCZnZbXWRcnS8ti9s2PvZHeAKeXtV1H+dBPE8
	5tOv2q7a/D3jSXFV9SzKK5WDpxKvTPo78DrzRUK47YzMPvfLGPVPxoZtJx17XQds23h2yPkNVqb
	ZFF8FpAm44zTBbSlNCz4lBECdxESPuPuB6ergyg==
X-Received: by 2002:a05:6a21:8210:b0:3f8:beca:1034 with SMTP id adf61e73a8af0-400aec05805mr3640080637.46.1795175054359;
        Fri, 20 Nov 2026 03:44:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc8829sm1220211a12.8.2026.11.20.03.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: aic94xx: validate the sequencer-supplied EDB index
Date: Fri, 20 Nov 2026 20:44:09 +0900
Message-ID: <20261120114409.3072549-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3:
  https://lore.kernel.org/all/20261015091747.4184349-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
