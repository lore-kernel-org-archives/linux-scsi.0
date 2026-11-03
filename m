Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709117;
	b=bSUEVSkAZLSdCZD9CGI+SGEx/AFLlDerwAd/LNgZwCXyB0XcLGW64jKcjgp34F1L5qV0
	 2fyuyPlaQxD3zVRVeYR3r55yWALuQyVt6v9AIJl8KcmRGtmqbO0PompcEJNHlePF59W4L
	 i57hvwcoM9ZgtA3mq0sc/RN0JPyIZz4OAyfWtqe7Wke4PGhBN8wVlzipkfbdIkqEJVM4S
	 X6RiK2364IyMTwH3UhKiF9Q/nXFVSxzKQAT2pyHrgZK9jI80NXqPlFEE2PwgPj5+VUza+
	 GlT4FmcFkigE3QC5ze3WXQlNpUZ5mV0Nmr+nh0c13uLUczx5FTYyIl1hIAX1yQgry3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709117;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=ieBmRp1XcwhQFbEylt8mhSxOR3vG2tatu8PChzPxznk=;
	b=mwc2G1WhSn57TTdT2RvWAtHlkpHYwKVfUm66kPwruWYL4c+oL6CpSfE/hrOLzB1W/0w0
	 Ux9jzcz/vBlcpbU6/Rs+41F10iUebaWVEBdJIBhhDAeBF6JmestOrwZdTXiM5YJiJio1t
	 xe/lD7Brd0CL5j2I3A4y9c4zjE+C6r7PpEpOk09Nvtgs8PIs9xBXbVpIW3Dk3/3cGdyFf
	 o4UpJ7D4MB2I3lRR/l8vyIaOSbQdRVwbrxJNsu1NUClIZMxSHcARP0xu+eHeyXBc2W/Pg
	 5jTGAFYCg+Mqk9XuXofduJ6i2dKGEG9HnP5J+3lcO/Bw303Zd0PLchD05orPaajIhOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a0DXus7o;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c68sBFbQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a0DXus7o;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c68sBFbQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99911606A33B;
	Tue,  3 Nov 2026 12:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99911606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a0DXus7o;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c68sBFbQ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a0DXus7o;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c68sBFbQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CE6A322607;
	Tue,  3 Nov 2026 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieBmRp1XcwhQFbEylt8mhSxOR3vG2tatu8PChzPxznk=;
	b=a0DXus7of5RgUOPO5EQ7spZ0WftX5e4qot6+LNYxmKKukyCizDWc1oKY4CC6LBzBB+thN2
	Ttp/MVdNvw/3uNHsheMrpare5fAH1iVzi7m3g7SeRQbug8WxLuEYYUV2e7d3YbuXdSxzy5
	T4zx8jIXyMeboatx196X1/KbjigXgA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieBmRp1XcwhQFbEylt8mhSxOR3vG2tatu8PChzPxznk=;
	b=c68sBFbQoqCoja45UCE7ehZNKOZUzrAAEHvJPSTYcDxpLFADBOJFNaC2OoS/mO0e85UbjS
	QhLIZTAe06G+fYDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieBmRp1XcwhQFbEylt8mhSxOR3vG2tatu8PChzPxznk=;
	b=a0DXus7of5RgUOPO5EQ7spZ0WftX5e4qot6+LNYxmKKukyCizDWc1oKY4CC6LBzBB+thN2
	Ttp/MVdNvw/3uNHsheMrpare5fAH1iVzi7m3g7SeRQbug8WxLuEYYUV2e7d3YbuXdSxzy5
	T4zx8jIXyMeboatx196X1/KbjigXgA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieBmRp1XcwhQFbEylt8mhSxOR3vG2tatu8PChzPxznk=;
	b=c68sBFbQoqCoja45UCE7ehZNKOZUzrAAEHvJPSTYcDxpLFADBOJFNaC2OoS/mO0e85UbjS
	QhLIZTAe06G+fYDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AE45134B8;
	Tue,  3 Nov 2026 12:31:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kWjGGDrU6WpIBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:31:54 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:36 +0100
Subject: [PATCH v2 1/7] scsi: qla2xxx: Check FCE state under fce_mutex in
 debugfs release
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-qla2xxx-fix-v2-1-c6d2cdf2c806@suse.de>
References: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
In-Reply-To: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Himanshu Madhani <himanshu.madhani@oracle.com>, 
 Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-17.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -17.30

qla2x00_dfs_fce_release() tests ha->flags.fce_enabled and ha->fce
before taking fce_mutex. Since commit 841df27d619e ("scsi: qla2xxx:
Move FCE Trace buffer allocation to user control") the buffer can be
freed at runtime by writing 0 to the fce debugfs file, which clears
ha->fce under fce_mutex.

If that write runs between the unlocked check and mutex_lock() in
release, release goes on to memset(ha->fce, ...) with ha->fce == NULL:

  CPU0 (close)                    CPU1 (echo 0 > fce)
  !ha->fce -> false
                                  mutex_lock(&ha->fce_mutex)
                                  qla2x00_free_fce_trace()
                                    ha->fce = NULL
                                  mutex_unlock(&ha->fce_mutex)
  mutex_lock(&ha->fce_mutex)
  memset(NULL, 0, ...)

Move the check under fce_mutex.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 5d08bdbcf70a..247174a38d94 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -464,11 +464,11 @@ qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
 
-	if (ha->flags.fce_enabled || !ha->fce)
-		goto out;
-
 	mutex_lock(&ha->fce_mutex);
 
+	if (ha->flags.fce_enabled || !ha->fce)
+		goto unlock;
+
 	/* Re-enable FCE tracing. */
 	ha->flags.fce_enabled = 1;
 	memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));
@@ -480,8 +480,8 @@ qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
 		ha->flags.fce_enabled = 0;
 	}
 
+unlock:
 	mutex_unlock(&ha->fce_mutex);
-out:
 	return single_release(inode, file);
 }
 

-- 
2.56.0

