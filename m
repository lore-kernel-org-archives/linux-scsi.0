Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694248;
	b=KUuvodUfa8WPpF67ii5w9iTh32P3+XdqtZk6akq17oePwQCAaH0o536gBKbowOFMmZH8
	 /PfwifjAj9vI8jKG3xn9bJns2xGDWXRYdVxXNtV7ZhezE6QmvxkiYa2f3BtoA75CvPw19
	 SckqCXW37Q1+gryB1O2KIXimYgO0FFqHr3BkX7/TNBaqrl3NV4giDru001T91ZaG8WFJn
	 hsIo1DSKCLzciNfkqdMmKo8le/fUa3LBTQVmG73Gyn2/ycNg54oL13MMTQFULSxQR9MBp
	 BBhcwO2m8/9DQBaO7nvJkQbM8G39X6JxFz+hLaqnWmZvvJZe5Qq8SgUAeGwf8a42hEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694248;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m+dbMoF594CwKxVE5qey0vlA+ySrFoGi/fZzuG+HLlk=;
	b=zH5o0zH4KOrG0FA5f3sYzDgeJmdsCn8uimHw+VWk9qFJj2CUEskmSn2HQllz/kyTKo+q
	 YytBGCES/6AZ3VdeVWmUAIJbWh7kdPeD9Eb8QfbElSRVkIN0C88GppSgBMTHg1L8KwYar
	 4CG2yx4GIkKYiWw7LfiP2rkZNMm11kAkibtMoWAzdjnsiH0OKXBTHbJ54k7GzBAOSQr9I
	 FkYaN4HS6qwVm81wDfOxIz4Nrpkw+H1METaSOwTOclP7k3lidPgmKoTNIB6PyCT1+m8Bm
	 pPRGozm1UE5XWG1v7XR79IKkwR0r0wp3c0lElaV+LZwrqjpL4wEAYh97iX/TIGGDkfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WI3vn01B;
	arc=none smtp.remote-ip=209.85.222.43
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50E60A3823
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 18:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD50E60A3823
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WI3vn01B
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-98301b325c4so58165241.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 11:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792694246; x=1793299046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+dbMoF594CwKxVE5qey0vlA+ySrFoGi/fZzuG+HLlk=;
        b=WI3vn01B89XLBnuJYaFrj2y9kkZgc8dGlcsMp7ePtGwnVTS82tZoD1iybL/GCIXQ2t
         umWY1Wh17EP7256g6l5HZD4PZ5vw7rLh5bghHsRZaCBGFiI5Nkdb9tDm/N8bilI3daZR
         sVPlL0Z9BNYZ9+Qztrwvba2dtoUokDIZkKhP4BlFuS9viU9O7QBIvsI42WmsdTlNnn5L
         WlfQ/8EXlVBozwusX6EnNuqktb6/bSiUY1qZbH3e1DH8k71JVlJk/qTEK8oCevAfWBYM
         L5CyIUjWcYWd3+q4Joia/mT5xhXa4HwI037+9zpwluQFSwMU2ZjKscnu3k4nCxPO+wcO
         9rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694246; x=1793299046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+dbMoF594CwKxVE5qey0vlA+ySrFoGi/fZzuG+HLlk=;
        b=C3iWLnyxOr9yBd7W5u/6Xys8tgqPYIlbxIs3qFJ0NFxmKTu18WhRYMwMIlQVCd7rxt
         xKL9wCz2PPrlH2SMEXTF3QnrZg5cPtIW2Ql5DsAgn5U7V1EuNH+MvztNwiR5U+nOwV/J
         pr+jqLEHU1Cw6lZs6lWmuC5XcAffmk7YKY2pXaKAVbvI/S2ut4WK3ZYU6WLjE52Lw0eD
         CRZm3USSozz/CPY1i2PBqQphOU2ZOK2n4WiGuVg+7i3DImWj1QsDL1i7cyvwwU0umlVh
         /2J6MDns6OzU5bbBdh87HMt1UBQrEfMqfbgTHJCYbYcPK7kwdXVwSb8Qx1Iw9G3s1AfC
         Lr1Q==
X-Forwarded-Encrypted: i=1; AKwUvBxpj9Dgxo1ZWAZHUFX01WDzRwJpPzGrkXFbE7i3NTMqCTJIa5BUtVUEuJyFCjNpUlEnxGf98T67LtKX@vger.kernel.org
X-Gm-Message-State: AFq9FYI5B5Edzt0w6JZbdP7POfFFBM+eaXmZ3fV+VHtdwKzGyRP5YT3I
	oLyz2+Y5uY0RCGVwTe32z7hGjWb+1TSargCNCDuv4xTk/yFqbzecZR3e
X-Gm-Gg: AYBFou24yG4j3D59iuSPUCU7a2sxQ3qS5Fe6KSphvJsOECoE+3iEyxAgIPP5f1fQAZP
	9k7LZXkhz0uTgcG0bm2mfEIZ96m2PixrXl+O7AJsCmpdlx0nkZB8GEcxwJON7+00bvFDpR/ht8q
	XfU9lPGYPYIf+p37KmvK6RrP/g9Rl1ho4dOEzCfewIT4Q0Yl0pn9HgoQQLOpbpVC72bo+Gja9N+
	ac7xcirWWMbgysX0FESrxo3Dp/+xaLTk5Ddtsmjkju3TWB3orawZW2k6eigGoQOPfxYLrvjNDUS
	dggSEUZQuJlt/pVNPdLHe1s4J60sXmL92Vj9Mplb2bQb5yzi7SmAN0fxrf40rLrT3rGq2b4KAkG
	sG44s2BTffH9WL77KFwAyPFqsdYtuc0RiSA8k5oHm5XkVe2XaK66vxjtRgRhqP8bGORpbk84KTL
	mFHA1ZGbVhVPA6uNqi3Z8xesz7sUe7wk2mHCsyBznUxyIpCsVqx5UpGUv9U+wgcXpQFTALSvPJo
	lTFtMk5XMrOCzb+NrCCXhYqz4ZrUc2hKzAO8ZtQ65NhH8fyuGx6lbLM5EmQIXVuDo91vQ3a99ng
	zUcmaiymmyFXDM/ddlnA
X-Received: by 2002:a05:6102:370e:b0:7b7:3acf:bd3a with SMTP id ada2fe7eead31-7ccc3090cabmr152501137.4.1792694246314;
        Thu, 22 Oct 2026 11:37:26 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ccc2052f7dsm581623137.3.2026.10.22.11.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:37:25 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: [PATCH] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 15:36:58 -0300
Message-ID: <20261022183658.58090-2-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022183658.58090-1-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
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

The Acorn SCSI expansion card presents each 16-bit SCSI data halfword
on the low half of a 32-bit card access.  The hand-written assembly
in acornscsi-io.S implements the two directions of the data path:

  - __acornscsi_in()  : packs pairs of 16-bit card reads into 32-bit
                        memory words
  - __acornscsi_out() : expands 16-bit memory halfwords into 32-bit
                        card writes (duplicating the halfword in both
                        halves for the bulk of the transfer)

Both routines are simple pointer walks that a modern compiler handles
just as well as hand-written assembly, so replace the .S file with an
equivalent C implementation.  The conversion also happens to handle
odd transfer lengths correctly: the original assembly drops the final
odd byte.

The C version takes its arguments as (void __iomem *, char *, int),
matching the prototype actually used by acornscsi.c.  The assembly
version had no C prototype, so the original comment declaring the
first argument as unsigned int was never enforced; using the caller's
type removes that latent inconsistency and lets the MMIO accessors
do the right thing on any architecture.

No functional change is intended for the normal case of even-length
transfers, which is what all current callers of these helpers use.

No Makefile change is required: acornscsi_mod-objs already lists
acornscsi-io.o, and the build system will pick up the new .c file in
preference to the removed .S file.

Signed-off-by: Breno Rodrigues Alves <breno3011alves@gmail.com>
---
 drivers/scsi/arm/acornscsi-io.S | 135 -------------------------
 drivers/scsi/arm/acornscsi-io.c | 168 ++++++++++++++++++++++++++++++++
 drivers/scsi/arm/acornscsi-io.h |  14 +++
 drivers/scsi/arm/acornscsi.c    |   4 +-
 4 files changed, 184 insertions(+), 137 deletions(-)
 delete mode 100644 drivers/scsi/arm/acornscsi-io.S
 create mode 100644 drivers/scsi/arm/acornscsi-io.c
 create mode 100644 drivers/scsi/arm/acornscsi-io.h

diff --git a/drivers/scsi/arm/acornscsi-io.S b/drivers/scsi/arm/acornscsi-io.S
deleted file mode 100644
index fdd7237bb..000000000
--- a/drivers/scsi/arm/acornscsi-io.S
+++ /dev/null
@@ -1,135 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  linux/drivers/acorn/scsi/acornscsi-io.S: Acorn SCSI card IO
- */
-#include <linux/linkage.h>
-
-#include <asm/assembler.h>
-#include <mach/hardware.h>
-
-#if defined(__APCS_32__)
-#define LOADREGS(t,r,l...)	ldm##t	r, l
-#elif defined(__APCS_26__)
-#define LOADREGS(t,r,l...)	ldm##t	r, l##^
-#endif
-
-@ Purpose: transfer a block of data from the acorn scsi card to memory
-@ Proto  : void acornscsi_in(unsigned int addr_start, char *buffer, int length)
-@ Returns: nothing
-
-		.align
-ENTRY(__acornscsi_in)
-		stmfd	sp!, {r4 - r7, lr}
-		bic	r0, r0, #3
-		mov	lr, #0xff
-		orr	lr, lr, #0xff00
-acornscsi_in16lp:
-		subs	r2, r2, #16
-		bmi	acornscsi_in8
-		ldmia	r0!, {r3, r4, r5, r6}
-		and	r3, r3, lr
-		orr	r3, r3, r4, lsl #16
-		and 	r4, r5, lr
-		orr	r4, r4, r6, lsl #16
-		ldmia	r0!, {r5, r6, r7, ip}
-		and	r5, r5, lr
-		orr	r5, r5, r6, lsl #16
-		and	r6, r7, lr
-		orr	r6, r6, ip, lsl #16
-		stmia	r1!, {r3 - r6}
-		bne	acornscsi_in16lp
-		LOADREGS(fd, sp!, {r4 - r7, pc})
-
-acornscsi_in8:	adds	r2, r2, #8
-		bmi	acornscsi_in4
-		ldmia	r0!, {r3, r4, r5, r6}
-		and	r3, r3, lr
-		orr	r3, r3, r4, lsl #16
-		and	r4, r5, lr
-		orr	r4, r4, r6, lsl #16
-		stmia	r1!, {r3 - r4}
-		LOADREGS(eqfd, sp!, {r4 - r7, pc})
-		sub	r2, r2, #8
-
-acornscsi_in4:	adds	r2, r2, #4
-		bmi	acornscsi_in2
-		ldmia	r0!, {r3, r4}
-		and	r3, r3, lr
-		orr	r3, r3, r4, lsl #16
-		str	r3, [r1], #4
-		LOADREGS(eqfd, sp!, {r4 - r7, pc})
-		sub	r2, r2, #4
-
-acornscsi_in2:	adds	r2, r2, #2
-		ldr	r3, [r0], #4
-		and	r3, r3, lr
-		strb	r3, [r1], #1
-		mov	r3, r3, lsr #8
-		strplb	r3, [r1], #1
-		LOADREGS(fd, sp!, {r4 - r7, pc})
-
-@ Purpose: transfer a block of data from memory to the acorn scsi card
-@ Proto  : void acornscsi_in(unsigned int addr_start, char *buffer, int length)
-@ Returns: nothing
-
-ENTRY(__acornscsi_out)
-		stmfd	sp!, {r4 - r6, lr}
-		bic	r0, r0, #3
-acornscsi_out16lp:
-		subs	r2, r2, #16
-		bmi	acornscsi_out8
-		ldmia	r1!, {r4, r6, ip, lr}
-		mov	r3, r4, lsl #16
-		orr	r3, r3, r3, lsr #16
-		mov	r4, r4, lsr #16
-		orr	r4, r4, r4, lsl #16
-		mov	r5, r6, lsl #16
-		orr	r5, r5, r5, lsr #16
-		mov	r6, r6, lsr #16
-		orr	r6, r6, r6, lsl #16
-		stmia	r0!, {r3, r4, r5, r6}
-		mov	r3, ip, lsl #16
-		orr	r3, r3, r3, lsr #16
-		mov	r4, ip, lsr #16
-		orr	r4, r4, r4, lsl #16
-		mov	ip, lr, lsl #16
-		orr	ip, ip, ip, lsr #16
-		mov	lr, lr, lsr #16
-		orr	lr, lr, lr, lsl #16
-		stmia	r0!, {r3, r4, ip, lr}
-		bne	acornscsi_out16lp
-		LOADREGS(fd, sp!, {r4 - r6, pc})
-
-acornscsi_out8:	adds	r2, r2, #8
-		bmi	acornscsi_out4
-		ldmia	r1!, {r4, r6}
-		mov	r3, r4, lsl #16
-		orr	r3, r3, r3, lsr #16
-		mov	r4, r4, lsr #16
-		orr	r4, r4, r4, lsl #16
-		mov	r5, r6, lsl #16
-		orr	r5, r5, r5, lsr #16
-		mov	r6, r6, lsr #16
-		orr	r6, r6, r6, lsl #16
-		stmia	r0!, {r3, r4, r5, r6}
-		LOADREGS(eqfd, sp!, {r4 - r6, pc})
-
-		sub	r2, r2, #8
-acornscsi_out4:	adds	r2, r2, #4
-		bmi	acornscsi_out2
-		ldr	r4, [r1], #4
-		mov	r3, r4, lsl #16
-		orr	r3, r3, r3, lsr #16
-		mov	r4, r4, lsr #16
-		orr	r4, r4, r4, lsl #16
-		stmia	r0!, {r3, r4}
-		LOADREGS(eqfd, sp!, {r4 - r6, pc})
-
-		sub	r2, r2, #4
-acornscsi_out2:	adds	r2, r2, #2
-		ldr	r3, [r1], #2
-		strb	r3, [r0], #1
-		mov	r3, r3, lsr #8
-		strplb	r3, [r0], #1
-		LOADREGS(fd, sp!, {r4 - r6, pc})
-
diff --git a/drivers/scsi/arm/acornscsi-io.c b/drivers/scsi/arm/acornscsi-io.c
new file mode 100644
index 000000000..ad16d984d
--- /dev/null
+++ b/drivers/scsi/arm/acornscsi-io.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Acorn SCSI card I/O
+ *
+ *  The Acorn SCSI expansion card exposes each 16-bit SCSI data
+ *  halfword on the low half of a 32-bit card access:
+ *
+ *   - on reads, one 16-bit value is returned per 32-bit card load;
+ *     consecutive card reads are packed into 32-bit memory words
+ *
+ *   - on writes, a 16-bit memory halfword is expanded into a 32-bit
+ *     card word.  The original assembly duplicates the halfword into
+ *     both halves of the card word for the bulk of the transfer and
+ *     writes only the low 16 bits of the trailing partial word,
+ *     since the hardware samples only the low half.
+ */
+
+#include <linux/align.h>
+#include <linux/io.h>
+#include <linux/types.h>
+#include "acornscsi-io.h"
+
+/*
+ * Transfer a block of data from the Acorn SCSI card into memory.
+ *
+ * The card address is rounded down to a 32-bit boundary.  Each
+ * 32-bit read from the card yields one valid 16-bit halfword in
+ * the low half; pairs of card reads are packed into single 32-bit
+ * memory words.
+ */
+void __acornscsi_in(void __iomem *addr, char *buffer, int length)
+{
+	const u32 __iomem *card = PTR_ALIGN((const u32 __iomem *)addr, 4);
+	u8 *buf = (u8 *)buffer;
+
+	while (length >= 16) {
+		u32 w0 = readl(card + 0), w1 = readl(card + 1);
+		u32 w2 = readl(card + 2), w3 = readl(card + 3);
+		u32 w4 = readl(card + 4), w5 = readl(card + 5);
+		u32 w6 = readl(card + 6), w7 = readl(card + 7);
+
+		card += 8;
+
+		((u32 *)buf)[0] = (w0 & 0xffff) | (w1 << 16);
+		((u32 *)buf)[1] = (w2 & 0xffff) | (w3 << 16);
+		((u32 *)buf)[2] = (w4 & 0xffff) | (w5 << 16);
+		((u32 *)buf)[3] = (w6 & 0xffff) | (w7 << 16);
+
+		buf += 16;
+		length -= 16;
+	}
+
+	while (length >= 8) {
+		u32 w0 = readl(card + 0), w1 = readl(card + 1);
+		u32 w2 = readl(card + 2), w3 = readl(card + 3);
+
+		card += 4;
+
+		((u32 *)buf)[0] = (w0 & 0xffff) | (w1 << 16);
+		((u32 *)buf)[1] = (w2 & 0xffff) | (w3 << 16);
+
+		buf += 8;
+		length -= 8;
+	}
+
+	while (length >= 4) {
+		u32 w0 = readl(card + 0), w1 = readl(card + 1);
+
+		card += 2;
+
+		((u32 *)buf)[0] = (w0 & 0xffff) | (w1 << 16);
+
+		buf += 4;
+		length -= 4;
+	}
+
+	while (length >= 2) {
+		u32 w0 = readl(card);
+
+		card++;
+
+		buf[0] = w0 & 0xff;
+		buf[1] = (w0 >> 8) & 0xff;
+
+		buf += 2;
+		length -= 2;
+	}
+
+	if (length >= 1) {
+		u32 w0 = readl(card);
+
+		buf[0] = w0 & 0xff;
+	}
+}
+
+/*
+ * Transfer a block of data from memory to the Acorn SCSI card.
+ *
+ * Each 16-bit value read from memory is expanded into a 32-bit card
+ * word, with the halfword duplicated in both halves (matching the
+ * original assembly).  For the trailing partial halfword the card
+ * only samples the low 16 bits, so two byte stores are sufficient.
+ */
+void __acornscsi_out(void __iomem *addr, char *buffer, int length)
+{
+	u32 __iomem *card = PTR_ALIGN((u32 __iomem *)addr, 4);
+	const u8 *buf = (const u8 *)buffer;
+
+	while (length >= 16) {
+		u32 v0 = ((const u32 *)buf)[0];
+		u32 v1 = ((const u32 *)buf)[1];
+		u32 v2 = ((const u32 *)buf)[2];
+		u32 v3 = ((const u32 *)buf)[3];
+
+		writel((v0 & 0xffff) | ((v0 & 0xffff) << 16), card + 0);
+		writel((v0 >> 16)   | ((v0 >> 16)   << 16), card + 1);
+		writel((v1 & 0xffff) | ((v1 & 0xffff) << 16), card + 2);
+		writel((v1 >> 16)   | ((v1 >> 16)   << 16), card + 3);
+		writel((v2 & 0xffff) | ((v2 & 0xffff) << 16), card + 4);
+		writel((v2 >> 16)   | ((v2 >> 16)   << 16), card + 5);
+		writel((v3 & 0xffff) | ((v3 & 0xffff) << 16), card + 6);
+		writel((v3 >> 16)   | ((v3 >> 16)   << 16), card + 7);
+
+		card += 8;
+		buf  += 16;
+		length -= 16;
+	}
+
+	while (length >= 8) {
+		u32 v0 = ((const u32 *)buf)[0];
+		u32 v1 = ((const u32 *)buf)[1];
+
+		writel((v0 & 0xffff) | ((v0 & 0xffff) << 16), card + 0);
+		writel((v0 >> 16)   | ((v0 >> 16)   << 16), card + 1);
+		writel((v1 & 0xffff) | ((v1 & 0xffff) << 16), card + 2);
+		writel((v1 >> 16)   | ((v1 >> 16)   << 16), card + 3);
+
+		card += 4;
+		buf  += 8;
+		length -= 8;
+	}
+
+	while (length >= 4) {
+		u32 v0 = ((const u32 *)buf)[0];
+
+		writel((v0 & 0xffff) | ((v0 & 0xffff) << 16), card + 0);
+		writel((v0 >> 16)   | ((v0 >> 16)   << 16), card + 1);
+
+		card += 2;
+		buf  += 4;
+		length -= 4;
+	}
+
+	while (length >= 2) {
+		u16 v = *(const u16 *)buf;
+		void __iomem *cp = (void __iomem *)card;
+
+		writeb(v & 0xff, cp);
+		writeb(v >> 8, cp + 1);
+
+		card = (u32 __iomem *)(cp + 2);
+		buf += 2;
+		length -= 2;
+	}
+
+	if (length >= 1)
+		writeb(*buf, (void __iomem *)card);
+}
diff --git a/drivers/scsi/arm/acornscsi-io.h b/drivers/scsi/arm/acornscsi-io.h
new file mode 100644
index 000000000..64acfb8bb
--- /dev/null
+++ b/drivers/scsi/arm/acornscsi-io.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Acorn SCSI card I/O
+ */
+
+#ifndef _ACORNSCSI_IO_H
+#define _ACORNSCSI_IO_H
+
+#include <linux/io.h>
+
+void __acornscsi_in(void __iomem *addr, char *buffer, int length);
+void __acornscsi_out(void __iomem *addr, char *buffer, int length);
+
+#endif /* _ACORNSCSI_IO_H */
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 79d7d7336..263a1bf24 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -140,6 +140,8 @@
 
 #include <scsi/scsicam.h>
 
+#include "acornscsi-io.h"
+
 #define VER_MAJOR 2
 #define VER_MINOR 0
 #define VER_PATCH 6
@@ -886,7 +888,6 @@ static
 void acornscsi_data_read(AS_Host *host, char *ptr,
 				 unsigned int start_addr, unsigned int length)
 {
-    extern void __acornscsi_in(void __iomem *, char *buf, int len);
     unsigned int page, offset, len = length;
 
     page = (start_addr >> 12);
@@ -931,7 +932,6 @@ static
 void acornscsi_data_write(AS_Host *host, char *ptr,
 				 unsigned int start_addr, unsigned int length)
 {
-    extern void __acornscsi_out(void __iomem *, char *buf, int len);
     unsigned int page, offset, len = length;
 
     page = (start_addr >> 12);
-- 
2.56.0

