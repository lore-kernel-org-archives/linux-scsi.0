Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349455;
	b=zcT5CFUSQ2azcuCsC0g2pKW3x/6w11fPX72ZogsazL+qDNp1HQvgvM0oEf0sQXRAabh6
	 N4paUiOOxJtq6z61BumeYwytKZ021ltnEO0dVn5xDdyixWyKgC5UaeC4P2h/nIHmVlnET
	 9Xme5xLF0GkD9hyM/zQmWIsC/xDvxhiHrCr4sRQ082BZJOYnQO4Y4FPlUQ3HPWGgj8fLS
	 54VafKLKowM6Oy1Sy737Dr3e6cxtHpkIiCD4P28qWWmDxKPTBk7GIh6Q11jAlF3Il1S+d
	 d4iqn8vMwrhsKCbV+b25LRe3D2Dj8cuOJJiWCRKqqNxZhRjWZfVcjd9ANF1JOlBOAdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5VGH+8AVAlrWwk+iBkQMQ4d2lmEyzdJub4xNIMW5F28=;
	b=st/4Ac7clDXX0ygQoHy/MsrQhkRvOVNoqrowdiADTWZbjX5tr4F0lertGr+GpBr9BdcN
	 //U18bSQg7gM8nxmwrLC7PMqmdZ6H6cbSv2JPgSspbOOW0+jmXixWbsMIdN+rjT9IRtwg
	 cxZZeR06VsNaxcW4xNGx99KN0vBowQj/U/AUW9IKAwQ6QUYO8IIdiQ5Qt0Zo3MreqxtZf
	 l7Gm7fhExxSucf1FgAB5YCxPOmHb/H/fMvthT9HIngjzfPnUrBR/xDJ7HNto0oD7Oh+/P
	 pBCbE+DxyCu1ecieRU56o4vvjn2a/R9pHtnr/cqJOHZUa9x/ynOvtXxeuvXiYSCK8NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xz2B1zuG;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB48606A321
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 22:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BB48606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xz2B1zuG
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a8cc11ac42so2546239c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 14:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794349454; x=1794954254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5VGH+8AVAlrWwk+iBkQMQ4d2lmEyzdJub4xNIMW5F28=;
        b=xz2B1zuGmegeSZMDCqovYzUH4V7UWmjgS1jy33CXEthDGKsL20CtXrVMTuy/oFw/Hc
         ys9awCsiB9470wbVB1uulspA8O7rAcwvo+xKFZKibnlSCcxyQ29+tfh2QipcYruKHkQG
         EWrYPhllOWo87R+ZGBEdHslgkazYFM8WbR9e+eU7awVm/gHpbaSUt05ivkS6rZK4bEnL
         T7GV9Ht/CsU+YZofjK981aZlTwO5ukZhYEuJjCufgiq1qNi4zQbRHff2CxpP2DIM1A2g
         bpUoyk0y/hjhmYizcSmMLlvIGFqeqw1yYVGPvJ03Ty06Qbu5vaGk5QL27BN/4SQrdkQ7
         BkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794349454; x=1794954254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5VGH+8AVAlrWwk+iBkQMQ4d2lmEyzdJub4xNIMW5F28=;
        b=ABH0lUshUI+DrPirOCzZd+TE1n/xxjG2RrpfrWMEGbt8GEUgsFrxom2h4DQBb60M+C
         Rz3hE6enZsQaMvIS29jwcKzBgemTmeJAcOCVubCsCsDRUs4/ZnKIycaJ5jf6QEnO54M3
         Swo6b12KH2eaZ5l4vhMET2xrLHtR1YsUE/CRhYWe1/RML6/k0Le5RsOa/HZ+xDLzAiiq
         WccXlBl98Hb42G8S4CVQM9FA6R/3uMg8wf6R3Oekr8dTSNRGj2BFPQQPNNYXpRpGHyLS
         6nNHWLTyudgVzTzCHnWMIit6+K5r0U4FhA2NcCqtPpvyJT454T7WiTncQnxRPd9BksLK
         Eqag==
X-Forwarded-Encrypted: i=1; AL+hErFvewBFluJ9c0GH0Ag88G1ZLrRttrFieCDyqL4lg6jjJ2CkpNx8G5cWVCEsk9aMIz4aD3/58J/9oUpO@vger.kernel.org
X-Gm-Message-State: APuU4Z+BbU1MTu9xwhtEh3EiCwZMvIasmsrvtUfP3C74GhE639Ocyf9o
	i0gQKw4UA9K1M8B3TplvQzRJkOXmhmlwgQC0qLAfYHS3QkFIv/MwKnwh
X-Gm-Gg: AYBFou0zLlyX/FDhXgirVVS+vNvNi8NuE40s01uW3nwOZzv4JSFH1yW217m1ezOcybn
	PeIDxCnilD802x1VY/LLAXUB/fSb/c4ddMrN9B1ukhm7/OU9WH7qlZCvIz7qKpApYUUZTNBiwA6
	ncGUFbmHKtRxkeM9M7Nc7OVCLyTNI5nA2GLlDQ63IYfNP/DEiLt3n1ARjhdBEQdvsLpWpXuVgSH
	wv/BKzE0fjH0cT/9iPd8Zra7BbwBJbX78Z4BJ7doU+32BRwmf1SOFkbLfUlvf8vAPqfHRwEMkDm
	Xr/V0fhu3eTSCYdISEXvrT3Aw7bBj9EXLBkYopDcYZfZl2XXo3M4AUqSDN4MuUYqamzj3wTyOvl
	oz+l/R3xVhw9yNs4P+Djg4brIb2DNXryKrHF+0Mxen4CU/vHcbliSrYlsne1c/FbUH9BCM5qdPQ
	F9FoyTdrErtcmsXlLanKw1ia7h9Hb0/EdmQRHIaOrFPkUnNHECZee41FmDvbvsfBU0xcEBGWPWx
	MJLSEI2MYrpYCVOmFxIjQQGTU39xdCMKWYZkfV0zc0f6fgTGFrvcazFbb9Aw5yFCsG330C0ax8l
	wPb3YG43Onp8mDetwMDjbdAkmTOxwiiH8RTQkSq19pPtze91RxGGnbSLeRtR
X-Received: by 2002:a05:701b:455a:10b0:185:fd0c:4585 with SMTP id a92af1059eb24-1b3c034aa22mr354963c88.33.1794349453933;
        Tue, 10 Nov 2026 14:24:13 -0800 (PST)
Received: from localhost.localdomain (wood.seclab.cs.ucsb.edu. [128.111.49.37])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b56c4e88sm8661009c88.0.2026.11.10.14.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 14:24:13 -0800 (PST)
From: Praneeth Balasubramanian <praneethb2002@gmail.com>
X-Google-Original-From: Praneeth Balasubramanian <praneeth@ucsb.edu>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Praneeth Balasubramanian <praneeth@ucsb.edu>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: iscsi_tcp: Don't read sk_user_data from the recv work
Date: Tue, 10 Nov 2026 14:24:03 -0800
Message-Id: <20261110222403.205332-1-praneeth@ucsb.edu>
X-Mailer: git-send-email 2.25.1
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

With recv_from_iscsi_q=1, iscsi_sw_tcp_data_ready() queues
conn->recvwork, and iscsi_sw_tcp_recv_data_work() runs the receive path
under lock_sock() only. At the end of iscsi_sw_tcp_recv_data(),
iscsi_sw_sk_state_check() reads the connection from sk->sk_user_data.
Its comment says it must be called with sk_callback_lock, which the work
does not hold.

On teardown, iscsi_sw_tcp_release_conn() first calls
iscsi_sw_tcp_conn_restore_callbacks(), which sets sk->sk_user_data to
NULL, and only then flushes recvwork in iscsi_suspend_rx(). If queued
work runs in between and the socket is in TCP_CLOSE or TCP_CLOSE_WAIT,
iscsi_sw_sk_state_check() dereferences NULL->session. With a delay
added at the start of the work to widen this window, a target-side
connection close gives:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  Workqueue: iscsi_q_3 iscsi_sw_tcp_recv_data_work
  RIP: 0010:iscsi_sw_tcp_recv_data+0x219/0x420

Both callers already have the connection. iscsi_sw_tcp_recv_data() gets
it as an argument, and iscsi_sw_tcp_state_change() reads it under
sk_callback_lock. Pass it in instead of reading sk_user_data again. The
connection stays valid until iscsi_suspend_rx() has flushed the work.

The unlocked read was found with an LLM-based tool that checks callers
against the locking rules stated in kernel comments.

Fixes: f1d269765ee2 ("scsi: iscsi: Run recv path from workqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>
---

Notes:
    This was found by an LLM-based static analysis (GPT-5.6) that checks
    kernel code against the rules stated in its comments, as part of research
    at UCSB SecLab. The patch and changelog were drafted with Claude Opus 5.5.
    I reviewed the patch and take responsibility for it.
    
    recv_from_iscsi_q is off by default, and setting up the session needs
    root on the initiator, so I am sending this as a regular fix rather than
    a security report.
    
    Testing: two QEMU VMs on next-20261023, an LIO target and an open-iscsi
    initiator booted with iscsi_tcp.recv_from_iscsi_q=1, using CHAP and
    continuous reads. The initiator kernel had a 20 ms msleep() added at the
    start of iscsi_sw_tcp_recv_data_work(). Closing the TCP connection from
    the target side produced the oops above. I have only seen it with the
    added delay. 
    
    The patch applies to mainline 9ba46df34488 and to next-20261109.

 drivers/scsi/iscsi_tcp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9260b1c9b0e0..88b1f255ae9b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -104,18 +104,20 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 
 /**
  * iscsi_sw_sk_state_check - check socket state
+ * @conn: iscsi connection the socket belongs to
  * @sk: socket
  *
  * If the socket is in CLOSE or CLOSE_WAIT we should
  * not close the connection if there is still some
  * data pending.
  *
- * Must be called with sk_callback_lock.
+ * The caller passes @conn rather than having it read from
+ * sk->sk_user_data. The recv work runs without sk_callback_lock,
+ * and connection teardown may already have cleared sk_user_data.
  */
-static inline int iscsi_sw_sk_state_check(struct sock *sk)
+static inline int iscsi_sw_sk_state_check(struct iscsi_conn *conn,
+					  struct sock *sk)
 {
-	struct iscsi_conn *conn = sk->sk_user_data;
-
 	if ((sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) &&
 	    (conn->session->state != ISCSI_STATE_LOGGING_OUT) &&
 	    !atomic_read(&sk->sk_rmem_alloc)) {
@@ -148,7 +150,7 @@ static void iscsi_sw_tcp_recv_data(struct iscsi_conn *conn)
 	 * unmap it now. */
 	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
 
-	iscsi_sw_sk_state_check(sk);
+	iscsi_sw_sk_state_check(conn, sk);
 }
 
 static void iscsi_sw_tcp_recv_data_work(struct work_struct *work)
@@ -202,7 +204,7 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 		return;
 	}
 
-	iscsi_sw_sk_state_check(sk);
+	iscsi_sw_sk_state_check(conn, sk);
 
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
-- 
2.25.1

