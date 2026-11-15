Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733152;
	b=bPhtH3Uq8F4emwKFsWhMuw1kLbyTkW60tj7R8A4DiqejYpfAo7TVjmmAe6h0XwbFDH49
	 wmdYxlwQW3yniIOL4haTgAtBgFlBWxfOddzKrebWrKaNkLP16ITFqJIJLJnD6df2tPDEg
	 VRBukoOBPIXbV2uWHHQN3yJOGQ5n2fDYQo2s8yTpDcF5LFbufd88yt4BY+N2QynbLpdSH
	 hEJZ/Rk9zsyMlaOpRijsRnGV37Tm1LLPdN/9SNU9jjekrxXqPT4yaUlI9CB2Yq3bSUjtE
	 4e8/U40NphZvxM4lN+bzQWSpT7SHEqQ8bKelqS45N7GgVDvWYyeXt/DBVvzhXMr5LRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
	b=hzmB8d07kSr/iNVf+v9A6o5/0Zt2fz1/kK/kVglQROGxc2B3gYfB3AuLGvRbISF+OOFN
	 s1Ar4pHwL6Bl8/dPu87/SK7HEvSvhjuuv5Pg6rJa//76su40+NG1ttqNBHWFSPwyTL+17
	 4lUit+CJl01ADsWI4+0HQ7MTYB0ftAXY2eD5NMKco47yOthLyKKg8wam0MB1GhPWO+bHP
	 kJ0AYf4AxH1EkzD1XQBDkZtxkxYSbQ/6SnZESZG08alu6ONNNmG3UJ5zhE5/G+CISyYpd
	 ylr3pwL1e+GEm+V1lJyAy43PKH9DDzyVizlIb8nfJVdgH8Cmzi4Wf3iHSRM2HwavEGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Y3lgp/rm";
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FC606A335
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 08:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 117FC606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y3lgp/rm
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so1148630a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733151; x=1795337951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
        b=Y3lgp/rmcuHXtGgT7jiOpAhUdOJjUk2EjyColK+tRWTsylj3O0EhFIqbVdSZ8dov2S
         FBYbHklRubGQqGKxI5Rwp2PdjLLucmeIFSLVw53xmyOcmSti1Ei7PsQMrnNtQDws/HKf
         bDzaFYiVA7pNUjapbfk8z7ZWCO0o38b2UZwPSIrXy1ymv/W5H3VghAjcogdi5NJkk/U8
         6jnrptXeSZtRn7mgMe0VQrPuh3ic239zz/vUfWyuEfpJCZf7kWeGfC8zBzAB0msA/49d
         SdTDWwI8obh+POjb6QClXWMmV0qDnf133Ieyh1z8MY3c0rWNwifB9SUlDqaNea7VhCQC
         QsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733151; x=1795337951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
        b=qgTM4GiQpxRq75iewiZUXxCuNznC09ZvH4UQUk9dJDaqLS2tOyqwIxQMhMDAcPdp0d
         tdt2vI0HkHTzgPL+rIkXEVdJ13lPSSA0bDQU/eE/lb1TAk5ELhkiPm61dqo6WhhW1YhD
         jeasUko53LQ0KWm31TKu6FAGsrFvIZj9vPWRzfH6hqHs2Me99fw6tAGBrsI0O3lJnH2F
         hbv/n1rJeZdvDPDhXaP2DMiD4Vr7WTpIHdEoqC1H1IBxSZhkhAfwWFAXHt/XAZwWfmAG
         6qajOeWM6eBQCK5OqjZBGpa0Dsafv+LbbFYyC/afdPyD0qbqxjM07RsdGjUhRC1DN9H5
         rPbg==
X-Forwarded-Encrypted: i=1; AL+hErHAHHY2NprzRLCeyb1RKQU5qwddC0ETjLekyWPKsQWdyhmHzBCh4I/jyA1ErG0OwgfRLh87OW9D2fNg@vger.kernel.org
X-Gm-Message-State: APuU4Z9WSXWLP/Axhz1BS6+4zsJWY9xGXvzODTwMrjbk9UeRlGxTccSw
	3bOQ8+pcwF8bEHVewbVMHdsqA9Trqcg6z3T7J3SOg0F7L9TQrSv5rqnN
X-Gm-Gg: AYBFou3SRPBQozU2bKlkcIRK8ALDhj0BFRITBLfJqglTjFlIs5WLFRcgudxD37bZ5y+
	vgUr0ZLAeUTdE2VrhAqFekvigEbuCOlVKHr3uiMmUqoGKcqveF3ZvVqEc/WXRj9jRWX+cGgOMz0
	00/5dL64AndVGXRAnlPooHOwXuDZy2/L6QvL37y4SfU3+rH10l2EFEGfNLuYhcXY8KGKZdlUUcm
	4cVSncYdP0FkIOw64dWiCmTyQQbTGlQK+Fz3R8sXCbRlISa6UJGv2g/GLilEneAIWcG1HenENVC
	pdCnB8WVsfilEj/nBWU8zxqIOxp4Y+9yVPC5N6GY/8slxn6YOe12+jz9hPXEX64LcAjp/6ZvVeI
	xhFRTrrBLB354fdIT6kmVzIBNQtxbnbbNVwOEXPJSzKrIqekDTMtxotTR3bMMPbvdOkuGLimpca
	q3OBNCKDb8Xk/aDKLZ5qQ43kV+P4GQjbB5bGzxxsAWzWMbZ9Xw86IReabA0q5mVtJBsNawQ0i7c
	ygXyTdT4dTlEpC5Cgj3RV7fBp/Bd0kBlkUkvVqUCJE6giqI6us/NfPtMI16ljQkFsNyZdRZCDiF
	2Pun21lJvNqIbl6idIxmQ52e7PStZOHyaC794pGkHDmDkHrKBFoUmKj0nmTlszZAvfi8CkVjS/W
	+P+495iHuHhNBwEr8SG42FUKgFx2uG3YkVKEQYGb4SvuSH+rR8Ws159bJf5oMY+q7tRfbWSeK7r
	fnW4w3okj3JxklJz6aE5IE51W3TMwKnwF5sQ2TQN6NLm1tpwEs0IR+1XuxKU1MbBzNEfvjWqIwy
	CbJ16Ll9Bscv07ekG/AQ4maUgyIrtRYyciWkbs247b+F1SHg80rtiiQMPoVWos/
X-Received: by 2002:a17:90b:2e0b:b0:3a0:e1f7:9b04 with SMTP id 98e67ed59e1d1-3b1b09f3b6amr7513724a91.12.1794733151364;
        Sun, 15 Nov 2026 00:59:11 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:10 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] scsi: target: iscsi: fix session use-after-free on non-leading login
Date: Sun, 15 Nov 2026 19:27:43 +1030
Message-Id: <cover.1794732723.git.danjwade95@gmail.com>
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

Tested with KASAN on mainline against a target with authentication=0
and one explicit ACL.  Compile tested on x86_64.

A reproducer is available on request.

Daniel Wade (3):
  scsi: target: iscsi: factor out iscsit_stop_kthreads()
  scsi: target: iscsi: don't attach a connection to a closing session
  scsi: target: iscsi: don't re-arm Time2Retain on a closing session

 drivers/target/iscsi/iscsi_target.c       |  6 +++
 drivers/target/iscsi/iscsi_target_login.c | 66 ++++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 +-----
 4 files changed, 74 insertions(+), 16 deletions(-)

-- 
2.39.0.windows.2

