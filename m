Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046095;
	b=G6rf2NpQCD1ihMQex0S6omXpDmkkehsj17XX8wcvn86YKkhwLe/pIlOC9kO4ZjOCTjYM
	 M5h74TvpQMYsYjPDtGeFZJD/NlpmcU21Ha0uwTomvUz4Oqx2nHk+ro7pMgxDr5AlunEzY
	 U9M99hb7A/2Ja08f24Qzuz+jNK4E7x8zACTJw1rGEANmZgZUPJey4g7EsVk4tdW9YtkPT
	 rcPLRQt/6lnDd3Ez5dk1bKuVPzVFQ9dLzEfo5IJqwxSmnzBZUss0xILM0SCLmP55MS/gE
	 smmlcZvi8hnufmhCBj167b8kAP2CcPHrxV9JkFZ0M8BOj7lMDUwggm43bTi+mA9KSPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=x6Ir9qU2xog4QfeMmCenRIHd3uFmt4x3r9jl+UO9buQ=;
	b=vweXEI+W0vG2T/TKk3rv9JNRuBVhxsoZ6EF3D6ONANVDxskwEKsNzTkPGn1+1hQ42Sr3
	 cQlAE3MDISb5QswE33B0Pz+uQiLaS+FfrRaaq6cnbYLUCXU23NIz3m++jMcgSPjJq47MF
	 eLWVSh4FCYs1pWxUiKOLtmi0bK39Sw5ez+1QfZFkW63IDPzve78Gh83hDOrUuyQPevM5C
	 SWWoQjFflA0qPgyb0U0DNYLyK5CxZPe8ZBHSqfWG8+PmTmTuWNZshcXEvKiGmcn+2f7RT
	 4oH7gMZTZEFFNwX5EmJzjvyHQ3i40ZQrfUmGe/LGN6hiA1Om38mXe5+Wzpjno0FpMiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rJHNclSh;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F406606A31D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 20:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F406606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rJHNclSh
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso2069120f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 13:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046092; x=1793650892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x6Ir9qU2xog4QfeMmCenRIHd3uFmt4x3r9jl+UO9buQ=;
        b=rJHNclShInfy+ZLUiLttISC2n55SbLNGJEM0L+D08yC8yetnKCdtZkcarSkGTk1wX2
         R3awMvbbPNCQK8pT8zGAqyPG+R2BuTEvhC0xTKMA0MQcjCLIajJSlLV560EF/ByGXd1H
         N7ed4ppqvPxsG3o2+x3wXvTr3+T5aC9qZBHaGGwVBIrbgnkdzF+vmYplRwWoMEEhxagB
         4xQ1ZQRLYl87psMxmtSQg+RF90yQ+c0HRyaEAwwoccCAEJ9WgMcMHxlhl8oliy4Gvr4D
         23AP5yX/zVnXEUkbHMxpiErVq5OpR8SnUYrcg45+PBQDYREqkA58Ba6jqhszDU5VqmR4
         U20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046092; x=1793650892;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x6Ir9qU2xog4QfeMmCenRIHd3uFmt4x3r9jl+UO9buQ=;
        b=pa0fd5XCeqBot/PWdHWdb0EI7Mg7NNPDcEnmVBhPCA9YkZYHdfEQKBNE2yB8a26gI+
         0aztA+HcN1ZoofeEmPH0pUeJYEtC3rbJc+G+THcXGVv49hgptPgJqpSPn+bST1QMbywP
         Wqk9sfPApO5KIZOtp7AMbzxUGt7wxjZ+6CiqKBvMvsBvk+XLS+glVn5PPpaae+hLWoBm
         TmFqA/OoOTDdjH+m/IhpwPaXaWYffhBjlnsKpPqXX18RqYWEiZaGTYy2GxaWz9h3HJnB
         +emI3JSky9MbLxuc/TpDvN7RqQNkoBWhwIBLBgt8QsHhW2cBMQbic9erIX+UPhyo+flK
         PW0A==
X-Gm-Message-State: AFq9FYLDlhs3BrMWJSZ3/AhGVPy+8/UDqKh/Y7o4eKnsbagWX77UscKU
	lc6vhE8/f4ca0n1pzdqgEVkgDH3Sggi2BNaMC/4ZniFhz374np/4j1c1
X-Gm-Gg: AYBFou1FPicXGoy0e9W1LloSE25cJyv9sTQjjFHDRmjNP5nld3Pu/r/EKCIyo2G0oNm
	eeI3+k5QnlvkU34F1VuEzVTE2NdPZcn9d9rZGwYx/+HDWR0Bhaz4BQBkspEJUfQD6cwCZKY8+jG
	dFAwMx6562okOvRRaZLxiR0R5TLT27PvR1SrckSLjZiuONlwKoPbf3d0auT3Op19C7OKV5JUy/w
	Q+SN5D2udJXXiuIax8SPxzFgb6sP1cqaHrVDPL5qmcbcTEtN3KGxdMhJdzWebyUJ2Sr/EIhVYI5
	iIvPmDZ6WovtjC1twHL2lZxlZ9BYunZ/wNVxUAGbiwrheeHV0LnM1Ms091Nvx929otYMFI2awyd
	6NuYAIVqQQ3rY4omzolsD+tKc7ykUCAF7bRKbCpd2JtiCaDyz6m2LDMmRic84qbhwenjSPZSAWE
	1MxWs6CjRzlEauGUbiTajWunq6eAIQAx7Hdmt1Wc89zkkzuGttD3AdLVIeMn0tjTF5yuePXG0lj
	FOVzap6PemZ5Qmgec/wWpFNN3mzlYtU+FWhValDg9LKGyHLuF0PO4HKTm9DHkK1S/c=
X-Received: by 2002:a05:6000:2312:b0:48c:557d:ab24 with SMTP id ffacd0b85a97d-48e3eb2cdbfmr14854413f8f.4.1793046092473;
        Mon, 26 Oct 2026 13:21:32 -0700 (PDT)
Received: from unicorn.lan.internal ([2a0d:3341:b894:4600:8f9a:af38:72d6:7c0e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdd5b3sm18232676f8f.53.2026.10.26.13.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:21:31 -0700 (PDT)
From: Giuseppe Piscitelli <ooonea@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: Balance the pseudo target reap reference
Date: Mon, 26 Oct 2026 21:21:17 +0100
Message-ID: <20261026202119.667348-1-ooonea@gmail.com>
X-Mailer: git-send-email 2.54.0
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
OpenAI Codex analyzed the teardown warnings and wrote this fix and its
local validation.

Earlier validation covered four constructor/reference-count cases, a
Linux 7.3 build and three ordinary corrected-module lifecycles. This
base was checked for applicability; no new build or runtime test was run.

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

