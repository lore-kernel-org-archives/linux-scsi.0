Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793515095;
	b=DmcFwfevgZtjcNnefAHkXE7j7SxWeiEY3nLS1m3bvbROlsaHPDQvf/Jj/BTyMtBLNLg3
	 EneKjVRIgZQQxiDllctwyrqX37/pN8ENEoJuvSnjFoz9b0G2r4Vaf99JI8byIwvrRo7US
	 RCEeH4zmtRM2OXzr2d29VV6tCKZN0SxycKcvChK3j88aXk9SJjHPcj/KXQHUVFjCKUVLw
	 02WYe9y2jCZRfw2ERp0iJp/b+v5SN1a94ge9HlBSd9TCuG/4kkcAYzXyQtldoeU4eAfET
	 nOsDpOpSAQ6y7Le6SBREyzLlgT2jdWhl+WGuu2rvSoSA9Gwp+3PmMOor+5l7WTUqmGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793515095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RWO+QUyZGGT9JFrisetKTbapr5TrQxiyv48XC9q2SJk=;
	b=IRvw+/FY1V8RvwcaLGLVi063DNp/2kkp5PEYh/kctpaA0pj2FkWLx1KPKtwTvTnLIwJ2
	 xjQmV2AVmhlTfwCkOdLro8QM/HLKS7WYwvQd1NU+NTeAv5VtiEjq2jvPr54HMiyRTXgmx
	 439DdowWti35yWpqY5gqNqw2vhUMKL7DrxcbTQnbPzsilsPPAWfi5KVFcrYg9BNsB9bsO
	 M8opOhu5+Odbh0TAndne80CUEKPPEtiYd/6x1i0si9r6pgmJWXJgXtlMdubELIbeZSbDJ
	 3b4SYuYvPm2bmR6dWXPgFyrc7ww/KIsBsKnyN3O5+0LJQhduH8L7xk3CoBzPFTnIp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NRNw301s;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EAE606A32C
	for <linux-scsi@vger.kernel.org>; Sun,  1 Nov 2026 06:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5EAE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NRNw301s
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1606526a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 23:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793515094; x=1794119894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RWO+QUyZGGT9JFrisetKTbapr5TrQxiyv48XC9q2SJk=;
        b=NRNw301s7/fyH0SOi6Xnd1gRIt61R/gpMLNfP/dtdxe7cN54Yt03X48wbjZh9GWkdb
         UGIXoTe1KlKn7LTMuo3zIhA5tMAzmFpiO3RdmD+JygbFJfOUNBIf0SK2pBTtXoZDjz+P
         LLA6XX1Y8+D0GMixI5NLTS6Qr+4r/ZOYC2wG/xqJOLzO10n7OYXDpGoBN/fq56flFDlD
         a+JrQB2b752icPtg6zmV63j3gy3DSni2aHGauyt7ZKdKraDsVcOx4UhQRc8pqr0OFIrw
         SlPdiqtZA/o/5Mvgl4MWqXhl5++nDh4AxTEmpAqRv/C9YVjh0CyOxmxT34l9aTnvIc0T
         2GEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793515094; x=1794119894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RWO+QUyZGGT9JFrisetKTbapr5TrQxiyv48XC9q2SJk=;
        b=Dx7DO7l91U1E4KGmPyd26yEHnhcsXoVDEAGCiTLipb0T9zl7W7gG+yMtV8SER7ekGr
         rmxjGCJ/ZcWPVyPOD1tXfo+2ybA1dzrdu2PwNP2vyWuoimtg2GbV1LBXDIUP/mPqVH7J
         ZF9S4fmgtePtKV/85XlYIYB9ngzXBdZi9Uq1TfAyUQCGs02ITpFabJQnSaNCeoWdGHWY
         IOwnE7usKTXqfC+ikokclzGcA47bErnC5zMKnxp4vo4ZKsYhnfLTBwk5ZVGzT2zL4Dy2
         4ldfDHuHSvKSEnt54U2RMSatrWlIgDUYHrcIovE5rJmVNhsEt8IyfgLMDQnqIMUXveDz
         s+Uw==
X-Gm-Message-State: APuU4Z8yMJaqxuAMRlSUTH5kSTwD8EY5NTXDgdH9PA6Pa4GnX+gEBZMl
	wv3q23Fw4HdiVUn5LUHF7xwbfDYALpO5/EgN2X5mmlXb5PgSZJapTZrZ
X-Gm-Gg: AYBFou375Pq6vedzXrr5cycAPl/2IzqVxoZZPJzLH+Eh2fhzNRD57WGCuXHRKs467v2
	nXFbsYswck4/aKIMc83SeMUWNu5ncWFY8TnhRfvO+tgUWyI7z5yTCjaGnO8WyDvyQSBLLAtnRab
	MIaGWVQW7dRinAw9Ltnf8SwTKRlmGYk9CbtJwdbnbMyWzdU29W9TP+gdXskMzxeoWLv0XL8uoQ5
	JUjnKugk8mNIdbL4mibvEhB3Wpjy39M/6fp1nVp1zOaQ0JKFy1R3RHT+zpVV/JI87HSuzPSn9D7
	h/AQ3YtDuL7imWFwMcoJ/KLQWK+Ko9s81ZoiDC1Mp/Z0uj/wNuFY9RWL5AgS4Bd/K6YI68hKQI9
	a6YCXtFaC4/ZUsD7i/4estjy4mQU7hJZ+0orekkBfhgt4cHBsr1jxiP0tj8O18PKDKZLtoMdeAW
	YnVcQGCKNO43KeMMbN0ZT9Iwo+ff4o1C8oCG0hspSzBy8cpno6YMyB71f1xnEVJqx4gwTOgC8kY
	kO8/GIiXoUrbZbDlA/hjwdpBk3GSbOzJHhluR+I3yOb+IGqaAAu/wBB0vCrvm6QWsac9y56s7Wz
	FnD3GFuhs392D25TKq2E7ivqLMzAaQTkuXkUizWBOTvjXI0=
X-Received: by 2002:a17:90b:1b0f:b0:3ac:9f24:44be with SMTP id 98e67ed59e1d1-3ae897f55e5mr6520493a91.29.1793515094108;
        Sat, 31 Oct 2026 23:38:14 -0700 (PDT)
Received: from ubuntu24.vpn.host.chaitin.net ([124.77.157.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm14036712a91.9.2026.10.31.23.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 23:38:13 -0700 (PDT)
From: BeaCox <0xbeac@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 2/2] scsi: be2iscsi: bound the WRITE_FLASH copy to the DMA buffer
Date: Sun,  1 Nov 2026 14:37:54 +0800
Message-ID: <20261101063754.89598-3-0xbeac@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261101063754.89598-1-0xbeac@gmail.com>
References: <20261101063754.89598-1-0xbeac@gmail.com>
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

The WRITE_FLASH command derives an offset from vendor_cmd[2..4] and
copies the request payload to nonemb_cmd->va + offset. The allocation
contains only request_payload.payload_len bytes, so a nonzero offset
can place the copy beyond the allocation.

Check the offset and remaining space before forming the destination.
Bound the copy length by both request_len and the payload length,
matching the existing scatterlist copy limit. This keeps requests with
request_len larger than payload_len valid when the actual copy fits.

Keep the existing u16 offset interpretation; this change bounds the
memory access rather than changing the firmware command format.

The analysis, draft and validation were assisted by OpenAI Codex.

Fixes: ffce3e2e8ce4 ("[SCSI] be2iscsi: Adding bsg interface for be2iscsi")
Cc: stable@vger.kernel.org
Signed-off-by: BeaCox <0xbeac@gmail.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3b8551a1f0..1b95161cf0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -41,6 +41,7 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	struct iscsi_bsg_request *bsg_req = job->request;
 	struct be_bsg_vendor_cmd *req = nonemb_cmd->va;
 	unsigned short region, sector_size, sector, offset;
+	unsigned int len;
 
 	nonemb_cmd->size = job->request_payload.payload_len;
 	if (job->request_len <
@@ -66,11 +67,19 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	switch (bsg_req->rqst_data.h_vendor.vendor_cmd[0]) {
 	case BEISCSI_WRITE_FLASH:
 		offset = sector * sector_size + offset;
+		len = min(job->request_len, nonemb_cmd->size);
+		if (offset > nonemb_cmd->size ||
+		    len > nonemb_cmd->size - offset) {
+			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+				    "BG_%d : WRITE_FLASH copy exceeds DMA buffer\n");
+			mutex_unlock(&ctrl->mbox_lock);
+			return 0;
+		}
 		be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 				   OPCODE_COMMON_WRITE_FLASH, sizeof(*req));
 		sg_copy_to_buffer(job->request_payload.sg_list,
 				  job->request_payload.sg_cnt,
-				  nonemb_cmd->va + offset, job->request_len);
+				  nonemb_cmd->va + offset, len);
 		break;
 	case BEISCSI_READ_FLASH:
 		be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
-- 
2.43.0

