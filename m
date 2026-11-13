Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794530151;
	b=j4dOoc9hf1y3mZ5IenIq/IRf1JiUVFRR2iCdo+WlOw3m0hVqHkMqxADOHNB39zOfWY4Q
	 7BNioBdEJpohG1uzonE02iKBQqKZpH9epViXy+JwIvPJ2S7ub/LMx3jvhwpFZd+oSFVSq
	 0Uzt1ENwRtNQqb84pO3ju1Dr6GH1o9P6iTabib10ZzDiAeit3HKw7yzs3Slah1/0NldVj
	 D2WjkbD7s7DFRBCg3UWNB+Gu3jkAPfNqo/2r5Md1NG9AVcVpZkEZI1g6wldFlsoMH4MSz
	 PBaBPla51v/q6ooy622s5Mk99R3tkNQgZJBIPla3Cch+feXKsSaft0eBZKQ8pAmvQLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794530151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+/1cY6ZrJCVA1E38up//QamWrEv2l6bHlMUbtQACcqk=;
	b=JSrqKqWVm9rz6N420yb0WoC+Kg+7tXoRIDrBO2C69/gh/I779YnmpaF2K/W2LeW2+PPA
	 bPAl8kr/HifjGM+h6BPn7Ina1F3b2jACb2KfI2uc2ZpNKL39wbMQzfQA34n0V9Ebb+j11
	 KI5te2iOARHMkhvoqv7aWxPfP76EpxOPY98Pq/+GIge6sPV/iNXDfzfwJQ1z7DXhKTIxj
	 q+uz9OJgrOX5zhRnrEglyxTI79K7gWVA3pUe4vjf7Ml7cuW8Q3OtsGhm4Yvg4HfegqQzV
	 nKsUFuqHNMbSPsOFNaUEDmrc6GJF2MSqDho483+ArnVkJT0XE02q5pKoOeVgFZpLROw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R+PEhPOl;
	arc=none smtp.remote-ip=209.85.214.197
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9A4607009B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:35:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D9A4607009B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R+PEhPOl
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed276af91dso7097745ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 16:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794530150; x=1795134950; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+/1cY6ZrJCVA1E38up//QamWrEv2l6bHlMUbtQACcqk=;
        b=R+PEhPOl675YIyMf6fGRwXb6xqHN7XybtWwHnsvqN+ucBJzHkIcMIIlZ5aDzigTili
         xn8RjbZGkkviyvOBY0LLeW8Iphd3zVJx0PqDx+tbunrRFktAodjqwOJe/up/UGnjcuAj
         Ct2PxiE7K9hC3DGrzok9Vhp5VS/OOo4deRMbbNB14WSkgB4F9VZwmQ4WvBZPrI5PPl63
         E6zV2MIaS58XwRLukETOiROb1VSRMvDUjyOqooWKRrqwBfopfPmULdEvNDBeIxJmNFE9
         M5K1vbeY5g4Z5Ha8/w+P2d+TgccIFQ6ShBOfv2nsWe65iLcQvBUqyyat13sT5kMEuO9C
         KB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794530150; x=1795134950;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+/1cY6ZrJCVA1E38up//QamWrEv2l6bHlMUbtQACcqk=;
        b=HcTjm5fBcXaMiNSSe2ef/MqGZcY6bKzL6QpchCkDlasMmDtvjILnZOqF/v2NwPApRt
         nT2LmA1nR+N0TMObX32xxsvjDgggRjIWQpyXyX+xFvakJijMLs71uc5WS7GIw0ZGOwMl
         RCZtrn5iB3t0dz6P959Mf4mswtoS5EuGcIBjKydWsSAxje5Aun2C1rkukhMnsw1IyIgN
         HZHGgLfKxRH/rS1R3dbIthw1aztXxd6UBkworjinvmBlU04CA3yY1AGdsgh7LGUNczfM
         62rSH8Yx7V+EnysBNMfd0FkoUDXgXZr/LVLLG/FFNX7fI4Sq1/0r0+HOCbQWbYjmo++b
         nQug==
X-Forwarded-Encrypted: i=1; AL+hErFmcu7H01uixgZN5+SQE9nnAKih6VMJGUX8dYSYrfT9Bh6Qbt+wveQHwtIpi9D3ZsR0N1LaQsarCsaH@vger.kernel.org
X-Gm-Message-State: APuU4Z87A8uCx2YUfTM7oUnWZsJPV0m0O5zCBmytOw+F6IuSV1zzzeVO
	UI6NviwH9r/dQcKKwnYELR4fCcyYnNZZE23qmR3OsGC872zQOQJ24qgO4hAQBjD/9Nh5OUNqaSD
	c6hcGZinq7P9kH0xKCxmUiM/OxrNch4wP1oH34A==
X-Received: from plmm12.prod.google.com ([2002:a17:902:c44c:b0:2ea:e1c7:d3a1])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5c7:b0:2e8:4066:d247 with SMTP id d9443c01a7336-2ee0dad1fc1mr9431415ad.33.1794530150245;
 Thu, 12 Nov 2026 16:35:50 -0800 (PST)
Date: Thu, 12 Nov 2026 16:35:36 -0800
In-Reply-To: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113003536.3622755-4-sarthakkukreti@google.com>
Subject: [PATCH 3/3] scsi: core: do not retry passthrough requests on
 disconnected targets
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

Unlike scsi_decide_disposition(), scsi_check_passthrough() matches
SCMD_FAILURE_RESULT_ANY before checking the host byte and returns
-EAGAIN on DID_NO_CONNECT, DID_BAD_TARGET, and DID_TRANSPORT_FAILFAST.
Callers using SCMD_FAILURE_RESULT_ANY (such as sd_sync_cache())
therefore retry passthrough commands against disconnected targets.

Return 0 from scsi_check_passthrough() when the host byte is
DID_NO_CONNECT, DID_BAD_TARGET, or DID_TRANSPORT_FAILFAST, and update
scsi_lib_test_any_failure().

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 drivers/scsi/scsi_lib.c      | 5 +++++
 drivers/scsi/scsi_lib_test.c | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index af27fd3df8d4..fa16a75e810c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -219,6 +219,11 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 	if (!scmd->result)
 		return 0;
 
+	if (host_byte(scmd->result) == DID_NO_CONNECT ||
+	    host_byte(scmd->result) == DID_BAD_TARGET ||
+	    host_byte(scmd->result) == DID_TRANSPORT_FAILFAST)
+		return 0;
+
 	if (!failures)
 		return 0;
 
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index ae8af0e0047a..aafafe676098 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -184,8 +184,15 @@ static void scsi_lib_test_any_failure(struct kunit *test)
 
 	/* Match SCMD_FAILURE_RESULT_ANY */
 	failures.failure_definitions = any_failure_defs;
-	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	sc.result = DID_ERROR << 16;
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	sc.result = DID_BAD_TARGET << 16;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 }
 
 static void scsi_lib_test_any_status(struct kunit *test)
-- 
2.56.0.611.g1030f0b940-goog

