Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293705;
	b=oHk1NxTHPt1HPwrHaOY9bTezN0VFUaoyE2iRvoOTK2b3BOytTvi5kkWw5GZzKsuJ73Hu
	 qWJa2E6qiomDPlA6WDGjn142kj01J1ARONydgC13I2kzfkBjFrFywRnKbxeHg8YgDCkCP
	 cn0HUVj+rP3woBprM0MqAaIQUYJMWE0nzbxkR1ZrmJ3RRP7giUFkCfepXE+huM2iVesOs
	 mZw8hyAaqHxCovDYNkyuOKe4Hv2wwZsA1Zx4yIxckfhpY0ROwXByLMNhzIK6w9ZU0gwCI
	 ImI5iiFnd2utwSDTdYmgT4fXeID+a3af4Gu8NEd8ieHohAUvDjNfIC30lQVpk3nwOkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293705;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=r9by4dkuXGhbE2ZQBI/thU+h6fdez1PQv8BEe17vPo8=;
	b=t3H8UP4g294jAC0ZK9DwE9fHXcv8zDUAT+l4q7iQATPV1MXdTEFzFBDnqxxUowmL0Y6g
	 vVilt4nrLJFKIOuKYZZfMvsRp7PGwp9DDrHDwc6v9JW1nu6uC0/kaEsoCQjCjBkupGlWG
	 eCVBgTTisWOxaRyxiZ94q1opR280nwUWjNrIY3/1yBdNvDVsK3Ljn1takbGOsdlNiA3zh
	 lmlV5qOm8RH3hjsMRTIN0sKgBRZ2kwmQvyGyq3ic2pcZmpNQ/Z0UFGiQpm7HMOyGzJRKB
	 FZKM0YqJvxOYEw4DgPZTP5NyCfjzCpzLFRMwhPQpNgB3unXsuvcJq95Dm+gxglEj3mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="A/BUEZNv";
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD51B606A326;
	Tue, 10 Nov 2026 06:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD51B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=A/BUEZNv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=A/BUEZNvFmJa+EjoRAvtpjobIk43NPvEehsPVB6aZ8+kfTx1zQnH3st+Ojzd1n9K7oYplOS7a0bJj
	 eRLLCih179nAjwHg8bCbBeqaAshhKsFRx0rbP1C0YaNOpH07PVUA3ulCrXXVBqX/k2N0jFAKV/Hq4M
	 yLrbjjnhp45HuYyU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36af2bfc4654-97e00;
	Tue, 10 Nov 2026 14:55:01 +0800 (CST)
X-RM-TRANSID:2ee36af2bfc4654-97e00
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56af2bfc1a43-aab62;
	Tue, 10 Nov 2026 14:55:01 +0800 (CST)
X-RM-TRANSID:2ee56af2bfc1a43-aab62
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Orson Zhai <orsonzhai@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Subject: [PATCH] scsi: ufs: ufs-sprd: Fix vdd-mphy regulator leak on probe failure and remove
Date: Tue, 10 Nov 2026 14:54:57 +0800
Message-ID: <20261110065457.1280-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs_sprd_n6_init() enables the vdd-mphy regulator, but nothing ever
disables it again: the driver has no .exit callback and no other path
calls regulator_disable(), so the power rail stays enabled after a
failed probe as well as after driver removal.

The UFS core calls the vops .exit callback from ufshcd_hba_exit(),
which runs on probe failure and on remove, so an .exit hook is the
natural place to release the supply.  All other vendor drivers in
drivers/ufs/host/ already provide one.

Fixes: df7320bac37e ("scsi: ufs: ufs-unisoc: Add support for Unisoc UFS host controller")
Signed-off-by: laixiangwu <laixiangwu@cmss.chinamobile.com>
---
 drivers/ufs/host/ufs-sprd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 6862250c5..30acbfe6c 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -266,6 +266,13 @@ static int ufs_sprd_n6_init(struct ufs_hba *hba)
 	return 0;
 }
 
+static void ufs_sprd_n6_exit(struct ufs_hba *hba)
+{
+	struct ufs_sprd_priv *priv = ufs_sprd_get_priv_data(hba);
+
+	regulator_disable(priv->vregi[SPRD_UFS_VDD_MPHY].vreg);
+}
+
 static int ufs_sprd_n6_phy_init(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -394,6 +401,7 @@ static struct ufs_sprd_priv n6_ufs = {
 	.ufs_hba_sprd_vops = {
 		.name = "sprd,ums9620-ufs",
 		.init = ufs_sprd_n6_init,
+		.exit = ufs_sprd_n6_exit,
 		.hce_enable_notify = sprd_ufs_n6_hce_enable_notify,
 		.pwr_change_notify = sprd_ufs_pwr_change_notify,
 		.hibern8_notify = sprd_ufs_n6_h8_notify,



