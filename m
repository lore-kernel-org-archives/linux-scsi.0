Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515966;
	b=hFA1+AIuSJQKJyER5frltniLHtU3D8Mgkyo7tEOgF8Xxtt6Eoaj48ammQJoWrxQUBbmF
	 ft6grHDAAbn3WGfnoqkkTNCRlAz+GQYhaZkci0pTe3usmc9CqcHE7BnbQwXy4TDj+FUUM
	 ETF+RGi+7OkPMrJdo5mb4LKOpQziChf2EoYX3Uuk57e3UTXpuJCkieZzGXtU69hs/TMyg
	 YmTv6xGVpMRFKOT0Mi1eYv80MKJpTg7jgEBxPluOkx1J5HGLyH5MLFkpQrYwgTiuRlFs2
	 YeSlknhTgEoznbJ3FiCgOXNuhTKbDJBiV74WZgz9Fgi0BP0vARNbDwcpJMa/F2paxcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515966;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=uT853e48QpIr8qFM5HFmiwLhXn/KALQhvBNFDd0B6tY=;
	b=mm0I4Gt+jBGQFhriG2OSw+nGiTE7pGjsOCL+07Vky40eG75kqjUO2aTxFB7ykH1BZXu6
	 a5hvLq0ZupGIruftJH1pGJ9cTAD5jhkhrtFcS1Ec8z8qGkAHgLpj5Srb/b/Zybqyh1gQj
	 IptzMPVEx6BL+HWuq+DIplOOSMQl7RQWMwkwuylJdXR+CY6YBXHC+60gWW+KmGMkifydc
	 M+KfGEDcri2zPc5YbkEfk2w4wk9lpezgAOSD46ndtFaXgdYNKvk/XLDNvcolYiaCga4po
	 b2DHvtRySV/okNSJKfqt68g/wvPXOsNmUhrxRh1UswuFIgnhMnO0NdKJZlmz8Nez/HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="zYp+d7K/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE470606A325;
	Tue, 20 Oct 2026 17:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE470606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zYp+d7K/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uT853e48QpIr8qFM5HFmiwLhXn/KALQhvBNFDd0B6tY=; b=zYp+d7K/+RjFkvbJ7tn/leS7Br
	B90sjxnPtb57+3DLOn+KCAYUkKY/LNcVa6w4NyRQj962X1+CaWPbG+Iz32vzBvAf2CUU2w6SZ1/TI
	rrxlKLVgOBVoHM7tVQYk2724o7tbD27bpbP+uhTNTLsN+KnOCzt9l+T8FXFAG4tcha83n8fD5eE/k
	cDyWaXF514sp4vPKGY/9u/qPDWCR65AmOAhHMyazY29f+eeMjuRWPGa9gIB54ze9onF+CbH8pLT0f
	ZAJl7onkPtdVYhiKA/zukuTIz0UbdAEljMBrKDSu3OeMTR/u7kMfgegxXD6/9OYawlt0EexJA/MT4
	gEYPRSwA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xJDHo-0000000AJOd-1POx;
	Tue, 20 Oct 2026 17:06:04 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Phillip Potter <phil@philpotter.co.uk>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: [PATCH] scsi: core: update cdrom.h coments
Date: Tue, 20 Oct 2026 10:06:03 -0700
Message-ID: <20261020170603.3692218-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the location and ending value of the cdrom ioctls.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org

 include/scsi/scsi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20261019.orig/include/scsi/scsi.h
+++ linux-next-20261019/include/scsi/scsi.h
@@ -176,7 +176,7 @@ enum scsi_qc_status {
 /*
  * Here are some scsi specific ioctl commands which are sometimes useful.
  *
- * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ * Note that include/uapi/linux/cdrom.h also defines IOCTL 0x5300 - 0x5396.
  */
 
 /* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
