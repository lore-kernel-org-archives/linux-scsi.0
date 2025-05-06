Received: from smtp-out-01.ironnectar.com (smtp-out-01.ironnectar.com [54.36.210.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE7613D891
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.36.210.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746560058; cv=none; b=EuPiZGk2p7Zm7uRNDi3WIhkFE6cWHnTDC0xxKRr8oSlqbyau0SCCTnK+yxRFDLZXFs600PMkI0kxWpSupqYUZUxHLKLk7ennWSVSMTGEdgjDZIz74olcBM3FmFp8R6Zj6IGAuMLAKv2DyYQHCXAPB4CmGgRRZgkgMzdc1DTH2hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746560058; c=relaxed/simple;
	bh=zCJtVWEe9cevGBBqdcB8XGxTm8fiPnXPMvEZC59mffk=;
	h=Content-Type:Message-ID:From:To:Subject:Date:MIME-Version; b=fLOEJTL+Q1R4X/r8nEM8sLHGt9jp71m6UP68HqF5NAZQnc0IOOp1xBec4k2bZDru8NuSDrgxDmsU/XJawN7zznhfMtw0qA6weJq4WL6PZ64ay4b/hejn207nyEqFVUpb0DymBHRZF0HlvtPPKxtOTpvAAJJXNlMXNmHfggjkVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fromengine.com; spf=pass smtp.mailfrom=fromengine.com; dkim=fail (2048-bit key) header.d=fromengine.com header.i=@fromengine.com header.b=X0pKbav/ reason="signature verification failed"; arc=none smtp.client-ip=54.36.210.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fromengine.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromengine.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fromengine.com header.i=@fromengine.com header.b="X0pKbav/"
Received: from inbound-int-01.ironnectar.com (inbound-int-c00158-00001 [10.250.0.157])
	by smtp-out-01.ironnectar.com (Postfix) with ESMTPS id 26CD17E496
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fromengine.com;
	s=mail; t=1746559074;
	bh=zCJtVWEe9cevGBBqdcB8XGxTm8fiPnXPMvEZC59mffk=;
	h=List-Unsubscribe:Reply-To:From:To:Subject:Date:From;
	b=X0pKbav/FzTWMbaxhOvr0yPBph4yCP3oCsBnEewBIf3S/6K/R8jkz2cGLKfz5x68d
	 P/7MIJRddAUHiYUmjOnP2CxLkgc5nOYsaPz/T3KTkOcJuzKiZFqHZRS0mAHb+T6EPB
	 yqdlyF6jNL9eGecCno4FPss7nTNLwiOkK6aekOpoHmwYiEvkNKMCwqQw+qfrhrdRPc
	 cM8ZQRUv5E+p3eNAZl7eU8f4sKVHEb+BdQ2ZhMCtw5ifQpIFLBF/trkhsWIZ/4sDee
	 9+Jyy9T1MacUYTBTNq+nJGn9ywGix4diCcdAtCXqQB3O9NibJqhFfzT4Vy2EhKiFeU
	 KtDQcTzzxeMfA==
Received: from 2b9a7363-d56d-40f9-932e-20dde291dadf.local (ec2-52-91-61-225.compute-1.amazonaws.com [52.91.61.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: madison@fromengine.com)
	by inbound-int-01.ironnectar.com (Postfix) with ESMTPSA id 4B6407F28D
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 19:17:54 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Message-ID: <2b9a7363-d56d-40f9-932e-20dde291dadf@fromengine.com>
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Reply-To: madison.wachter@engine.com
From: Madison Wachter <madison@fromengine.com>
To: linux-scsi@vger.kernel.org
Subject: Travel supplier opportunity for SCSI Trade Association
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 May 2025 19:17:53 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hey SCSI Trade Association!

Madison with Engine here:) Super excited to =
reach out - I think SCSI Trade Association has incredible earning potential=
 by adding Engine as a travel supplier for your members.

We're already driving massive value for associations like ASA and ABC =
(through both revenue share and sponsorship options), and their members are=
 saving 26% on average on travel.

Our free travel platform gives your =
members access to 750,000+ properties, 250 airlines, and 40 car rental =
options with no contracts or minimums, while generating revenue share =
directly for your association. Plus, we have a special offer for your =
members: spend $2,500, get a $1,000 travel credit!

Would love to show you what we could create together - want to hop on a =
quick call?


Best,

--

Madison Wachter
Partnerships | Engine

CONFIDENTIALITY NOTE: This e-mail and any attachments are confidential, =
should not be shared, and may be protected by legal privilege. If you are =
not the intended recipient, be aware that any disclosure, copying, =
distribution, or use of this e-mail or any attachment is prohibited. If you=
 have received this e-mail in error, please notify us immediately by =
returning it to the sender and deleting this copy from your system. Thank =
you for your cooperation. Hotel Engine 1601 Wewatta Street, Suite 250, =
Denver, CO 80202.
=C2=A0

