Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793095751;
	b=pn9hMooSz0kA5OonW7bgwek+K34xfIXmMLXMTudfDtBvZpEPS17XuyGPxkrxZYz6nQsR
	 JOnoFmNUCN5sIwmuzFsbmE4tYjLZCh6izUcNSqqRPTXiLM630rpisVcFcEfhzapxvSp78
	 uFk+zYdaNLCLrcymloxqc+ajMRPJbx7BqaR+ohyM7R8pgvHd9hDXqps22eBe4nUGJT56n
	 QRf9nQtRyFL+0WdWCPxHOS8D3km75QZb/CJqQO0+aJLCdiOTs+3nRy8kVzgq6DClDcJ6P
	 bJzlqP+8WO/0G4bb7EZAjdgJdcq2NS/CE5+fWTAiFcm6mRIEN5k5d785ENQEe57ZXVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793095751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1TQFPxvI9cCV2PEQR7e2VoXkM4CEOcgxtKO+kbRzJI=;
	b=0N2vbtjGD7o3y1auQCf/Vuensm595eZBk7mkhqVtNK11gWOLw7BBf78TWzZGInCgHWoa
	 OhQ4mkYZFfgtyPXKE5D6+wLBQ4s9OAofE5C2C7qdjVgw4JM3HEDxWnaHBNnQUbPBZBmm/
	 5WU92c6NU43cFczPL9n1YUDYMuu7nUvQc53m5toXyzYcs8Dv9pzpwUidfxUqvp8l5Y3Kr
	 XrCofxvQTcH2EXfSMZFK7RKiVjIQJXG0JwdUsMLwGaQkKyCrJdYLiSCcuInLdrefRIZ6z
	 x8oz+K0hhF0tmp3dECaCvhV/HOIYcRFPln22yGeO9Sf9Pdy69bSd4crBSEnyjra2TXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WBXAb0tb;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7018B606A323
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 10:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7018B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WBXAb0tb
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dfaa3fa12so576445f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 03:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793095750; x=1793700550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q1TQFPxvI9cCV2PEQR7e2VoXkM4CEOcgxtKO+kbRzJI=;
        b=WBXAb0tbp2OMhaaP88j/zfTc5TECBWNVG585+Hqxb6IR+F1Ke7PrVKASf0vdcnHk/B
         EJdNi/5SO6OWqnnJQJMm7OzH5jVX4HaPvZ+hb+3Kn/i2PmggtvY1FtYGY+KtVY8EX85n
         G8YsR/EfxvZP9FCj6ZS8A2MK1BjNxKW+1s+5Y36C4/qjUSvhSfKtVs8zbL0ltsjXF5A0
         D4+EqOL0C2KUW3l87l00LIRHw7JYkLJx/BKIVj5LsjX36A37qmGAmCLx9iJYcRccKbrg
         9EOa1dgedAWdscomLZq976N9DqtT+ZeCUIHVY+cTLCqp4Hzu7h4PbhyeXVZNq4OcBzDO
         u1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793095750; x=1793700550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q1TQFPxvI9cCV2PEQR7e2VoXkM4CEOcgxtKO+kbRzJI=;
        b=VS4nGuUbtAhD7Epp8UHXHdJz+oXOydWw1idxPosYk7vBNosmq7bcblWyLcA7IlYR1z
         ExnbtDGSABg1nyhBii/M3ha+ALIl+xK95ZIkgmisBrxAeRk/IE21IL9tv/9ak5i4LSQe
         aPncttK4z/8iSSdnOx5zpdTlstbyHrStl2xvsJbLqc+wdzW/a22wcwYKSvqVsVfj64uw
         nbePCgJ0mUZRD+4n5898uGD/LLkLfW+9zPC/Sdt0WatxhhY14jZ2XrrQAodwd0/hibnK
         EMLgVLyCDyzbXRdvwrTZJPe76RnBFeCW7z48jvEizB2JNNiJRxd9TE/85fu5gdU39s0M
         SdxA==
X-Forwarded-Encrypted: i=1; AKwUvBySdC+Ak34GHStcZ6oAhlWcs+fjSJz4zkuvxLwPSRqhKt1g3UUd4/BMoH7FiUliLEbSyeMucviYT/bA@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5t1ij643Nfr8ZCcxfI3XWbRPbJ05CBBf+q33F6pwH8tOE/YQg
	XHZi04kgronOnjVQsk4wS9A9YlNiF5YHu38W7BivX9+j7g0iASDTwUMW
X-Gm-Gg: AYBFou2O4bwNw/IDsoXx+gYr74j7w7JFq2a2GvL/T+sUeQRseFYGvqpaHVK3TwXhoIE
	/59GDW0fmP3WypczkfbUIKq62a8Bna0Vb+4erKH1lblpTFaLOSzfDdV9oaEJQilcIZyYXs36xbf
	UdsBmhkcba9CGOT1Y1cd2Vq/kvciYKNYBw/H0ELELaQeby0zS+aNIF2VDrtHkYZFP9xA2zDDsuW
	9LzESlSFVm+HnN3QJ3OvRFy6lmeMqgKwXyZ+WD8pce1sLpzk3+fhzcJSIRxImJcOKSRjVQ4oThX
	ZuNslMD4nqoYywxZ53D/nCshD20VQjw1pJ+pCjZKUorSaLy7ljvsyA9FcPECZe3ymA8qwEVvTVi
	zXcf6hYjOAIGP2Hc7oifQxMpdo5pStfkvMRpCNHrMetz77FASGtaHjmJZx+IluuT/kVx3EaQ3zp
	/ZbVqJAlC694pTDtPD9rnXc1lB8ZxVB7LMt+47GXOakq4Eo8C1QPBlhnXtph3SekscphuAvgM2p
	XS9/oyoVbmOQBBT8tCcYu8PM2W/qDncB62zqCQpyuGoH6dakcDmhj/49J1NMQInPhUi
X-Received: by 2002:a05:600c:3115:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4a7c16c5294mr46820035e9.13.1793095749477;
        Tue, 27 Oct 2026 03:09:09 -0700 (PDT)
Received: from unicorn.lan.internal ([2a0d:3341:b894:4600:8f9a:af38:72d6:7c0e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a5822a7sm266582155e9.11.2026.10.27.03.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:09:08 -0700 (PDT)
From: Giuseppe Piscitelli <ooonea@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: core: Balance the pseudo target reap reference
Date: Tue, 27 Oct 2026 11:08:50 +0100
Message-ID: <20261027100859.1031135-1-ooonea@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026202119.667348-1-ooonea@gmail.com>
References: 
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

With memory allocation profiling enabled, unloading scsi_debug reports
allocations left at module unload. A stock Linux 7.2.11 VM without OpenZFS
emitted the following on each of three load/unload cycles:

[    1.644665] drivers/scsi/scsi_debug.c:8863 module scsi_debug func:sdebug_add_host_helper has 1024 allocated at module unload
[    1.656260] drivers/scsi/scsi_debug.c:1261 module scsi_debug func:sdebug_target_alloc has 16 allocated at module unload

scsi_alloc_target() supplies a reap reference for its caller. The SCSI
device initializer takes another reference, which device removal drops.
scsi_get_pseudo_sdev() drops its caller reference only when device
allocation fails. On success the target cannot be destroyed, retaining
its driver-private data and its parent host and adapter.

Drop the caller reference in the common cleanup path, as the other
scsi_alloc_target() callers do.

Fixes: d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI device")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
---
OpenAI Codex analyzed the teardown diagnostics and wrote this fix and
its local validation. The new unpatched capture reproduces the symptom;
it does not establish which of this fix and the separately proposed
scsi_debug asynchronous cleanup fix removes each diagnostic.

Changes in v2:
- Include the allocation-at-unload diagnostics requested by Bart.
- No code changes.

Earlier validation covered four constructor/reference-count cases, a
Linux 7.3 build and three ordinary corrected-module lifecycles. The new
stock 7.2.11 run above captures the unpatched diagnostics only; no new
patched-kernel build or comparison was run.

 drivers/scsi/scsi_scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0f0f243..90e67f3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2156,14 +2156,13 @@ struct scsi_device *scsi_get_pseudo_sdev(struct Scsi_Host *shost)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
-	if (!sdev) {
-		scsi_target_reap(starget);
+	if (!sdev)
 		goto put_target;
-	}
 
 	sdev->borken = 0;
 
 put_target:
+	scsi_target_reap(starget);
 	/* See also the get_device(dev) call in scsi_alloc_target(). */
 	put_device(&starget->dev);
 
base-commit: 6a53f401e671b75c129245e371ca6e9d47fc3c9a
-- 
2.54.0

