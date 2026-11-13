Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587147;
	b=dcTQJ3Zd8ckxuKAO1gIrt1xZTnjFXgPs1xvYCAeG+DldUKVgxVt6wbXqJUaEUSRHyrh8
	 HLC7RLvDYLvOPS90UEA9Pcld7qGJ/Z6idLNKj4+LMyR98mVmqkdAUZWzoIIE0+M91pY8j
	 IK0TEsDRdW+DNpF2fA5CZ6pWu77+tp19wYY/OxPPPq1EOMcXcRXTfQTIfeAC0sqkAazTr
	 L/vWAPCjGaKKGYclX2fksjTZ5RaaeTJGeOMZsB1Xz1ZjO3YejWCkfLXfqk2HYr3cE/SzH
	 +f+FLTabU4QeV7UWM+J9FQffEXtuYANKsldJirfP4Rt/WNFUkUgTkl0q7jbRF+P1uWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UBaROJez7pNp/JJU9doXAN32l9sh+oAK5l3zeHDvhjo=;
	b=R85f0LTvNmYuJUjvzd+CO8n9sg+J81nFelPwxikE/UD0zXm5O6WlAzdSGFFOVJJ5dR7C
	 3PiuH8ozBShHrYCLOWjhjsDEc+dhjBoj+wIrqz3ok6kh9D4B6avQxqwPctEIG6Afhfs3B
	 SqjYGhhTIrJwVRNPd9hwp3KIVaB06Xl19mpCrWIZFxN1Qg+gd2FHbJUtFMeA8niRZT/Ew
	 0o1IdcOGnv8DO/pLXZD2tP2njGJVOg5BNML5jBGb3EBIg6SCSCIT7itPVahfDMwgjqkPp
	 cHoBCkCXeRP9OaP7MFqyI4aq0ERe2EvDJfMf1nymD2YIUWm84YYpxOm7NI4bZ1zxApA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u4a2hNq7;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCD3606A8A5
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 16:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCCD3606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u4a2hNq7
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so595085b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 08:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794587146; x=1795191946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UBaROJez7pNp/JJU9doXAN32l9sh+oAK5l3zeHDvhjo=;
        b=u4a2hNq7+gVeqxfL+84E6F7KwiRUyPoR91hiBdY2qM8DxWAyg3tET1mMhmqOSKtc9+
         mzt8JZRDlfvhnGapQY2Iz047j5NjageUO8JbpcqES5vz8F/tsrTvC6cPB8RiaI0iAhd5
         RIjJz9X61Hw9YEioLHCthFU6g8aoX+Nw67AiVFxfCHaxQ6DOx7G2aoRUET1pd/zBXIs5
         e1r8tPMiinH18TFy7ylEKhNVAIsBazBhx4W4CI+lfBayz2iPtk2FsJkt4wqBPdZT4tBU
         RuHvnQKOoXqqQNUiKoYzpQLk596pZuD7ohVMij0ZwbZVwteLpsJzbH4M7lwcFVPBUfTo
         0JNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794587146; x=1795191946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UBaROJez7pNp/JJU9doXAN32l9sh+oAK5l3zeHDvhjo=;
        b=BJcVzLxufL8ORjnyu1FIcjbrhjvKSUC3gZAX2j3Wmwu0ZG1iReJHNYHHIPkdGu+SKF
         mtMClDBzT4w/YGb+IX48A15Pb3SGxYBqStmo9J90SVMUFikJeBPlb/t0FraqOVgKDlPI
         RLQJe5n4rwvfmQn1PDrF7BW/JGryCN427RjwjD8neBishk9GswC6bLkS+s6CbzIXXP35
         Hkv3dKow1ay/JCld22SsGwAqvINIfDoZ9XSGgu4lkYPdkkS3O6K6XGAq7Lj9OgR8XnRP
         qXFAfWLecfNUdr0fjJisunEtFD2C40d3O3ITFcx24ZYLFETdOOT0T7K+hIoaUm0xEA/u
         dO7w==
X-Forwarded-Encrypted: i=1; AL+hErHIUWfBySdhNUo9jjAWTBIV4T8ZkXsAFechpZoaCmb7P3JOeqd0n+CdKfEp/DJ4a4FQ1RYXCoTYJ2On@vger.kernel.org
X-Gm-Message-State: APuU4Z+nW65pMJbIFpeYjFIVRtF284zedhmkb2DE/iyZ5uyVHWHZ2Lz4
	FOVNoIfQ5XDzjjPOWK+pbzjRfdga6HxS9idJ8fxjVLIk0EPOdoSTwjiR74TM6fbqwD4=
X-Gm-Gg: AYBFou3U7CtYRNVVGy/UJIYLUhnXB7vIpMQxxHxkEqLt2bEjieBdsi5zyvR6Ri+TzsN
	v2UARk64PFv/uzi4Q0RNyaO+GkTqBwO4QC5Ub2wuJq7+E06jhDsgYCjHcDUsDOtWz+FL/9rfqe+
	gh0zzqLXAni0+KDtINqvPAHrA1MOqX6HfwqhYLeSnZpvrqbpenRUIS6FUN6xE1e+1C3s6LaGkva
	2kj8YEQwkx3NaXDpXr1gvJu5NtvtwNFGom10E0o/jF071MUrwic3KIam2ZU8VSQFHOIHHIxEQmx
	MEUgMDaat0xox+Eqsttkb6ubc35ns63eSUQbSRSF2spdjeVSinN9z8gG0VWD2sTOrHOD8P3W0rT
	RLaM2o5IbvsobWNq4c6dZM/uRFQ4XRZMNsjEH5RouAl7hRe2ztjmpPHeZh1n/ZoY+Um/1mePLw7
	PDeJcdXWmL82JkqDu0wgnAieA53/TfQSHdTPa/Rh8M/Ywul13AU26+I6SIsy0hyEpOzih+KXA9v
	0N/xCc0E9sZNrqFhDehS9TCMbfHTip60vG6W1WompmLyF3xXV2lq8yi0eJbaUea/BLQfF9W0+k7
	d8iv/vG9Pg84S0ta/9k=
X-Received: by 2002:a05:6a00:3985:b0:87d:cc3d:fad4 with SMTP id d2e1a72fcca58-8beb753d183mr2710685b3a.54.1794587146024;
        Fri, 13 Nov 2026 08:25:46 -0800 (PST)
Received: from oslab.. ([101.6.42.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed243c34dsm1376800b3a.41.2026.11.13.08.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:25:45 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH] scsi: megaraid_sas: Fix NULL pointer dereference in megasas_complete_cmd()
Date: Sat, 14 Nov 2026 00:25:24 +0800
Message-ID: <20261113162524.162899-1-islituo@gmail.com>
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

MFI_CMD_LD_READ and MFI_CMD_LD_WRITE commands can be submitted through the
management ioctl interface, where cmd->sync_cmd is set and cmd->scmd is
NULL.

However, these commands bypass the sync_cmd check in megasas_complete_cmd()
due to their placement after the fallthrough statement. As a result, the
completion handler may dereference cmd->scmd, leading to a NULL pointer
dereference.

Move the MFI_CMD_LD_READ and MFI_CMD_LD_WRITE case labels before the
sync_cmd check so that synchronous commands are handled by
megasas_complete_int_cmd().

Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 602173fd313a..5e1aeec96a4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3635,6 +3635,8 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		break;
 	case MFI_CMD_PD_SCSI_IO:
 	case MFI_CMD_LD_SCSI_IO:
+	case MFI_CMD_LD_READ:
+	case MFI_CMD_LD_WRITE:
 
 		/*
 		 * MFI_CMD_PD_SCSI_IO and MFI_CMD_LD_SCSI_IO could have been
@@ -3646,10 +3648,6 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			megasas_complete_int_cmd(instance, cmd);
 			break;
 		}
-		fallthrough;
-
-	case MFI_CMD_LD_READ:
-	case MFI_CMD_LD_WRITE:
 
 		if (alt_status) {
 			cmd->scmd->result = alt_status << 16;
-- 
2.43.0

