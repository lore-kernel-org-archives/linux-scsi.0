Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792976887;
	b=s/+h4cYBqzRRI+tipx1usctUmv83WnrGRh4kkmYCiUwdih3uhioAeUfWL0v9MRy1CrlU
	 J9Fg9CjPqnD5FJfkfKPxC1lQptkeI34dCjo6zd1Hl9OIG6ot27+YZpi02/5H28ma3HjAD
	 zxFBMdRGEKPJBbUfEAvgnX1YAkJYSOtLJ0CoTcTkPeFijPRvOzVtDnOX4cM2ssm4VRwGC
	 zlmDta/ZbUNCXMET8JqGGYS+SJ5KB8te8zU2C9u7uaGtAeQzwgxoC4FfEA2njjMMMVgj+
	 7/O6w4YGjtd7pE3UD6ty6R1rW+Y3LJy3z2SHrjeXxwZfqUHPxZe88yEgFLMTssOWnIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792976887;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=PvbCmZ07DI9O6HQMV2Va+P3QVvlNTXPgmDpuvb/m2vU=;
	b=yojPPv47U4EaGs4J0cxIZ7yp41bv0eQ5zON8gADwYbqJKfzVWEXo+mayd7tJHlkap+ia
	 5YezHEJZjsJ3xaTpAF1CIjIG+P4MtlHH16M31+IDrGClTcR51q4BAzcI+TVHA69xj4k0E
	 Z4ImKk7BbBrIQkWKLs6c8I4tBdb83KJnuc7g1M4mLEKt/Pz/srg2/syFjZDFsRqsGvwrT
	 35o3/lg6uYSTna8AWrOSjONhAqLZMzJq2Q/nmYILLvwRSjyOoJ33hPRZ0eopJkPVvY7Bq
	 UOa+7MEp6XRI1EeEklPlBG8rhn3XvRDLdZ1SYxfrSq5AE3qqDISR2hrpPMgxweIpIIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fwo6ve84;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319BF606A31A;
	Mon, 26 Oct 2026 01:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 319BF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fwo6ve84
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Pv
	bCmZ07DI9O6HQMV2Va+P3QVvlNTXPgmDpuvb/m2vU=; b=fwo6ve84Ze/Zvtex4G
	LLCdpyUdVK8jzTvcdvDNI1gYUdcoCMoZp02OYSi+uKTprVeM1oVSivhan9klAgAL
	zbOlFEDmtyvi5NOp6ChTqklyxnunROgvGEw1Z82pehfzOtENOSgNU0S+H4xtmqmO
	iFIxnDhkQp73ea5iebsfiDUhM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3P8+fp95q_7YjCw--.11149S2;
	Mon, 26 Oct 2026 09:06:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: x-professor@outlook.com
Cc: linux-scsi@vger.kernel.org,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	axboe@kernel.dk,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2 0/2] scsi: bsg: report data copyback failures
Date: Mon, 26 Oct 2026 09:06:36 +0800
Message-Id: <20261026010636.115901-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1792772194.git.x-professor@outlook.com>
References: <cover.1792772194.git.x-professor@outlook.com>
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
X-CM-TRANSID:_____wD3P8+fp95q_7YjCw--.11149S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUY5r4UUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QBk9Grep6DMdQAA3z

Hi Yingjie,

On Fri, 23 Oct 2026, Yingjie Wang wrote:
> Propagate the unmap result while preserving existing sense-copy error
> precedence. The two fixes are independent and can be applied separately.

For the series:

Reviewed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

