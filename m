Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094234;
	b=1J+r09XYk5w9al3TEAHZr26rD6Vm4SqDUX+wX8Mk9PkpgsZRY11ud+x3nRVbB22/lZP6
	 3zRLlWgtlcZHXpX9pFfYbEHN+XLlALkixg95xQ/di2TJ2YETIHikmImF1saKfdcd+AGy2
	 rNqtqDny7jUhnl/EnPSbDjbcAtCV7IyyVHPLnN3gK9e34Q4jH9Re0tL5Z6hkNN5gjm/FS
	 oWJdNIfyOfI9vgFOIj48TxZCEEJJeCvxIpqq8cWigfQPD+hY939NekE/a78V0YqE+TT3n
	 geDZUTICVtqcAq7YO3tJKsTHxCrhizWNezOzIBXvpARC6TWI/cbPKtWxttlzdR33f4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094234;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L4E3XRP64cRcg2qhwnD/p3VNtz1wiNwPHBJ/utwvJVo=;
	b=PPUGfr1GP1/rC+63z9/XKqk9y3rVbP8YR7jhnQ7HFVGipSoT8+3Don4zehNy7gI0mJgu
	 RFlW+VArcMXAANyoM2Z6k/kRJPCqjQwP2Nw2cKFirPgR3jHEfGp88JZfxs7Icz39I6+uj
	 SN3VI+0TaUs1fc7pwP8+vBgYHc7KO+fdCAdk9jtajnCwYnPuyjP/n/VOf7pJY0aLZ2/UU
	 8iPGKbFvlq72HdYuvPVm12z3IYMnp/lQw2sp/14vIUJVD9kUIAywyQeOv2uutxgaeFgf2
	 a8OsD5XzIp3BxI4Q/w+MoQD2G/+tzcQNZdmJCYZpwfZtR3T6BYBwvnp1/FlZ7v/9h0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mfaF+RhV;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473B7606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 13:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 473B7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mfaF+RhV
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a05b210703so1275909b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 05:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094232; x=1795699032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L4E3XRP64cRcg2qhwnD/p3VNtz1wiNwPHBJ/utwvJVo=;
        b=mfaF+RhVNLCmGyPAQrRmfCi5qQBk1BaBMHoIYOtwU5J2gBn6VuxzPHneB2WUiGf1Tz
         PWC6V/su9l5fONkjmLnBlo+nNekwTWOVsHUEyVQfXS4pNz044toX35uj0xg1prBfCUR6
         N4zV/1HGN/X8zJ+5yAaI3RY7awvHgx0zexu0j7z6fH6w5u60QP6ROsFjY6XHUueKmyWy
         WytUKeFAIatM6QkLFjAh3hAbiLxMm0o5RMtXEI07DoYTXXjA8oybeyr3bmkUPVIPrQAU
         ulfyB5uahgeEfaiujqv2NIYZPSbKnH86gMW8y3jZdcgNGVGIKG5029rDLl7N56diRNz4
         WeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094232; x=1795699032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L4E3XRP64cRcg2qhwnD/p3VNtz1wiNwPHBJ/utwvJVo=;
        b=UiD4RyoSg8VJupkmhUY0Gr6E5wdZ1Cugd6ZaYcNtvhKDk/NU0W82qMabfn4HuJjOrp
         p3Fb5PdrpJyr8BZJPnw1Qpc/9ulWoW2HwRnXjnwWUQiFsHO7RfW7+/4t12uKVspksJqJ
         MhQ2dOo4vRzdEqFY1oiytER6ctsUG/7E32kWzU3D01Vg07tqigzvw7654Zm62mmFS8LJ
         RgfIZ5Pk3j+06NSQxQO4bmPiVOgkV4FsgkuuIuSZddn9arfjHUcDklB958luYGerX0Zt
         QHYXTYT1Q0no7SKtG4Y+uC+8r7LK5e0x/STvhN5/M3NKLTPvGenpv3SrW2DZfhHcsc01
         pkzw==
X-Forwarded-Encrypted: i=1; AL+hErFJIIQtPvGcuBol7cMkt/yCrzNYFzGf/EIdmt2ArE/ChVf60sln3ikQJYo6arBSqbNfSoNNsYwLWu7j@vger.kernel.org
X-Gm-Message-State: APuU4Z9L+a7/eyZAGTgZHGC9ffIdklIShmMErv4mkGzwqbAL+zOEwEWK
	yj3KNovuPzw5t2Z4W2QYWKOLdnseTekI/ScpbR+rGtJeo4UMV5F97+nInon3fz5lGzU=
X-Gm-Gg: AYBFou3gVxuIp4cU/m2POHKyVH8ETb+B/bW6FOagREyQv1JfEn9HEnnL0udDsW2Fu2F
	TCiMcJdmTaSkN8sezXCJdqcxRAKIPFNbxigJROxqijXOcLvNiUDKY/HtaenTPhuknfOHyI5Y9Sn
	Pjt7jK+9vpXHRH5vAW7rzGkfHEN8+NM7fZvB9nOXOcEOyMivWdFXs1+Gloj+mhS0hnQcGi9Y7rG
	wEMKl4q6ashl3GXGRkWrRl/DxJbJpfuRJzqMD7qBtaZoE9ieMeep8HAxCNvCDW81KURgbIe22/K
	h/QuF1pJwT2CZzGIlWmwsyzzFWufaje2j838lJXOY/oB1scrK9rQuelaC8PM4qtAaj6feA346Cx
	CUuGt6CvnICP68+3Ds0hLSdU6kIVtcR+84vL62i6PxzmS6VJeYLLSHOr4/+Yc1+ePkhcwt/KsyF
	IDD81IQ0pjOcRNl0srrTmgvlIcMMytEYX/aC8xhDlBNkx2gXapCXylPq6Zf+8zT2xq+0A1C6tsw
	cZuFnbJqHFf0BkbanVvT7obLW1uBH1/QgtM5sXrKiC/N19j68rCY5TY+hNfXPkmr119/nuuOP5s
	RvX0I//s2P8Pg9T5cXorU1BMFXwL4a+dXpCVJqd7BOOeuWB3JVAaRoAw2tJX8JNK3L15vwe1LIf
	aeCEChmuUsTPOMkOaIepGlDKLsCadEBTjaj06OD8sK6y/TNrK5gX3SYQzd8g=
X-Received: by 2002:a05:6a21:66c6:b0:3e2:acd2:b94 with SMTP id adf61e73a8af0-3fe97bf5bdcmr1281756637.35.1795094232170;
        Thu, 19 Nov 2026 05:17:12 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:11 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 22:16:56 +0900
Message-ID: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
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

Link: https://lore.kernel.org/all/20261118211503.2526705-1-yhlee@isslab.korea.ac.kr/ (v3)
Link: https://lore.kernel.org/all/20261118113905.2361969-1-yhlee@isslab.korea.ac.kr/ (v2)
Link: https://lore.kernel.org/all/20261116101108.1650132-1-yhlee@isslab.korea.ac.kr/ (v1)

Changes since v3: 1/4 is replaced again.  The review of v3 1/4 is right.
iscsit_add_nopin() publishes the command before it queues the send and the
tags are sequential, so a guessed answer can arrive while the NOP-In is
still only queued; the lookup then queues ISTATE_REMOVE ahead of the send
and the tx thread sends from a command it has freed, and clearing the tag
before the header is built would also put 0xFFFFFFFF on the wire.  That
window is in the base tree too.  1/4 now marks the command with
ISTATE_SENT_NOPIN_WANT_RESPONSE under cmd_lock, after
iscsit_build_nopin_rsp() and before the PDU can reach the wire, and
requires that mark.  2/4 to 4/4 are unchanged.

Answering the review of v1 1/2 needs two target-core patches, so there are
four.  1/4 and 2/4 are drivers/target/iscsi, 3/4 and 4/4 are
drivers/infiniband/ulp/isert, and 3/4 depends on 1/4: it lets a Reject the
core allocated reach the wire, which without 1/4 is a double free.

1/4 is not about iSER.  iscsit_find_cmd_from_ttt() matches on
targ_xfer_tag alone and leaves the command on conn_cmd_list, so a NOP-Out
with a reserved ITT and TTT 0 is given the Reject the core allocated, and
a second with the same TTT is given a NOP-In again - both double release.

2/4 keeps the unsolicited NOP-In off iSER.  The transport check in
iscsi_post_login_start_timers() runs once, at login, while
iscsit_process_nop_out() and iscsit_na_nopin_timeout() arm the timer again
later, so it moves into __iscsit_start_nopin_timer(), which all three go
through; isert releases such a command on its Send completion.

3/4 is v1's 1/2 with the fix generalised.  struct isert_cmd is all zero for
a command the core allocated, so the back pointers are filled in where the
core hands one over, in isert_immediate_queue() and isert_response_queue().

4/4 is v1's 2/2, unchanged.

Measured with KASAN, one fresh boot per cell, arms alternating.  On an iSER
portal over soft-RoCE, 3 boots per cell on the finished series and 2 on the
stages; the base column is the v3 round, whose binary is unchanged:

                                 base    1/4     1-2/4   1-4/4
  Reject + NOP-Out, TTT 0        Oops    Oops    Oops    clean
  the same two PDUs paced        Oops    Oops    Oops    clean
  nopin_timeout 0 then 3         Oops     -       -      clean
  200 Data-Outs, nonexistent ITT 128      -       -      200
  one Data-Out over TRDSL        Oops     -       -      clean
  login/WRITE/READ/logout         -       -       -      10/10

Where a cell oopsed, the reports that follow come from the teardown of the
killed thread and are the same set at base.  All 18 are clean on 1-4/4.

On plain iscsi_tcp, base against the whole series, 5 cells for the first
row and 3 for the others: two NOP-Outs answering one real NOP-In are both
taken on base and the second refused with the series; 20 Data-Out and
NOP-Out(TTT 0) pairs in one write give 20 KASAN reports per cell on base
and 0 with the series; a legitimate answer still works on both.  With the
add_nopin() window widened by a test-only delay, a guessed answer is taken
in 17 of 17 attempts on base and refused in 19 of 19 with 1/4.

Yehyeong Lee (4):
  scsi: target: iscsi: retire an unsolicited NOP-In only once
  scsi: target: iscsi: do not arm the nopin timer on an iSER connection
  IB/isert: finish a Reject the target core allocated itself
  IB/isert: do not leak the receive descriptor of a dropped Data-Out

 drivers/infiniband/ulp/isert/ib_isert.c   | 41 ++++++++++++-----
 drivers/target/iscsi/iscsi_target.c       | 54 ++++++++++++++++++++---
 drivers/target/iscsi/iscsi_target_login.c |  5 ---
 drivers/target/iscsi/iscsi_target_util.c  | 10 +++++
 4 files changed, 88 insertions(+), 22 deletions(-)

-- 
2.43.0

