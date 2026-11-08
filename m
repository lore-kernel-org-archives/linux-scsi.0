Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794128490;
	b=Jp85bq/zqIuaCJsaMqWNuRQTHQ33EwOnzqko59pPxb6JsooaVLJ9H67bejKGjJwDc+Rv
	 IIQg7UXHS/D223QWbUcTESuR+8kfLf0aq07NC5Dq89pUNBXjPLI8naTNVIQABkk5jdg8z
	 T/fTyKwdCbVtNjkkP/gR1VhR1PYJdwgjLt7HlYOXnhynRwpMifnUpN3e0C595Qc6aDF8V
	 J1OwBkotCCIWW2oXMT7WUbMJiYFOzzDLt+r0IGa7usLjcc/ksdPXJ3CGsxAgWCwsr2Cl6
	 yw45Ad8U/WxqDhpyUWDBuk0oepmMoiJnNDIwu3AOBtfH51wjnPnXd5CSqKcbx0HZJNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794128490;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GpRg0VY2yJJLJAO/hhT5l5/PBAi7YUoiPdqyzPaVAWE=;
	b=KBAEaSjmxw4UMUrbVv+Vc2khPa0SJaTbCZI9ev2d/E4Cy/Fz/QftTa24ZLpt4a8qEiwH
	 DC3KXUhE2dwauEjXGMS5oHOscrOSv9Da1iksFPl3C/KiTOOHfp8etpXNjzxYoO3oMNi//
	 s8aU6q1uE0WZCojTqbFQP09a075cjt5B5jNpwTa2QLlw8AWPkKvuypkJGAxPjJzBtX6t3
	 +Un5LFF1HpEHKqItPolqE9XiO+KPR5tbAdbXoOfoN0jCPzk59SBGJc0+V1KVbXAanCjTU
	 jHSDE4quo+ehdd3xEMcdkXMx5zvAhWQpWMIlumlt05/Nkr5N+KosQvac3gU0iC+MGKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="k/zMcDFa";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E93E606A320;
	Sun,  8 Nov 2026 09:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k/zMcDFa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794128489;
	b=mQuTy7BYlghJ4xYVljfVdwDDF/yJPgfLkhDGElto1JnXhUU01/tiE+ljeuE4bkkQjlby
	 GpGguOqq3hkE6ijSrVo/P4eKGHt8TDsWx0nxwObkzPkbUZVGDoUzkAZb49uIajumAQ8l2
	 IHOniExmhHGvRjWmisKnD+c9td1+koNkq85yVO4l9ZKtTLZtXTxyxNkidBBNTVTuXvdtP
	 JAcz4di3QT+I+7ugdC5Gp6HiDbNF4LcnLaZIHz4jzuJD+BV/2nJBbw8fGxOtLS/ixIXhg
	 aNpz2BiTvDk2uicDdCJCJsZ6JkdvLljl5gFOxwTGFkygivwbqzdrk6fUWsE4FBgVFmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794128489;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GpRg0VY2yJJLJAO/hhT5l5/PBAi7YUoiPdqyzPaVAWE=;
	b=dlapjvgQ+Mae6G5M+0oR33ef759lyoGpoBvPOgY/xGcYgi0L9B8YDV0uT6dmDrniEg9t
	 fHbbZqAyaiTz5qQC3tipKIoqvR3lJ7zyam2x+AhGz1eEvEMSvMoPhBBePp19wpoMrxbTT
	 N17M4K4qMd2zPUWoKHhnaiYjnxWZzOGt/Fgt/TqHOPgBLYyV/4iI392G7w65IMNyjULkW
	 9m9z7Zj5n2ScZu5SIqemW+yCjBVyQj9ZMulDhDebsTOuOeimcBTCsgH0ZUNs1sOFF+xMD
	 MsfPY3lcuoTzonIntEs49n1EZs5/6RVUbn1f+QsAOVIdmt64MwrAcT7Ph+KdfexieUw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4B2AB1F008A1;
	Sun,  8 Nov 2026 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128489;
	bh=GpRg0VY2yJJLJAO/hhT5l5/PBAi7YUoiPdqyzPaVAWE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=k/zMcDFasnTEINl1VjKcWEMRTjm5Jh0P8/CRIXuf6jX3TzWaTmApeW48wuXKXGST3
	 IcqcpL3PBc1lm7Fc9Y88opbh0aMS2jXZwyCjwuLXtALsJZ08bMl4rAgH32EeCuB4aV
	 lLgVRiZW7taoWoTVjdylaaUnceNwBm7BtnQeFqG6kZe3AHY18VNXOD9i69J3a+O0G1
	 E/RHmO4pUKfsvlZVakRNhsCpXH3gV6iBzV8LVjQ5iqWHzHF8xHZZLg707jrzZzhYJ6
	 7sv/gs0U9Zr1S0MYqVVdoBJTnrbDL2ORmG8MK+sxKRmlJ64EoeqLwgBFWbCWp8uhnq
	 x8hm23wspqq1A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9C70047E8B;
	Sun,  8 Nov 2026 09:01:28 +0000 (UTC)
From: Weidong Wang via B4 Relay <devnull+weidongw.illinois.edu@kernel.org>
Date: Sun, 08 Nov 2026 03:01:08 -0600
Subject: [PATCH] scsi: libfc: Fix rport kref leak in fc_rport_enter_ready()
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
Message-Id: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
X-B4-Tracking: v=1; b=H4sIAFQ68GoC/yXMTQ5AMBBA4avIrDVpK62fq4gFNRiLkg4iEXdXL
 L/k5V3AGAgZquSCgAcxLT5CpQm4qfUjCuqjQUttlZKFmJTOBKPvRa6zFjtjjLQlxH4NOND5ver
 mN+/djG57B3DfD6dLQpptAAAA
X-Change-ID: 20261108-h123-send-723aeb555069
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Weidong Wang <weidongw@illinois.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794128488; l=3067;
 i=weidongw@illinois.edu; s=20261108; h=from:subject:message-id;
 bh=xRn4o4Xo2uz0/atqmK0OD/T0n88c9mKnmN8e3Rc+YrY=;
 b=ngBmio2Hk2lkCkJjxTpsOfHS9AbXORBCnJtDD9yLk5LY7hbmvytIqliR2ttZ/XpS895htJMUv
 dse4I3xbIYjAOwbCFYb3gErrliNJKx5rQ1Es4Ysza6RL/Hu/WnCgjLQ
X-Developer-Key: i=weidongw@illinois.edu; a=ed25519;
 pk=DR2S1xPEa5sELrWPfOpvUphJQ2VHC+MDc/wJavE/ifg=
X-Endpoint-Received: by B4 Relay for weidongw@illinois.edu/20261108 with
 auth_id=1449
X-Original-From: Weidong Wang <weidongw@illinois.edu>
Reply-To: weidongw@illinois.edu
Content-Transfer-Encoding: 7bit

From: Weidong Wang <weidongw@illinois.edu>

fc_rport_enter_ready() takes a reference on the rport unconditionally,
but only queues event_work, whose handler drops that reference, when no
event is pending. If rdata->event is already set, the && short-circuits
past both queue_work() and the compensating kref_put(), so the reference
is leaked and the fc_rport_priv is never freed.

This is reachable from the wire: a PLOGI from a well-known address goes
straight to fc_rport_enter_ready(), and a second PLOGI for the same
S_ID while RPORT_EV_READY is still pending enters it again. After the
rport is logged out, kmemleak reports:

  unreferenced object 0xffff888... (size 512):
  backtrace:
    __kmalloc_noprof
    fc_rport_create
    fc_rport_recv_req
    fc_lport_recv_els_req
    fc_lport_recv
    fcoe_receive_work

Commit 823a65409c89 ("scsi: libfc: Skip additional kref updating work
event") fixed the same pattern in fc_rport_enter_delete(). Do the same
here: only take the reference when no event is pending, i.e. when the
work is actually going to be queued.

The issue was found with an LLM-based bug-finding tool; the reproducer,
fix and changelog were drafted with AI assistance (Claude), then
reviewed and tested by the submitter.

Fixes: 4d2095cc42a2 ("scsi: libfc: Revisit kref handling")
Cc: stable@vger.kernel.org
Signed-off-by: Weidong Wang <weidongw@illinois.edu>
---
Tested on v7.4-rc1 (05441d697f7f), x86_64, KASAN + kmemleak, QEMU/KVM.
Reproducer: software FCoE instance on lo; raw FCoE ELS frames injected
with AF_PACKET (PLOGI from well-known S_IDs 0xfffc01.., a second PLOGI
for the same S_ID while RPORT_EV_READY is pending, then LOGO), 120 rports.

                   2nd enter_ready with    kmemleak unreferenced
                   event pending           fc_rport_priv (512 B)
  unpatched        116                     99
  patched          104                     0

READY/delete work events are processed the same with and without the
patch; no KASAN/UBSAN/WARN splats. checkpatch clean, no new W=1 warnings.
The reproducer can be shared on request.
---
 drivers/scsi/libfc/fc_rport.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c25979d96..7b0938544 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -550,10 +550,11 @@ static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 
 	FC_RPORT_DBG(rdata, "Port is Ready\n");
 
-	kref_get(&rdata->kref);
-	if (rdata->event == RPORT_EV_NONE &&
-	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, fc_rport_destroy);
+	if (rdata->event == RPORT_EV_NONE) {
+		kref_get(&rdata->kref);
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = RPORT_EV_READY;
 }

---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261108-h123-send-723aeb555069

Best regards,
--  
Weidong Wang <weidongw@illinois.edu>


