Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794214;
	b=jybY6ZkDEtDnVrMq4IGteySuZK0V8rEGd5t/ETNDDieSHyALFVxbsSvdNPYrlySi47XC
	 8QSWRYpoh97zlTka6TO9bdNNMqRAmKR2HWyERELVafIvTbZj9CV+LN4G5u0/GvliHVY54
	 rgx85GBwjO297XLGpf8tk88WvquwcNkRxriEmM6sSuDv9XBLAsO/TobZYk/N5FgKuCqLo
	 m9WvtJjqWmNguZUft5rdmAYsu/qU3nUjaw+FrVVFBRiK5BxkUcX0WKDBbe6WWfCW3Gsuw
	 MoXp6N0EXmD5P1bQD9rTjs7OSinQu6gDgKunPOMKuymg+laZ0gbmiKHxuI2+qVySEGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794214;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
	b=BV7CcRN1+pQ/lnA4rSfExIdYpWUeNu1xAKI5scUVXvGa1TbjLa1907pGWhXMtrkc6bcC
	 np92UBC7t4bwYyh2IAr4rJrGtmlUDfILpijDMXYamBbjQMwDuS3p4673lxwxJgMELmopl
	 suHqrgjU6y2V1SwbHYYD5s05Tp266fyCSmqGs5bZG2DaGgGZgfYFA1mdbbcJr5H8WJgkM
	 wgRBrcESJcYIlYFDSgJMk+pUhD5fhxYzXYDtf2/6890y7gweTfdDau9i5lmVHPH5p7mQt
	 qnbZz9UhDOGz0QO0prOAanb04y9HeGv7IKSLbz8J5E0NtVE7m4DCfMTuVUfBJazw7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UdalBOcP;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD43606A32E
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBD43606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UdalBOcP
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso228898a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794213; x=1794399013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
        b=xWtZsOb5Gjh+YW2BHszN1cZwtOcL1QFDdZmRLCvN54i24iC6icy2w4Vo0sB37B37c2
         J0C8gVxVTzKDVQej+3tUMGEN9YeuAVg5CSwFe+ZzQZa/O8mJHAmpOaoviRjeJ0A8BwH3
         VUjbMjyIgaIZJsCcaaMDRH27UbrbcnzY0pDEjYEPMeYv7jCuiwoZPeMaGJFHbP1NmNJB
         2pUTTDLgBGTdEdF5Ff8TSdD5LnsfAdQ0Oqe4dio18VD3XxO/QyWdGPijCiPSj+Nos4Jz
         UgQSaiCxLDYa87YIvEtLCJTiYiv//DJpiYFP+ksVmkeR+4klZXaEvQ+jSa7CtgVd75Mu
         fBHg==
X-Gm-Message-State: APuU4Z83WxqLaHcFydNFLbYnrOJy8eDbOehag041fV9s1Hmwv2ZKA5vA
	MrnhcXomvHvqqMJ9El6qgxxbyxLWj3ZXuQ0pHiFKtkSZg5EYOvMFVypCwfD1RGwn7yKnwspSVwm
	aCvFY0l7hkOYMo7M6SUraIkzJjmUNo1lyv8qpJULFNiTH27ol+uaVeD9zhZLXboXAe241JWaYI2
	nZLVDwCz3tBlYmKzmxP4gMlErbFgc0SPp53ACwqovmRdY7rfwCp+vfNpki7uQSZfhkCHS99/1pG
	6vNLJPROEce1Kog
X-Gm-Gg: AYBFou3MPf7uAYKTyKCZ9A1pnLQYl7qtB9arKuS5bbZFwjgsBMyQsku2hgMfx8udq5Q
	YXCpuu+z6925qMgMXVzD5K/jzJLTiVhZiF4AYODqmHJtjXmT/QyfOEa/5UE1QjS93A0ejyfbxA5
	QtD8S1OcEiplQBHkQ+PXLa/zY/J/NqFZG+I6UoN95LViayiBGVw5dGr0u2TW8IavT0fPYNQ4rXZ
	rRTgVveHi1fD6ncOY2CjvMQ1ZdIBRQeUNvn7dJyk+NLrKDzulCQeGX3y/fbSpYWr+VC9uBQkivD
	IkYzFe69FbsWQ/3F3TJHZ/E7Lj20CDdQJ8l54BhixKSF11BwVvdMyrPc0VQutrNVFd8p4Mp373O
	LtT+YNAeYxQJDiBHQ3rqYYuYTqERZV8aDNU3Gm4UT1Lkk9uC33Mm7mJ9cgWPaKTvqdQ3DLmpJat
	CbBhQbN6nAC8tSwfpRprsFuEhNivK1Akua95Q=
X-Received: by 2002:a17:90a:c886:b0:3ad:50ef:f5ff with SMTP id 98e67ed59e1d1-3ae89751590mr13266604a91.37.1793794213195;
        Wed, 04 Nov 2026 04:10:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09453df22sm1666676a91.3.2026.11.04.04.10.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a3451ea93so923231eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794211; x=1794399011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
        b=UdalBOcPeMJIcAo8oe1WdpW4Aawc/+MuvdtcbrbZP+CbgPb5ghigUGd9sshrEX1tdx
         BlLVYrtmdwJnoMluCsGDMPTQyChjVKMzsHDHhpotCZCgJukl0D8G3pjRNUojXKT9cBpQ
         YOms5D3jlsMAGQhbAFo/IgDJgqAHQsk3ko0hk=
X-Received: by 2002:a05:701a:c96d:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1ac56c9ffc8mr19877619c88.5.1793794211454;
        Wed, 04 Nov 2026 04:10:11 -0800 (PST)
X-Received: by 2002:a05:701a:c96d:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1ac56c9ffc8mr19877537c88.5.1793794210491;
        Wed, 04 Nov 2026 04:10:10 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:09 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 08/21] scsi: mpi3mr: Fix integer overflow in the log data size calculation
Date: Wed,  4 Nov 2026 17:30:49 +0530
Message-ID: <20261104120103.503871-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The number of log entries and their total size are held in 16 bits. With a
large entry size the product wraps around, so the driver copies only part
of the log data and still reports success.

Use 32 bit variables for both values.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=13
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a68552c9dafa..bd105efdd9cb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1346,7 +1346,8 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_entries, sz, entry_sz = mrioc->logdata_entry_sz;
+	u16 entry_sz = mrioc->logdata_entry_sz;
+	u32 num_entries, sz;
 
 	if ((!mrioc->logdata_buf) || (job->request_payload.payload_len < entry_sz))
 		return -EINVAL;
-- 
2.47.3

