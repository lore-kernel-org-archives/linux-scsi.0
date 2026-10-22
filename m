Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653533;
	b=QvAJg5cenZIJZpF/7NsQkP4ZLf7ZBDFrf1XZFSdpyr0VLZLvOBuaOa8oNj5UnPd55btx
	 B3Un86/A4N3HdkPR+3WFEixZ7ZCw1L+ZnoH4lVFoGDIHSiQ3IQ6rTcPpmvVxgqfr+AWha
	 aOs1XL6theMpC2x/aG0DBoGC4xrjhCb1RWsKkLNSGHlF5T8lzSqehmc7ZZOUbYhG7rPbz
	 LvM0B3ZtEvETR+12nJuoCFkRgfYXqv7woaBXsUs32Wn4aWSEChkIskB99c30PpFknoYSj
	 y1VkZqZuB9t0pdH/MMSUZ48gQaG2PFSI/RJYZYG/bcZnhmm2zidTd5RfyCHuqVYAvmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653533;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=gPiE3QWjmwTsVpl3XFuxTwOhK5xMwryQhv8LE68/7Gw=;
	b=PbZ5db7u+eaTgoDzCX/LhJMCY08ygWs3hPIy/Yr1kRnAGaTiMWiOU5Hm7ZxrbLPzR5dN
	 mRZSAa4npiNTflqB+EEsdmBTBhjzldulnOx4QTfaclhwZMOGriGHIfoqInUMswdxLcEe9
	 vf+6x8krSOJKkuFhx/VgkvaLbHcLu3oDHNB5LJQNqfMlgULbqXqpoNJieuTV5lJoS2Vjz
	 Hig7ul7n2uJ/ZEmU+1y3qMPMfQXTMSMUPtyvzJXld7E8+NVWIBycYegYokoSo11M/FYnk
	 PoIldGJGcRXT6dKm8eYhFlPpi8QrqFCTTQ82zmObsOHFMEJvyQyyShJ6rIhuyHKWTlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=LnUiiXeB;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8FD606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:18:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D8FD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=LnUiiXeB
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso801728a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 00:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792653533; x=1793258333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gPiE3QWjmwTsVpl3XFuxTwOhK5xMwryQhv8LE68/7Gw=;
        b=GqsKhJSKDTS/pRyGDNpXS3vU2YnSvPmotY4DeRy7ICC30nWC7uFWy13EfkB/oi4wq9
         tORkXtnJvGkP3wcBDzvnC2S8PShgPe5Z8+WKv2A5EldHjcMH+AmofajBy3XtzWmxwbam
         4FJnIs2MGe7i0ebB3yNXj3OqZnzplVITg/1SRcZOnsJ6GBAGvZsQVPjBIf77ggexy2Gq
         ENoPLC++IgOJkPSob2ZZ1gMXsaBxf/Jj34dYRaPEF6ULc2elxJG/t98nTGt0yd7GSWlf
         Lv0gSM5eJnGu3gbpAIteAxEVimyyvGKW6QVzhIr2TztUthHBT9HkSq6QiRn/JnHd0QM8
         Yp7A==
X-Forwarded-Encrypted: i=1; AKwUvBzvMNLYw/FhGoH1ep0F1O9B3B+UIwQ3OqYBlxMsDEbpVARL98UUdBGRdi4SnbA58mCoStHtDic/hpnM@vger.kernel.org
X-Gm-Message-State: AFq9FYIYqpSlfXqxe1y3onjy6dzpqePXIi8zJgUDGYzLBALaR1CcacnF
	J6JnIS+PZ9IR/1jvetIWPhkDUFcm3ryxZltSQINp+G7LV9hztX1JOVJdITMpSrOHc+/FfO9fqxL
	+vnagMFzPJMaN+NY8GgHJ0AYOwRwNQOnVyALctZtteD7JaN9CXJs0394hJpZftzZkB7symPOjZx
	YwSKHxUJ2bhck8Cz333dUd2GINxqhhCI+drMJcFAYlKgO9/TYuYz8HDqLgyEx09c6HLHjCdBFGs
	P8cO2NFtoBn
X-Gm-Gg: AYBFou07Qak5HxR2gTynUbfE2QkduFgivM7BcoCsxchy6G1l6vLNS8EYdSRyIxsdJwG
	1Y+5EDdDvFNBzSGuvsGS75wINNqZ9JL4AFFSUwSE7QPgNbi0YNCZ77YVWvF4b2MmpuqaEEmKHi2
	VFS3GGjR+riSndSAgrg2sx7yjuWqh7VUcdwcLE61SW8WXgF1WQ1aYdKuYmyproHexVjlkriB6Sq
	CxIQklOGfzVkt59mDt123Evf2i6MRhlHypIMXNA06lVTppPrpP7yDN0LwH6RomY5aovTT7Wf4lo
	sXIigb3qWzuRKIuaz/w+nAtj6CxlzQA/MhOvz+RTqfcZSH+Ra6qozLvcUDK60pjyI7ou+r+5rJ5
	29FUR1f+DGeZDX1T7Q5j3RenyakUSabTRTrlZjY843/ymd3SznDcYyxz4+sc5VcS0vCcmufAfza
	dB81+ctGZEQTtkFu8YAyPWdNfbXRYxKPVDQQ==
X-Received: by 2002:a17:90b:51c3:b0:3ac:9706:7739 with SMTP id 98e67ed59e1d1-3ad86f1bd90mr3104080a91.17.1792653532624;
        Thu, 22 Oct 2026 00:18:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ad8602f10asm1590030a91.1.2026.10.22.00.18.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:18:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so3959169eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 00:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792653531; x=1793258331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gPiE3QWjmwTsVpl3XFuxTwOhK5xMwryQhv8LE68/7Gw=;
        b=LnUiiXeBcWdhkli1TdvatmlNUvP8ZQu6TwBKT16lKjDzOTvangXV2lMJeaHG5f1AvN
         uHch5HLep8jkIpcMK4GZThi9+iH7CAYud4i2a68WJXwxe0I1jwEx8FjMFpTEq/63H/lR
         KWqQ+rQZ8oq2ZciZCTNdHeMvdnQs+efllJmPE=
X-Forwarded-Encrypted: i=1; AKwUvBwkVDzgkTAhejOjJGeATE1vLNCBIxJvN7UtRcrsSIVsGRucbATHho6O09nXgv8/D4geUNOVt+X28bj9@vger.kernel.org
X-Received: by 2002:a05:693c:20d0:20b0:368:c6b9:d3bb with SMTP id 5a478bee46e88-368c6b9e87bmr1870311eec.14.1792653530924;
        Thu, 22 Oct 2026 00:18:50 -0700 (PDT)
X-Received: by 2002:a05:693c:20d0:20b0:368:c6b9:d3bb with SMTP id 5a478bee46e88-368c6b9e87bmr1870282eec.14.1792653530184;
        Thu, 22 Oct 2026 00:18:50 -0700 (PDT)
Received: from matt-workstation.dhcp.broadcom.net ([192.19.38.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674198fb21sm13687638eec.23.2026.10.22.00.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 00:18:49 -0700 (PDT)
From: Matt Wang <matt.wang@broadcom.com>
To: vishal.bhakta@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: Matt Wang <matt.wang@broadcom.com>
Subject: [PATCH] scsi: vmw_pvscsi: add boundary check for cmd_map access.
Date: Thu, 22 Oct 2026 15:18:40 +0800
Message-ID: <20261022071840.8655-1-matt.wang@broadcom.com>
X-Mailer: git-send-email 2.47.3
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The context value provided by the device in a completion is used to
index into cmd_map to find the command that was completed. To prevent
out of bounds access or completion of an inactive context, check that
the context value is in-bounds and that it maps to an active context.

Signed-off-by: Matt Wang <matt.wang@broadcom.com>
---
 drivers/scsi/vmw_pvscsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..49d1950a7 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -201,6 +201,9 @@ static u64 pvscsi_map_context(const struct pvscsi_adapter *adapter,
 static struct pvscsi_ctx *
 pvscsi_get_context(const struct pvscsi_adapter *adapter, u64 context)
 {
+	if (unlikely(context == 0 || context > adapter->req_depth)) {
+		return NULL;
+	}
 	return &adapter->cmd_map[context - 1];
 }
 
@@ -550,6 +553,11 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 	u32 sdstat = e->scsiStatus;
 
 	ctx = pvscsi_get_context(adapter, e->context);
+	if (ctx == NULL || ctx->cmd == NULL) {
+		dev_err_ratelimited(&adapter->dev->dev,
+				    "Can not find mapping for context %llu", e->context);
+		return;
+	}
 	cmd = ctx->cmd;
 	abort_cmp = ctx->abort_cmp;
 	pvscsi_unmap_buffers(adapter, ctx);
-- 
2.52.0

