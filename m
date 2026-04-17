Received: from mail.hugovil.com (mail.hugovil.com [162.243.120.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B472FE58C;
	Fri, 17 Apr 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.120.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776456463; cv=none; b=Yn2BBk6Gtf8V46nqN5lqI0MW1rvNfD78GbMgYyjqp9Iwof/m3s9ZctM2f+vYXYNi5E25cUMcurmePWALdfLSn9r0DqyS4Pqt2b+FQAt9rlPk76ZstxGMvQwl0IAIld1nMDb9EVbzM1Yh4WrwbYpsobHNiSZYSzdGasawz2dE0tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776456463; c=relaxed/simple;
	bh=r3dcpzUTyZ3Ll/+6lC35ys6Pz2enClcuWS7OKYhJLig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eK7xRTjV0+a4pNAg3VeRLfl0ISwXEvDZZ6A9yRES26XNXyq5HVv3uDrulhQm3KqscbOZk7UthX8K8lcD/7chGAiNTygVAFXSLohpu8+SETA6mJLs4iCsCoZL0r1NjUseqSxXAbH+eYq7zLaCk5j6VP0OHyWWYxqdT0aUrT72t5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hugovil.com; spf=pass smtp.mailfrom=hugovil.com; dkim=pass (1024-bit key) header.d=hugovil.com header.i=@hugovil.com header.b=TexcsiXU; arc=none smtp.client-ip=162.243.120.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hugovil.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hugovil.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hugovil.com header.i=@hugovil.com header.b="TexcsiXU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hugovil.com
	; s=default; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
	:Cc:To:From:subject:date:message-id:reply-to;
	bh=XSNjjT78S1FdDsqZ9Z8cpbJxB/sRGvX8KExpQlqxhyM=; b=TexcsiXUKCg/tb79uxyjz/vR0e
	rYnw76vhXN9i6tDJHjqLsJDH/lSox+BJ6Kh90++z0AHnfDTT0fF2i6ubbDddD+RthHIIYi1lmVLsL
	JG/OS1hViKlVaIGtlJXXdwXnxXEdoTvBGOzyje90Qeue2sexGRlJeKGfVEhUEOSuH6cQ=;
Received: from modemcable168.174-80-70.mc.videotron.ca ([70.80.174.168] helo=pettiford.lan)
	by mail.hugovil.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <hugo@hugovil.com>)
	id 1wDpTY-000000008IR-28Gj;
	Fri, 17 Apr 2026 16:07:40 -0400
From: Hugo Villeneuve <hugo@hugovil.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hugo@hugovil.com,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: Fix typos in comments
Date: Fri, 17 Apr 2026 16:07:31 -0400
Message-ID: <20260417200738.3920001-1-hugo@hugovil.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam_score: -1.0
X-Spam_bar: -

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

Fix typos in structure comments.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
---
 drivers/scsi/pmcraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 9f59930e8b4fd..cd059b7599b4c 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -657,7 +657,7 @@ struct pmcraid_hostrcb {
  */
 struct pmcraid_instance {
 	/* Array of allowed-to-be-exposed resources, initialized from
-	 * Configutation Table, later updated with CCNs
+	 * Configuration Table, later updated with CCNs
 	 */
 	struct pmcraid_resource_entry *res_entries;
 

base-commit: 59bd5ae0db22566e2b961742126269c151d587c7
-- 
2.47.3

