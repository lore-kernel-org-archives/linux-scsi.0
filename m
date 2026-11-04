Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794211;
	b=SxoSoCAuD6SSp/zA05t4wNfPugWsEfNXKtymNrNMe+0WH5/ImCfKuqkJGdKuBWHk2+Qh
	 zHYjy30GMctB8WmC63Z+ke9giX5+2GcZST1r1/6m3qRr5ydBH1Tywk8rmldlayNdwqBTI
	 GmNauWaGxe6DBX0Z3GelyGYzWXZNKJeeIYWcDkMVXjG9r0xiqoMNTrtVwqHTZ1U1O8wNF
	 UygdC1iar/WBg5a6wotH56u7WPSODrZbtlTXJpdWFduHk9idHTtbYNmpF0aoKwmvUL59N
	 I49cuPF87X6zfXaB5QGxbvpe1Di4HCBZF1J/gPbekCr/K7t2GuWnGKqZmLS5F0YsKkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794211;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
	b=aYTJpwifwIz+sXq3Q8xWqfMsJeOaZDYTTp5k+B1dbVF4bISfRUuDDs2/4tXpkCOZy2og
	 Yu2T3gIp7Sn12TkrinSiY9oomVRzPBU4dgz/CuYDC9CdRYwoAtmJGVIKsDMkjovXVt6aS
	 KQxIO9rDHdE58fnspFlpqqGyMfgKo/qRI7C/XnraYANCeVMsP+UMHHdDhTsWyHtpgNVgK
	 7JjIssxP/fNusddb1ZNnHSy7WhuzlkQ3C7j0Nj20HeNYsoowAm/0R5+RdRH09+fYMFN4J
	 A8tAkeL7lcg0W18ssdfiDB7jonOkoxDszF8aA6Dyx79DmzFQJBKdb/1VvElT/NeOV3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FvWM1XiD;
	arc=none smtp.remote-ip=209.85.222.228
Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27452606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27452606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FvWM1XiD
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-93f22a8515eso62240185a.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794210; x=1794399010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
        b=0OgqAar4R8KIDMnccAXHRLazCiecWojVpW2Q0moJVu2SCci6HgaJtNPBw01ASGLNME
         PpkNY1rXpIsKUxeC22lLxTwXvptn7V8u5wtKeW33JivNOjHqSNycTmugKN99SH5NiKeA
         4FicSCfI59OH7ANuje6J9XOey7MIQ0n7YHhbMP/51PtbrTGUcF+K4r7WGnz53q2N0GSs
         c8t+On8BtXBEF+z80PfXLkzJwemlzZSlcivLT3OKoGtCWcVCzgpzDxbVzC3m1luWI6MS
         of0jxZiTRE/9S2MRFJzE+arDeDThhS/ZnJKUptGn1fMFrVkHDDOSzwMtso2NPad9J2qY
         A+IQ==
X-Gm-Message-State: APuU4Z+jAOinQDnhBYBlOLqwugt4rbaAV2seiZhkmMEHIJG3zO/YZg6k
	wU91OfY7Un+EUUgqL8huAz2Os+XSFjRllHF/6lTpEtJvSAPF+CSZ7bYYloOniDqdCz3qTqkjwwg
	iAbJFiyt8xb+eknac83YnWa0bqEBtRqygc+LGrQbgE+sjuqAIbYqe4fs5hnEdorTwxVtHYLheJR
	QtyACIrKuRdFXvavuXxFqQALO6tye4dUmIydEMiZQAMTJ3jqu7Y/mzUpzIAV0llnoN4pBEh4L7r
	jjanmRN/IQ3nzkE
X-Gm-Gg: AYBFou3tjv9g5N02EZqaImDOkAEZ7plzEiH4LznmuCU3YEhdUpPeGO1eNmfkCzIVkFZ
	8o9fexuL5rYx3m/obnPub75cshHjMIPeSwZc8YP3YL5KDfJ8d1m7HuIVWvvEzjbnITYlinDlETE
	2h2ALphP5m3CnFYsCazFeaiBPyU7DbRDB/ontYE6hGeKF/BA9hpxapgUHXkbwe2DP1xn9yCaBQ8
	ts4Z3mhkJTVwxlpgHwF/2fg5gcrBvrQ07t2Dw2rFnj2foTPZ59vmTKvD7mV6JhXipzyJZixp9MP
	56ZqZwEzMUqnTgjUxDYfQtq9wKVgFsPAF5E/PTOXfEhOJ3omLRzR5DrLqQsl9gmsTV8qMzFVF3t
	BkU9C55GLNGs39DM5LOSZNIGF39LvTc6nSuxttAcZVPZA6yQjq3XmcSXntyoQe1tUE+/2NES/Sy
	2kawyUDXOx2/h4voeYaxzMym8mNTg2p9ozL/I=
X-Received: by 2002:a05:620a:bd3:b0:93e:f9ba:690e with SMTP id af79cd13be357-944215817e4mr2503794985a.3.1793794209877;
        Wed, 04 Nov 2026 04:10:09 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-945d45598b5sm29575185a.0.2026.11.04.04.10.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:09 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso1252907eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794207; x=1794399007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
        b=FvWM1XiDhi+euJIdnAg6e/wZKaZ2qtDqQq/hRlWTt9E0+9NI03uzhj62eqjszyOtKZ
         iyphYPFhzFNjZTbYfvWRsiK0u6J7W+NY1ZbYBR0B7gs/AsGBdWGopUvOhX8fTv0VWIea
         WldIr8WDUCYLXfAEmsGZYiB4Df6tNychiiyqM=
X-Received: by 2002:a05:701b:240f:b0:181:5cac:8f27 with SMTP id a92af1059eb24-1ac5fc0ff9fmr23612876c88.35.1793794207332;
        Wed, 04 Nov 2026 04:10:07 -0800 (PST)
X-Received: by 2002:a05:701b:240f:b0:181:5cac:8f27 with SMTP id a92af1059eb24-1ac5fc0ff9fmr23612804c88.35.1793794206422;
        Wed, 04 Nov 2026 04:10:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:06 -0800 (PST)
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
Subject: [PATCH 07/21] scsi: mpi3mr: Fix integer overflow in the HDB upload bounds check
Date: Wed,  4 Nov 2026 17:30:48 +0530
Message-ID: <20261104120103.503871-8-ranjan.kumar@broadcom.com>
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

The start offset and the length of an HDB upload request are added in 32
bits and compared with the buffer size. A large offset makes the sum wrap
around and pass the check, so the copy reads far outside the buffer.

Reject the request if the sum overflows.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=15
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 83f798c4e9af..a68552c9dafa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1117,6 +1117,7 @@ static long mpi3mr_bsg_upload_hdb(struct mpi3mr_ioc *mrioc,
 	struct diag_buffer_desc *diag_buffer;
 	uint32_t data_out_size;
 	uint32_t data_in_size;
+	u32 end;
 
 	data_out_size = job->request_payload.payload_len;
 	data_in_size = job->reply_payload.payload_len;
@@ -1151,7 +1152,8 @@ static long mpi3mr_bsg_upload_hdb(struct mpi3mr_ioc *mrioc,
 		return -EINVAL;
 	}
 
-	if ((upload_hdb.start_offset + upload_hdb.length) > diag_buffer->size) {
+	if (check_add_overflow(upload_hdb.start_offset, upload_hdb.length, &end) ||
+	    end > diag_buffer->size) {
 		dprint_bsg_err(mrioc,
 		    "%s: invalid start offset %d, length %d for type %d\n",
 		    __func__, upload_hdb.start_offset, upload_hdb.length,
-- 
2.47.3

