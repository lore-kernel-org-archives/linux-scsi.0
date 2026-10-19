Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792446946;
	b=uxPM02NE6TY9rBXS5Nd606kK7XLlPJ8b53PQ19kxOkUMolbPRoAtDH06amg8O7yk2wSf
	 r/eeVWRhYApt/oExPK11weSAkfhMxeEmp8fXJ7ECidhcmM8RcMmn/fIKcgvJVKFPh3mT3
	 3lhXP4X2X2ZNwTyxakIqzkk4xI9GhdWc+hR+H/CPmh3pHDfcTZaghey7/Cq/bG3N6npM2
	 xT1yUTqvO1WBHLOEDyFyuXIfvxvlrkomaT65rKE6FZtNj6KCmyrzsEiTpP6+CGRlJsgMg
	 dQTdp7riPSbDscDCQCoIbNZbHEsOi2O7wRBHu+utsFeZ5jdokWVOJvucJJBrljtoQHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qnAcF7DiLfesErSEN9jHLUGZI40lao7HDdIoFwsZrGo=;
	b=Qgzq5yUyQwm60C6i+UVR6m7wIW9iQRsKQUcigjxaoGRE5FA+yEh+CKFpfcV1epvnlpva
	 j0IwmSIl1m6n0VZApbilCw1eTeu1fkPWo2mo1HaOPaG7i//p0pqA8IHYesJ8G3lXbfPGm
	 UwoNhnG5+04gQvjpw8a/BnVyp19jjXiSQ82iB9B8ABIKJVWmN1cfx/6jiMEWRbngTKBhx
	 r8ysGSTYeeMic4SoFvqtqFNluzqqtQ/lG/XIfgQpgPxeBabh8ahB0XTRVqYxBXBLSDzbC
	 8fBYC83fHosOZPqEZZdAPOMIdVsqqfWC2HDdTdtcsH2fEzqfvzkw8YTI5EPqFAQLwrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=urMm9H5G;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8BC606A31B;
	Mon, 19 Oct 2026 21:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F8BC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=urMm9H5G
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j7q9Y48Xjzlfvpn;
	Mon, 19 Oct 2026 21:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1792446941; x=1795038942; bh=qnAcF7DiLfesErSEN9jHLUGZI40lao7HDdI
	oFwsZrGo=; b=urMm9H5G1ejBcfya+1u42UquflckVusTr4HPjj/i/j7cjjnozoK
	CPAkKzt+37DHeGR4gvlBMaQ/VBg+KblFReuARp82fChxH4bBOXXBuNbyknehmr8a
	/ZAIHJQNYcaB9ZEPOHjcveLbfPS+hTUlFxB6+3GlW8gKoQQJj4lq4hluaJhyf1ZO
	vOINB+0U9yXSlAO8W5qCU2UTjwKckHdOQC7FFXNT7ENO6310UZD4S9b4SeIyCdO0
	sH1YIBClbWwOVnbZjjXVyqPQkvO5EB0vXKCSfzZ/QbIwuXa0dGnKJsXSUCyWp89j
	KQDvxRTgpt/xf+JQ0em8Xv58Jgb9wvrugiw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pGZJ_9Rcjmzp; Mon, 19 Oct 2026 21:55:41 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j7q9T0r1hzlfvpd;
	Mon, 19 Oct 2026 21:55:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Lianqin Hu <hulianqin@vivo.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in sd_remove()
Date: Mon, 19 Oct 2026 14:55:32 -0700
Message-ID: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

If a SCSI disk is unplugged while runtime suspended, its request queue
is still in the pm-only state when sd_remove() is called. The runtime
resume attempted by scsi_autopm_get_device() fails because the parent
device, e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
resumed. Hence, sdev_runtime_resume() is not called and the pm-only
state is not cleared. Next, del_gendisk() calls
blk_report_disk_dead(disk, false), which calls sync_filesystem(). Any
bio submitted by the filesystem waits forever in __bio_queue_enter()
because the queue will never leave the pm-only state and because
GD_DEAD has not yet been set:

 __bio_queue_enter+0xb8/0x174
 blk_mq_submit_bio+0x640/0x7e4
 [ ... ]
 exfat_sync_fs+0xa4/0xe0
 sync_filesystem+0xa8/0xdc
 fs_bdev_mark_dead+0x30/0x88
 bdev_mark_dead+0x54/0xc4
 blk_report_disk_dead+0x8c/0xd4
 del_gendisk+0xa0/0x2f8
 sd_remove+0x30/0x60
 [ ... ]
 scsi_remove_host+0x88/0x18c
 usb_stor_disconnect+0x68/0xf4

Fix this hang by calling blk_mark_disk_dead() if runtime resume fails.
This sets GD_DEAD, tells the filesystem that the disk has been removed
without attempting to sync it, and wakes up any bios that are waiting
in __bio_queue_enter(). Syncing the filesystem is not possible anyway
if runtime resume failed, so no data is lost that could otherwise have
been written. If runtime resume succeeds, behavior is not changed.

Please note that this patch converts temporary runtime resume failures
into permanent failures. Before this patch, if runtime resume fails
temporarily, a filesytem sync would be postponed until a later resume
succeeds.

Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Lianqin Hu <hulianqin@vivo.com>
Reported-by: Lianqin Hu <hulianqin@vivo.com>
Closes: https://lore.kernel.org/all/TYUPR06MB6217DD31B1B3CD09E431CC12D292=
2@TYUPR06MB6217.apcprd06.prod.outlook.com/
Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b0d2542fd317..dc45df819c42 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4268,7 +4268,15 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev =3D &sdp->sdev_gendev;
 	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
=20
-	scsi_autopm_get_device(sdkp->device);
+	/*
+	 * If runtime resume fails, e.g. because the device was unplugged
+	 * while runtime suspended, the request queue stays in the pm-only
+	 * state and any I/O submitted by del_gendisk(), e.g. from
+	 * sync_filesystem(), would wait forever in __bio_queue_enter().
+	 * Prevent this by marking the disk dead.
+	 */
+	if (scsi_autopm_get_device(sdkp->device) < 0)
+		blk_mark_disk_dead(sdkp->disk);
=20
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
