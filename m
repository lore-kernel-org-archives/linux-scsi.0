Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653550;
	b=LThT2PdPPDxC/6upFigW97kJDG6dznXrm0L4GqScnq9tU3jDiyLI68JlwVyMjedpFvgJ
	 0ct4Pwl+W/bIvoy1zZz2sh9flseNSowsVQuwMnytg5j5f/nMdzWYNjzbPBFGn0tmBcCS3
	 pqGnK+Mm/dxk57FyVNe/COHWBzPV1iMsbnRQlXRfyWNlJFK2RnGVmhlB8VdT/ekN2AoBP
	 6TUwliX4x9moaK4YSMTl/VeKuUD5GlKQWdjbZpnaUKEhNvFer0TWcFSauaTQ3LcbHqjpy
	 KgmM2CMZ8qzjjnCvyud4b6Kio4XHR/DUzRHIFskHlanc+2aDllW+PtyH8+cDevTJlzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653550;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=mb0Xuw2hsRE9Rh0sEojEm3qW3tIg9er9OBi3tNQNZUc=;
	b=Dsnt7Odb3x8WZI60LePke+Ds7JV5bfi4y8+uLRlD1RxFU05yj145RpS4jqug1XXB97LE
	 KGUNEQUMtnazQRIRzTKLTrdNJrvQaFhjkcuvlLhzjZE4PZ03Uf58zRrP+VNPeTBwll0h2
	 4nM8OlIEAE9kAhpirjZ4K2mUiNpsIMaWhZ6ZolDLCtWx2A7kDpXg13mkO+e+X/VeCH8wK
	 DAUaHIro1kpVYXoaOnH1yS3xcOEGUK+slU9PHaJ1tZGzfy7k63rI2BtScjuDTjrbYHRX+
	 d477jSwJbLJt8gCXUlrul5TZqM568NsciQWmq6kEE9zhyAcaLXeizvaRNv1qYEKRobw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Am00/wPD";
	arc=none smtp.remote-ip=209.85.219.99
Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B1606A31B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:19:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA9B1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Am00/wPD
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-917a64f28d0so8541116d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 00:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792653549; x=1793258349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mb0Xuw2hsRE9Rh0sEojEm3qW3tIg9er9OBi3tNQNZUc=;
        b=FYex0R0yQu0RaSSRsD7XpbDj5Fv7Qmn+d7nhBawXs4fVCETnD0/L5gus/q38iNw7nW
         hcI7T6EvurqyuGGtuJ5zryfroHS5dqb/EdKvABidnvZGUY8YqIEkyFUxOxI50SCwTV8t
         INRPrrXvLN+ckQAyyp3nrIK8r7LcNrxsJAYpfXBUJQJkZVJhELPNr6wjuzMix3pvyGvS
         iOj9+W1B9gdMhnXul+nuRYOXFQ4BYr+E2MzmSwI5HLkP6CvmLMCeqRHbUWM2hDwH8y6R
         y3an3lZAv2CSb5PqrgerDPdjX+GNwTNho3WPykxrg8vMFBIVhQ8FOTKJbi4zDK+MvGuu
         LHBg==
X-Forwarded-Encrypted: i=1; AKwUvBxqW+XyRNda0K1wCBDh9lCufTJA58O5VeB8MQ6H8WuDTGe4AfnKlJXijxOepCcci0I3nBIpVAblT5jn@vger.kernel.org
X-Gm-Message-State: AFq9FYKU7pA9aaGa2IzxZFuzjSxdbJLJTbqzQJTSCug1AxNjkOwvCDb1
	6b93y9ZqGqt7FXkaXDQEkI1kpEs3s/ZE4EnsLdfSBFomGJ606I1rUGpGpsZ9euaQTi+7fdTRCMb
	fvlzNeVGykuo1fZtclBBCmSEKebKc1NJ593IHuS6wWSbPJDomoFv5hfJElOkCjoGPEqyNBjjcXW
	pHY16Q4hOynSLq2tqE56ExJTEPJH42jGIFHWVH+oAbG+g/5hJpUZ6vo4iCIpHcebnokCoiV5Tb/
	JTcylQ6ZKb7
X-Gm-Gg: AYBFou3wlD2RaXsV2cX/4EdlSh6xUQIX6kbld2CXX8q0g5/OrMi7mDND7sbi8y/pzVl
	ISWsrxhfeMeNaQ5RRfl0Vf2Lq/HB7hWRfQDL0DbLpqSod4Wup57WxLoATea8r8gkRkxBOW7wUfa
	qk7sCu+wS4aj0zbDUQVdW6LgDan23R+Yno0vQQZQBCaGWTQLsqekflhf7acB7M6zDmC9qTw+Lr9
	PsLBQ13fuwTplcCURPJWnAvwOLmyLX/AIoEO7GpuHKzXjTjLTPyuPIrxGJhLzIy5cks/rnF8e5Q
	HLeHri8KpC20kymqhg6cxI0PKHT5LWV/uA8DMT/YH651IMuKgrKK0UiWoKbjYNwzyMYZWeOCUja
	9F55Xa9weEBZG+qIWmxke9c5VliCX7077Nc4qJeer1mhYaK1+rTNKNFt8Cjg5HhVyzc8DAFzGI/
	DkgiqF1Dd2gZRKbGW4c+ZIWUmczUxlmRwmWg==
X-Received: by 2002:a05:620a:2b9a:b0:93f:3834:31f9 with SMTP id af79cd13be357-93f626db0ddmr262991985a.12.1792653548663;
        Thu, 22 Oct 2026 00:19:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93f56de5a85sm74923185a.11.2026.10.22.00.19.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:19:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35a04491c56so571933eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 00:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792653547; x=1793258347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mb0Xuw2hsRE9Rh0sEojEm3qW3tIg9er9OBi3tNQNZUc=;
        b=Am00/wPDIWBGzmaaThjF2RGPXELEyDc/dNj7tCjcRmBMhTiD6lLPcluzUIZ3pvgp0a
         zoDvZ4i+0EhWSy31mFSz0trIwvSEVehCmViouaYfJ8If3ELbd1FpQV388eQOvXbAwK2g
         OTyQyyp4sEf73LbMp2eX+NziRp0EDhIy+cwh4=
X-Forwarded-Encrypted: i=1; AKwUvBwii4RpZtdlAUA5LB4POW/XSid7toGsnN+SCBZgV3ca0Q6QQSqbkx1WJoLb7pdC/afoXBAj2BkzROYR@vger.kernel.org
X-Received: by 2002:a05:693c:8809:10b0:359:fb64:11d7 with SMTP id 5a478bee46e88-368af69cd3dmr2002276eec.11.1792653547246;
        Thu, 22 Oct 2026 00:19:07 -0700 (PDT)
X-Received: by 2002:a05:693c:8809:10b0:359:fb64:11d7 with SMTP id 5a478bee46e88-368af69cd3dmr2002239eec.11.1792653546572;
        Thu, 22 Oct 2026 00:19:06 -0700 (PDT)
Received: from matt-workstation.dhcp.broadcom.net ([192.19.38.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367411b4145sm15650049eec.15.2026.10.22.00.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 00:19:06 -0700 (PDT)
From: Matt Wang <matt.wang@broadcom.com>
To: vishal.bhakta@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: Matt Wang <matt.wang@broadcom.com>
Subject: [PATCH] scsi: vmw_pvscsi: clamp on e->dataLen in pvscsi_complete_request
Date: Thu, 22 Oct 2026 15:18:58 +0800
Message-ID: <20261022071858.8674-1-matt.wang@broadcom.com>
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

When calculating the residual bytes, clamp dataLen to the buffer length
before the subtraction. This prevents an overflow if the device sends a
larger value than expected.

Signed-off-by: Matt Wang <matt.wang@broadcom.com>
---
 drivers/scsi/vmw_pvscsi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..8e2c1b20f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -548,6 +548,8 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 	struct completion *abort_cmp;
 	u32 btstat = e->hostStatus;
 	u32 sdstat = e->scsiStatus;
+	u64 data_len = e->dataLen;
+	u32 data_trans = 0;
 
 	ctx = pvscsi_get_context(adapter, e->context);
 	cmd = ctx->cmd;
@@ -590,15 +592,16 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 			 * returns zero dataLen with non zero data - do not set
 			 * residual count in that case.
 			 */
-			if (e->dataLen && (e->dataLen < scsi_bufflen(cmd)))
-				scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			if (data_len && (data_len < scsi_bufflen(cmd)))
+				scsi_set_resid(cmd, scsi_bufflen(cmd) - data_len);
 			cmd->result = (DID_OK << 16);
 			break;
 
 		case BTSTAT_DATARUN:
 		case BTSTAT_DATA_UNDERRUN:
 			/* Report residual data in underruns */
-			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			data_trans = min_t(u64, data_len, scsi_bufflen(cmd));
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - data_trans);
 			cmd->result = (DID_ERROR << 16);
 			break;
 
-- 
2.52.0

