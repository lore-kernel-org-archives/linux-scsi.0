Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721384;
	b=RCp0kcFxWOmWgRnTEu/s2LNtWKht8JDBvj5E3CdnVyRLcg2PhSoupq/ynjaYItoejfCC
	 S7EKT/4CJj1uN+L6HdmCjopHuXz0W45uYyKey0g02erOHYgt9y9guCTHoVegATvaEXBk4
	 w3BLdv5fWXT4PwbxpiSv6tWp3qqQaUiRlYKH3cQBVUq3X7QQkdk2VnyN+yJ7ZMExt5MiH
	 +oDzuWNXUGdTOO1LBjQFmd0oxmceWNd+JmRfWPHc94mqUikL09fuL3mxyR+Vk7eZoydgi
	 A6IE6vHsmuc0D/SB18fxVsGD3bMU2bur41y+0yKXuPkq01WxRhJuuTIJa/HjVAFvuDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721384;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=KrELEAwJpNCkeUSFIEEA9iPaXTDlTgbejvk4WwmN6J4=;
	b=STH7kY15tR2lHT74Kliy6WUUC4nkNJAtMopKof3IYi1TBnnlbc9AIAhjNK6BUuorSCQp
	 AiV8Adr5/mWdeuGkVKsssWrelQHpJE1H5X0GSt4exCPjofKMILTMD0laBvLl/Ih8SqeUM
	 5lxacjkbggUiQBE3HzVMQds34YgzIapKS6TqW1Mn1O+kBy0BoxNwLqXOgHPRl6hySBfzp
	 6e4jMANgS4Q0K/SnJbkWWJ6cXdP1b4UVJpxp0PQ4HI+FJONmgp+uUQKX/kPfX7ZB4Z2e+
	 n/KAi2z4O1+Lk4DQTwM+RJj6LU0BNzXB+XGG9U4W6CmFN9E4XIDtlfZTO32PNRmY2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAF7606D813;
	Tue,  3 Nov 2026 15:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DAF7606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJtTq2T8xz5B14p;
	Tue, 03 Nov 2026 23:56:15 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6A3Fu8UA003138;
	Tue, 3 Nov 2026 23:56:08 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 23:56:10 +0800 (CST)
X-Zmail-TransId: 2afc6aea041af0d-24502
X-Mailer: Zmail v1.0
Message-ID: <20261103235610554mYM6cfXrrF3RpQowmPUzD@zte.com.cn>
Date: Tue, 3 Nov 2026 23:56:10 +0800 (CST)
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
To: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBzY3NpOiBjb3JlOiByZWplY3Qgc2hvcnQgUkVQT1JUIExVTlMgcmVzcG9uc2Vz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3Fu8UA003138
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 23:56:15 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA041F.000/4jJtTq2T8xz5B14p

scsi_report_lun_scan() reads the LUN list length from a buffer that was
allocated with kmalloc() and that the device may not have filled in
completely.  scsi_execute_cmd() zeroes the part of the buffer that the
host reported as not transferred, but only when the host reports a
residual at all, and it cannot tell whether a transfer that stopped in
the middle of the eight byte LUN list header left a usable length
field.

A host that completes the command without reporting a residual leaves
the kmalloc()ed contents in place, so stale heap data is parsed as a
length.  A host that reports the residual but stopped inside the header
leaves the bytes it did transfer to be read as that length, and neither
the retry allocation nor the number of descriptors to scan is then
bounded by what was actually transferred.

Allocate the buffer with kzalloc() so that a host which reports no
residual and transfers nothing cannot hand back stale heap data, and
ask for the residual so that a transfer which stopped inside the header
is rejected before its length is trusted.

The check requires the full eight byte LUN list header (the four byte
length plus the four reserved bytes), not just the length field, so a
transfer that stopped anywhere inside the header is rejected.  It also
rejects a length that cannot hold the header at all: the retry path
derives the length from the device-reported value with an addition that
can wrap below sizeof(struct scsi_lun), and the residual comparison
would then underflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
v2:
  - allocate the buffer with kzalloc() instead of kmalloc().
  - reword the commit message: scsi_execute_cmd() zeroes the residual
    tail, so the buffer is not simply left uninitialized.
  - keep the residual check, which is what catches a transfer that
    stopped inside the LUN list header.
  - also reject a length that cannot hold the LUN header, so the
    residual comparison cannot underflow when the device-reported
    length wraps on the retry path.
  - spell out that the check requires the full eight byte header.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 52f3b525d2fd..e6aac7310537 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1475,10 +1475,11 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 		.total_allowed = 3,
 		.failure_definitions = failure_defs,
 	};
+	int ret = 0, resid = 0;
 	const struct scsi_exec_args exec_args = {
+		.resid = &resid,
 		.failures = &failures,
 	};
-	int ret = 0;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1516,7 +1517,7 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 	 */
 	length = (511 + 1) * sizeof(struct scsi_lun);
 retry:
-	lun_data = kmalloc(length, GFP_KERNEL);
+	lun_data = kzalloc(length, GFP_KERNEL);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
@@ -1567,6 +1568,19 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 		goto out_err;
 	}
 
+	/*
+	 * Reject a transfer that did not fill in the whole LUN list header.
+	 * Also reject a length that cannot even hold the header: the retry
+	 * path computes it from the device-reported value with an addition
+	 * that can wrap below sizeof(struct scsi_lun), in which case the
+	 * residual comparison below would underflow.
+	 */
+	if (length < sizeof(struct scsi_lun) ||
+	    resid > length - sizeof(struct scsi_lun)) {
+		ret = 1;
+		goto out_err;
+	}
+
 	/*
 	 * Get the length from the first four bytes of lun_data.
 	 */
