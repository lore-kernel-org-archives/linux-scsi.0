Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09BE3195FD;
	Mon, 31 Aug 2026 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181323; cv=pass; b=O5GRvrmiyFf/AVwKj27K4s5JofGrJFjuJJdcwjrbkK53R9TtmnmCKIMOcQiPto1VgBqL/VVSKNo6ktYNts7RHU75UNeKGi7KNKD0d9dodu/Ka7Le2JWR6s3um2dFBznXWsd/ChQ3rme5e0DxlMmPOfWhOMb3WdmslY0LvG3/QoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181323; c=relaxed/simple;
	bh=7K2++2lVCH/mhMxQmGo9pjPt8HQrezFr/5LDlPaqLm8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkBrS93M+k5mo2DhqR/BN6Pj2CqWI7I0aVgyVPgB7SGnfbZn2UjSlZHOuMrzaLfwDGa+YCUqyvxrNfmCWhxuxHC/Q+GLLX/CbkktUw4okNWLy602bHOEjOA7O6+PCkI930TOewB5c8u+k7Y0HxZCdJYefzFmNQVNzGsme5VRVB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=rLltL18x; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=J5qUM+A2; arc=pass smtp.client-ip=81.169.146.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="rLltL18x";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="J5qUM+A2"
ARC-Seal: i=1; a=rsa-sha256; t=1788181299; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ta8OmsDsot2gg4c9trXmg4QkvqmuOrx40FzhaoAGT5umHLXFTfv+Ir+m1iSgIyD2ba
    L3D28kixnFWf3XrbhXAiu8WRw/gK32xwcAYwI8Elkm4zNjLnXYKeB0WC+ouMzNp8cdj/
    WGzP3RNNk7qLOyUXNNG2lycAzLRRpnH78FZUteBoJWaCxhy1U9Pz4kPQY5IrkALR1eVp
    QnxWxvXCpE7YaaaYZP6lR45BsqjBaIw7YgmHOQIcTpJyAfEuRjCU8BjnrbisPZAkY09d
    vbyh/jgQLpKdgGzUyp65toRV722x9fJh74bJKAdUnMLv1Fh4gMtJQpndWjCxKmx283Ev
    ZQDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181299;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DQNekzi3HMaJqX2BC7HG+aXLO4uXJg8AL/wH7W8AuKg=;
    b=BITry1WPy2PjcTRJVr6l0khh0FcTMKANTZuCXPGt6qaUo+PgciMeH/SZ71c99zS773
    Gu2IGNBWyulhIi/3xD8CxRffCQceMXCMcAQv2ycSXaqhmje4ui/m4Uk/rtzWwwPhqDFC
    Oz3gpIXnDzyDsN+rUPIXp0D4smO2AeRV46il7lYJw9SxAcVywYnpgumw4xOpxkVEPr4N
    1MThmsoQaq2jJ6d7u1O5jORUotJ3s9OnUPaTGRnFL6P32A3mlc1WjyRgo5iUXEbPCNxl
    uyfKuGd+Xye9uHhuPwXJ8/UxWH1Woi0x4vQ53I78PG6lANiRQCMLn+TYqyqiPJe1+WT6
    fmIQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181299;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DQNekzi3HMaJqX2BC7HG+aXLO4uXJg8AL/wH7W8AuKg=;
    b=rLltL18xdIS/o0eI7KyFlcs9Ce/BwJGrrlv3HrtmTilGqTC3P8p4dgK6cbo2pKgyNM
    tW4KCarWbwvy3LaVesOrP9KotR3wgqQRNZalAJ2jNYeQ9hSgT/waprmNzU104Q0Xn/7q
    y+J19SyCyWpaME+aN8Ot4FcDgkz8zrvFToEwyvaMC24WNB0LH1gzI2FnuP9+bWkc/P3y
    KOtbNixw24I6rjTYJ58EfFLUJnYGRdjBUrXZioH8cxIr0G5udrEecuzFMOumY4qOZXa6
    QwRJl3UaHn44gVvW0KXBMWeJbbneTLe2mq30HVFMlpCRYfruLChnz9n/AUSVN9APkeDj
    q9ng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788181299;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DQNekzi3HMaJqX2BC7HG+aXLO4uXJg8AL/wH7W8AuKg=;
    b=J5qUM+A2EJfVAtX12oCv6pGPuLWK5fxnb328CkGOVzOzRPPIdeRaB8PTCMfOTsyV6+
    buTtRZiIP9J4ykk2fvDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/xK"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127VD1ckHk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 31 Aug 2026 15:01:38 +0200 (CEST)
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
Subject: [PATCH 1/3] PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
Date: Mon, 31 Aug 2026 15:01:27 +0200
Message-Id: <20260831130129.3979454-2-beanhuo@iokpp.de>
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

