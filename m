Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC73B8124;
	Mon,  7 Sep 2026 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808948; cv=pass; b=sYHPSAeRUCtY9X+SpBTwi1qtkUuGGx9XQpQ25Og+axle3ggAaLSzEbHzi8b5j1B2cyth9JUedp5PQ0jyku+KAXlIEH8kBYBePmhYloAXEYjVOW3BkizVmyZNQerIu8ejav45Be8wY1cJMVjO9h3erup54e6gPTN+Ky9TfjIUyCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808948; c=relaxed/simple;
	bh=oY3N3aHhyFfh4TzdkQGcKa9+tBM0Re+wcfe7XgEUdQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ws47AA0v/1D4uUMGbAVVQhZqXYpsSVl9HMk5qVgVVMiymgB9j81S+QI3rOfAXCgabjAD8mDBgPWAhZx5bPvkzsdKKAqIBZg20nJjcP5zEkFVkdK7bpmKD689E5+O/kjUGmqWu7EgIPJu8MixkaRMXuLRRJes/uzQxFbT06P9BoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=HVV+iKUy; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TZJej+8O; arc=pass smtp.client-ip=85.215.255.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="HVV+iKUy";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TZJej+8O"
ARC-Seal: i=1; a=rsa-sha256; t=1788808910; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=f3CgaXosVKj0voLF5H29DYWyVqZWzQy/U42OBfdP1EfBUR3VnmxW/F/yJaJ+jAJ503
    oI+4WcvU3nXFDj86Dh6Y2SXU9jB7wz39bfXi/+mNpy/L4/DLfNXlVUx3Xl8ERBt4xIHX
    AlxtLrsPL/etnSjDPwqVl2AzMJhCZWDEyjS5CK/HRpnZGVqV3TJ2Be8H5qKW9rOnZ9WL
    n/1CQVTxPS83YaXyMu/Z48HqfbKk2zGnuGxETF880mss7sSkftsYNaUDLevE6rsUki71
    xjM3p/66qQSempBAjMgjHN9+655DBNM/MIaP/mtEbn5VzWEedW7rdkt1zYbgEFo1W15c
    /AWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=mgEDvvUNxzael5eFRubLpo0j0BX0Gh6Xo8vGAYGbwIs=;
    b=SS4eDPcoODmhhM0oRPxnOqJ03ngM44pivAI0/ycOkEH1j5kk7HhQTQ82qIJfSJGyxY
    PmuzLHmHfbHPlMWcfFRNtvjuh1CSorltol+KhspMrXRXJYQ/uifVjUWrxrcMj3kY+LnU
    IUxgKftAbwpPTrUmlV+d+WJ4VkCQNW25uf8k1qQd1TQvCNRW6KFqwOh0PFLNEOGt4MjA
    puWzxVE5LYaKX/G7FX0WaXqphCGT5RnH8PMnRFJWYJGL7om1B+OmrdY/43PYg2pPEtAS
    pybPj8WtBNppDw8A06zwwEa7+tDiTcDSgCJCV31Rprbm+XN221rqO1i8tdpGB4i1akLp
    Iapw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=mgEDvvUNxzael5eFRubLpo0j0BX0Gh6Xo8vGAYGbwIs=;
    b=HVV+iKUyhncLDmqI5A5pR1XzNA2dWSiBOg0FGjC6hU46J4aPvMcAyX4XGHAZx9PZUY
    p+w9kZrZxiOnyRWTadikdcFMRRpGVm4qPg1AK9b7Xba/88dRWUxWYhtjXWO8rcGhsbby
    YnexmsKZQT4pzt6iaq6eo3pG9vs6OwRfWcWRrmuxGlalWsQvT2yGOyvRcxFsXLSLfnj/
    tWP1MMIKTU/WzegN7nxZ1W1myo3d8SBB9P9hnB7BYJFJ9pNCyLcrUhYptMmKlCo3kKJP
    xHa0y9hkkgOKvQKilderIaqHqxjIf/C49+5FvjxatDTvmpME2yngmswC3cnQwD7Nqclc
    rPEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=mgEDvvUNxzael5eFRubLpo0j0BX0Gh6Xo8vGAYGbwIs=;
    b=TZJej+8OrSygUvZRg7g/kGK24CZeRD7GGlvZ9rYg7fnDlwPIrwNsWRGAHDx5hI6wBb
    22VhmvDi/ZpmQuKMCNAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O0JuBIIyqXfWze4EsqKg="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287JLnCsJ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 21:21:49 +0200 (CEST)
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
Subject: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
Date: Mon,  7 Sep 2026 21:21:37 +0200
Message-Id: <20260907192140.2701755-2-beanhuo@iokpp.de>
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

devfreq_set_target() calls the optional ->get_cur_freq() callback to get
the frequency that is passed as freqs.old to the DEVFREQ_PRECHANGE and
DEVFREQ_POSTCHANGE notifiers, but it does not check the return value. If
the callback fails without setting @freq, cur_freq is never assigned, and
an uninitialized stack value is passed to the notifiers.

hisi_uncore_get_cur_freq() can hit this. It returns -ENODEV without
setting @freq when its PCC channel is missing. On the mailbox error path
it sets @freq to 0 instead, so that the core does not read a random
value.

The other two callers, cur_freq_show() and devfreq_monitor_resume(),
already check the return value and use devfreq->previous_freq when the
callback fails. Do the same in devfreq_set_target().

This does not seem to cause a visible problem today. The passive governor
is the only DEVFREQ_TRANSITION_NOTIFIER user in the tree, and it only
reads freqs.new. So this patch is not marked for stable.

Fixes: 0fe3a66410a3 ("PM / devfreq: Add new DEVFREQ_TRANSITION_NOTIFIER notifier")
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
---
 drivers/devfreq/devfreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index f08fc6966eae..f20d9a660779 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -348,9 +348,8 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
 	unsigned long cur_freq;
 	int err = 0;
 
-	if (devfreq->profile->get_cur_freq)
-		devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq);
-	else
+	if (!devfreq->profile->get_cur_freq ||
+	    devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq))
 		cur_freq = devfreq->previous_freq;
 
 	freqs.old = cur_freq;
-- 
2.34.1

