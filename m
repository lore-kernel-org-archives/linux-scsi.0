Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795732365;
	b=Kw0ODLk90M87wYvgwqvxYp3c0pQjwhOtE6qtEGe7rok4FkMaGY9wLJDe86XylF09gglK
	 nqccjLceHqBZ1+NtFKAfLDbkXfNcVlE33vZuKozuuh/ueILHTLfrmNS9MXwjXiy9O+jfC
	 w0cFk3Bf9U/p63wXOi3YIsQqw6ELYqyIcmUgnnUTz4r0sbSn4VHxFOwvanJ1rVPmUbO1x
	 d7wUH/bUuR1zlvsTDfGudpnBOCrceIcSLifsd509xGcJ7ocgpC0z/nABFJg+7r/zjakaR
	 v6v2OIvuXIzX1VBl37od3HK+pgkJV8d6I9sG5WZngteyf/NP2RpoUReYRK0ZnDu5rbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732365;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=YLRX0OaUNZ3WcezBtVDRtDl3s5/0FwtcLnvobcev8Cc=;
	b=ayVsbCjpxqMmxF1/cNhpoTpBrRDiXPrLGtY6M5dEbLHK24JsUyFaF6FqnNCxQfNayZi7
	 ZX3lB7S0StGcNCKZRNucJJPWamxdEfuGSrxkzpfuMau12MqU2JFG4bsHHGLH3KR2bGP0z
	 66lhBo8wikm6Cvh45d7fs95mpdu+jZY3fptNkfQ0O2Ldjzr3QvUo4FKzbKODaUp2K2c9z
	 XCLTBhSijCU6R7tpGqirSZNWRN62jztxrRk15haqUrPp3rY/q59a31EXJxHzooCMBPZ0/
	 /hhGmyOYjZh7wIJHROLiBRYwXhwfnPb5c6tUKuuGTcDL31OXtEllc6Hoq6aFQiLrODg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=LuSLgd4m;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b="4xfwx/gY";
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CBD606A31C;
	Thu, 26 Nov 2026 22:32:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13CBD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=LuSLgd4m;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=4xfwx/gY
ARC-Seal: i=1; a=rsa-sha256; t=1795732359; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=f+FvmR0vJ8clx1Nl1XG30F0bgb2yWTzgpS8AW00jD5BFsklDPZPiVMWQ/dBkd+s1kt
    cWg/HgalvcB0DzDRBePW9QSkiC8UjHldig5ptP4FP23xYn/phgP2lv7O7j8bfPEF27tj
    xuoAI+9wb6qFLHaiLloBqXTeDkD5mZ28h2HMONUWGaTQcfYxXHVGtj5OoKwdTsfjbjye
    +NT2H5fbOwpUDXAikxw4D+uu0hCH9HK3qg2W4sYyWjPWxQaPMvBOuoXR484+MJkOlGOm
    kFH/twA4js7jBj9Qf22rzyCkHf1S5MVtqYHlyiGYaKOcLmsIYvYIshiJK4QHomh3KesU
    kChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YLRX0OaUNZ3WcezBtVDRtDl3s5/0FwtcLnvobcev8Cc=;
    b=KtJXYabVqbldq4crKNokmAUZmS4mIpuj3+TrUoSmLwBkvZVa5UYfPJDge5ScQ7+dgk
    bdoZXT9bswmTgPmIDQuQe2Zo3A3NDYmxxhyz8OYQya8uT0CKwNa1JzwtplvmKZmMtzYJ
    Uvq/4mmzmBd8PHRtr2+1KGXUxxm2BzQsWaG9SifqfVkfM1DVYNWeBMEVu8iFAPwNbCD8
    eSBWJ9MXsiIMU04vtPrkbRCKARKpao/G+ERaEgGiHP1kT8Tqh0dL/SmoSgzCl0mtorA0
    wfvypfa9dNlhYahfa/4zw+URnqY/g1Cl3VGw7eaCy7Jk3WR/tXglfb4G/rGvBsjUaLYJ
    n9/w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YLRX0OaUNZ3WcezBtVDRtDl3s5/0FwtcLnvobcev8Cc=;
    b=LuSLgd4mE7BGTR+TsGusU/Y+SD3vSwcXJc3397jpsp9mX/M6mlC2NGdH0z1qK+EWY5
    ldqyLJIM3Q+wcl/p4qoxxs8Fvo3YQaqLaJ1MZfubJa+TRvDYAzdGt65ZL9pkc8N6+jxW
    f1baJYbO7YDbwhCJ4uY8hVCCvXInU2y+cDx6bKn9gQ8tsU9wHyvSXwYxJB6or4gdI9Kw
    U5deY9JapSGpAZoOCCzgaU2a3WVclzSXfgF9/usvkiZqgc8rqGPyKLFweEBFcBPIVcZw
    HeRJ8QQ86QSk+jsf2gdskMcHJE7ME1cC5oXYykUgzbJFenkRYM3jvJYr2H/H2c8xiti0
    bhyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YLRX0OaUNZ3WcezBtVDRtDl3s5/0FwtcLnvobcev8Cc=;
    b=4xfwx/gYLYYBmtx+BTQC8glqkZ4WzaLbxnpakgl6EZxVDZdubtYG2BSLKFDG34QuQb
    tJInF47jR1v/n2jKxSCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RP16IHIszTD3hB2bKri1qswmSmZySpVjD67C0o="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AQMWdfOl
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 26 Nov 2026 23:32:39 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bean Huo <beanhuo@micron.com>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Avri Altman <avri.altman@sandisk.com>,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 1/2] PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
Date: Thu, 26 Nov 2026 23:32:24 +0100
Message-Id: <20261126223225.2257410-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261126223225.2257410-1-beanhuo@iokpp.de>
References: <20261126223225.2257410-1-beanhuo@iokpp.de>
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
callback fails. Do the same in devfreq_set_target(). Read the frequency
into a local variable first, so that a value the callback writes before
it fails is not used either.

This does not seem to cause a visible problem today. The passive governor
is the only DEVFREQ_TRANSITION_NOTIFIER user in the tree, and it only
reads freqs.new. So this patch is not marked for stable.

Fixes: 0fe3a66410a3 ("PM / devfreq: Add new DEVFREQ_TRANSITION_NOTIFIER notifier")
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
---
Changes since v2:
- Do not call ->get_cur_freq() inside the if condition, as Chanwoo
  suggested. No change in behavior.
- Add Reviewed-by from Jie Zhan.

 drivers/devfreq/devfreq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 82dd9a43dc62..7546ed720dcb 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -345,13 +345,15 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
 			      u32 flags)
 {
 	struct devfreq_freqs freqs;
-	unsigned long cur_freq;
+	unsigned long cur_freq = devfreq->previous_freq;
+	unsigned long freq;
 	int err = 0;
 
-	if (devfreq->profile->get_cur_freq)
-		devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq);
-	else
-		cur_freq = devfreq->previous_freq;
+	if (devfreq->profile->get_cur_freq) {
+		err = devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq);
+		if (!err)
+			cur_freq = freq;
+	}
 
 	freqs.old = cur_freq;
 	freqs.new = new_freq;
-- 
2.34.1

