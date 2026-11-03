Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709131;
	b=scKTQiUXFuedFEWgLwRIxMsHKpjyheTi9KR4z5ZlCu8OxqKb9wMxoWN912qr0OB/C8cK
	 OAPStnowJJZniAnCjTBUoOKwf2jLkVDV+6UyefQkJgCF3x6BV1HzUE6B5DNcuH6pId01u
	 SBB/92ZXuR4DsIjl08otqjpMOucxE0A3OO7LTrafDGOE7mJ+G3S6vl31P9RFrG4qgjSa8
	 ke16DX6THY/boFaJnZrUduPa7XhWNQxCOR9ATFxa4w1WvKX8hAx6if9sHflbdfijg/IiY
	 XQAHsAMniw5MGkh/godkc67HW7HGzBWBuOhsg9zcCCdDa174QjmHEIw9RVg68tOBagw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709131;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=afHS8zwu/16De20akmb+PF8aMcWpg2XEqYVbWQIuyf0=;
	b=gUYt5Y/3NndIcSfUu1d4tSA6i/9VrONvo//CTO775QXGMgFu1Pg792Rdj7LQpLHXWD0J
	 Eaj3ag9VjXPfgD2GTZGqRln20Z8yuSBacw+my2P9sQsRoJgjyIiWuxcYk0xtJLusg92Xx
	 wY44Ere5/U+OHr7iiMQu/FJgE/wUbbJWqWY5swhZdIiTqlqb+NjNeMgVt20UayEgsiiLg
	 UGIFjFiinPoxVZ1g3h8TETGalUCS4MhoNCJIEKtF0d85/vaYFBt2vjHltnPXjoyAh+Q6z
	 hpA1En69KEJbw6oSpNbjmIxie3HeT8137O3T78B0J6NxzCyIgjxX0MPjDalZXnMm0bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bdinvgl8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=maZNZ8nP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bdinvgl8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=maZNZ8nP;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE13E606A327;
	Tue,  3 Nov 2026 12:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE13E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bdinvgl8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=maZNZ8nP;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bdinvgl8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=maZNZ8nP
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1256120570;
	Tue,  3 Nov 2026 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afHS8zwu/16De20akmb+PF8aMcWpg2XEqYVbWQIuyf0=;
	b=bdinvgl8yKvQ7fa1lLcpVAvv8QrxZpnUyJ9aruT2OJAErbpQLXfjQxx/sR2gp1SnOk8bqk
	lIH3F2h6n8nucBPg80t4yYzarFAUnUNvzpiGLXBl4FojZ4+wmr26N7DvA87XNmdl0kUFuO
	Z3oQNSJ9oBSGY22lWvvNPUzoaY4pjo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afHS8zwu/16De20akmb+PF8aMcWpg2XEqYVbWQIuyf0=;
	b=maZNZ8nPad7f6twpXE0CAQz3FKRu0YXEXzW74aKhiYPXOyPfDFfWeitCIbqVyUf2SR9Ed+
	JDeHMykZyBsKYjAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afHS8zwu/16De20akmb+PF8aMcWpg2XEqYVbWQIuyf0=;
	b=bdinvgl8yKvQ7fa1lLcpVAvv8QrxZpnUyJ9aruT2OJAErbpQLXfjQxx/sR2gp1SnOk8bqk
	lIH3F2h6n8nucBPg80t4yYzarFAUnUNvzpiGLXBl4FojZ4+wmr26N7DvA87XNmdl0kUFuO
	Z3oQNSJ9oBSGY22lWvvNPUzoaY4pjo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afHS8zwu/16De20akmb+PF8aMcWpg2XEqYVbWQIuyf0=;
	b=maZNZ8nPad7f6twpXE0CAQz3FKRu0YXEXzW74aKhiYPXOyPfDFfWeitCIbqVyUf2SR9Ed+
	JDeHMykZyBsKYjAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C56FF134B8;
	Tue,  3 Nov 2026 12:32:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LMkVJ0jU6WpbBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:32:08 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:41 +0100
Subject: [PATCH v2 6/7] scsi: qla2xxx: Reject unsolicited NVMe LS from
 ports without NVMe rport
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
Message-Id: <20261103-qla2xxx-fix-v2-6-c6d2cdf2c806@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -17.30

qla2xxx_process_purls_iocb() looks up the fcport for the S_ID of an
unsolicited NVMe LS request and dereferences its nvme_remote_port
without checking it. The pointer is NULL for an fcport that is known
to the driver but not registered with the NVMe-FC transport, e.g. an
FCP-only port, a port whose NVMe registration has not finished yet,
or one that qla_nvme_remoteport_delete() has already cleared. An LS
request from such a port crashes the response queue handler in
interrupt context.

Reject the request with an invalid association reason, the same as for
an unknown S_ID.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index beccece1e7d9..8d27cdf58755 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1419,6 +1419,15 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 		goto out;
 	}
 	rport = fcport->nvme_remote_port;
+	if (!rport) {
+		ql_dbg(ql_dbg_unsol, vha, 0x2113,
+		       "No NVMe remote port for sid=%06x did=%06x\n",
+		       id.b24, d_id.b24);
+		a.reason = FCNVME_RJT_RC_INV_ASSOC;
+		a.explanation = FCNVME_RJT_EXP_NONE;
+		xmt_reject = true;
+		goto out;
+	}
 	qla_rport = rport->private;
 
 	item = qla27xx_copy_multiple_pkt(vha, pkt, rsp, true, false);

-- 
2.56.0

