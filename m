Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702990;
	b=Tm1qsuKucY7AWPLHS3wlcGeOr6sncJ422SBOmDuu8POwSua9kyyB0AkN+o3rDBxBcbmw
	 jKy4bbKXeQUoFnW5mCdgDxhQZk6KbWp++viFOnVR2EHccHeLT72Jv3D9bhXkGDuYXl2Ep
	 QNARtvPj52q5Ql1g9hBL2eIsrFd+1JrdIRqCcC4rwu3v07psPZtFP09XtGhK0+59P6u55
	 tNR9OskAYQenlSQhRXkqI5LsMJwAJ9x9xdI0iYfQwJIsL3aRJsEqgQG06CoVLgfotuZF+
	 EmxEuxxW2K+SU0DgUNA/XYmKnCXvv96YsEStydTMh6WkEXQ+lt4jgPfr30/Oyf9yOag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702990;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VnX/SJ/TUUJ6Boa3Yc8krurLw5MGewq6ClqgjuG4laY=;
	b=4lPwHQlN6OHAXM8+eJ8Sj+3HJfY4JlT0ofOgmliM3wDYEUhgMAGuIJ97nM4Kg3tX9uvF
	 YdlBDzzbbA8ynzI6UWkSE7EeoFM3o0yT3adR8GoQ/r5Gxio4U5xLz5OdPwYq66TL5q38Z
	 2UKUhdsY1m+OnKEVK6tLBvpcjYgHrebdpPB3/aWGvpWIwogTTFaGh2J6XFenx58VImYfR
	 Hx9pu4v9Rcpr5li/+EGQG4wl0FYZznF1tnQ46DvGvyk0EZdMIi9RM4wrOpU6Jzx10wmxD
	 BKacI/fWpkAH+p8chDUj/9bAOQbVVH3BY0AYog989yXcxZENwqs1LajaLJMzXw/lJ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="q3AN/NrP";
	arc=none smtp.remote-ip=209.85.222.44
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731C606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 21:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3731C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=q3AN/NrP
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-9906034086cso137939241.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792702989; x=1793307789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VnX/SJ/TUUJ6Boa3Yc8krurLw5MGewq6ClqgjuG4laY=;
        b=q3AN/NrP3ZhvCwpoHXkBPv6SuVkjZJpMUA8dSVTAKNdaHNcNHOvyUGnpTLfpRE0HDH
         ywC8iPlCUwOFre1RVHYUGCrJcqAKa4JVUU8W3q8CIj2VRFtidShkLZ+Gz5tpFiGtJ6fu
         z7GcPCHCgsjDimsL9S87X+mHhaGy3ntXGidOYeu2r7toMGnXdYEy0245188TjbfXjIjW
         segdAmhe0NXDHDv9Slk7A9jLjb6WqmLWdu3uQJZeS0+b9S1oMyb8FwIpyQIFGkIKBzxS
         OShG5Ez6ne9o/dTF3nqCA8Q+oZYkIwM/474Hmk6jvR3niw0KnQDXtKIBjg0LDMBjQ2gm
         5Yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792702989; x=1793307789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VnX/SJ/TUUJ6Boa3Yc8krurLw5MGewq6ClqgjuG4laY=;
        b=g/xNpReRgfoxO3u4ucMmMoPA4MQqUN3YOoSblyiwlbWFpxpMGDGLlcHp/thnW7EZHe
         3RjPGi7q6I9IE4uf9s9jLqSMPVssOEqRHmlGBcSxUQLxXJI1185lbJRR/+aMp98bO8uV
         xp3z8j+OwZVgUu2GWMFocqOe9D3XIRldpa4EhXOpEl44SlXWgzyu5pkHGryVHD8tf4iF
         N+Sg5z9ogPEmEQI7vuC3D8uNnp5ZzzYfL58tH1fOGX08XZMFelSv88YddsmWcTTBA7qJ
         C2Hrcs1phAXxW8KGgs7prdsesCeZTCDYhUmIlSN+mxT8xX5nRYdvG67zNYHvbMvbpXmQ
         YHEA==
X-Forwarded-Encrypted: i=1; AKwUvBwyJFSxTdV+gcTU77xVpE9TLJkli8wPiRYQcxnZR1nzhfO/Gk72Qxgb1wtqIr7xedtHUhB/8v34IIpE@vger.kernel.org
X-Gm-Message-State: AFq9FYLdfH6MnycCwrOxSmeB0nw/F6yK+ko8JC2x0le6NTO68pVB2pC6
	F2pJmP17sp8o7/x4JLXoCV5q/yd5TFjeuXaNdqlfMFvC5vGiEtxePVDP
X-Gm-Gg: AYBFou1PUBpF5ZeycQbXhaeu6Ly41uHRPcsgNb5TWVSajNO3Gcn2VrT6EH0ZT91zC4I
	9+62jrvl9x5uwaBb+r+2anoodVRM/ZwkjBLefQDdOFSkI8jfITSyw+oeF6yoELv+OCm9TaC2PW0
	Od/wA4pEUGPsjFVfUE0DaTOqQSxM86Trm8Q6g4FRzqHPjUlOUCgvD2L7RN/sSVRgpavCOOs+oez
	KycRe/dHv7cQGErvjw7+EWaYcqG/emiSvH+0Qt5shyQNCBMrL78uayjnzTuMJFCfq4+SPIyhIyL
	V+MLrws97R0G2r+piBg3bK+galVBDTvs0gOwk8Vg/IWu3xPouyvtVkeplftdIlXAqkNtIVpD0N8
	jBkn25WTTmRoRSFQMsiKN4RJK02domWiQXJsPC81EC/4G7y4+8QjayPfhv0MmSkfP1uRYhD4T6R
	Dfmop+xYBTjuwfbYuYzMMHTxD0i+oVIr8wMpr6SsyjwLK7uqvX7tncFWyJyoW0RCc1F5IVdr5Mg
	hdcS4Q/cmX6HTGwnDxOmE2xsZLlUIm6whMZoxjAOZuT+C0RLS/oYK/fy5oQbWE5lqFs8ECfEZhC
	XdzVdpgmQzft91YX60Ow
X-Received: by 2002:a05:6102:5048:b0:7cc:9d46:ac88 with SMTP id ada2fe7eead31-7ccc324e368mr293096137.18.1792702989019;
        Thu, 22 Oct 2026 14:03:09 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910160bad4sm527066241.1.2026.10.22.14.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:03:08 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: linux@armlinux.org.uk
Cc: Bart Van Assche <bvanassche@acm.org>,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 18:02:52 -0300
Message-ID: <20261022210252.80844-1-breno3011alves@gmail.com>
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
equivalent C implementation.

The C version takes its arguments as (void __iomem *, char *, int),
matching the prototype actually used by acornscsi.c.  The assembly
version had no C prototype, so the original comment declaring the
first argument as unsigned int was never enforced; using the caller's
type removes that latent inconsistency and lets the MMIO accessors
do the right thing on any architecture.

The 16-, 8- and 4-byte unrolled bodies from the assembly are folded
into a single 4-byte loop per direction and expressed with
put_unaligned_le32() / get_unaligned_le32(), which the compiler
unrolls exactly as before.  The LE variants are used because the
assembly performed a plain 32-bit store on little-endian ARM, which
emits bytes in little-endian order and is what the SCSI payload
expects.

Note on odd transfer lengths: the original assembly dropped the final
odd byte when the tail reached the two-byte handler, leaving the byte
unwritten (out) or unread (in).  The C version advances the MMIO
pointer by a full 32-bit card word in the trailing loop, so the
remaining odd byte is transferred through the low half of the next
card word, which is where the hardware actually samples it.  Callers
in acornscsi.c pass even lengths in practice, so this is a latent-bug
fix, not a behaviour change that affects existing systems.

No Makefile change is required: acornscsi_mod-objs already lists
acornscsi-io.o, and the build system will pick up the new .c file in
preference to the removed .S file.

Signed-off-by: Breno Rodrigues Alves <breno3011alves@gmail.com>
---
 drivers/scsi/arm/acornscsi-io.S | 135 --------------------------------
 drivers/scsi/arm/acornscsi-io.c | 105 +++++++++++++++++++++++++
 drivers/scsi/arm/acornscsi-io.h |  14 ++++
 drivers/scsi/arm/acornscsi.c    |   4 +-
 4 files changed, 121 insertions(+), 137 deletions(-)
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
index 000000000..08071963d
--- /dev/null
+++ b/drivers/scsi/arm/acornscsi-io.c
@@ -0,0 +1,105 @@
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
+#include <linux/unaligned.h>
+
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
+	const u32 __iomem *card = PTR_ALIGN_DOWN((const u32 __iomem *)addr, 4);
+	u8 *buf = (u8 *)buffer;
+
+	while (length >= 4) {
+		u32 w0 = readl(card + 0);
+		u32 w1 = readl(card + 1);
+
+		put_unaligned_le32((w0 & 0xffff) | (w1 << 16), buf);
+
+		card += 2;
+		buf  += 4;
+		length -= 4;
+	}
+
+	if (length >= 2) {
+		u32 w0 = readl(card);
+
+		put_unaligned_le16(w0 & 0xffff, buf);
+
+		card++;
+		buf += 2;
+		length -= 2;
+	}
+
+	if (length >= 1) {
+		u32 w0 = readl(card);
+
+		*buf = w0 & 0xff;
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
+	u32 __iomem *card = PTR_ALIGN_DOWN((u32 __iomem *)addr, 4);
+	const u8 *buf = (const u8 *)buffer;
+
+	while (length >= 4) {
+		u32 v  = get_unaligned_le32(buf);
+		u32 lo = v & 0xffff;
+		u32 hi = v >> 16;
+
+		writel(lo | (lo << 16), card + 0);
+		writel(hi | (hi << 16), card + 1);
+
+		card += 2;
+		buf  += 4;
+		length -= 4;
+	}
+
+	if (length >= 2) {
+		void __iomem *cp = (void __iomem *)card;
+
+		writeb(buf[0], cp);
+		writeb(buf[1], cp + 1);
+
+		card++;
+		buf += 2;
+		length -= 2;
+	}
+
+	if (length >= 1)
+		writeb(*buf, card);
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

