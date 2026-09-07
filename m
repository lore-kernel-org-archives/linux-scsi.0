Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A0525A7F;
	Mon,  7 Sep 2026 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809097; cv=pass; b=pQ6jmGxCDSU50ENc57wmHCNe+CueQJWiWZgREl8FxhlrwGX4DCSV6BZbRYIh1S+VRJh50iGpZe4U3u9xCK3ghSc3Fk0/KB6Tyn7I59u75fbepwrdNioYsHJs9HeksNTTqPKt2TRlfIEDPlZiZTigjvt+cZeFbis1g095U9K4vPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809097; c=relaxed/simple;
	bh=z8/LbN4GvRWMa1Awdne7SOiBoRZtd5hXxbxRwoQKATg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nri4R5QtM53sYQ1wEkWF+h/jQ+bmFo2F+3G44kr1eQpoGfdwRFtuHz4cpX0bl6YLG4J6v1c9AJm83vIiXsxvD5GuIOII7lIRlRu09U1wdshJAmhQcYxPdytnzwQFl0/l/N4IzbJ9ZRWmpGcB0M2tbQAMGc75XjT2AP3tGy3ZrGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=aUpF6NbI; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=aFAtzatz; arc=pass smtp.client-ip=81.169.146.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="aUpF6NbI";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="aFAtzatz"
ARC-Seal: i=1; a=rsa-sha256; t=1788808911; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Roq2zVfMow6OGRqxVJ4LnyPsdK0PW/lS5HQoFrwojtVYbo67qehH9PpG0iZtPUkN/e
    jeAT2psUcXdqGfT/qXUNB34vQ7+QBDOyi1m9zNrD53v0eOiTo7wFhdcUWMucBkZcX+li
    zNBLg/s9dxyJNKx8Dadso2T5JO2Pw4IqK8tOUvFAamoJrmui+LV74ieqZxGEpzJvcV6i
    tSXm1zrHGDjmILZIZyNrQ7Emc9lA8vKOtexfwiShSmMm+WU7GuFOQSBBIVN14cJFdHjZ
    fONEG+few2uFQl+Khcj/FjYPSIy7bhXjJhUasqzl4fvJxQK/8RRkPQESf30ndUh6E7+H
    nKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808911;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=H1cbDq3VQhnovGC+0efoWjTcvl/McAtBG8RhbfSzmqc=;
    b=d7v01WLBA+DF2h5oDJFGsuaEGdtvFVgwj4Bm9vLB9EQqjfdzZ6H7wCvRYShGwH6QSq
    U1FyMXUpACqdZ5ta0RZSbMDdj77LHfrv2Xz6IH7O4VDG6WkzacLNFSFiyPK5yKqocTD7
    s8qpvQHM20xvEpj2afGo9pOakiuOyyAQLWFnwfsixsoYXS7AHgtg4Vfd3734IuYPRJG2
    rPtRdoHVoX34aQhJNnIElhRE/wR2FjD8kAYjNlXfHaK1Wz4mqF0HLcXUa2N0avErymTV
    08uJXQrELoC70cQUNTRxXV0T99raoy3iJrNoWn5kX5iFdgIEGMHgkbwvfK1HPN/UjYhz
    5/Vw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808911;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=H1cbDq3VQhnovGC+0efoWjTcvl/McAtBG8RhbfSzmqc=;
    b=aUpF6NbIhaoFLdkqKRNUJ4kIrLNEkx5XV+ItCQwdPr2BSelo83zRTbrxWyKVkLvcAt
    QQmY2/J/WqUsANVttNBLx1U1vZnIhpJX4Mm+/ta4pcniVNT3hLK1CRWoLxgmfNUwbfUZ
    H1OPx/gCdVItQkes+lxWYpUpOxUVy56JJKOccWHHQPVZkGra1hS6q7cJprwQi7xejZUM
    +L/rSaRPeW42p5Tlvs1g7uJeXHDMbSO9ztaji1d+0uo6dlNjqJM6Fsjv/cE0DW8y92TH
    wDhKOAFSEUQMd9+hcfuV2MgkWlbRw1q/sI0iYF0Vc/s4CmkdcsAbizaOcBXLKYU4q5Sn
    i3KA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788808911;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=H1cbDq3VQhnovGC+0efoWjTcvl/McAtBG8RhbfSzmqc=;
    b=aFAtzatzxbnvhyQiApug5jvZMhDc3bwSQ91a8nFFH/EDmi1zKiIRfA+nTHmht5r0Fl
    9ekp4U4Cmpr98ivtYFCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O0JuBIIyqXfWze4EsqKg="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287JLoCsL
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 21:21:50 +0200 (CEST)
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
Subject: [PATCH v2 3/4] scsi: ufs: core: Record the frequency the controller starts at
Date: Mon,  7 Sep 2026 21:21:39 +0200
Message-Id: <20260907192140.2701755-4-beanhuo@iokpp.de>
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

ufshcd_init_clocks() puts the controller at its highest frequency, but
nothing writes that down. clk_scaling.target_freq stays 0, and
devfreq_dev_profile.initial_freq is never set, so devfreq->previous_freq
is 0 as well.

With use_pm_opp this shows up in a few places. The target_freq attribute
reads 0 until the governor scales for the first time.
ufshcd_devfreq_get_dev_status() reports 0 Hz, which makes the ondemand
governor ask for the maximum frequency. ufshcd_devfreq_target() then
sees 0 != max and runs a full ufshcd_devfreq_scale(), which holds up the
queue for up to a second only to set the same OPP and the same gear
again. Without OPPs the frequency is not reported as 0, but
previous_freq is, and devfreq_update_status() then drops the first
time_in_state update.

Record the maximum frequency in ufshcd_devfreq_init() instead.
ufshcd_add_lus() runs after ufshcd_probe_hba() has geared up to
hba->max_pwr_info.info, so the clocks and the gear are both at their
maximum by the time we get here. The only difference is that the first
governor poll no longer redoes work that is already done. From the
second poll on nothing changes, because target_freq held the maximum
frequency there anyway.

That first scale also re-applied the gear that
ufshcd_vops_freq_to_gear_speed() maps the maximum frequency to, so it
quietly corrected the link if the OPP table and the gear negotiated at
probe disagreed. That does not happen any more. On ufs-qcom the two
cannot disagree, because ufs_qcom_negotiate_pwr_mode() clamps the gear
through ufshcd_negotiate_pwr_params() against the same controller
capability the OPP table is written from.

clki->max_freq is the right value in both modes.
ufshcd_parse_clock_min_max_freq() fills it from the highest OPP, and
ufshcd_clkscale_enable_store() already uses it the same way.

Suggested-by: Stanley Jhu <stanleyjhu@google.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..351c76094b9f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1681,11 +1681,6 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	if (!scaling->window_start_t)
 		goto start_window;
 
-	/*
-	 * If current frequency is 0, then the ondemand governor considers
-	 * there's no initial frequency set. And it always requests to set
-	 * to max. frequency.
-	 */
 	if (hba->use_pm_opp) {
 		stat->current_frequency = hba->clk_scaling.target_freq;
 	} else {
@@ -1727,12 +1722,21 @@ static int ufshcd_devfreq_init(struct ufs_hba *hba)
 	if (list_empty(clk_list))
 		return 0;
 
+	clki = list_first_entry(clk_list, struct ufs_clk_info, list);
+
 	if (!hba->use_pm_opp) {
-		clki = list_first_entry(clk_list, struct ufs_clk_info, list);
 		dev_pm_opp_add(hba->dev, clki->min_freq, 0);
 		dev_pm_opp_add(hba->dev, clki->max_freq, 0);
 	}
 
+	/*
+	 * ufshcd_init_clocks() has already set the clocks to the highest
+	 * frequency, and nothing has changed them since. Save that frequency,
+	 * so that devfreq and the clock scaling code know where we start.
+	 */
+	hba->clk_scaling.target_freq = clki->max_freq;
+	hba->vps->devfreq_profile.initial_freq = clki->max_freq;
+
 	ufshcd_vops_config_scaling_param(hba, &hba->vps->devfreq_profile,
 					 &hba->vps->ondemand_data);
 	devfreq = devfreq_add_device(hba->dev,
-- 
2.34.1

