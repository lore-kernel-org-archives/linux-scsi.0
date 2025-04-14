Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F937188733;
	Mon, 14 Apr 2025 04:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744604945; cv=none; b=dmZe2Cqt9oRsAZo/PGzZ3LWWt4pt0cSTqn7yNvN+B417c4EYYPpLLJFf5E45BJaeI/FqDF+GiJbM8QDNpgO3flL8aqU31oMabpsErAMYKkEEI7SIZbK2iOE7nm474QQFXnIK+8noyUWoUaIlyp3mLwrh2kLLDd9vjMZLt3RYdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744604945; c=relaxed/simple;
	bh=9nLxry6uymEWY57ezGAJopssPlPMvQrTufAJrt4l0IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbJ+dn/8EPKIbzPrD4QFNX3cWPFwYzWv7ZYNLdIgsETmQu3tawUCvEKMxe4Kc33oDv7EYWceUN+sQg23Qhta0HGJYgIBQDIJ0Rh8OrEKCbrLljuwESwrLTpKngBj1xalxB4o21Vecf6ZxxL06Un5a04PTw1zCjQthFZJO1Eq7sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=e5DSpVEh; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="e5DSpVEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744604857;
	bh=+0Ip4t1kULw7IHR0Km+psz98T8xTOCy/rdMMlTcOddQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=e5DSpVEhbqHeLU7aVJnSrp5m5SgQ96elMZNql7q4fw5TSrGq9l0QWI9aYRQx/D3Nv
	 DEtcgbhnHtKmDp/jFqC22Jx1Lty2eLamDTGTmWP8/oGTyBu4Y1Zr1mRIdSPsKschuN
	 GsxT6kXpUUOuTKeLyQZ5E2SoW1TD3xQiROOfl/OQ=
X-QQ-mid: bizesmtpip4t1744604815t525699
X-QQ-Originating-IP: jZ81SD253UP75DJ/PEHtvx9P72SblTv+7A+anZzUtlE=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Apr 2025 12:26:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16234562638770567262
EX-QQ-RecipientCnt: 11
From: WangYuli <wangyuli@uniontech.com>
To: wangyuli@uniontech.com
Cc: akpm@linux-foundation.org,
	guanwentao@uniontech.com,
	linux-kernel@vger.kernel.org,
	mingo@kernel.org,
	niecheng1@uniontech.com,
	tglx@linutronix.de,
	zhanjun@uniontech.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI SUBSYSTEM <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 3/5] scsi: scsi_transport_fc: Rename del_timer in comment
Date: Mon, 14 Apr 2025 12:26:27 +0800
Message-ID: <084BD6AB1C4759DA+20250414042629.63019-3-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <37A1CE32D2AEA134+20250414042251.61846-1-wangyuli@uniontech.com>
References: <37A1CE32D2AEA134+20250414042251.61846-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NHmMC+6XyEPfA3ApZy0TqMz0i+E37ZpBG+MK3sXzT5V/kN7OP9yed4qz
	uY/iaujPVeJjGpxulFwpyLyrKixxUWHDvp8GLMJTVKjbguXv6mxMgrZ3v8/fCCTEpLsP0nq
	wpx3Flw/atsb8d28afLKtSPPOExp8uuF+zur2BQYu9k53DX7ASTdTiLMMq0DOuLJ/h/n9YU
	XeS6pb9yTwqpHqDM7siXm8BaFAJJhbWdKBdto7heUL/kgoezdYP010Az/rNvr6jNV2AH/WG
	685KHd7pYYPTpQID4s2LMafo+XvxmOxvxgaUKRB8XUNeux45DwywNayHpVthltj4Go2qjKr
	8Km0aFtPjLa/mbCd+Y3IfWw1rF4L2gLPQfZFpnZKAJVk2WhdBLNFoXjHza2zsL7iA6xEhVL
	3JQTOfQ6CYZ4x/oUuG8YIY65tApYXumt8+SMg/7fJmyEnMbtzmQnJEslpunvY8+biZyrZc6
	HQsp3/mzPYJVPkRI//LaqBVoTdlwpuAOU2TRGDLbRxKfj/G43vo/8sPeKBaZtHJY56pGOhV
	rxIvYHofgTw2yL2ux9h/Pr9ihUsz8ZgSPr5gGDhfYfkkQiTHlW/b/vZ1YMJSDk4+1RQhctc
	5uklAH6tyECRpFx+KJobaQNRz//H9syD7ibdfckPEtk59AVc9MIrMds5ceMG/lje2xZhFLd
	gGe6lz605QHU3XVPBbkUIb0E9HfwlK8wx4f2tCtMONe6SAbRNaNhknMc/T6Q1xhWTo2XTHp
	3yDdEcr6yAKfd6UWDf8H/ZF6JVlYFs8QDsmGCwDb5qv3Yuamk8bMaCep7/r696Vq8qxvtYf
	GbZTBJEz8oNUO9EYezMxuH/DBXY+0egOQeH3ZaMVqeT00bALH2VAzHbhYafIhjfPzIpTwDY
	H5inb5IiPR4yzUzUerv7ZQiup3clil6aO7nxKWrZXS0aFTHvKoeTYMW6dmLHjG4G/k1N0bB
	zlHQTP2sYO5sUJtAO5/3wXBjgrGipgfEDUwhaCQRrhOm1s89WuSk2G+f5x3GouyvhRGImnu
	oeG7/+QeZWYbQTyxrQ
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer to timer_delete, but did not modify the comment for
fc_remote_port_rolechg(). Now fix it.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI SUBSYSTEM <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 082f76e76721..dda7be02ed9f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3509,7 +3509,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		 *  state as the LLDD would not have had an rport
 		 *  reference to pass us.
 		 *
-		 * Take no action on the del_timer failure as the state
+		 * Take no action on the timer_delete failure as the state
 		 * machine state change will validate the
 		 * transaction.
 		 */
-- 
2.49.0

