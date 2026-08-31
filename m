Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B41730674C;
	Mon, 31 Aug 2026 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181317; cv=pass; b=ocT0HKlUBJXXYXR8mrgOYd5pSnqhBeFCLVAben/Zn0KCucG1MEeswCfNqhsQKS2CqjfhgmfP4W8EcMMY/mtkk/QWhQvgQNCkagZx+cJYgxxFWygdKusMaY/1WqMnu3ujl2QMK/KKIAbDqoOh66HBQE3BqMzZgu4OluO6xNM2520=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181317; c=relaxed/simple;
	bh=53GClohDVNUq80O0s28UO9y06MRiLO0L0qiayYoNT00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KySKTI5Hnw9c6SuUSq/wfbEVfWSyTLIotZiJIyHCN/JclIJu5LdtFwOMwiXZs/XGguLd3hCXuHSlKn5NsF4ZdQiR9cHcI5wiFE97ZkesmMKpYc9N7meGQYk+2UonVHfGjP76+83EuHKlCj9VDKsxYN6cD4QVVIjpjnMnRjO6kPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=bm/ZxCzS; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=a8Iv4tyb; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="bm/ZxCzS";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="a8Iv4tyb"
ARC-Seal: i=1; a=rsa-sha256; t=1788181300; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=WfwuN4QpX8O+mjFgs9Gq/gzFBhGrIev9YX/+rsEvYVHorBHobl9wHb1ECyvAS0y8d4
    OIpyjwhq65um8yiWXqEcfmM41adv1DLtaIMY5nSGLeYi9RTKSBzQtalx7E21gXdesoUk
    WcR1XdhH6tah9+pT8Rmznr+mG3JDUSJNUWd2T1mI74YEIvGA9uh2sUPFZ6GdxP8dFWqW
    +W+f/1f2/1OeNzcQ0y2Q78Xoxhn101Me9I4OHgOCzU/CADJ7WbEX3HBv/yfj3JoeCGw4
    UBekl9Hy1Q1YXmsM4nxcV8xBsSY8hlWAi2IofsFvJcedATVFaQr5l8Cmt22q1zuNPDkH
    BSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=7tWJLc2AfX1JQbEqmTT83Dxd/SQ1Lf+Y2dv19BU5jxA=;
    b=cQzRT1To2erejjwgHSS5yHQO3Z+RmsGEB9dtSP8HCkzDbYtnjqFQHh+9EeovIRKdcC
    yh3GS+6PcAjxFBDsa0BPNCEqwPQALRRhAg0ENdPQEXpSAFFMlFCRhR0chQ7907Y/W0BF
    lPaX6I1jTpSw6zpmdCdsbDFJ8JQ0FnHCtK/rAEN3SLvp5U3iUsgPX3XrfehaiHCbsSic
    8+g7lzdLZCyfeRZdAEYiac7KMfoALeuRxqi/XsFwRfP6lPuTZb045y76djBmlCyv3n8E
    0unS3mOp4bbOWm1DQB5AtywGMB80VLEtwfEoHYNodI2K4uODU1xgH4lXTQVFV10saYi0
    k2lA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=7tWJLc2AfX1JQbEqmTT83Dxd/SQ1Lf+Y2dv19BU5jxA=;
    b=bm/ZxCzSaV+IdCwFRkXPD/ZMUKBqpjVmUj1gApdTaxwn2P+ChSZeTP6VmcFphAzD0S
    +ZDEajS/I/FB6D0RXal5RB8pfqkMtSaySX/aHXvySfSP8zOKLQjuXNdU2294MPF0PED3
    3y0NS55J41uFSlR9Y8t6aoeet5mjo2mMmm1B4begsyRCV7qVQam/LJ2hdfhAJOpcaHtK
    Xdd1BWBucdaG8h497L7zQ7EAOPpqMMchoC1KQIdea+HUi+vzvcARc45Ictz08j880nc9
    WvnCeX5XuVUG4XVgalD7la38/JEtDv2u8MXgT50/02/AjGnN0LmlBO5MB24eVTTafU5x
    BJgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=7tWJLc2AfX1JQbEqmTT83Dxd/SQ1Lf+Y2dv19BU5jxA=;
    b=a8Iv4tybK9+mQcMEBlNSychSUE47RovIs/Il2IgR9TzXhnjX93VfhZRLQvVPDbFhCA
    Y1R6/x44uqKFAFPuv4DQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/xK"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127VD1ekHm
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 31 Aug 2026 15:01:40 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 3/3] scsi: ufs: core: Report the current clock frequency to devfreq
Date: Mon, 31 Aug 2026 15:01:29 +0200
Message-Id: <20260831130129.3979454-4-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260831130129.3979454-1-beanhuo@iokpp.de>
References: <20260831130129.3979454-1-beanhuo@iokpp.de>
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
values that ufshcd_devfreq_get_dev_status() reports. Both are 0 until
the controller is scaled for the first time, so return an error in that
case and let devfreq use the frequency it last set.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..45187a7e4f4f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1716,6 +1716,37 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	return 0;
 }
 
+static int ufshcd_devfreq_get_cur_freq(struct device *dev, unsigned long *freq)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long cur_freq;
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return -EINVAL;
+
+	if (hba->use_pm_opp) {
+		cur_freq = hba->clk_scaling.target_freq;
+	} else {
+		struct ufs_clk_info *clki;
+
+		clki = list_first_entry(&hba->clk_list_head,
+					struct ufs_clk_info, list);
+		cur_freq = clki->curr_freq;
+	}
+
+	/*
+	 * target_freq stays 0 until something scales the controller for the
+	 * first time. Report nothing rather than 0 so devfreq falls back to
+	 * the frequency it last set.
+	 */
+	if (!cur_freq)
+		return -EINVAL;
+
+	*freq = cur_freq;
+
+	return 0;
+}
+
 static int ufshcd_devfreq_init(struct ufs_hba *hba)
 {
 	struct list_head *clk_list = &hba->clk_list_head;
@@ -9612,6 +9643,7 @@ static struct ufs_hba_variant_params ufs_hba_vps = {
 	.devfreq_profile.polling_ms	= 100,
 	.devfreq_profile.target		= ufshcd_devfreq_target,
 	.devfreq_profile.get_dev_status	= ufshcd_devfreq_get_dev_status,
+	.devfreq_profile.get_cur_freq	= ufshcd_devfreq_get_cur_freq,
 	.ondemand_data.upthreshold	= 70,
 	.ondemand_data.downdifferential	= 5,
 };
-- 
2.34.1

