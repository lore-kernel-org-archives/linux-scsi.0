Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538173;
	b=z2jx/uqskf2iVcxbj/00O50w6qOAk9gTqsH3+8xEHxT06fn8S35U0oHU6z/z/N3BY7zN
	 L6lqsAWwiaO/fTr60r9nng6lu7YBQHJgYck5NRBQXHiWkXjftuIukG3kMTHc9yFYaYZpV
	 WY1E3an+TetBh8Gi2rczgu6epPBnHWBH23fB9OGokDwbaGSX/nE6ZJUzS3OsUWgvPIhun
	 e2lv5xfOVbiIeHJ/VbXBbsseDHosC0ozeY9EWpTmFtsQDEQzQ1K53wdDokkPNObkhuNEl
	 5+rwwwRwBg5VisiRG5uxartbTTAbMV1wKMvMiS6DtJJ8fqZmX440HpNhF0EO8yL0+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=2bIb6utckDAVVNVMntfTigEadbgFKDZJSoqLLBeE+3I=;
	b=449NLLZcZOUGYIiEAczCWKO5dVHgBEfBO1l8L5RriWOxqeDHZDzDuILuv+yDGJbEZLvO
	 n/2SlM0nK2Rg7M+AlJUpPcUjlZkbk/YLiVteOEgkIljGrhXiOapDKbNuszRC7bdP+qER+
	 sOzD0aA1US1Xqi+kBWRN/iGzZAAIEkO4UkX4k5B2HSQWjXuimeNbZz8cvCdUqROSyqgDp
	 2FUCLjedWV+5XFNZLpEZRvKsRQYVZaFm/sLi0eTPvKgKz7lyPExgLPZKu/hWnUNGJFhHB
	 m2jlXpTdXNqWUXaVpb8ZhfzvIaJPIwveWCsL8fPo1j7axC1dAK0+OhdGSZl93uzo0JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5Y9jRcv;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346AB606A881
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 346AB606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5Y9jRcv
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3425098ae4bso1100239eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 18:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794538172; x=1795142972; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2bIb6utckDAVVNVMntfTigEadbgFKDZJSoqLLBeE+3I=;
        b=B5Y9jRcvnYhESwdbgUjcg8ov5ov1wIuDYyUmbKT++u8hX91MVPWkdL7Cu9OkLy8Hbw
         JkfS0yhysawtup8SwukK6WqXpLdH1WetRpEdtRwZmAPMFHWzDM6Q3/IsRtXE9rt4UHtS
         wpLVJemf3DsYtQOC3Xlw85I7b2ruGw4Xj5alQxr9sfSo9tdMcQEz2q2CwSh6EykRiqDr
         T4fZS1pTRmae6+bte3NkUH2Dq3ZRYcqVhC4aS2wiFEbyo97jW5Bvh0LpJ0SI1gGnM/DW
         SM5BNWtj6zPIuj+58KlZlTIyONBsbQ+g8fvkP01O+GLDOCEYQv+8iP5zuNbFbENTRfEA
         fCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794538172; x=1795142972;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2bIb6utckDAVVNVMntfTigEadbgFKDZJSoqLLBeE+3I=;
        b=g10XHdfbjuunPhdgdLtg+/A/1typ3woqk3ZilmhbJpUyoPvcyu9/l1YyMqNlmmK6Gv
         36u2KcBGr2gyiBCBYHR5EyzKhSHS2IhnEcx90FW2AeiyddD1pcBLagiCzKqhXlZLP+cF
         tQ3TEUkw8Wlc94nl3a3GgxwvwUhZGYQp4VhCNvq/kp1y/bT0FI1tAauSwswdCvxqGtp5
         +4fXqS1q5OiqxOumP3NQuiFOY6lLFSszC3/1kkz5pD7O86TqtW1hLR1UKhhoS4II9sOB
         VFt20pF9QO/4ZPGOf9l6fgLcw9K0hbXtPYKqk4kvN+YIp0fullo9bPqntHgy8R1775DH
         0Gnw==
X-Forwarded-Encrypted: i=1; AL+hErGivn40lptN9dDWfD8xhFx1pdJ+2F11IoTFhH0sWKB0V3rqh/Yp06TMWhBVrIpmq4Kn1ARQIRwD97ZQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9SugXUg4DyccuMT+yy0qUhPYymJXVexephw1CKUhRaLdPO6gv0
	V3nIbU6oXmo1Sm3wZPIuIUtoMFhepktP9gRj99wDZoqsDhCj8ZVpOjvdbI9mUOfH/gBy1JGR4Oz
	RolZcYWb9mcGabFS7+qz0JeKPkMuE945HmAjOFQ==
X-Received: from dycue8.prod.google.com ([2002:a05:7300:88:b0:378:1191:3e95])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:4104:b0:36d:dcdb:70c5 with SMTP id 5a478bee46e88-377e15f06femr5624665eec.20.1794538171985;
 Thu, 12 Nov 2026 18:49:31 -0800 (PST)
Date: Thu, 12 Nov 2026 18:49:21 -0800
In-Reply-To: <20261113024922.27977-1-sarthakkukreti@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113024922.27977-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113024922.27977-4-sarthakkukreti@google.com>
Subject: [PATCH v2 3/3] scsi: core: do not retry passthrough requests on
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

Fixes: 994724e6b3f0 ("scsi: core: Allow passthrough to request midlayer retries")
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

