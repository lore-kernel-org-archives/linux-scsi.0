Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D01E0DD9;
	Wed,  6 Aug 2025 03:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754450005; cv=none; b=WCVRgNr9VY+kM8RaoYI6xx3LANCfMMeawvHtzkbB4zPpbFt03oeaAO+bjx40lSL5pXUa5bO+bTniLh/3GZ9ihFXRcd7EuGXKapa4XhPQjpFXEbwsXoorkLPXlEooCczN3n7H2TJvbwBt4HGPhvFsThogpQcMVsup7G1aKcHH8Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754450005; c=relaxed/simple;
	bh=qZpOlXy0+FLMxGS0i2zicDJ/aCVaBeS4deeu+rNTHIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=e5Llga1Rufup/7P90zg492GcqlPY6xjNDts/UmltprNd4953/HVYCLrubQ7kkO5PepRvuaEp0UmJCFZRH5xe7GxhVkteUlqgoR7zJ+uMQtTdwcMR6KQkkTFSSixBFTeuWs5zIxWnTcN4u4Ki6RSlCcvuNNEj3YjMvJSN/6tgzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICglc+gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICglc+gn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6AAFC4CEF4;
	Wed,  6 Aug 2025 03:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754450004;
	bh=qZpOlXy0+FLMxGS0i2zicDJ/aCVaBeS4deeu+rNTHIc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ICglc+gnJkGZduL1NsegLwDVIy1wQ/7DvlhGLbZq25rKhbNCNXzNvBm98kGRMn9gx
	 aQMhM7aRxOfR3ShYtTxv+sBiwxxbXSHBsDkHqKwCQHhAQqiHUEaNXzJOErywMvzm+p
	 8duA6I6M22FpRtXZo+cUIBaOHYrGZBi0q2184L9ZTpuR646KQiMFd66DLlVdUFXDaR
	 LNflt0Yg0jkiT3GGAmtrEcYa9oOqUQuH8ti23VCFzoX/Nk4PQ9sA4dbxMqDeoa4+/2
	 4yjF+/3wVNiSA37Wq2fyT6UOkTFppadpKgnd5/9bCWuXIUafOBG+eX2A/zRiSS0yB8
	 dClF+LSGXGsNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969D4C87FD2;
	Wed,  6 Aug 2025 03:13:24 +0000 (UTC)
From: Cryolitia PukNgae via B4 Relay <devnull+cryolitia.uniontech.com@kernel.org>
Date: Wed, 06 Aug 2025 11:13:16 +0800
Subject: [PATCH] scsi: hpsa: fix incorrect comment format
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250806-scsi_typo-v1-1-ec353a303b31@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAEvIkmgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDCwMz3eLk4sz4ksqCfN00k+SU5NRkY2ODZGMloPqCotS0zAqwWdGxtbU
 Awh2GSVsAAAA=
X-Change-ID: 20250806-scsi_typo-f4cdcec330c3
To: Don Brace <don.brace@microchip.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, wangyuli@uniontech.com, zhanjun@uniontech.com, 
 guanwentao@uniontech.com, Cryolitia PukNgae <cryolitia@uniontech.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754450003; l=908;
 i=cryolitia@uniontech.com; s=20250730; h=from:subject:message-id;
 bh=3UMfS7qpU8IFgDaZz/llRfgTL2TQCQqfwbCh0auXswU=;
 b=t0BXVHA8W7v/uTiulr+eQUoGrooCc5YrZ9Jky3Vn+AQOPtQopjXntJJRezHHnQGJSQtpDBsz8
 u+p9dDnL4TDAw86Gq0f/sN0tnB3BIK0rRAyU6aRLbNwL5yjlVBkgEaU
X-Developer-Key: i=cryolitia@uniontech.com; a=ed25519;
 pk=tZ+U+kQkT45GRGewbMSB4VPmvpD+KkHC/Wv3rMOn/PU=
X-Endpoint-Received: by B4 Relay for cryolitia@uniontech.com/20250730 with
 auth_id=474
X-Original-From: Cryolitia PukNgae <cryolitia@uniontech.com>
Reply-To: cryolitia@uniontech.com

From: Cryolitia PukNgae <cryolitia@uniontech.com>

Comments should not have a leading plus sign.

Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c2901393826e86c0a53c58600fa86ae..3bb7a1d9af53a9a535b4bfa34c0d1d13b5918643 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7632,8 +7632,8 @@ static void hpsa_free_cfgtables(struct ctlr_info *h)
 }
 
 /* Find and map CISS config table and transfer table
-+ * several items must be unmapped (freed) later
-+ * */
+ * several items must be unmapped (freed) later
+ */
 static int hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;

---
base-commit: 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73
change-id: 20250806-scsi_typo-f4cdcec330c3

Best regards,
-- 
Cryolitia PukNgae <cryolitia@uniontech.com>


