Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5256314A62E;
	Tue, 25 Jun 2024 11:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313587; cv=none; b=NPrM0WGmgcBtCsXmlHSDbEV1wFqa7pbvbS9rHcBYrnpRDKZQgJ28FKjkuEvRXsR/uMtFlz/8pC9qAUqtkJAqFCwWQBkBbg8VYO7DrWGnY3p2bZCcsWF37RqWeptuP7l70qujIXM6oa0XC0uZ3GSwOdq6M1I5/NdcC6AEbBqw5ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313587; c=relaxed/simple;
	bh=0mjG34OBIjvPM8qYsovrBQbSiC+pvkzNtzjDLVGtZKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJJC2strBSVsRZ059VTQZ/DiKY5v1w/6hF3hUThL8F37IrgJ/6B/KCS2u6NjHenr6pBs5ID+vRMNUJxLnFRT1gJUhjJ/8wJet6dPRX//IcEe8In1y3A+fKfC3yNwRTN5ZEdKcMmKuZtIRhdrJlX9PaTrNl0KGhUjj/jL7JsTJnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fUX+Emi0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fUX+Emi0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QNz95vpA1cO/SbF4XuegZuCC9VEq0KfwHWrqlxd8Sic=; b=fUX+Emi0JTdT74EQE+0OYmf0BG
	N5ARp9Clt84Yb1ew5C0DCU1ScprPFunhfybPN6ryjp/t27SrHjrvCl+7y2/jEdNMa/A0adiH2oaXa
	rDGibd1ydVTPGY1w5mCpvHCMpMVyNXXD1HL3BFqM1cyVgCe9nrzdbCPk8wtFSeB2OJjklu4V6waD3
	HMXg6VPRYwcSoliba2IwJpPC2MoDHEJ9W1wFC6auWVXCp1/FdBkGAXoge9HNOcVNqzHGPcWsm8gXi
	k8bmGItzG65WtpgP7cbpx9rXTe+RIjGWQd2Njbx92Is1+WkIjnmeNVe4RUT16tU7hH3woIlC721hA
	lRmNr2Bw==;
Received: from [2001:4bb8:2dc:2ee2:6df6:d2e9:d402:6e6b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM40C-00000002UKQ-1uET;
	Tue, 25 Jun 2024 11:06:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/7] block: conding style fixup for blk_queue_max_guaranteed_bio
Date: Tue, 25 Jun 2024 13:05:44 +0200
Message-ID: <20240625110603.50885-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625110603.50885-1-hch@lst.de>
References: <20240625110603.50885-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

"static" never goes on a line of its own.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 2ae7f8579de3fd..e38c522b3b6251 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -142,8 +142,7 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
  * so we assume that we can fit in at least PAGE_SIZE in a segment, apart from
  * the first and last segments.
  */
-static
-unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
+static unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
 {
 	unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
 	unsigned int length;
-- 
2.43.0

