Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2971367
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785113812; cv=none; b=CEETMf4Z8BL94dARQRnETjrse30khDeDm5DcGwAMgNZeV+7jMTg4/yGdrLVVMYmOycRyP2mMHkdM4ZZUChdtcTlDfPzHbdurEC3Jo8859SVNCFna2D/3xb6WzOLlzhBo30gKCqPkS/5px3I7Ge77UPUrMVzRFnuNmTV/gZ7Ol5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785113812; c=relaxed/simple;
	bh=Zc0O1NsLoCuS70O9z02gx7R7N5oLu7X5F1tCFBFqNvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E531MQi+gK3v34tI61++wqxjGLGXyTi/0VBq4CTMERuIH+pli6vCeNHB3Qed4IM0yo3E2dos0oaHHWduJIThmKCn+942V2IT9f/oY5kqsG41de2Akgsr6gE0jHdWEIGmWkJgr48/OzEXSP3J/zL8sQLnsZx3suk0CXruVJ4GdpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Suxvrv8e; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Suxvrv8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Zc
	0O1NsLoCuS70O9z02gx7R7N5oLu7X5F1tCFBFqNvA=; b=Suxvrv8ei6hTgZprCZ
	lLydFipQsj5zHHmQLlsHd2iH/760LzmQVWnOuNZlUaDuAVxYvZVJ8L8ntA0divop
	86IFe7ucAYgq4lqmLWFNmyDwEY97ov4g/9Cfd0oGTCaRDgGwZRnaNvbg3rOHxfCE
	kQFSlaq++gNMC49/KyeK8wxv0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3vxUcrGZqcf8sLw--.35491S2;
	Mon, 27 Jul 2026 08:53:48 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: john.g.garry@oracle.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: sd: fix probe error cleanup, special_vec leak and sd_done() sense gate
Date: Mon, 27 Jul 2026 08:53:47 +0800
Message-Id: <20260727005347.1610983-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vxUcrGZqcf8sLw--.35491S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU51v3DUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRxm9mpmrBxD-gAA3M

Hi James, Martin,

On Tue, Jul 07, 2026, Yang Xiuwei wrote:
> This series fixes three resource-handling bugs in drivers/scsi/sd.c:

Gentle ping on this v2 series.

Thanks,
Yang Xiuwei

