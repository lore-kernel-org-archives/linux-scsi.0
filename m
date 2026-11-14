Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627505;
	b=firLHdqxsF8RtquPne/ZZmU2uEFhOmyvSy59gAZtLhKgiEt0zu1VLJM3N4ZOdqSYbJEU
	 cz2C1ZGODyBaCE3KVufh7D0VCv0CYvxwa/fPLwNClBHBf8p76mrmWND6Dr7LA32O9Yg3y
	 rWnAYc5ZXL4G8iTZjxekDyRfSIZ7i+qrXfqNl51X0vkj2B5ePoqe/VavE9N7ZIEvOgBH4
	 hOdBcUmeYvdSaBNrq5bAkpLtjqehG/zjkAUXSJXwnKK8P/fcwOkHJ/fYgCjGv4/AHhQU4
	 M2NidoHLqghVxYnmKGmYVA2xtDGY7mljOGN2pegLm+QR78/6GSiAN6Naz4sh/Snx31Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627505;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XApMTeRiMcqMGBClJsYA/h0r8RwI8hz2qrd5pPnw+Tw=;
	b=Hnm2a5pjZMDZU6VxwhQL0P1mjnLoLHiZQ85WGjZSzoN/sgKcAPZ2V3k9gU39O0VdvnI2
	 w5rtpqx+EIFSfP8BLUyCF4suAPjgKnTa22AYj1fv2wgwtC/I3bVcPfAwI9w6JxakjkpkN
	 KyQTiTQUPqrs+YdirXD8RXoxOjnPJcqU/KsNMkSuP7aqwIvp8ckeYOEasEafByLw7iBzA
	 z9QsN/kzxAccu7rIHYH9PJag+bbXTScirc89DqKapn0NO+/HSqhW29wHSu6CZ62bCPMVA
	 K4aryAIZp5fGxQaQ47yzKQ/u+RFwlaPS0oTqIgqIdCLnENAayfzr8kBW2zLJQzJCBZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t1LXlA0n;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F3606A32E
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:38:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D72F3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t1LXlA0n
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9d7791b00so19493595ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 19:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794627503; x=1795232303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XApMTeRiMcqMGBClJsYA/h0r8RwI8hz2qrd5pPnw+Tw=;
        b=t1LXlA0nPq5/PxDT+AAAb00hC5E8MFOJkTAG9lQtRUPtk9xI84h96Zhn5f/+xcMAVH
         yiQONaeSY4785hcIXl+AGRH7VfZ9G8RxyBbpyOvOKqcWasi0XXDOFGaWfqCR0qWoNT0J
         clZ9qa2mC0Sl8gfBmJwn92zskVSycSXiY0FaMwMwZJZPwM2hZAFeF/KndItNg8gW0GGe
         j/cp2M+ckZ29KhTdQlU5C5k02XXlVyEHGB554WXYnP5Oh345WkV1ib86eNp7GVjwJhQo
         4RihW2Wk6S4IgO1am1+nxVcD9B/XPX6z6I3bikk6GxU+PfKS5nqavRDUVXlOEaTCghD6
         u/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794627503; x=1795232303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XApMTeRiMcqMGBClJsYA/h0r8RwI8hz2qrd5pPnw+Tw=;
        b=k5HvvpuWzsdSa9y68TcPH7cCarxjFgla+rg/VgtPk50mjCCobs00XlOBzuyus8N/cS
         5WNUizM0pW2DUEyvNazpzdYozPfC6xI8JEHKmGsIO+pViKmayWt1ta9H+MUBFfJ9OWqv
         C1BFKVRmDmFuVtMBQf2kjRM7bnU9p2rFWXHq9/g+PpX+VWKXf3uFtNik+lBkj0cF5q2I
         E9ER0NZWPmcUjQK3VMtZ8yd7idqKS2Vs28yjnFYRwtgUozF2VCX/HagDhM98z5Wsjgnq
         y/Og4tUzNtGog8DnYcjpsFsNdhxy6b6ZYRqmo/OJzKvsM9kiZ6Awk9YWltNuCvWcbLXZ
         DUaw==
X-Gm-Message-State: APuU4Z+Pi3aaCpa3sGMNIoG782j9Iadvt+mOuWJKSKe5rsylDWwG60ON
	BYaN+1A0J8l1XJxSyrTAxxxDG4TVKOB4EL+0g/91pfpBGgZwTU4CsdpZHC9vXVF7pZQ=
X-Gm-Gg: AYBFou1hF8qZuT/cAwt0Bs44Y1p9sDLYcu92UJxDqGUW1v50Z4qRhWNfzv9lopChFsC
	j/zex3xw0wAjqDMHxvqm0pkEpFAzikEOwpIVWImYHqhriXpx2dbWdYvfYU5BlJThtx8IHQJsq9g
	3CBOoDFc9UZhlsec1yAf8PoHtSpsm1gtG9RWuO6lOzVjBzKICQzm59WFE6/JsVvPvjkXOTKY9Yv
	J7eNfNSteDWQPGfK1OAn3/MjDvQIOdRDougYK4h/QEc9e/VDpE2Pac/Rkgfd42/XxnPfVBodIzp
	yLrgCWEsatACJQoqXrnTbSmKi4XfoxK8mtG29VmPc/2W2MN6muFYur8ekZKrzLfbfnoe2OoT2jP
	A4yoRxccgqXFKvjsAzMIH9NH/5kFII2INIlUYui/mZpswU5WaisZpiYsPhiRLT0URbpVGXj7cis
	fIY+LLBlHmHSDo3KBT8FugbGu/3LiBbijlH0Fy5sVQgGY11QuuxrcCcu2/TPfxmOSzA2a4LJmrP
	f0nsyk5rya0qcK4sgDhnvKyN+HPG1wVmOszeYLiPILhtIeenKxcKoywgkjeRh212o24yXSt7SqV
	Ua4ulsvFUryF6zTaIMKOqf4dRAbofLEDE5/9n7n3VD6YMPA+4eWF9ua2uVnuTjcqeI64gvOxxqx
	/sEexZJwdvch5IZZS3LnzM7+2URK7Vk1ogkkQFQ==
X-Received: by 2002:a17:90b:28c7:b0:3ac:a521:953 with SMTP id 98e67ed59e1d1-3b1b0b63d26mr3878240a91.46.1794627502924;
        Fri, 13 Nov 2026 19:38:22 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3a21769sm3412380a91.4.2026.11.13.19.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 19:38:22 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	erich@areca.com.tw,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 0/4] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Sat, 14 Nov 2026 12:38:06 +0900
Message-ID: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
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

arcmsr uses three values from the DMA area the adapter writes - a
completion slot number, a type B ring index and a message length - as
subscripts or copy lengths unchecked.  Patches 1-3 clamp the length,
reject an unissued slot and wrap the index, each reproduced on KASAN.

Patch 4 is not about an adapter-supplied value.  Type B is the only type
whose completion ring is consumed with no lock: D, E and F take
acb->doneq_lock on the interrupt and the polling side, and patch 4 makes
B match them.  arcmsr_abort() masks the outbound interrupts but never
waits for a running handler, so a working adapter is enough.

Not addressed.  flag_ccb is unchecked but is the CDB address the driver
posted echoed back, so only a fabricating adapter leaves the pool.  The
data_len double fetch needs the firmware to change the field between the
two reads, which patch 1 bounds anyway.  Type F polling not restoring
cmdSMID is also handled by the dedicated polling function in
https://lore.kernel.org/all/91fa9048-ae23-4813-a8fe-bd64d5b374d5@areca.com.tw/
so I am not sending it; I will rebase whichever lands second.

v4:
- Add patch 4, serialising the type B completion ring with doneq_lock,
  as raised in review of v2 3/3:
  https://lore.kernel.org/all/sashiko-outbox-167892@kernel.org/
- Patches 1-3 unchanged.

Best regards,
Yehyeong Lee

Yehyeong Lee (4):
  scsi: arcmsr: bound the firmware-supplied message length
  scsi: arcmsr: check the completion index the adapter reports
  scsi: arcmsr: wrap the type B completion index before using it
  scsi: arcmsr: serialise the type B completion ring

 drivers/scsi/arcmsr/arcmsr_hba.c | 45 +++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 4 deletions(-)


base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0

