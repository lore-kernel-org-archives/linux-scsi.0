Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559227;
	b=s6QkDUhpre8Kpy7rcxyYFVCuJO8pSqmQYbvlDVnvhuweZ9qHVydqT6/hn7TYbMhA4Whh
	 xvx/2HAsU87Cemt7TFNWaO9dV7ztVPk4WjeVeE1jw9CQ4RQ/loW3CM9QtG6FK3s59oxRp
	 D7p8Oo7FdjNDCeGk34rmykGYQWbWo+a/KxdtBxD1IKBumj1aqg77HHuezbGc9RRXCtQOA
	 bFr8gNzhMXhdW1Mchjtcq7mSeFe44jn93h5aVRsBh+SLaKRwwAITlM1ALBu3tWqC9IGuy
	 1BswQyt2BRD9qQW3X1eitapD4bGXqTMSJFaWB2+fpAgHeityrkEEoVbuNr6mXYV+vLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
	b=HJIbEsxDPmeKcek78OyBq3Ed6K/kJhk2uHqLx4aRpwQCTuxVJZRV105FDjIUPL6bDdPa
	 pUJW98nHRa2/QrhQv7W8b8nVCKOQqeBit6fBGok0c4+VPDheE1lAqSOOhdyYjz5p2PUav
	 UrZR87KbATeMJ4OTBQmHgO2OuG00CKIvRVX0OTS6sQI1Tf3D5Uc6riWXa/GPYPSHRM0g3
	 TJxmrxfffdLEK6ROVhSzEONCFKpuOngskZPvtOY8g1dPBTjcA8arihGWHYQxK1+tly9z4
	 ioh2hdHlNDyQiAVywnkXr6voRyPC5cuwXABg/vU+jpIPaT/8tBMjytRlsc9d20wI/zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BFD606A8A4
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 08:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1BFD606A8A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso322550a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559226; x=1795164026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=WMW3oCUZ/rAbrvlxycYpeBLVSzfh2TLgjVIcTTWk0wKtre5oqsAU4oz9pcN6quLYki
         EU/bMMfcvEgcttMb9KZqWf3fu9f5+JyBdDUffJwHcSWVoQzx4x4aibqf2XX2cuWGlEVN
         jHg+RH+23I1Hwne/9x6ygIJUDwWrX8IAll0CKyXc4bjsaWYGh/v4cEvlblf11+PRq4TG
         aOQ3JKy/k+k1L3Jfm5IxA1OIUtrFHzONFmzEA8ZZs40hWUFED4kxkbdRsSNOkGpv+/aP
         ve2h2AkSK1xNt6f7GxVjbdv/44T9tB5GaQHXLjsduAhQNcgbD9fUH+finDFVkUy23xTR
         B7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559226; x=1795164026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=XRGvksDZFGueiRU3XSPTTKcJGPrlasW6rQ0MlnJ9nDUmF6YBvsJVTq6vYimFVRzUKV
         f7YuAgMgQ8u8spVmNzMU6/nXqPcSuk+rYyZP0Z58KQBMbRInvKsVFw94/4hfAyAHXlWq
         vaeV3Yg2M8gG1YVo/3VlqB9IZO6bNmEOmgXjnhMjWtvJZawJa4+bjhHSNVfiBV5bcHIY
         YNRScWlPOpsx59eqdI8XauDbP2oXV4tGQuOblY7Aqo7mCWa4ADeR2qLjr8fE31KueiGv
         jNIhtOzQ+UxeDT7MMqLRx5dBPEXzOkcL3rkyHKe42ShjLzX0k5gAlOKOSd58smT+alFl
         yLcQ==
X-Forwarded-Encrypted: i=1; AL+hErHtQ9Qm96lzPZmH9hWp+xe6oNI+BXuH/UjvGsstaDadok6ARHty8PU3Y32yZVBvFqpPcmKDkW22Kcwo@vger.kernel.org
X-Gm-Message-State: APuU4Z9hKjtDLKuASx8QZIZlU1avF7fPTKIHw4XYiXUK1GZlQUQAejtb
	miL62qmOl5qwZk4N3raP/CXH7xcH8sBBeAQuzt/MLbXsZvnXPR3NSqK3
X-Gm-Gg: AYBFou2ViaL/Gtsfq6jRB1mxmc791d9xqJ+Sl5Fg+D3/dVs9ZvJjPYdgNZl05tLCtzQ
	mD8xTqRjVSJYGCKKUoDngtTxee02VO+554PvbLuwqE5sw2s1cxnWNF77ubjFrYstHYahISTZN1T
	Kocax73LATUEOdlPgFZ8K+YAln9H0xxYEUMZgV+lhQajM9UUFohngHrQ29o+/aYfKUmA9jPQNBk
	XDSOumlX+2OFs1RLBgpGz6yuAOuM88PXC8oVTjMzjBck9fSG6mbrDPaMs2ZM97EDYeTEiXp/jLw
	Ej7NRe2f+HOZDKizonbylikZ4PpPuJnGyyLHZ/ZI5ytcNkq4puJmTQz9X8CwiwLpXcXa7XYUqIF
	uDne+Jvyk0+6TssqqIztJmQKCRZdcyduBkdnQuDy562E5vKQd4RXtAcWULayue+GhrCnp8wSNrP
	W5N57shGnGM6FvZivu5nQU9nKqTpXQws3WqYqx/hPy0qZM4vDpClCn/GNY3ReYKbJx2M1dd7J8t
	AeIPzwsYPz1M3rPCgL1nnvMqnqiUFv5zNzdr/4KA0GeQoV2EH9XYfMLwHSzQlr3RdtS9nF+lYwM
	83C1oYp4hiDvgU66IQ4kSMZWLHlpyOqDwHjrg8YMew==
X-Received: by 2002:a17:90b:4acb:b0:3ad:6090:a189 with SMTP id 98e67ed59e1d1-3b1b0b67b18mr1705922a91.45.1794559226059;
        Fri, 13 Nov 2026 00:40:26 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:25 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 1/3] RDMA/srpt: Initialize commands before returning BUSY
Date: Fri, 13 Nov 2026 16:38:40 +0800
Message-ID: <20261113083848.1517595-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

srpt_get_send_ioctx() clears ioctx->cmd, but descriptor parsing can fail
before target_init_cmd() is called. The error path then calls
target_send_busy(), which dereferences the NULL cmd->se_tfo pointer.
A remote initiator can trigger this by submitting a command with an
invalid descriptor table.

Initialize the command before sending BUSY on descriptor parsing errors.
Do not request an acknowledgment reference since the command will not
be submitted to target core.

Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
Cc: stable@vger.kernel.org
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..127f256c6e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1597,6 +1597,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 			       srp_cmd->tag);
 		}
+		/*
+		 * Even on -ESHUTDOWN, target_init_cmd() initializes the command
+		 * so it can be completed with BUSY without core submission.
+		 */
+		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+				scsilun_to_int(&srp_cmd->lun), 0,
+				cmd->sam_task_attr, dir, 0);
 		goto busy;
 	}
 
-- 
2.43.0

