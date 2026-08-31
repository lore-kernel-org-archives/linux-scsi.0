Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7B2F8E8F;
	Mon, 31 Aug 2026 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181311; cv=pass; b=heNCxjbJ57FRzemfArmKkCVByj12B5gz6Vh7N18U46tuXugu1KvUXNlhait8XqyrZElLE80jocEvdJtVNkpvpQABw6HHIRkAlkAiZ8adT9ji2xITEA8fbgLblCyFpShbxw6ahNC41WiNtL9mI+WESlZs474mCKDs2IaQ6HLr3Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181311; c=relaxed/simple;
	bh=sHBexSQ4uDOsbNPAj0VKPBr/Zf7xOkTCorvaMnBp3pA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=T4RJcUAqRci6T/rqfVtvrcZXtbgQtsOb80JDyai8wXr0PVcD6SYNTvKKem6T4TgrLmiBCePC/RQ0ep5UMvdR9t1ZX0pPsLBHnu/KV0sPvNb1gYg2mHaPrQC0Bc3YpXpKKyFUMUAMVlvVy6TPUmKP44RI2OFsgSeFs3r9ay7NDi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=j2ex/EGP; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UpKQF25b; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="j2ex/EGP";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UpKQF25b"
ARC-Seal: i=1; a=rsa-sha256; t=1788181298; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ALGTti9KxykSWzFJRCzdBpRMcBm+Q5U6z3q4LLXqc/vrDLPiCyaCRaW4DbokbeVqBt
    0U1HpUlA6l2kR9MbVFKuggSbYTwyuLIOiHoe130fIhTD/2jxHiEQaucF70ZKnKRldFAL
    Zn8D4eSyysM6IOjb0guMGLWhetLtbGd0j5jRlGUR2fZRPc/2wIIL3yF8JSw8AQXyU9KV
    jVQmF0pMrNxl2RHdzLirpKFrPVkiLlaOlHIOq9arucAg+9tn4NrJcgkB2dV5utTDTIfR
    0PzcULTmqnKm7FL619JasycxK5A3CgrSkzw1QDTuRe1pgnpX1AR8jVtsKzJ509ivt/qn
    rCUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181298;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=/oDoPiLP0MWOOPKiSVzIL8l7Vm0Qb4HJZfvT0e7GXIo=;
    b=MsoG2wdi696Xr+LOiRmw9LOvGs2cBqN9K04RlClGyJgZW+dpwXmcyL+X83QJ838PHS
    2cTVGncXG5OsUjZH03vgjdxi0kD0k0AS2q2K2Gtvm2EnJtcHv8E7MWqv2F0vhEpotusY
    UOJzxQBb2hK4VuACKzZc16u5tyT0Pwk1upLrZ2EXOcIetb04A1hp4vpUdvdqsAT7KkP+
    Ya+c/2Tywm+KkqdLnUrWexanqVvly/dxAy8Gf18oJxFYZem4ue6JweN004KaB1A6h4Jg
    BbVcn9vW6WiMCHwzXu/OI+Wm4N3zaCShgtdN8j9wKtrczZ4TyelsWDbxNBekT/HlXXO/
    4S8A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181298;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=/oDoPiLP0MWOOPKiSVzIL8l7Vm0Qb4HJZfvT0e7GXIo=;
    b=j2ex/EGPEGG+ccC9DqiOuhVuxb11X9X0aqheP8Z51B5lon4RSR497r6cZ+ZMwf5HM8
    vgC9wj4+lsBre6nhrf5grmwSM11/393H17pjHB6tKmo7djtGlx49WsfnIOPA7T8VWuR9
    morYL7S3jGczEFtaVHCGTIrHr6MgGdBDffPVarEEfZblJ2TLl94hNFgV0KLpVWbZWUu4
    OA1w4TLy1LVUZgJ3NQLcJjz03yvjJWnhmaaKQofU56rlo1fTG2SZFfAnqnM6BpaLYR+O
    HXMyeL9X8DT54ZE8QSwgNYjw2lKWQUYKVRd+WY0LpYHjdFqjLamovAkhX7s+95bq8vEZ
    lmXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788181298;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=/oDoPiLP0MWOOPKiSVzIL8l7Vm0Qb4HJZfvT0e7GXIo=;
    b=UpKQF25bzwXbjTHPScPYlHY9bdEFuuzLUkSepaIiizB++tQtSJGLfE+USf+LV70u/T
    CyLYlzgObSmRq+aiGpCA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/xK"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127VD1bkHi
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 31 Aug 2026 15:01:37 +0200 (CEST)
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
	Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH 0/3] devfreq: check the get_cur_freq() return value and use it in ufshcd
Date: Mon, 31 Aug 2026 15:01:26 +0200
Message-Id: <20260831130129.3979454-1-beanhuo@iokpp.de>
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
callback fails. Patch 1 fixes this.

Patch 3 adds the callback to ufshcd. Without it the cur_freq attribute
shows the last frequency the governor selected, which is wrong whenever
the controller is scaled outside the governor, for example after writing
0 to clkscale_enable.

The patches touch two subsystems. Patches 1 and 2 are for the devfreq
tree and patch 3 is for the SCSI tree. They do not depend on each other
at build time and can be applied separately. Patch 3 only needs patch 1
for the error case described above, which requires OPPs and happens
before the controller is scaled for the first time.

Tested on a Radxa Dragon Q6A with UFS 3.1, with patch 3 applied:

  before "echo 0 > clkscale_enable":  cur_freq 75000000, target_freq 75000000
  after  "echo 0 > clkscale_enable":  cur_freq 300000000, target_freq 75000000

Before patch 3 both files report 75000000 and keep doing so for as long
as clock scaling stays disabled.

Clock scaling itself still works. A 4 GiB direct read moved the controller to
300000000 and back, and trans_stat recorded it.

Bean Huo (3):
  PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
  PM / devfreq: Add more details to the get_cur_freq() comment
  scsi: ufs: core: Report the current clock frequency to devfreq

 drivers/devfreq/devfreq.c |  5 ++---
 drivers/ufs/core/ufshcd.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/devfreq.h   |  7 +++++--
 3 files changed, 39 insertions(+), 5 deletions(-)


base-commit: e30626823a406725ce29bc75cb8ec467d3e1e326
-- 
2.34.1

