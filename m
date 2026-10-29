Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307305;
	b=Lhh88JWC9LSKbwBbySgs+WRG4/+4XsjVGhk8LoBrxn/mRTnjVrjxGXEEsCg6ounXfSQI
	 iGUfvZYolDV6jFpR5AJs6y3h4/QcxqUUOjJ7wjRrL5u+ie6bePCwXbiCa8WhT3GpGtb+l
	 AC7VOksUDFn1jzerOK6rvRz0c5Iq6CrJMyPHITNgShLjIg8hf5Tzkb2TvyH9fPFRf4dj9
	 X0AoB6rvM4hJeBl/hVAymfMoFsEIz4M40ze4mVMSRs4Ai59fMS6trv2n7yP9DRHdm7DXr
	 avD3Whb822CcLla7JYFeJ/G08jPUNG8ZY1G5QBvu9cuDHt0AE6orULiqZR8MYJtRFeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307305;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yn0E6PsawiIQSMWnv5cp9iauDzybQJHQhfdxbkgQhf4=;
	b=XBsf0F36vr8GdZOWg2m8gDz8kNeaglOl82qzHBvHOA+Z5Z175HMdbVQlgYG6dPUrPL+/
	 6DTrU79D7vQRSN49csbvfV98e6sKovKKGgIkK+2rUAsJRx+pHSPBs/JDvSaEqqWzFE1Ta
	 0ywHG7sg0Btu/A4yVUQFBsIgCesFNVYlm36iMyMblP9kFTkLMg1jwBX5Hn72lHVc6XpPm
	 2oeNMyM9nPQL9oSzqB2IV9kRd8SS5U3hyMWSHv2H/yUixOR3mObZANNv7LM9TwoYHgPbi
	 LvsmsepRXBhP5yT1vvnSdb6ehdsU4oV3L8jtmub3lpWOdX2k6zdG/wLcrXc0f5ZD0gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x+4DBvya;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A18A606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 20:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A18A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x+4DBvya
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-353804b591eso169399eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 13:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793307305; x=1793912105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yn0E6PsawiIQSMWnv5cp9iauDzybQJHQhfdxbkgQhf4=;
        b=x+4DBvyaqroUy4LfNUqU4OfStZxkx3ttcWS+SVU+ESx7wbqQ7MrQc2PTQx/aXNQtMa
         wbMshrv+GpuagtGtY3iIgTxga/Z0GjraDLi1rJKnTdUsZ3SKxM9jtiYnsHdYXALEEDNv
         Sjkg0+V9o5KzR9AM2mn1jY33AblwXNDykIc2i1w1Ygduyej8GMbAiFORkGRAFekzK4ea
         oTbhfQHPzuJQrYh+ynQAXxPiMHCAI7zT4OvgwqrnawCdU2IYN1YvaBAyXQCwI9ZOHih2
         Hgpc5TAHBUUUnNLpXI3KC9w/C2sZuBTEDS8tJ83q4ahi2bkp7IiqEMjtTA0lKEUTX43Y
         zduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307305; x=1793912105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yn0E6PsawiIQSMWnv5cp9iauDzybQJHQhfdxbkgQhf4=;
        b=QChsgeObGPs5mXeTHWwdwgwQ+1ZjvIHfVvMrGpnL7til975Mmg6fcDEMICbtHPpWMY
         MGapBwl0v1ZGg9/+OxVKqtxoVnYZa5g9lAqJ0JsYhki6EcfmRgmesHtgbohiFYNHELq0
         P27ffUxsScnVq/d80RkDeDs982Gxj9+1L5EsK0ABKmcO9wBOjtACZeajhmTb1xwB9+tH
         Eo3yH+KQiitasgrbtPXE7KTvxy6zc9am10y4nML7q2DkkzCRUQWUgqiy2GRT2AAx/WOe
         uCOCqfGKrxtb7oEk2M6O1zvP7XQHl5jCd9bRJgse5vmRZbgZAqLWPg6boWo0h3l1PM+3
         XYXg==
X-Forwarded-Encrypted: i=1; AKwUvBxAOg1UnsWUfe5KFXFtTdIEOQtO4k2hyTKcmd+S9EaDT/82iKftgQk8S0Fj9JfDqH2waYD0CoEgbnWy@vger.kernel.org
X-Gm-Message-State: AFq9FYK0LxIWuvGC0DYbEhpX/8EEP4Mm6jWVBV4EenM3zmxeZ5OPRQwN
	Rfltwgr4YUWCWQTUXEUQN1x+6YTylGit/IJxEXsBVTHUlB3W2znnQiDk
X-Gm-Gg: AYBFou3I8QeHJUS29UcwcvhpdHysHfy6Fh/Lf1II1zHtaL1KRRO5yR5KW3wV/Zjvmxb
	oOPAvJFFo7rGFhct5gj73N3acPipmv/aD6Ah506Nt5R7joa8p/QS8J1qJEd4Mn9RzpH49MBGe0F
	bjwMclFZPT8k8ro0MxaNEhbYOW03POUf7OKE10VC54KVGALB7Ld43P/koknQamShdITaLVC+wN3
	/pTLP59SoNU90m1aW0tH5QSnIUqk1H6lmaIFwAWPtQQQFsGxzEgNPgElqJ9uCVEwEfOQwQinFRw
	LuJKIGXzJCnn4lGr6fERNiWTy5Z/+btUdkn4EEhTBsQeiDyWqjAziUXc2YQjHhX8aE3QK343xFA
	9eWL4Z0a7823nqSi7ux672PFhs/p+T7RKwHvFblGZEmLpQTq9RenufdHl3mZ5FwWdTsSrJ05p0v
	eTY8Asr6xDCR3BpclCOYgvEhuouusq5EyuAXq9JElLxhAtEmVsTAhC4eCI7fN0+aGUSQnM4Br4g
	qw3ACQHR2LZ+gLYKX9xd0Co7wLcYJ9EcJSdOInEYt7+wPL4xwuMY4JVvDBYJgVsOM0NwsQXT/FN
	PV38Yr4mxT7PhA4BQDz0cDqBvKhm7Czi3FWyoCa5N1+yBz+7LuBQnkZBMUd/0CorsuQ=
X-Received: by 2002:a05:693c:41d4:10b0:35c:99e1:c755 with SMTP id 5a478bee46e88-36a4242c0e1mr727112eec.38.1793307304487;
        Thu, 29 Oct 2026 13:55:04 -0700 (PDT)
Received: from localhost.localdomain (wood.seclab.cs.ucsb.edu. [128.111.49.37])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a61a0csm1274968eec.22.2026.10.29.13.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:55:03 -0700 (PDT)
From: Praneeth Balasubramanian <praneethb2002@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Praneeth Balasubramanian <praneeth@ucsb.edu>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: Check for existing sessions only after authentication
Date: Thu, 29 Oct 2026 13:54:56 -0700
Message-Id: <20261029205456.1211532-1-praneethb2002@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Praneeth Balasubramanian <praneeth@ucsb.edu>

In the operational-negotiation path (CSG=1),
iscsi_target_handle_csg_one() calls
iscsi_target_check_for_existing_instances() before
iscsi_conn_authenticated(). An initiator can therefore send a first
Login PDU with CSG=1, TSIH=0 and no CHAP exchange, carrying the
InitiatorName and ISID of an existing session. The target reinstates
that session, which tears down the legitimate initiator's connection.
Only afterwards does it reject the login with AUTH_FAILED.

iscsi_check_for_session_reinstatement() matches on ISID, InitiatorName
and SessionType only. The InitiatorName is not secret, and open-iscsi
ISIDs are a fixed OUI followed by a small session counter. A remote
peer with no credentials can thus repeatedly disconnect a
CHAP-authenticated session and keep its I/O failing.

The comment above iscsi_target_check_for_existing_instances() already
states the intended invariant:

  NOTE: We check for existing sessions or connections AFTER the initiator
  has been successfully authenticated in order to protect against faked
  ISID/TSIH combinations.

The security-negotiation path (CSG=0) honours this, calling the check
only once authentication completes. Move the CSG=1 call below the
authentication check so both paths behave the same. When
authentication is not required, iscsi_conn_authenticated() returns
true and behaviour is unchanged.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>
---
Found by an LLM-based static analysis that checks kernel code against
the rules stated in its comments, as part of research at UCSB SecLab.
The analysis was done with LLM assistance, and this patch was written
with it. I reviewed the patch and tested it as described below.

Testing: two QEMU VMs on linux-next next-20261023 (20a33c6b6cbe). The
target VM runs LIO with a CHAP-required node ACL (generate_node_acls=0,
authentication=1). The victim VM runs open-iscsi with correct CHAP
credentials and continuous direct I/O. From the victim's network, a
script sent 5 credential-free CSG=1/TSIH=0 Login PDUs with the
victim's InitiatorName and ISID.

  Without this patch: 5/5 logged "Normal iSCSI Session SID N is still
  active ... performing session reinstatement" before "Initiator is
  requesting CSG: 1, has not been successfully authenticated ...
  login failed". The victim recorded 79 failed I/O iterations.

  With this patch: 5/5 were rejected with AUTH_FAILED, there were no
  reinstatements, the victim session stayed up, and 63 I/O iterations
  ran with 0 failures.

The code is unchanged in mainline 9ba46df34488 and the patch applies
there. Legitimate reinstatement after successful CHAP still goes through
the CSG=0 path. I have not tested the TSIH != 0 (connection
reinstatement) branch, which is reached from the same call. The
reproducer is available on request.

 drivers/target/iscsi/iscsi_target_nego.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca34..ccd468e26fb9 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -982,9 +982,6 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 		if (iscsi_target_check_first_request(conn, login) < 0)
 			return -1;
 
-	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
-		return -1;
-
 	ret = iscsi_encode_text_output(
 			PHASE_OPERATIONAL|PHASE_DECLARATIVE,
 			SENDER_TARGET,
@@ -1008,6 +1005,9 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 		return -1;
 	}
 
+	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
+		return -1;
+
 	if (!iscsi_check_negotiated_keys(conn->param_list))
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE3) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT))
-- 
2.25.1

