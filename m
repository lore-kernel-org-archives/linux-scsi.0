Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709124;
	b=kz2R2NKbj9rDH9QOcumBRa2B8v+scPM0rSivwoVw89GvvwLLinmWuxZnFO7gxc2VTJ7a
	 iYLkqaMkA4MAHdXXXDwKtQ+iB14+RAb8glNNjAEbEy8zUc8chnexUyktVuABQDkZTdRn1
	 kYYvRCvlz05aeAv1I0fgTyxYBZIcGaUy3n8UIxKaAE27G9vItwU/JhtZmt8oUvRwQJfHD
	 64/YzROTwkKU5J2AIZ/qgt6ADhIrlop9gCKdx2xT93KktASNd5eHWj9JYdAyEIE048s/a
	 gf5oVTExSA4tmKEXSv+hE0R4TBMw/JUTEMT48dp1fkqu2naA4VOyTRqUJo+PQ2HT9uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709124;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=OObJ1Vsh+Tag+2HW3Ymk76zg+lXhJEtYvCWaVbRWRqA=;
	b=IErmPaSlr/tsGI08lFoyEtZnVvIjGyhDHalAS9Mx4AxMfzTBX298wGKyAJeWrdNTIFBa
	 /qC5SGrkr3eO0wpnxyzcaB8LhiLb+AK8rfvNr5XX8iak+pv1QI+V53X0fSFraBFB5pvw2
	 pPHZUq5vmyQrWd4Nf+uEiIhL9ofNTU1Njavgt3H66U4BxcR2PfZ4JFb34tGNGTPPV5HbD
	 4EdKdNIDCn4h66WkHWJBoBzpBkYzeDUaFRW/F5YcV8QKV51Ta6thtSVXW0Ze7IazxOFVy
	 2Z6Bt1JliN9UjoLgyC+FLQx74zokkXVREhGBfMAxG+YouwCJkRvOmVLEDioIqouAyVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Eod1nydk;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TJa7LNNq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Eod1nydk;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TJa7LNNq;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7331F606D814;
	Tue,  3 Nov 2026 12:32:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7331F606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Eod1nydk;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TJa7LNNq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Eod1nydk;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TJa7LNNq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AFF5A226A2;
	Tue,  3 Nov 2026 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OObJ1Vsh+Tag+2HW3Ymk76zg+lXhJEtYvCWaVbRWRqA=;
	b=Eod1nydkJz9AcgGVAolLcaIB1bNAbBSn+8qzj5OVZi7x/m6kb5gBLi9psLMw9dJQCwcGlQ
	gJQTG1JuESYPlpEVDuj6ph9pIsfpaALYIiBbwLMWNGQyPVh9HQnw/BFJDeMkHV6wItfc3N
	PJ5DPKd5g4a3OM266pC9QeMoFqIW4ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OObJ1Vsh+Tag+2HW3Ymk76zg+lXhJEtYvCWaVbRWRqA=;
	b=TJa7LNNq+KZ899Uc0weFpWlE3P5Z0OUsUq3lDFHsEmrGhR3SMlkEJkaVRJ2gCJrAfJaPLq
	L1agNvBh3Kd5K6Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OObJ1Vsh+Tag+2HW3Ymk76zg+lXhJEtYvCWaVbRWRqA=;
	b=Eod1nydkJz9AcgGVAolLcaIB1bNAbBSn+8qzj5OVZi7x/m6kb5gBLi9psLMw9dJQCwcGlQ
	gJQTG1JuESYPlpEVDuj6ph9pIsfpaALYIiBbwLMWNGQyPVh9HQnw/BFJDeMkHV6wItfc3N
	PJ5DPKd5g4a3OM266pC9QeMoFqIW4ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OObJ1Vsh+Tag+2HW3Ymk76zg+lXhJEtYvCWaVbRWRqA=;
	b=TJa7LNNq+KZ899Uc0weFpWlE3P5Z0OUsUq3lDFHsEmrGhR3SMlkEJkaVRJ2gCJrAfJaPLq
	L1agNvBh3Kd5K6Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BC30134B8;
	Tue,  3 Nov 2026 12:32:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e8InEUHU6WpSBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:32:01 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:38 +0100
Subject: [PATCH v2 3/7] scsi: qla2xxx: Fix use-after-free on late bsg
 completion
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
Message-Id: <20261103-qla2xxx-fix-v2-3-c6d2cdf2c806@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -17.30
X-Spam-Level: 
X-Spam-Flag: NO

When the abort in qla_bsg_found() times out, the outstanding command
slot is checked again under the qpair lock before the sp is released.
The check only bails out if the slot holds a different bsg job:

	if (req->outstanding_cmds[cnt] &&
	    req->outstanding_cmds[cnt]->u.bsg_job != bsg_job)

If the firmware completes the command between the timeout and taking
the lock, qla2x00_get_sp_from_handle() has already cleared the slot
and qla2x00_bsg_job_done() has dropped the INIT reference and completed
the bsg job. The slot is NULL, the check falls through, and
qla_bsg_found() writes to the freed sp, drops the reference a second
time and calls bsg_job_done() again.

Bail out unless the slot still holds our sp.

Fixes: c423263082ee ("scsi: qla2xxx: Fix abort in bsg timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index ab559048dbb8..8565f4e838f9 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3669,11 +3669,11 @@ static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	/*
-	 * recheck to make sure it's still the same bsg_job due to
-	 * qp_lock_ptr was released earlier.
+	 * recheck to make sure it's still the same sp due to
+	 * qp_lock_ptr was released earlier. If the slot is empty or
+	 * reused, fw has completed the sp and freed it.
 	 */
-	if (req->outstanding_cmds[cnt] &&
-	    req->outstanding_cmds[cnt]->u.bsg_job != bsg_job) {
+	if (req->outstanding_cmds[cnt] != sp) {
 		/* fw had returned the bsg */
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		return true;

-- 
2.56.0

