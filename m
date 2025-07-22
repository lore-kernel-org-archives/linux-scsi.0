Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CFE4C92;
	Tue, 22 Jul 2025 20:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753216341; cv=none; b=dEOQC25xTHgfbfzdtrDTZcaUyn6ez2wJYNqgQ4kZnxHjcmyyI4NJrKR7HutLpM44/9KHOyvYzop0YCSrX+LANj3DxqFOcCeI5mb1b1vc32LfDB+6qoGLQ4Eji+u25W/0T04cr4M9HGYOBxaoqNf3VZwYkL2jtoV2jw2FAhPf9mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753216341; c=relaxed/simple;
	bh=SiE7peuWE5Z3IZWbTyAH0/m05LSMfAM5iBmRLL4a6P0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GnEmXY2v9BoJIb6seERXyRLO3kr7Z1EJhGpXpzn2iSpLs+5hyyVLycqXsydgXX7kUoI7mB4jazsLSRN1DbCAt8hoObiTU95+h+TD6hrm+NByRfLUlU1sCgUWVEZ2U2FfEL8qAijNd+k4c48D07waOt2ils922i5jwsyMXZMxUMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ag37R/j0; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ag37R/j0"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aaaf1a63c1so45780871cf.3;
        Tue, 22 Jul 2025 13:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753216337; x=1753821137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6UwaG0Ur5ZFEJrfPoRwyrNV2Un1EmxTc/2Z33GQL6KQ=;
        b=Ag37R/j0dag34ZuVEoTQxbfIhbY01BXKTHUM/jerCGUYd5SixhVU5MwQQ3duGZUqvB
         Qm+5pG9BxLB3dCIhPyLGdzgEx+Wb6/FpLR2dpoSNGhLd9uCT5mmhUlgoqtq8G8sJC1S0
         UY4qDTkXyGJ1yBiIphN8O1JbMl/owim81+9szpc0KlXM0igKD5PP/iHmCq+JT6aFNgLG
         mRKGQA4eHyEwuYZXBmRMGHQHWjT6GJW0RBAcolt9dia86aBKZlkeTOBxPZDKF8uuot+y
         5jD2tFIM5I990pNZQelbOInNZ5edu2dIyb642eAowYiN9D4QaJGFReIPcY4zfyJJ+BuU
         lNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753216337; x=1753821137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6UwaG0Ur5ZFEJrfPoRwyrNV2Un1EmxTc/2Z33GQL6KQ=;
        b=Cfm+kBGJsKPwyJl+REWnOBelm9szT1lbtnz+lcb80W8DZbQkXI6+HPuSoRGwy8BS+Q
         NuGvQiZ1lrhBeV6cfJKk94DAceoSRH5lfiTSKvPXrJ67ywnRcK/Ci80u5kd3qxZlH0N4
         kQemK/qRBheH9yXMwqNH0gdc+VDrbhb2JaxCneNVNGMv8QEps/fTd67KF3KsCD2Wsr1A
         ubOU852XoZf7HIZx0wvUavUhrYzOzUgEY2lZyzgBRXfAdeTenIMFwotikkmd6ZvXoIfb
         VCeCpa2MWLkzkZ28jl+/OIswTZgDXDj/ZFOQFMXWcTgzXgF6khHoaDGXZy9vEw4zwd7r
         +f2w==
X-Forwarded-Encrypted: i=1; AJvYcCWxEeanu2HC23LnaCCDNosPZ9zhdV/THA4m9x+r8QX4/K7Q2DV9eQladRFtoeWQihbm09sb183wh+qWCNM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPPp/fdcv7e8gwFTSbwvOiJSXOFtH5uz0fHsvvj/OE8J5wzco7
	wF4bGJf6M/nyAXe07nPYdn1oggLsvqDgVcdiyafnbrZXn3v7yVuDeyTx
X-Gm-Gg: ASbGnctH8TAvvaB2HKsYMB4dYr5FiSVrVPeP9T3seYKWOxgK0+mI/rSbXAIlZ2ffXZU
	ZEGlfLmad+XUgBb2+MDGpI3vmhh5KrR6GoFzHLovL6tvKkaeXdOCZV8R2g+TmDuBUFTt1sp1tst
	U+MiZ7rigebEwypAhUVz8mAqgX52IJmZCxmL7X+nhVg6c5RxHGya1gNnjx1/7k1iPHPjndFw3MG
	bVipyQAi1KRSIw2o4qSJCHf1i0GOvGgM63+aCgXRSX8CX3JAgT9uNXmURK1FMrU20UCTqBSmwwE
	DrB0A2A0manrSD3v0h4d59MEMmc+rtyInlyxG2tAAgUcQdhI63n4mmc8R+jfnBB5MklS3HY/9EL
	6ADbIvayRGzZj0d7sfrTS3apkzedMkIl+tMq7sS6O4Q0jiJ3oR11KYKlNlNuVqeOYGw4yHUUUUk
	E=
X-Google-Smtp-Source: AGHT+IFZO+INRxMBea9uQnl7mVblxY5p03lyGE73I1c+ipJwqdUZwqA6J9gpYponXblEKwi+0Ghzgw==
X-Received: by 2002:ac8:5ccd:0:b0:4ab:38c1:f9a9 with SMTP id d75a77b69052e-4ae6de83addmr8039551cf.19.1753216337418;
        Tue, 22 Jul 2025 13:32:17 -0700 (PDT)
Received: from anbernal-thinkpadt14sgen2i.boston.csb ([2600:1000:b191:467c:33a8:e32c:94a8:9ef9])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4abb49c5c52sm56627991cf.30.2025.07.22.13.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 13:32:16 -0700 (PDT)
From: Andrew Bernal <andrewlbernal@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Bernal <andrewlbernal@gmail.com>
Subject: [PATCH] scsi_debug: add implicit zones in max_open check
Date: Tue, 22 Jul 2025 16:32:13 -0400
Message-ID: <20250722203213.8762-1-andrewlbernal@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`max_open` also needs to check implicit open, not just explicit
This is consistent with the logic in `zbc_open_zone`, on line 3809.

https://zonedstorage.io/docs/introduction/zoned-storage Open Zones limit
is defined as a "limit on the total number of zones that can simultaneously
be in an implicit open or explicit open state"

Signed-off-by: Andrew Bernal <andrewlbernal@gmail.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346a..0edb9a4698ca 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3943,7 +3943,7 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 	/* Handle implicit open of closed and empty zones */
 	if (zsp->z_cond == ZC1_EMPTY || zsp->z_cond == ZC4_CLOSED) {
 		if (devip->max_open &&
-		    devip->nr_exp_open >= devip->max_open) {
+		    devip->nr_imp_open + devip->nr_exp_open >= devip->max_open) {
 			mk_sense_buffer(scp, DATA_PROTECT,
 					INSUFF_RES_ASC,
 					INSUFF_ZONE_ASCQ);
@@ -6101,7 +6101,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (all) {
 		/* Check if all closed zones can be open */
 		if (devip->max_open &&
-		    devip->nr_exp_open + devip->nr_closed > devip->max_open) {
+		    devip->nr_imp_open + devip->nr_exp_open + devip->nr_closed > devip->max_open) {
 			mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
 					INSUFF_ZONE_ASCQ);
 			res = check_condition_result;
@@ -6136,7 +6136,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (zc == ZC3_EXPLICIT_OPEN || zc == ZC5_FULL)
 		goto fini;
 
-	if (devip->max_open && devip->nr_exp_open >= devip->max_open) {
+	if (devip->max_open && devip->nr_imp_open + devip->nr_exp_open >= devip->max_open) {
 		mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
 				INSUFF_ZONE_ASCQ);
 		res = check_condition_result;
-- 
2.49.0

