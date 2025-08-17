Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685CA19F11B;
	Sun, 17 Aug 2025 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755450351; cv=none; b=oGIcCdxJOz6fC3iNjv4nScZfiDUr64kC7UcdEiLwMY722ri615B57TLFbNfSa8qwUip3rMOJd5dwQrLMa1+Wc9DxAeP75UED877U+V0Qp6tm1y9X4fplg3PaHxBeSV/GEl1q8IAZnAQA+meNDSgFKuLDhe/rdDnVkz6CP/O/T8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755450351; c=relaxed/simple;
	bh=I/E3eG7XY11lPKPsk33mo29bW1hDW2w2SRc+rX5TwJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cl+viWEI2a961teL9LOoTsIpG85CSWAU8hV1fKnop99wt719ICys9/fjipyry2d6iOKrfzEaapoAVC0JJ47jWw9LXPBN9xdvFxC61hGlmByNMFJ3At9X7AUqYyOwRj0Mc9eXWUnxqSabpmBVxqeGhEU4v3D9NLn2osfLlMLGnMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=leE73/Dd; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="leE73/Dd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=I/
	E3eG7XY11lPKPsk33mo29bW1hDW2w2SRc+rX5TwJw=; b=leE73/DdfZnJfv7Cq3
	ttd7Ovnpo+MNYdUeMzM0iYQHdtvkvsBtJJXhcC7/c5ZQGxiqGDtemy27w17OC17m
	i++akfbY+hDRsz3s6pLskeWRHsdiAzfqvYWH/EH5Z9dAjU0rlmqjyCzDKDMt5ONw
	PYL3KOGxIb9WJruw5j5pWdp/g=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCnrxHiC6Jo5TkwAg--.17785S2;
	Mon, 18 Aug 2025 01:05:39 +0800 (CST)
From: Yang Xiuwei <yangxiuwei2025@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH] scsi: target: use IS_ERR_OR_NULL() to simplify error checking
Date: Mon, 18 Aug 2025 01:05:36 +0800
Message-Id: <20250817170536.2656180-1-yangxiuwei2025@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250817090324.2333676-1-yangxiuwei2025@163.com>
References: <20250817090324.2333676-1-yangxiuwei2025@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgCnrxHiC6Jo5TkwAg--.17785S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUV-VyUUUUU
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbBDhCskGih+9TEBQABsE

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Please ignore this patch.
A similar change has already been submitted by another contributor.
Thanks,
Yang Xiuwei

