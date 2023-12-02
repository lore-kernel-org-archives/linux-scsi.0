Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="kIEB1/L9";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Fua0gh6y"
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7418E188;
	Sat,  2 Dec 2023 08:02:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1701532957; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=e866lOBbMx7/D+3JinX3TdM2Bb9lw13zradFKP8vQJTxGkSdW8hwniumWm5PT2ASDR
    4+RcZdGEfj4saAqQugRnowDhQvzaI1xZgR3xr87ZhdFYqPUeHhvjrIsGWSpCwzeLlVse
    HsuM5flwcu1qTq53ZJJqy/2qPuP4C+RXwU+pR5zEkkpSGtobfnsnaIMsyF5Zxp0q65Gj
    NlvPuRlf8vXO17whOHL6OSM6m1ptyccNaRvwd3gUjdCbbzLRbwO8sPURHksxMCMKF8HY
    S8aHUc7WLFx4EzTE0aQA8qVhYDC2j8hZtfAsXpDazIK9+FXEmbmL+C7j20/sZGr0U+Aq
    1JkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1701532957;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Tnpp+igY4DbZNs0oTu7nbRDD42wohiyLate59qDod5Q=;
    b=gL7ViZ0LmlTlbr9hHjr+XoeAv6IKxjw3mCcfFN4Ec5vrVnN4x5qCoywmJQBNV0zN3i
    eFOo/N7OA8/JtfvXBG4Q3krLdGgndRHH2kM/7Duat38thSXo8PVe2kkikTUnkIWtTsB1
    n+prwPZXHOokSPU7Zju4ylIj/saGyUwUfcqAQIwiHcco+PBEvKe7MWdDToMatqP2iQgQ
    L6A5guP2VhMIirrzRaGYKgXo9EhAv4n83ep2a0FjYkhb4PiUExD+wEg4neyfL6Ro2GfA
    oTEG32tqgzn+A3IbhdNiruFRiqx+7sciiFiySWRwX7NbBrYlnLyFZxZMNTzN4bsN8vWe
    Vp1A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1701532957;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Tnpp+igY4DbZNs0oTu7nbRDD42wohiyLate59qDod5Q=;
    b=kIEB1/L9NCvJ5RUo8J7gpCBoY4QmE9ZM3JJppLYsAL617Ex5kFM+nje8GjTT04OM/s
    Q3zI/aZi+oB76tNPap1DIRdIZdnS6Im2t0D2Fle5gQa/4+l8ek0ZbTJlSyTavWPgWBJU
    WLy9JXDfEqqy/lKk3iIBo6zc0DaRWwOvxDRZyQ130EcL8ACdohYfh+LVh2Nva/IqqAx5
    f3zqW5Ff0vvj7UjuHRUswpbLDIdB2+Kvkomd5JflAhzHMAxePBoCnLxrn172ye6tb4Sj
    U+B/1fMkLi80kVoMlIN/+DMvUZK342i6bAHnX2S5sfKrvvQaD7ZD6KznnUmn9MqkT6XM
    ylyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1701532957;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Tnpp+igY4DbZNs0oTu7nbRDD42wohiyLate59qDod5Q=;
    b=Fua0gh6yCT8HXHdEI/IRJqJnK2BT8GqYfmODKfiqEVluIKXLNNEpnJbTYrlsSFU+BS
    br0Y2ExM0Ef5DiMt45Ag==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U0BfWsYLe+bQusZClHgu6POSIuOZDSGI3MA01fA=="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 49.9.7 AUTH)
    with ESMTPSA id z8d451zB2G2b5CJ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 2 Dec 2023 17:02:37 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	mani@kernel.org,
	quic_cang@quicinc.com,
	quic_asutoshd@quicinc.com,
	beanhuo@micron.com,
	thomas@t-8ch.de
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mikebi@micron.com,
	lporzio@micron.com
Subject: [PATCH v3 1/3] scsi: ufs: core: Add ufshcd_is_ufs_dev_busy()
Date: Sat,  2 Dec 2023 17:02:25 +0100
Message-Id: <20231202160227.766529-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231202160227.766529-1-beanhuo@iokpp.de>
References: <20231202160227.766529-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

Add helper inline for retrieving whether UFS device is busy or not.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 68d7da02944f..f88f20f27f93 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -235,6 +235,13 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 	return UFS_PM_LVL_0;
 }
 
+static inline bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
+{
+	return (hba->clk_gating.active_reqs || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+		hba->outstanding_reqs || hba->outstanding_tasks || hba->active_uic_cmd ||
+		hba->uic_async_done);
+}
+
 static const struct ufs_dev_quirk ufs_fixups[] = {
 	/* UFS cards deviations table */
 	{ .wmanufacturerid = UFS_VENDOR_MICRON,
@@ -1917,10 +1924,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 		goto rel_lock;
 	}
 
-	if (hba->clk_gating.active_reqs
-		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->outstanding_reqs || hba->outstanding_tasks
-		|| hba->active_uic_cmd || hba->uic_async_done)
+	if (ufshcd_is_ufs_dev_busy(hba))
 		goto rel_lock;
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.34.1

