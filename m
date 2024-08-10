Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0997150996;
	Sat, 10 Aug 2024 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723288998; cv=none; b=aLvTrT3F04bXOmo6JsSMWWtgJCBWQaUgBlbBV/XnqVibABlBh5o2gxzXvSmn1N/kDw6Zfo63YGGRN+9+lgRfxY8Fkr2nz8MIGJSSBTpG0FumFB3Wkz1j4jHDgVIjb7gcPpegBLWdHp7VSomCmyyTh5/IIU6rsrqT9zMMpMo+nlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723288998; c=relaxed/simple;
	bh=utmyr/+lpN586NozsQ5axHslb8Qcps/cRgR3CtcF5AU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i42l+ckZD5GDgXD00EJtDeIrvkYbQn9gCywMiR3HPCnv5FDMa0ZkXUada9J5t4H91CzEIGQkT1A+yn0oi+YBqdXHT2xy8K8ZrHjuyoLRflZrDbPeA3Lyt+ErfK37sFfTf55Nap/L4dn6cDN5Hyu6Fbp+bucVlwEvS99ZUPHEl6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LOZluEWQ; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOZluEWQ"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7093f3a1af9so1727738a34.1;
        Sat, 10 Aug 2024 04:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723288996; x=1723893796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IuPM+OrkvNy7G5yohgcG7IwK+z3l6+EOtGuqEIgk3kU=;
        b=LOZluEWQn5N24AW1e2pXKJuk+NX5WyyGQ3bz928vMVjhy9XUJKtUG75Xw6N76gUHva
         cUdDQu1JeuVsLfdS/PhwDW8pdZfsrYPfKeJWk3z4uSpcDZ4mRFvUjfpUphOr+mf/Rtgp
         hpKnGmwVAPS5x/glbeTLKHjm+khZ6qfpy9vMaBZMXLe5RwlUsdLrwIK5Pwp2ZdR7KIFu
         cpTS9Fwvq/BuiPWFn+VhDKaHPykeOkuIatpOV2zNm5yJFcykfbJmuPlpAKSd456TK2gy
         rmvsG1eVMCk8Ke4mq3Q72zXhZ2ia06ex83rj5nfY2fAmryL/gigs9U4OB+1ckV2tgKZ3
         SPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723288996; x=1723893796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IuPM+OrkvNy7G5yohgcG7IwK+z3l6+EOtGuqEIgk3kU=;
        b=iO43rp0mGeAS45IStKNVIweFzcgwm0u8jp8C0PTQY8kAtH9nyCPqd6IyeoiejsEPXB
         kNM5rPBpulJ7sSkgfGRdMIDLD9QYr7c9F3CaEGkYiNyLNMm6bWYJYcmgpAuwu6PgSEy/
         3C+o5ycek/sgyHklkzyV+KUe1bX6MIBzQi4wAde1xMWjs7P+bXpanaQnpLvn7yfeqC54
         oHTOVSBgNfTPALOiQvYJA7SzrHo+uzHTtuPTqppfHHLfUZaK4N4Qp86Q+vVZWUCawiUv
         Un+UgNVyK0VxjxPlieLfVmAP6fgPJn22hp/A0Kyf0AnVwwgDsJCL5cAl3XFg/3yRGFpF
         o+Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVNnG0lg2Hdup8fmBJAYpwDJpt70kMpXKiXWuj7NoUCzqgkVCO8TTp0WPc2DHEXhqiyDveUSjPv9FoCdemxG5mcgcbX+seQud9VU8tm7J/xRUMK9oQaOEce2F6lJMnU5nyplN0OHZItUA==
X-Gm-Message-State: AOJu0YwM5DEiOmvjYDv00WtH9rDcr4SRawPItleqio/V3sASPQSUTajt
	D1QQpUVKDvYk4npLhlrCy49y3PVvw3tZ/IyuuA+iGbETNudj61b5
X-Google-Smtp-Source: AGHT+IFh392Licwbxfwuo0524rd0uQ0mP1kwO5VDQ0sRcjur1pe6s2bGAhlzY16+V/rBqGNBlSN/ww==
X-Received: by 2002:a05:6830:2b25:b0:709:449c:61d8 with SMTP id 46e09a7af769-70b6b2fcf88mr5286784a34.6.1723288995969;
        Sat, 10 Aug 2024 04:23:15 -0700 (PDT)
Received: from ubuntu.worldlink.com.np ([27.34.65.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5ab56fbsm1086964b3a.200.2024.08.10.04.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 04:23:15 -0700 (PDT)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	martin.petersen@oracle.com
Cc: Dipendra Khadka <kdipendra88@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: drivers: scsi: lpfc: Fix warning: Using plain integer as NULL pointer in lpfc_init.c
Date: Sat, 10 Aug 2024 11:23:05 +0000
Message-ID: <20240810112307.175333-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sparse reported following warnings:

'''
drivers/scsi/lpfc/lpfc_init.c:5517:32: warning: Using plain integer as NULL pointer
drivers/scsi/lpfc/lpfc_init.c:5526:32: warning: Using plain integer as NULL pointer
'''
This patch chanes integer 0 to NULL.

Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 69a5249e007a..7f012ba3edb2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5514,7 +5514,7 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
-			return 0;
+			return NULL;
 		/* Set the node type */
 		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
@@ -5523,7 +5523,7 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 		/* re-setup ndlp without removing from node list */
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
 		if (!ndlp)
-			return 0;
+			return NULL;
 	}
 	if ((phba->pport->port_state < LPFC_FLOGI) &&
 		(phba->pport->port_state != LPFC_VPORT_FAILED))
-- 
2.43.0

