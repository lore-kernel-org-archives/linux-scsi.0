Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EAB271466;
	Tue, 24 Jun 2025 11:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766327; cv=none; b=AE3ncefoTvYRveLS1oofQUATpM96rRYW0GJwGtgIGKRx5NAGqkNYQ5EYXZchKNk1EV3PEmhqcQGEIV22HD9d7D7+o6simALJOP2HxQTmRtAQsSVy6GB1B7J+FKY135SuN4Iq0zkjFUKLwg7eZlsuMbK139ug6FeJxNtK6wNq2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766327; c=relaxed/simple;
	bh=tapvvsPYWY3CJuWC+udPR993vigkLIE4IN8OuYjkBZI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=LQPpMmrEtFE7FZaaTJ53QMpXOPtwIN1uhD+qHnVn/YyXQFPvJ/h7UmVLmXYvo26Fv6cjd8Jr4P/eRgFvkW5tPhQPew83bOPwYGEgXctaLUIu19fRQ1BELzX7ulkOBbaD3hEGySLXygycE/n3SsCEm+4ZYGe8qR/h/uoMhV/u8jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=JHw/NrKu; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="JHw/NrKu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750766314; bh=0r/rCsSB8r1bm6A+gvQ2n23zST+AWByZPBuZEAmtnYE=;
	h=From:To:Cc:Subject:Date;
	b=JHw/NrKuJoiW4RtkAwLpOYQhC3qsYNmqwrruCndi/NlTCzlKxoHk7WqxARSIgybR7
	 g9RYPp6zkrRe5voAk/LiBoK4ViQ7RPWYTQl0UrdelBml0JqXFgIa+MUnpiCcIOd0so
	 +NothF8QSsrzzCDlyNPkzW+q1Xq8FjU9LofuYSbw=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.161])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id EA091C23; Tue, 24 Jun 2025 19:58:32 +0800
X-QQ-mid: xmsmtpt1750766312tbicdk9an
Message-ID: <tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com>
X-QQ-XMAILINFO: MyzM/wvJS/656oMF3GB7gRl1PV9ALd1QEHSLZDwgZpD+Rp5H9EhZV/Hr2fybcG
	 CB8ogugEolpOlKvpHlk+ypoccZjw8Svo/J0BvnZPRWdZybQQeUPK6af3hNjtHKugrs3Rn8j7Ilil
	 mLGffjjvgkNnoA/hzadx2lRN7Wi0HxgCuXQKgDuGG6dgZtWCQypPvkVcYZmord17Cjvtm8c6O12w
	 sTLpSN/5L2ZZSFN0/km8cIaQuwev6mQKXmXg/f0SdHprd2sbN73ax4ghqfDDVgh45nXjKeUTfjAt
	 zU2iOYRZuSTQCnrUYMFrojU0QqEUqN9Md0F+6g/J+Al84NyvRT8VHPYSpK6NyA3r9mwt8UI2vYfu
	 xbOop21e0BXxlISn7AJX4AVwNUOMJYThKDK3VpmwFRvlS4mco34hbgPN1GRaLwtVAlbSkIyCzJFU
	 5dVr5FDKzPvYFrwPYiNGcUUIW3sZLAO+94ohFZ4S2y9d/+BombDNI388+ILJcS5xSWXLbLp4kuYr
	 RwR8X/7ppCu9lUKwSxJ2yyjIyasSdNCGFp3JYi3DW9X85pvMPssaE/fb/Hr1uTL0+BN3qy9eyn1L
	 jhZOUHuPOikUvxL9AL/jxqZFGIEapCF4s5vj7Fsal0pZGZcKR5T59nZZ658BRlwJCnK5ZHQlAA09
	 D8nTHdQbekmJuuWl+KYFfZ/O2cFFde/Kh0PrQat28VnTsYCEk0p69CpjCRWvJ32Ok+3L66sWSc6j
	 IIsVlztJtJCaMR8IM/DRimFx0m9enZbF27ZZ2apWv9rvBmAIda1KMnNgwtoJglXlnRnZPbFwAX2r
	 cCiYBzZFYAVhMjMv4+xs37zxVakTplCCSbsCQURY4lQ/xRMg1in8WmSKbs7GRj0+I/Mm5XTdCP+h
	 iapW1F6q9OAW07JWIqQE/KYqMd5vltf/QTPChomG7itdjut3s9gruW0UB5aSU2+KfLrBOOq8QZIE
	 cl5/C0tixF6z+f8QLeXPX6slwfIIc95QFvgjdtZREe721W+5CAp3t3EZpJlOXgMz8XdW0Lrgm5+O
	 rdxKdQ6JOqwOdK4ZKtcDCJPx4aPqdSjoGTqUXN5ZFKDFjyggh8
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: jackysliu <1972843537@qq.com>
To: anil.gurumurthy@qlogic.com
Cc: sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jackysliu <1972843537@qq.com>
Subject: [PATCH] [PATCH] scsi:bfa: Double-free vulnerability fix
Date: Tue, 24 Jun 2025 19:58:24 +0800
X-OQ-MSGID: <20250624115824.2579291-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the QLogic BR-series Fibre Channel driver (bfad),
there exists a double-free vulnerability.
When the bfad_im_probe() function fails during initialization,
the memory pointed to by bfad->im is freed without
 setting bfad->im to NULL.
Subsequently, during driver uninstallation,
when the state machine enters the bfad_sm_stopping state
and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again,
thereby triggering a double-free vulnerability.

Signed-off-by: jackysliu <1972843537@qq.com>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a719a18f0fbc..c21210064fbd 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -706,6 +706,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.43.5

