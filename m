Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199A1CD15;
	Fri, 28 Jun 2024 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594374; cv=none; b=bkBgLuituBg3Wu3GXgs26a8w+BPhTdnWgzahmfZlt6XFKhVGvQtsZsUbmXIWacZeRKD4Aqn7IaQcYxp/pwI9B1zoBPNmiEGn6RDk4zFGw03bye3nEEJ6svcOPOga0FhYyc/Lil8+JRpfwTlK+5GUrtEkZur5w9VPdNkhe7LipUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594374; c=relaxed/simple;
	bh=Cljtgd/Isf+l3B0F4sdoVRtTN7f2sCDFmMMfEfMfYJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A+/fJqsGXUqYjeKF2UPZ01uwqfjUKxNfYe1oRg65Jaa/0JBoc4YZuCFBO+mBIiRyjY/OfsVukkAP1oRLJqe0TL2c6Hg5ArZoQIHV0QiVvdac3HBHQAWtYJPEKj9YdPub8O+nIOh196P9p0yfNtdA33BO5vKFpsa5jp8tkt4SIY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcH/SngH; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcH/SngH"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6c386a3ac43so131282a12.0;
        Fri, 28 Jun 2024 10:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594372; x=1720199172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gIvSZMXVhoGcZvS7xN6Z8l1Ej0EBODeUmgZswcD1Zo=;
        b=RcH/SngHr4bwCNz9ZLOJPgQ05hc5DXqBHSi/BxLur4QqOlYn1QOwcFymRmJOg+xJ9u
         o3bqKzs8Q2dQetfO4svKN65cQ56B/+2WIjma+Gm7PZJTI6nXy0w2sHM+DWozFT2NJtR3
         S5VM00m522xxwfoU2Agn8+QcuQlwsRyvBZmKcGpnxSTOar3hnDUojEc4khZuHhzcNHhT
         7fgWB/J0b7Xs3dSxgeSbM1CUVsICvG2llJbHDydJXxyjwLxRG6qFSBZsDdM6ahSeASE3
         Vif4wp4li7SzrOWnmV8uVcLSnT0i6dUOIenGO0gCQ3dxwJqHdY9deQxSjKaKuU7p3CTL
         cgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594372; x=1720199172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1gIvSZMXVhoGcZvS7xN6Z8l1Ej0EBODeUmgZswcD1Zo=;
        b=l8lAcQxzVRS/+W239MUNEGnp7wOcPUgXxcHO8vPoWRQ9NVjfJZ4sNkj6GUKhzJhp84
         Wfwza+vOVxsrTZU7Q9WvIUNsCqAsbPHSJVPFvpa/y4E+8N628HiFggJ2P1QR1wThCnAI
         odjRL7620562tWyjKietkICBz440jt4Li5BA9uxG3dwMDV1hawEbw+6z5mw3QmGv4JBu
         MPoWiBkR9qvzv4CvWko/Yis6GYYerm81R4D28/DqqfhnQ6RUCP0VuIPdd91oJK6dDA/a
         nuQxI2PS6GA4vGVlTZtH/rgkjykEDNkx/c95LEQlmmEsQFk7MLg626dC/d1fz1KgqxMW
         ePBA==
X-Forwarded-Encrypted: i=1; AJvYcCVpnciFhJ72QVAzxhzx6h1BKzP/WGCDSdrH8lLazyBneJTlksRm2Cc4JtAOaLAtAe72vvCrFw0shnG5+6QdJGKjVRZfGKRB
X-Gm-Message-State: AOJu0YzGXRcXPZvoHL+QjVT8N59tNCXGrqgFx0JGnZUK3H7g5/E69H2L
	JRGqpTD2GRYxiXUKoFjlnU5dgS5yugK1B6Lzj7b/VgJWs8LuQPkMLgB6wA==
X-Google-Smtp-Source: AGHT+IGHw5BYsgW0Inrz0ttKbYVGPKT9eE46X1A1MfpGT80g/5Fhiz8+hURvFuC0dSof0ndxOA9HiQ==
X-Received: by 2002:a05:6a21:33aa:b0:1be:c3fc:1ccf with SMTP id adf61e73a8af0-1bec3fc1f10mr8465436637.2.1719594371967;
        Fri, 28 Jun 2024 10:06:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:11 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/8] lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state
Date: Fri, 28 Jun 2024 10:20:05 -0700
Message-Id: <20240628172011.25921-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Certain vendor specific targets initially register with the fabric as an
initiator function first and then re-register as a target function
afterwards.

The timing of the target function re-registration can cause a race
condition such that the driver is stuck assuming the remote port as an
initiator function and never discovers the target's hosted LUNs.

Expand the nlp_state qualifier to also include NLP_STE_PRLI_ISSUE because
the state means that PRLI was issued but we have not quite reached
MAPPED_NODE state yet.  If we received an RSCN in the PRLI_ISSUE state,
then we should restart discovery again by going into DEVICE_RECOVERY.

Fixes: dded1dc31aa4 ("scsi: lpfc: Modify when a node should be put in device recovery mode during RSCN")
Cc: <stable@vger.kernel.org> # v6.6+

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 153770bdc56a..13b08c85440f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5725,7 +5725,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 				return ndlp;
 
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
-			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
+			    ndlp->nlp_state <= NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
 							NLP_EVT_DEVICE_RECOVERY);
 			}
-- 
2.38.0

