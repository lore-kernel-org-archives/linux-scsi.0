Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745297;
	b=aBa/QTWXzj/el/H/sIirPavxcRbbXExIcerUTZTPPqF2JOzBNSQF7TfupUkqrQW/obP2
	 oxmTCKWMZb1tUSDkrzrHC2jb+Hq0THM/NxtjyzOtSG+dhva9OtjpgviWB8PHiX9GQ/a06
	 gmK+VUGT6tpLbntyTJuu7+7wo3jb7BNbPneW9YjXs0u7Jm97uvJmjPb0zeKkJZuGKWXEP
	 000QfVfbPp4cRW4oPS5OtToditwsGKnVUSmC8N3XTQPb8C9pttU3/ST13n7bS+tva2CSu
	 Xyn0FejydcM6o3S3Wry820vTsBDNDEuqi+08h3xFj2FZQ5THfXbOJrXOZqQvGGf42Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=JHGMhIDfe6WAYWe+FkSfHWLhXPJoptf+ba9HCbYyk88=;
	b=CdK/yrw3QlpOLrY8V83ljMxYj9nEp6wngX4LWa5ADckfU9uMG2seYv79RB/gaGrwzNJk
	 FpdLLKio2fWCcuZAJIAoVj6U/hjKR2WdSifKLeair4q8KKKzo7DV4123QBehLqQJsVJRx
	 xKmdijNjWtvjdWh3g726deWeqwI4K+a7mi1uBuxUWB6pnxKLPekH3MroOIMNZsGhHl41K
	 WA9u8bDZ7ixUSCyeD4elKBXv3jb2oXNCCB7MVZOR/F4Ujvq5Wx6r9LGkKGytXxNib4Fwz
	 fhciwcDNLNDJ7EJGrax04OsVl2sQgjV6WEjo7DroRIIkcixNIzG5QhjI3bjdCmCeZJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SuHcITR3;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2590606A31E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2590606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SuHcITR3
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a070781f63so873078b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745296; x=1795350096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JHGMhIDfe6WAYWe+FkSfHWLhXPJoptf+ba9HCbYyk88=;
        b=SuHcITR3zO9FUe5aWO6oSCNsm2i3GomzfbwB6DUi87XOEJBcUlS9GEnmpssphplHm3
         BCAzqapGelNdJVylbZf6VUsSrS/gePn7mLuER7LEyQNN92UEcZOVY0c0ZPbzpS43yKQQ
         N+qslmv+yfu7ppoz1WtFraMIlOSPhuujaadB3bbNDfQ2ebiSk8A/q0mK8OMEuE8NrB4z
         XCNW3mcUr0NDRhkcjecgS+vRsKsVlZK0AX1eZeyVs6R8h8BAgyJZDpgKZLIx7ylYQ523
         ZcsrMP33BCfclAnxwhgAG4CvI/kJfS4ol7hHebRpjij0MuFxxuPSBrMQRE5QUZZglZHm
         evJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745296; x=1795350096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JHGMhIDfe6WAYWe+FkSfHWLhXPJoptf+ba9HCbYyk88=;
        b=jBGGR3F0qcRSo7rr/aGZA1fyd431ozXGLu9OfyRbw0iOjDqEl1zvWw5DSbe3skjxYI
         BYVfUHIViEFQjl35bWAZeBcJ8oGGZfvlBNs0wF8ValvnHuqgFAHfUjklTE6f2xnsndav
         TiCzScHyaVSewTueUPuD/ahf05fZUweHJlq+XO9Ofx9kD+SmzzDvIjTF4DdOLDhQh9g6
         uFrI8mNFW/r0OBLJUTuTlIeAlwgstrO/Fi3NOKXV7wPJpMYCJBf1SD6J2xZCKy8fxxKt
         u4oaywfQhDxxzgCNKVNpZD+bY9cbOrwFsBX5MGcoqrpwxriv64xV0q5VYr+3hoZYGuNR
         NB6Q==
X-Gm-Message-State: APuU4Z+HhxWNU7OCOceI7IEl8Ks3mxa00SPBpf9U8x56jNnSNDdn0ynZ
	7HanOgjWirxWFUbAEv4KhM53X2RkxbnETFHequnqrRooiMMa9919pMav1egouecTTpE=
X-Gm-Gg: AYBFou3cEBWntiYVvSh8hJIIKmDfw16/D5Y7A57dqP3ULuczqPZAtP2kX4yO61Q67IA
	1ctK5gNJOFMmM6IU5ki72Zlig4zPRwGeM65EVaIElhttMgD54fn7HfPP/wOZSz0tLXYDAcTgX4p
	Cmui5BO9J+qdaLDUY+nqPIiil+KjBHjxy6k46Z64h7E8/tIELJeW7enAKJydPPsfMLJX+bndutN
	QjFhjYufDx82PUZXYZ4ux0M/lOI+nA73IrLIvu4U3mVHXXj7XgDRJo7SmKBeAMAWD2G/gLKwVuW
	EprwSPmudtnGTZ24ctIVnjGrABc6z6E5Ym6UxbyY5TEWX4Sgd1x2fu5SMonG0clk5uueoB5aF0Q
	uJfKSfbtq2hBPZK0JWDX3pAfWLnvzuBEjYnXKUCxwdlMlc18uG656BrjKCvF6ETcpuP8VhJ83/G
	vQYUP0dd2ozI9gwOi8pUeaiVaSQkGs72GjEaM9Zx/uo7u0H6xDUKyZvUCLMwV7xou5PHH20IwjP
	1SJvllGGk4+Sgvkk/aJXT44LvgFoM4g0lsmwSuGXXlvPyFpnGHHbjzrI68mERvdVmnrRRptNvUQ
	rJEIBSRlBqPa5RpcJy8CiYztgs88CpySilqObixtScJJmxBOU23jplSvjvuSHHYDJ+dEfiRKSpr
	wCg9BZ/M4oQ2VvaZ+wP08wRZJi+FzLi0BaGVRAQ==
X-Received: by 2002:a05:6a21:6e96:b0:3f9:bfa2:6067 with SMTP id adf61e73a8af0-3f9bfa2a300mr2573650637.21.1794745295946;
        Sun, 15 Nov 2026 04:21:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18736b3sm3301925a12.7.2026.11.15.04.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:21:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] scsi: libiscsi: tighten task completion
Date: Sun, 15 Nov 2026 21:21:19 +0900
Message-ID: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
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

1/3 stops the receive path from completing a management task that is still
queued or still being filled in, so a slot cannot be returned to the task
pool while the transmit path still owns it.  2/3 stops it from completing a
NOP-Out sent with RESERVED_ITT, whose single reference belongs to the
transport, so that reference cannot be dropped twice.  3/3 is new: it makes
the transmit path hold a reference before it publishes the state the other
two test, and makes the SCSI command lookup honour that state at all.

v2 -> v3:
 - 1/3 and 2/3 are unchanged.
 - 3/3 is new.

The review of v2 1/2 raised three issues.  All three are older than this
series, which narrows two of them and leaves the third as it was, and 3/3
addresses each one:

 - the window between the ISCSI_TASK_RUNNING store in
   iscsi_prep_mgmt_task() / iscsi_prep_scsi_cmd_pdu() and iscsi_get_task()
   in iscsi_xmit_task(): the store moves into iscsi_xmit_task(), after the
   reference has been taken.  For a SCSI command that alone is not enough,
   because iscsi_itt_to_ctask() never read task->state, so a command still
   queued on conn->cmdqueue in ISCSI_TASK_PENDING could be completed by the
   receive path; that lookup now skips a task that has not been sent, the
   way 1/3 does for the management lookup.

 - iscsi_xmit_task() requeueing in conn->task a task that the receive path
   completed while frwd_lock was dropped: the requeue becomes conditional
   on the task still being ISCSI_TASK_RUNNING, read under back_lock, which
   is the test commit 533ac412fdb4 ("scsi: iscsi: Remove unneeded task
   state check") removed.  The other half of the same window - a task that
   was parked in conn->task and finished before it could be sent again - is
   dropped now instead of sent.

 - transports without ihost->workq, which call session->tt->xmit_task()
   from iscsi_send_mgmt_task() and iscsi_queuecommand() with no reference
   beyond the allocation one: both now take a transmit reference of their
   own, and both finish with a failed send inside the same back_lock
   section that tests for it, so the receive path can no longer complete
   a task whose reference the caller is about to put.
   iscsi_queuecommand() gives the command back to scsi-ml right there;
   iscsi_send_mgmt_task(), whose caller frees the task, parks it in
   ISCSI_TASK_COMPLETED, which is a state no ->cleanup_task() reads
   differently from ISCSI_TASK_RUNNING.

3/3 needs 1/3 underneath, and is marked for stable for the same reason.

v1 of 1/3:
  https://lore.kernel.org/all/20261113145140.282504-1-yhlee@isslab.korea.ac.kr/
v1 of 2/3:
  https://lore.kernel.org/all/20261113232322.395246-1-yhlee@isslab.korea.ac.kr/
v2:
  https://lore.kernel.org/all/20261113233938.397415-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee

Yehyeong Lee (3):
  scsi: libiscsi: only complete a task that has been sent
  scsi: libiscsi: do not complete a task sent with a reserved ITT
  scsi: libiscsi: take a transmit reference before a task is published

 drivers/scsi/libiscsi.c | 67 +++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 9 deletions(-)


base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
-- 
2.43.0

