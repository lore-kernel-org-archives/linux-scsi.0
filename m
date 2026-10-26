Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015571;
	b=LtnPRUWmoL1DwcWwujnwm52m4virW+06L3ga5cIOYN4zq2aPWt1uy293g2DaOE74iAnl
	 dyVnYl1HEOYQNpBMFSy5EKN8+olYyvvxx4FI822T3uTht2o7pUMVGLTQ4hbTLbNjf+YhV
	 aiwm3UXQje7yzwDiCAkvLGvkO6r6/ux3Qgm4z3WUMOsyahPkYLyOhBIL8r5uK1ZViytMV
	 mFrKxc4eI+WA0hja7gEf2HSOogBjg0fJgU5VMrgPqUTPD9EtVHttCeeN3KpyKEmd9n0tA
	 pq2xB5n6xQuRNjRWm3Srqb17UPiSU9xWEvy9KWblYBZ0FvI6Omg7CQN458IqM6yEs4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015571;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=8j4oNTIcFNh8lFf1TCDHIGK6IzVaY3FeTaMvxD+ny5Y=;
	b=gnw000FmtGJuuFtt1lC0nbsWY8XAnJYx/PsIPp7TJYszldzSAcEFL5X3abjXk9oqL+mH
	 Kw58Q56iHdXKlEUVDuxITNl34t9BK5JUwhDgjhQpqG8wJ5jGSMQJUL+Pw6t1C45nnnH43
	 qOgMN9RlZ+t3Nkp8qbQdLQuFz2oz2wGfaMLdRR0aDJjfEj5c8cqQFkZCUVUko7qXF2iux
	 TT427cdtITIT+uYasxch72yylzCdc671mhEb1cXD098Shc4yr8QHIQ9TGySwzKPWL4Gc3
	 kp/LW0b7efVluSrvev39lMV2HjR/nEhCO0Ey+paXuwURM38x1RFOn2WlYPlHXltm2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD1F606A31A;
	Mon, 26 Oct 2026 11:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AD1F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jCsSc2ZKVz57DCk;
	Mon, 26 Oct 2026 19:52:48 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 69QBqgup090165;
	Mon, 26 Oct 2026 19:52:42 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 26 Oct 2026 19:52:45 +0800 (CST)
X-Zmail-TransId: 2afa6adf3f0d4e8-dec98
X-Mailer: Zmail v1.0
Message-ID: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Date: Mon, 26 Oct 2026 19:52:45 +0800 (CST)
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
To: <bostroesser@gmail.com>, <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Cc: <michael.christie@oracle.com>, <bvanassche@acm.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiB0YXJnZXQ6IHRjbXU6IEZpeCBkaXZpZGUtYnktemVybyBpbiBkYXRhX3BhZ2VzX3Blcl9ibGsgc3RvcmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69QBqgup090165
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 26 Oct 2026 19:52:48 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADF3F10.000/4jCsSc2ZKVz57DCk

From: Shao Mingyin <shao.mingyin@zte.com.cn>

tcmu_set_data_pages_per_blk() only validates the upper bound of the value
parsed from data_pages_per_blk=. Zero passes that check and is then used
as the divisor when computing udev->max_blocks:

  divide error: 0000 [#1] SMP
  ...
  tcmu_set_data_pages_per_blk
  tcmu_configure_device

Reject non-positive values, as the neighbouring max_data_area_mb and
cmd_ring_size setters already do.

Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
---
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 425ad1246a75..07b514678176 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
 		return ret;
 	}

+	if (val <= 0) {
+		pr_err("Invalid data_pages_per_blk %d.\n", val);
+		return -EINVAL;
+	}
+
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
 		       val, udev->data_area_mb,
