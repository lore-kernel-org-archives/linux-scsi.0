Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972027;
	b=nly5snbPWSnh3+vRss88aLXWD0sVz91LNmOC61yly4ggv0fooeOuEW9riZTDq5FTiMyg
	 UT6oS7eyPCcLlJOlf3F2QVFhdVPwAQY/NlNiSrR0S60QOkAsIp8px+JNBt6dH68lULRuL
	 EK6v2xKpiK4z4Z4a3MEHCZfup2g7IcKQsB2pyBJ0YJbDwgH3HValh37ixwVfHMtQdHuU6
	 oj+7oFhVysSeYlIyZEyPlDDFou9i8bS/87UUIMW07OTZYfBzQcZRkb6WV370RRODOv/jW
	 5zQzWmCBTZiGgY6peS890OAptvRP69YOI5oFx9e0susUDpaBZFfLBQ7twT+GZXloIAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972027;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HZRrtyWyhDHM4W5ZPdUJtdgJ8QIlZ3J97mOSJfRbiTk=;
	b=MOMab4+JY1ZhhWmhn65BV9bEoH8JWXHG89iNtAzR87+TYYFFQ/enUW5O5erIq2YsPmrp
	 qyhdLCTmLTE4DyIhZ8RgE6Un/qauVU8Ghv8ZmEE9dJRTOJ6RQy/31iaBomE0zVCcoLBDT
	 liVE5ECFNgMxc+QlLzMa7HyEqEL5jSJ9lq1wZb9MpeDVkTarIZgZKW6jFEFK1u6hr9kri
	 +0Cq7/uhobbTs3rU2r5rGXsdoTqn5xiRoEhbhbpYt9k3dJ1wBjzlLyVk4yg4qf5SafE+j
	 Xacx8ZNQUkGRV6YR6gMsk5l4eHMbd1lRe/GUCkc6e8EpKkql7x8Of781peKfbIPaUHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=rA63Gwu2;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806E6606A333;
	Wed, 18 Nov 2026 03:20:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 806E6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=rA63Gwu2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=rA63Gwu25zVlwyYdfnXl+dOH/KoqIaxHbydEmcGlAkHCUdvy4jwGSJUdHbeNwv01TbaaYbWW9xcpb
	 5cVXbrjR9qH4VQ2vpdQrpFyoKQHYIKbMqPwNCdzXDQbyH62TbAxT/1qKs+4tQ+gLecZpxgstc0nFGo
	 RU2UixKRpq9eEqOs=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36afd1971394-db1e9;
	Wed, 18 Nov 2026 11:20:17 +0800 (CST)
X-RM-TRANSID:2ee36afd1971394-db1e9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56afd1970808-c73c4;
	Wed, 18 Nov 2026 11:20:17 +0800 (CST)
X-RM-TRANSID:2ee56afd1970808-c73c4
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: peter.wang@mediatek.com,
	chaotian.jing@mediatek.com
Cc: chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	sashiko-bot@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Subject: [PATCH v2 0/2] scsi: ufs-mediatek: fix va09 regulator lifecycle
Date: Wed, 18 Nov 2026 11:20:13 +0800
Message-ID: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

This is v2 of the va09 regulator reference fix.  Two issues surfaced
while reviewing the devm conversion (many thanks to the Sashiko AI
review of v1):

- the devm release alone would trip
  WARN_ON(regulator->enable_count) in _regulator_put() on unbind,
  because ufs_mtk_init() powers the M-PHY (and thus va09) on and
  nothing powers it off again on the way out;

- the M-PHY power-off path can leave host->mphy_powered_on set when
  regulator_disable() fails, so the next power-on bails out early
  and never restores the PHY (pre-existing).

Patch 1 keeps the devm conversion and adds an .exit callback which
balances the enable count before the devm release, in the same spirit
as the .exit callbacks of ufs-exynos and ufs-qcom.  Patch 2 fixes
the pre-existing state desync.

Changes in v2:
- 1/2: additionally add an .exit callback powering the M-PHY off so
  the va09 enable count is balanced before devm releases the
  regulator.  Without it, _regulator_put() would warn on every
  driver unbind (Sashiko AI review, [Medium]).
- 2/2: new patch fixing the mphy state desync when va09 disable
  fails (Sashiko AI review, [High], pre-existing).

Link: https://lore.kernel.org/r/20261118014234.424-1-laixiangwu@cmss.chinamobile.com

Xiangwu Lai (2):
  scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
  scsi: ufs-mediatek: keep mphy state in sync when va09 disable fails

 drivers/ufs/host/ufs-mediatek.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

-- 
2.50.1.windows.1



