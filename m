Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015500;
	b=KN4fSImCtI6sAo8zWWTgUZN//8qE5gEOqygd1lavIKp0cvnbkhu7aBNXgWZYDTMAu6QI
	 5aJ+dps5dHaNRkY34/CAqZ7OgKAyyYXdq+m9mRN6XI/XHe7UHlRSnO79Aowlzg7Lz2XAu
	 gAzVvG4u0FgdHgcPiALfXDPOR9XD0VTTfsY23XAC9k9m2ybZFDT9auw4u6AzuywtInyAU
	 hA/L3JSA1aDgFHKEhS+rYYNySxpz9e7JYINP+U+WJSf8JxqeAMIg0sqWxbjai3LBXFe/0
	 1Fjx6gTHDnhVgi9ubzpNBN4Uj31tg76S/32w+Bgo18jJh5OUzAr7PAbTkJce1wRfvyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015500;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=LJLUjdfs9Xy+NVEtFMqrWw/HRzgEK6tpMHOW0mraM84=;
	b=V9XzAXNNqRD6tgwZOsnnkL4qzOFPR8QjN4sDmI8b1uGU0IhCwiY0w8EEO/7Au0rkNZe9
	 FsgsG6FDFGZdkpBMvs7UqPAaYgcrxZa0UEC3Aev1l9OxMakltN0ON8nY8b9KEgPztNeYM
	 cV4V5hoC+hOmOQYm7vx9fKQKhuDgSiWc662qpmxKHqeHMTwGh37TDtDGmUs+6YlV6ZcMj
	 QiCKq6kgP5yRpPX7hKHtvaWzV17Xb7OnQiHKUDKf/MXIaFVp0nQRDvU1OI6dYVqMdX78X
	 MYBxz1ewWiDsR0mcEByS0qiFsvGbVcdzNmU8p45EE2DXvrjsITipy7Cb6W+Nuqk292A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3895D606A31F;
	Mon, 26 Oct 2026 11:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3895D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jCsRF33yYz57DCh;
	Mon, 26 Oct 2026 19:51:37 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 69QBpUNb089646;
	Mon, 26 Oct 2026 19:51:30 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 26 Oct 2026 19:51:33 +0800 (CST)
X-Zmail-TransId: 2afb6adf3ec5bcf-b93a5
X-Mailer: Zmail v1.0
Message-ID: <20261026195133237y2UxJLoV1FK6aD1zrFbIU@zte.com.cn>
Date: Mon, 26 Oct 2026 19:51:33 +0800 (CST)
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
To: <mkp@kernel.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Cc: <michael.christie@oracle.com>, <bvanassche@acm.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiB0YXJnZXQ6IEZpeCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gY29yZV9hbHVhX2RvX3BvcnRfdHJhbnNpdGlvbigp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69QBpUNb089646
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 26 Oct 2026 19:51:37 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADF3EC9.000/4jCsRF33yYz57DCh

From: Shao Mingyin <shao.mingyin@zte.com.cn>

core_alua_do_port_transition() assumes that the device has an ALUA LU
group member and that the member is associated with an LU group. Neither
is guaranteed: internal-use HBAs never allocate dev_alua_lu_gp_mem, and
the association with an LU group is dropped when "NULL" is written to the
device's alua_lu_gp attribute.

The configfs path can reach the second case. After clearing the LU group
association, writing the implicit ALUA access state of a target port
group calls core_alua_do_port_transition(), which dereferences the NULL
lu_gp in atomic_inc(&lu_gp->lu_gp_ref_cnt).

Return -ENODEV when the device has no LU group association instead.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
---
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c43..17386c96de13 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1081,8 +1081,15 @@ int core_alua_do_port_transition(
 		return -EINVAL;

 	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
+	if (!local_lu_gp_mem)
+		return -ENODEV;
+
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = local_lu_gp_mem->lu_gp;
+	if (!lu_gp) {
+		spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
+		return -ENODEV;
+	}
 	atomic_inc(&lu_gp->lu_gp_ref_cnt);
 	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
 	/*
