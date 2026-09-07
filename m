Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C776440B38C;
	Mon,  7 Sep 2026 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808949; cv=pass; b=a0ZWYYvVzKpqbeGziY0niBovjs4WD3JCvC5vx6tAC3KxbQ3RiT2zefiyqQnZXWrEYuAbKQGFUFJvd2da+fKfjSAi0CWcSro3HYrTX5pPqa7MLHvcAhzDa1ZPRkY/SboUt0GZQlbfkDOH0WHXqnbH/F9FqMkYG5lBDN8L8/YYZKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808949; c=relaxed/simple;
	bh=WVcZN2qQ0/zx88UtIawoSa+m72wtgSHdvJZC+985PIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmKaeN+utQN8OsSEofzzXP+u967QWK5YrVlgiXyUENCPzJAVzZo6EuAXNeLD9gq1Q3FxK72FtrimARngY2zK8PUvKgJTiMe1CSOH6ybTB6CX6tKkJ38E60pkWVTh7kUYGsstVPUtkb0oxaOx9UhajGVoXTTG3Xrvgc29HfWL+dU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=WnpwjYRy; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=HjCvzsss; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="WnpwjYRy";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="HjCvzsss"
ARC-Seal: i=1; a=rsa-sha256; t=1788808912; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Mqtx+zC9VLV9peiyhUUB+1sRyiiUkb9oze9ZgNvbX2hf4OZN/wiyQv03SkCjEv5N5i
    itG/Ftef2/5AFeinlvUtxi4rhXkfYnt5jqaTEijGIuRLeb2Xo+B6ZeHp/G6yq8RRSQvx
    mhhY4h0+psN0kGbIWywWi3oIrrknxvzrESbzO5m0Ln3DCPZHblfxvBNUFQ3oUGX7jykv
    PWjIw43ybn9cU7/hqIwPQInWqMiabmhirLFLlLKpfmznxEE5VtAEUf/7Zjsoogf4a9BA
    6egfgC1hNmrgH9dAI6QiDjcs42QwH5jZ5nhazd19Tv/TRj96yVNt3q1ROmLEVQGGzUmL
    CbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808912;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DUSGuKHy21V6+GxO0cBGC7fg9zg1br9ErHo5MOH0l5k=;
    b=iFi8WeKD9AgllmoyVkRQBQgQpyzxz5CR1pwdZOIXyeUGrZ+YZwdrLiQqNG6kUid6yg
    qmCVb6xyva8fvthotLfBZKc+Foey8XtbrpTODGwwCpkkEdFmcl/k/V8XBtcFwzzP5jEb
    MkRpkjxmp9gBh21e9z4ypgzqJ9FoP3zCajAWI5JKhtOUYgnLc56JY9s2fJk1JI6wugPT
    pB7NHKv6P5c9hK+YK/8EU1mjdZs2SB4HhPaZumfvdPWa+WPBl3/Dn8IFhAKci5OLIZ4M
    dSBpbiC3fHIJUoxadHlND6Oy9By4d2U8omhiz5Zjrmre+XtPPAfDJ7e04PlP7cq0dGIM
    ptQQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808912;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DUSGuKHy21V6+GxO0cBGC7fg9zg1br9ErHo5MOH0l5k=;
    b=WnpwjYRysPBpVK2144EiBrZzXLjF1ZF4L+aMdWY0m8M4mIWwD4r6pHlNcTNgSCuwqd
    +jqKQk2yvMr/kGil+N5IF5CuD4MidimD9u41lk7UH7CB1j2+EahxTq2njFIFjfz/0PvQ
    ORNsdUVgKWFl1w+uHJ5By0jOSzwLhu5X7L92LgFgvWZNCKyI2xlXoyw5y5jOekdZKDmD
    LlQkdYEA0fDek6z1IoBHj6vy/AjP6zl+BfHsXg0DzRNSjz2wtEkIP9iOYOfXHbkZ4QuQ
    64jJMrJ8uRqNXLx8C28HIrkmBlA8xFQjPn1d91QF5RdOr6Pgb7icdGJexzX72VxGIDzd
    98NQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788808912;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DUSGuKHy21V6+GxO0cBGC7fg9zg1br9ErHo5MOH0l5k=;
    b=HjCvzsssk1zxPL+z/cvOee9WfNLGzT2RcBiahUiLemAakIfOGvPIvdwUtHjP0DdptQ
    uvkjB+j0p/x/t+GVLwCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O0JuBIIyqXfWze4EsqKg="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287JLpCsN
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 21:21:51 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: linux-pm@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 4/4] scsi: ufs: core: Report the current clock frequency to devfreq
Date: Mon,  7 Sep 2026 21:21:40 +0200
Message-Id: <20260907192140.2701755-5-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907192140.2701755-1-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

When a driver does not provide a ->get_cur_freq() callback, the cur_freq
sysfs attribute shows devfreq->previous_freq, which only tracks the
scaling that the governor itself did.

The UFS controller is also scaled outside the governor. The clearest
example is writing 0 to clkscale_enable: ufshcd_clkscale_enable_store()
sets the clocks to max_freq through ufshcd_devfreq_scale() and suspends
the governor, so devfreq_set_target() is never called. After that,
cur_freq keeps showing the last frequency the governor chose instead of
the one the controller runs at, and it does so as long as clock scaling
stays disabled.

Add ufshcd_devfreq_get_cur_freq(). It reports clk_scaling.target_freq
when OPPs are used and the first clock's curr_freq otherwise, the same
values that ufshcd_devfreq_get_dev_status() reports.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
---
 drivers/ufs/core/ufshcd.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 351c76094b9f..bac95e891de5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1711,6 +1711,26 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	return 0;
 }
 
+static int ufshcd_devfreq_get_cur_freq(struct device *dev, unsigned long *freq)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return -EINVAL;
+
+	if (hba->use_pm_opp) {
+		*freq = hba->clk_scaling.target_freq;
+	} else {
+		struct ufs_clk_info *clki;
+
+		clki = list_first_entry(&hba->clk_list_head,
+					struct ufs_clk_info, list);
+		*freq = clki->curr_freq;
+	}
+
+	return 0;
+}
+
 static int ufshcd_devfreq_init(struct ufs_hba *hba)
 {
 	struct list_head *clk_list = &hba->clk_list_head;
@@ -9616,6 +9636,7 @@ static struct ufs_hba_variant_params ufs_hba_vps = {
 	.devfreq_profile.polling_ms	= 100,
 	.devfreq_profile.target		= ufshcd_devfreq_target,
 	.devfreq_profile.get_dev_status	= ufshcd_devfreq_get_dev_status,
+	.devfreq_profile.get_cur_freq	= ufshcd_devfreq_get_cur_freq,
 	.ondemand_data.upthreshold	= 70,
 	.ondemand_data.downdifferential	= 5,
 };
-- 
2.34.1

