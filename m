Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794120472;
	b=XVGKEetwAl5RIBGQdOTeB52E3wTuQYs1/FO8lQ2D0dj40nUeQhLzYKerq79GFOOerNLu
	 2h2ETG9BnZclOqaMBNyoXhW9AaenTxf+CafduOcVqrxwa2RimlIGlM1W+0EciR6s+53Xo
	 Tu+VopSd/OXBy9YR3fGLo9JVIUsA+C9+lkZ7l1+P4zXAekN2sl5jBh7HYo4XjJev0gR6n
	 zIDqYTRRLl8FpFRiQAFx3o5nfphtJcCrd5YJFs5cWDflzIIli8Py/gmGhlLpehXykRVjz
	 OgdbjyMZdYrPbzrjiJf7Quyg7GY4pigJ8vDg7ihlNgIlZkaECiOjFzg+JYzUfMPfoTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794120472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKZVAumh7VUy5yuq+U1sG3RMnUiZQTey/FtdDJ1Gal4=;
	b=VK5e5/U0TeVwkDMwJ8Ufd0L3x52yRfgNcTf4kHMF+fw7bKv/QP70STjj5V+xYPd+1TbM
	 9YdwdODb4PffGIJeqND/kTY6NJl1MP4kHQdxkTFm/+qz8gR1T58XcAY6ciitYaNIdZzLu
	 pCLM/KwTY4hW7YkOvJ+/mULk70QV1vhCR9rWNz82Z5o0jotMQBrqaZ3u9KLpOQmJIlOkg
	 OYk6huHSMbPHmmCuiWZsr+gs8j8M+xBQ7MxO76q8L92IfZ3P7Etv42m0TjcBTNdue/8Uh
	 343m7K8yWB3MJq7egKfxegZJO0rIW2F+myOH8NHKdUUuX5C3xigUe9C6j1cwrWfQYbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yKM0CFgs;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623A3606A31A
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 06:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 623A3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yKM0CFgs
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33fb4680717so600030eec.1
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2026 22:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794120471; x=1794725271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cKZVAumh7VUy5yuq+U1sG3RMnUiZQTey/FtdDJ1Gal4=;
        b=yKM0CFgsy3uOk0v7hg0qZnjSn0Ndk4B798CoyjTJAdcGju0+LCU7fVjHLF4GcPSQ26
         RXEYTrlsy5c2MftfSL6Ha65ta3uGXbCYR77lhkFFj6hTV+Or0XorCRHRl9dPeGEuAWgY
         mKNjdwFL5koQjaaA0FaI5gKyNB+rUTfyfdmxBbbaVDaty3Yj0EMdzI3QbAiIEdwRjm8g
         w6xhKwdRXLOMpoBRgu2iB4icwo7kNGHJ7Ag8m8krRQ3+cgvmsPRo5pvlD4QF9E+NKozm
         zsptjvz+3HAOP5IQL4vF2ezAOozp10sNF43zz9vAErXMLgcnpDS15PpJtCoCTx9Of0CD
         Vn9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794120471; x=1794725271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cKZVAumh7VUy5yuq+U1sG3RMnUiZQTey/FtdDJ1Gal4=;
        b=R43xGT1D/j2v1LU07SyvW6WwIxoN5h/4H658/qH+bMRZh1SHZNx34pbiAkNk/VySDt
         4f00xfezfWk7iY7xVar9FL7NzvOl9o1MS7YtP4M/EHYUCmMaLYMZlJt0POxVFm8Y9Odd
         hTPR0XkoqFmJDiYI2ziB9p1RFYpodC63uivk1v4i13ojP/ZmXQlZ7MBjZ7GBuYZ6TCLk
         Ig+eL7ghcIWI+3jUSPdqzvThTRQu+TKEuqyYDju3KxpWHol1MOpdYNXD4IYXmsDmsOO1
         +WO2A4PX5FmbWrG9JMq2MLaAhe4IJnotld9PT7yNq3AINEVjV0MUtvA2cUHiadc6zN7C
         0SPg==
X-Forwarded-Encrypted: i=1; AL+hErE1rsbc0MKrCXVWn87gLhVi7q0TjfGISpj3NTiGZ/gFI+wHVYClWkZXn/aqzVtTmskKFSHgXff1fekT@vger.kernel.org
X-Gm-Message-State: APuU4Z9qCxQ/pT6WmFB6VuRhwOJEzUxU+xSsILZLgspRoBUJ2yjFwCUX
	/2oj70BFvCMZW/Nnd4JkDwYypPcax5SV5cIaTlLL49+OPK4HDucDdXyw
X-Gm-Gg: AYBFou2mCoLjtSSR0oM0pFDYeXm6HLTi2nkDlpZl7RIhyS3xTXZoZbW3Pxlu2k+/1ni
	BTRNfuAJTkv9CH9GQpFdvOXvEhKcck/ph5DI/ui0t3yxkkfpnOl5z3Vmb5J51YrQJwCznnXFW0j
	P6kYhIQbhedM2PRTdWvcxajmFnaTrr0hVs0aPtNnLPuaDK9Nxii7x+dayvxumT0Zy4iyvIUmXW3
	bXq2btZ/ayO8Q7CRRSY/JT10E0L/FRBl73qetrLwNOcaUinQrFSFtGN1jNLkQsTL5u+mcAmvBOf
	dJmdksjktdXkOa8jbLb5pQuL7b4u0krdNcnDEtklarKPoNCIdBcRAF7FSNp620MNl/ws3Wimwc8
	My2kNMt7FIrWFNZmDCGmo7PnO0VBn7AE40gN6sfntgQ5i9tdM1q4Qxlrcureg8N19hBQbSfQyh8
	v5u7MLvMDrR0QCnXKoM3yCzz3Ue33uWTT/Uyy2wZGQY1/bAJN53Dvk4XA2WP8Oq3/iVfWGYA1Jv
	PYC/0TaWE1+M+qr1oaNHbRoQQnhqO/ilPkeGrZek3427xncX5bEdc2bzUMhlSTwd75HH8q1I360
	wZIupQzVygwRG1OT2pf7lw6ohK8MRSgS8jju4C2BbYyBzlCArSRuqktxVMcZjNaCj2BCIUIdvNA
	KLGjit+gBCM/RG59r+I0Q+oZbpQ==
X-Received: by 2002:a05:7301:7305:b0:369:d779:bcb8 with SMTP id 5a478bee46e88-3724fd69ac0mr1973804eec.0.1794120471293;
        Sat, 07 Nov 2026 22:47:51 -0800 (PST)
Received: from localhost.localdomain ([2406:b400:d4:acc8:a024:59b8:c312:eefd])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3726039c635sm3190224eec.0.2026.11.07.22.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 22:47:50 -0800 (PST)
From: Torra Sowmya <sowmyatorra@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: johannes.thumshirn@wdc.com,
	axboe@kernel.dk,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	outreachy@lists.linux.dev,
	rostedt@goodmis.org,
	julianbraha@gmail.com,
	julia.lawall@inria.fr
Subject: [PATCH] scsi: sd: Remove unused zone append tracepoints
Date: Sun,  8 Nov 2026 12:16:26 +0530
Message-ID: <20261108064626.5539-1-sowmyatorra@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025151702.13434-1-sowmyatorra@gmail.com>
References: <20261025151702.13434-1-sowmyatorra@gmail.com>
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

Commit 1846f308d66f ("scsi: sd: Use the block layer zone append
emulation") removed the calls to scsi_prepare_zone_append and
scsi_zone_wp_update, but left their definitions in sd_trace.h.
Consequently, sd_zbc.c still generates code and data for events
that have no remaining callers.

Remove sd_trace.h, which contains only these two events, and
remove its include and CREATE_TRACE_POINTS definition from
sd_zbc.c.

Fixes: 1846f308d66f ("scsi: sd: Use the block layer zone append emulation")
Signed-off-by: Torra Sowmya <sowmyatorra@gmail.com>
---
 drivers/scsi/sd_trace.h | 84 -----------------------------------------
 drivers/scsi/sd_zbc.c   |  3 --
 2 files changed, 87 deletions(-)
 delete mode 100644 drivers/scsi/sd_trace.h

diff --git a/drivers/scsi/sd_trace.h b/drivers/scsi/sd_trace.h
deleted file mode 100644
index cba3c0b825ba..000000000000
--- a/drivers/scsi/sd_trace.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2022 Western Digital Corporation or its affiliates.
- */
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM sd
-
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE sd_trace
-
-#if !defined(_SD_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
-#include <linux/tracepoint.h>
-
-TRACE_EVENT(scsi_prepare_zone_append,
-
-	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t lba,
-		     unsigned int wp_offset),
-
-	    TP_ARGS(cmnd, lba, wp_offset),
-
-	    TP_STRUCT__entry(
-		     __field( unsigned int, host_no )
-		     __field( unsigned int, channel )
-		     __field( unsigned int, id )
-		     __field( unsigned int, lun )
-		     __field( sector_t,     lba )
-		     __field( unsigned int, wp_offset )
-	    ),
-
-	    TP_fast_assign(
-		__entry->host_no	= cmnd->device->host->host_no;
-		__entry->channel	= cmnd->device->channel;
-		__entry->id		= cmnd->device->id;
-		__entry->lun		= cmnd->device->lun;
-		__entry->lba		= lba;
-		__entry->wp_offset	= wp_offset;
-	    ),
-
-	    TP_printk("host_no=%u, channel=%u id=%u lun=%u lba=%llu wp_offset=%u",
-		      __entry->host_no, __entry->channel, __entry->id,
-		      __entry->lun, __entry->lba, __entry->wp_offset)
-);
-
-TRACE_EVENT(scsi_zone_wp_update,
-
-	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t rq_sector,
-		     unsigned int wp_offset, unsigned int good_bytes),
-
-	    TP_ARGS(cmnd, rq_sector, wp_offset, good_bytes),
-
-	    TP_STRUCT__entry(
-		     __field( unsigned int, host_no )
-		     __field( unsigned int, channel )
-		     __field( unsigned int, id )
-		     __field( unsigned int, lun )
-		     __field( sector_t,     rq_sector )
-		     __field( unsigned int, wp_offset )
-		     __field( unsigned int, good_bytes )
-	    ),
-
-	    TP_fast_assign(
-		__entry->host_no	= cmnd->device->host->host_no;
-		__entry->channel	= cmnd->device->channel;
-		__entry->id		= cmnd->device->id;
-		__entry->lun		= cmnd->device->lun;
-		__entry->rq_sector	= rq_sector;
-		__entry->wp_offset	= wp_offset;
-		__entry->good_bytes	= good_bytes;
-	    ),
-
-	    TP_printk("host_no=%u, channel=%u id=%u lun=%u rq_sector=%llu" \
-		      " wp_offset=%u good_bytes=%u",
-		      __entry->host_no, __entry->channel, __entry->id,
-		      __entry->lun, __entry->rq_sector, __entry->wp_offset,
-		      __entry->good_bytes)
-);
-#endif /* _SD_TRACE_H */
-
-/* This part must be outside protection */
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH ../../drivers/scsi
-#include <trace/define_trace.h>
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5add..a7bdf089e142 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -20,9 +20,6 @@
 
 #include "sd.h"
 
-#define CREATE_TRACE_POINTS
-#include "sd_trace.h"
-
 /* Whether or not a SCSI zone descriptor describes a gap zone. */
 static bool sd_zbc_is_gap_zone(const u8 buf[64])
 {
-- 
2.47.3

