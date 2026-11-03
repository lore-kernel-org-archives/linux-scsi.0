Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703175;
	b=YTJ8MNVzTUcPhegh3MA+cSgAtKTMArhcfXieZDQO3x0M3DS43E9WZ/104opAbPR1+aye
	 pXdHfNUeqCVYe4AAUEOh2qRr9PjkfabcMA3+8ge5VoBUMVZw4wjE5jkNDtRAOgLFlt5On
	 CH/Czc3TxB9BY6aFDq6xCGw7LcniCoEcWWmNwR25LWa5WvMbp7Mu3rikyHGx85uGg7aoo
	 6P6PRtBuZTwyi6oQ+/N9QZsj8X59CCIo6cpmPgIRTykT2zZSODNnzSPnaG5yOg1xneuNE
	 6z7kWaQN6ctLVqsm0ALWA3Pn76xj63Nk3OFvNWwKMwqVKg2NgkCjUSo/JKKyV+HfGOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703175;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=8jldkdgXypUZGK7ZAxt+IOr1VbrZ6ao856mae2SJmPk=;
	b=Kf4ORr7GUJcYIkAUjLAZfMy1RdsbjPG4n3I4NoS8v5EXbNUMDrnqylamL9nN4yidzvE2
	 wJEm4WyvBLWXrpOcpv7lDjjWm+wGVdpFhH5KZBUcmDKX2U2uDq5hn8QiN9E5WMVjTjtCC
	 VZlnJeGOPuI/x98EM5izY+pLQmlfLM4nO95ygWXJnMt6Fj8SIKXwSkcQO0p6u5bxuN5Sp
	 Fi9lE5DyPgDD5Y6VVV/eWcCxw7ldvT68XuhViD5RZ2gDuK495hacPlx/2PIjtOmwA5JeH
	 wZSROOnSxQmUphmW+6fA1p5kS/x3J7rIHK5k25vCvAQuaJONNtGVD0/8F0eR0K8UznQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1EC606BA56;
	Tue,  3 Nov 2026 10:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE1EC606BA56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJllg3d6Cz8Xrrc;
	Tue, 03 Nov 2026 18:52:47 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6A3AqXd9086930;
	Tue, 3 Nov 2026 18:52:33 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:52:36 +0800 (CST)
X-Zmail-TransId: 2afc6ae9bcf4b91-a92ff
X-Mailer: Zmail v1.0
Message-ID: <20261103185236493epBX4ZduRODf5qr1glAyz@zte.com.cn>
In-Reply-To: <20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn>
References: 20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn
Date: Tue, 3 Nov 2026 18:52:36 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDIvMl0gc2NzaTogdWZzOiBleHlub3M6IHVzZSBCSVQoKSBmb3IgdGhlIG5leHVzIHR5cGUgdGFnIG1hc2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3AqXd9086930
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 18:52:47 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BCFF.001/4jJllg3d6Cz8Xrrc

exynos_ufs_specify_nexus_t_xfer_req() and
exynos_ufs_specify_nexus_t_tm_req() set and clear the task tag bit with
'(1 << tag)'.  tag is an int in the range 0..nutrs-1 supplied by the UFS
core, and controllers can have 32 unified task tags, so tag == 31 shifts a
32-bit int into its sign bit, which is undefined behaviour and trips
UBSAN's shift-out-of-bounds check.

Commit 01aad16c2257 ("scsi: ufs: exynos: Fix programming of
HCI_UTRL_NEXUS_TYPE") fixed the same pattern in exynos_ufs_post_link()
with BIT() and noted that the UTMRL access should be changed as well; the
four remaining mask computations were missed.  Use BIT(tag) there too.

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
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
