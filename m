Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E072833E363;
	Fri,  6 Mar 2026 02:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772765252; cv=none; b=FCJFY6zkvOmXAcA+1Bk22EqDlE6Bd73ke7iZV4NMZAeNQdC+YkzrJodiUC2PohOsO7mIQ2LaoFploJfiFMfuekan1kqyRk5Ioulb1PCwWbDxIeVyAKyIil/s3unSlma5L484el0HXpoIauqeNB0kAF7k2MUcI4grfJCH8vQXpqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772765252; c=relaxed/simple;
	bh=ss1qzT2zGltopR2HmNiT0A8layIVs3at5mlgB6wi2U4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKF6uoaIq7bsC/OBDD/a+LWocWeZZdATRSz0q7E34xp9IqOOPJLQwq/j4PdHzW/4cYr9EW5K1QoSEYgADu9ZbpSe82mpfmRA9W0eLv3mc0a5xctZyGkZ/wLxIDmdC1sAFYMdnHlyTPi8XCbV2pH91o99dCO2UhPGwKlgexLCSGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qUPRU+T5; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qUPRU+T5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ss
	1qzT2zGltopR2HmNiT0A8layIVs3at5mlgB6wi2U4=; b=qUPRU+T5lBV8hRVgez
	S4iAmjixh3FqBZ1l4bfhzxeJDzLpICg8CpxGonEE3VIp5u53jenTVFBNGa07CCrr
	eExwnkbX+9WHE+o0rZTlEo5x0WY4FOVkohhgZuAVnP5c9n4ONFsRy97qyXZ/XZ4s
	cr4MhMD3rt3OEOkr8+tn1jwnM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDXPv0DQKppel3WPQ--.833S2;
	Fri, 06 Mar 2026 10:46:29 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yangxiuwei@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Fri,  6 Mar 2026 10:46:27 +0800
Message-Id: <20260306024627.58267-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3ce6f611-330c-4705-9842-f85eb9a13556@acm.org>
References: <3ce6f611-330c-4705-9842-f85eb9a13556@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXPv0DQKppel3WPQ--.833S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUo38eUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QUWpmmqQAW72wAA36

On 2026-03-05 15:12, Bart Van Assche wrote:
> Please send a new version of a patch series as a new email thread.
> Otherwise the new version may get overlooked.

Thanks for the reminder. I'll send v7 as a new thread.

Best regards,
Yang Xiuwei

