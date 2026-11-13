Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613190;
	b=yngVcGCa3Dd0T/4gia4B58Qwr2BtCPDvsQLUSPXt80N+WtuV3uztEUG/FOVVbX+cK9rT
	 E9BMETFmH7IfrGbQk+5b2odTcuqALStGD6A9rcjRFtiznvP4t0SkGx8szj7Z61YQ+gNJr
	 /1lvsk4ePRLqJ3l/SMG5frBJWYCjI+5ZeMRH8ajEOY4TtxEMjBY+6FD5JceJeXzerFCOK
	 fq69P07wcgdm4dtxpTAm3/OWLd5cTtVjj9uFng8JvWAyzbHYQk5wQjHxvKQEaMP5CqLFI
	 CsTIcZg31r+UcZ0IIRhrzZo0CwnsVJCtL9W8zn+6a8rqmpuottqoD7LuBTxUCRLWx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=GwKH1HHqdkQ7zt/Ah5+Ef0sT/6ecww8p/cC3kM3Mwew=;
	b=QmaSHINGvTjye8t2K58f5ofZCZ/e6VZK03OKehnHXiAxpmnDLk2I7mzd7sruUDf1v1qu
	 Ob2qG5Rdmt1rdrh33TaQ+VwX2Rqqs7G+CRaHFMUSBKFNGOL8en+hUOjBKH4zEnRtAUiju
	 CxOHVFJeRRzZCHYOinM1Dc+OgBRpSmlTiQnpmJQwhfrgWG5Lixm2rapz3KcL8IhW9pzVK
	 mpVN98Qy14dkBSP24FbbDKnXE59fGQoIp6+dLiRmecpo0Ug0koSPcch+Ghx2Ne1S79qHV
	 RlJoahYQRWG604Ezjv40OAXr1OM9Dr0B5JOELWoX4jfCxEkXVq4J1VejfJ66kzNFQHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=s8OXfRrL;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBDC606A337
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BBDC606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=s8OXfRrL
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so849135a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794613189; x=1795217989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GwKH1HHqdkQ7zt/Ah5+Ef0sT/6ecww8p/cC3kM3Mwew=;
        b=s8OXfRrL1L1xiJZcVdzuZEh8D9oRw8Av2IQr6sMv74zDxldJ2jLVpc4iusN47Q7Rxu
         ATRyJBegvQ3fANP9vMwtdSF8FjyJQFaxgfWaULVq/MVh1yuK3AWi0rkx9SMCupiDJltz
         ZmIRkYpzDYAHf9qXtSdG1UvTKm+Vl3kXv0QY8qWEYp0a1hNKbf44JegHvr5CnxM6QH7t
         zk4klXgbl4j/fDlQV5UD9W/NWRB1dCa7Xk5HtW7bwoOLDZ+ZRrvpuh+EV03WBACcsLXy
         KBXIR7lX8MdRc3BKjafGVGdOc+wZS9FR6UhalrUDixRTCpCqGHiUzNjw9mfZrktvlegJ
         ra4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613189; x=1795217989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GwKH1HHqdkQ7zt/Ah5+Ef0sT/6ecww8p/cC3kM3Mwew=;
        b=gmNDjtxqVfYPtmCscWO12p8T+mNXqAWTTGFFlWYzzv1u5VK7B0aEm7rOP0FKioN5Qn
         VFMf6mJ38eiJWsC0QTBdFpwBGibsX0nsj3mlEs1JHkHwwxlG/Z8mx2ex5hktGSFY4VO9
         dsU1RdatEhf/vNy2X/J1/HefMMh3GYHMHXsvK4QJivxDtSqJrf0Jjk2LlZED3xIMfafE
         yQ1Y7Q+4bpd58XUGh4Z/OeqGeGZK20+rc5DvLTY5sc5EcbExhWrJJbMYr8eUIFj3ZUvG
         bdhcrT0EdPDKyeA8XunRtVeNq5hpHLR8aUY0LdSRCA6EMiKbczTkMpdsonaI5q6Ii3wv
         cODQ==
X-Gm-Message-State: APuU4Z9lqg1SrIIKWVZxkazNko22WfpxOkCx1FL655NG1J52R42gP8dM
	g8JExoWHCzsR3Df9VDTrWUJbn6KFsUVYp9raL1nmxhLQxVchY8Q160kC1iM1uLsLz0s=
X-Gm-Gg: AYBFou3x6gJVcX/Nhl7ePgiP1GeEpfcGubXZEo1urzp/J2QL6RrbjtmXba87De+2RXs
	62ce2TxIcBJNx5nSAkJ5k/WSu5Y6aHgynpI/5WgBYF8duUVgfi7aYlMsqfdF9pl39D09tdlL/bO
	j01RL80iIF59C4vKx5aLRabhEwb/zO1RpFobZX2eiZ8r5QGepX344R+iJw4Vvl6TfhW5MrtgWR3
	+5oYjkp7wWYUsk9MjuowoSvcAcS4HnNqRsz06OrPVNThx1ZUwZ43n+iBYWbfPC9bQROWg8Az99p
	+vc2IjO7ayNckMVlz3it+VK/yeUj/VulV/opLd6d8KTe5l4Jh7UyuTfnljFVJ0gsVTxfYjR5bHp
	jl3B3jn7R8wyPAqqRyNNkc1y5jZdKZzYveFjrvxJbKl00V77M+lguR22DbTKExMRecOwf0UyAUl
	qlPA4tE6XRKPg0bYjHFJaPAGmUEvKFAcekXtYUBPv9aCkAkfQfXoary9kgqSIN6f7uKamHY9MLF
	1pVs/zLNmNZS1+2c8akxwCkhcMBQDUrj3zGqqpqBTBKQbTba1U/oe/Wq2h+D2Gu0Ti78DcKbwGG
	8ZCgsYD+YZbw61W9DuEtyI0d9CgPf/lPOEPXjojRfYPFyMCiM5+gGDocTTf/CgHvtSl1CW+RoMQ
	F2AWVpxJe3WF1Uevhdy7VWqqYhPqcQavmS3pvfg==
X-Received: by 2002:a17:90b:17d1:b0:3ac:9a5e:9ce9 with SMTP id 98e67ed59e1d1-3b1b0a3b41cmr4034654a91.29.1794613188872;
        Fri, 13 Nov 2026 15:39:48 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm6442462a91.7.2026.11.13.15.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:39:48 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: libiscsi: tighten management task completion
Date: Sat, 14 Nov 2026 08:39:36 +0900
Message-ID: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

1/2 stops the receive path from completing a management task that is still
queued or still being filled in, so a slot cannot be returned to the task
pool while the transmit path still owns it.  2/2 stops it from completing a
NOP-Out sent with RESERVED_ITT, whose single reference belongs to the
transport, so that reference cannot be dropped twice.

v2: no code change.  v1 of 2/2 was sent on its own but depends on 1/2, so
it did not apply; both are now in one series.

v1 of 1/2:
  https://lore.kernel.org/all/20261113145140.282504-1-yhlee@isslab.korea.ac.kr/
v1 of 2/2:
  https://lore.kernel.org/all/20261113232322.395246-1-yhlee@isslab.korea.ac.kr/

The review of 1/2 raised two issues: 2/2 fixes the second one, and the
first - the window between the state store in iscsi_prep_mgmt_task() and
iscsi_get_task() in iscsi_xmit_task() - is not addressed here.

Best regards,
Yehyeong Lee

Yehyeong Lee (2):
  scsi: libiscsi: only complete a task that has been sent
  scsi: libiscsi: do not complete a task sent with a reserved ITT

 drivers/scsi/libiscsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)


base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
-- 
2.43.0

