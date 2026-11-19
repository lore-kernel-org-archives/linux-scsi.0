Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072578;
	b=OTWu90GL+QTF+iIClUVKxk4VMXaRXHa3RhFwesEFUNpXdDl7bbqvPgF3uCWsrKIMIAKl
	 GvH5WXQMSIo/SC+jsIrDwvfEphfxpsYQ2mjdtltq+WDyRRH1zki4O31SyEj3maXzX//Qm
	 Tqtkzl07O/TwRJpy5ntNMdBne7roHCJ3aEX2UIbCxn4QYEpCoyxGtpXTCkfI1/RWjpGYU
	 qm1eivOVl8DuVVCsIjkPZB0P6VjCDwGtYwQHfCbYWGaRth7v3Dw81xs9u1XyVii9qNR/t
	 X6pzaSx+liO/aqbEhdvec4uBoaecvHPc/153AtnUztHVq1/xPjJ2To7Xp0yRJyQiWog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072578;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ley7Oxra1LH46R1LcXoHmPiYUD4v2OIpHqOBZ/O6LaU=;
	b=wUIdjkHWBK8qQtmU2M5bglMXfmZYsCKfQgrnjoDeb9L4GR3ggciiWFAREnNLEBit6n14
	 EWAPVyT+JXEPfPtRupM15lg0urkvRQUem/Ys3AeJAoPuSgSjEZyYxGteUNnHjCCvu3p01
	 HsygZTEGIUjolgZFNpwuyZVVm06iH3WhcEsxPClh28T9oaSeIr/jBkL1M2ItysIOYtME+
	 Mw4E1pII9Uoe/2YWJiGBaKvUQfmrb1NpDT0Oidsw5HT0l1CsvO505RW7L8JeBJNf3Ii4B
	 EaUKQ929rmBUQgYL9+6RvZ8mRGDsqq1CSlybUoDLC62GU0RDpjlALRBAcjmfEmVr1lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=jHMJz77h;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46363606A320;
	Thu, 19 Nov 2026 07:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46363606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=jHMJz77h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=jHMJz77hoiRfpPvwH2bEL7sE92qSSvbHxGCNuaplT6xRYCMeXTgU+Q5f+gfRdSn11WnQcwcp1ofpF
	 inDX6aMtE1O+jVPRN1ZSjCE+OMtlWibKi7h7r6f1SAdmcZRIkBx3HivNWut4IJz9FnxSlH8YqeSf89
	 qLps3RoaXCKvcUJk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96afea23af39-208ab;
	Thu, 19 Nov 2026 15:16:13 +0800 (CST)
X-RM-TRANSID:2ee96afea23af39-208ab
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56afea23a32d-f43a3;
	Thu, 19 Nov 2026 15:16:12 +0800 (CST)
X-RM-TRANSID:2ee56afea23a32d-f43a3
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
Subject: [PATCH v3 0/2] scsi: ufs-mediatek: fix va09 regulator lifecycle
Date: Thu, 19 Nov 2026 15:16:08 +0800
Message-ID: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
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

Two fixes for the va09 regulator handling of the Mediatek UFS variant
driver.

Patch 1 converts the va09 acquisition to devm_regulator_get() and adds
an .exit callback that powers the M-PHY off, so the enable count is
balanced when devm releases the regulator.

Patch 2 fixes the state desynchronization of the power-off error path:
when regulator_disable() fails, the M-PHY is left physically off while
mphy_powered_on stays set, and the next power-on never retries.

Both issues were found by manual code inspection of the va09 error
paths; neither has been observed on real hardware, and no MTK UFS
hardware was available for testing.  The affected paths only trigger
when a va09 regulator operation fails, which does not happen on a
working system.

Changes in v3:
- patch 2: restore the M-PHY power state when regulator_disable()
  fails (phy_power_on() plus the va09 SMC call) instead of forcing
  mphy_powered_on to false, as suggested by Peter Wang.  This also
  keeps the va09 enable count balanced and leaves the suspend error
  recovery running with the M-PHY powered, resolving both findings of
  the Sashiko AI review of v2.
- patch 1: no functional change, the Reviewed-by tag received for v2
  is kept.

Link: https://lore.kernel.org/r/20261118032015.974-1-laixiangwu@cmss.chinamobile.com/

Xiangwu Lai (2):
  scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
  scsi: ufs-mediatek: restore the M-PHY power state when va09 disable
    fails

 drivers/ufs/host/ufs-mediatek.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

-- 
2.50.1.windows.1



