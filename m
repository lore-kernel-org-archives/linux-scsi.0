Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F040292906;
	Tue, 17 Jun 2025 09:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750151327; cv=none; b=lNws7FVsmG4rmz+qoBVIAKxBOk9YrUeGV72bwMgSpCKOFfGYjPdb8qRwA8iO17ULAGFxWspsJW5QQ94fYlhfmfiYRfIv83nBocx7jjuGN/KoWK19CRonUCY8mgG28hz4Z2jtScO5h457dwFbSJq/oZnWDh11RkuPnAQtr3fX8Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750151327; c=relaxed/simple;
	bh=y2kpAHe6WXsS++Wx3Pgute+9Qw0FzzbQqOP2DPszjUM=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=CUsGdDKgzPz4ogpdX0wtnnbOOwcb3feoJ9dViCgI1jG8G3YS1p67ScOgDiwcrwManWCo1DG5TSJPIIzfvnbJwF50X33rATCRICNZC89LtLDddoL4BDnbiZ154HPV97bYdLZU+h5V0MH47+CP7g430lUG4niI6B7dtpaAIkjje9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=J0XMvo//; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="J0XMvo//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750151016; bh=hphOaMPhVeReQubhMjEgQY7y3BcvT7JT2QC8BwFPfho=;
	h=From:To:Cc:Subject:Date;
	b=J0XMvo//egT0/n9OK8WI+zsZ8HUGgKBmDMLcIZCl+MSIYyiC6iK27mrvD6gCrGQCl
	 xt8PK8Zn5fYqJGLN+/HU9AaejlVAEJqGpuv6MbRmUqe8Qu3Fb8RvEfkciIM1iSJRsw
	 Fajy/Zg09gKfwH3Bs4jSc7q/E6tSsogS+EWeEA74=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.162])
	by newxmesmtplogicsvrszb21-0.qq.com (NewEsmtp) with SMTP
	id E28CA6A; Tue, 17 Jun 2025 17:03:34 +0800
X-QQ-mid: xmsmtpt1750151014tzvu4q5rh
Message-ID: <tencent_BD16D2DE705D6E27FC5B93ECDEEF9A7B5009@qq.com>
X-QQ-XMAILINFO: OcNQvPIwPRPcCZww6mf1bDJ83odA4DL4U3jXTfU7FCAcFQEuOrwsasSzgo/Jna
	 78pM9VeNIPMxk92QyRRNrxSlouqa0pLOvQGoi5a0SyJwZrcRdCg+qHIbPdr7atFIwjVqAi+/n6ai
	 L+ekxepNmQedfoOs/R2ko3XKV5O/sdzDUZ2PZ4AIw88IrCivCEWtcGyS2H2Y7Y9sW16m1W+WcVax
	 VqnWVwyFU9RkmztHaUxZWFpmUVfXIprh3/z3AhQxw4WQsIDcosl+x+24E2TqhKCtu1wWzN5+Nn9T
	 /EUDeWEQA2N3hXEfRTxokMN7vmJk9hF4j8DEpbUtI1sli14j2m81iYsB+0Ek7C4/GjwCh5XbW5wD
	 6iUBoVNAu2rPsukjuKGWqSt7fmQ6lYJuUiZlqnTEgaJ6Er4fosxKXmIKFPXfzWe5vOLQuOGO7ba+
	 KoEeHTdh8ytIL9i8N1PGpGKyQ81eJvlow73jGK/p4R05wrGcAXWL6/p0A4THFXT4/gYmVjB+Ab3q
	 KiwOTyVf8GEdPvrbt/9zFpauOgKkf1nvWw7qLI8kuB8gUX2Vfgr9zOOJgd/SvOvIL9J8R1FXHpv7
	 kcPabNZ8xuaa4Pusw54RXAcOY/i/we6UtbfkB5beybQhReAn+8/hT3oqK/fg/SY9MPbfDYgBHiCB
	 Xgk5WsGvnhqKpAnluTLnEuoeeaeWBD8TP0nFlD18g1ALoStiYhgG2hukL4f028aTyo8zut4zVy4V
	 NM9WjNs/QmiqswzrASuNY+VE7rRzigWakvgl6MDxdvl+zDvXYddtRpInULKEZTqP1hM5sbY8uO/B
	 oSwhY/bSijfBtkJiODqVO3iDQxuGBxXtFd00SCVXrz+6OMtgNtWqhJTDpY4WmVRmvyXlBhijTGdH
	 xqnDuKM0kdQxEwLvsooiNWMcJEJogpXy4YDWuGzPZOgFhPj9F2U0m4LV2ONZS6mGjtAj5XeutKN3
	 nlFZQ0Au2epd2jYDTX5o1qWztGcx7Zld+bglf5GH2xBchIBgJIAN03jx4lILMUQ8xb5vI0XbD7iy
	 o3oGYI5rjIABL5lOdxyQ5N9tAc9+ZBywmEiNmJItupcFGuUqfMLJBzVnEkX8vGqG/L0aWY6w==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: jackysliu <1972843537@qq.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jackysliu <1972843537@qq.com>
Subject: [PATCH] scsi: fix out of bounds error in /drivers/scsi
Date: Tue, 17 Jun 2025 17:03:26 +0800
X-OQ-MSGID: <20250617090326.753352-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Out-of-bounds vulnerability found in ./drivers/scsi/sd.c,
sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
Out-of-bounds read vulnerability exists in the
Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
The flaw occurs in the sd_read_block_limits_ext function
 when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
 responses from storage devices

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

