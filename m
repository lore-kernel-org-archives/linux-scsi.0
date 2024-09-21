Received: from cmccmta1.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64B613DDB9;
	Wed, 25 Sep 2024 09:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727257697; cv=none; b=Dk34mxgUJJCsWqln+VUBFIiKBddlBv1UXTs4fdxJH5zbS3+6kFOVy/okJR+83Lc62PE5s4+nyfLa5chVvCFNBFRk23dfCz4r1n77OqHpx4qUMrwtcnP8rJ1apAYK8W1T8UPvZTYqLhC5wn++zPUyo1DXPrHQi1WHUZKg6FCMI2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727257697; c=relaxed/simple;
	bh=gRNYL+wKAiIxFZ0OmZddSezoktGM5DJElhiRFjfp8tM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RXXlbNxdEW3F9WCvYfWmcDOIZaUwVJ3s5AuAOmnzw/hwGIXjXlN8h3HTa8y5Zwryoa75U3YZMIxK7xTnTd4H0s90utcyRQQOTq+QORB4dl89yJimBZ9yh/A8ceBPAVupgmubyu96ep8POs0a9GRgo959XgDSfciVu9r0bOZpixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee266f3dc54f27-c3f34;
	Wed, 25 Sep 2024 17:48:06 +0800 (CST)
X-RM-TRANSID:2ee266f3dc54f27-c3f34
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee266f3dc54498-ce3be;
	Wed, 25 Sep 2024 17:48:05 +0800 (CST)
X-RM-TRANSID:2ee266f3dc54498-ce3be
From: liujing <liujing@cmss.chinamobile.com>
To: anil.gurumurthy@qlogic.com
Cc: sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] scsi: bfa: fix cacography in bfi.h file
Date: Sat, 21 Sep 2024 18:45:37 +0800
Message-Id: <20240921104537.14843-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>

diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 41e6b4dac056..e1e0e967bcc3 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -1148,7 +1148,7 @@ struct bfi_diag_dport_scn_testcomp_s {
 	u16	numbuffer; /* from switch  */
 	u8	subtest_status[DPORT_TEST_MAX];  /* 4 bytes */
 	u32	latency;   /* from switch  */
-	u32	distance;  /* from swtich unit in meters  */
+	u32	distance;  /* from switch unit in meters  */
 			/* Buffers required to saturate the link */
 	u16	frm_sz;	/* from switch for buf_reqd */
 	u8	rsvd[2];
-- 
2.27.0



