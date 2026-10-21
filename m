Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575842;
	b=wvTnssY1FWbMO+Yo1CXMV6wSMvWkuw/K4wMWT4qukvN1YY3v0h+F00CD6hKtlMj5wZIN
	 5ul13WQrWWDh5PBhTFe1amCiVUxLmKNXoyYICAxQ39Wlw6tWnOKxBp+mY2Hsj7GUSkbui
	 TJ7HLw750w66nfD1KjJ+fM2aVBFuaF0FmC4m/4xr8n+KpuEt1wLxK3xHCCEko3rhaLh0O
	 WS/7SB6HBBiR6wTI7oa1MVCO1FfprnFqjHVury+BJD3Q0hbXazeMswpDQJ/KJPA/pigtr
	 KPPAm69UtZAS/Xku/VLWMlGc8O/1iwtUNZEjGT+Tt2kEuWm2QQIWgyKAOawzwT8YUog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
	b=uLXD8B80lw4t9TNf4UzRRC1DsRRzBR0Pu+Mb2X7eY6n/dU/WULzCvk9BoO9/smqCSQ1e
	 PT/NV3S0L51KnorADXQ18ZySEdH7FVisacBtYcdGXweXPr1jUoZEu8NsD7BrCH3K5DFGM
	 p+OAiVActgxPQ7IvdpQpFFvWj8Kuy+YH7nRJ0P7YY2CVlhu+vgUz9RxToB4L33fX/lw55
	 74dxjxMD/R8uABLdF3qmauBs0iRqeJ+wKEpHhf4XiuVBEoUat+gP1GbWEgPf7Vz53r7Av
	 ayIxZcCxh3noilFJHynmvJiwiBeiVjixGJBQXvPy8uT+u1xWaR4w84Y67TnQ1tGI7jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Src1xL7d;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EA5606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 09:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8EA5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Src1xL7d
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso186577a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 02:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792575841; x=1793180641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
        b=Src1xL7dJtcD+mW+4kphC0vx+JMq83KXMH7usEwmz9UqBfkDiDbWNHsEfnycXz6ud9
         7VivyaxWw+ti00pkjfGK1MlvcmRnSq5gh2DOZe1/MkXLfzQ9CwFQo4aQ2ySO4JfEQmgg
         0kKaPeUdtyv+tdFE3MQcZveKQZQbg1Rm0a0jfYnlKuRomlWGdsohhjfVVyUNem/FuDZQ
         UOQ7jOtGhCzQwc65ruy2qqcKfbCFMfIvZf/jvwcPlUURw9h0goYmGrC4AXueXh1ipwzs
         YlYj1nXfSkGmLs83iusDHVYQG6yPl3bWUdwQLSAOWrFOjvo3JzVOZqQsBPeWon4Lgbxu
         S/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792575841; x=1793180641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
        b=kZBuzTzKT3KzLv85Ob6ZknbvHQxpX+F7YRmVKK9PkuFv72QLmN7KHWCbaybHw9JLJ/
         r9tXVau4/fGMo3ClI8lENMaxf+AvY4l6k07dTYCIjyBi7q4Ghk2Jkc/O23CU5IRuOq/c
         t2CU4VRWLIL0fAKef3ecL5XDTQDyFNrtwEi5129bM7lXFAVT3HCGDVqpTHeRtIGGAGMy
         Dxl3ZKopOdgnN2uKJAcl3gr8Qsjj1uMFpUG8w7IIvxxRGBdepeWupM+3kkYmk72SdVqJ
         pwgr5mkfAqa4YFudYsKEV4elh+8BArpY1z1mHV3McOY25zmQJIs5N9oDWqZZGPS+5wlW
         a+kg==
X-Forwarded-Encrypted: i=1; AKwUvBxXDoCom8PlfTEoxyK+jSNGMC2APLsFT0G+VoXAKI/Roe8PkligNHG+uP7eDFfMBUnZbo7c6vdU8Wf/@vger.kernel.org
X-Gm-Message-State: AFq9FYKnWZTNCRrUYSqADFGKP91WZVpHBaKZIjjQlEEbouwiLxwX1n0Z
	ETBc1mgNHN8QR7ki5uro4wtHP/eK18iFBTCMLuG1FIfTKIgIAbBYZ9NM
X-Gm-Gg: AYBFou300qU5nWIvgpnoeTNd7YxP9NYklYT5bp6DMzI7+lLxB905AzFhCfw/2ixPxP5
	V/HKZdiX/ar8hT/7UmUUqkWB+SElDj345gPBJ4dI/qjF503bpfSeiQx9OW37Mcddveko3ivcHNb
	EQI566qtchRNh5MqZEdJmDHEYHKS5YzaOM2kYq4khphPn49YwNM0O2eisJvVLGhh9mIPlzPntoJ
	VZC7LEg3OU5It3VtB+yr0e2l6pZZ+KZZ945KFO0RMIOtDltgM+p6tbcd+Trqv2jMN501nV56u1s
	wGrYv0YKrDc73MXGQozuoqpBSa0wwHUH9rcGTNgd1CaltwDr3b4IdmrNYJ6dX4cSYEhxJ/xX9jC
	fsmIUo4k3xi8EtZvAynI392VO21bAfUOgL1jiW0IXsfSSUpDstwmFiZkTfM2OK+DwMX0Z0SuSRJ
	ekd+7CATGxBHizkCjUyAYp5lfUBB5bam8bWrszAcc+p+HQFbzEK9rnKQZDMk11BqTnmITmwiOq6
	PsjR5W+CNX5R017CaWsby2Fw3yFPB4svOo+3YCr2JxVNflaOd8r8+A=
X-Received: by 2002:a17:90a:c887:b0:3ad:53e2:78c1 with SMTP id 98e67ed59e1d1-3ad86e980d9mr1157973a91.10.1792575841069;
        Wed, 21 Oct 2026 02:44:01 -0700 (PDT)
Received: from gmail.com ([188.253.12.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad8021d29bsm3644438a91.4.2026.10.21.02.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:44:00 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] scsi: target: validate REGISTER AND MOVE TransportID length
Date: Wed, 21 Oct 2026 17:43:34 +0800
Message-Id: <20261021094334.198599-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
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

REGISTER AND MOVE has a 24-byte parameter-list header followed by a
TransportID.  A 24-byte parameter list with a zero TransportID length
passes the existing tid_len + 24 check, then the handler reads buf[24]
for the TransportID protocol identifier, one byte past the received
parameter list.

A TransportID is at least 24 bytes.  Reject shorter TransportIDs and
compare the declared length with the bytes following the header before
reading buf[24].

A malformed PR OUT sent through vhost-scsi triggered this read on a
KASAN kernel.  The command is now rejected with INVALID PARAMETER LIST
before buf[24] is accessed.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 25b1bcacc0c8..ca1a2802aa22 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3226,10 +3226,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	if ((tid_len + 24) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+	/* TransportID is at least 24 bytes. buf[24] is its first byte. */
+	if (tid_len < 24 ||
+	    tid_len != cmd->data_length - 24) {
+		pr_err("SPC-3 PR: Illegal tid_len: %u for data_length: %u\n",
+		       tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
