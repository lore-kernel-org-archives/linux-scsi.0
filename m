Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C8B1946A0;
	Wed,  5 Jun 2024 08:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717577742; cv=none; b=Lqfd58dDAVhgbnyAsVdZbe/C1h63bTChw/xDATO86zNey9SbH/5UUDGZpMkJwctoUljpJB8N38OfoPe48W2K5QCPYZUecKYmwyc1PYyMukxt7wCuqYZqtEk9bQMgvRZ2bmZtudAXWPxihKkY9h/jb4Kygj35XT78oQKLVwtsyRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717577742; c=relaxed/simple;
	bh=kRzNAa8ifqgPiAlP+LdgUdhEdsW90Wn9qtcCwDi2Bgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G/F0GNakpl3NkY2lea46jwNy6Mni4fcL2Jba3WBUn7samhjbMXUIP64vynegpZHHBVYBvXLQralCbWhNs0tzyty2tP5qEOb/YDFtjJ5w/B/Z1cuYIzpjdlKpLGTKa3N+4qhR1mToAO7m1iDtGIx4ca5OogeUYx9xHUrczyMRHyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a6265d48ec3so682940766b.0;
        Wed, 05 Jun 2024 01:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717577739; x=1718182539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mZLzzmdpglmrMP4ykS0Ib91Fc1S3Euiv7w/Hx29HPo=;
        b=j5HD8okTuqkQTg1VYHLfy7XMt2ELOwgPL3+fCtVRjZXmn67M1rC1qA8oF8CYzOmJHb
         q6J6iMNYLdM1jgPcF6Xxi/bkYXIb1S1SpbtG3Q0qQseZqqG8mDVePY95zhQdltxE6TeC
         QsKkq18vDKqyIGu90kCJXKvUb/tAKqNMnYgKzlozT899JoXUnT4yhdhWymVBkC0b+hQ5
         H8xfu2c98zzB33w1iVBdQV99sk/i6qqssr/XSdkP6c8RlpJGib3s0D4jvBKFdPKdAuaQ
         Gr5z5Kc6WrCmNHelsxyeic5rXNP+zTK6Ep36qUJ5i815Quxp7RDqi2XrxZYnq5hoWKou
         tX9w==
X-Forwarded-Encrypted: i=1; AJvYcCWgTyRQ3BDPT2akXxMXrF7AhF3hMtC16UnZZ4fOkCAVg9dk1rGjQcLWRVWTvB06Ex28IiXxqsEfEFkkN98s9K85k8hEkftkWbIJ+WcV5TnFEIy8CJ3SWBFcec4ch8f/C6V5F95q50mfOAnE3KE8odXlklxqB0ymYUaElwUoNWEjBQ==
X-Gm-Message-State: AOJu0Yya1rmXiMDE2dRozRKBJUnpsBubPCAtaWa8UkAaqwdDex41C1xn
	04ADdKECPjEgcjvLOg4ZNzEEjlf6JYN5nNaoMuUMfX5a5nR7sME+
X-Google-Smtp-Source: AGHT+IGOXhLphl0UTY9qe9qNOOk/fo1YS4xAchj9MN7d2TWhBIViph2c7YlDJZS+48x8SljmDafb+A==
X-Received: by 2002:a17:906:69a:b0:a68:e322:2996 with SMTP id a640c23a62f3a-a699fcf09bemr119498766b.36.1717577738929;
        Wed, 05 Jun 2024 01:55:38 -0700 (PDT)
Received: from localhost (fwdproxy-lla-002.fbsv.net. [2a03:2880:30ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68fa8035adsm473879666b.185.2024.06.05.01.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:55:38 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chaitra P B <chaitra.basappa@broadcom.com>
Cc: leit@meta.com,
	stable@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Wed,  5 Jun 2024 01:55:29 -0700
Message-ID: <20240605085530.499432-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a potential out-of-bounds access when using test_bit() on a
single word. The test_bit() and set_bit() functions operate on long
values, and when testing or setting a single word, they can exceed the
word boundary. KASAN detects this issue and produces a dump:

	 BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas

	 Write of size 8 at addr ffff8881d26e3c60 by task kworker/u1536:2/2965

For full log, please look at [1].

Make the allocation at least the size of sizeof(unsigned long) so that
set_bit() and test_bit() have sufficient room for read/write operations
without overwriting unallocated memory.

[1] Link: https://lore.kernel.org/all/ZkNcALr3W3KGYYJG@gmail.com/

Fixes: c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
Cc: stable@vger.kernel.org
Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changelog:

v2:
	* Do the same protection in krealloc() in
	  _base_check_ioc_facts_changes, as suggested by Keith.
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 258647fc6bdd..cc17204721c2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8512,6 +8512,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pd_handles_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pd_handles_sz++;
+	/* pd_handles_sz should have, at least, the minimal room
+	 * for set_bit()/test_bit(), otherwise out-of-memory touch
+	 * may occur
+	 */
+	ioc->pd_handles_sz = ALIGN(ioc->pd_handles_sz, sizeof(unsigned long));
+
 	ioc->pd_handles = kzalloc(ioc->pd_handles_sz,
 	    GFP_KERNEL);
 	if (!ioc->pd_handles) {
@@ -8529,6 +8535,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pend_os_device_add_sz++;
+
+	/* pend_os_device_add_sz should have, at least, the minimal room
+	 * for set_bit()/test_bit(), otherwise out-of-memory may occur
+	 */
+	ioc->pend_os_device_add_sz = ALIGN(ioc->pend_os_device_add_sz,
+					   sizeof(unsigned long));
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
 	if (!ioc->pend_os_device_add) {
@@ -8820,6 +8832,11 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc->facts.MaxDevHandle % 8)
 			pd_handles_sz++;
 
+		/* pd_handles should have, at least, the minimal room
+		 * for set_bit()/test_bit(), otherwise out-of-memory touch
+		 * may occur
+		 */
+		pd_handles_sz = ALIGN(pd_handles_sz, sizeof(unsigned long));
 		pd_handles = krealloc(ioc->pd_handles, pd_handles_sz,
 		    GFP_KERNEL);
 		if (!pd_handles) {
-- 
2.43.0

