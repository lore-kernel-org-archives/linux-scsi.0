Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332446A5FB;
	Mon,  7 Sep 2026 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809094; cv=pass; b=SZJABxXGkvtNnw3FCtVMNO/odBkybmqxyprfD2mj54P9YVbiX507NiCE74arlUTOMQy/qf+f+L5Bt1ZuOXVkxjtcW3Lx/iYBj9zCmY0SABzklbI6zP10ycjrDpB3rxO1LwfH/S7t1xMOBymGfrc4EMcrPznyXm4nQWKxtnq1KXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809094; c=relaxed/simple;
	bh=pGmlDyj6kEi/pZlOxdkNgatuXW5yQ2y4hlNY1o1vB18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GeEwuGnomC2YpF0fq3nmw0u/YtYy7gkXrg9q0LYgz1lNvuXxxqIVw/EcpwuVOs/28relkpYY0oK8Jnfm/nambaaQBrqWwWpUOvPY0G/XNYW4V9vTPQ9iymQRqzrAqjvZ9n5Hp8iTR95UZdBDZvE8FBWD1F6m/bNFwJjjzfbjMdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=hoeZzi4u; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=4wX1GCC5; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="hoeZzi4u";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="4wX1GCC5"
ARC-Seal: i=1; a=rsa-sha256; t=1788808910; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Dbf6iZZv5k4DYBI00dHHz/LyZqAEzYBim6OKB5X4T1Iu1duuYfE7sc0cHXyt/vTTqP
    k9HzC7WSKyJxlvAUm4ef45fBV7fwed1J3pgv7YQvpjB/goq5Bl3rFwAcLm5HFF5v7AtC
    FfsNfr1E2fMpxyzeJDctlOqgqccnwXnbk3PwxyX4NAi/Eh5YPGZlQxk0rmQWJtnM4dKO
    EF9EBo3eYISBn8tnFi2TQCdC0BjGA2el9ch8x8335zIezkmtyehggxNgZrTGVBbR9Lij
    5xhPm4ZbNA3Ewwz09NZPNIEBWoJikUIDzlaewc4I5WJhHxS48Y/CKla9yAycPTEkJQY+
    thPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=HYkoDkMO58/ar+Od/v2oKjQULCGRUjQgFPoaO/nCErs=;
    b=a9hsPhzpWEK+J8Q7oBE4P9D5A8MioXb/BjmS411DxhV5oCx9U2EmTVFBYZZ1gFQ3Bc
    MaJeiezxhQswCtq1ZCsbAD63ZGf54AKi5q3OkY7CoTZziUuDwHmefB60t19y0khoTAda
    +rnIeVQyIkjnJohL7u9wFQ9JKDuj8pbHc5OtSRNfDnvxCW5InwYBhA3fOrM0dEht6pds
    0N2q1+TzKejmApuAYmODl+UJLbF7LuIhG2KNg8XEV3N7+F3EzZrWBfB79/JY3+rsSDS6
    xBKYcXuJFKUvZGPpR1FKhiyhGLhXQytBSCJ6SIyl9mPGlaf6EbowI8cfHnUN/S93iWz/
    9+ig==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=HYkoDkMO58/ar+Od/v2oKjQULCGRUjQgFPoaO/nCErs=;
    b=hoeZzi4ucGWuVVVxta++wmKuilSUj6VY70xayZhCw3gKEZJpyuTa4lZswF5Ct8lgjH
    COajdiBMXViACpUrelXTZtBB0cjcDtg5R9ZFh7UsgXawKSh/Yp6Q2qxtpH7tp2C8cJ5/
    +LfMX/K/0AyBkX+JZSy27wjoPK8gNRRozR+plSuyWKqME1VjGTQkpgTjtTsdyY9yxX4n
    +GtObN4iawWQs/W+UVxyMCOGgfRDXTTmCMRd+Zvzh+2DYdxVsAyNqc4W6vPH4jTCyJE0
    +0YZLgypluO5siZagOQocnzLDdpdfBAxcrN5yVzbeA7o4fTIoHnIAowKWNMRFTuqzySR
    r9/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788808910;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=HYkoDkMO58/ar+Od/v2oKjQULCGRUjQgFPoaO/nCErs=;
    b=4wX1GCC5PhtDW1UuaMNyX5SxcuiOqyUcFqgGWShMg4vC3u9r4ZKoIWpZ6Sx3elfC1t
    xkIhWiWNBEExOs1Jd4Dg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O0JuBIIyqXfWze4EsqKg="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287JLoCsK
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
Subject: [PATCH v2 2/4] PM / devfreq: Add more details to the get_cur_freq() comment
Date: Mon,  7 Sep 2026 21:21:38 +0200
Message-Id: <20260907192140.2701755-3-beanhuo@iokpp.de>
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

The comment for ->get_cur_freq() only says that the device should
provide the frequency at which it is operating. It does not tell the
driver author which unit to use, what the return value means, or that
the frequency should be one of @freq_table. These have to be found by
reading the devfreq core.

Add these details to the comment.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
---
 include/linux/devfreq.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index dc1075dc3446..809ef29b9af5 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -90,8 +90,11 @@ struct devfreq_dev_status {
  *			use this directly. Instead, governors are recommended
  *			to use devfreq_update_stats() along with
  *			devfreq.last_status.
- * @get_cur_freq:	The device should provide the current frequency
- *			at which it is operating.
+ * @get_cur_freq:	The device should provide the frequency, in Hz, at
+ *			which it is currently operating, and return 0, or a
+ *			negative errno on failure. The frequency should be one
+ *			of @freq_table, as it is used for the transition
+ *			statistics.
  * @exit:		An optional callback that is called when devfreq
  *			is removing the devfreq object due to error or
  *			from devfreq_remove_device() call. If the user
-- 
2.34.1

