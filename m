Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015403;
	b=mwNkVlp9Zt6GNGoRsGd239YZ/kOheB4/JqQMkpLcrlNxouOyVXm1dRAg0vv4G/qoBn9w
	 1apsvaPeit2aLL3hGXu3p/T/x1kSgsW0+xIgFbQnc6QCEerBjdsypvqidY1EmsKZxJoKd
	 3688ABbQQiUsbWWKejfRIf9LOV9LElTeEZu0snW3zokmwXHSUv6YxT8jZBEseGN0oGcZB
	 KOaOF+6l3ribmnKiEdgC1a0IW7wB/VGFkiGFxMN2NG+OWWsdU7Fod8anuZthwEhaZpQcq
	 YGmqVv5heHVcwrJm9EvOmxc1Ao/9ZjCCrOV5XI9UCaSbf3YCTRF74kAzjfoMN4WRHPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015403;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=BtV2IthiJQs4qJs1IE3KxiEa4l7s2YssIydBTyg2DwQ=;
	b=YqT+YhDg8dkCuvd8J3MLAqk8/I4GKcIfGxZm5FJr6usBA23Bwo3iTBr54MOxK9ahr37Y
	 rzvht3d99Ox7yYyRFt8C3QvpK+yCHEcvmfaJCDb2rO/zu8jSZsE6FfIPUl9t3LOwRQCMC
	 207XNgY3n2wkLWi7VcUU2CYHCVwBS/uJkW8hX4l4LebPLtIiY0D4Nr85fqsukpdM8SDbX
	 CpEg8X6KCWnFENyhVjnSQQGVE30YHgqMJoJJMfFZA4JOSa7NbH2VwuH9EpztUbL43LBD8
	 yxrR9LyO50v+7HPI+plkQ4L0nZ725iaUkUrD9MmUOGHKwzTB2hEbbvOP8pbdxStkuJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71A6606A33B;
	Mon, 26 Oct 2026 11:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A71A6606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jCsPJ55L8z59yrx;
	Mon, 26 Oct 2026 19:49:56 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 69QBnq5h010156;
	Mon, 26 Oct 2026 19:49:53 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 26 Oct 2026 19:49:55 +0800 (CST)
X-Zmail-TransId: 2afc6adf3e63067-a884d
X-Mailer: Zmail v1.0
Message-ID: <20261026194955694FnXGoQ352dstLk5HPBqCG@zte.com.cn>
Date: Mon, 26 Oct 2026 19:49:55 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiB0YXJnZXQ6IEZpeCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gdGFyZ2V0X2Rldl9hbHVhX2x1X2dwX3N0b3JlKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 69QBnq5h010156
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 26 Oct 2026 19:49:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADF3E64.000/4jCsPJ55L8z59yrx

From: Shao Mingyin <shao.mingyin@zte.com.cn>

Writing "NULL" to the alua_lu_gp attribute clears the ALUA LU group
association of a device. The attribute can be written again after the
association has already been cleared. In that case lu_gp_mem->lu_gp and
lu_gp_new are both NULL, but the code still calls
__core_alua_attach_lu_gp_mem(), which dereferences the NULL lu_gp
pointer:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  __core_alua_attach_lu_gp_mem
  target_dev_alua_lu_gp_store

Clearing an already cleared association is a no-op, so return early when
there is no association left to clear.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
---
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a956007b..430fc1eaeca5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2547,6 +2547,14 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,

 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
+	if (!lu_gp && !lu_gp_new) {
+		/*
+		 * The LU group association has already been cleared, so
+		 * there is nothing left to do.
+		 */
+		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
+		return count;
+	}
 	if (lu_gp) {
 		/*
 		 * Clearing an existing lu_gp association, and replacing
