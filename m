Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739231;
	b=TRXRoREekfIxTIuUIhe6nOPQ+/AOMHAqrezd9v6tKaq6r1xWfUxOcP/rpxG+bCuXzbiH
	 D+ImJcyda4NoP3OTcoz2kkx6IjXT2YcQm0Tgg8NwoNScx6WQf1LFRKJAzgQG5LCoimB3R
	 +ufnmW0XM2D+nXOfluoMkQzzGvxK9FkjkOWz6eOxvk9tVCvAkSnYw51UWDWB/Z3INDsp6
	 L0APlMMPn5+aTFiKECVXpT0oNpTKR592OELukbdF9dUfachjm4Mk7YJvlzvmOcTJ7nxQr
	 TxWuWaqQRGU+c0TzwrqteJHHt8623RePn2l7a7db3Y0/OL8JoyyK6DSvDxbNiaBEtZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
	b=teS6VSfjA6zJ0U24/Er+3tl3UWAHvRyxdhHPq/1orebvQ+kDabNkjkXBg4qiyYz0/3Cp
	 4L2VanwzoW2tPAoFwlXWuccyIikNM3zf4JRtDnWffs2N/Ls59ndKc0eVaLdTZcSLVimM2
	 1axc9Quc7tZG2YlUB6B/JzUdQ8QHVtYhm+qSzi4ku+XwEOOTrXAMtgEVar2zRwUVDVftC
	 hCv/aKmz2ShPw92IJBro7ioLxKaVwCN151gQHTvLGi/6Wxy5ok9ZJLwEORS7tBde9nHC+
	 xqG99zhib3kRCK/Qxkv302nQKLN20qC/UgEt8a4eWjQ2a4y6np25Si7OrBcfGmEhgQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OPQa8KoE;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC29A606A31D
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 10:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC29A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OPQa8KoE
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ed1b9e8f43so12338625ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 02:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739230; x=1795344030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
        b=OPQa8KoE8NBz3masLHOa9NpIYzd93Qy6Av/TK/2YtXrNMgSbxwBHTomVuGb6UQEXH3
         V8WWCtgwPExlNJXpxqK8AsFYFsJVyqG4cJ/p//GyUMf5KTEOjk91J6y6MdTx5XDxcLQb
         e/48Es7FElgrqsmFukokBnUVF4t4RYYgvBB2p4yS35M2HmgnqtHEfo/rxhtLyjDztmEs
         3RYqVxEupOhSNRWAvbq/jzmNKnVsNBe9mp35/AIOALzYyespId3qbxRkGLos4+JlsHP9
         JskTlyN3jIQUOQWUpDLRKpsBpZa9hsu9zmS0tnMjiOI2A6HT8pm4EDo4BXPtxfz7ga5i
         eAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739230; x=1795344030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
        b=O0cuNy9viSuyjijBBf6MYRfZ9yFDan3MtxCJusDhiP++O3CUru/0EiOCr/Kyexj/ul
         00zF0ruOlA9YRNZp1fUetTCnWiPC6NYhxdSjAgY/lZYuV53/ArZMkUw0qhR/IK8/nvl5
         g6gbTNZRYMiQfGh8A4IReKxM7dpsgpORA2NJFA44/kODulZNk1+2CX2xl6cTvj856ucp
         mfw6LXxEailvc+nRokLIbKKjhMeOh0lQdDPca1icUkQAlC+Sn8ZmkUtSthQTzq8nbyJ9
         isWtp9GRpVm5+Em+plfvePNSznRbV/Vsq+xIZkfwo8odhpdnJRc1eWsXCYkHiG6n6a+/
         RTog==
X-Forwarded-Encrypted: i=1; AL+hErHHRzb1mH8USRZ9GP61X1Ne+hlsap0Ok0OrazRmAXLJWO3uzuDXE+xpinzgzhTHKQYKidMjDDPUCDj/@vger.kernel.org
X-Gm-Message-State: APuU4Z8+6uVR/w6hsqvFeXzpLsL4ptAPktbV9lqLZNXC+uKSv/ml5gMX
	XwqtgoVpi0ihNOcJP+Gi7AO4j5ghUsmSzid2sjOiigx/EWhqH9YW2iCc
X-Gm-Gg: AYBFou3z86YCn1RDq1jMqTcYLxOmAdkFCRDg+GT3h+2auAmIeF/jS6Ynd7w3ABBUeYQ
	GjU/ZSyiYSe6q2a3KPzuiepcPBLi85NSyEXCPN4oOgKmT8/HX2PVzn/4kMkSUmVxwd46olKJmcO
	bs5ZfQB5FlLOR51UukCgfU7f9+fq0hbIY1oX63H49wN1jgV2/kzHs1G3tDQsXyMjRjniIGxVW0Y
	LfkpRaHUT/BafbP2yEfFd72KA/pEAqjEqBODHX47pN1D1KnR7IH0k2jnTGL/z65Zfohg+hZnNRr
	YWeEUFCLcidG1pIVTe6pZMyHD/2IZz5bQK9E26ca93jG2TkA7PbBvRSVjZ7lFG0ZCmC1g1wlFo/
	tim1vhjwd6UGcAeQfvP1zLRdSsNAr4pb5DZXEY9czv1Eel/GMc2rfH2//lybEqp+GmFipQBshwP
	b7YnClYsO358gJPRRiW2Z1/641NluTbq9uk5gKDKPIRDTzBJ48GJEQVQfEgHikWwdUKMnNTbLC8
	Zd90gpj5FzG2HMjbFaZVADSLppw1VOP10ygAO1YnB/7qiabpOt/atqvozqY85CKa+G2ms2M0qwn
	jRJ0ggQxiNjmij2btbriX1ko9m3SgLuntrTEsi+YHFCly8oHKTPIfsZfnPp8QYKUtWLwi/iAZV+
	RNjHja8wnFOshjv68hRDePX78CZ0jaekhb4nZQcii0n5sEtXXapKr8EZSF+yOxaJ92big2V+Wxq
	MLcX6jdbI6LYJhKvVQS+ESWeXSXvNYx2rXbX+TSXWUF0CVbvaky+OTpISDvH7GFZgsp7PVWKFAp
	FHllfMLlcLRWx5AgBQH9sTTxI5h+yjyit9f3v5zdTeGnYb+RwiM5pbvXjCipFoA
X-Received: by 2002:a17:903:904:b0:2eb:a1b:e9e5 with SMTP id d9443c01a7336-2ee0e0cf7c4mr80607895ad.52.1794739229907;
        Sun, 15 Nov 2026 02:40:29 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:28 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] scsi: target: iscsi: fix session use-after-free on non-leading login
Date: Sun, 15 Nov 2026 21:10:04 +1030
Message-Id: <cover.1794739041.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
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

A non-leading login can attach a connection to a session that
iscsit_close_connection() has already committed to freeing.  The
connection ends up in full feature phase with conn->sess dangling and
its NOP-In timer walking freed memory.  The same window leaves an armed
Time2Retain timer on a freed session when the login fails instead.

The bug dates to the driver's original merge in v3.1, but the fix keys
off ->session_close, which arrived in v5.7 with commit 57c46e9f33da
("scsi: target: fix hang when multiple threads try to destroy the same
iscsi session"), so a backport further back needs adjusting.

Tested with KASAN and lockdep on mainline against a target with
authentication=0 and one explicit ACL.  Compile tested on x86_64.

A reproducer is available on request.

v2:
- 2/3: re-test every condition iscsi_login_non_zero_tsih_s2() tests, not
  just ->session_close.  The Time2Retain timeout and the multi connection
  ERL=0 path both reach iscsit_close_session() without setting it.
- 2/3: publish conn_state inside the attach critical sections.  Checking
  after it was already LOGGED_IN let iscsi_target_tx_thread() enter
  iscsit_close_connection() and wait on a conn_usage_count that the
  refusal path then deadlocked against with kthread_stop().
- Both were reported by Sashiko AI review on v1.

v1: https://lore.kernel.org/linux-scsi/cover.1794732723.git.danjwade95@gmail.com/

Daniel Wade (3):
  scsi: target: iscsi: factor out iscsit_stop_kthreads()
  scsi: target: iscsi: don't attach a connection to a closing session
  scsi: target: iscsi: don't re-arm Time2Retain on a closing session

 drivers/target/iscsi/iscsi_target.c       |  6 ++
 drivers/target/iscsi/iscsi_target_login.c | 81 +++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 +----
 4 files changed, 86 insertions(+), 19 deletions(-)

-- 
2.39.0.windows.2

