Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95B52F6A;
	Fri, 31 May 2024 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717178475; cv=none; b=m9R10sqBiKZxCnrHlDsGnd2V5P+KtuxXwqigqUVifNb+1WZ+6W4S8yF7LYSiker4Atk49NWy8JQ3L1qrD0/E+Y60keGUs6xqF5L1oiWsFqILDiDespNlJd01F9QTTyX9gfoOHvddR/4WZ5VEgD9HYWN4+xPi6YaYtqRv1JiHmuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717178475; c=relaxed/simple;
	bh=tao2gQx02AeKmIGyjONY5RmwcqU8wLfetOD0u4K3fTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BxwXcizAZgGQmPaoXMSoMHWMT4GbtLFXJl4wntL2v80FFBXHMMIszVtMcYNcHM/66Rz+UNjibpK2gURCkBs6k70/NM8T+UfOZFQgfPXfdbp3ukuR4dc8W5TusE0RGIETRWH3OqwTMPwFLTK+CMgsVJ6BLZ+QP3NXWMzwe2ARBRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a689ad8d1f6so43957566b.2;
        Fri, 31 May 2024 11:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717178472; x=1717783272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NLstpYo8ImkDRhndA7onVdU+VCFInAIg26uWhetlb/4=;
        b=qd50BoiellVvY9Tk518r8zO5FBNhXkhwT4/vG3zo9ti1vGS2maj5CX9n4Dj4VN+26N
         SNvL/aeZ3dFWGKGtEvKemJAvdWQWWZ3L0sGNTpPQkfhu48TnnGqY3SpNRM/bi9emCbC4
         sJfdIyDA4TC9Fke4vk91sqqD0PGr5AdWHrADw4+zN5F8gclHWcTh+uPm9l8SfqGeycpp
         79QOaWvUKk3YvEiO2//NgPfRAWROKTkN+2NpSjkdlFrA1ZshUvRragW2GbR1CBr3/4mQ
         Irrpz9OR6U+SA8PbYDQKKpokLdrt/cFdIFEfda1P7cYWnidkJI7uf9Nwij94zzac6cBl
         Fq6g==
X-Forwarded-Encrypted: i=1; AJvYcCXdRjO5sJc350rCUygN0bbS1vHWZCP0XMZz4kKnAWrVz+YJLGTt4vlOMjx/th8s9yKHClrwDxBv3fqjB080uVx7c1MBzg916/woPtzxPv21hY/7MBO9rWYny3ffob2rj3vGYu975eNcfw==
X-Gm-Message-State: AOJu0YxEWg41A9FxbtBiF3baWWsi6ww502ONDm0kcMt7naGrOy/sWLAi
	GMR3tIotiYb+N0ZOo70RbZora5swHQpGZUHCifV6vEAxllVaNlpMU86Neg==
X-Google-Smtp-Source: AGHT+IEwj0Slis4hrfiXkf85Fgrd/rBKf2ysY5uKFQK+X1tj3scLLSTZDhlMTJfDT4aeViNuRgIDvA==
X-Received: by 2002:a17:906:b0d2:b0:a5a:88ff:fe81 with SMTP id a640c23a62f3a-a6820136cd7mr180720766b.20.1717178471779;
        Fri, 31 May 2024 11:01:11 -0700 (PDT)
Received: from localhost (fwdproxy-lla-001.fbsv.net. [2a03:2880:30ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6848423bc9sm86641566b.147.2024.05.31.11.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 11:01:11 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: leit@meta.com,
	Keith Busch <kbusch@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Fri, 31 May 2024 11:00:54 -0700
Message-ID: <20240531180055.950704-1-leitao@debian.org>
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

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 258647fc6bdd..fe9f4a4175d1 100644
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
-- 
2.43.0

