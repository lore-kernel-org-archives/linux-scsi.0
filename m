Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794264;
	b=lhv+CYqj1bPQ0P5BUE0V1X9M5eDOJF85QlhXKoZmDibU+2uopZfbufNccJoH5EJ6Cm2J
	 rXJRDXbJEiEPA/Oun4iCx7xA+Ih2v+5uOOZbOtHR8q2rpfczWv223WPMGO8gf3J3Q39Oh
	 b7xjdpJoBNzD2nfJ92U8ldQl5UlX0VyWtmyvNC+C1Qhx6xP3vCPCzkmyECjZ5O7q1Wpox
	 B1gEffe4QVCFWGrNvXkH9mm3z5P5Fk8UtML/+B8rKQr1nWD6RR6y5EBnhBDSWZuiztC6f
	 AhxcP9ZdFxxZceEUbikdgzBjQZt+c1nO0jMgOuJ1dwKfT473hjvo8cG+BZmdvQdJ9Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794264;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=w75GAwmmcBJZkL+Y3QiXlPAr1f2IZbUzKoF9FLKRNSw=;
	b=YVtM2gjixqQO3pwRe2dCuHApbe5cdCAaioaG5EgkOZaKSBCJJd0horf7nydolLu5Um0w
	 PVBD3h701WUWPyhm7av9nBd0p9Imj8NZQjPIMTl04kOfb2msSFTIo6jAy69UQHW5nONcd
	 +0Ew66wE1egvRMan5/OuzTIW0frJjXGvcoSqR1Xma7UNVlkT4uwKVKfxqGL7Eho8w0DmN
	 RbyV50c+JoHlUv24+4zFssXUvtUkcsnNY3EiqQ5NOVeqxOcwZ9mcB2Mft4XUyc64OfbUg
	 HDk6WziUrAS0p+OUlRPLjHyP7nUsZr5xm+fQuKkA4FVhgxDOOWF24qJDhBOpl7kW7Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OR4l45Xa;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214F606A337
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4214F606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OR4l45Xa
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso317726a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794263; x=1794399063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w75GAwmmcBJZkL+Y3QiXlPAr1f2IZbUzKoF9FLKRNSw=;
        b=D1UM1KVR45k7V6G4BSdD/XAOcRXne3mWDwOBPgwg/R0lGkFIGCA5anc5fsQhlmXFqZ
         6NoftoDeMV4ZEFfSi9zlr2bN1k7wO+Lpvz4ZfFullvpdSowsJ/CZ2JXCSZPi5znoV3k+
         qJUp6LX906N6yiQLubCdJGaabcDg4JlVZ6onOQ2Hl7pPGRuPh8RFZ/oXydy3QpRL71be
         R9+O9SDUaJi6NThtA0OCn+d0rjSg1JLyl85qqpHWuks4OKRS1NOgju/QpptPoeNN2Vho
         zpAAkdmJ3sw4/C4C5eGrdwBxNRp/xX5AGWnfxMPzN6csR3IR8S+AGM9bPStqRPtHsPif
         WoXw==
X-Gm-Message-State: APuU4Z/BuD/6sZkjFrOMiBVsNCJVufjGhgevrF7qfZ8otMFXhGFqBVRi
	hosuz2Tl46T7vOUEmWRaD3sErej3N3vQkKNb1BxhZpPLJBEA0yqULT7h+d3FH5fF2wkKCcGFqmO
	75PEHxWvzzntjXYCFShnh2Youb+fcXKeyfO2Q1Wxd/JkRaW0G+sQEX5kidBZbmdXsKG1VI3u99Z
	1nuN3z3PklFbXKjdzBt7LyYNJWzbttbX9pBn5HhxwC4HNQ2moGUWjTbtRagSwGmFSWKIhvE3vTq
	LN0wb95XG4Ngr4y
X-Gm-Gg: AYBFou1Y823HUlz0hBxoRBuYEPlQSmXjiRZuSnmAAgelhWqURyjbJx7YqhR5ErH/2CG
	Lyo0izeQ8ghb+/7En9ruK2z9jRcdfL5IpVomFK27ScVyzWLOrQt8Pzytnit9PL4aUdyC8IFuHtN
	er056k8Mt0tK0YeJamptTf3d9RVtQos/fdbHSxj6PfiwO1qNbQ7EKrZYJ53ON4KClYxvC0yX6tf
	bAotltwgdjH+FIxWJHiseh4FILV7fMtUZQuINV4fANpqeKZ22qFQs/drZCSjf8ELEwf11nHFb80
	w/Gy1XA/L3y+y3oVk+W+ZYolL0WGltTetxKz+8fffNCjdNcyALyB0YZkdUvAzbf0tDkiRlAZdUk
	raHMu4GVm7dwmU2aCR00dpbpIfWBnDzeHzEqa4ctpCKwFZ9htl+nYDE5NThS7RaRSgaJU8ibP3A
	cVHWC+nsQvaWir3g3iDiGJukf6iStw0k3o0LU=
X-Received: by 2002:a17:90b:4b8a:b0:3a7:8350:3f7e with SMTP id 98e67ed59e1d1-3ae89771679mr12693229a91.44.1793794263455;
        Wed, 04 Nov 2026 04:11:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0946671b4sm1645409a91.5.2026.11.04.04.11.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:11:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36c9e87d262so974234eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794260; x=1794399060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w75GAwmmcBJZkL+Y3QiXlPAr1f2IZbUzKoF9FLKRNSw=;
        b=OR4l45XaO8ZdSdStlZ4T0VQtWVjPmw+ZYyzdSYi5NVkv3vdFLawg9pFkrul2UjX8S/
         J7EEjMXsxvqb89aAWM91YAoft3u1RvpTV4QFnHRl7Wq8Eco8D4OWghr4NPejiVeLAfA5
         bNcyix76u8oukazuc+3/cX5Xw960lvY7Zh1SA=
X-Received: by 2002:a05:701a:c96d:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1ac56c9ffc8mr19880098c88.5.1793794260337;
        Wed, 04 Nov 2026 04:11:00 -0800 (PST)
X-Received: by 2002:a05:701a:c96d:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1ac56c9ffc8mr19880056c88.5.1793794259487;
        Wed, 04 Nov 2026 04:10:59 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:59 -0800 (PST)
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
Subject: [PATCH 20/21] scsi: mpi3mr: Fix byte order of the BSG status reply
Date: Wed,  4 Nov 2026 17:31:01 +0530
Message-ID: <20261104120103.503871-21-ranjan.kumar@broadcom.com>
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

The status reply returned for a BSG MPT command stores the IOC status and
log info in little endian fields without converting them from CPU byte
order, so a big endian host returns swapped values to the application.

Convert both values to little endian.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=2
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 2dc6fad7a37b..e38208241707 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2938,8 +2938,10 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
 			status_desc = (struct mpi3_status_reply_descriptor *)
 			    bsg_reply_buf->reply_buf;
-			status_desc->ioc_status = mrioc->bsg_cmds.ioc_status;
-			status_desc->ioc_log_info = mrioc->bsg_cmds.ioc_loginfo;
+			status_desc->ioc_status =
+			    cpu_to_le16(mrioc->bsg_cmds.ioc_status);
+			status_desc->ioc_log_info =
+			    cpu_to_le32(mrioc->bsg_cmds.ioc_loginfo);
 		}
 		tmplen = min(drv_buf_iter->kern_buf_len,
 			drv_buf_iter->bsg_buf_len);
-- 
2.47.3

