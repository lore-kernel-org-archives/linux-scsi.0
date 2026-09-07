Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50F393DD3;
	Mon,  7 Sep 2026 19:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808948; cv=pass; b=U1Alp9TQVq1omqja2i3EPfliis8iLY8EvUCV3zhHk4rDoRBx9YUqf0SZzfIcnkEAIzAp8XRU90vrKV104bWSlFvmfHYLd6uBectC0HxHbJFfjN0wkUXx/EY9zXjUZtfSCNLGHxRy5tpsCuFlYebIEljlLTLPhm3v79uWrESczRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808948; c=relaxed/simple;
	bh=HhrAm9DJpRZhOpSMo0i3+dJ3oAcWSDgw4nmsP0UB8ng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=JMLENVNVcud6v5mz9jYNyz8UuYwWGMADk7uto0VifYa632aSAQAOtOul7Bgt3yNtr5YiBz5Nas31C6GV52szyWfkJQ65JZp6KeI2yH8PXXjeKde1HNlkcWcqhBuO5t7KF3tEqn/Oa5spkUhJo/cK/dx+c/ZW0sYbWWNQ6Xi0MX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=VHHUKBF9; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=/rn8fzBk; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="VHHUKBF9";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="/rn8fzBk"
ARC-Seal: i=1; a=rsa-sha256; t=1788808909; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Z9yDJYfI0KrsO901DO0m4O75ss+U66DqChvVcs9euTXIA5QBm67e67Eiywq5LzBHHv
    5J+pqnl39Yns7A850r9AQfA90PEIhU0NRFHXF03raFmkOMc8IQ9XehEtuv0XJssWbspG
    KOGxY1gkBXx0c3r8Norq0JHt3ujkywmugs8qFmhU6cmCm7PPOKszozwxEIDGLhTDcKZU
    bJH4fBHx2KJp6UMQB5Ug1nVgFlbW9VhpW3eBimsapXcMAe74bcwLLcFSS1GlWOMmeGLc
    WGh74S96UJoR6vzlRv7mQzFeRi91CfrwxoC2e6xnPIyPkzE3c5UMEx/Ay428VnrHAsP/
    EyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808909;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=rTSqjvK3EbaHc/ippsBe5x4pRfP03d4sXgnLJ5qsaeE=;
    b=RTuFZjnpxpXIayRupjyNuTf0kpccJsSjm0anhwSNFWCY+gcmN2c+Iccb2btRWQTCIq
    Ape8aYDCoIibEcEWNUFcGGWkzpqDnmVSu9k1XWuczWD64vDdC6d1RXgxe3FAEOf7Fd9N
    lPJ85sfnZ6WBvr9SCKXAnh2IuWNSzPnmlaJiEoQ/DqqS/9Bsd1eAwWnkmjlnFnuwofPR
    LUSNiodoqDfH5kdtI/avwbVJxOTclWJIpvGKNySURFrbVVLaBYnJfZGQXh0aMFSTQxRb
    J5a3W/gl7h6oZuuRd6TmgkhXuLm4yHl2W7/+f3aAAymV9kfsPiwQA5hiQrtRwEIhD6DX
    EUmg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808909;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=rTSqjvK3EbaHc/ippsBe5x4pRfP03d4sXgnLJ5qsaeE=;
    b=VHHUKBF90upQzptUmbI+BgdnVGn6/pB2h08VnGPVtgHFa0TdQjBjpPqvEdPvkH6zK+
    rXakp4Tic2QYCwEIsBV5J+Yz9NPt3eIa0PnJmzQ9vy/+MwNNeo2Ouk/PAlq5+oggBbZE
    tR490GTwQqk6c55M/pi+T6+A/6gZlJsEXm1BZZbG/wDwaMznL2YyieypdpAhh47qbX4k
    0F18McXiyoGCz3F7vL4G5PmuEtL1DpXswkxV0hAvKua1IvHQz+s+fylMcXbcz/PpL/XE
    TsLn7O46yM1wzWUvhDWfRBRUQVHt9V/Vkzv819lyAnSvqJI3f1NkibcxhTXpgzsocsM7
    TfMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788808909;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=rTSqjvK3EbaHc/ippsBe5x4pRfP03d4sXgnLJ5qsaeE=;
    b=/rn8fzBkyjL4ng4VKxZwLkO+gX1BKXaJz0f+f8B7i5O4pAimbpurX29PKnmrmFjGlI
    tT4j8pYGCPtc0Epvl1Cw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O0JuBIIyqXfWze4EsqKg="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287JLmCsI
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 21:21:48 +0200 (CEST)
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
	Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value and use it in ufshcd
Date: Mon,  7 Sep 2026 21:21:36 +0200
Message-Id: <20260907192140.2701755-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

The devfreq core has three users of the optional ->get_cur_freq()
callback. Two of them check the return value, the third one does not and
passes an uninitialized frequency to the transition notifiers when the
callback fails. Patch 1 fixes that.

Patch 2 writes down what a driver is expected to return from the
callback. Today this has to be found by reading the devfreq core.

Patch 3 records the frequency the controller starts at.
ufshcd_init_clocks() puts the controller at its highest frequency, but
nothing writes that down, so clk_scaling.target_freq stays 0 and devfreq
starts with previous_freq at 0 as well. With use_pm_opp this makes
ufshcd_devfreq_get_dev_status() report 0 Hz, the ondemand governor then
asks for the maximum frequency, and ufshcd_devfreq_target() runs a full
ufshcd_devfreq_scale() that holds up the queue for up to a second only to
set the same OPP and the same gear again.

Patch 4 adds the ->get_cur_freq() callback to ufshcd. Without it the
cur_freq attribute shows the last frequency the governor selected, which
is wrong whenever the controller is scaled outside the governor, for
example after writing 0 to clkscale_enable.

The patches touch two subsystems. Patches 1 and 2 are for the devfreq
tree, patches 3 and 4 are for the SCSI tree. The two halves are
independent, at build time and at run time, and can be applied in either
order.

Patch was tested on a Radxa Dragon Q6A (1d84000.ufshc):

  before "echo 0 > clkscale_enable":  cur_freq 75000000, target_freq 75000000
  after  "echo 0 > clkscale_enable":  cur_freq 300000000, target_freq 75000000

Without it both files report 75000000 and keep doing so for as long as
clock scaling stays disabled. A 4 GiB direct read after enabling clock
scaling again counted the transitions in trans_stat and attributed time
to the 300000000 state, so the frequency the callback returns is one that
devfreq recognises.

One thing to be aware of: devfreq_monitor_resume() copies previous_freq
from the callback, but it does not call devfreq_update_status(). A
frequency change made while the governor was suspended therefore does not
show up as a transition. That is how devfreq behaves today and this
series does not change it.

Changes since v1:
- New patch 3, so that target_freq and devfreq's previous_freq are not 0
  at boot (suggested by Stanley Jhu).
- Patch 4: drop the !cur_freq check, it cannot happen any more.
- Drop the now stale comment in ufshcd_devfreq_get_dev_status().
- Patches 1 and 2 are unchanged.
- The devfreq and the ufshcd patches no longer depend on each other.
- Avri's Reviewed-by is on patches 1, 2 and 4. Patch 3 is new, so it does
  not carry it. Avri, please note that patch 4 changed since you reviewed
  it, the !cur_freq check is gone. Tell me if you want the tag dropped.


Bean Huo (4):
  PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
  PM / devfreq: Add more details to the get_cur_freq() comment
  scsi: ufs: core: Record the frequency the controller starts at
  scsi: ufs: core: Report the current clock frequency to devfreq

 drivers/devfreq/devfreq.c |  5 ++---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++------
 include/linux/devfreq.h   |  7 +++++--
 3 files changed, 38 insertions(+), 11 deletions(-)


base-commit: e30626823a406725ce29bc75cb8ec467d3e1e326
-- 
2.34.1

