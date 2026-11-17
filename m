Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910512;
	b=2Id0uvCsbVzBfvkjgO0xoOJckwh+URDkDYGIdpc/heS5NORjqJjjh5+DgafJybU0uDql
	 zmdLOG9cbKrcDBAlYMUiH1L6J/my6933R8On4uEe9UEFydjh1fV0IqR4WD74zeqacqx9Y
	 VeXsUDbKFkJtoDc9enAxb0lCVSPbiW4jsEKrc+6Pu7LJ+SCM5a8lPZiQldJX41n5B6lAO
	 ArqsTUsOJfHRymWePO3oS6ga5LjNMQ/875vE52t5+ziFTiO5i4ijiFFZG5hMP1c4JKf/v
	 7anJJ+quwjStF6zc4Ut5Zymm38r4Vd4GEqEA68PcRVYkcd9qcAdgsbyIasyWAe5yYlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hIRaxxo4elhQ/z0xroM1fiMsS70aRe7w7f8k/jc1eTg=;
	b=4sXpLwViBnhXGc9givqfCSgjtfFD8ETABjUDFXSw2Gbho5N/orpMYQqbGqzkjy9NUprW
	 NlDTMTCjGk/pMjc91nDLqB/bf5kJS4zUK7EUZgYnbdBH/FMEYeiOvLYSb5jkrABPdisHx
	 sG4Gbkh4m1y+mTIqDSqk128vkj82/G2f6ISRwGZsSvvoh1Ct0uhaVBSuFA7+7CqqbdU8S
	 hH1Qa2QYeJyFf0l3FxVKMTaJhBkHimFYpM92cSTVbLlzRWRv8beA6jMyhNQ5caEaiHArr
	 A+Nq3dppX2ObUKyw7SWSdyv9niE5cmTbyEmD9JN7s3IDQP54QIv7nuBLwI+SzFncjCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZSRbgBbL;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF1606A334
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FFF1606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZSRbgBbL
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b3b4944abeso1705570c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794910509; x=1795515309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hIRaxxo4elhQ/z0xroM1fiMsS70aRe7w7f8k/jc1eTg=;
        b=ZSRbgBbLh9xlpv74RLRKRVOgeWV6gTyyUx18BJTQuUQUfpesN6GoQmLLAGmz97x9zz
         QXc1LAZjemPTTZauTzxRMXBE7PVe+IfBDE7zF4vzb0C/RSRIwQW21Ne0DpJp0Xs+03Ws
         UHI/IZU62eCIpvWofst2/GDuMRbbESXE+KxXIzAAStojm1UrNmbuwFuTCq6y/ah4S/mx
         3h/idv0+hrsqhIwRtIq5hgiDuJDiE1WrbDlbQS9Eem4YJAAG2Hxco2LPHEVH20/sPgsL
         zWd6DiXWlpzkrDqXnZNUNwrGYfX6XAhahof6Knv0ZX5PO9Kvtj25sUcQiE3Rq0DlXTc/
         rruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910509; x=1795515309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hIRaxxo4elhQ/z0xroM1fiMsS70aRe7w7f8k/jc1eTg=;
        b=ynmgwY7ruvHgcIiHbiZJPEQ9KK31l5FQbIg2k3ooiY8lsMVLKMtDeSnmtprJQcrR4e
         TER6zdmyQcrjIou3+vAmchK1bzy9jHkrlwVJ26JKjlP1EmxOv5sEJsoaRS0/ZuXoX/wQ
         ZCCaTo4pKv2d81ZfGR2JMBRAWDePeGOrnWrN+5QxA0gqC+KOM36q+EZic/VZP4WsMIKU
         xfFi2PCD/GQC8pcEwrNkkHrdv0/Msu3SjqNxbLR2zC3JVyxXcPcdhNeuCWiom15D4enq
         dk3luBu3D1Lbrj27QocjGs5m0VhSCxhJ7bBhzHEMQmCfk0gZf2YSNuWEP40wRg5qRBLs
         uLYA==
X-Gm-Message-State: APuU4Z9i5DeaxUYIZetNaVSv2brMgLfPrBWoMYv4ud/SeSUETtcq6mvE
	Dm5qMJt+rBufEuXnutxciqm9oluFBGvJZgFQLDYhU6C9SjMqhCkeVjtrWDH7p4EAikU=
X-Gm-Gg: AYBFou2oYyyFuS52ROAby2nHNhdiINVfzRTa3xB6PEAek6Jfcy4T94aoFddAGcUnUuk
	4GgGv5IMB0bbRHwEcSJlApYhtRTB/Y1D6ZzatIAuOVpVI/ExFw6ZZT3m7Ww/Q3CHRaPfXdyuZJ3
	ohKnWVgALXPhmPmZKbRjj/fYLzYlghNIBWlCZaCO9NS3Zm0AnEgaaN6t0t+kg0ySxRMaGwb+2Ca
	ajJdjXWn1hYy78y6GbouAQHbW+1OTmjVObnVw87ZJORTCybKdPF3SyGnvI/iQIvEF5tkOrK6kxa
	YsZjtlekfQ9AYUlT0IbfiGQYiiFpAXADrP8URmiq3guCJff2gGh0rMWNg/22VdwUUHuteD/4BwH
	akWvqG1krxP2Coqjx4txBfUfkgGaJRoHyRVspCnYvFk64Y94sFpaVklrY1UhyTliAsl0wMubBfh
	j4/+A0p0BPpursj2lTZ2QyBE1BEi8PvjuelHbWMPUvmB6GxL2M2ugnot2OWyW1NlJtug5vKQCVa
	PvfkskZibKL3yJdAoRxDRnyRHSgl5XciIQuAG90E7gd4jDgoBoVkctNaYzyICdWGdH1nJSRKOJn
	Nkgz2OAZLRb1gaSO3zvHYBmMNAIyxLdOgRXeUZdUw1Wz0KbaIt4+mT/D+rY94jNfc0tJDZpC17E
	2E6laAR7yCoheEZBZxaQJt10bHqe4Z8PVxZ0ftw==
X-Received: by 2002:a05:701b:4651:20b0:14c:8461:b3ef with SMTP id a92af1059eb24-1b50310039amr12607345c88.24.1794910509130;
        Tue, 17 Nov 2026 02:15:09 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:cd44:de10:449c:756c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e008sm39965539c88.6.2026.11.17.02.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:15:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] scsi: libiscsi: tighten task completion
Date: Tue, 17 Nov 2026 19:14:56 +0900
Message-ID: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
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

1/4 stops the receive path from completing a management task that is still
queued or still being filled in, so a slot cannot be returned to the task
pool while the transmit path still owns it.  2/4 stops it from completing a
NOP-Out sent with RESERVED_ITT, whose single reference belongs to the
transport, so that reference cannot be dropped twice.  3/4 makes the
transmit path hold a reference before it publishes the state the other two
test, and makes the SCSI command lookup honour that state at all.  4/4
stops the receive path copying a Data-In into a command that has been
handed back.

v3 -> v4:
 - 1/4 and 2/4 are unchanged.
 - 4/4 is new.
 - 3/4 drops the two hunks that kept iscsi_xmit_task() from handing a task
   to the transport once the receive path had completed it: the early
   return in the conn->task branch, and the ISCSI_TASK_RUNNING test around
   storing the task in conn->task.  Both release the last reference to a
   task whose PDU the transport has only half sent, and for iscsi_tcp
   tcp_sw_conn->out.segment then still points into the sg list that
   scsi_done() has handed back, which the next task's
   iscsi_tcp_task_xmit() flushes first.  Mainline holds the task until the
   transport reports the PDU done, and 3/4 now leaves that alone.  The
   second hunk also re-added the test that commit 533ac412fdb4 ("scsi:
   iscsi: Remove unneeded task state check") removed, so that Fixes tag
   goes with it.
 - 3/4's SCSI lookup refuses ISCSI_TASK_FREE as well as
   ISCSI_TASK_PENDING, because iscsi_alloc_task() stores the state before
   ->sc and under frwd_lock only, so a slot being handed out can be seen
   with its new ->sc and the state it was freed with.
 - 3/4's changelog follows.

One older problem is left alone, because it is not a completion condition.
iscsi_xmit_task() still sends one Data-Out for a command the target has
answered, from conn->task and from conn->requeue alike; nothing is freed
there, because the reference is taken before the queue's one is dropped,
and skipping the send is what the two dropped hunks show to be unsafe.

3/4 needs 1/4 underneath, and is marked for stable for the same reason.
4/4 is independent of the first three.

v1 of 1/4:
  https://lore.kernel.org/all/20261113145140.282504-1-yhlee@isslab.korea.ac.kr/
v1 of 2/4:
  https://lore.kernel.org/all/20261113232322.395246-1-yhlee@isslab.korea.ac.kr/
v2:
  https://lore.kernel.org/all/20261113233938.397415-1-yhlee@isslab.korea.ac.kr/
v3:
  https://lore.kernel.org/all/20261115122122.1446791-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee

Yehyeong Lee (4):
  scsi: libiscsi: only complete a task that has been sent
  scsi: libiscsi: do not complete a task sent with a reserved ITT
  scsi: libiscsi: take a transmit reference before a task is published
  scsi: libiscsi_tcp: do not accept a Data-In for a finished command

 drivers/scsi/libiscsi.c     | 56 +++++++++++++++++++++++++++++++------
 drivers/scsi/libiscsi_tcp.c |  3 +-
 2 files changed, 50 insertions(+), 9 deletions(-)


base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
-- 
2.43.0

