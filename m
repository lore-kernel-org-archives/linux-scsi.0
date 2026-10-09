Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF63A257C;
	Fri,  9 Oct 2026 03:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791517912; cv=none; b=Guij+11VQbhlvB9AlYmFBtEseVWBPykAtqQiFB+DPKC8zuvqK906GVNLJI8mcE+h71QDqmBmPjB4yiqF47M+XqaobzT87Pc7RwbMr3IWDSt1h+GzYpGkFhg8OyBOPvq27h9c/DvdftmmYwglN0bpf5x3Mxu5MhVcpEujtI0PWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791517912; c=relaxed/simple;
	bh=6lR7Fe8j7ZJqwgSdEaqt4wE1JuE3HtF6O2bh/oqRu+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edeXLTNmIlb5aag13+CJJSuZvEvh82ie3MMggOBXcJKe4dfdaoNfvw3XN1P6wojSxdQ6shmwqIuZXl/b8S3bD5puWtHF76UYWddIEmlqga94gX0+ZDF841zj5GDUt7IfXqHyZPy1/hB9Z93Bn0pGHeNE6FGIBvCvjrEG8xXAxsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=EzL/mU2f; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=EzL/mU2f; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="EzL/mU2f";
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="EzL/mU2f"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m1QWpC5GKYRSRxzyMic5aSse29101qlmEtiZmN91j/0=;
	b=EzL/mU2fBaB92YELKt7rTdtQK6B5fLf6llQy9gnMSoYM9iacimd68ImLn0Ho9tgr+gclgwlsW
	Oz4FAZXZA5Kaq+owb33EJGkv8HQX1I9BkWWO7x+TPU1WF7XJEYoqF+Xok+bgW8nPnPu3UgQaBll
	EOP87hqfFLWgfatooU4VQdg=
Received: from canpmsgout09.his.huawei.com (unknown [172.19.92.135])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4j1C8p5pdlz1BGMv;
	Fri,  9 Oct 2026 11:32:10 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m1QWpC5GKYRSRxzyMic5aSse29101qlmEtiZmN91j/0=;
	b=EzL/mU2fBaB92YELKt7rTdtQK6B5fLf6llQy9gnMSoYM9iacimd68ImLn0Ho9tgr+gclgwlsW
	Oz4FAZXZA5Kaq+owb33EJGkv8HQX1I9BkWWO7x+TPU1WF7XJEYoqF+Xok+bgW8nPnPu3UgQaBll
	EOP87hqfFLWgfatooU4VQdg=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j1BwW2FTTz1cyQh;
	Fri,  9 Oct 2026 11:21:31 +0800 (CST)
Received: from kwepemp500006.china.huawei.com (unknown [7.202.194.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 622B04056C;
	Fri,  9 Oct 2026 11:32:43 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500006.china.huawei.com (7.202.194.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:43 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:42 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 3/4] scsi: hisi_sas: Clear PHY error counts on phyup
Date: Fri, 9 Oct 2026 11:32:37 +0800
Message-ID: <20261009033238.1076098-4-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Some disks generate link errors during link establishment but still
phy up successfully. These intermediate error counts are not cleared
after phyup, leaving stale data for error detection. Clear them on
phyup.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 38 +++++++++++++++++---------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 9c363e237353..030f050731ba 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -280,6 +280,9 @@
 #define CHL_INT2_RX_CODE_ERR_OFF	29
 #define CHL_INT2_RX_INVLD_DW_OFF	30
 #define CHL_INT2_STP_LINK_TIMEOUT_OFF	31
+#define CHL_INT2_RX_ERR_MSK	(BIT(CHL_INT2_RX_DISP_ERR_OFF) | \
+				 BIT(CHL_INT2_RX_CODE_ERR_OFF) | \
+				 BIT(CHL_INT2_RX_INVLD_DW_OFF))
 #define CHL_INT0_MSK			(PORT_BASE + 0x1c0)
 #define CHL_INT1_MSK			(PORT_BASE + 0x1c4)
 #define CHL_INT2_MSK			(PORT_BASE + 0x1c8)
@@ -1061,16 +1064,31 @@ static void enable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static void clear_phy_err_cnt_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 irq_msk = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK,
+			     CHL_INT2_RX_ERR_MSK | irq_msk);
+
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DWS_LOST);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_RESET_PROB);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, CHL_INT2_RX_ERR_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
+}
+
 static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
 	u32 irq_msk = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
-	static const u32 msk = BIT(CHL_INT2_RX_DISP_ERR_OFF) |
-			       BIT(CHL_INT2_RX_CODE_ERR_OFF) |
-			       BIT(CHL_INT2_RX_INVLD_DW_OFF);
 	u32 state;
 
-	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, msk | irq_msk);
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK,
+			     CHL_INT2_RX_ERR_MSK | irq_msk);
 
 	cfg &= ~PHY_CFG_ENA_MSK;
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
@@ -1085,11 +1103,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 
 	udelay(1);
 
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
-	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
-
-	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, msk);
+	clear_phy_err_cnt_v3_hw(hisi_hba, phy_no);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
 }
 
@@ -1671,6 +1685,7 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	/* Delete timer and set phy_attached atomically */
 	timer_delete(&phy->timer);
 	phy->phy_attached = 1;
+	clear_phy_err_cnt_v3_hw(hisi_hba, phy_no);
 	spin_unlock(&phy->lock);
 
 	/*
@@ -1894,9 +1909,6 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct pci_dev *pci_dev = hisi_hba->pci_dev;
 	struct device *dev = hisi_hba->dev;
-	static const u32 msk = BIT(CHL_INT2_RX_DISP_ERR_OFF) |
-			BIT(CHL_INT2_RX_CODE_ERR_OFF) |
-			BIT(CHL_INT2_RX_INVLD_DW_OFF);
 
 	irq_value &= ~irq_msk;
 	if (!irq_value) {
@@ -1920,7 +1932,7 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
 	}
 
-	if (pci_dev->revision > 0x20 && (irq_value & msk)) {
+	if (pci_dev->revision > 0x20 && (irq_value & CHL_INT2_RX_ERR_MSK)) {
 		struct asd_sas_phy *sas_phy = &phy->sas_phy;
 		struct sas_phy *sphy = sas_phy->phy;
 
-- 
2.43.0

