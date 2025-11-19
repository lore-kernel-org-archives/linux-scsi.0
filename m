Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B4357A23
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571494; cv=none; b=Q0RVFBI/faymh5mGiGRQJ/zclM8190vFjGNxtdIntC33vXyUvwHxcajETnuAzECkoq5E1lJPEio59SzAnA2MTGYAvuF+iF+VHWtmL0wvNlaaad7Qh/zXLf5fNevBZmFRuqlIvDNY1ldbM/cy5+iEMRmjSFYT/WgFuQlMBV623Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571494; c=relaxed/simple;
	bh=MNyRt9uaCp4IUo6SoPTJemXekTlsqDu/gXEHV8s6LpU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e8jr0/Ji57J2nTmN6TmQ+UlB98amKFwLeB+vwFtouZt3yLVnW0slTeV2uLhZrpjOKlb23F59YNsdz0EMXuJ6h2HT/OaEUUXRafSkTz+s7cqcuPmVw0u/zTCcxlkhN494kUBvCoRmWgn1cWzJnSw65EKdmc6rXOQvU/bBSF/SJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cH66krHX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cH66krHX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dBSN92nbKzm1DtB;
	Wed, 19 Nov 2025 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763571480; x=1766163481; bh=YYw1B
	iv+BuEE4veLTDakVlRFxFogb2UFCQyDGTQdBd4=; b=cH66krHXBI0QBeDuYBGdP
	JBiBVJAAVTkMb51sX+y9l39AYmHtgm/MNikZW/PJJ/LLz1aF0S4XpnZx+9fgkkGa
	DFPjbOxTEagSk3aTWOKHuf93Hv3TdWNvObDXpu6iIzZRJuVNkqHSJr2XrTpTduTT
	PDQTB782GhHRv6KUgVzwUSpe+FdqcqPAslmtctkczbI2jSGC1IKJgfFes5LFJPXD
	BsfjzdsBS7E/yxuFkaNaec47498yEZnzxY/AQFXyc2C55Ti+iDvJrVutT+C1Q952
	T3SEex7WPayvKnEl1PrfAWvzBDE/L2wp09P4TTfJUM3cUk9adBMPHcqyQU7GZc4m
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id llegSQQvITf7; Wed, 19 Nov 2025 16:58:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dBSN61YgGzm1Dt5;
	Wed, 19 Nov 2025 16:57:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] MAINTAINERS: Add the UFS include directory
Date: Wed, 19 Nov 2025 08:57:32 -0800
Message-ID: <20251119165742.536170-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Make sure that the linux-scsi mailing list is Cc-ed for changes to UFS
include headers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ccd0f7d0c2bc..49bb3a64b905 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23041,6 +23041,7 @@ F:	drivers/scsi/
 F:	drivers/ufs/
 F:	include/scsi/
 F:	include/uapi/scsi/
+F:	include/ufs/
=20
 SCSI TAPE DRIVER
 M:	Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
@@ -26338,6 +26339,7 @@ S:	Supported
 F:	Documentation/devicetree/bindings/ufs/
 F:	Documentation/scsi/ufs.rst
 F:	drivers/ufs/core/
+F:	include/ufs/
=20
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER AMD VERSAL2
 M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
