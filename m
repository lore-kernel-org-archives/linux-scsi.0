Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794727891;
	b=GJAQmoeBEnRKN75EqAO2SvMyul/6r/qmYB/bJPCRZjRAWzkfqd/8KYeLqDURg4K1UP85
	 IkWRurTuJ5tBpem9U99B7l9LF+tZmWfejlOvG/aPPQ82RbftK2hYVBpLrQTsIMazzVgXe
	 cd1KwvXI3/OgN1JyJF605CRt0N3/lBj+JPUCl5WG/hjEcNrmT2FUqI3C9UuNTR3+y4utb
	 WKj04mv4KfewoVwV+ScPIgdK502LxfwjF1F1fRoWszEyTiPhoElHRSRg8RN4hGLCsMlZI
	 dOJn1kIpLbqK0nX/GNJ89z0VqukFPW1Dz+hmwZ2NBvDuz+wcoMUbI55nAzHMLY79O3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727891;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
	b=nYy1ykDws3qiowfBUCnr2jhUDGcFZ5Y9wepE0nPKwyaXfEyME9QbQKo6mHCy2O13VMm3
	 EbCMuM9ocqSMxpVXRrUqfkRwCZlyKi3VUUHBVRQqRvbumixPhUSSv1c1JCXu+nuFYS8yf
	 0/5A5fskp+GJFuc4JOr3MGbTiLP1BC1iq2b6MXgFgcXD7VNXgsICQojuQ8cZ2w8EvUDOz
	 +BmkjukuLneXynQFydP1VgC6y3tmV0w+Q0XF6i87qc43Hz9cWblpiazWs5Z8p+1Iq9aEs
	 RGRX6CIvX2zImvMj1miRwMP9qfOzGWJZpUxvw8ENw6KyFEEqwYQf6NsR+1QSf516AEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3P0aCTQ;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA3606A32C
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 07:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91DA3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3P0aCTQ
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso2646177a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 23:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794727891; x=1795332691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
        b=y3P0aCTQn4WSyqVN5zkxPbnkLqEDzHMHWf2Ar9oDoYglX075SKR/QrPhxSRKsu+JLb
         VG6aayabQVF6xbKnfaAXPknVHtTyL++LrdvGQJynFMEr2Eitam8S8KBSktTTQuUACzbP
         eRurKT0vNOsRlXljLI9u1PfFG9pdCHA2csRYllNf/hr5bJzscbk4PlX1JvW6A+1YAGgL
         rfbXHlA5LKWHSvYXX9qN1UE3xoUitxFTKdUgsupyk4nL2yQDnkmsEIUInFiNbs8woD2C
         Sc9EAb5kpp+64cahJCWIu/3eohf3hhxg1ifoCOUu+9MZo6+V4DOcHGg972RWOCJdntRQ
         PTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794727891; x=1795332691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
        b=hTQl71tTFhzt5o6DCdAmKBtdH/agZPNy+JayJ6yt0MnscR5UseQeaGjFPydOBaMttL
         deSPd2HopvuWip7uR2j3pRqPhRaG3dVBEZsKpn2FS6XQVKuAb+G16Sfq1vugd7FX/oTZ
         IeSVNqGVV+aZp85MgCC3PE+j2z5E9OO+LNtPSamEmYi4BJZxSshPhHDM+X28xGzRo53Y
         n730qAkaon0k/3kyoG41Mdb93fYOMs7hAVklRV7WmWvGaf+MT79ZmlTxQLxn4OeN1NJs
         /ZycQjA5K1RcGZyfWMgSL1sMR2yf3zax+Naj8UYNafNtJ6MDzGAOof6guS44j5n3yOLe
         dV7g==
X-Forwarded-Encrypted: i=1; AL+hErEH1qTWDPpMIB70zWPZqjyldG2R03zpM3OFqXeT00E4I5eU2XoCa3za/P6lB52XWtnx6QyuUGCzF0UW@vger.kernel.org
X-Gm-Message-State: APuU4Z/6+IUaWMeHWoM67v+LWe0uikiIk72GXPOEKdJ+aGAX9yI9GL2m
	jA+/lqJcBhw7ZHtyxTdS4EMfEePewMqxcaNBmJCwWDwT8OLfT/420SGC
X-Gm-Gg: AYBFou0Jyko7e6Sr2O9ySGrrtvhN6OQA2rG2yXX2hZ311pYDqU1MGhdeyD0V2cxQqVe
	3WO/BMVQdkK5yNsH5uiNVC9a/Qts0+ycpOPvwm/rZ8TiQVvjHsyf4vAEeUfRvEAanG4K/zIOQOX
	51fnFgxvUiIEoay9uJzlh8hnJ+5rwMiOf/o9DWD45bnZ3GM5ymU3AcACCLj1158qSPDw9akpU4t
	JzZTfHVJEQqCyVhwTUrGxKRJDaeuWHI9C6PAYhZE/7dlZ9D3CwR13i8ho6gWLa99gTdxhp7zt+U
	cwAN3BcJGcNdBFlxFGfX3JOGMGSinhvMeKrWFgGY7Mr1R03GHEfRbWzIhHimD3uxzcYxm7TJrUH
	M3/ZKT356l51HfIWyZaA6PtJKeLFqL/euygCgNcGuIRDy1V1cg7MtP5J0hEswzkiT7v3J167o/m
	LKxOQC1eHsbLgEAQWqXajgYOXv/lZ1To4hsg4mvIkAO4VE8QbVp3WsJpxkZDP18Y4ZiBUjH6B9/
	cz5LL8uXxJ8ZhA+ulmXqU1qFm1ScGStYNaTmhZxA8s0M4nCVZpLESH+AuEwM9GIvOa+LB48q6wr
	uQQc977dseUVrDcKGobo5xvH+DcO8+klVoOQpg0D/P9dsXu8v5E4R9b/iR1ljBtjDAkGd4+GEsX
	jo0KhteXkVKvOrO+MHe6jxGnZfjO440GbROebBwMCsaoEHKvAJUKdaFsELV8EEBrffxoHFyUC08
	B00VlrUMuJ2O1ZxwHhnfVU3IHGjeU1xNdI1LiH0d5LzWAf8rLO8/97cKUO+DAIV0K2EpWRi3J1Z
	IiLxX3PWkCc+laZruyhmsCMFA1ApbGhxKwzbrTOh03SY9X6QkeuFE6e4IGuWjix
X-Received: by 2002:a17:90a:f947:b0:3ad:eb4c:26fb with SMTP id 98e67ed59e1d1-3b1b0b553a4mr7578914a91.23.1794727890800;
        Sat, 14 Nov 2026 23:31:30 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce55c1sm16837463a91.3.2026.11.14.23.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 23:31:30 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: queue login_work under sk_callback_lock
Date: Sun, 15 Nov 2026 18:00:03 +1030
Message-Id: <20261115073003.9927-1-danjwade95@gmail.com>
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

iscsi_target_sk_state_change() drops sk_callback_lock before queueing
conn->login_work:

	write_unlock_bh(&sk->sk_callback_lock);
	orig_state_change(sk);
	if (!state)
		schedule_delayed_work(&conn->login_work, 0);

Racing this, iscsi_target_do_login_rx() can take its err: path, which
restores the socket callbacks, calls cancel_delayed_work() and then
frees conn. The cancel does not help: the callback read conn from
sk->sk_user_data before the unlock, so clearing it changes nothing, and
cancel_delayed_work() cannot cancel a queueing that has not happened
yet. Nor can the err: path wait for it, being itself login_work.

The callback can therefore queue login_work after the cancel has run,
and conn is freed with that work still linked on a worker pool's list.
The core then unlinks it, reading the list pointers out of the freed
object and writing through them:

  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report
  Read of size 8 at addr ffff88800d94c440 by task kworker/1:2/32
  Call Trace:
   move_linked_works+0xa7/0x2a0
   assign_work+0x168/0x3c0
   worker_thread+0x3f2/0xd10
  Freed by task 32:
   kfree+0x179/0x530
   iscsi_target_do_login_rx+0x3b7/0x7e0
  Last potentially related work creation:
   queue_delayed_work_on+0x80/0x90
   tcp_fin+0x238/0x470

CONFIG_DEBUG_LIST catches it there; without it the unlink proceeds.

The window is a couple of microseconds against an idle target, but it
widens to milliseconds while many logins are in flight. An
unauthenticated initiator looping logins against 64 portals faulted an
unmodified 6.12.117 once in 19577 attempts, on a stock config with no
sanitizers, that time inside iscsi_target_do_login_rx() itself:
conn->tpg read back as NULL from the freed conn, and tpg_state_lock is
at offset 0x1c. An unprivileged local user reaching the portal on
loopback hits it far more often, about once per 258 attempts.

Either path oopses in a kworker. With panic_on_oops set the machine goes
down with it. No credentials are needed: the race is in login negotiation,
so any host able to reach the portal can trigger it.

iscsi_target_sk_data_ready() already queues login_work while holding
sk_callback_lock. Doing the same here makes the read of conn and the
queueing atomic against iscsi_target_restore_sock_callbacks(), which
clears sk->sk_user_data under the same lock. Either the work is queued
first and the following cancel_delayed_work() finds it, or the clear
happens first and the callback returns at the !conn check without
queueing. orig_state_change() is still called after the unlock.

With the patch applied that local reproducer makes 11212 attempts without
a fault.

Fixes: 25cdda95fda7 ("iscsi-target: Fix initial login PDU asynchronous socket close OOPs")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed15..85531d6 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -715,12 +715,12 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 		pr_debug("iscsi_target_sk_state_change got failed state\n");
 		set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		state = test_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
+		if (!state)
+			schedule_delayed_work(&conn->login_work, 0);
 		write_unlock_bh(&sk->sk_callback_lock);
 
 		orig_state_change(sk);
 
-		if (!state)
-			schedule_delayed_work(&conn->login_work, 0);
 		return;
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
