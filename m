Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9AA3191CA
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 13:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765545271; cv=none; b=Txl9AbqTUJb8IAslnntGbI9+oQZzXW4SQtO+BTXE5f6S14TehMm1cFWmT97sa69+BFBl1mUkDlyjuDa0kv1q6yQn8f1jGW4jXql6IdCcE6V5/zspNoW4VJPcFWMwkfUa6g0g4U32kqLQya3tVZLvWej4H8JQ7uA5ZntGTrwHD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765545271; c=relaxed/simple;
	bh=ArpbRacKJaduErwQkuNAou7Q45AxtpN3ucA1sTRhMtU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qB6LrKg4sRSiPaTTo2yMuolRGnOLaSGjhXGjKeRhZ3Nhr8JVadc5DzXJeIkoz5NM6uHRirkb8yRCoodKbQOEg/WOl29Lj6ZPNkA3+CgtnrhGWkrvkhBjb5bNIlAZ5mdd8SPhZm/swMyWisKaBsWrcgHxScMCz5pqc3BWKpGHXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.com; spf=pass smtp.mailfrom=posteo.com; dkim=pass (2048-bit key) header.d=posteo.com header.i=@posteo.com header.b=XqS41pX5; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.com header.i=@posteo.com header.b="XqS41pX5"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 90FCD240103
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 14:14:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.com; s=2017;
	t=1765545260; bh=rPK11aEpi99ck3AMk4uOc605JLQiBMqK5mCWiSM8Ul8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=XqS41pX5XMq2IS2gkxYjloDykOibGDPxd0ERhZWshucwSYZWXQcgIbuiBUiZhSXDc
	 xIFyt0EcwhGhRyH/2dG3ocd3SsSTM39P3AMYK6gwEHph0kRk5o8yAOD9amprHGEz7E
	 x7Sg6gtLz0KQAtlMeIRZ59CizHuZA0dls7pkoDN3xhojKhPjcem+7jmDyTPpMtlW7F
	 SOArAHN1257QorKr8pwnmkuDrHui/5w3giDjfZzZW36bLNtKYn1GEDdv2GOfcI0/Sa
	 zVa7TEASlGFVfm6U9CMrHY14vl7X2xPCcafPA+LRVKzwy44uK+UAEfJWYM5bljNnsy
	 AaAbjVbeuderg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dSVKQ5xGdz9rxD;
	Fri, 12 Dec 2025 14:14:17 +0100 (CET)
From: Zhaoming Luo <zhml@posteo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: dt-bindings: common: Fix a grammar error
Date: Fri, 12 Dec 2025 13:14:20 +0000
Message-ID: <20251212131112.5516-1-zhml@posteo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a minor grammar error.

Signed-off-by: Zhaoming Luo <zhml@posteo.com>
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index 9f04f34d8..efeae8f3d 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -48,7 +48,7 @@ properties:
     enum: [1, 2]
     default: 2
     description:
-      Number of lanes available per direction.  Note that it is assume same
+      Number of lanes available per direction.  Note that it is assumed same
       number of lanes is used both directions at once.
 
   vdd-hba-supply:
-- 
2.51.0

