Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464513B0598;
	Wed, 16 Sep 2026 12:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789562685; cv=none; b=H8blJfq3RIqF1oXr8hjHVMRV6VhfOAB8fbFiWPRRo8s5zcUNG484ImHi+SkKHb8XwIpjXzZEilJXi45Zwyep3RzY0Nl2oW8L9WmF2qzNBtl6ZjSoQB1pqPa9rAlQXLEapd7ausEU1V1tCvVOiZRs1q7V0vLrdcjRd6B9O3TTf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789562685; c=relaxed/simple;
	bh=28h+a5ZIDW+KSk9cKWwepcCdX+f0vQ2iq6OYIrCia7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a+gNtBevUcaUXeoSLBF4RhfyjvjbvB6NoaBImfe2/T8coWS+ytmESJ9NMsZaY36MQ2mSxwt2OWfkuL52lk9BldvF8YnKuWJPq9tVragIOejriKgn3J8Mt1DeZ6krEW0a+7pm9aHWJmFoCaiofzQnxLFnxcCQgN9lwPWBbufwLPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=dCwLonHG; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=onl0Er8M; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="dCwLonHG";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="onl0Er8M"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hlJVx20gQzKn5g;
	Wed, 16 Sep 2026 14:44:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789562681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lUey9CroN+QLrQwK19JJ+n9O2SBbpWLy4W8bjyLufew=;
	b=dCwLonHG7CbT6KxzYS0M2m7s5C6hPm4lyyfQlKntZku7U84+2+rI6i9f2pEtzR6ak70Q6o
	F2aXcw5ZyyG6pywM8HvFvhKFvrNclpo1orDtxrXriy5Wfs1+ZSlV8xqqcw5Ps5U9pC3qTK
	DtgC9+BEIyBtkCHLfhVaeCG35BxtFyg3qh+Ocn+xYw5vudiIkMdU9bTLStW2CDf7INuWA0
	6XDsy/Sh6k1XLNVev79h+HI/1gijtOk/tc2Xetj0Lh3VFQaun8jAa9yPIzPpQlOAu3tEi6
	DXNt9SzZ9vE9BxEXmihtcKZnMjvMwj0GwTI3E+G+JlReRk610sFdpnH9lSLVbw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789562679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lUey9CroN+QLrQwK19JJ+n9O2SBbpWLy4W8bjyLufew=;
	b=onl0Er8MJLSoVKUJBnPRCsR4W4oyz6oilgNdqCuzln8G2kUPTlZ48UDUfN91Qso9/RYbP8
	ipGp/cAafNjcjfv+9P399Xwyt+KAuq68RsdBuMqInltess+w69f4IoZ9M9OnGKpyL+l4sk
	X460sV5rvg+YUdUZL9Jzy0bWgW0T6d7UWs+hqpRhR59nc/gbu5NdxFm0vhO5xG2ljnLEaq
	U4xk36CgggXmVO3SmgzaDz6Yc2tTkSifC8O5rGIwkqItc4WjKgNTDZ36r01R2Kdwvm4PIE
	19p6Ny0V7q41OYbcKbUCbTlaki/odu5ZZfe/U/Eghu68kFfr99enxCujzh+Prg==
To: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-scsi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix interval notation
Date: Wed, 16 Sep 2026 14:44:03 +0200
Message-ID: <20260916124403.315227-2-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: qwtzr95dhrf89rbhkuq37rjy7tpb9r97
X-MBO-RS-ID: 964b2241810823ec1f5

Remove needless ']' from interval boundary.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 Documentation/scsi/libsas.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 305a253d5..9ebf2bf28 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -75,7 +75,7 @@ enabled
     - must be set (0/1)
 
 id
-    - must be set [0,MAX_PHYS)]
+    - must be set [0,MAX_PHYS)
 
 class, proto, type, role, oob_mode, linkrate
     - must be set
-- 
2.55.0

