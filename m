Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733166;
	b=yXW5PIgfI2jur5cK8o/3/1KJRnEKCzCsmEs7hyW70pNr5e7Hx1ENnqMpVoLIjHwIh46f
	 QIXd0yQY0Ny+Dt6o7kV4H21v84nhdLhoYjDI+lEJO+tIHxTfCG2KIPGNL/JxvIOr3zsTx
	 E/jl4kJczAvSvy6F0GM3wJpgohJRf2ulP174MKHQ3ymifa5hjqVp31V6vzl9TEqfsrXv3
	 wuo+nXBolJbO6STC80D/pY7I0KwUgSPVgnxAJO5R3jLOOGXlLdtxlgSKy5y3Pq6UdBu9a
	 kmzO8VEi2suR4oN20zPkHKXXW8aU+P2YyaKLB0NkTh64Sc2PpTyTOoayBwLfW7rLJaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733166;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
	b=gzANzczosp8ED3hcLRGFmf3KtRIVw8UJMvziHVysH2XouEVGq3BGBcIrkjbULP0aHwCh
	 vIkeQubPi2WK90dlZLytzMdHVsHkIb4fa+0gQFD2Ed8zv0HeqlNxtWtUT+5PapWgQX/eK
	 eyflanOjfqxQ8Tu6i2bTutk20BVMP9UUT/wOl4vClQMhfYMefElKpMZ3lkfkAISc6d1I2
	 jnzMIZSBpvIrdz0AxITPm5kdtqw5kn4wNG/LpGmhG1kHc/8EBGzwALaZtwH77H3xDvSK1
	 1v/lb8hjJ2C2nrewZZMY4r6RRvpbU/zRjPmYmEWxgTW0sZDNN9bO80k5085pv08Sh4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ufvbUa/C";
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2760606A323
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 08:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2760606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ufvbUa/C
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb2893531bso1981753a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733165; x=1795337965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=ufvbUa/CyNW0QD0sqLv86lbibrg8v63JuwXnM1pa1hOYQdWUVenxsUMM2kFXbx79Ny
         OAbopnSnMkUkMKjjWSXq4lqymggXuo01tyM0LiselI0JGGsIHkVmVv1naJpqw1KHf373
         QY2R+TGyz5zqKN/cs74io7f3GEBznRH656w7mE0C17ntInTbvIwwKDTpw2PTdlA9WST5
         TxLT/CmdK3E4/3pWOj0kA0iR0rr67q97i+IYdQtqDq5mKshfQGK1GOdqXEYPO8ASF3AD
         klpE2OffPXghSxNUk6GK9J/WKYdaDyngjV+4KQjgBUKyQGFOXuNBfozb+n7p8ycWsNTe
         y3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733165; x=1795337965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=trMZaZbU6Yos3RBjwnWKw3Z8sjp9mCG4JwuyQWAMLR0bMCJ+K/cveV1g//X+XJoZvZ
         9sjOVqnLanj8R9EXNvjwZPT8WAL8KQoyrw7kIWok08Qr0YN92pDZWJWguC7T/2o62CnR
         mNeSBkEGJ7uqoIIridF/g3FB9Jbi5kmQsp1hnfCQVCCe7wYS53rFJj86Vr25/B1yIM0K
         3gfApKFFxwJYsYsf5hks0kuZ6t+6JGNcHW1RHjF64J9af9r76CZqj9uGOwGweHpkYsBB
         q/POQijle0+KH8Zf0+XUpIWu4jHaiIzmyahCocJPEdsVxuZqSGSqf0RcuZEQcC9ew1Jl
         kbmQ==
X-Forwarded-Encrypted: i=1; AL+hErFVjiC+Bjg3cvoBk5Rw01+zkgoG5oU16X7N7d8P+YMnd3gXpChLcQjuwN8aqELdePOvegtjS0/jadUL@vger.kernel.org
X-Gm-Message-State: APuU4Z8G5v0A7p3NUJEYMQt0lWPNggktlrHPW3gi6+WLNCfk0j/zpbf6
	nlUpi6J97WQg5Xrey4+z8yaDUEp0+MtTMl+vcdyxatMAeJooToZHvXTW
X-Gm-Gg: AYBFou0T+59C1JBHWXivHRtU6JPtwNJASD3mjd5+5h6G3/iggZHwSzs0Fhrlhoe/cOl
	grrsA//DtXlpPZhMgjreNtsme7MBsLlRkeBFs7OtzOBW5QwMoWEDmXfqEFuR02O6WUcHksq/7/M
	WdgffyzhlI7aRNN45WYD2XIJVmnBJr44OCEDAdXW48gbQuPKAjR/afyg9ZKPFb81x5kXaSfXYx6
	Sn0rF+v0T0uWrDzlfYGRY/ZiqRkJlumu/uKSjkJsH4T90BAvCv0bHe5XfN5bNQgeabqXQb9omjT
	vtlu+c50RiGw6aobA7beIWIJI9thOr+IOG5RY+rpX224/6x8WRtKpcZ1rYIB0T2mZHjBk4Xq+Oa
	MMFEDSpDxuFRchtbvTUlWzr16htZo+xmJKRM0ovXPYIOWdRhmh9M6lpogFPQqLYgNNWSiOSJ41h
	Kdi5RsrTfz13eSEgFORtb+8hEL8C1vertxgc64VNHtVhQz2N+x5Syok/5O3BqVo5pMGCByNVJOO
	XxfMjANW/+f4ijmf9wMhIYKGPQB401I09Jmexgm4OlXYDr4MliE5Zq49aHiVov7n2rj7U7QEGC0
	XAmi7uL9BEmkYVxeaotlnQwRI9x7MBGSDn/1bB4jszRmhUkKp9DOZkOL7f3hebOCCuHhgHVXiVL
	dlBGNnwhZFUWHBCWdquoxxzhKVzPjWlhJxphV5QQiBs1+SwDCF9uWortVyhdO2zyLdaUvc2YnxT
	IuLdZbNjFcZU8YCee4fERu22PYs3ldg9GedS6tHxzeFLpDFuIr9dpJMCBtnQ7e1EyTLtdfdSE5D
	vpF24b14rpFwDQw4ADgGSmTALUpAp9mBYdnGcCCMgMJvNKOFlO5J4IVNORQkKa6JNG7AFFjrOdi
	gALnSJnBgw==
X-Received: by 2002:a17:90b:498e:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3b1b0ba0ac4mr7507738a91.24.1794733164961;
        Sun, 15 Nov 2026 00:59:24 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:24 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: target: iscsi: factor out iscsit_stop_kthreads()
Date: Sun, 15 Nov 2026 19:27:44 +1030
Message-Id: <e6199ca99e81a80af4c4c8f43885c628377b22d2.1794732723.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794732723.git.danjwade95@gmail.com>
References: <cover.1794732723.git.danjwade95@gmail.com>
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

iscsi_target_do_tx_login_io() stops a connection's RX and TX kthreads
and releases its thread-set bitmap slot inline on its error path. The
next patch needs that same teardown from iscsi_post_login_handler(), so
move it to a helper beside iscsit_start_kthreads().

No functional change.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++++++++++++
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 ++---------------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029..f4df5518171 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -643,6 +643,23 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	return ret;
 }
 
+void iscsit_stop_kthreads(struct iscsit_conn *conn)
+{
+	if (conn->rx_thread && conn->rx_thread_active) {
+		send_sig(SIGINT, conn->rx_thread, 1);
+		complete(&conn->rx_login_comp);
+		kthread_stop(conn->rx_thread);
+	}
+	if (conn->tx_thread && conn->tx_thread_active) {
+		send_sig(SIGINT, conn->tx_thread, 1);
+		kthread_stop(conn->tx_thread);
+	}
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+			      get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
+}
+
 void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsit_conn *conn,
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 03c7d695d58..02c5f6ecbec 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -20,6 +20,7 @@ extern int iscsit_get_login_rx(struct iscsit_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsit_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsit_conn *);
 extern int iscsit_start_kthreads(struct iscsit_conn *);
+extern void iscsit_stop_kthreads(struct iscsit_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsit_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsit_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca3..d56b28446d3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -362,21 +362,8 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 
 err:
-	if (login->login_complete) {
-		if (conn->rx_thread && conn->rx_thread_active) {
-			send_sig(SIGINT, conn->rx_thread, 1);
-			complete(&conn->rx_login_comp);
-			kthread_stop(conn->rx_thread);
-		}
-		if (conn->tx_thread && conn->tx_thread_active) {
-			send_sig(SIGINT, conn->tx_thread, 1);
-			kthread_stop(conn->tx_thread);
-		}
-		spin_lock(&iscsit_global->ts_bitmap_lock);
-		bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
-				      get_order(1));
-		spin_unlock(&iscsit_global->ts_bitmap_lock);
-	}
+	if (login->login_complete)
+		iscsit_stop_kthreads(conn);
 	return -1;
 }
 
-- 
2.39.0.windows.2

