Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792530548;
	b=Szg2KRFbmc2zEtkGnMqvH7zbEJCNZzaoYhomgTb9iDXudgANo6mMOsee5/sliEF/aLqo
	 wVCX0PIQhlORfT63NvHsL5UL/awV5s6/PIxYLiCvwGlov5CCiaPuarme6/pQ9jV2TR0sZ
	 I6XDYSb1w3fs/Z5iXmUP30RUbr40CD/MdHSOmdWbyD9OpX45H0Lo5EuxvYwafa/QR3xTO
	 GN8ePjF7ARHN6B4V54wgfUCsFqqjCApu7wU1NajQO6X5Tujx/ivSIqaqvADnaRYcMrUiz
	 L82fY7L6dhw8ymGf8vgFfIB/pGrO3RNp6Ww/DCd5Ft1r3PF2ef7+iD7ieHpHEgtvXXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530548;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=UYhLgunWkT1r2zjrjSU63H7YEQH2F+XP4XYRth7CJ+Q=;
	b=GYEcH/WqcFYvp0Y4676/uJYTgofIp2bITYD9vgfQteWtZnbJ6+ZYluzPak0lBMSn/sGm
	 mC9B9FLPFYm4LZlaaYc6aD1Ph2CWzXqKcrVw3ojNpRb5mUypxCP0ILMyXBBdSdPUTxnkU
	 mtSnAyi5J/cWrbyxdvcoIfh6/TX2xWS3w3olmkjHMLc6YnJbuOIRYy0POT1OYXZavbSud
	 iWkwmeFVifIgdtf0XzTvFPIkcEzjTn+20b477kI7LkiQxuwLO5PY+zKbp4cDhKvP6RvmX
	 PVUJKXbQIT52w4rEMdfau0yKYaTCQ0xzsI4g9GPjsubu39wlgfVLhSshh21HI+AprGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=palmit.com.au;
	spf=pass smtp.mailfrom=palmit.com.au;
	dkim=pass header.d=palmit.com.au header.i=vince@palmit.com.au header.a=rsa-sha256 header.s=zmail header.b=yxhbpd+q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.50
Received: from sender5-of-o50.zoho.com (sender5-of-o50.zoho.com [165.173.182.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E41606A322;
	Tue, 20 Oct 2026 21:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12E41606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=palmit.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=palmit.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=palmit.com.au header.i=vince@palmit.com.au header.a=rsa-sha256 header.s=zmail header.b=yxhbpd+q
ARC-Seal: i=1; a=rsa-sha256; t=1792530542; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Fp0dXy8cCAsJvezMjMgqXtNPv10Ia7tBMyVrY8LC5mO+eRv9rXxIrhOkYwu66EjJQa9lVOrY1ttnaT5Z44YRZtsUuXQQhWVIfOj9Byr/8+JwUTvhxoTTQ6UJARokVFyRPKRwjStMsoTBthPbe8qytZN7jScwlmgwUszovo/duUI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792530542; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UYhLgunWkT1r2zjrjSU63H7YEQH2F+XP4XYRth7CJ+Q=; 
	b=jeFKND5ckOKkm7stR+lj1T4G2MyTlniBW/xjpJbHZgJQIqNXSzb7s8OQeTp2psoA5DW2hKxWnOGHAo2OelUg40rTOBAdJBYmzvdSaMLaxaHzf/GXD1O3bP4yWqC2kjFTArCkVt3ExV7HbngikC9LpUgO2nlpfig+ICu+kv9IgA4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=palmit.com.au;
	spf=pass  smtp.mailfrom=vince@palmit.com.au;
	dmarc=pass header.from=<vince@palmit.com.au>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792530542;
	s=zmail; d=palmit.com.au; i=vince@palmit.com.au;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=UYhLgunWkT1r2zjrjSU63H7YEQH2F+XP4XYRth7CJ+Q=;
	b=yxhbpd+qDYooCqWE7lD+tVELN1ZANcd53IrGsyCLmiRree4F0DZKSPHx+AJZRDjy
	GynVYXhPhnVHmMLO49dI9wzsZkIToIX9hcAOKCzxEe731VDpvA6SkkPb5ZdxA5QiDLf
	zZO2J1oT3YZSdFI8jyktfXA3f3Vk/TXKzJpXCpAw=
Received: by smtp.zohomail.com with SMTPS id 179253054089779.02106118084941;
	Tue, 20 Oct 2026 14:09:00 -0700 (PDT)
From: vince@palmit.com.au
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Register devices during SANITIZE
Date: Wed, 21 Oct 2026 07:08:56 +1000
Message-ID: <20261020210856.42835-1-vince@palmit.com.au>
X-Mailer: git-send-email 2.56.0
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

A SAS disk being sanitized responds to TEST UNIT READY with NOT
READY, ASC 0x04, ASCQ 0x1b. mpt3sas discovery maps this sense to
DEVICE_START_UNIT and issues START UNIT repeatedly. The drive stays
NOT READY until the sanitize operation completes, causing discovery
to exhaust its retry budget and decline SCSI device registration.

Allow registration only for the SANITIZE IN PROGRESS sense, so sd/sg
can expose the target while retaining its actual NOT READY state.
All other sense dispositions are unchanged.

On an LSI SAS3008 with an HGST HUH728080AL4200, unpatched Linux
7.2.11 retried discovery 145 times without registering the device.
Linux 6.18.55 registered the same sanitizing drive. With the
equivalent 7.2.11 fix the disk registered as /dev/sda (0 B) and
/dev/sg0 while TEST UNIT READY still reported 02/04/1b and 47.32%
SANITIZE progress. Another SAS drive continued to enumerate.

This updated variant uses the named 0x041b sense constant introduced
in newer kernels. It passed static review on the current SCSI
for-next branch but has not been independently boot-tested there.

Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readiness handling for slow devices")
Assisted-by: LLM
Signed-off-by: Vincent YUE <vince@palmit.com.au>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672d..a77bbc3d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7700,7 +7700,9 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPTER *ioc,
 				u16 scode = scsi_sense_code(sense_info.asc,
 							    sense_info.ascq);
 
-				if (scode ==
+				if (scode == LU_NOT_READY_SANITIZE_IN_PROGRESS)
+					rc = DEVICE_READY;
+				else if (scode ==
 				    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
 				    scode ==
 				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
-- 
2.56.0


This email and any attachments may contain privileged and confidential information and are intended for the named addressee only. If you have received this e-mail in error, please notify the sender and delete this e-mail immediately. Any confidentiality, privilege or copyright is not waived or lost because this e-mail has been sent to you in error. It is your responsibility to check this e-mail and any attachments for viruses. No warranty is made that this material is free from computer virus or any other defect or error. Any loss/damage incurred by using this material is not the sender's responsibility. The sender's entire liability will be limited to resupplying the material.

