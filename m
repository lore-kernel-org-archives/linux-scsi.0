Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739240;
	b=E68tk5iL2Xmv6HbBNt+EyVuKYUxcyVjcZC5BDe3xE8ZbQzhlQKr088G4Hu0zxsKs9uXw
	 dndBw0eXd43xNlSLm9LnuoHubxPDkn247jYzRH/2YBTHIk77LZRU9c4wH+CbuExTmJ/tr
	 jUpNXUwDe5LkKPwoYFdinSw1mVAyqvb4qotVXoDV9fzT+L+dTtLRYX2BDxhSV4JGI/see
	 61555uCHeY17XGS3Cm5NGJXKolsPRHCRmM1+7kvYHE9dUuzg9j1gmOcKyxrfQvRvJAEaV
	 GCNYif94x2ksSpOywm/lcTjTpKk7NqxWJG9u+a+Yw7O78eB7ORS37NyVvumpnu9lMDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
	b=q+YMylmqkDjxLgHlHFoIC706jbCGikG2V+J3c1y9fVwY/KCZAWZzwShWZCX9FtGunRwg
	 S9UTWfBEcUaPuPgf1N5qxPyRdajmGFuEBjhqHjFvzmn/nDuHzFhxSuUm2aEjMtpUxwiRf
	 u5fEx9/UPSR8mAoru7basjJXIW3aFjgoG+pazK7C9he7QbHrNUQLdB28WvuGRpiGXgQdX
	 3kT4OuVrwA+emUyO42exx8KdIQYW93mH3bQ+rEfHf3vDayrdCr31R4dKrqGeiwDV7wSE3
	 /3Xyd8g9spReyutEhsMZaDcHB0Rl71LNisPUQ7kQUGVNToRD0JbUqrF+OENE7rq2z4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEiVyM34;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D65606A89B
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 10:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96D65606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEiVyM34
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9995ce866so27052225ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 02:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739240; x=1795344040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
        b=gEiVyM34NDSCp2pkPQHpI928xWtg0jAwkU/EloJQ/g0yaZba/6kxQadtViGi3+wEah
         XOrg+w2+flKHeBdmIll0ru5ewMNgL4UoLb0RnByBBV7Y446WgYVAdR3Pij0H0+1Xcm6X
         IC+nF9rftvRryg2AavPmqTPIbi8FlSXGWXsGTnC20i//w23MXZI6AevHv4382SPCJsty
         8iww6oTppF0lhO9rBUdEwsxbwRyTR7dUPk21OQLfsTfER8oT5xaSmHn1hdxTqsIVx6NF
         yEBraZpvbudueMgbvLmMMBYU7VhjebE58m50l/7Y/BybISts+0BzEQF6TqXd1SRmwh7U
         5Qmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739240; x=1795344040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
        b=rRgcqW1xsRUgJ9K1VKSuc9FiIvcUGTS2j+YCldDo1HkdFsSVhogPpgJa8FgAcbyyhZ
         +Ot+ozD23pMpe8Kce4dpx7OqdoEpf5FB40Wjd9Kp2qTiZjXgSVSoZw3ENknHutJeMibA
         Tfk2yfyoyqFq77iPQN/1vMo0HoRt21VXRWTqzPH/BE23cOzZVDhZ83fquXrxe+cDo/I4
         4b/CsXqe4jiYBE7qFlFFj6UH4UCkjsSAS3gPU86V/cfquyKuMOh08SpnVsKz9JTxzlPE
         BeYdHqcRx+EZVgG1ZBAlqdw6G+GrpqKcFqbCcekLezYXz/9ozFY5Za2roDREM6PiRSs6
         oIKA==
X-Forwarded-Encrypted: i=1; AL+hErGKeMDZQde9f1KY5mZopEr2MxINoaUoHG07B915hXiHiMhGTShNEMuqndnQuEB/mwmVjpZpb28RBq/W@vger.kernel.org
X-Gm-Message-State: APuU4Z/Lvs1pjU5VeplpAI4jCnay4xhXsi013k+gCo2e9dARmBDVPdAY
	tNHwySkIR6NrTGD/JyVPX2jWS91hyMpkfrMGgCWeESaMUILQ++2duwYT
X-Gm-Gg: AYBFou1Yi4YoHjOcoy9dw91s7qBjxmJRmct1O0bLS18TrODWR+mhiKe5rO/a/KKgpJA
	ZJ8s4BAjWsWWmT6MYxZ3KP2SbJPArB9S8BnbST/R5+JqSvx4/Ccj5W4DOcYnnZj5+UKZvJHeYEK
	3jYVRsdJHJ51NMCxDVBw59f6gPCs9WeUoxI8q7CJagZBu+5PA4nAk0+/EdCimgCDauaJrhaGIaP
	ZruhHt9qE0R35xwyaMV9oAMFaz9+FEPWshY991U01Fq/p0zEyZRjRjgmgSzqqGfoaWqJ3eTM7KX
	OgmfPMTflEyrgE9ycd4T8fMwbomHoQ5zCkbRRX4RNDeFjQv6LJyBPs0SXCd4sUvDVDNk1P5ngrf
	DDrmpOdXyWidWzdoXTPxP4oSnlTYVELW5LFjNnqTLyey7tZ1Wp2Iv+Scy43trdznoyw8+1KCdTK
	NBqacnTKXblZe7mdLRaceFQ5Lr7zQABKcDUWdCGf4+bSICBZHL33pfjo0qW2EBuc4memhK+Y0uq
	/4MooNbEznM2DgY0Wh4Ul/vW2Ch5qAW4Cfb1OOiqj6GtceaOddgEPAy7wDx+TpKV5YKYiGX0xqd
	wOmfqU1gmOvQ5Mhg/mGm8mwApS5GRD8gtuwanprQkLm47QWg7hQQiy9ijMbmqhkVen5j0XqzlIo
	CR3SQ3dGBNcPIoyvP3wgeDDfDuF9Vz5D/IRLv0TrwSjW6yY7fdrYx7gtps8AVzoXSgJ2bCKY9ac
	7a0Q/rvZ8tpxeSYIhrAiiIigTE1btrQEMtyPXL14sCK/t/FN/K+HaEiADTlRpLCcbJINSoU6EoI
	X5WK7G6liTXZQtNHHVN5v8Es+mCUTeODIp8t9dn8hurh3nDfKgD0W+fPqw1/Hus
X-Received: by 2002:a17:902:e88d:b0:2ed:acb:aa96 with SMTP id d9443c01a7336-2ee0dad0247mr91339425ad.24.1794739239813;
        Sun, 15 Nov 2026 02:40:39 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:39 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: target: iscsi: don't re-arm Time2Retain on a closing session
Date: Sun, 15 Nov 2026 21:10:07 +1030
Message-Id: <6396b9a2d459b956e4081fa080e194d2df0b2a6a.1794739041.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794739041.git.danjwade95@gmail.com>
References: <cover.1794739041.git.danjwade95@gmail.com>
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

iscsi_target_login_sess_out() re-arms the Time2Retain timer of the
session whose login just failed.  In the window closed by the previous
patch that session may already be on its way out: iscsit_close_session()
stops that timer, then sleeps in iscsit_check_session_usage_count() on
the reference this path is about to drop, and frees the session as soon
as it is dropped.  A re-arm therefore lands between the stop and the
free, and leaves an armed timer on freed memory.

->session_close is set before the free is committed to, so test it here
too and skip the re-arm.

Unlike the previous patch this does not need the other teardown flags.
Every iscsit_close_session() that reaches the free is the can_sleep=true
call from iscsit_close_connection() and has ->session_close set, while
iscsit_handle_time2retain_timeout() passes false and re-arms the timer
instead of freeing when a usage count is held.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 556ae5d2d50..124c9903fac 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1177,7 +1177,13 @@ void iscsi_target_login_sess_out(struct iscsit_conn *conn,
 	 */
 	if (!zero_tsih && conn->sess) {
 		spin_lock_bh(&conn->sess->conn_lock);
-		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
+		/*
+		 * iscsit_close_session() stopped this timer before sleeping on
+		 * the usage count this path drops, so re-arming it would leave
+		 * the timer armed on freed memory.
+		 */
+		if (conn->sess->session_state == TARG_SESS_STATE_FAILED &&
+		    !atomic_read(&conn->sess->session_close)) {
 			struct se_portal_group *se_tpg =
 					&conn->tpg->tpg_se_tpg;
 
-- 
2.39.0.windows.2

