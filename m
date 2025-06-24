Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABF8EC5;
	Tue, 24 Jun 2025 03:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750736074; cv=none; b=h0USAimUbwJfo/pmNNNLyaFhuk8Hm5UZNL9HCSwrxOW2z2qjf75uoJM3v4UiFRuTDfIHQ9alfuU6eTmdwHOVKDZ86suvlc/tUPdDaN43j8gz2Ye4YMkcj3VS8KZ0h9Uzn+4q5Eu0kR7j2tHn+6w0FiP3vvWh0MrmRTHlDpLiCtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750736074; c=relaxed/simple;
	bh=2lgsSiSDVhVvn8xEry5TEui0answQ0NLBijzCjYH/hg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=b2XdsTmQE940Ns1gD3qOcKOEtQ7JD9SyQJumwHqxR2U4GAKzBEactDvFSryNhwkS/l4mNcHpm5PZa2NO4YrHJEVEsMDT+dN2zjkx59HjH+D6Yh92KOK/AtOvBZFkrkFh9D01QOmWE/TasviG22N99/zppBMmAiFeJ9TZS5LGyFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=XECnpSKp; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="XECnpSKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750736062; bh=e5CddSXqWu8idh7jLesbAOAwyCS96hBKVBtYhIbCOis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XECnpSKpRSoAgZQyQuGsY+Eum1g/7k26jZYVoe5NoqdrH4d7H3RqIGlPfb/RtvUGS
	 y7lStmQfEKbsss8jsvz+RPVJYIw4exAYkEVaDeR12wYL5Z1UPhDe90vGVahkbPrsCo
	 Q0k6b2j/mS+ss9OgT6u1U6lfNmLp0u3qnkp4jwA8=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.165])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id 4333CCA0; Tue, 24 Jun 2025 11:16:51 +0800
X-QQ-mid: xmsmtpt1750735011tvra48o7l
Message-ID: <tencent_FACDDA286D6964B8EFB784FE3C4966EFDA08@qq.com>
X-QQ-XMAILINFO: NyTsQ4JOu2J2sYoc6GuRSGi/RPtT58ss+s1XHr5nfWLCHIxKyly4svic0kOksH
	 7zwcIW37+MpR+3wzQtAIANDUukiaOHjmoBh4GDWsbAPaHJYlO+xx9TIgPZ0on+vnq/aGjejOMJG6
	 0gb8oc5F6MNWngAIQu+G4BItbqf+/5wbUiIsJaj0H5l4Z99NV8anfIBTyngabT79+9v8ITDgTSRr
	 /YW61SOabi9MaGwz+Jjkensj3KWLKqSDoe3hhl6/5EjWUHK5bnfdrI3MieryVgElo77Mim+H7oUv
	 H0kHuZmHOyXFzM3NhrUwQpe7StGdjg+YckF3SViWdgR+j54wgb48EA5A9jxwN5KRvRacs29HtU/v
	 rFZ85eHZH1LXJ0YHNTfg88HWG8PDzNeFGRfrtfkIKFAzDlJb3kK5tLOrP1/UfVHsTYh+qk1c91Qt
	 1d5yssHNwAfT2qSpVIq4a12EkslIPIw72mmHeGsqCsOFZD3qzmPCUSBIIU6nVKjjtzEP/ymj3wS3
	 Ua4UrRbVBO8+HrjDOSVXnEX4XidrBcruqy85q16oGrLUjKLu0cFFm/bplXnzSR+EIP3BWdUiHRdo
	 wMHnoByIzaeR672eOofJ7GdQ7jKXhcFb4I4yHdVxAbduZP7LaYuzthfD23Xl+oV85b44apnTfSp0
	 DYTt0K2dGM+jDbwawuro90tYaMojOqD4v5DqSfr/I2OhTrDYFFssElKpjNe+HBEISE8A6Umf2LAg
	 TAURUfIA/TgfxhZ8mAw/Zn1Is+KUJBx7Wdvd7oF8g0YbsJgcPDn0F8/zqo2TxeKzgAI2HXhVj0ZW
	 MAQ6txox0Zh8TFJNsQ2LxvmxaNQK6RlHmCF9Fzmf8TMU+PLJ79GHA/qafOATPV1mNUWhi9UsWB3y
	 e3JngoevZxkM6KkFdrYUKj/rGujKniwonhi8N7BDoZowI+rfFvTez0CrwzherPvZ0LJ58SuKcCau
	 9JXqOZ+iUMFGvO195htvkNPI2fKlpPh5yt+riZJdbcfv30Uj/v4qv1ZgYWPR8f
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: jackysliu <1972843537@qq.com>
To: lkp@intel.com
Cc: 1972843537@qq.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	jhasan@marvell.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	oe-kbuild-all@lists.linux.dev,
	skashyap@marvell.com
Subject: [PATCH] [PATCH] scsi: qedf: fix inconsistent indenting warning Fix below inconsistent indenting smatch warning. New smatch warnings: drivers/scsi/qedf/qedf_main.c:2814 qedf_prepare_sb() warn: inconsistent indenting
Date: Tue, 24 Jun 2025 11:16:43 +0800
X-OQ-MSGID: <20250624031643.2205842-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <202506240340.fv6cXpyc-lkp@intel.com>
References: <202506240340.fv6cXpyc-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Old smatch warnings:
drivers/scsi/qedf/qedf_main.c:2816 qedf_prepare_sb() warn: inconsistent indenting

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506240340.fv6cXpyc-lkp@intel.com/

Signed-off-by: jackysliu <1972843537@qq.com>
---
 drivers/scsi/qedf/qedf_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 8767d9de819f..b46fc510557b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2810,11 +2810,11 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 	}
 err:
 for (int i = 0; i < id; i++) {
-fp = &qedf->fp_array[i];
-if (fp->sb_info) {
-qedf_free_sb(qedf, fp->sb_info);
-kfree(fp->sb_info);
-fp->sb_info = NULL;
+	fp = &qedf->fp_array[i];
+	if (fp->sb_info) {
+		qedf_free_sb(qedf, fp->sb_info);
+		kfree(fp->sb_info);
+	fp->sb_info = NULL;
 }
 }
 kfree(qedf->fp_array);
-- 
2.43.5

