Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263C0409280;
	Tue,  1 Sep 2026 02:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228485; cv=none; b=VT+NNxTNRyje41aEsbv4Az04lrLQMeHGVBKtfbA377pVvqzobcoakn1uhrJr86twl3oRhWLGy4rgdeatZksGZeuygpPGZbCV47VO/7y9HPVDJW/t32+D93pPqxe7sjXu4bcyZ0mhiPRN2wPNGZGyBynC38NKIrI7t0I2XQDANAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228485; c=relaxed/simple;
	bh=hvJsXWzxiHQrbVcQ2y+WDFAWpLlcdjburqb4QvStLZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tRk3rdnJPLXM3brAoOnsMdhOGdd3umGJkjmDENz+yAVWHYTCSlj8MiVBa8mAtj2g/UTwGwsl8Tu0l20Pq5nTlOutLodL3Nooh5IjLcpJJaO/guxmUFWUw9mQw4/qb2HtrllEx3rl/yujHKmnfcTTdjHrJKQEkaX3SASwZNI0hoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jlnH4M6P; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jlnH4M6P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hv
	JsXWzxiHQrbVcQ2y+WDFAWpLlcdjburqb4QvStLZM=; b=jlnH4M6PCqX+amFsFM
	BKOwJKTEl012YUmandVG3EAzk9AdVGLAXbZLETgeKag2zt+V0Kywg/BbVqcKaVyl
	nr8iBF45OmxNOYQru9Tc0WJmdY3SCBIx4brKNBMHoUHVdfs6ZvMMaTl8PMb8qnBW
	3wB2MBbf17arXOpBS/8zn63UI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnzv7hMpZqYMR7TQ--.14746S2;
	Tue, 01 Sep 2026 10:05:22 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: yangxiuwei@kylinos.cn
Cc: James.Bottomley@HansenPartnership.com,
	axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	rc@rexion.ai
Subject: Re: [PATCH v4 0/3] scsi: bsg: io_uring passthrough fixes
Date: Tue,  1 Sep 2026 10:05:18 +0800
Message-Id: <20260901020518.3253163-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
References: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnzv7hMpZqYMR7TQ--.14746S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUb4SrDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QIFlWqWMuLd7wAA3l

Hi James, Martin,

On Mon, Aug 17, 2026, Yang Xiuwei wrote:
> Three patches for the BSG io_uring passthrough path.

Gentle ping on this v4 series. 1/3 and 2/3 are Fixes material
(sense overrun, SQE TOCTOU); 3/3 is the GFP_KERNEL mapping cleanup.

Anything else needed before pick-up?

Thanks,
Yang Xiuwei

