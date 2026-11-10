Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323493;
	b=V7BnDeCnKqcu6tbDuhqVlsS7rIupJV5xkhDvpnS89dLk1AtEM+NTd8Rj2KFVse3U3ZZA
	 qQyQKC4PgXesYHex5W3NSQRjPh/IXqOywkKtnD+fAVy9qejjpZmIhxOUsDHKk62FHyVDk
	 vn9w/S+w5wgeR5Sz6lfBQ1R4DzBfHENJIKTFHitBD6MdGWP/kY3gTS1VSIqEkN32GqtP1
	 pkbNpkq69t0J3KZNufRUHE7udEFaQNTtH2vmHZUn6G6ktIy85D/LEw836pt9Bf33oXXtM
	 1/77pjj42B7zga3xaq299l9vEAb9yoQs1XaI+VQfnw+oUU6x47nNi2VqTOVuVq9lFQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323493;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=8/Zl3PTvKJJWZps1rabn4MLPWpxfNyPYBrECr2jn2Pk=;
	b=aiWrvzuUdvhY72bMYmdbUVGrPk16Jlfx+E/dk5BbdCf9lQpc6XZi5tMhOgLDjmVv7bNp
	 fMpLRQf0hQQ2cH/UQWF2EdILuiaCPBCW7DtLf5TYjrd5pxEdjDBwydI++rw1iZq9Gjreg
	 /Wk31dJN9qpw7FpBmZS5fqK9I4WW/Xwms00Z2LvEZ0X5qX9JX8Pa0talK8Al+s1bDg7oH
	 J1gBTwUt6t3yexxuXhpQIimzO8V3D4uVeJVDMXwne8jvdud46XosOundY2ynk8+periQN
	 cd6adtF+je8qM9HD94RpHMO/uW3UIFUmr+TwSv796TFu9a2HvXnMcWj9+wOSmzFgL0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=B2jKpzdO;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C41606A320;
	Tue, 10 Nov 2026 15:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08C41606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=B2jKpzdO
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jP98y1JBJz5BNS0;
	Tue, 10 Nov 2026 23:11:30 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794323490;
	bh=qxQwU7fPNHyXKf8ie/RVJscAvIYr85HLCTBWhrfda50=;
	h=Date:From:To:Cc:Subject;
	b=B2jKpzdOXk+ewm8wHZn8M+ZQwklInlIOkhb5963biyYB9PKeFbvary234vHar0+ZX
	 eRox4teG6Q487IlnXqb+ZBxB2710FljlAEM27iARFrKH8BZVRSEIo6D+SOKgnlCvq9
	 oU3P8ZfgvtIPsXt/TuKPO4fLMHipb9WqBYp8smEdKF7KJ4ZhmD2mhSwv6352pUL50j
	 oleuM0XEokRPeDWS/8rJjbLWeJiaxqBexachFe9srKSYu5mcXEFL6gjpoVdDXyz1up
	 sKvhrn4VGcASFALfvWZhEOmS+UMkzu+0eWFWCcIMZfh4Qks1ip4ZCdYIxubYjnyYtN
	 QdrHWDz+gLUEw==
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6AAFBMOK034831;
	Tue, 10 Nov 2026 23:11:23 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 10 Nov 2026 23:11:26 +0800 (CST)
X-Zmail-TransId: 2afa6af3341e41e-25a3e
X-Mailer: Zmail v1.0
Message-ID: <20261110231126279OKrUUjTUMgoJ1kpbNZrCV@zte.com.cn>
Date: Tue, 10 Nov 2026 23:11:26 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBzY3NpOiBwcm9jOiB1c2Ugc25wcmludGYoKSBmb3IgdGhlIGhvc3QgbmFtZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6AAFBMOK034831
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 10 Nov 2026 23:11:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF33422.000/4jP98y1JBJz5BNS0

From: Shao Mingyin <shao.mingyin@zte.com.cn>

scsi_proc_host_add() and scsi_proc_host_rm() format shost->host_no into
a 10-byte buffer with sprintf().  host_no is an unsigned int and can
reach ten digits.  The %d output plus the terminator then overflows the
buffer, and a bounded format would truncate a ten-digit number to nine
digits, colliding with an existing procfs entry.

Widen the buffer to 11 bytes, use snprintf(), and print with %u to
match the type.  Ten-digit host numbers are written in full, the
overflow is gone, and W=1 no longer reports -Wformat-truncation.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-204381@kernel.org/
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
v2:
  - widen name[] to 11 bytes so a ten-digit host_no is not truncated
    to nine digits and cannot collide with an existing procfs entry
  - print host_no with %u, matching its unsigned int type
v1: https://lore.kernel.org/all/20261109113810258gK5WuYWQKt0HsI2ikxmHo@zte.com.cn/

 drivers/scsi/scsi_proc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index fdc355d783da366dcdce21949d9a20e43be474fa..6a4324c2e2b5d26c65b9860ca4048210e6044fb7 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -221,7 +221,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	const struct scsi_host_template *sht = shost->hostt;
 	struct scsi_proc_entry *e;
 	struct proc_dir_entry *p;
-	char name[10];
+	char name[11];
 
 	if (!sht->show_info)
 		return;
@@ -230,7 +230,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	if (!e)
 		goto err;
 
-	sprintf(name,"%d", shost->host_no);
+	snprintf(name, sizeof(name), "%u", shost->host_no);
 	p = proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
 			     &proc_scsi_ops, shost);
 	if (!p)
@@ -251,7 +251,7 @@ void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	const struct scsi_host_template *sht = shost->hostt;
 	struct scsi_proc_entry *e;
-	char name[10];
+	char name[11];
 
 	if (!sht->show_info)
 		return;
@@ -260,7 +260,7 @@ void scsi_proc_host_rm(struct Scsi_Host *shost)
 	if (!e)
 		return;
 
-	sprintf(name,"%d", shost->host_no);
+	snprintf(name, sizeof(name), "%u", shost->host_no);
 	remove_proc_entry(name, e->proc_dir);
 }
 /**
-- 
2.27.0
