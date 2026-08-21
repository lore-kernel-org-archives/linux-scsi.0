Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCAA3F8707;
	Fri, 21 Aug 2026 05:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289114; cv=none; b=H5ncUxc/fqNmyP+z23zH9wmh8ApJJY9QIZKp324RFBYCY0bp2rYetcTA7Vw/ebdQ5+ItwwltkZesvI4v0qIPSjVi/AgzNrlxBo0XTx7mGafF+b5G+7EAgMXNTjDKOUSGZu6jaoMQR9cEthbpaCwOTe+kAvmZxjmZUuyaBSfarOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289114; c=relaxed/simple;
	bh=svgvTVgHnOGKfBtPuTRAfxLSxJifVEsQny3na+RRPew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guQtLx9ykLnm4QadF2j98lsIUMcnFsW3zeqgqpmFkXVPef38NotEACRZFKpCRTrbdz0xgBjIG/43KkecSA1TwB/khGXw1NfhyOS8MSquPjCfdtJks3l31HlelMfg8GCNLeGvugFOcozrHyu/DFP1Pox/0pzaQr70fCkSzLzh4hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bIXUx9ZB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bIXUx9ZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9iM2OKyOZwmM2/nj6jRwvr+NMWCoRK5y6HCEKecDqeY=; b=bIXUx9ZBNZtUHDUO0dyXXbx/J+
	EegtXWeoJw4OvCI9SGPFSZeuKvx71MY7qMqTHVCdvXuW2Loo6EwiYIVhCxlCaF2Cukec16VZiFmSB
	ta+7xDTHWlKgtUv4E4ICaIKTMFUtGXMTpgN/ayBjdwl+tmhh9g2wrDa4EOOSlCGiFht7n7uafY7Eu
	KvqxGeFFVv9VFC3mR2U5If7fT3PiYBUYSCY8wff98iQeYnKkyBSrkSLeGMOz/C0UzYovO+/3q5bpe
	txTeLlPo5FG+XCax9L+ip9TOA1qFBXqRtUQdqlr4Yp//Eyj+43X+bU3dpLY9dl6Tj/TRBiQglhzfx
	CPJYoXYA==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXj-0000000CYBa-0piO;
	Fri, 21 Aug 2026 05:11:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/5] add a "pi" group
Date: Fri, 21 Aug 2026 07:11:28 +0200
Message-ID: <20260821051133.1817670-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260821051133.1817670-1-hch@lst.de>
References: <20260821051133.1817670-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a group for tests exercising T10 protection information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 doc/group-names.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/doc/group-names.txt b/doc/group-names.txt
index 424e2c4a1ca6..ef6b8f51cf87 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -137,6 +137,7 @@ tape			dump and restore with a tape
 tempfsid		temporary fsid
 thin			thin provisioning
 trim			FITRIM ioctl
+pi			Protection Information
 udf			UDF functionality tests
 union			tests from the unionmount test suite
 unlink			O_TMPFILE unlinked files
-- 
2.53.0

