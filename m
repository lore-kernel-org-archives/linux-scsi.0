Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072772;
	b=pqn5/mXp5YSRBl3IBnf7kBnAWHrUUhUEjM/+JID6xSquNfpABadGkCnA0uTgtjxnxjLz
	 YP1xN+oidhKNyf8saoaTNnOEintF9ulSrvCR9/q3/gTxjxOJbPjR5tyuYgf1C3M8qSTpy
	 5ImNj/BMN2mb//ssIUgMjV9cEPz/exSKwQ2UKu0RSf6ctReIKjEkRnHhI5BfLJB4H5wub
	 Rlu9U2ffJleCrpqSc/h8SQsy/5EAzSw/EG5Bqf3sxcyO37Hkbmnvl0ndA5XoHiLMxhafX
	 jDD9tekTxhLNFYu4jiAF4y/EFTb4QVI3eFBuECFODpGJxtnUTgD1xXTdLGGcv4Kb2yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072772;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
	b=CO/Awdi9ucaernVguiRmEkgMPK7R1/KvVTooz1QfTZ++Gjf7gSuOQUGSB87EGtCzUmSi
	 spIAuTPPdh6+B2eEMM+Ja07+r3zPArc3Pq2kMO6cEozVDmHfwUkgsdIc+UkaSGgVGUIOM
	 T7AX+0kKIttPURBrsRl8clbGuIqz5ufnN1o1WfbEUpkqgR97hlWSPp/vSgjc/VU+7Qg04
	 t3uzEXjM+LLo1KeQnUnEImsift+JDg9XvQMOWBYo4y/lGaRouEdns4nZTtwabIHU+O0U8
	 6JgA4zMzLALv1re9wa0UH/A+Ve3G0B/eISupE3Qw3Q3JaHvfIQF8NpftM6v6OcIk4gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="G0/sNtnR";
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A78606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74A78606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=G0/sNtnR
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b094e649d3so1290940a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072772; x=1795677572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
        b=xHNiOTHz/01+nqBHQFH3cxE7rGbBDl9PQdauMQ2UIeBZwWZpNUKwqELFzaxXyKwDvP
         4UeYF2GxuEF+CNOa3R+m768+XDN6/FaFS6Kzwzb4VhNuXPcpqemXuoRuNKG+X8NKdyNw
         qj5Cjs+BBi8l1r5MC70d8Bl5TK5NAtxdKerAynX2PGzERcwIK8l2Y5+9CLRFM6SDHNQq
         CEPiWWCN4rRfjwnI3smX9YN8NFcsM8m6IWiVtjjuvZ/CH6E/EW7z4ZNFAxfqZP+Ui4hK
         PRTgDO3aUTzQjP8bnBObwdln94q4qVQjg2qRKksNPbkvb/483YC6BtOjCJZCKmxgSeDN
         vaeg==
X-Gm-Message-State: APuU4Z+w/flLU4uJnPBKxjfocZgvPjnC5/Il9FfKmrFm+6sJm4IxkPMa
	gK90OPB6VzJgtoH2tf5k2oQvw3B7nTc6Ch1Vgm8DK6STrrCeHQdCSCKqRxIn9cUtURyrN/F+UeS
	diNJ0XiXPD45hpzUXLJcwqv4U9iOwR50ftt/tTZjB2vs5OunuLctMayvPXMr9hAZB/Xr0HftEHx
	/vQwHGiQFdTDvZsETBxGgp//un9v42LFis9QGwXKPjTMPxjXBTtGjQfw5St/7VbUEp/duNT8C59
	7PmnfMcdmR0u6uO
X-Gm-Gg: AZFdTZcBOb4VPUt1u7IEMPk0xs7AncKbza5PxozQISAzOWyHez2JRy1BaD2YvrDwKdH
	cx1vfm9Jp80TT/G6oBL9tiT1YW+zJzj1hEqBASjtNYMk4gtYlKuszb27m8UIt60bDyBsVsscJFr
	6R/mvUccAfImh3Ks/Bnw8et2og0ZLhyd/+XNHhJ2h1bxvbB9bM98nHC/1dMYzzsn7ATs7RLojuL
	Ytr3U6/hm/iU0KYHOv0uhn9s/wFH7FmqnnDY/86HTjcEisQbu7077Hx+4VP+ut/JJ5XkdTjztqd
	tS7DHrnqizTXVe0fb2VJ8AjrMTapNf/8tBTQYCcPC81iRM2vR4pmoeu9UmCmcJ3ULlMP8UUIVG5
	5T4UmLqe4J0845KkKXhApBsrnOqVra44kExCYJUydxLeBrYzx2PIMHk+24+ZvQmBoqky0ja5nPh
	wloCi0u7N2vis+DBIe+04yulP76kncuC0ZwXKXJw==
X-Received: by 2002:a17:90b:56d0:b0:3b0:9a2e:b491 with SMTP id 98e67ed59e1d1-3b3d07d4e32mr4861278a91.66.1795072771725;
        Wed, 18 Nov 2026 23:19:31 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405960b36sm532610a91.1.2026.11.18.23.19.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:31 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae7faf4ff7so2382411a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072770; x=1795677570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1vVVoFvn/CK478zZ5PJ8qe1CElHhNsCsBEbVLhWUK4=;
        b=G0/sNtnRu0tCkCLyjz7bw28XVdZ8VND70bRlexBOxKxtbTvB4OPHnR+HUmGdeX9/JW
         +86fyN7HS8el5KKJb0fkOnVMz8Tqwb/KZS27ijMxIVKSXaOuTngdVyV+XqBI9SyhvIqg
         IpgegZ+qlI3LYHj4bTXp9Yn/nQ/sUUVtkIJ0I=
X-Received: by 2002:a17:90b:39ad:b0:3ab:be66:ddbe with SMTP id 98e67ed59e1d1-3b3d0762ff8mr5253396a91.28.1795072769997;
        Wed, 18 Nov 2026 23:19:29 -0800 (PST)
X-Received: by 2002:a17:90b:39ad:b0:3ab:be66:ddbe with SMTP id 98e67ed59e1d1-3b3d0762ff8mr5253372a91.28.1795072769296;
        Wed, 18 Nov 2026 23:19:29 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:28 -0800 (PST)
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
Subject: [PATCH v2 07/20] scsi: mpi3mr: Fix integer overflow in the HDB upload bounds check
Date: Thu, 19 Nov 2026 12:41:19 +0530
Message-ID: <20261119071133.127282-8-ranjan.kumar@broadcom.com>
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

