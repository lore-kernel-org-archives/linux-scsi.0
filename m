Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174985;
	b=tnty4uL3tFriKVYRk88aN11TJBa196YCRVEgpOa2zQUA7m6jfdedn87mJm3YV0xzSsmF
	 FntTBQ00dppu3TbmLXMzG0GY51MTZhD6dbdi91yzxXKZnOFbRANh9i8qNcFv/ykfqpeNm
	 lQgbaCHKEDkYo+AaCsUFdcIJYX3tVf0yGgtpG8Pk7yPGRHiMEoSwzOm1GEzQjPFiBJJUG
	 exWAXlUIzh0K2BvNsXoAO5vG+0KeRMkVShPpwEEjybfZBYLQdmThG5jBDNAIRZ+WSfJCL
	 78Zqfxfg4GWRTCKuauH/wA6pYEx/ylJxuOmAwDSvE3Qdg26xQAD8mHkmLPYcPBHFqaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174985;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
	b=H3IH3Sh9j+j7hwFIBZvb5KiKmJGHwogm6CbfVcVpNOQxsIGvXhZsLqvymBIART2Ucf60
	 QbrdIDeWSzVvrk6BkKdYbvz3woh+sdpim7QWWeRNCQbN5zGIrbhVzYI7mvwcZcE60dAE1
	 zg4udKdaEqQANIWUcCQaMf7dY4tXCgezHK2ajy5eJwWcjbx0LEwN9ACJwJpEm0Squ97Uc
	 CmnXcwFOLaDiVPYu7KjypK07sIyXsrZ81NpNI4lqS8JJiVKuyke62Zp8UzeywBmC5zPmF
	 98oaDywJvUjV/mnEqVoJOtcJfEQJpWhyZzHIvQ0wyp+5f8xnHA/b0lYa3K36V7/vr5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M8c4rnww;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E208606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E208606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M8c4rnww
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f0426a65e0so4852545ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174985; x=1795779785; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
        b=M8c4rnww66GZ8Abyj3I9MvBehqqdQE9CnXAXTVgyNAPKfTQYugLP+BkxaqUeHJCY9d
         K7EDSaZLQtyx2+ZUQRMUT8rPvBcBY/GBlvUjrchpOHpOwdaS0TRxfJPrbcK27MLyo3un
         2mSrjVMKYQloJNOjJrNWHi7IHthBXVZJPdtApr3avdvPqzzCZMdVTnwHCqweS3BQH57i
         8F1yZ8imyqFHCQVvDAnTRptSNCzJAE/JDN83PwrYX4eIGBRVXKxsPV+qYgkLDGA4RrCR
         /DC1NI2dICi9rBF0DmsPGc0a5FNWQgLVhMl7o3HeO5uaYacsa0qHGR75943f789k5ElC
         x7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174985; x=1795779785;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
        b=pqWt3brlQZDfbnX2HE1GeY1S4NCz0crqbqL/QqFFm4/hMKuQZRqjPg15CwrXsTYC6K
         tAPcKmsO3j6/oS+wNu/k+VUtcgGU4kGfLdDBfsmSIBVDw/lodFUIClxdGtJ/S1Km7l/O
         ooIddTkJ+bnVdC1MkxTgM9mW6oSpvvrIoMAdWgukBQw0yN6ruhZqjsp2iDjMqE23DDJF
         s+w+hE98TZhsnU2bnH9uG7T3KYn0B8XbSzMOjsOXaDlF+vJjctiHKinnPQf8sB/4EqLN
         RpbrMs7GA4jfxaEOw/+SfZXlLZ7/5pBR/kfnd7JO6iU0iOraex/4gz5fMCjt50tC4mFd
         TILw==
X-Forwarded-Encrypted: i=1; AL+hErGv+QZOEBadIgi+B/N/9Mt+yeVKACr0bp3+vYpDcwrPeDkwEIbHHJEj05akZR34kdLHmUIB0lziAjoP@vger.kernel.org
X-Gm-Message-State: APuU4Z8uPN258p7Qf/9RAZwBZgrJfM5+TBzXd/tgq899LmFE0OnSwtPb
	1XjussY7XxrWMjcRfxJGpJs8C4DOGma01vugnZKO9V6JaPnJ7KNzkMvuxGXoK9kd0XI=
X-Gm-Gg: AZFdTZewiJaXIecZHvofy71B/cnIfbxNS8QYgFDZ5eq0dk4lD3uIeNU9ZGOi568P443
	GQpaOWO0NDiz3jrwezqIrpR0RM8asxeBs2m7CSiofSIugFt2VG1bDbbORA50Mm/YB54yuAGiEKM
	uk1aMHN1ZsaLv1lIHr70uOnx+CxGAOP/etYBTrbkfahYoCJJRooeDuWhAjedyN4nPJ6yiSnppEE
	h5akb3vMF0kHUdDpJkXihUjh/ClSuYoFpBTUOqIzaLZ4WlEXY+eiUMgVvgNvpgkEOu0EUMwBOI5
	KoF7qyzb4Q6lDOFb/VE57NWONRmjHl9vqmOh5w0xz7dFf9ex1i9mi8TlUnppI2xVMHRWkpy8dHk
	nvVK48n6ZSERmpbNATG+Zq++Zq2BCmpW6nyoxCbGiTbQsYVc5d/aKGCF4hFqoMrv3/tqMhjvUU8
	Wrg9PRJDJb9SudjvsVWuwkInLLTU2XmT64C2d1d37DPyBpFYKgyH8lS19+bGH5WS8XNpnLSvvSU
	ShoLqrFpDC8hW4vmyXoANT9YERHqfpuu58UJxWW43gFJDvpzsLsBny05rx9Wv9k5dsogk9k1EgG
	2EEI9xWF1n6nkfhkfWhAzq8gf1HiIKo+8wOaXvR+sG65E5dpCf4LpdnJ90yiSTSTK5NIEzxK0FL
	92/qddNt5DqGj4ELT1ON9lUQVqAKqryN9FzKO
X-Received: by 2002:a17:902:e811:b0:2f0:22b2:bfe2 with SMTP id d9443c01a7336-2f03f201151mr27718695ad.31.1795174984741;
        Fri, 20 Nov 2026 03:43:04 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c2ad2sm13209395ad.16.2026.11.20.03.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:04 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: qla4xxx: bound and correct the ISP83xx reset template
Date: Fri, 20 Nov 2026 20:42:58 +0900
Message-ID: <20261120114258.3072242-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
References: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261011144752.2063334-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
