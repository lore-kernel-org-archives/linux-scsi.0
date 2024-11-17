Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE42F1D90A5;
	Sun, 17 Nov 2024 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731851561; cv=none; b=prVHh5eJj5Zlg6zoxev4YZXyYZt8y0+/nVXG2iKfG0oNRJKqXVzQ5BdT2TdZEaXWUAEzPeAJaO8ZFLUyoMp6yntHJQpNWwqU5elWUwTnOsoJTMGgDWZFzy/pIvqojKCcjTC1zGJuJ9w8UKkBgMRD6grTpCM+fz8ZFNFspMCkZDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731851561; c=relaxed/simple;
	bh=ObcO+Gr8TCkI/gLytzm1vnIEBUyIOuvWYCyed7ryV2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dXvPhJWMfrUHs59VUTXlsp0UAkHhyTztjQP7OuMZWxyO452rT9X52G4/Wj5FdfbuMx/bced6BRbZ/9AMzLDjs2waR35mvRI6bVZTeJS6vekB587O3/DWNtJ0xM+Pf/YvNTzBnjqA30j13HV3yUvqtPHFF0DuEuhSALNQtjIkdYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ZmWcIu+O; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ZmWcIu+O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=ZyBmIjTIcSGbctwyBnIM3F3AfWbOl1Dn1J1hUcvpU0k=; b=ZmWcIu+OPQtrKDSc
	3qUunJJTSGcXL4QXerHQunYFmtbQ4y5ajLsc5GCtIf0sHA2vJZM1oonhe975mEwDfeB5RxENl3fYO
	sPooZyV21nsYnCuM3UPEtto8QWeGPgL5djkAbmd5OQSiqLL4KzoBF21eBJkfQ1CAPz7UspDZce+yP
	Fk4j8D9dKEgybiwf77HlNpSVUt1xb52Ee1z94/YWgwvGKT5pXa80ikgzWmsp/OkZ0Rs+evPrAd5PX
	fvdk3haasbbSoq7t6z3DFVRSMMst7po+qjQCX7HBTSCod8BJlS9qoCJvr9eERY+b+Nxsk5bc7p85S
	IeNnhfYH1SQ+Ib2wFA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tCfhI-000MsI-2r;
	Sun, 17 Nov 2024 13:52:16 +0000
From: linux@treblig.org
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/2] scsi: bfa: builder/parser deadcode
Date: Sun, 17 Nov 2024 13:52:13 +0000
Message-ID: <20241117135215.38771-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  This set shaves another chunk of unused code out of the
bfa driver, in it's structure builder/parser helper file.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>


Dr. David Alan Gilbert (2):
  scsi: bfa: Remove unused structure builders
  scsi: bfa: Remove unused parsers

 drivers/scsi/bfa/bfa_fcbuild.c | 482 ---------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h |  72 -----
 2 files changed, 554 deletions(-)

-- 
2.47.0

