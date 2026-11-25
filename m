Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606514;
	b=wTK1vskwY3oBRmMX6lvWFW5WrBL4PUZrOIrbE6jKy0mXfvXz5v2jjRJ420uWoMEsnR4Z
	 AlxCBjXZy3ifPSAGrXrArJEZm7OGK7pnHMDyV9NLqJcd3VZN3uOBsmvPt7dbnxhJyZM2z
	 TASDfGSkYsw8r+oW3GFzvB6LerN90UhmOywE9B+MBRjKlu0wk24nrJdWtVFNjM8NX/Zts
	 f3bfRDCSjNVNt1a7hWVImnMBt7TWiMu4gHkVvKbLDzW8JfbK2mYPZaYJHufO8LBHKxZht
	 RbT3nEcr4VJ/yQ8w2gHOzyLjT3xartl69QPzUEs6WR9OznOuLZpKwLkzcVp0iR3mkqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=n++5g53G1zjVYZaB64/wmjPkzu1LYF2WPuHsIPKatOA=;
	b=nbKe0CHfPmE/p3zzYSJ5QJ5rnT0dMf877+tg+PqcPwz2TuN/MMSv8fvl29PdoBpzK5um
	 v4gwt4sVy2kiJ0Rk9WWdYMECMjDb39vbUkb4gV4KjeysrE3gh2pKlAgvXKEOnltKFO4fi
	 pKIAyqd40NAgDuKFX3GaepgoIgZvW2XaZCNIBbrlAiBqUNuTqrC3m1JmTYd5WM53zKEo5
	 uqURJTnr1NM26oUSBriP1Xdn9HWicRMKc1WlKDlIxdhre0jqzsbodpoA9h01X23mlmibE
	 nKEe7HC5yWOMLO6W6kf791pIPOGTPmRx2/eLFWBRIaupswbmX8sUzoT9RAofZSFRI/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h0E7v654;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC332606A329
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC332606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h0E7v654
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-386a0f79047so5997157eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795606512; x=1796211312; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n++5g53G1zjVYZaB64/wmjPkzu1LYF2WPuHsIPKatOA=;
        b=h0E7v654D/t7RgVnix7Ih05t1KNzNDPdlKutXNuDmWfUUqa87Z6fDNh7Wk+Zlt7qwT
         zfad7VDRTl5RRmCXNrwjBY9G3RA+llAiBdPbQcfSbhcbdV9PtHkidaW+utZwbppUCig/
         0fFXCJGbBH1vuBYHJxscrXRZRIuYbV+4UfJwvD1Q1RB8oCQ+rkC6n/V3a06mRFmNRLz9
         nxt554V762VvOCymRY99H8DlueQWMCW+eyFHC7Pw+WuC5oEKzJDhuAFGPC7mVwXjTL9u
         rSIvLXiTPPm8B9U+nzt9MohDrUt/ozmdzb+Gf1ZBgCMcWis5XIzMkGKyErJ1ly0VS94K
         qhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795606512; x=1796211312;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n++5g53G1zjVYZaB64/wmjPkzu1LYF2WPuHsIPKatOA=;
        b=k8jTZ0+a2/p2mQg9JZLOyjtTIO+uuraO91JO8GTsFdDD0oudmaxtlSI8svCYyyB87c
         uFD9xgFU4yuvfRk0duZKxX35TYtDC+k2iyimu19CdJ8ykTl5STWV9M6BTEl1JB4D4MrR
         gvcTRXRPd0Zo/M8fNuoInh0D5uscf+hMoQnUe3/PXwv0nOtflZC9r3SKa+VRLqA6oB/S
         PMT9TBIJmDnQwahvUzS5My4dOJ4kahwE4nIjA1924CQSHa3yJEvid4BEDyCZUKEKpGUI
         Yu3M562Vz15W2ggwQ085iyZbFT9X4Q5aWzNA1JPqFNCcSNDXVIgSmtL7/cNoFRrJ9j/4
         24Vg==
X-Gm-Message-State: APuU4Z+1LYyDjTSgi5ueCau2kEZrtiWtSjIiJAjg0sn9dk+FMXPGGigc
	0JJmNkQcqzXGOeAmYTz4F1EO8w1aBX/Nn3nPHm+uxqnNLEJeLCK2BMdmSugOE0NxmbF/fhpEjjv
	BsuZaThP+/MfEmhERuHA0rSWRegUjtAUHGBzJyjXBlqsgcCgQSjzh3MZupbWHTyGe3D/Rwxbp5y
	HW50YSntNNfvT0NDSTdqX4a2R1vjV7HmoWj8Okkm1g16ZPtYJcSjEu
X-Received: from dycmv8.prod.google.com ([2002:a05:693c:2808:b0:386:c2e4:36b6])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:e91e:b0:384:2780:8757 with SMTP id 5a478bee46e88-38570a3e793mr20155979eec.22.1795606512106;
 Wed, 25 Nov 2026 03:35:12 -0800 (PST)
Date: Wed, 25 Nov 2026 19:34:00 +0800
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125113435.1426680-1-powenkao@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125113435.1426680-3-powenkao@google.com>
Subject: [PATCH v3 2/3] scsi: ufs: core: Defer debugfs init until after device init
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Randall Huang <huangrandall@google.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>, John Garry <john.garry@linux.dev>, 
	Li Qiang <liqiang01@kylinos.cn>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

ufshcd_hba_init() currently creates the debugfs hierarchy and fault
injection attributes before the controller version (hba->ufs_version),
locks (hba->host_sem, hba->ee_ctrl_mutex), UniPro link, and device
descriptor are initialized.

Move ufs_debugfs_hba_init() and ufs_fault_inject_hba_init() into
ufshcd_init() alongside ufs_sysfs_add_nodes(), and remove the now
redundant ufs_debugfs_hba_exit() call from ufshcd_hba_exit() since
probe failures occur before ufs_debugfs_hba_init(). Split out
ufs_debugfs_ee_init() to initialize hba->debugfs_ee_work and
hba->debugfs_ee_rate_limit_ms in ufshcd_init() next to hba->eeh_work,
before interrupts are enabled.

Note that hba->trigger_eh_attr and hba->timeout_attr are now
initialized after device init. Until then the zero-initialized
fault_attr has probability 0, so should_fail() returns false and
module-parameter fault injection takes effect after device init rather
than during early probe device-management commands.

Suggested-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 11 +++++++----
 drivers/ufs/core/ufs-debugfs.h |  2 ++
 drivers/ufs/core/ufshcd.c      |  7 +++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 89753c40b27b..a3731dea11c7 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -472,14 +472,17 @@ static const struct ufs_debugfs_attr ufs_tx_eqtr_attrs[] = {
 	{ }
 };
 
-void ufs_debugfs_hba_init(struct ufs_hba *hba)
+void ufs_debugfs_ee_init(struct ufs_hba *hba)
 {
-	const struct ufs_debugfs_attr *attr;
-	struct dentry *root;
-
 	/* Set default exception event rate limit period to 20ms */
 	hba->debugfs_ee_rate_limit_ms = 20;
 	INIT_DELAYED_WORK(&hba->debugfs_ee_work, ufs_debugfs_restart_ee);
+}
+
+void ufs_debugfs_hba_init(struct ufs_hba *hba)
+{
+	const struct ufs_debugfs_attr *attr;
+	struct dentry *root;
 
 	root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
 	if (IS_ERR_OR_NULL(root))
diff --git a/drivers/ufs/core/ufs-debugfs.h b/drivers/ufs/core/ufs-debugfs.h
index e5bba9671862..d0acfd045a8b 100644
--- a/drivers/ufs/core/ufs-debugfs.h
+++ b/drivers/ufs/core/ufs-debugfs.h
@@ -13,12 +13,14 @@ struct ufs_hba;
 #ifdef CONFIG_DEBUG_FS
 void __init ufs_debugfs_init(void);
 void ufs_debugfs_exit(void);
+void ufs_debugfs_ee_init(struct ufs_hba *hba);
 void ufs_debugfs_hba_init(struct ufs_hba *hba);
 void ufs_debugfs_hba_exit(struct ufs_hba *hba);
 void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status);
 #else
 static inline void ufs_debugfs_init(void) {}
 static inline void ufs_debugfs_exit(void) {}
+static inline void ufs_debugfs_ee_init(struct ufs_hba *hba) {}
 static inline void ufs_debugfs_hba_init(struct ufs_hba *hba) {}
 static inline void ufs_debugfs_hba_exit(struct ufs_hba *hba) {}
 static inline void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status) {}
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 646359d446c3..443dcd7ed12c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10115,9 +10115,6 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_vreg;
 
-	ufs_debugfs_hba_init(hba);
-	ufs_fault_inject_hba_init(hba);
-
 	hba->is_powered = true;
 	goto out;
 
@@ -10139,7 +10136,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_exit_clk_gating(hba);
 		if (hba->eh_wq)
 			destroy_workqueue(hba->eh_wq);
-		ufs_debugfs_hba_exit(hba);
 		ufshcd_vops_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_setup_clocks(hba, false);
@@ -11375,6 +11371,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
+	ufs_debugfs_ee_init(hba);
 
 	sema_init(&hba->host_sem, 1);
 
@@ -11506,6 +11503,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
 						     "dme_qos_notification");
+	ufs_debugfs_hba_init(hba);
+	ufs_fault_inject_hba_init(hba);
 	async_schedule(ufshcd_async_scan, hba);
 
 	device_enable_async_suspend(dev);
-- 
2.56.1.839.g22a8290db9-goog

