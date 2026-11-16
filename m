Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794796784;
	b=3cWlTruTJktfuCdHmlTVLpOl1qXvhusSFZ34Gs86gaKyNBDHkhrEaLHBemr7U/IUfMBM
	 bqJPXEmM/7yvG02VKJDcKP7oUGtdiTFPdA2UA9fqeRRyAEkTSHklZoTfxMjtZdpvqa44g
	 wBGnyoOwjMUnv2y18BXVU/ViXlyGtI/f+jKwD5KJveALGeVTO8ZtheprBBIp6GqYPC8Iu
	 /0weBB2y2NSQPskV3M2D/DgXchhA6xy7PBU9rWHIqrrWovsgEFDSy1xbadB96zg4alck6
	 CGtLX7XR3ZfX6NzTENm6M2ZS6p1uPRrBoRyjyD6bW+ofADKBEi1kOK6ZKSt7Vb9xzwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794796784;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W1VDz9lyYjusMl+WyanPC/YCYkBINyyegwMMtwqSAfo=;
	b=kDinSnYqJPwj/IflRFGFJn/t1MZqudYQubJQ77f2fTSEI8DJHX7VXSQwboj/eGQGSsAV
	 Xri1ness8VUZGglKKVuTSCe3mxgF0rT3cV8X/4OsO9hAsNPPOq1vILI31QTvgaKuDMvT4
	 eMI6hTvrtq3GNq1fw5TLSaGIw5+unIO7HDCp9aG+tPisbUCIH5iSfedMElCxmKw8ZVLEy
	 s+Lz4yIiJRcK0UJ6o9l5P87Bj6C7Dr/h02KeVSdTDjt4drQBe0vzDsAwEt7aUOQLxbJ4Z
	 3qjPr3wahQQT1tgg8/Lovbo0MF43hwF3wEfyrlgPMpDFXKe4Ua915wgZD69K9dAYvcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z7gDma7P;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE108606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 02:39:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE108606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z7gDma7P
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f30660e69so285997385a.0
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 18:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794796783; x=1795401583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W1VDz9lyYjusMl+WyanPC/YCYkBINyyegwMMtwqSAfo=;
        b=Z7gDma7P5PpaLN0hhr8r/VvOPWXLIsWiR+vO2v7kNV+r4QzPBoZ34CmGj6A0RHlvUn
         cSKLubOdcQTssAoeTypaPDrHRM4j4gtOf+aULHrdtVkeAsbanmNNGZoQg93pP6DDy17R
         O+WLuL9ZTU78x3c0vSQ42M8Fm+0Nyc+Cisn76WGVD/5Pp95BQCF1CNpJTh4PdUvgw2Ij
         ZSLUPYbafUQMksZgVm5IpoKUzX00QZKaYhOxxTpCx85wXtWWmhx+PN06nxssfqnBCH/8
         9qFaqMjaw2AsFMQwak8RxhW/S/pZ6UrrvO6CouaB7C1dkF31fgn4EM0tsO2VLN2olW9o
         08QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794796783; x=1795401583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W1VDz9lyYjusMl+WyanPC/YCYkBINyyegwMMtwqSAfo=;
        b=I639h2Sa6dwgJp37tfhoYRdPEkxOySmLoxw+RT8GhLXtvdm3uELvBRSGZ0OEK8WVcH
         0Z5zTajjawe5S3usjsSQs7x/ufctlOlSBzongDbTIBe+GcLPCU+VoY6/4NOb7JmBRZJX
         iwsxf9mmQ+6kRHZllH7k8lsiY7xO96+4gFmk+C63mq0yhrlaKFlXqIs4tYZSv2v00BaF
         RXV0iV1HFmOH+XNO8dPosb9v08vtKZcsEOczlB1oipBIk56yWHB3yzPqQrjHsePGw7gn
         rVveVZCqDHWXk6iZzGTStywRtWKjG2gmFPxDpKsWfhsuFyb/2A0Uj0ulBa+ObBIMUtDv
         bbUQ==
X-Forwarded-Encrypted: i=1; AL+hErFjAvP5dL5kbA1hxXquvbqA25mKCWZfdkRlv5SSGdHbFdUWmlE/8XHLrjeBOAuXyj6X9gxZw43E/QzS@vger.kernel.org
X-Gm-Message-State: APuU4Z9d2FV0JjinOhaMIlL2BvyX0T1Dk48MFUkGFhO+V6FYs+EDXXUG
	n+zHNh1sEW3fv3IVJjDbcKASU00Ig8wpjFvbLJIGILd1ZFdVmRlWligX
X-Gm-Gg: AYBFou2mA8M3BDZtTRbv/a8jMarDlZSyAYuXE9ubA+iaeHO4NsQ1LwgtMfKe/ary+T+
	g67IE7BRjedHF3dwXlSTUj1pD2yuR/VZ6zgASmQGicuEvDtV7yglxiS+AAJ8uPm1T2rYTigFuOv
	dVQhJ4JtboRt4qcqSPtotLrVY1Dw1L2sClfH96f5VhGZyS11OrcR4ibkUXl2/uWT6v/HjZG+GNs
	FTRhGfvOuuVV+xmF9PFf3itq/67R/0KxC1WaR/W9py7EzPy28nunyQU7USxW5kdwHm65DIjIQQa
	WIW7K9ymSdZz5ryHjSgOf3ubdhO10k6W884rzUL/bFgllrEF/q+OP5/sOp8oCVBkb7T8CoQ80YC
	mjbbSKS33R5eEIqQUd6s2g7ynBIV5ofGvzBnkd4eUONk8vRO4n1tekeMPSY80C2dIlSSolCmWnq
	9JQILTZk72+3iXa8pgkpYk7HcD9857H8lkGolq65XQmA438z75yBhwptRIxGWiNlkXbeMfiBlN1
	HCTfp2wnj9Y1pEpd27Guq1nsCU7rVmPUHB/HlJSTPBfg12UR6WZksgPOrnpcY4YJ/iahHy3A/P6
	p0M0omLmvbxbOSRK7MYkKTjf017MTDBlcW6F/sW5ZEVCgIqFrLjbYqjxE6aNxoOgSDNwW+ByAjT
	fHNqTZhUgVTNDvBaJUmZ5fw==
X-Received: by 2002:a05:620a:2903:b0:947:7f9b:f839 with SMTP id af79cd13be357-9494bb706d4mr1584260985a.47.1794796782744;
        Sun, 15 Nov 2026 18:39:42 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8f92bbsm747000285a.40.2026.11.15.18.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 18:39:42 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	Nigel Kirkland <nkirkland2304@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH] scsi: lpfc: Look up the VMID entry under vmid_lock
Date: Sun, 15 Nov 2026 21:39:39 -0500
Message-ID: <20261116023939.588838-1-lcy8047@gmail.com>
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

lpfc_cmpl_ct_cmd_vmid() looks up the VMID entry for an RAPP_IDENT
response without vport->vmid_lock and takes the lock only after the
lookup. lpfc_vmid_get_appid() can meanwhile hash_del() another entry
from the same bucket under the lock. hash_del() clears the next pointer
of the removed node, so the walk stops early and misses the entry that
waits for the response. That entry keeps LPFC_VMID_REQ_REGISTER, and
the I/O of that VM is sent without a VMID tag from then on.

Take vmid_lock before the lookup, as lpfc_vmid_get_appid() does.

Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus SCSI_LPFC and W=1.

 drivers/scsi/lpfc/lpfc_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f709e5087577..af720ccdf1b6 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3613,14 +3613,13 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 		hash = lpfc_vmid_hash_fn(app->obj.entity_id,
 					 app->obj.entity_id_len);
+		write_lock(&vport->vmid_lock);
 		vmp = lpfc_get_vmid_from_hashtable(vport, hash,
 						  app->obj.entity_id);
 		if (vmp) {
-			write_lock(&vport->vmid_lock);
 			vmp->un.app_id = be32_to_cpu(app->app_id);
 			vmp->flag |= LPFC_VMID_REGISTERED;
 			vmp->flag &= ~LPFC_VMID_REQ_REGISTER;
-			write_unlock(&vport->vmid_lock);
 			/* Set IN USE flag */
 			vport->vmid_flag |= LPFC_VMID_IN_USE;
 		} else {
@@ -3628,6 +3627,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 "6901 No entry found %s hash %d\n",
 					 app->obj.entity_id, hash);
 		}
+		write_unlock(&vport->vmid_lock);
 		break;
 	case SLI_CTAS_DAPP_IDENT:
 		app = (struct app_id_object *)(DAPP_IDENT_OFFSET + data);

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

