Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69FF369985;
	Sat, 21 Mar 2026 10:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774090756; cv=none; b=kLMApqht2KKFoQNq6HmSBIbcvJmpTc5xnmZINpbcg1RUzDpQal58WwxF4tZrJD9eJMGIf5ZCHPwDWNKVvfffsO+qt/1eYUao+pHZ/kA9RIWHp1uWgyZZhToxNXLSg1XevbZR/gTJi7RW/JZxOQbAP3B3Kjp7O98HFZ2LrMb3TX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774090756; c=relaxed/simple;
	bh=9bxq/g7yOvNBGI8aEcT53+Sb7wb38f1rPYvFAI3t1H8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kz0nMr0U32J9RGdc9TtYrUiTALnPAU+8iZv/Cr7Ss2/jdUhseENbUOXNTtq+DP+zc/tL4i4oFZd04AjlNI9ziU4vsadq/tapFopdQ7rFt0aB/jP0yJcVim6HSYx/2cQVtXCPaJjEUumLmHtyQFEIis6H+lM6slU3Vp9lzWMC2/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=3TK0i+2p; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="3TK0i+2p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1774090751;
	bh=VgB5yvKL9jWXDpmNk27VpCqTFyPSfPmJHs0D+WXgb3U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=3TK0i+2pJNpM1PSZDLZk7gNcmdJheufqkiAdO+FsLpPzM/L50kAsdCCN9kUwzIQn0
	 ZjYXOgegnJrmYZ4K0El1qEVwHDHn1/MYqpRj9d1MEgAwaaT8Us7TFloDytUPg1KIDc
	 IpE3RjWbJhvxbWVEtVTwBULtKOOxfrWrd+2tJy08=
X-QQ-mid: zesmtpgz8t1774090747t24fe09db
X-QQ-Originating-IP: W3JAkyEoNGgs/ffoNxQVpgQk0SCl1GkR3HxJrkrZLgs=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 21 Mar 2026 18:59:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9495204049230802472
EX-QQ-RecipientCnt: 13
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	kexinsun@smail.nju.edu.cn,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg
Subject: [PATCH] scsi: iscsi_tcp: update outdated comment for renamed iscsi_conn_set_callbacks()
Date: Sat, 21 Mar 2026 18:59:04 +0800
Message-Id: <20260321105904.7726-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: MAlUHnGeA8XKToyLYZNgiGqxN12K5+qhm0yGEnX/YBmKHl8mxNy+GeMp
	XZMz0ASFozR3cdMOjQSv/r9+MY4QOxBczx0KG/DbtSPlSZMDRTQQ/hAaOzoPITsi4M7rpsv
	WoP62YxxRUuFY8i8jy/qYTbW/cLbVrhy6IuKGmGxf1mu0qFAY7ELJwLQXAbXq00Gf+NA9mS
	I9WT8ojlZOUr8tE9e+bxm+ozDsibTpyobzV/mFGUOgRCwbqp6xXhskeqpv+Ff/7CJxHjU8d
	gg0WLV6CAQ1juj0DUI1+5aNi/myVt1pi49dP7LzFfJuAmKmc7WHcFD6uKT7lYskrqtSwc3v
	5dWMJaDU/epzsEnzXdGPsuof0C2+T9g9aNN+3kbKW1mDb0/t/uyp88sTH6c5RCC4YR642uD
	+VokG0QzJ3Pl58IrGqZgg/JtIo631BWfRNx8p5Agshf8fFjQpS+7HIK7XogykQHHvS1+k31
	UnZ8PF652MRSgIpyNgbHspvxanaDF5Av1wHFUyZ3hYzi4hBat77evY442QmkDAxOYUI14Xv
	8HAMId378iq0ggbiK+c48YgPc6jGwtdD/iijCx2Iu6fuFSbmDreH+r6sphBuyfqh2Pqrlnu
	qM/LiOMEh2h7zSivFm+HqqLpni14ics1B3mwTxyWMfhrK3nSzm0ygyIGOb0wZInvFiIYi9Y
	DKkemiiG6PKzjtNZaCiRJ7GFPyWSI5CgEbV21gmqLW+OXazj0roK2Mkp85A4mG+Q9MAlojc
	ZzQ/wPvzHUYlmF8KgDdyK+92POACqIjXQAM6wV2hXFWT/OYJK6AkKzqXgIRZtTiyyi7mYF6
	eQY3qwpoK/psLXcK/0FJ2m0szA8Qtua/I0lCuzsuG6aDrwyRlwuWy6aMhkZEANW0mDp42ST
	h6hbnWDULugz/bb7wf2i/PKs9taATfmbU+meskrUNXxg+cNZ73w2iEPvHNf0cv/0VCU3wIb
	+uinJVU0x2SsduiHKlIuis07VEtLIBUP3NVpgMVM5ZRIHKO6hpNR4dDlS9OJdeFj+rgNHXR
	elJWrnF+1J/3XTUdQa6yQ9Mj8T5JYvgMxbh5BXDl9JaTx2WORxxqYcaypB0HHh39EqyNVO0
	9Kq4jIioLFzMHwljkVXWoE=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

The function iscsi_conn_set_callbacks() was renamed to
iscsi_sw_tcp_conn_set_callbacks() by commit 38e1a8f5479d
("[SCSI] iscsi_tcp: hook iscsi_tcp into new libiscsi_tcp
module").  Update the stale reference in
iscsi_sw_tcp_conn_restore_callbacks().

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7b4fe0e6afb2..9260b1c9b0e0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -267,7 +267,7 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sock *sk = tcp_sw_conn->sock->sk;
 
-	/* restore socket callbacks, see also: iscsi_conn_set_callbacks() */
+	/* restore socket callbacks, see also: iscsi_sw_tcp_conn_set_callbacks() */
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data    = NULL;
 	sk->sk_data_ready   = tcp_sw_conn->old_data_ready;
-- 
2.25.1

