Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3691B85FC;
	Sat,  7 Sep 2024 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725716648; cv=none; b=pfi5+o9NHHuMqIKLLqcdEl0a5nB+pdMEu+f1eUGNuMEAgXd3QE8QmGHQ/ga7A9LdToLsxRJnBlfr+y1WxkjwIXK+znzIjw8FqWb/Nq3nMiKQJ5Yir6tUPbAoSbBFHHtaqnw1/fIof82LN0y6VmUkZaCW4Kl/g6whP4iF+FCf5iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725716648; c=relaxed/simple;
	bh=mDkAw5omsoEZBD5wLg0jIFkoCZcWP9v9zsMS9k/Rh8I=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=CwC9nhaTq1LdXA3TU90zQWZ9UnMNvxFRzdKtw09ggkDfJf3JnjQ+S7v+q2k9K3aexWLlEG0ItEX1PBtgg5ajsdkF+iVvVRRklHiDX+2eeVJwYfqOU/NfShfkOaeTo5bozopmQhi67ikNkTyloF5o6i7i1PQ/XUFG8DDQ1brKDcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=wC9kykFL; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=wC9kykFL; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="wC9kykFL";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="wC9kykFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1725716645;
	bh=mDkAw5omsoEZBD5wLg0jIFkoCZcWP9v9zsMS9k/Rh8I=;
	h=Message-ID:Subject:From:To:Date:From;
	b=wC9kykFLI0TxMGQCTBAxkkLWY+LnavFG0Z8ToCQv4cZjlQU74f4OfyvBfa9b2U1we
	 6qAYROXpCgHlm1wp/B9Ww6F+p46b7EPT1kBFteOX21QmyS9lSIFQ/0AiF+4JFChLJc
	 99DsjIv5aJb5EuzKlFfqx5ij6a+oQSOBItLOKpXQ=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 55878128039E;
	Sat, 07 Sep 2024 09:44:05 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id tGPpxpCgXES8; Sat,  7 Sep 2024 09:44:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1725716645;
	bh=mDkAw5omsoEZBD5wLg0jIFkoCZcWP9v9zsMS9k/Rh8I=;
	h=Message-ID:Subject:From:To:Date:From;
	b=wC9kykFLI0TxMGQCTBAxkkLWY+LnavFG0Z8ToCQv4cZjlQU74f4OfyvBfa9b2U1we
	 6qAYROXpCgHlm1wp/B9Ww6F+p46b7EPT1kBFteOX21QmyS9lSIFQ/0AiF+4JFChLJc
	 99DsjIv5aJb5EuzKlFfqx5ij6a+oQSOBItLOKpXQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C2E751280393;
	Sat, 07 Sep 2024 09:44:04 -0400 (EDT)
Message-ID: <27f70daa7591cc513244457041cafae3e1949452.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 07 Sep 2024 09:44:03 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Single ufs driver fix quirking around another device spec violation.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Mary Guillemard (1):
      scsi: ufs: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP

And the diffstat:

 drivers/ufs/host/ufs-mediatek.c | 3 +++
 1 file changed, 3 insertions(+)

With full diff below.

James

---

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
mediatek.c
index 02c9064284e1..9a5919434c4e 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1026,6 +1026,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
 		hba->caps |= UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
 
+	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
+
 	ufs_mtk_init_clocks(hba);
 
 	/*

