Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732381;
	b=uaq0+RdUeRYImCNouSKkBAtjWXP/ZFZXpIWcEaO1c9xvI7MbVRaGWck4aqBWGA8ALKVz
	 9Tp+tVDwXCBfAZxxG25X6w0dxl3C+5/qoT0uj/34DkJQ3CCd+X30yf7fdNbbxnuXlE0jR
	 yg0zbj2fJEiDeIa/ofKnbLdMx50qRNIilP/uVLfwMg7D/bndOTGX6wq8dlOy78rSQQQL/
	 SvTqktrdYM7O3K+qx8tcKRc8ng9C/8687BxyeJdMiKjU21cVF2OGuq1m6yH5ISp/3WoEw
	 DE+3jMY/90lvrMChltGiSLmpvmqxctMqdtHJZL8xJOxXAimbkefnG5yyQd50v1yGGCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732381;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=rDV2BnArGweH/9tJr1OD6C7TOXW9aVZz2xDGtQqewGg=;
	b=pwOCr6fvgzc33suCO+1y88hkF2iV4fBt/CuJZ+eNZgTEJLNHpXTpW0/Rnvpd5BWycu26
	 xAtfPHqpj3x5035okzqqwXLHwmYCc/T4WvsadnKQirUBODLjrwB64ug7jY7yyQ96rcwzt
	 +kTyeSQ6MzA1NcCvfzq98SCzW2ugfkUy2KoGz3he6cTjJLO60c63rgeVr84EHYYxkRNi6
	 e9spwknTpJKdB+6ewwVNMK5GEYqYrWJcgU2tG8EnGZjpD7ifZdkrSrv6A91pyxVUfwvOp
	 qLbdXydzPcx/z9h4QvnlfvpWDdM/AUD9pZ1OQ9NfEBmopdXXvE5ApdeP/a5kQncSTrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEF5606A330;
	Tue,  3 Nov 2026 18:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EEF5606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJyYP0Gh7z5B13X;
	Wed, 04 Nov 2026 02:59:37 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6A3IxRq0077218;
	Wed, 4 Nov 2026 02:59:27 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 02:59:31 +0800 (CST)
X-Zmail-TransId: 2af96aea2f1355a-cfaa3
X-Mailer: Zmail v1.0
Message-ID: <20261104025931795jKc5btIAI_LwC4kQ10PV3@zte.com.cn>
In-Reply-To: <202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn>
References: 202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn
Date: Wed, 4 Nov 2026 02:59:31 +0800 (CST)
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
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvMl0gc2NzaTogdWZzOiBleHlub3M6IHVzZSBCSVQoKSBmb3IgdGhlIG5leHVzIHR5cGUgdGFnIG1hc2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3IxRq0077218
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Nov 2026 02:59:37 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA2F19.000/4jJyYP0Gh7z5B13X

exynos_ufs_specify_nexus_t_xfer_req() and
exynos_ufs_specify_nexus_t_tm_req() set and clear the task tag bit with
'(1 << tag)'.  tag is an int in the range 0..nutrs-1 supplied by the UFS
core, and controllers can have 32 unified task tags, so tag == 31 shifts a
32-bit int into its sign bit, which is undefined behaviour.  GCC happens
to wrap the result to 0x80000000 with the kernel's -fno-strict-overflow,
so there is no runtime symptom today, but the expression is not well
defined.

Commit 01aad16c2257 ("scsi: ufs: exynos: Fix programming of
HCI_UTRL_NEXUS_TYPE") fixed the same pattern in exynos_ufs_post_link()
with BIT() and noted that the UTMRL access should be changed as well; the
four remaining mask computations were missed.  Use BIT(tag) there too.

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
v2: rebased onto v7.4-rc1 (for-next); no code changes.

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
