Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15E738C2D4
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780422701; cv=none; b=tgRkM0dG6gvP7D9kpkoNR/pUJ9oOwm3qbsTpD/w+ms6AASlLYs+04DlHyFstHg/YOszhJbAF5D0Bm+IKf2hOHEKpk5HI2F8Hf/kCrgZ2HwmK8uVBs4yrFQ0TuU/hSjcSpp6iFV5kpiQr+SKTMKKho0ZkgxJ46EcylLTv3LgZYN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780422701; c=relaxed/simple;
	bh=KaG+niRaD7Ir6Mh2s737LKzS3Xej/O3jfbjYmAtdu2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VhaxQbYa0e9DWjjye98Uc25OBLJhzuPV5EOwUA+ceMGC0T7krQJQQU2bo8u1ZmDalbKwRhSXaecEQkXhARfzCxN1d+Z6qcPgH4HmdrD/eBFrnWSt7IUywYIN/K7EyOtkhSHa3bQq+64UoqCLVEEsKcpmtsSsda+iZsJiAk0FCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xyO+Asj5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xyO+Asj5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gVJL22zt6zlfftv;
	Tue,  2 Jun 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1780422695; x=1783014696; bh=KaG+niRaD7Ir6Mh2s737LKzS3Xej/O3jfbj
	YmAtdu2E=; b=xyO+Asj5umSRQgLJBxKZVj6f3GnTdMlI9dcNYSYBsdmny0RAPf2
	HZFk2xPi7cYAAkD+4uJeGlUjKVJHGWtz9Kcy/uXEzcr13eMWVnbxYov95qUoxrum
	TRtJazYYfJ7241TydiruFT/DLD7bt5IJnjBdR4HRYDPXI36voiHAHDcRVcu2NhGA
	ekVJq7p6MDQUq78ULNlJm+8HmKQviibzcJo2YQn7xgbUlPzgqEegcN+vD2a+r2Cs
	z5M1HoqTnNOyMdNPsBNeMaRPFkEU00wBikkzqolZVnFqmB4kyXQCWWswuTitDdsH
	ge5nLCMWnqcjRsy8Lj0CsJd7kPaO5WtcF3Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6RR_zOTBazqx; Tue,  2 Jun 2026 17:51:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gVJKw6K28zlfftZ;
	Tue,  2 Jun 2026 17:51:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] mailmap: Update Avri Altman's email address
Date: Tue,  2 Jun 2026 10:51:25 -0700
Message-ID: <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.1013.g208068f2d8-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Avri Altman's email address changed from @wdc.com into @sandisk.com. Add
this information in the .mailmap file such that scripts/get_maintainer.pl
produces the correct email address for UFS kernel patches.

Cc: Avri Altman <avri.altman@sandisk.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 34acd34bbf9b..d5844d97b3ff 100644
--- a/.mailmap
+++ b/.mailmap
@@ -116,6 +116,7 @@ Asutosh Das <quic_asutoshd@quicinc.com> <asutoshd@cod=
eaurora.org>
 Atish Patra <atish.patra@linux.dev> <atishp@atishpatra.org>
 Atish Patra <atish.patra@linux.dev> <atish.patra@wdc.com>
 Avaneesh Kumar Dwivedi <quic_akdwived@quicinc.com> <akdwived@codeaurora.=
org>
+Avri Altman <avri.altman@sandisk.com> <avri.altman@wdc.com>
 Axel Dyks <xl@xlsigned.net>
 Axel Lin <axel.lin@gmail.com>
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com> <bgodavar@codeaurora.=
org>
