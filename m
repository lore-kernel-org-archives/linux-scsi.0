Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8BE38399A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 20:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780345217; cv=none; b=PcB6kp9rdwpmk4jv8a7vZ6+W7FvWjQl7NKZJqMWotMe/JbQybeDV9cYj+R8fVZ73kSBZrtxCrSuv3VqlEyUcIEL47gHa7hvyQurc8VV+4MFAE4X4FPIUMnDMa9du1bjCzS6BCWvvANKQ3u4O16M0U7eCWDACY2b4aKIv5pgVKko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780345217; c=relaxed/simple;
	bh=Qv9s2qNDGnJLbDcBOEmyjgdJDS0m4KUfuBRITqJ5lQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hOaiF0qrka7k6NuqkXnZw3id7rYLxENh6UnRs9EgyvjZktv4NpSDqxBk4IVbUvDpNRqWA9qzw147hy2M2aqRkiP7afV5Je8RhjtmMdcmzsvjMnn/5svGvujrqPpAPvjnty+bS6vmyMmxfIz5j4oXjFzJJNFdo91vL2J5OtK0XyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net; spf=pass smtp.mailfrom=theesfeld.net; dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=gZI3uUwg; arc=none smtp.client-ip=109.224.244.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="gZI3uUwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780345206; x=1780604406;
	bh=KPfVAe+EKCmxEJ9+FKpLXsTX13R2V9swnJwsiXMLk7A=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=gZI3uUwgCwqyAIwZhEHR8qwwKp9alaISstIciQNijBLj50yzVd6+fO0kjit0C1Ict
	 JclcfYc0YNIgvMcalb7cjEWhg+b6Gs77qokdNC51AkU0nagWi0n1jA3YgRLEF0AWey
	 o52JA5lEsXnwPvk3wWmh/bD09kHuUhPDprKTmwkdUccV17mnlBsrPlfng00wkGN+Kr
	 n9JOWA4/FlwKvKMGiXJG1qslwwiwvIPPkjOCsTHWuhI0rufl1rYuO6yOLLrpE+V8wD
	 P6uuVfcwWN9D90t0nLwibts919mDW26m8ASbyLu73MusjqaHAIoQXcIZvt0ZtRQ5ha
	 4rHnHiPFoufcQ==
X-Pm-Submission-Id: 4gTlgk6JJPz1DFFr
From: William Theesfeld <william@theesfeld.net>
To: Justin Tee <justin.tee@broadcom.com>
Cc: Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix spelling mistake in comment
Date: Mon,  1 Jun 2026 16:20:01 -0400
Message-ID: <20260601202001.651088-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Comment-only change. No functional impact.

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7406dfa60..2b87dbe3f 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5003,7 +5003,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	} else if (phba->sli_rev == LPFC_SLI_REV4) {
 		/* Let type 4 (well known data) through because the data is
 		 * returned in varwords[4-8]
-		 * otherwise check the recieve length and fetch the buffer addr
+		 * otherwise check the receive length and fetch the buffer addr
 		 */
 		if ((pmb->mbxCommand == MBX_DUMP_MEMORY) &&
 			(pmb->un.varDmp.type != DMP_WELL_KNOWN)) {
-- 
2.54.0

