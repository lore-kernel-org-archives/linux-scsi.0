Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709127;
	b=1hkgfORxSf3JK5g71jANbmAPe2l/K53R38km8HJpGeVnl735M8VLzbTozzA+jKojljZd
	 3La9nBTQl6WoXbYzJj512524RS6ZNuPvsA3VwzNdeYMIcRm4OvoUz7SQDS8hmj03u8PDm
	 2kCHHIjaxQYBvQW3R0HSp+GysJ9uVGiyrZcbgBDiqH8tUl0ty7AVW6NYsSeVDl9n6CQXO
	 qP7GLtDa4+5KA6U1+oPqT8ejJxJsRboupYPDXNIC7plsDfm9Ngmf6wyM+sJBtxJvMZmF6
	 ju8oH6VTt8Dz2cTsAlxijggpY5nZQuiS6GsML+sM2gEaENzMfFEMe1/y0XB073C1Q+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709127;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=eLHj1MqvPSxNJRwQe2kJjh7RW6JL1CbP9jKiRsa1DLE=;
	b=lsgYgxyPdmfnb+ZlVMCXsIHZrXKvZYYYtS1PFDbeh3uMmIUh5UgjMGejun5xoZ5MSN7H
	 fvrw/gvmMA9rPccTxgd4TQp2qFJ5jORDAQ3pSTMN/nkydOt/lpGfLOlR2IoLgsHdwrhrn
	 nK4g1Ualrsv42hXeXZ8pMEYuBh/7VtubRBFHHIwidzWaPq8o/9UWykM7sGz+kpY3GgmEH
	 QFQk5pPa2t0XLQzknWx4iTU9JM/PHBrSru68eTrwpsEYojh97RKYnzK8zM8HN+Qdg0l6C
	 uPqyikMp5SCM4qdx5M4rwTfGbjMtuxZ2fCTjJFKZkYLWwz2Cws5cR+BaoM2h+ostZag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="vwuUpvd/";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PMUEHix5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="vwuUpvd/";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PMUEHix5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D49606EEA7;
	Tue,  3 Nov 2026 12:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13D49606EEA7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vwuUpvd/;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PMUEHix5;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vwuUpvd/;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PMUEHix5
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99DB522758;
	Tue,  3 Nov 2026 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLHj1MqvPSxNJRwQe2kJjh7RW6JL1CbP9jKiRsa1DLE=;
	b=vwuUpvd/EPf6qgzj0QnitSAbVU6R5c8MKpMQWUks0o4t96Q+OGM/X3oOOxGoHSDHVpynQx
	+iW4VjKVUboIcZGQaBP2eCJE8Wrzy8d4DK1yheNwomTUVv0gD+VyhkANbxjWVXLGujGy4V
	W2x4bZpO7w6ABcCAdFy8BlB1/P6Qj+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLHj1MqvPSxNJRwQe2kJjh7RW6JL1CbP9jKiRsa1DLE=;
	b=PMUEHix52mcP7IfsUOmqKfG4Lo2QCwrcSagaMQ8snlbB1Mip6RJZoKLGagb2OojFs4AO/L
	tRiQffAG/YcR5sAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793709125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLHj1MqvPSxNJRwQe2kJjh7RW6JL1CbP9jKiRsa1DLE=;
	b=vwuUpvd/EPf6qgzj0QnitSAbVU6R5c8MKpMQWUks0o4t96Q+OGM/X3oOOxGoHSDHVpynQx
	+iW4VjKVUboIcZGQaBP2eCJE8Wrzy8d4DK1yheNwomTUVv0gD+VyhkANbxjWVXLGujGy4V
	W2x4bZpO7w6ABcCAdFy8BlB1/P6Qj+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793709125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLHj1MqvPSxNJRwQe2kJjh7RW6JL1CbP9jKiRsa1DLE=;
	b=PMUEHix52mcP7IfsUOmqKfG4Lo2QCwrcSagaMQ8snlbB1Mip6RJZoKLGagb2OojFs4AO/L
	tRiQffAG/YcR5sAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55D39134B8;
	Tue,  3 Nov 2026 12:32:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fv8IC0XU6WpZBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:32:05 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:40 +0100
Subject: [PATCH v2 5/7] scsi: qla2xxx: Fix inverted IRQ_NO_BALANCING
 toggling around PCI reset
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
Message-Id: <20261103-qla2xxx-fix-v2-5-c6d2cdf2c806@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -17.30
X-Spam-Level: 
X-Spam-Flag: NO

qla2xxx_set_affinity_nobalance(pdev, true) sets IRQ_NO_BALANCING and
false clears it. The PCI error handlers call it the wrong way round:
qla2xxx_pci_error_detected() clears the flag before the reset and
qla2xxx_pci_slot_reset() sets it afterwards. So irqbalance can still
touch the MSI-X vectors during EEH recovery, which is the failure the
commit set out to fix, and IRQ balancing stays disabled for good after
a successful recovery.

Set the flag in error_detected and clear it in slot_reset, as the
commit message and the kernel-doc describe and as the ipr driver does
in commit 6ac3484fb13b ("scsi: ipr: Enable/disable IRQD_NO_BALANCING
during reset").

Fixes: eaea513077cd ("scsi: qla2xxx: Enable/disable IRQD_NO_BALANCING during reset")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c412c7fb6fe..93103d7e4e28 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8009,7 +8009,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		goto out;
 	}
 
-	qla2xxx_set_affinity_nobalance(pdev, false);
+	qla2xxx_set_affinity_nobalance(pdev, true);
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -8147,7 +8147,7 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
 	    "Slot Reset returning %x.\n", ret);
 
-	qla2xxx_set_affinity_nobalance(pdev, true);
+	qla2xxx_set_affinity_nobalance(pdev, false);
 
 	return ret;
 }

-- 
2.56.0

