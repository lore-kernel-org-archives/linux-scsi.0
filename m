Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922971;
	b=CP0Z1KcyoULfxQXhB01VjPNlwNlvCxQGMit+/2bHmhTkRx5Gv4v9+wp0Sf2PYPS7D8ro
	 GWsvCEg92jW0n1ilqXv+iqfLwSQY22nDPSiX18AJ77SoMi6Fj8ct4i3PJWQVC287FHGNJ
	 QcYo46ozqjI+WTCoM30SnxawN8LKalHXhKZ1aCI2k94Kex1Z4K9ySixcl0JIHcvd7/Keg
	 JanSvG1sZJ5Fmh1dJQOrRiNX8vMwe5XJfF7XDGFIc694/xWxcU1A1UCg7fw4Vx7DLdLgd
	 woZFzeLR4JEBRp7aP7c1WoPBrN2q6nfOB5mV+dEk1l5VaC8vPFRGeaavc/zCkMXhgjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922971;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=lYvyOgeDLhWRH71wL6BvrJmUkU6oMEvaRE2drZaf37U=;
	b=MHxsguGAk0c/vH37OrxOmHlhU4c8Q13JqW2z2nNXoSOk3nuZKe2QueUNma/H2mDB+cKW
	 Za7mASN+69SEFL3mEPdg3pH38luhdtiLWFh1WdW+U9LdSSWT4GCGf7/3lS916ffZU+IzQ
	 rxh4fo+t8WInOu1T0aLVbpzlE7YdAEI8CEkymjW69jGGaXETmOFUzpPuzbw88WGXk7rKc
	 AonguSNa6qqF5ClhqK/C7igIjlm62ukCE/HORRd61bcFe32fnG8CReSfnsLeZJ5KSTqnv
	 npZT2EwBfXBl+iOKroBmAOkGSf49WKubNwMcOgLtoBEbt2jN3Pl+oKzdXmeIq+NN/tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="FJ/gNqVY";
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B609E606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B609E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FJ/gNqVY
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b6b22be970so1752395b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 05:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794922969; x=1795527769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lYvyOgeDLhWRH71wL6BvrJmUkU6oMEvaRE2drZaf37U=;
        b=FJ/gNqVYyrVQqVNQp24+Mvcm2/Fswm3iWpTCbYFvz0mLTfjWb2EkFBahcNFhIytZpX
         oJ2NTGEZiLB9dJJLFGHQAIN3o2Z1XJ4tUDbFUrgXSGkcolgSv6x8WtsMygqbFfBJqvRs
         hDjYyoV6SbCHBB2yHjUlRcOb6V2xDsi0HFIiWtE/vDP9RxC0QJTcZGIMHDVTWhDe7xoY
         1h6b0OhZ1/kMSrYQshblurkr2FYZSUKSSvpwlUtovdiH9yjS9bG8/FRqqdHNf2SreFgh
         Bxkd4jnPyupdvIw/hJ+oCaodZMmEILOkHTYkhySeDPbbPCBE9cFDIUiqgjLGrW5lZLPm
         AmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922969; x=1795527769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lYvyOgeDLhWRH71wL6BvrJmUkU6oMEvaRE2drZaf37U=;
        b=Il50VNqG/p3QCFQfHNQu2Ovhe3tXT+Mzl5s289JOO3FfInG1EqggIv4UKbBlVWXPwl
         AjH2VfmOiUTJSoDKin8AVaAZzp9kewjbWkdv2IIBp5qyLai6CuWfIf6mp9juO0m0OoyL
         Rd63kRMCIUOCAMt07RTc4IboQ8NaqB8ILPkaEYCY4tAL+dknN1ztN6XlxvCYv/ctnV9U
         hqR1g/DHRzPIQBVm5iigSiIxHsqJ8Ni0Z+sHWfgFrMrcIjvp1nWBewFMbNbq2aTdGJOx
         JMrLmBR/vXb7UospniEml4AbMIAcE4UISzqfdb7NrbkIcIMVOOPuakablJdbBx3XJpix
         TcjQ==
X-Gm-Message-State: APuU4Z8Evym8vS3POyPFuZNF0SmZSPCNoLN+q9GPhAzSZqatoqlHb0mC
	z6fRgfqxzQkEVoI3hf89vvAI3uNSByxOCs5qVOB0o53rbAi93MNdkVTcLUKgTOhp3uw=
X-Gm-Gg: AYBFou3X2TgY+a4oI4O25S9BjyFF3SqcK5llBKCjHsQxhDwlilVjlClJv9klKfpXh7W
	8Hro1QXIOdepAQmucLwUNmRyH3CVPSdpjoZ+mCXo7io3ytqxOa3NdwlJD6344kKHeKwwZ7m5XA7
	QA3Wp1SyAxTsKYOUv1rV2T665OwA/SX1N4EvbjMwoqZTtmx7p+oR5t51t2IJryEHM2IV2vdMkxC
	IWV2nHEq0Atwd+t7wGvaUWqUQ0wBAs5vlvabSXjOIQj30LqeB8aAHtz/AnFJ215HZDM1oiMc9MS
	tyQhupfLyytJBgrIHCoUSAaO+pUz+FIsjmgPv3fSHB6QEdMZoIADK+xoJGaLfPPp2T4hujXTcHk
	kmp3M8MGGjV5+zUgyionFqh/HQSGzcUcm1cOdCIJolwf21yhb25XzFIIiM9hTCFtRiuJTtpyS0E
	FCz+AP73Ptz6jDi22uZpXlYWZd9e7TC03pKJrDI5/NRnaVC+Ee9RivhEx4e8S7X9XyL9V1voWCR
	JUt5zBUhSiG0OCKdG1txSgOwIzZbtMLNoOe6Siy8pd4yi6Imy6md8lS9M0rqBAKr3joDjbpouvn
	A0BZ5I7HmH0K4hTrl5GWy/x6s7Xz+8grv0CguEvtwS5gL13AMOGdes7ZdSXENCaRVvLKtP26wMm
	OGHs15PpDoceI9jT9P5HPof+upOJRugq7lsU3Mw==
X-Received: by 2002:a05:6a00:340f:b0:857:7317:cff5 with SMTP id d2e1a72fcca58-8beb6197550mr11801170b3a.22.1794922968711;
        Tue, 17 Nov 2026 05:42:48 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8024sm5040714b3a.11.2026.11.17.05.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:42:47 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zilin@seu.edu.cn
Subject: [PATCH v3 0/3] scsi: mvumi: do not free or reuse buffers a timed-out command left with the device
Date: Tue, 17 Nov 2026 22:42:24 +0900
Message-ID: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1/3 stops bus-mastering before mvumi_detach_one() frees the buffers the
controller was given.  2/3 keeps a timed-out internal command's buffers
until then and stops the probe loop from reusing them.  3/3 waits for
the event work before the host is freed.

v2 -> v3, from the Sashiko review of v2:
- 2/3: free the mhba_dev_list entries an aborted probe leaves behind.
- 3/3: clear bus-mastering before mvumi_release_fw() on the probe error
  path.

Left for separate patches: the DMA address rebuilt in
mvumi_delete_internal_cmd(), which 7/9 of the series below removes; the
unlocked sync_cmd test in mvumi_issue_blocked_cmd(); and the same
bus-mastering order in mvumi_init_fw()'s error path.
  https://lore.kernel.org/all/20261015045213.3975845-1-yhlee@isslab.korea.ac.kr/

This conflicts with that 7/9 only in 2/3; I will rebase whichever goes
in second.  I have no mvumi hardware; this was checked with a KUnit
model.

v1:
  https://lore.kernel.org/all/20261114014430.489668-1-yhlee@isslab.korea.ac.kr/
v2:
  https://lore.kernel.org/all/20261115122153.1446810-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee

Yehyeong Lee (3):
  scsi: mvumi: stop the controller bus-mastering before freeing its
    buffers
  scsi: mvumi: quarantine a timed-out internal command's buffers
  scsi: mvumi: flush the event work before the host is freed

 drivers/scsi/mvumi.c | 97 ++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/mvumi.h |  3 ++
 2 files changed, 84 insertions(+), 16 deletions(-)


base-commit: 23c62304dde29abe92013d85910d03a77dada35d
-- 
2.43.0

