Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794616428;
	b=wMHyCapc69sK4YeEetEvbZWnX0a8M7UdnWpVq7/Wlba+NR/qZuNnTkfrA07SF+mNOkV6
	 GpWdU7IgG5TF9sopmbee2t20VenEHm/eSFTMgTeSm8r64TKSKPX5586JveLZYvkILQwOU
	 yBOFbkYn8vhLzeym88IN0jXqoxdtGeSKJksRjNFtbb+5JYYA651wAz8uH364IeF4URg1d
	 sK/mf8pxQxD+yvceU+qhga/TJomV/fxDC6YPiGcXGz+DaaUuzfj3gJAK42DGfvUmffPUU
	 RhLO558MRiWjNS1wufCEaDqL8S+DtFl/XfG6uMWE86XKCiuq/WeVmztKfFPw0FsZKOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616428;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1bnpAKAisFN7BP2OHDTddn21Tp+toUMvXTb2Ub8ahpE=;
	b=IX++2YTKpxsubCAtxxLhbmvbo4iKE7w0oykZxfyWhPK2p8nwRqttpSQ8bKOEMvT4Fh//
	 rj79Hs6pDJuzMjxIXu/cdkvE8pCu8ucTv40fPzR4/z+tDOn/iVtPHftwUAHtyDTq9tI2b
	 qhBu5MkorjY3guwWF1LDgwRXAAeOKsnjpwxrWPLTeNaDdfZuow+pZrQpTubx6lfypRHtk
	 A24TlelZP7J9iv51MDDesiGsvdqebV+6o1veFHhQxrF4+2g+H736Pq8XDjkJksKrA+s4+
	 lsYHP6/pbSbVx/7gYGL1BGsFmovWLFNvVc1Kkj9qEsYkuSWYJIxP0K9oXvKgH4YUSIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebbmpE68;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074A606A336;
	Sat, 14 Nov 2026 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebbmpE68
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794616428;
	b=r/bqIq467g6n0nNvum4dFZdYHfsAdDykigCDyFo8TkkMnzrwlnWBI0EXF+osuz4FXfgM
	 nxA6Y/2gkHrJ1ILN6GV5UVoHw5338ijot0bB6fhRTp71JFNLuZiq1jgeuRvhTAzKh82ns
	 jdp0lK4BT6bmPtLS5TQGCtoNMDHsIzc0jZtlovOyCqG7NyuA9rZCld6EhTPCFrovM0Psx
	 n4+82RE0AIxYqbN0U8KbfvsHmTG/z+dq0itW2QuI/1UK8m3yYfFN99xqMSRUdZ119G4sS
	 a56TX1D+rhpJ1vMcUxejoulO4vJhr9Z1N+SgBOE7T62FtQ3+d77Qt8YHjsA4QL2PYLg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794616428;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1bnpAKAisFN7BP2OHDTddn21Tp+toUMvXTb2Ub8ahpE=;
	b=waMyZE9Jd+ymqSRDiOUXskbvHUNk2u2QPNT9eNiPZltGaFYK27vcdF1hpdqDcfat944j
	 wjlixxF53VCugOtsmhQEIw+d6yd3U3SEX4BPl8HPtTSe9DfaLrPeOyDQq2ePp8YLdFoOc
	 Y8X7hJT1++osljS7eDyGINuFsScdd3WOk8sGvqzA+YGIB6sxpuQH5WXQ7ulU3wxdD4YKJ
	 pmujJO10v8sPvjp4xjC3opwXyno7lsHvWZnhV7aJ/Htx3qMsSe2g+JN7SkRBa2sc1fonX
	 Ts4lL5ZCt49n1fsnLNwJgLnlhJqVeFoe+vfbMJhSqnX0pqdEBcpXmry7fLEWX8/5/cQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 92BB01F000C4;
	Sat, 14 Nov 2026 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616428;
	bh=1bnpAKAisFN7BP2OHDTddn21Tp+toUMvXTb2Ub8ahpE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=ebbmpE68EfcBAvaDDwqReBVPvQepaFQByUHB7l817wooFE6OXZb8YwNzYm2YrpcZN
	 kNC67/AqemI70/46t7ZyoBzA4pDNrj/j4UNxU0GajtE2PTAxNIwG2xBvhflzRj5d0M
	 m2QZkHqI1MmR/v89DkcqnnF7VBjW6qDF+qIYWPF7f9of2O7p6yiX8iRq/RABQo4WEQ
	 ZzMNbnpidz0GsXw7CQSbkvwKsEhDGjrvb2q/maitqfbyILVkC9a8T+sEqvVwFRu8vx
	 GAJtxTQtsSvY1Pil2lvprP1OAv+qEr+7MvKUsuFpSNlhDt7UN7oDAIwez2Ftfzf2Cv
	 h07mWXfUY2WRA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 240D149BDA;
	Sat, 14 Nov 2026 00:33:47 +0000 (UTC)
From: Izaac Chong via B4 Relay <devnull+izaacchong934.gmail.com@kernel.org>
Date: Sat, 14 Nov 2026 08:33:43 +0800
Subject: [PATCH] scsi: fnic: Fix typo in kmem_cache creation error message
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-fnic-typo-v1-1-a9f70c9c4a6b@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQqAIBCF4avErBNSpKirRIvSqaaFilYU4t2z2
 jz44PFHCOgJA3RFBI8nBbImg5cFqHU0CzLS2SAqUXPOJZsNKbbfzrJGylYLzCtHyH/ncabra/X
 D73BMG6r9DUBKD0aIWzVtAAAA
X-Change-ID: 20261114-fnic-typo-7449d2e4494a
To: Satish Kharat <satishkh@cisco.com>, 
 Sesidhar Baddela <sebaddel@cisco.com>, 
 Karan Tilak Kumar <kartilak@cisco.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Izaac Chong <izaacchong934@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794616426; l=1054;
 i=izaacchong934@gmail.com; s=20261114; h=from:subject:message-id;
 bh=aK+ZdndpFxlDmt74J7lkKpKkjfqPLloO4qhOgeRfRYc=;
 b=LvzW5ATwEWwcdBjbRpA0qBV54BEsyR5iA+ZPus6w8l0rW8U5dO8bv+a4DfuZ2yBioLUnSfnjc
 ulXpHC+SWVkA2z0qCt2iJbAxX2ipsmnkuEpjGnLDtKZCApPkENof9AW
X-Developer-Key: i=izaacchong934@gmail.com; a=ed25519;
 pk=IFfOWcK2ZRkDtCqaNggolAwpvIidYMt3Oar3NEnvqzY=
X-Endpoint-Received: by B4 Relay for izaacchong934@gmail.com/20261114 with
 auth_id=1518
X-Original-From: Izaac Chong <izaacchong934@gmail.com>
Reply-To: izaacchong934@gmail.com
Content-Transfer-Encoding: 7bit

From: Izaac Chong <izaacchong934@gmail.com>

The error printed when the fdls_frame_recv kmem_cache cannot be
created says "cach" instead of "cache". Fix the spelling so the
message matches the other cache creation errors in fnic_init_module().

Signed-off-by: Izaac Chong <izaacchong934@gmail.com>
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index a19c0b0d8..10c2de746 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1460,7 +1460,7 @@ static int __init fnic_init_module(void)
 						  FNIC_FRAME_HT_ROOM,
 						  0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!fdls_frame_recv_cache) {
-		pr_err("fnic fdls frame recv cach create failed\n");
+		pr_err("fnic fdls frame recv cache create failed\n");
 		err = -ENOMEM;
 		goto err_create_fdls_frame_recv_cache;
 	}

---
base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
change-id: 20261114-fnic-typo-7449d2e4494a

Best regards,
--  
Izaac Chong <izaacchong934@gmail.com>


