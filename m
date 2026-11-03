Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735388;
	b=yNtJRUfeJQQhYGEGGX8ANiD8Y015hezzhNN66NXYKjoR2pO8YN3z1H5rPWYIsacv+oxY
	 rov2z9NSVntuir/EFET14aLCBmzZkiaPWkTXyP3YPp/CFEyYSoqHUMUgbG3d1JwyVK+Y0
	 6wyG/GySiU6EncJ0kR/Ps2nJA4009/Jyjq7mjaq8sMEaMrrpUb3DNweIBbkMoYHJLpqYN
	 gjjvxGGG/oN/i9rrh2yK5sxpNiPpJS0tk8LgeXJvynjrbQRVDDgrjLj51S0L1bEje3UO7
	 1X8JNfx6e09SfQ4xIaxs2lZb6j2L/35uej2H1nXMHzdHBvMr2cQGTptt0GONu2k+kGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735388;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=wr1vBxqOwzVVeBlfORJLdh2wU2b9XxfZ/Zk2+hfs9Rs=;
	b=f6bvV/NJknGdy8/xXmotPeHkBTeSIxMRwIF22rhDoXWUbkOeBYNq0O6vODauDhOKYtCv
	 C48lbVyg4N7h4yII2CPNSgmfmxGP0GUN+LYuL6W5VjjLQwoq+aAVyorjzy8lkDU0JD/3y
	 lbSiTUvYaoNp/dznxFDWyjPNXvXUDrw+XKq4tflsfYqjtUmgmIkLq3NkPWdzWe97jN4De
	 rKQE4IzrQc1LS5HdP42Y36nCJI0vETgoi3dWGj4vN3J3/x/8n4DvOKDTOPQVLgbdnVW48
	 dr0CudhvvexL4vv1DwPAsioca60hKdezt3W8KDc+EIZHjIvpOjRIagPncAFYIVn8E3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAE606A32C;
	Tue,  3 Nov 2026 19:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FFAE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJzgD4KJGz57KTr;
	Wed, 04 Nov 2026 03:49:44 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A3JnbwE052245;
	Wed, 4 Nov 2026 03:49:37 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 03:49:40 +0800 (CST)
X-Zmail-TransId: 2afc6aea3ad43f2-f7913
X-Mailer: Zmail v1.0
Message-ID: <20261104034940800qG8bny1y_TdrfjLr-KGpv@zte.com.cn>
Date: Wed, 4 Nov 2026 03:49:40 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Cc: <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYzXSBzY3NpOiB1ZnM6IGV4eW5vczogVXNlIEJJVCgpIGZvciB0aGUgbmV4dXMgdHlwZSB0YWcgbWFzaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A3JnbwE052245
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 04 Nov 2026 03:49:44 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA3AD8.000/4jJzgD4KJGz57KTr

From: Shao Mingyin <shao.mingyin@zte.com.cn>

exynos_ufs_specify_nexus_t_xfer_req() and
exynos_ufs_specify_nexus_t_tm_req() set and clear the nexus type mask
with '(1 << tag)'.  Commit 01aad16c2257 ("scsi: ufs: exynos: Fix
programming of HCI_UTRL_NEXUS_TYPE") converted the same expression in
exynos_ufs_post_link() to BIT() and noted that the UTMRL access should be
changed as well; the four remaining mask computations were missed.

Use BIT() there too, matching the rest of the driver.  The transfer
request tag is in 0..nutrs-1, and nutrs can be 32, so BIT() makes the
width of the shift explicit; the task management tag is in 0..nutmrs-1
(at most 7), so only the transfer side can reach bit 31.  No functional
change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
v3:
- Make this a standalone cleanup: no Fixes: and no Cc: stable.  The
  kernel is built with -fno-strict-overflow, under which GCC and Clang
  both define the signed shift here and neither trips the shift
  sanitizer, so there is no runtime bug to backport.
- nutrs counts UTP transfer request slots and nutmrs counts task
  management request slots; only the former can be 32.
- Capitalize the subject verb.

 drivers/ufs/host/ufs-exynos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3bcbc9ebbb28..ee47958253bb 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -997,9 +997,9 @@ static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
 
 	if (is_scsi_cmd)
-		hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
+		hci_writel(ufs, type | BIT(tag), HCI_UTRL_NEXUS_TYPE);
 	else
-		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
+		hci_writel(ufs, type & ~BIT(tag), HCI_UTRL_NEXUS_TYPE);
 }
 
 static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
@@ -1013,13 +1013,13 @@ static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
 	switch (func) {
 	case UFS_ABORT_TASK:
 	case UFS_QUERY_TASK:
-		hci_writel(ufs, type | (1 << tag), HCI_UTMRL_NEXUS_TYPE);
+		hci_writel(ufs, type | BIT(tag), HCI_UTMRL_NEXUS_TYPE);
 		break;
 	case UFS_ABORT_TASK_SET:
 	case UFS_CLEAR_TASK_SET:
 	case UFS_LOGICAL_RESET:
 	case UFS_QUERY_TASK_SET:
-		hci_writel(ufs, type & ~(1 << tag), HCI_UTMRL_NEXUS_TYPE);
+		hci_writel(ufs, type & ~BIT(tag), HCI_UTMRL_NEXUS_TYPE);
 		break;
 	}
 }
