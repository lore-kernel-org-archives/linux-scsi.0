Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794194;
	b=GndX+wJuDA/em2n9g3m4FcFXHmyZsgKzxQcJ78fvccTGEppgUedoHMrO3iAttOHkaaPS
	 CMGrlV/sm1Wg3jS6pbid0YmV3Hquh75AesXOH126aT1tKSG708xjWpnH5wHKLF01xIJOA
	 xAStQYkyvkgVLOoPiLbu0m3h0wv/1tzkps5E3d0wrAH/xIwzoMgTeEioGHi4N1sZRn6OD
	 xNMOJqKAzRvNGkU84tj8rVD8OlY2trNl8QzLrfX7npHm4TvohQ24LxOvx4/MXL99a+0Pa
	 pF94gUUCBCmdYQ/EoyG4LhjhFcSYqwixsCOXTyVj3dgFSrmxgdth3tzu1SIxoj/ndjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794194;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
	b=ETKho3iIVTYKJDaeLaktafk3zKrKvIjJ2cfpO/DJQLFnIozDkvIER87nc1nH3IaNSMxW
	 S3WbNTlxlvBeZXhbdGK3Nk0yD5DW4BkviF/zHx12u/cPdBzvN6oX982WcLJ2Re+Aw+fCB
	 tXtJLLp/s8tORXS52Webq+7WPaIVB1E6IH8pd2bGCSMvpnPJ9oNWsR4UNTy44yh0tsEtS
	 OuznCMC3ZAkYsxDO8L/4jRf54uKi5iW5nfWtpmKxmhP1oEtytpRtFPXBntlFFk90V7Z8/
	 Md0rLk35LawoXKrLdZmzBx32eQLcCmhn2x4eikKrDKrNms94nwXJkdEtiezTdrkfbpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=d86R7Fwn;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7C0606A331
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:09:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A7C0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=d86R7Fwn
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso387456a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794193; x=1794398993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
        b=uf6cEZ+WdA+2qD0mkPI8vLrP3ZwuyEInKorXh6O+suXj/l/3TQrXXSiQt/uYghmj30
         0kYSehhcuwX7raFXiN+YS6ss4qX9Cm+aCgtB8AzAgF92Oqfthp65mHOlfwdwPVxWBR0y
         aN099N5ZFlR4Fj+DGBH3yR7M1smXWdWBrX8QHbXLMewRmBurqEbp8k/0lJXWPhA4oXzr
         Q+8a/pfsRgjIUIYBTMBCw5BHTaRPV0ktH5Sf09ZmVv8o0pglLAT1OAzIs1OVmImvUfrI
         p72GNQZeX+dzzVEyXgkCPPysmc46dxTVqkX3SRGuW7HnVUIbfNtA3QWZg/r62C+vsaxT
         ooLA==
X-Gm-Message-State: APuU4Z/b5+vAOC2fpSgD/LyJT1U2ZmznVXu+zSoh9EzyH4Xrb51VoCGR
	WbsY0/yWwLRnJulfTpsdvMvn4WrbI6xuZW7JA3HAYV61w1ASN+WZMZFc/khlZJtKCLUk10w/sVz
	tDowxXDF1H3lGG44l1mrqcYNTUBU8rK7D7of+dY7TWIHuBjRckUDYOl7+pq2EkGFkM3lks0bKOm
	BU9EDEyjXYv301hG4jvZNG4v90ThL0P0tb8AHbfhqRjoV8l/r25O0RouhgCnvvNCJwx16Df+4Nq
	dWvapxf8PVlb7gi
X-Gm-Gg: AYBFou20I0RTAA9YcWk6K84tXQrnistV6rq+gLRswi9m0cVsW8yw+oTUrrKHK6/4+W+
	+sGtx1AxqdY6CmBPHe2kkCKfQnusg8wdAA7SFL3bG7JdR7KB5vAHWOHkdDmSDNwd23Pcfoe9yrv
	78QCChNykVlAfycVG/AhY3FtBXscUIrdpqQJ+LLrHPWAxo1Kla2+gNix/ViY4E1fRsiSn9iA6ND
	zBVIqmTSVNchYxwgsfK985b8UKxYo0hN44F11ac5+muebNHqwNJpLh4ciyKfwhQcZWC3RaLyGTb
	iF4waNGsl2/x37lThSA6Yhzl6IW4OTsNiJkFVAzZj3GLO1nc8tFWQ2RXnfVWKbpRUnYxrXppZlK
	kq/oOJIsNRhgwiqFt+qXZhW4eSu1ANkaeS7+wSNzE8mjsPIA1vQmgJKJSWHsxLWlv10nHAfoJC6
	jhbUvMrgrolegbREmOEjwmTIbnURo1zEZYD5s=
X-Received: by 2002:a17:90b:3c0b:b0:3ab:9c73:130 with SMTP id 98e67ed59e1d1-3ae89764119mr13312624a91.33.1793794193278;
        Wed, 04 Nov 2026 04:09:53 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094427c4esm1702903a91.1.2026.11.04.04.09.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:09:53 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-16bc6f3fdb1so882610c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794191; x=1794398991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=smItLsiqQyNyfV5YMLyWwQKtc0tCMKnCLPkp9DBtrrQ=;
        b=d86R7Fwn5OskWRAj8hkxxUPEEsLkgUt8mAsXytwxD3kTDS8qnjxalBAKe1y6v2nlU5
         CBvsI3Gub5NK3Qa7jmwbkObVcVvS8cLwRgCtWSaBms+Tp1h7d5EjDaQ0CAEDnjnuS3NW
         5IChKML0PCFXE3Pl/tTPwqHdt7LhrtGQAmJ10=
X-Received: by 2002:a05:701b:4193:10b0:15a:4155:3d9d with SMTP id a92af1059eb24-1ac5da76f61mr24300469c88.31.1793794191346;
        Wed, 04 Nov 2026 04:09:51 -0800 (PST)
X-Received: by 2002:a05:701b:4193:10b0:15a:4155:3d9d with SMTP id a92af1059eb24-1ac5da76f61mr24300399c88.31.1793794190554;
        Wed, 04 Nov 2026 04:09:50 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:50 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 03/21] scsi: mpi3mr: Remove redundant BSG buffer length checks
Date: Wed,  4 Nov 2026 17:30:44 +0530
Message-ID: <20261104120103.503871-4-ranjan.kumar@broadcom.com>
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

