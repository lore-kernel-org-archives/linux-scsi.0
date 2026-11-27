Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795787561;
	b=xGmc5JJm+DzeQIz5jIj7DmLE6Zp/JaL8ogqTW92HgKkuwnStUd5PKuJLrex501PK1uPR
	 mDpR8NlnOvqVPXMS6mGEM+VGTeld3SmRjb1ry687fOAyxOdYjVEZJYHSKQ/WYlyqg4e9J
	 STS2LIWdodgk8QN8Jp5/FudvVmu+bxuP+rF3XKRgpl9fps0BO71Ln6ilXMf2twxXbRs45
	 9LLc454tksZUpQMll4+bbEFVmMkOEsdVnHoAwNMzr6NZ44pYU0JFT2JaqWZRuWltdq5/t
	 VNGNL3pdBR4ANHYVRZhqCdFDGfIyEIy/6+30sa88H5hoUl1ykA2wMI7Qg/2Us+3JMMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787561;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S9NopdCuRCua6D4VeJIAX7bWhIeQ9+jfQfbb9+yyIDM=;
	b=AFUDOXV2Y5Gz8fgYNPaInBAcMfS24azdHwx5iA1AzDh4ZJ9V/+w1tmqOTI2IOPzff+UO
	 2om1Yv70xXv5s7neGQ7DRfuLuj3BfP0j9fW56GJVC7KvsxUffxsAjcKSlLIKCGgrrSWcD
	 ksR6J0NoDIyNRg+l392mJtFjv1Nsp2dn5NqJdMmfEf09El/UB6PAwXUMDYkAiV+3wXUqp
	 2vT70COZ7Z1hKSajSEQD+oPiuwhIOPtiCYcKH0EU5ScVnzkeCjPpWZA8CQIwFS+jF7H1U
	 e4eHBCVS7ThZFWVB9HdeeM/wBq38L0772k5hU4hKO6Be/EnXsX7jp9G9R5M+UJfM+eA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aRJhxcUF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA0606A326;
	Fri, 27 Nov 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aRJhxcUF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795787560;
	b=CAaKVhUS4qHS7L7UaKfHiEdbcpJmJVRwjiE0zbXrwEQifQV3ExSlgUZB6uLuSE1PtiUd
	 e3PvIn+w3sPd41oUuru3UsQVdbHqy0EITA0ziYf8xSmUCx8JHIMI0rsiBKVkSF2WT1vYh
	 7JVWoLGuW/3e+E8GQBLIYxXsmTnqJB7/Vv0Y7E+rAMbTGP1gdl9UTfrEyEYlAktOr4KOB
	 Lthood9WxwG6G44YZ44t6xANgj//zfQIO2HEnc/NWpqmljPVt1Wd77AElIPgykTX05Iw+
	 mcBqvFKEs9c7BUlZegzHI3JqWl5dooWcCKpBev6+oNH/Z7Q4wDMS2P3zye7sYEjdYLw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795787560;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S9NopdCuRCua6D4VeJIAX7bWhIeQ9+jfQfbb9+yyIDM=;
	b=rSVdMxyQT5aoB+pFG84xwS9/pVtF86Z00fcNdy8/OT7x0pA6wI35ndOx4qk17QgML5rm
	 PNa1hoZPz1zNjjD8rfnNym9CHof3Q5SFA8n22ncuCKMb45dv81nqy1kre/D32zI3qoKqj
	 ddiUARsEdD33CeNns1+b2X9J2SO/mDyyGqEfpstJqSmVNpwn0GA53He8Q4ZOWKKpVv6sC
	 0e0knbxx1Q7X354cG6RD59FROguuEwfOs43bwjCJPcI+g4kcqStgZBX13lQDUs95p2YsZ
	 s6/iFce7EEkGMxgeBJyFaBzQ7Z/dQS6Qm5da+hZwE/T8uq6F28vk2CnH4XWNtoOy6qw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9A3121F00898;
	Fri, 27 Nov 2026 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795787560;
	bh=S9NopdCuRCua6D4VeJIAX7bWhIeQ9+jfQfbb9+yyIDM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aRJhxcUFTbuvtqzNjxoss5AZoKJIBRNRef7IwB2hRG5OF1vdB3PNcAWEZldn+DU1U
	 xpq7kGAufZkuKMtBSMjlFjLgOXH/VavJeciVR0UfH88tUsEslKGhtmswmpHHxx4r0t
	 E+iIPkvEdTMoNk3Nl/WtVdPjmZ1dTkdg9ddC8472pP6NZeMGQqSZgUFKumrdDeqAzD
	 HWQ1hHNrAmD6e/IRv4YguXrzaP4aOCHA/mLmORMG0l6TGDH0IAGrSd1MOllKHQWOjh
	 UcbHnfLEyzfjUApMeYmKslDlCNVqhZcynAwfymoH4Vhy08dTmMKOaGgSbIyq5ewX2u
	 7S1E/y5tdrw0w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1DECE4B822;
	Fri, 27 Nov 2026 13:52:26 +0000 (UTC)
From: Rongen Wang via B4 Relay <devnull+security.nitrohex.com@kernel.org>
Date: Fri, 27 Nov 2026 22:52:19 +0900
Subject: [PATCH v2 2/2] scsi: target: iscsi: Do not let Time2Retain expire
 a session in use
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
Message-Id: <20261127-b4-lio-iscsi-session-closing-v2-2-a3ac8e88cbad@nitrohex.com>
References: <20261127-b4-lio-iscsi-session-closing-v2-0-a3ac8e88cbad@nitrohex.com>
In-Reply-To: <20261127-b4-lio-iscsi-session-closing-v2-0-a3ac8e88cbad@nitrohex.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 stable@vger.kernel.org, Rongen Wang <security@nitrohex.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795787544; l=4058;
 i=security@nitrohex.com; s=nitrohex; h=from:subject:message-id;
 bh=5/Dtu7CSdvDwnXX4ATjaK74rHeFBYAS3kkaixR0Ih+M=;
 b=RhFiaOEd5YjmyHVMNjJK0beLTbUDvNkrMfUCFmcW+6LhHZeSfNzvEx9PJU8vQfntoJuHjBDCi
 8uuvPm0J858BNskLO5lTY5vKDOU5Ip6Dme6Lv9H6Y+nxes7e1vnYCv1
X-Developer-Key: i=security@nitrohex.com; a=ed25519;
 pk=Jk5NuTVJdxr1CTP4RuYaG31zSgsNlyFzVo9sphZTqt0=
X-Endpoint-Received: by B4 Relay for security@nitrohex.com/nitrohex with
 auth_id=1652
X-Original-From: Rongen Wang <security@nitrohex.com>
Reply-To: security@nitrohex.com
Content-Transfer-Encoding: 7bit

From: Rongen Wang <security@nitrohex.com>

A Login Request with a non-zero TSIH holds a session usage count from
iscsi_login_non_zero_tsih_s2() until the login completes. If the last
connection of the session is logged out with reason CLOSE_CONNECTION
while such a login is pending, iscsit_close_connection() moves the
session to TARG_SESS_STATE_FAILED and starts the Time2Retain timer. The
lookup found the session logged in and had no timer to stop.

When the timer expires, iscsit_time2retain_work() marks the session
ISCSI_TF_EXPIRED and calls iscsit_close_session(sess, false). That
removes the session from configfs and sets session_reinstatement, then
finds the usage count held by the login, clears session_logout again
and tries to restart the timer. As commit b30d7199af28 ("scsi: target:
iscsi: Run the Time2Retain handler in process context") notes, that
restart does nothing because ISCSI_TF_RUNNING is still set, and a later
expiry would stop at session_reinstatement anyway. Every lookup skips
an expired session, so nothing frees it after that. With the previous
patch the login is refused, and the session, its se_session and its
command tag pool stay allocated while the target keeps counting the
session. An initiator can repeat this with new ISIDs.

Handle such a login like one into a session that has already failed,
which stops the timer when it looks the session up: while a usage count
is held, leave the session alone and clear ISCSI_TF_RUNNING. The login
then stops the timer when it adds its connection, or starts it again
from iscsi_target_login_sess_out() when it fails. The other paths that
take a usage count on a session without connections set
session_reinstatement first, which the handler already checks.

The Time2Retain case was pointed out by the Sashiko AI review of v1 of
the previous patch; this patch was drafted with the help of an AI
assistant (Claude Opus 5.5, Anthropic, via Claude Code), and the result
was reviewed and tested as described in the cover letter.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Rongen Wang <security@nitrohex.com>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 036ddc1002..35e2eed117 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -747,6 +747,7 @@ void iscsit_time2retain_work(struct work_struct *work)
 						   time2retain_work);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
+	bool in_use;
 
 	spin_lock_bh(&se_tpg->session_lock);
 	/* A stop after the timer fired takes ->time2retain_fired back. */
@@ -761,6 +762,26 @@ void iscsit_time2retain_work(struct work_struct *work)
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
+	/*
+	 * A login that adds a connection to this session holds a usage count
+	 * from iscsi_login_non_zero_tsih_s2() until it completes.  It started
+	 * before the session failed, so there was no timer for it to stop.
+	 * Handle it like a login into a failed session: leave the session
+	 * alone, and let the login stop the timer if it succeeds or start it
+	 * again in iscsi_target_login_sess_out() if it fails.  Expiring the
+	 * session now would make iscsit_close_session() find the usage count
+	 * and give up half way, after which nothing frees the session.
+	 */
+	spin_lock(&sess->session_usage_lock);
+	in_use = sess->session_usage_count != 0;
+	spin_unlock(&sess->session_usage_lock);
+	if (in_use) {
+		pr_debug("Time2Retain timer for SID: %u expired during a login, deferring\n",
+			 sess->sid);
+		sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
+		spin_unlock_bh(&se_tpg->session_lock);
+		return;
+	}
 	sess->time2retain_timer_flags |= ISCSI_TF_EXPIRED;
 
 	pr_err("Time2Retain timer expired for SID: %u, cleaning up"

-- 
2.34.1


