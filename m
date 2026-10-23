Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792722075;
	b=0ODdwYay4BwH+90BpJRIfeEmHlZPq4OZCV5H1sYeI9wZyzzl8unrooEoK+YiJ7UqnXMU
	 2W8VkX+OWy6iz2lH4u8tF8xKRIM9ikkklcjUrbUFctUxe4K8BkYy849gU+mbOmhlZARKW
	 zVkhcZrLQD2b+8uzKN7iKsJXUH9IrPpWpWSkTDeXzBeJzzgqwIKVlvzVetS2lwXXZcEFN
	 97qu6nbxYdhNSsu/6rKcxURLFCPOWAlOBEQiMbkcvtcjyia/kEMZ00SsyPqj17YV/rI8J
	 JYlBAeu7HDZb35U1eAmg/0wx2B93jCmR3Uc8jqFqKitIU/r77K0lISGNwa4eUwnXA/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792722075;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XXX5hCVe20W2DEnZ0HF+fr0EqmB3/p1IDPVPZBeHOFk=;
	b=ta6OWtoSisS+qrtO75v4qIgH4p4qnikBxZA1zvewlIqevRpIZ7pK6W7cFdoinQHzqZdz
	 dOs2sov8kuizmwtQ0f9oWZomk6GFCcoC43jlD1Vso41pIsilleoB4gKZRNZFQr0SgdVrP
	 wOgZVqJF97kEODjH4rRXBfKJjVGroZOu64IVRxGZyQLK7lBcYggkkAikA6Y9uOjocrm5t
	 fVX7YHbH2eepDUMW6n4250RS4+EiURiCB9Hsc0vj7G6cuwM5z9nyShjdkKRZpI23vhiGE
	 we4BvF8DHYXNkyTMG4LjSwASWD05SYy7/WtZIvFE42J30YrHgv1ox/PF773/DIdTKyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=D7ulQNAY;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE2A606A319
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 02:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EE2A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=D7ulQNAY
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso158866a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 19:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792722072; x=1793326872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XXX5hCVe20W2DEnZ0HF+fr0EqmB3/p1IDPVPZBeHOFk=;
        b=D7ulQNAYpQewZbA6rR4DxTDcoX9oMPs7QYZdu4flYQ3UEakeUTfC7TOSxNNhi8OAh0
         jDQuD29MTwJKgOS1IOHArMimnzfJvu8FvdSr7izuK9dqyz17oRSlKwzQnI6FdQYMRM82
         G2QDHuzwugLBqXAcH3RQLT67SVYC7Wy9FRlzGyvyonoPH8n2hHqF7Jq7O5V/tnHnkysF
         f7IzCDR3eEDqQ8hrJgkR7w8v3aFcQbqYIa3YUKzlZrlPL7t84828V5X28zkPfi4vqAQy
         wZwqaNglqVCbGHBLfFWt4ePexQuKzGwLdr1kdzFwULfW9msWfuVyMNwPXDotZKh7xJcR
         nKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792722072; x=1793326872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXX5hCVe20W2DEnZ0HF+fr0EqmB3/p1IDPVPZBeHOFk=;
        b=JeXWGGwAVdtQFmLnMkgQEVY7xeEhF51Di4lJe6LOt0DH/Y4C80PCsQRSi9Y3yBQwCY
         jsuAtNsp0KjrKSPt1mPA+kLW8mre+NtTJQqlGzNH9d7kDKsqyWvm7xKLdrbc6Y/4j0Nb
         mT9V3pYFCVGuMJy0F6BkUymog7b9aMCuPckU9p3RCXHyODevNre2oU1mh8xJ6zgP8akv
         B59cRTaI9UaOka5WWDZ+mIObA5ax5rNccjBDoYgCDuqwa3S6nOWwpt4HSOCGVNAMV9Z8
         ORxrP289XGJX2ckGBozq/3dTrjDD2bBAAhnNvKU3gdUKMP0XFZ6M4ygiC/YgLxxoKYVG
         OlsQ==
X-Forwarded-Encrypted: i=1; AKwUvBxaT9k9xS1kEq44PDoulIsZoG46cY1mz0mtU1QGPHApfRlAQAauDZgNQDDZ9uDpBsLAJqC7dnHn/HNz@vger.kernel.org
X-Gm-Message-State: AFq9FYJLWEWTgUxkVJc3YzIna83nbJAUV9P0SV1kIQElRKwIk3r9ZgFM
	cqP+Y92ZLlbf7bdgvMazOKjT92WHN4McmQxCkRToIxy5vwPr0jdiE2VhDB61USu+18o=
X-Gm-Gg: AYBFou1z7dwkF1aVqRKa8DXvBaz0J6EAeWNRkhay6PiqXaAlcpNlOaiIaoMJXxKavdM
	M+jS+OMcUQU6JfczNWu4/rkloNMmaPib69jc6xFK5sE1H7B0lWadJQh4A6VEilMkxjAUEQoFJgF
	sGsArjmd+sfz1KH+muRj8U02dJxePaELIwPI8pSv98jf5JXQwtqFa9UUzP569IzCCSBGAsl5jTk
	ryoACss2o6okiBS3fXDS8kFkAynxdNbdChVc/dv9acFG0TvjrxQnkLJ3ztOR2QlLYJnL9Ly6ssr
	qfi7ZFmVUUO16JZ/iRUts+tGDoZPaY5IQoq9N+HUpxevqOBqwnMgY8yiWT6dBlSGfvJPWCHcBAB
	Eg0RgUDBFghCISdiIJFXFxbPrMaq+a7wRcr9nyXs3ILnJSYC3xgtEDR/vqcymiVwBdWzcGN1teh
	reA03mYcSya0kg315+jS87UUeZ6p2Y2EAu1sc4jJscaMmIkwhZqA3JumfgYrz0wjpHx3V2212WS
	JQOQ3Wm73WSL6QLq5vGvuWVoo7/qjplEsw92+ZzIfUmu7PqBdPISbBKuvBno/0N5zyKdYtbLleX
	AKE=
X-Received: by 2002:a17:90b:1fc7:b0:3ad:3715:d21 with SMTP id 98e67ed59e1d1-3adce7ca8c9mr598095a91.49.1792722072334;
        Thu, 22 Oct 2026 19:21:12 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add2994cd2sm183922a91.3.2026.10.22.19.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 19:21:11 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nihar Panda <niharp@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.ibm.com>,
	Steffen Maier <maier@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH] scsi: zfcp: bound the RSCN page walk to the status read payload
Date: Fri, 23 Oct 2026 11:20:56 +0900
Message-ID: <20261023022056.3106651-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zfcp_fc_incoming_rscn() takes the number of RSCN pages from rscn_plen in
the received ELS and walks that many four byte pages out of the status
read buffer payload. The fabric chooses rscn_plen, it is a 16 bit field,
and nothing compares it against the payload. A value of 65535 gives 16383
entries, so the loop reads up to 65532 bytes out of a payload of
FSF_STATUS_READ_PAYLOAD_SIZE, which is 4032. The status read buffer is a
single page and its payload ends at the page boundary, so the walk
continues into whatever follows that page.

Every iteration also hands the four bytes it just read to
zfcp_fc_enqueue_event(), and that event reaches user space through
fc_host_post_event(), so the bytes past the payload are reported and not
merely read.

libfc bounds the same field. fc_disc_recv_rscn_req() refuses an RSCN whose
rscn_plen is not covered by the received frame. zfcp does not share that
code, so add the equivalent test here. Compare against the payload size
rather than the firmware reported srb->length, because a bogus srb->length
need not reach the payload at all.

A conforming RSCN is unaffected. An FC data field holds at most 2112
bytes, so at most 528 pages, well under the 1008 the payload can hold.

This is an out of bounds read and an information leak to user space. It is
not a write and it corrupts no state. It assumes the adapter passes
rscn_plen through unchanged, the same assumption the host bus adapter
mediated paths in other drivers already make, and one the driver cannot
check for itself.

Not tested on hardware. The bound follows from the field widths and the
payload size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/s390/scsi/zfcp_fc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 05d0812978798..24efd29b66bfc 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -270,6 +270,18 @@ static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 	no_entries = be16_to_cpu(head->rscn_plen) /
 		sizeof(struct fc_els_rscn_page);
 
+	/*
+	 * The fabric chooses rscn_plen, so refuse a value that would walk
+	 * the page list past the end of the status read payload.
+	 */
+	if (no_entries > FSF_STATUS_READ_PAYLOAD_SIZE /
+			 sizeof(struct fc_els_rscn_page)) {
+		dev_warn(&adapter->ccw_device->dev,
+			 "An RSCN with a payload length of %u was dropped\n",
+			 be16_to_cpu(head->rscn_plen));
+		return;
+	}
+
 	if (no_entries > 1) {
 		/* handle failed ports */
 		unsigned long flags;

base-commit: f47d223627f80cb7a1eb14c585fe6cb35de5e984
-- 
2.43.0

