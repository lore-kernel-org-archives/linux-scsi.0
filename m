Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AFD21B9CD;
	Thu, 19 Jun 2025 04:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750306105; cv=none; b=PrJw1QYYIiJ/64jUlLgXYqSFA3051YIjelDdzrLPPMvN/zI93IiGkfygVDs3TPdslQ+YVs1RChtrAt+B1VMwkyTT4n5no/dzxqRMwGY9zncK9d4+HL03XnnUit8SNT5K73C7JHwq0YZAq18nKZOPxixlHCZ4X4el7w9sHYKsfZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750306105; c=relaxed/simple;
	bh=G/lWRC6vf9NNCYMa07xLyuX3wAYXtOBJwC4ah7z1j1A=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Bc5pfL/+ajqgom6ZCtWu8VDcYDd3q9Ekhwk1UXVPxjFX6hIcm4II6Pj7ME9aHsVIB4G6XYi5rrlpaf4RVI1OIqUAqw5wsOYwQJ+iiJHKEHOe5An/FVAfTgNr3gJHFLIcwPmWpvoyaTDOKIJNHXxwJOmcib3k3/eCXH+NIIZLybo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=zPlm+Foy; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="zPlm+Foy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750305790; bh=VsBNUC6tNPPt17NA81srEZ6c4UsR5q8Bbx9LElc/Kuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPlm+FoyByMqOo/Yz3I3sELlM2RdQDrAWhMyoVie8wur1JArdK9Gx7r2iq1HjKnMn
	 TN9sTN0LPMcKTwmiiaj8d2ZezB4iHVQsUkBh5UsUVyApxnUKgtqgnn4qSu2uI7tjK5
	 ACOq99kPDK51Qk7/JSxIDxoOQgbyD8Cak1FKzwJM=
Received: from VM-222-126-tencentos.localdomain ([14.116.239.37])
	by newxmesmtplogicsvrszb21-0.qq.com (NewEsmtp) with SMTP
	id C918AAF; Thu, 19 Jun 2025 12:03:09 +0800
X-QQ-mid: xmsmtpt1750305789tum2cip3k
Message-ID: <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznV5Ba/O+pqnT3QLjosrYQsR18H6EWQDLX9ZBt//SgHwErsu3x09
	 KDrgXvCvIYVWCrl/e03wpTy1sEySScO3ScQqn0VVnkguhd7J4/HJSC2fgLHBYmgJYy8WCMPgkJvD
	 IFH4BUw6RACDTiv7u+tDwSj8xZamdwh7IuRlwJMwh/ZxTGY3Bx9mbsHGcX+mXzT1FR4F4fNsbeDI
	 IBqJMuu+EuhEGoQiFqHQOVIXSIYCBSPWsuyJXRGo91wX/JbRMuykdXER0sab+io+dsX2/dMg5owl
	 AFLZPjirBWBEgbMt/SYUympBcwA+Nj40muO5lECDa+5GUcqq9GZpcivBmLowgQeSQQwXopLOAap5
	 qcb2WmRWgJiDFivnfTzrWridi+6yU2TjEpyXVsz6pe7R59Vk/ULKtJt2LOcgVMXGyMEuvYMjk9Bc
	 SywMlUetOAyPVjk50Q3dDubGk2mfjdt85O8fp9fg1miLW5NGdwAavAG8mY3ygdjzvn+cBumhinfC
	 smMH/68ayMTofubXGlPoaGti8mqj/myerczE620xcQFxu7hR1b+dUHmxLIc6DnCWdeG7/3y8PfHT
	 f1QzyzZvXc4g19F/wIYrO8IUN6eaIABeIehkJLjO998dmIZhhCp9Fp5anpvP3ybAjlmj54dgDYHi
	 fc4TEv3Qd2Ltsmd2hQArXE8w1YhV6qwwRM8jQ4MnthrjbaNsIQrh6YRN+I9S9gnMSXg2By4rEUZ+
	 UcRGOV/DPiM9yFsv2zobSAILM1JsUw9EGZ3YR8Jb8stK4d0q6Yq9hYb7cVuZVZHMwnoGCWlXMZPS
	 5UpBbXg9N3xVjCc7oE3ZAuy/6oV9A/ptBU1tg0SVUSbpAK2fx3AKsX4MF9YEInCoed3n3mOSr028
	 9XUg+jET+9AGOugNwZtJh68787hsT/d1ZnFz5c0xATYnWmWOCwEJGPm3wae5Wz/J2sFlL7NzRpxZ
	 Bbusq0xGhN5jKeUrLvWBI0WR0gMeI0pxHYX2FMGv4pxDDAXWMLnDcmx63X6MneT3ScxwmdB8ixIZ
	 EsDx9eTL0mU0puWcsavOXgE7sifDuVmdts58P14w==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: jackysliu <1972843537@qq.com>
To: bvanassche@acm.org
Cc: 1972843537@qq.com,
	James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v2] scsi: fix out of bounds error in /drivers/scsi
Date: Thu, 19 Jun 2025 12:03:02 +0800
X-OQ-MSGID: <20250619040302.2360386-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch, vulnerability exists since v6.9

Out-of-bounds vulnerability found in ./drivers/scsi/sd.c
The vulnerability is found by  is found by Wukong-Agent
 (formerly Tencent Woodpecker), a code security AI agent,
 through static code analysis. 

sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
Out-of-bounds read vulnerability exists in the
Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
The flaw occurs in the sd_read_block_limits_ext function
 when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
 responses from storage devices

A maliciously crafted 4-byte VPD page (0xB7) would cause Out-of-Bounds
Memory Read, leading to potential system Instability 
and Driver State Corruption.


Signed-off-by: jackysliu <1972843537@qq.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f6e87705b62..eeaa6af294b8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3384,7 +3384,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
 
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
-	if (vpd && vpd->len >= 2)
+	if (vpd && vpd->len >= 6)
 		sdkp->rscs = vpd->data[5] & 1;
 	rcu_read_unlock();
 }
-- 
2.43.5

