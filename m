Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271E29346F;
	Thu, 25 Jun 2026 03:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358006; cv=none; b=s7qRT+4V7yCLspzCPNdc3Y9VwXs9be1iHX7jwo82KQRexOVQa3JIGD4VsNnsD+3dx4WJsuYyL6AM2H9HKhQepVqqImyJS3ZKXxNiXzf4axVp6I+kOAsBHu7h4Tw+w4kk67zMPvM2J1PhFWzjSwxnzrRRPB84C1k27FVtJZ3eRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358006; c=relaxed/simple;
	bh=qABgI6ZUKqRLjlxYBCvtaOLGDoZbhoLruRVYCHjb8qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBF2BpqmBVQ4XlIsnZBi1F2D8btfOGNf5fXIY5EvEjFwDhErXYGkWK6rknhLIclh3zkcShsOHouSCW4F56OQa2w3qk7jnQ2I5wLc+wTy3im/9k1CIKwj9+6d0cMfi8nW0Pk8VZcx7XC0r3oEoeK5ps1z1oWWYz5l3vzwKww/xFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j/P8uM5O; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j/P8uM5O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=qABgI6ZUKqRLjlxYBCvtaOLGDoZbhoLruRVYCHjb8qo=;
	b=j/P8uM5OEP5ghj5mouWvNsX3ybkzaQaB51hW6z/DAWYPJwWFNmA3meXjJX7/1b
	ZBkOkrmqPxk+HN5wWsOLYXA9FSVG0rgTj7T9dDmxRfcuvB8jHjW6b/hqyrCCWNQw
	kBr8PCQEEuesQTgLGxTCLt2Js1euGs2CcDKCzg++xAQTM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAHrPqvnzxqLrauDg--.57902S2;
	Thu, 25 Jun 2026 11:25:37 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Rahul Chandelkar <rc@rexion.ai>,
	Jens Axboe <axboe@kernel.dk>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH v2] scsi: bsg: read io_uring command fields once
Date: Thu, 25 Jun 2026 11:25:35 +0800
Message-Id: <20260626020000.0000000-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527191817.142769-1-rc@rexion.ai>
References: <20260527191817.142769-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAHrPqvnzxqLrauDg--.57902S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUoVbkDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRG9Tmo8n7EZrwAA3t

Hi James, Martin,

Friendly ping on v2 — anything else needed before pick-up?

Thanks,
Yang Xiuwei

