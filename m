Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956D623505E;
	Wed, 23 Jul 2025 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753314893; cv=none; b=kcJpEBJRRepteVmxDnaYSc7ItokWfdwFD2ppwb93ZE08ArNcFFNtVECTQ2LSHO/b8crbkgy0Xut40gIGgJJODxYfTvwXPn2kJdYOSG6177aY8fZfzLAVr0eCLEz4x6UT6fCJIJ1ZwTnNV+8oSw6EF5St2qmzY5+a5nnwrvzaSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753314893; c=relaxed/simple;
	bh=+oDUPM5XtfqG0IypMEH3ckDWcw++baDOJdndPATMNrc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UTHwmSCEqzireUVxKYkEqcZ51eDWlVdt+6jqyNQW7mXZ+TdI9pV7fGw42PSnJD+knJNYBOeStrNxdpvtycIDIc9sXNTZZdSRYCRh2oFBVt/GAQ2rhQ4dlyJzpXQI40eE/c1tq5RAJJ9zCmxdFOQ45mG/PUI5WlVgMxmlCA1n7uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HFJebhLD; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFJebhLD"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e344e0212eso46711085a.0;
        Wed, 23 Jul 2025 16:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753314890; x=1753919690; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/E5HXVyeCGCSrpYvrMSK90oRU8ckd0JT8pGiTUv8oBo=;
        b=HFJebhLDHwWkw4cfDdlF/NRcbNLKz3RTynAtNmzBnBNW3d8t8rW7LFXCd4D4Ij9wpW
         K1rRV7F8v0QHWj8h6abRFdDUD3XYRcMUKQjXwKfGFeXxru/sHztMEjE8dNnncRMSbg2H
         OBTZuu7iNwHZl07HoqWawXd42EAPX5jV2ht06q9eq79IBb2yXsbn45hoy5YcN9T2vgW6
         pSCiIXItyE9zJsqQdl/IlbZQApWN/Hasgz6yA5MGBKVmv7DFDkJobe3iphB8n6ebln82
         tCctYhY0vuHVSBas9DNsVuzt0p8VzKly8w2QhRPf8/Tw5OpZ4+msJYP3CJTrIPU6nMDZ
         zGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753314890; x=1753919690;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/E5HXVyeCGCSrpYvrMSK90oRU8ckd0JT8pGiTUv8oBo=;
        b=G0KCss0Ptsulr8PToVtL/4WKQpV9YDuBNBub5BScTan9h63SKBdFkNOe4OZsJ2/l8V
         XN4+BA/tTN32vOKqAhOLMWpmNu3/pjDRvAmVFLH0cdz7rtQDQ15VzcGuVcNb/u3yVX4O
         H46QnFZ/9fjXGMhJuw/Cs2uo1PKUW2evpE7T5hkiuNeOF9TfHHFt1Xoo8RTJ0nZAf9TT
         aGC38nZg7aCtIZA0aV+BdzJ13qvMchSRulo/rsnMS2fK6vICKsko0WS5lj7jAMCMoGm/
         Dt6TaWEEUojlfyq/YaK5YqNhg64mUx0BMRCrLLCmWoYcxHCvsrDeUyMDwxshtGQxXVes
         xLEw==
X-Forwarded-Encrypted: i=1; AJvYcCW4gonB75SXnrF0gdemRgOBfUfcAWDmPmns8WJ748dsWrI6XQXK67xSeQzMwK9g17xh9RExXX5jDT8yHw==@vger.kernel.org, AJvYcCWcGmE0YmYnikNLqpCx8xtATXjn5+6WCFaIWGUWjbKKaw6KvLHqSnr+n/chDQPjimSw9s+IqkEjesRjNbc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3QfR3af3QmmLQ8L40FN1PgAxwUM7k+ZXDAhIldSk5O2M2xVNr
	Hacl1JrJfxRgh/J3TX0VZnE38FxzTz5lOdkjJiXUKiRBt+D7YBtJsyUk
X-Gm-Gg: ASbGnct/x8b3lCObpdeRLv18S5niz1SGKYDlVP31AGXJbiyPW8LG5FxA09RuASA3jKZ
	RBoR7YX/r/hM9jx+DKMdAOtFN2/q5cqOJEG46kPGJGl2SW+U319mUXzQFK7R6T8YiaymErwh3S+
	DRhi9qQW1tShYOt+BXwoMWTx6XxDLimiZFTsIwv8JGf6IAYj66XVVUmRhR03a8gOEvnC5fZ24f0
	AwKufthlQIpbSxWKse3zjKRdbM+iQM2AXAvx+LqPEyPv3tDWYY0abZUpqYdoMVpiQm5derTvHdo
	OdDm/1YHeh3GxuQdp5iSXQB+xXwP22+CzCG6vb3MUtXVjFI5eQnBcPtYFYcyZy69RGiPI+2UZTK
	aZNUkCOx7sg==
X-Google-Smtp-Source: AGHT+IGdrbc97XyWs2wlNrpcMrSgbt5fRXYWSfre2zuJTEVws1KdRR+IoNBb2eRx6kxE+KrHoMiPhw==
X-Received: by 2002:a05:620a:f0c:b0:7e6:2f77:1216 with SMTP id af79cd13be357-7e62f77123cmr299610685a.6.1753314890470;
        Wed, 23 Jul 2025 16:54:50 -0700 (PDT)
Received: from pc ([165.51.88.28])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e632e4e388sm22464585a.94.2025.07.23.16.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 16:54:50 -0700 (PDT)
Date: Thu, 24 Jul 2025 00:54:46 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH] scsi: ips: Quit ips_flush_and_reset() if dma allocation fails
Message-ID: <aIF2RrQZpJora09i@pc>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

dma_free_coherent() and (*ha->func.reset) need to be called only when
dma_alloc_coherent() succeed. So, if it fails, exit ips_flush_and_reset().

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Tested-by: Compile only
---
 drivers/scsi/ips.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 94adb6ac02a4..e51bfb797aa5 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4545,26 +4545,28 @@ ips_flush_and_reset(ips_ha_t *ha)
 	/* Create a usuable SCB */
 	scb = dma_alloc_coherent(&ha->pcidev->dev, sizeof(ips_scb_t),
 			&command_dma, GFP_KERNEL);
-	if (scb) {
-	    memset(scb, 0, sizeof(ips_scb_t));
-	    ips_init_scb(ha, scb);
-	    scb->scb_busaddr = command_dma;
-
-	    scb->timeout = ips_cmd_timeout;
-	    scb->cdb[0] = IPS_CMD_FLUSH;
-
-	    scb->cmd.flush_cache.op_code = IPS_CMD_FLUSH;
-	    scb->cmd.flush_cache.command_id = IPS_MAX_CMDS;   /* Use an ID that would otherwise not exist */
-	    scb->cmd.flush_cache.state = IPS_NORM_STATE;
-	    scb->cmd.flush_cache.reserved = 0;
-	    scb->cmd.flush_cache.reserved2 = 0;
-	    scb->cmd.flush_cache.reserved3 = 0;
-	    scb->cmd.flush_cache.reserved4 = 0;
-
-	    ret = ips_send_cmd(ha, scb);                      /* Send the Flush Command */
-
-	    if (ret == IPS_SUCCESS) {
-	        time = 60 * IPS_ONE_SEC;	              /* Max Wait time is 60 seconds */
+	if (!scb)
+		return;
+
+	memset(scb, 0, sizeof(ips_scb_t));
+	ips_init_scb(ha, scb);
+	scb->scb_busaddr = command_dma;
+
+	scb->timeout = ips_cmd_timeout;
+	scb->cdb[0] = IPS_CMD_FLUSH;
+
+	scb->cmd.flush_cache.op_code = IPS_CMD_FLUSH;
+	scb->cmd.flush_cache.command_id = IPS_MAX_CMDS;   /* Use an ID that would otherwise not exist */
+	scb->cmd.flush_cache.state = IPS_NORM_STATE;
+	scb->cmd.flush_cache.reserved = 0;
+	scb->cmd.flush_cache.reserved2 = 0;
+	scb->cmd.flush_cache.reserved3 = 0;
+	scb->cmd.flush_cache.reserved4 = 0;
+
+	ret = ips_send_cmd(ha, scb);                      /* Send the Flush Command */
+
+	if (ret == IPS_SUCCESS) {
+		time = 60 * IPS_ONE_SEC;	              /* Max Wait time is 60 seconds */
 	        done = 0;
 
 	        while ((time > 0) && (!done)) {
@@ -4574,7 +4576,6 @@ ips_flush_and_reset(ips_ha_t *ha)
 	           time--;
 	        }
         }
-	}
 
 	/* Now RESET and INIT the adapter */
 	(*ha->func.reset) (ha);
-- 
2.43.0

