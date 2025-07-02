Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882D01C6B4;
	Wed,  2 Jul 2025 03:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751428743; cv=none; b=Z/Mvff0FXGnfnH3MvwSsWCDRAoNPCLgf+zt6ngQDyCWlPIsdT021Rtkvq5vDV+X1yoeMk9jhU47wS8/R8MSMR+HLlUwZM8U8B3i/pvcUBq7flt2LNfRHnig3TPP4Jxr3eHgnFVe5Qw+PrGnR6RZ2zLo3280A0MqVChbCdJfmLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751428743; c=relaxed/simple;
	bh=9UrBH6sgsTmZxYydV10kbmoWyNSF9MfbgLZif68jJ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cLMlkcUiZDcDZM0XvvkFA2wn0P+YF3CkaZwPmu4hg2ugiEWG+/aBXxPcs+cSroiLcDFTsOPtQ/vpuhuPt6Ed84BcKmyVzcE+jIXGAU542Ly6kcA6LVN9bN/Su8OGPDadWc7Mapi5mkYVuMI7Pu2Ap135yqsH4bnW3EqwPctQbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkM0vpqS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkM0vpqS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23526264386so36414595ad.2;
        Tue, 01 Jul 2025 20:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751428741; x=1752033541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O/g0USg4y0OViHOr147Wq+ru//jXnDL6z9uYFIyXzTs=;
        b=jkM0vpqSyY09P9kLDbTMLm2OKx3sVB2t+GRioHPY4chQ2eN1QOh4k0Ep6RwV0Yy1FU
         y70+hNytHhw3Txu4GjeDGAYcfibRkRgLPGN9haN+vOp3PEWGrQNwV+6WOsR1qeF4qFRI
         gBG2b3RietLeh1BCWpPD9z9NPKT2BpRAtgDvnazHilL5yu291/ehxVYfxhk/afGUlTWE
         deFLir0a0yxA7TLkWygBUeMDpBuaboY+odE9E6Ey7MbJwAYtvnIMvpnJTSq4U0/XyE62
         bWI1Hz+gc8zOfEIUWlqEbMasmIWcAm4tGR17BHC80pmN/YOFFDANu8xtSkonbF59oBIL
         nQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751428741; x=1752033541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/g0USg4y0OViHOr147Wq+ru//jXnDL6z9uYFIyXzTs=;
        b=nrhgCUelD2F4oaajc13k7t6nEow0EcwBYYSXa/WTu3EzLSl+cAyq5F/66/7XiK7GJJ
         chUo8UBT4jnNJOATjMlG+NiicAxNFutH40AryWM18EGzA2bwDXiBVk6QTlGJYhIn8dbH
         Czm0kqG4pC5bjenxTnznC7f1oAErE3iaZE3C3hCe7NTBNyz3G/29EF1KEV2pONJI9Nmy
         tKPmyyRxrjw7vT8HXFxinPp/JTOQvzmCXPdadHir5IZvL50OHClXYqY9F6d1V9wVA/7e
         7fPGuqjCiM5BsFpJ4q2zqcT2/e1OAo0RXNAfjf+lUYVrHAsc8EI2161A5KXdTN2TzXVB
         7okQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy2sBcoAB45XAhwNBkFId+s4zgItHNru2lL9jtDGFHu51Aev883oLIMT6cXrYMJ5ep+50uLYTOXSya@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/AfbV0WyCJd5aVnjVbB7l+XFtbpYHwe7/FzCSRCQnlmnipQwv
	AMO7f15ahnRuOqSq128DJxdgxgQCgVoXztQq16xfgnu0Fyp0E1iqC69C
X-Gm-Gg: ASbGncvGwN16QvVkHI1vaNs6XgBxrtmGwxhC0fdXIZycGpTT0TtLIgLG64ILUwgAOXr
	VacKY1LpKwCoKSgSJmIsnF9G5RwaNaC925fPC7jNn+4zkoNv7HJRtUP8QXW6i/TosVcQfx7HcxV
	p3v0wpRZIOK3RNrsfmZHKbZvgXgXc5wXZU13NMq7Ickc+48/iRqaYqV3jICF/OJ/sTH9D4apGbe
	FebeEojMpxqP/n8wX9BM9NItyCVIDvbrkzL6poIjqhu7CgiyAn7YUL01i0YtlYRFXA7Q16H4UZz
	xddLtsP/pmeEhMISBvXqlkodz2c62jzoxGaicnYX8DJNAI1kamAQ6WBXS34k3g==
X-Google-Smtp-Source: AGHT+IGx98bxxnSOmOljPeabVSziAlzcRFf3M8M04natoa+ILhOvQOm3UACJ7qTFCkfxlBTMtAn1BQ==
X-Received: by 2002:a17:902:e84f:b0:234:8f5d:e3bd with SMTP id d9443c01a7336-23c6e5b0c27mr14084715ad.39.1751428740669;
        Tue, 01 Jul 2025 20:59:00 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3bc406sm116264955ad.195.2025.07.01.20.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 20:58:59 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E691E420A74B; Wed, 02 Jul 2025 10:58:56 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux SCSI <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Rob Landley <rob@landley.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2] scsi: Format scsi_track_queue_full() return values as bullet list
Date: Wed,  2 Jul 2025 10:58:23 +0700
Message-ID: <20250702035822.18072-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1511; i=bagasdotme@gmail.com; h=from:subject; bh=9UrBH6sgsTmZxYydV10kbmoWyNSF9MfbgLZif68jJ2A=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkp60S2NmtXx63sMV7+qrgx/3vDLT/lvWrlaaG/jyyZx 7y74rhFRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACay+Dgjw5Qv73w3ccgHRXam bXrNaVlzPTf7s3fMt58s6348MF07eTsjwx1RwymLS1s8vLI0JDs4nH+nL7PcrnxC1WvNz8S+fUL 7uAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports indentation warning on scsi_track_queue_full() return
values:

Documentation/driver-api/scsi:101: ./drivers/scsi/scsi.c:247: ERROR: Unexpected indentation. [docutils]

Fix the warning by making the return values listing a bullet list.

Fixes: eb44820c28bc ("[SCSI] Add Documentation and integrate into docbook build")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
Changes since v1 [1]:
  * Follow kernel-doc style on return list (Bart)

[1]: https://lore.kernel.org/r/20250626041857.44259-2-bagasdotme@gmail.com/

 drivers/scsi/scsi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 518a252eb6aa05..c2527dd289d9eb 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -242,9 +242,11 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
- * 		-1 - Drop back to untagged operation using host->cmd_per_lun
- * 			as the untagged command depth
+ * Returns:
+ * * 0 - No change needed
+ * * >0 - Adjust queue depth to this new depth,
+ * * -1 - Drop back to untagged operation using host->cmd_per_lun as the
+ *   untagged command depth
  *
  * Lock Status:	None held on entry
  *
-- 
An old man doll... just what I always wanted! - Clara

