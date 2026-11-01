Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793515091;
	b=eoHFeNcGzvKRhSoGotUYdeb/BBcVR9vEbzEFP7bWnIEprC4Nq751Ec8Zrmod2qbcnmde
	 xc/P9HyJvNHVjJCw7bFqGaievxlbiGKxaUefz/tCVEhTQs3o1ghRff5L8Iyu7uJUTkvSL
	 O779ySGGUuLklIWA/VKQgH0TcnST28zLw/CcKFTq4Szx8Eg87wk4zltxqw9ZIQCyVgQZz
	 VugRpJ+cU09KJUDoQv+eTaIbw4SZm9UdqwGPf6QC/0t3nk0QzlnAeouRuTYmrkqwDkn3X
	 eIdmj2fP0bFtmegcmtuTT7aXg8GY/0uUuCJlGFU8MU34rBB6Iyea9QYuHgt4GgSsC9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793515091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=14x9vk9vqr2toSJvl/cMga8+z/V3rFoujSUlXXEXROg=;
	b=4If4uS2eEsWejEKrYxm5ArzZq10xedMgmdVgyhf8gJiFNJE0svixa1mNHxlRTD/+PlHt
	 Zphdq0Arz66dx9UB+QNo6RQz1ZhmeUMwLAAdrrSGEN3VBZp5WIPKv33ARynos0fRA036Z
	 snQPgPiPRcLYWgl7e+OQDehUxoLB226mU1+3BxjZ3G04pp/S+/m92BiszBDxdpfq71SKR
	 x1C8d7VYHbd/KZH4mcBFJfHEeEsw82WPWrjSSYZQVN0YMkSQg0QKYDZgDEkkbZ9VumQzy
	 IbVEz0frYSoPf/+vYGHudSY+1UOh/VeglTyHS7rKQ5poa3AkBSIG1qzRSLXDYi4wDVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jaKbRs8q;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B158606A32D
	for <linux-scsi@vger.kernel.org>; Sun,  1 Nov 2026 06:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B158606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jaKbRs8q
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e987b4a710so16143155ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 23:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793515091; x=1794119891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=14x9vk9vqr2toSJvl/cMga8+z/V3rFoujSUlXXEXROg=;
        b=jaKbRs8qDefvyjJnGr4taFgormkQZjV9UOuZ5l57Dggjjs0zqQPWuFXSxxxays//UZ
         6UNPEhubBJoB28MYY+j7JRhufn7fO2HisNV6L7NbTWTVDwAk1y34KPmA+BkGAS8/RrM/
         tc4WKkGrXYn2p0a/rpKX6eqMXbZqAbnK5okTpm9TJXAegQrRiOmG8uvEkDzOhNWhK7x4
         TCr36tWRlgJUF0AZ/AmiUF7El0gVn4tRzDje30WD28aE5N6csGwP2uENypBdTRe66Sf8
         jL9wPcGtiiF+M0vFE9u605IRqlsh3TdidX23X6r2QBhhBqKfJE+Q82hsdaM6dgl/DTgS
         9Xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793515091; x=1794119891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=14x9vk9vqr2toSJvl/cMga8+z/V3rFoujSUlXXEXROg=;
        b=vFWP3RZ2VvhfCkvgnltvWcccGnwoXHEWgZe9t02GItGRDQ5iVxw8oi749ZlyBUr4dn
         UVD8ZQBmRLdctgZ9KRQFoB043LSttaRv4vicpE/HokrO/5GzZZVFC6IkJiQ5lUem5VVq
         LNHGpp16fFEKq1WQWhi3gVAXKGrLW1krnqnH1G24DkDeKUpSTKSVrK6n4t8GQwxGE/eX
         MYT4V9wNy4ydOiRqS0G5cUBeWOh4fIzcafxvg5gwMAOmY+765g6Ko73Af7zULd8ZiubC
         KJkWony6bxcEDw44ntdXLNKSpSFkr0pSyhvpTY9AtfOQdTl++2pF0LZQxu2aNfNIO7vG
         xsSw==
X-Gm-Message-State: AFq9FYLHhJ5OmsMvl7RhNns44SuVEen2Ll4mZEyeiPbncFGii9ePVZcL
	XlRqwajPNnYGOxUkGNT5zaAYMaA0B8+Mmn3BHTIv0xjI9r3Ra5dLpmr+
X-Gm-Gg: AYBFou1ZuNjVX/enYsa589w/pJzVMGUcWzwUCCZ3K7AMFRLkwggMLpioIKt7M7FEU0d
	PxS5D6iMGcJPYTfSHkY/FhFv6PnoJ8T0ttZkeNA9YGjSxKZqjx4Gf9gwKxBJYgTRHLwVeqbnccz
	u4+K3VHTjziWSCXUPMs1a4kmAXKNXgIs2i8U5+ytZakQFhLjZtV0qNx8GUx7DS5b0GOaE+FEmbb
	9spbCgyL/cMQjDSQnLF6x8VaefLrFMbbee3TI9GBCBfBy/Q0Jhiu4h23Aazu1dCwA05uS+ykEKg
	MlQp7xDkYurRBGHl88nWuc6uJWc+bmAyuwY0kMVGGb5zZvUjNK6YipJ2lFlsdxvqlfekZpQGy3M
	zxrjqX7qc5uTuv++07u6lf3sgrCjhFZO/ru/RJVVUeAUB3ai/kWPKSndTOxBJ7fUgldOylmjLq9
	QTkmw646KhJEIOQy4Vk1QABalEzjJ2qXONhJ9IPuvIKRFNSKcffyBe+J/5nbHl2qBeWPupRl6lg
	S6zRDdWa95HidJcHKrw8yLsK+itA+ZqQm/LoMPafPoWvRdzIQfCgZFkCfhc56hI+ZExV+7oDWU8
	4AVzZ4Mi54f5r9STeh2mFedkzIomYRMHhUqOL129mDpFMHs=
X-Received: by 2002:a17:90b:4c4c:b0:3a6:d2ac:74ce with SMTP id 98e67ed59e1d1-3ae8972b662mr3606936a91.19.1793515090638;
        Sat, 31 Oct 2026 23:38:10 -0700 (PDT)
Received: from ubuntu24.vpn.host.chaitin.net ([124.77.157.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm14036712a91.9.2026.10.31.23.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 23:38:09 -0700 (PDT)
From: BeaCox <0xbeac@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 1/2] scsi: be2iscsi: validate vendor request and payload lengths
Date: Sun,  1 Nov 2026 14:37:53 +0800
Message-ID: <20261101063754.89598-2-0xbeac@gmail.com>
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

mgmt_vendor_specific_fw_cmd() reads vendor_cmd[0..4], but the iSCSI
BSG transport accepts vendor requests containing only msgcode and
vendor_id. Reject requests shorter than the five command words before
accessing those fields.

The DMA buffer is allocated using request_payload.payload_len. Require
space for be_bsg_vendor_cmd before writing its fields or command header.

Keep nonemb_cmd->size initialized before returning an error because
beiscsi_bsg_request() uses it to free the DMA allocation. Return zero,
the failure sentinel expected by that caller.

The analysis, draft and validation were assisted by OpenAI Codex.

Fixes: ffce3e2e8ce4 ("[SCSI] be2iscsi: Adding bsg interface for be2iscsi")
Cc: stable@vger.kernel.org
Signed-off-by: BeaCox <0xbeac@gmail.com>
---
Testing: x86_64 object builds with gcc 13.3 and W=1 for the first patch
and the complete series. A userspace harness extracts the actual driver
function and uses hardware stubs with ASan/UBSan. It detects out-of-bounds
accesses in the original function and passes 2593 boundary cases with
both patches applied, including error cleanup and lock balance.

This is function-level testing, not a kernel/BSG reproducer or HBA test.
No be2iscsi HBA or firmware operation was exercised. The BSG entry point
requires CAP_SYS_RAWIO; no unprivileged exploit is claimed. The local
harness can be shared privately on request.

 drivers/scsi/be2iscsi/be_mgmt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index b1cba986f0..3b8551a1f0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -43,6 +43,15 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	unsigned short region, sector_size, sector, offset;
 
 	nonemb_cmd->size = job->request_payload.payload_len;
+	if (job->request_len <
+	    offsetof(struct iscsi_bsg_request,
+		     rqst_data.h_vendor.vendor_cmd) + 5 * sizeof(__u32) ||
+	    nonemb_cmd->size < sizeof(*req)) {
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+			    "BG_%d : Invalid vendor request or payload length\n");
+		return 0;
+	}
+
 	memset(nonemb_cmd->va, 0, nonemb_cmd->size);
 	region =  bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	sector_size =  bsg_req->rqst_data.h_vendor.vendor_cmd[2];
-- 
2.43.0

