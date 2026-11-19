Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072758;
	b=c6A2Fe7btohm2aThhsLRenSbKkgR7PONubATRgP8YH5PfMDY3chsDraoRgpBkqZ3crgj
	 SAKV3a9rCGf3vgufdSk3E+7DIMKf8pPbG4lp/a8bp80oeJD0+NTMEC8d4yctSbrRR+QGF
	 N6vPVH4EiqFCbigpQU9/UKeKqaFSst8pC4rS85ZZhMaPm2yvQWD55rVhk/cPx752hn1qS
	 5mzBa7rrZC8FoKBu773jL5cm70/acvSse4C4DICccYBXavdQY+9JQk4BiUM167JUF0Kko
	 s0/u0HvTn35VdBFj0rKtaDlBZyDu4NkMsrLO0n3W8HToUiKKI/D1bKoNzA7Y8Yu8qxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072758;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
	b=BtA2t+jURDcWnimNifWjWW8JN8qiAsw4nM5TChbchAkaVaFgTGoeki0Z0ygl3TQj6yPY
	 x0FT0TGoJSPdIkLoSmvTERhgpK04BEvoIKYRYUK7N85Ru60X8SG8Yxgz8Aalf+qmKfuB3
	 yCCR/jxq11ViyQJ9h8F0xvsjflvOW963cYwtX5CO045eLUrq1B6f3FTfiS9EjUfg5iQvK
	 UaQkCLcsvNu5xkW9OtdaApCeJpEXECN+/V38LEdcvN8N0/nplqlE4x7dNVTh3aL0wNyor
	 S87+MmkYeuqshjK+ZeTgoIR35vjI0hhwBIWfazZsVkZQNvDnX6p/cud0uf0+w79yHUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=P2HrzHuY;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE0B606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBE0B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=P2HrzHuY
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cddc250d815so1004574a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072757; x=1795677557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
        b=q3+56f+ATh4cK73jlipP4ckZ7KgLNHGEB2y2cf4c1EmExjYtVrxWqWwt/cAp0UaKTx
         Z/YEZ/XpnSHPOG5ojecoLvTVJ0KVkv37oay+QaNZGPJSWq15bXc5ARBx3z2w0kjpCVHD
         daSNlBmcCIBIax8aEaWzXVri0np98J68sNQQXQiv88FA6n30GerKkALs/vWUn5BcIafp
         z3//equ+/P7hFs9fFeneC7yxgGuLWNmXfd1TfvKT9fgOdwlLViJqiR47B56XF/CShyIG
         7Aq7Nso7ZqSK0ru8IaPwKSWkdUwFv+nE6a6U59XiMEPs1sPm2oJsEFzCm76Yb8hRMc0g
         MpvA==
X-Gm-Message-State: APuU4Z+WiSapFMT53CoRVIg5rjpDvj3a5K5Jr3FBD4tpSKpK9P9cPF3O
	sUK6ZW0X9FZQE2iOiMj18DsDY21bi8SRZqQbPlX33E9UmtLbMEDNBkCMB+fIkMZiijqNt7vPJYH
	1Jbq3W/QWE5cfvDwKbecOooZXTbMowNzLwzjQUYRfKiR6ciefrBJmPrKIA8uzNbxHU9uvt1D5iO
	lwJ2NQND8HIk4j5ohZuKjHqGkZvJJPI/euhyJgryyhcVPIBCLMvynOviaRMSknZNzKkwdHF2OBo
	kUxziJsPTRon+kF
X-Gm-Gg: AZFdTZecz03bUQ5cMLHRqY0tqTLu4CJPRrg2OyJCPBDMA652YB51qI33qYaajP4imFM
	vuZr7iBEB/5QKWr/k6+/KpeOxCy59Klr39a4oIpwzpiB4Q9EQ9Gw8oKsnH38KXqtarJe4FW+gfg
	u7bisXA92rFZ4K6kAHVrQy53wXVVgCt/MTtVFWaKHLZj9rjmbKt5SNeCAykcZDyeohq1BUnfPdQ
	tfVBaacjFgo9ClBXxbcVVnTrI9phjKF8GmIoJg3URnJLKC+pnzOt0dERD3o1ZO5vuAO3oblISP4
	2JWZiWhrC3yCiQjDppSA/qetA4dKCBcYgkKa3d/U3P93Yc4minOEZ7GEPTh1KOhWiJlFUqNSr1j
	eoN0BxitK1kLS5brcxz06wMA3hHr4wouosSWoMQvn1C2wzyzpHXIMXd9QnhpeRD6yKRjqSIWkxP
	iTmC6tGvSjCQeWUb8+etNlAOGSXZgEVaVdeCo=
X-Received: by 2002:a17:90b:3c8a:b0:3ad:43c1:7d41 with SMTP id 98e67ed59e1d1-3b3d07aa6c7mr4458819a91.33.1795072756961;
        Wed, 18 Nov 2026 23:19:16 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4062eb7cdsm471454a91.8.2026.11.18.23.19.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:16 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3adeba76cadso1420493a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072755; x=1795677555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
        b=P2HrzHuYPWYAj3Mxtk1U+wdKu8zvM0NOkgKXsfqjUi5Z6oYJLGP3hg1ij1hPJF4P2V
         ExA2uxmueiEVgv6wnzGL7T2Xg/jedQ1aNXmY0lwOJiRzPecIfKz95cqE1h3GEVcDhStu
         97eYfrd1pXje0kwIHintSUGBFCtYMW3FPO30U=
X-Received: by 2002:a17:90b:4b:b0:3ad:4a8b:c703 with SMTP id 98e67ed59e1d1-3b3d0764a41mr5061909a91.19.1795072755302;
        Wed, 18 Nov 2026 23:19:15 -0800 (PST)
X-Received: by 2002:a17:90b:4b:b0:3ad:4a8b:c703 with SMTP id 98e67ed59e1d1-3b3d0764a41mr5061889a91.19.1795072754725;
        Wed, 18 Nov 2026 23:19:14 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:14 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 03/20] scsi: mpi3mr: Remove redundant BSG buffer length checks
Date: Thu, 19 Nov 2026 12:41:15 +0530
Message-ID: <20261119071133.127282-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
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

Buffer entry lengths are now checked before the pointer moves, which makes
the later pointer comparisons dead code.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 6bdd43b05e20..9ab17eab191d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2601,14 +2601,6 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
-			if (sgl_iter + mpi_msg_size >
-			    dout_buf + job->request_payload.payload_len) {
-				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
-					       __func__);
-				mutex_unlock(&mrioc->bsg_cmds.mutex);
-				rval = -EINVAL;
-				goto out;
-			}
 			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
@@ -2623,21 +2615,6 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			goto out;
 		}
 
-		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
-			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
-				       __func__);
-			mutex_unlock(&mrioc->bsg_cmds.mutex);
-			rval = -EINVAL;
-			goto out;
-		}
-		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
-			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
-				       __func__);
-			mutex_unlock(&mrioc->bsg_cmds.mutex);
-			rval = -EINVAL;
-			goto out;
-		}
-
 		drv_buf_iter->bsg_buf = sgl_iter;
 		drv_buf_iter->bsg_buf_len = buf_entries->buf_len;
 	}
-- 
2.47.3

