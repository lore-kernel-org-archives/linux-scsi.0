Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279749;
	b=uY2PGVZDAIZB7I6o44Jv4WVwZoRQVpy7yMjOxusQ5m/35awdQRikvgf5rZABtpy9rnZ4
	 imtWmsFDEwNZgLqZPbO4wbs2Vdrn+nTFY2qxfoZFV5O8B5Ti0JFEMLyUoQaVKY/Ekr85W
	 672ITr+4Qte+LmAw1VcEXT0BN/H14o6l2XGzq/1Wd/0fySu4/O5iUTSerB7fp35evH7oE
	 H6gcTHwbpdbDx3P21m9qzZx3aHdMFgy+kKRfeDJULFdwpEB5uo5yLOX10CE7W6nfDi9/d
	 LIPboT0REzr2pfCwDv+/sbxF+5ESKccMUtoViI5svOWN7m4ZoGqQ0NdCZk6l6sUJnrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279749;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=d7d1UVwvKGrgB7+MNPNGp4vckOA+VTyvPz9idktThnk=;
	b=5W3xegm4BfAMAIpBetepOMVPr8/SW5j450dRAwBH6UFl3yEiq9pl0PsgJtCCeTXrGc1q
	 RVHm6Rwv6FatGxIxAeMw+AeBkUdUew/ijHh+ouG2NlACje0Px3FW/0+PYCyEizi16RU3T
	 jqUM7UMirbfhR5Opt3897KEzp4870Ax5Se/mUfDHYuYHWvDWanizoM5EZgHsn8H6aewOt
	 Xyg3flOU0+sq34o5RavSfHOz9R1gA4zlVi/b5olIpLSLBWrpbJerrOfhU/4vfXgMagiVD
	 u8lchyNNJLrwbu0Gv0Gv7E3ny6G4SdAbEuA1ZWr7b88a19YM+H/isJs2NpM+ECmb0QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=z1db2E7T;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0k8HWk7o;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m1vp1aoD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bFryf+WM;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F86606A31C;
	Thu, 29 Oct 2026 13:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49F86606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=z1db2E7T;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0k8HWk7o;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m1vp1aoD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bFryf+WM
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ECE341F7F2;
	Thu, 29 Oct 2026 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793279746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d7d1UVwvKGrgB7+MNPNGp4vckOA+VTyvPz9idktThnk=;
	b=z1db2E7TwogPMD8Q3f4y2j8NbOkyAfQSLE6mDDF3IbTvuvXm3vDyEBUScya1Uar3vP9vdJ
	6xLmEwS1pabNDwwEXqbmMWz2YHSw9Wuc36Oq8kxaJBLhlylJ8J8pGU9UzrSSQzZ5E3rUDg
	PQviEsFB5jjpwCgO7vtOhXOwdbKEDN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793279746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d7d1UVwvKGrgB7+MNPNGp4vckOA+VTyvPz9idktThnk=;
	b=0k8HWk7oWzlKCpcWL+CmD+G8Vfl19ucwMamgwn7CW80RJW0vMeTmMdUFDGI+5srUhCczi1
	CmGkAfJA5hB4x0Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m1vp1aoD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bFryf+WM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793279744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d7d1UVwvKGrgB7+MNPNGp4vckOA+VTyvPz9idktThnk=;
	b=m1vp1aoDXKIacrjliT4oWDRr9KzjdrP9ehJnvXD8/5RAg7yXsm495E/1awBA4sJX5hOl9B
	m1C8MhTLtSoSP7WB4FyzvLXvrxbqQbxm1aJbsuG8i0J+cEnHVDn8Ecyi5vWs9mAgXW3k1V
	ANciSeBhYJIrpc8Y5WwxyoOp1cAYkkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793279744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d7d1UVwvKGrgB7+MNPNGp4vckOA+VTyvPz9idktThnk=;
	b=bFryf+WMuO4/j3M+HfuaszfjDSX9j8tB43JZXjzZ0xM+hh4pxq6Te4CFlVr/9tf5X5UFHO
	b1BXPdHFsH9RfLCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBB2A1339F;
	Thu, 29 Oct 2026 13:15:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5QjcJABH42r/cwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 29 Oct 2026 13:15:44 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 29 Oct 2026 14:15:30 +0100
Subject: [PATCH] scsi: qla2xxx: Check FCE state under fce_mutx in debugfs
 release
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
Message-Id: <20261029-qla2xxx-fix-v1-1-7e272ffdc4b8@suse.de>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMSQqAMAwAvyI5W2h7KNSviAeNUSPi0qoUxL8b9
 TgDMxdECkwRiuyCQCdHXmYBk2eAQz33pLgVBqutM9p6tU21TSmpjpPyBr1oh0YjSLEGEv3dyur
 neDQj4f4u4L4frSwOrG8AAAA=
X-Change-ID: 20261029-qla2xxx-fix-91c92616c10c
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Himanshu Madhani <himanshu.madhani@oracle.com>, 
 Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: ECE341F7F2
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.51

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
 

---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261029-qla2xxx-fix-91c92616c10c

Best regards,
--  
Daniel Wagner <dwagner@suse.de>

