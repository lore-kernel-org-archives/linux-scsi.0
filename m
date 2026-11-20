Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186728;
	b=Gg6LC2FPuC7bGBQdtrv+VgqS9im5FPmV95SN7zVqUIGMBquwvA2DZ6hawZFTFyO6lfHu
	 yPU9Qpleabo3GkQ9huVT+zwZE0OX9+Pw+DJVv/d/89bkqwOFcCogkeevdTyBqx+11oggJ
	 oL7YPY2zwb2aspDTOmuNan0hyYl+m549MQDLINUBVcT5hyg/tua+HPASSyt3eOQq/5y9U
	 24p1FPYhuS/dAYM6mR2p1nb8LeBKJN/qRIKfbJhzbVivh9aPGfOXDTb39B2UMf6lvi1KM
	 8+koZmj5fs6mhmUMmOQj0BovQEusvJYyKM18KQ2ODr0+VASkTzH52N07bV82BzQ4hxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zL5A0eGkln2wQn7P2deJiaTIYw/UCNm9h3t8LovTIes=;
	b=Nf8OEYLsgehQKIqiaJkYxNsn8tZijMf/x2km2DTk8lu3m2Vo5VsyAM1ZeF2MEUdKbU4I
	 MAd/G4NQRg2lssmRquIUhXUQztpr07YyhG2jex1tK2A8sidyW/sRLaWfr2+rFwoPI0/xA
	 F1QzEyoCfabyYuzjEGRLR7qwkxiAlefban+H/m3bHJ46/SSgQBwmmkNMhdiTn4eJoGzlN
	 0obUBJsKijZ0cDupwNOw3OeGf8twTVJsWS893797h5iW/V1vt2qT4PBSHPOCGc26TwoeH
	 lMNOpr/iEAj5v+63Z90z/J951sQ0pRYb7aAqXloekWxkqka5O/oxX323qFLF2zMTV6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HZ+Qx0YM;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CB560A260B
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8CB560A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HZ+Qx0YM
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f048476ab9so4764795ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186727; x=1795791527; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zL5A0eGkln2wQn7P2deJiaTIYw/UCNm9h3t8LovTIes=;
        b=HZ+Qx0YMsGEkOku2Gy9Tsb6vA7ezG1H9yta+adBztXheQfytmohGELWuoJ7zJUA3s0
         eQQ69vAV3JcviK5KzDNEgk2OwF82y9suzIsjgJANfzLGGDwkv1xU7t2RZXpHyIzU4cXO
         qUoBsJ7r/kBkeK+6WTQW8TYXov1IXijTwmEXzxEfpk8en1NvgbzLl9mU9bVF298gaE7j
         8mI+RH8eF4tk0csovR2K5uZ4PG2J4LJlflsjrdajvN/97EkgEX0rCFkdTW4kWuibNLf0
         OIEIPWCrgYh/z6NhgJrd9uMnoQYKqfiZk4fHLrmoph68JYpKyPqAZ3i63AT3UUF2fVbm
         C18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186727; x=1795791527;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zL5A0eGkln2wQn7P2deJiaTIYw/UCNm9h3t8LovTIes=;
        b=pZNQLSFrHi9af22GtpKxMYJn/Ix2k1Kpn5h1UQefeaSnZQ7MQ3GsVKqBKkSGX3nYm0
         gugDK3OtvBEw4+5R56Q4IlsdnNb8b9ZeXCBjTFKSZ80Fy38ivfIG8PbHJikA0Xj3C2VC
         iYTVfFb1YtR/HSo2l12BTaAVHMI7x5auji7RIBIFvsFNvRc3wSFd4XFbqUAvtPkvKWX+
         nusZho0iICWtFRzbzr/nbZp6GgiGYwCBx9srW/+jkC0kCSwAp0wwBm+9GLzuwn++TmBL
         86l4vMpjhFwmSW5dg5fzv3fnduA8Yrq3cj7SegHukf+l9qaxsuAD0J5mm+BHxFSKblzY
         0dfw==
X-Forwarded-Encrypted: i=1; AL+hErG2mrtiUwXQPHRHCZq0ZpoRgQGsfQsuBeDoDJ+ZCwa9LyEx3EDN8n4rTNtMNj2MgPfCVAe3eLdHfGCc@vger.kernel.org
X-Gm-Message-State: APuU4Z8N894JSqbkN2eNNUhYe/elyv32VuAW1dQbhAcj4a7IdVCEoXk/
	hNWMJgxySt9jK6Y5yKiFqJCAcC3pRX5VowOa6fd5oicBryq0paTdy5zm29bIgmzkvD4=
X-Gm-Gg: AZFdTZcpUlnWvWbNgRrUo4RNTxhfyDEMTRDau/ZpYl99GsJy1wfOz8h9B6eW3XH/AGx
	z/Zsu2SYwAP0T0nQ9LDeNzie1Pp/kCaeQZMUxv4md0PLBF+iEIXxAnodkJf3jzmK3OnXiDUrZUl
	Xanqt0nwEXCA/dca8goRzjCr0Fzd5MN8GOo8louwDgrAPUeYx7pENS55MAoJqqhjdEkGckbokds
	qN9k4xvpW0Dk9aou/z7asv053FmzQk0sMKisu11oaTJOMCCffCl4aQTxibliCGY4jKObk8IZv2x
	4wG/Okad1ubhzr8cW20jPoKSWneCVV7szsIPkcRzxtKRiCXZOYbDdi+Hsm+R9gNadxTCkurJbAJ
	/IynOfhsXg3/b62Vmv5ETdGleWR1QR0Y9YCXr0alnzx1x8QBR2+oP3AvtGTRPF5vovVrCy2erv+
	ot/XM5tHQSufv+asEM9Y9uVL7YowpEWoTbjILYh9/2du8eql5DeazEaDRdynfOEEPVkoEb8WtFs
	ATYdD28yZxkYr4QSuBcrYRYbBslWfjjA72q/tI+ST3y+WXVJse+KDtQ5RyeOywFR2JZiW4moXQx
	Uaox1YA9f40QqgErujxqDtrT/YSuWW0T1/ZhRo9ePdIr3opKUbhcxG50ejyB4CHai1aBBCzlWfw
	OLhqfTJWylc8hLCBhpU3ropiVYJNMNfJVc2HX
X-Received: by 2002:a17:903:4b0c:b0:2ed:352d:c619 with SMTP id d9443c01a7336-2f03f16ca83mr34268275ad.46.1795186727194;
        Fri, 20 Nov 2026 06:58:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1215d7sm15163685ad.65.2026.11.20.06.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	cleech@redhat.com,
	lduncan@suse.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 23:58:41 +0900
Message-ID: <20261120145841.3127758-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
References: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
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

On Fri, Aug 14, 2026 at 09:14:28PM +0900, Yehyeong Lee wrote:
> A target can finish a read without sending the data.  iscsi_tcp_data_in()
> bounds each Data-In PDU against the command buffer but never adds them up,
> so a completion that declares no underflow is believed and the command
> ends with DID_OK.  The pages keep whatever they held.

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
