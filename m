Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A71C6F4F;
	Sun, 15 Sep 2024 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405013; cv=none; b=f08IJCoMWe5vAi1tg07FMPZE3VZ7k8WciooXv/AB8VL6/gyTmwcLBCC+Y0NUl3U6AsmjHDvgFNbxj9WJU+FgqtUMa/YGeFD09V3IjM4PtvKyRLIRh/38HfpNqUMli7OYDSJVUvHe10h3V58QKDWTNS2Mb6hQs6uJKNQmtO8deHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405013; c=relaxed/simple;
	bh=N7h40G6H+R81ASu4TOocUT+4E0L0Oewla+3XR8agLD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo4aB1XHzqiljvEICt8ztOB7BD3wcck/Mr56bKq1Nqzo9NXmjF+gcFqX+g9xHFnpeb5S2VVyJc2S46wKDdWJCCvBfMhQUMKoA2v6ragyWQe0PyjFA91vIhIJExtbwt1yhJvw4s2jH0GyOeQCfXEywxm95JcLAZtFnz423y41A5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=bwqnmYEQ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="bwqnmYEQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=kbn/IX1MnFptKdwlrvEqfeihhuVsxGXkdas1FH/VYcI=; b=bwqnmYEQg9KyfLQT
	q3VFhrmKu5NRxXZeU9GOcmoXfmjZCbDr3fsZxXCWaCQsRF4yAnHT3qfMoxtQJiGKDMWzuo6vOOK4i
	efChQKxulgIzRNqOC1KhonJQAUNwLN02NtAX9k2d2Th3zCCBJGahRII3jOtr2XsQ2qQhJtLj3kL50
	4sxaxHcOxZ8G+VlUsZ0+z1YMZ/IQvtT78YYZsbJt7hYQ3QjtoZafzqP75zK7hhXmxdUD8QqDEl2da
	86Ja7szUvve1LOnQ/WKtO++FH8VgkhwSGah5M4vBiLS/WJAAKdnAQDXojswONkBJacYFKz9QJh6be
	1vUqbCTNAkHx5QVYTQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1spoo3-005pGt-0E;
	Sun, 15 Sep 2024 12:56:47 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 5/5] scsi: bfa: Remove unused misc code
Date: Sun, 15 Sep 2024 13:56:33 +0100
Message-ID: <20240915125633.25036-6-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Some more unused functions that didn't group elsewhere.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_fcpim.c |  9 ---------
 drivers/scsi/bfa/bfa_fcpim.h |  1 -
 drivers/scsi/bfa/bfad.c      | 20 --------------------
 drivers/scsi/bfa/bfad_drv.h  |  1 -
 4 files changed, 31 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 28ae4dc14dc9..2518e36d70d3 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -3412,15 +3412,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 	}
 }
 
-/*
- * Notification on completions from related ioim.
- */
-void
-bfa_tskim_iodone(struct bfa_tskim_s *tskim)
-{
-	bfa_wc_down(&tskim->wc);
-}
-
 /*
  * Handle IOC h/w failure notification from itnim.
  */
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 4499f84c2d81..64e4485b226e 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -339,7 +339,6 @@ void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
 
 void	bfa_tskim_attach(struct bfa_fcpim_s *fcpim);
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
 void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
 void	bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
 void	bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 62cb7a864fd5..19675a6e0780 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -842,26 +842,6 @@ bfad_drv_init(struct bfad_s *bfad)
 	return BFA_STATUS_OK;
 }
 
-void
-bfad_drv_uninit(struct bfad_s *bfad)
-{
-	unsigned long   flags;
-
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	init_completion(&bfad->comp);
-	bfa_iocfc_stop(&bfad->bfa);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	wait_for_completion(&bfad->comp);
-
-	del_timer_sync(&bfad->hal_tmo);
-	bfa_isr_disable(&bfad->bfa);
-	bfa_detach(&bfad->bfa);
-	bfad_remove_intr(bfad);
-	bfad_hal_mem_release(bfad);
-
-	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
-}
-
 void
 bfad_drv_start(struct bfad_s *bfad)
 {
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index da42e3261237..ce2ec5108947 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -312,7 +312,6 @@ void		bfad_bfa_tmo(struct timer_list *t);
 void		bfad_init_timer(struct bfad_s *bfad);
 int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
-void		bfad_drv_uninit(struct bfad_s *bfad);
 int		bfad_worker(void *ptr);
 void		bfad_debugfs_init(struct bfad_port_s *port);
 void		bfad_debugfs_exit(struct bfad_port_s *port);
-- 
2.46.0

