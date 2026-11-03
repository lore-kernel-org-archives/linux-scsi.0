Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709114;
	b=bvEQ18h79Knp5wJp1GDWG9VZ343TiImJ3oDkEJcLOqH3LRa3f7SGyaX4Xfr6W+UKq64q
	 jGCJJNoSqK/w9IqCi9FVKyxgrpifN8OklNaLu4+uoBeCKSTV/Y2WqjgU+L6GWQ24KsWyl
	 b68htFDaE8ZcYmjxlER6CexZOyG3pScazxenLqKKiQxXizO7JDD+OuukLspV/vr+F6zNb
	 uA4BQ99/cFUMcIyELA93y9+hP7CWWEpaoJv9DjcTB9zXByGI68rnVCHXAhBiWsRNLXbzf
	 iUageWflyX5ntq3E5jfKq374LU4vI1v+RU1ODnSMr6f5rjcGIj+BJdFkogL1I/T1lfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709114;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=ZYgVNsj6D5cTCzBTpLaNRV5kU8YPbX8935wOF5evyTQ=;
	b=USjpm0k5paZWr25oBMQ2EM5rvQ6xcq5eb0ZgYMwtd4zS6/Zet8WDayoZy+A514siDEC1
	 b9bE2zRfYXbiL/4nc9X7xGODK4vQDEdZ3zN8pHGoVQzW14g+EY1fejd+1DN6zNfU2LP8d
	 uf1DtR9bug+pq35dT49sUrXg77CvsbVQ9RYsVgr85OLA3AevRoawPEnG6DnUamy3RZwkE
	 58MdY4tdrgPfI/U+8qr2GYfVmLWxEgiSZNgy3M3jt+PCF5Dms8Z/gqCuflcbEtRfUb9mb
	 H3YqvN4HXkWQ3pcsfCwz4ScKY/S0m5okhIxDUKxGwhHCS8E7zktMJPWQgpJ4toKc+Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wtvm1nfO;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RXHlJmJG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0mZEaqXM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=v3thr1Pj;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61032606A327;
	Tue,  3 Nov 2026 12:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61032606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wtvm1nfO;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RXHlJmJG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0mZEaqXM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=v3thr1Pj
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5861C2041B;
	Tue,  3 Nov 2026 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZYgVNsj6D5cTCzBTpLaNRV5kU8YPbX8935wOF5evyTQ=;
	b=wtvm1nfOAhA2ZZ0zmc+9zhKJZqlqdAOz+KYdjKc/frBGtrJz57MeB3d488UqPb5UQZAkNC
	Vr/0HO0xZXya0CC26uprHFZp1CqMrfT96h6GGCnFvhq2Lk27gAcGFX5OZSKgecp+TTRG04
	ejGWlxQW+m6vfzGcNpUj3Hk4LSALfs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709111;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZYgVNsj6D5cTCzBTpLaNRV5kU8YPbX8935wOF5evyTQ=;
	b=RXHlJmJGbG43y0mckD2+51zWrDhj4iopEXKXPjrE2XVKDoPj7esWEwI1gtEGwWip7ob2Wl
	gEBSggDvHmKLpXCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZYgVNsj6D5cTCzBTpLaNRV5kU8YPbX8935wOF5evyTQ=;
	b=0mZEaqXMcuHw0KtC7qgHwt/flPwJs65ZwM26uBjbofMML5j/QD7WIJaf7xsXdIQh7vMRSl
	pfu0YDRBunOIr94mPbib2ZxkbzjG9NS1cSos+CQ9fJeL6BUdsK+D1Al5PvP3LOKtIU9o/S
	uFPsxH68V/qm28ZpFy1CVh90bh9T39M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZYgVNsj6D5cTCzBTpLaNRV5kU8YPbX8935wOF5evyTQ=;
	b=v3thr1PjJ4fUQpz38LQ2NHZcp7Evmil6HAJLoIGfEw3wdvcFhPwXMJ+yt/GLdgkuUcA1Sy
	TRUJS2p5IEN6nvAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08220134B8;
	Tue,  3 Nov 2026 12:31:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZpdjNDXU6Wo+BQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:31:50 +0000
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 0/7] scsi: qla2xxx: Fix races, leaks and inverted logic
 found in review
Date: Tue, 03 Nov 2026 13:31:35 +0100
Message-Id: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQ6CMBBEf4Xs2Zp2Y8B68j8MB2i3UmNAu9DUk
 P67Ba8e32TmzQpMwRPDpVohUPTsp7EAHiowQzfeSXhbGFBirSRq8X52mFISziehldElro2SBsr
 iFajEu+3W/piX/kFm3hRbY/A8T+Gz30W19f6boxJKNIQNOmfNqT9feWE6WoI25/wFQI7Fl7YAA
 AA=
X-Change-ID: 20261029-qla2xxx-fix-91c92616c10c
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Himanshu Madhani <himanshu.madhani@oracle.com>, 
 Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,msgid.link:url,suse.de:email]
X-Spam-Score: -13.30
X-Spam-Level: 
X-Spam-Flag: NO

A review of recent qla2xxx changes turned up a handful of bugs in
commits that are already upstream and partly marked for stable:

 - debugfs: fce_release checks the FCE state outside fce_mutex and
   can memset a buffer a concurrent write has just freed
 - fabric scan: the "scan active" early exit clears SF_SCANNING of
   the scan that is still running and schedules another one
 - bsg: a firmware completion that races with the abort timeout
   leads to a use-after-free and a double bsg_job_done()
 - target: the big CDB allocation failure path frees an
   uninitialized se_cmd, leaking the tag and num_pend_cmds
 - PCI error recovery: IRQ_NO_BALANCING is cleared before and set
   after the reset instead of the other way round
 - NVMe: an unsolicited LS request from a port without an NVMe
   remote port dereferences a NULL pointer
 - SFP: the 64G speed check tests the wrong bit (cosmetic)

All patches are build tested only.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Changes in v2:
- Add fixes for the fabric scan, bsg timeout, target CDB allocation,
  IRQ_NO_BALANCING, unsolicited NVMe LS and 64G SFP issues.
- Link to v1: https://patch.msgid.link/20261029-qla2xxx-fix-v1-1-7e272ffdc4b8@suse.de

---
Daniel Wagner (7):
      scsi: qla2xxx: Check FCE state under fce_mutex in debugfs release
      scsi: qla2xxx: Don't clear SF_SCANNING of a running fabric scan
      scsi: qla2xxx: Fix use-after-free on late bsg completion
      scsi: qla2xxx: target: Fix cmd release on CDB allocation failure
      scsi: qla2xxx: Fix inverted IRQ_NO_BALANCING toggling around PCI reset
      scsi: qla2xxx: Reject unsolicited NVMe LS from ports without NVMe rport
      scsi: qla2xxx: Use FC_SPEED_2 to check for the 64G SFP speed byte

 drivers/scsi/qla2xxx/qla_bsg.c    | 8 ++++----
 drivers/scsi/qla2xxx/qla_dfs.c    | 8 ++++----
 drivers/scsi/qla2xxx/qla_gs.c     | 4 +++-
 drivers/scsi/qla2xxx/qla_init.c   | 2 +-
 drivers/scsi/qla2xxx/qla_nvme.c   | 9 +++++++++
 drivers/scsi/qla2xxx/qla_os.c     | 4 ++--
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 7 files changed, 25 insertions(+), 13 deletions(-)
---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261029-qla2xxx-fix-91c92616c10c

Best regards,
--  
Daniel Wagner <dwagner@suse.de>

