Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174997;
	b=kff6pTu5JqukFbtWcBZAreNrEAjgpsUJ0ZoH8cmpOTTQ4grzDJqVUYdNHw3TzFfnzOlq
	 av68PFfoq87JrlxEjHjsDFh38lwTAtiV2R8HPZqyIZBe0slisN8YWl2dUOtRizcex2vkr
	 jdGQKpGoe0hVYqa0A97bxIYh/N8csAkxMPFb0aaUJXGK/kDr9J0cTs4FCo6jXfnwxM/KZ
	 67tDFW8csQl1iDk6OYze/7/cCoQ8KNaSvunO3Tte7yKXk19F449UqHNiyyjM3C/bLe12r
	 yRdYIhXcfsSI8tQFGkkiqGvrFPF9a77rIjO5wbEgT89vyEZNdIPNaCelUUB7kMAXAnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
	b=hP6pZaufX1vC+iSJ2SUBmQdSYCwdW0X71DKD/LaliQ3bUdfrENrxXBsqXva0gCgQZXVq
	 tg7+3EPlvnrdSasCVyXRgX7K9HZfFGT0KnvSIWRama6hyWjUzBRYk3dmpMQry8oyj2yug
	 IyOOfd4dWUnm/HM0uCyXrIEyp/QaoPjRVdlz392Nuc4JSRD/pD42EmT3otnUn3wPQMy+h
	 wpkNCKuR38mbdOyl54835FOba2bs+/AEflG6f8+ZMCAthDTlx83gn8BhB6Z4QaJq3AyTs
	 t5uTbJi5stglDx8Xvm7QMyRGqywJScpwuKpj0KyHfV3NKvoxzitXUJmm3Z2QChe2WQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G2GB3A4X;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5DC606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC5DC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G2GB3A4X
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f02ee04378so6107225ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174996; x=1795779796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
        b=G2GB3A4XT2sHgkucCKvVEMoFLDNQBBI0S0GC3WumZZGm7n5ci6O9UlEt4yyPkKMDpy
         +NF3Q0KNVqqb4puo8H15Mce8ncBddovBBppKFOADK/pM65lxEsvpWCEszGb27yWZLpcv
         +B88l8zKMTdbVO7/aLEvHWCSgJiwrHj6gLSmmbPgBSjjZ11k0WD0FgS900hGVtXgxbK8
         vws8a5g0yzSUIS1kxzaDI8r1H7rPBEgOLWEkzFI2rVnuZEJWl8sW7uZ9O52ZzPLVrI0x
         eV9i2aruiT0tOSCCbyPYgCYFAhkDCRxqButXozqooXOVwClriZcUAXYy7XrmSgcFWq/S
         dHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174996; x=1795779796;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
        b=qIlbiw0dt2/FpURGTkA6RQD8X5sgj5XreMVjuPE4d48Oq+/4WgQm8gMuwDa6TJLFaj
         h8jVUS1LEJWChpoNgMoGqlFFGK0QneVNQ9jhrioTNEjooYb8/upMdKTAer4qZGbs/fpi
         J1ZDFegYS0DUmED9sbGmyTE/kVguTCMNhZ4d/2Vrkm+lAPiIfaE1wTY4jtiesCE88hnw
         2G0oez8Z/oEZZgnwTqhIWH1pH/dhc3UTkvl1H1SUBouxPrbKXZLfQulegSym3mkvejXU
         FpxAGxxg1ZGinOt8FQVqhxLs2PhV5zD8jBDa1um0Iw/DFDVpMHOAXdbG14Q+8BlQ/UDJ
         hKrQ==
X-Forwarded-Encrypted: i=1; AL+hErFhn2ruxcWA+flYSJ07m7ZLIuqiQfjg2B/zKYMzn6P1qbtMoh/kl9AACHvjY+pTZ6gnmPMY3D7yrQq1@vger.kernel.org
X-Gm-Message-State: APuU4Z8PUsG8I9SEhGR5zKVVM1Nb+HXUPtvEJsOC1jQDuf5vnxulCTSQ
	LJC/dqCSVY9TSDfjDbwzg4IOvVqk2pxgr0iV3L+JA9wfMN2aoKOKkeq9cvsbZ216dAo=
X-Gm-Gg: AZFdTZdiiVf2nNud4A4rBO/S4c7SC7giKakrjoC/+KU/ovOh9HgamKRw23GKNoQ1fTj
	yFqyJli3tGZlVF5v50dkACC3NhWdo18dW86f3x609CAXPIzajLXivipVtPqF3qgGJQaDyLz/DFX
	VWw3vEvODMNHYTAFfUOPPuFdnkQpldpa04SbJ0/pJ1imLvYCgGhyEdcxuSmU33dB2B//TVs90SW
	ZS6WIr2P8yZXkid0iQOPJmOtM9lTVR7niZUDvUa5+o2xD5M0s483qGo/yzlw/4OG7KGlZl6Dd7O
	rsSPLUxJNCZ09kHrWrb9d67y6zvcgGO87aVbdTuSFNOHlFTpqGQi9yBilSxGKUD6LxNsrPylXxQ
	ZkCvFNyZUi5aKFJkgVXKwG0NdWEZqKtT0fJvkFu8Z9/6X4vtpyf8ZxXcRkU37u8cyBA5uw5yEDT
	fyH9z+lU6/tXlsH42RroZ+wSwP3hnkwygwMLO7RR6ucxZPkjLFF0T9OIcG17WBr0/cAr4d77rDP
	hEiK8aCC2q5ZNOtCutv4vBKY08KDS4jI1PcdrFAGxTefrkf8spZiyx4gqYdJFOnf+HcMExsCF3V
	RE7uu9VPbnopdliEaMgB9BXbFAWbfa76ZIrWKMlT6xxQM2mdG3mN6RtPszqiUd/WnVB2K17UfXy
	IwHtibD1nXAgkTqS5Bul6zTSFnv7dNkCsQa0P
X-Received: by 2002:a17:903:2308:b0:2e9:cb4:b345 with SMTP id d9443c01a7336-2f03f264db3mr28740915ad.55.1795174996354;
        Fri, 20 Nov 2026 03:43:16 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120769sm13267975ad.57.2026.11.20.03.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:15 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thenzl@redhat.com
Subject: Re: [PATCH v2 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Fri, 20 Nov 2026 20:43:10 +0900
Message-ID: <20261120114310.3072277-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v4:
  https://lore.kernel.org/all/20261114033810.549787-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
