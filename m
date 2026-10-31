Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793456501;
	b=q1UZpUvCniJMMTkpSS1eLDiA+ZPd7h6I0AauwzxzHwo4CUetqhXPFHCi3HnVzpsxNQij
	 Yiijsp/l4EBXJH4H2FFzrR0fcC3Fuoot9Qmxxe/JvDk5q7XDILwsukXixEFV1aeOQ7Qhu
	 VRK1HoVoUjOleVZKGp/2Wvcmz66oUgFkCHWO305Z0bKj2AdtgPJKxVZEFNIegTC/7VTeS
	 jahYOl04erFncgzyoVCEV7Z4JPmllCzky/RF/KxliCkHE4QWfPBo5IsdSGQMaD89lnH1V
	 /KEO89opFa3q9BMn39LyZPL0Vec0kJh6N+9HY1E3p8qeMkjlGaOmAkriRozaT1yJMlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793456501;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=P8bqr59X4O70bBUBeBQOEpLRbZ5kC1qr02XdRj51bCc=;
	b=j5KcU4kc74nYgSh3NGkCmzsdboB/YnNqUC5pejWLbG9pzjnmPsfbz/Os8iedxOR3GRNd
	 uYs5t9Y6u7wUHaS4O04TqCbuEc+h85lvE7Ph74rpBgUYzWubz2fdeXN1yOnRHbSLfyv3I
	 42bBe44y3Xh3u1kb6v0M8jL48soD5LmtvKls+ljuPLR78GoIbESXQfiLGecwPA9qJKKks
	 z9ElnxZmjBJql4ZoFmB9lTBzWaXEl5sv37ftWD8/eak8lIdCB9oPa6l4eAvbBjgukX1XH
	 AsL0R7IjHvOnLfQ/nJ/9FM2GmqdAFYp412W56mPHAoGRIepRK2mvGyozpvmI5S9Ey8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069D606A31A;
	Sat, 31 Oct 2026 14:21:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D069D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jH0X309rXz4yjjC;
	Sat, 31 Oct 2026 22:21:39 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 69VELTce055656;
	Sat, 31 Oct 2026 22:21:30 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 31 Oct 2026 22:21:33 +0800 (CST)
X-Zmail-TransId: 2afb6ae5f96d23f-0bc39
X-Mailer: Zmail v1.0
Message-ID: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
Date: Sat, 31 Oct 2026 22:21:33 +0800 (CST)
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
To: <mkp@kernel.org>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBzY3NpX2RldmluZm86IHJldHVybiBhbiBlcnJvciB3aGVuIHRoZSBwcm9jIHdyaXRlIGZhaWxz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69VELTce055656
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 31 Oct 2026 22:21:39 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE5F973.000/4jH0X309rXz4yjjC

From: Shao Mingyin <shao.mingyin@zte.com.cn>

proc_scsi_devinfo_write() calls scsi_dev_info_list_add_str() but ignores
its return value, so a write to /proc/scsi/device_info always reports
success, even when the string is malformed and no entry was added.  Users
and scripts then believe that the quirk is in effect.

scsi_init_devinfo() already checks the return value of the same function
and fails the initialization.  Return the parser error, but keep returning
the number of bytes written on success: a proc write handler that returns
zero for a non-empty write would look like a short write to the caller.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index cfc259fd0141..b1f3bcd739b4 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -688,6 +688,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 {
 	char *buffer;
 	ssize_t err = length;
+	int ret;

 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
@@ -706,7 +707,9 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 		goto out;
 	}

-	scsi_dev_info_list_add_str(buffer);
+	ret = scsi_dev_info_list_add_str(buffer);
+	if (ret)
+		err = ret;

 out:
 	kfree(buffer);
