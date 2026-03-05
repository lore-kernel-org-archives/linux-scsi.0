Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6535A372EF7;
	Thu,  5 Mar 2026 08:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772699788; cv=none; b=NH2RbRfOBqiS54o6Ur+dt3U97SefTHJ8MtypqEACRKF5A8TI/s+POMDwcrZHT6mdcZG/YyVZsdMPqmgh4mZOaL6RhN7ZjSVe1VmM8SwkWkBz8SKqHdgC7KblidkByiAMvF8BrV7ClZ3iXFe5P0SzDfCSdRHvuR65MJI3bIQ/F5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772699788; c=relaxed/simple;
	bh=WjG4Nj8jpVmZSJ73hWezTDpx+t+1+5QiFkEVfYPdl+U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFNZgPCC1XZQxf8V5WiVbpRjfUV39ia5AbP2moB3k+Cs7hZ/OF+zwOYLLkgxBjwfUUX4Q8itUlK2SuWKrSiHxrAfK5U3cMUb1525U5RVvs0SIXYDEAE9t1bjA6O1qizvJtlxO8wS/gXuoTGaBLrfsmwRSgJpYXmCcC4PaqFJb4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=UCUbdqIv; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UCUbdqIv"
X-UUID: 62014a9c186e11f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=t6TRgPq7DKxCDmOZh4rGAZ9xbu66Z1j+cgR3cmV0iYU=;
	b=UCUbdqIvDYpMCCaFrsSpARAzhm/yhivo/IvE+2AAWtOp9I1zq3i47hRPwLuVknWJpm98n8BwKoS5Ck0Dg3NJY1ypOEwzLswUqKl/u9HiOe3Ll7RcduCNJ6pw565TxGj9RDqTS5SiMITW1YW5fm0foeey2RXjMhdw4cRlFCHra4E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:5d3b40ed-dcb0-43c8-8508-998fbac33366,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:83e18c7b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 62014a9c186e11f1bcd7499a721e883d-20260305
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1893048622; Thu, 05 Mar 2026 16:36:19 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 16:36:18 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 16:36:18 +0800
From: <ed.tsai@mediatek.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: Ed Tsai <ed.tsai@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
Date: Thu, 5 Mar 2026 16:29:14 +0800
Message-ID: <20260305083610.2672344-2-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260305083610.2672344-1-ed.tsai@mediatek.com>
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Ed Tsai <ed.tsai@mediatek.com>

On some platforms, the VCC regulator has a slow ramp-up time. Add a
delay after enabling VCC to ensure voltage has fully stabilized before
we enable the clocks.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++++++
 include/ufs/ufshcd.h      |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 899e663fea6e..bea72e7c1d32 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9942,11 +9942,13 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 #ifdef CONFIG_PM
 static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 {
+	bool vcc_on = false;
 	int ret = 0;
 
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba) &&
 	    !hba->dev_info.is_lu_power_on_wp) {
 		ret = ufshcd_setup_vreg(hba, true);
+		vcc_on = true;
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
 		if (!ufshcd_is_link_active(hba)) {
 			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
@@ -9957,6 +9959,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 				goto vccq_lpm;
 		}
 		ret = ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, true);
+		vcc_on = true;
 	}
 	goto out;
 
@@ -9965,6 +9968,15 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 vcc_disable:
 	ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
 out:
+	/*
+	 * On platforms with a slow VCC ramp-up, a delay is needed after
+	 * turning on VCC to ensure the voltage is stable before the
+	 * reference clock is enabled.
+	 */
+	if (hba->quirks & UFSHCD_QUIRK_VCC_ON_DELAY && !ret && vcc_on &&
+	    hba->vreg_info.vcc && !hba->vreg_info.vcc->always_on)
+		usleep_range(1000, 1100);
+
 	return ret;
 }
 #endif /* CONFIG_PM */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8563b6648976..bf50078708b9 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -690,6 +690,12 @@ enum ufshcd_quirks {
 	 * because it causes link startup to become unreliable.
 	 */
 	UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE		= 1 << 26,
+
+	/*
+	 * On some platforms, the VCC regulator has a slow ramp-up time. Add a
+	 * delay after enable VCC to ensure it's stable.
+	 */
+	UFSHCD_QUIRK_VCC_ON_DELAY			= 1 << 27,
 };
 
 enum ufshcd_caps {
-- 
2.45.2

