Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AAE32B113;
	Mon, 28 Sep 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610639; cv=none; b=Ovte9tPxUzSZi0RV7CS2B+tltWpkT/5VI1NinhY00u0+5xsW6xBWVkXAXttgkRPSEzBqEdH7iHTsLuQaOVCpktauDwDnRxGqP04HnZZhDOUVY7xXf+abFLKkPzzMYsSQOuA9QRKZBHTSFkmgW/7X1og6eojUtknD45uLLkhu7PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610639; c=relaxed/simple;
	bh=vT/LIk0b+YMJzIqUIMAUC6xNlwwKuEFAYoFiLiApMGw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=VcnMCiaMDsQT9Tri+tKBLWiFWeVUXEUrgT/V72vDogvzIFJu++eGbYyHYCFOyJLT3CSdBe1+ajGMgWEq2SxydR73Ob2H8vbz6s3OKVKCm8PeRriFuqJVMNgya9qRIznDJVFhqGzxe32NzVoOWekrpO1DbzO/PGGc5msUwAx3/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=AO5vxrXS; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="AO5vxrXS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=EcatbeX8pT4mVPK6BtLsmrFUIWcm+3T6irC1kikWPR4=; b=AO5vxrXSpbuxrRe1o/Rwqoj9+l
	ZpvZj/1lkh9zWIRW26x0izwnq9XN8z/XAVRabdlg8WdIT97E3U6wo0FnI0WvtxkyU0WMDHdgMurBx
	dv+Bg39Xo+FlH+NFh9HVpqB1k6iVC0wjn9a0T4Eq72xh0tfJfiUFSaZUYsA9tiFjAXYpV9jnQSwU3
	NMBNGdodHI3Ukh16lorAVFbQMJfVDioDgaL40BZ4wO/wwiesBez0UxAnPNSlVjrCd6Gc+QIZzOF6I
	BGkWg1grtc5tbZIn6jrmXNQtR/jMq4OYVbP7gW0TscEWs+l5blvP8DxMkE9IfcPs1KtV9VAA59vZP
	x/eYP9kQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1xBDcS-00000002TTV-0wIr;
	Mon, 28 Sep 2026 09:50:21 -0600
Message-ID: <62fbc3dc-421e-40f2-8f9e-d28a706cf64d@deltatee.com>
Date: Mon, 28 Sep 2026 09:50:05 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, Christoph Hellwig <hch@lst.de>
Cc: Breno Leitao <leitao@debian.org>, Andreas Hindborg
 <a.hindborg@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>, Lee Duncan <lduncan@suse.com>,
 Hannes Reinecke <hare@suse.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
 <20260926092148.128937-4-runyu.xiao@seu.edu.cn>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260926092148.128937-4-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: runyu.xiao@seu.edu.cn, hch@lst.de, leitao@debian.org, a.hindborg@kernel.org, sagi@grimberg.me, kch@nvidia.com, kbusch@kernel.org, mkp@kernel.org, lduncan@suse.com, hare@suse.com, nab@linux-iscsi.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, jianhao.xu@seu.edu.cn
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 3/4] nvmet: avoid recursive configfs open for passthru
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-26 03:21, Runyu Xiao wrote:
> nvmet_passthru_enable_store() runs as a configfs store callback while
> configfs holds the item frag_sem. Passthru enable used filp_open() on the
> configured controller path, so a path into configfs could re-enter
> __configfs_open_file() and try to acquire the same semaphore again.
> 
> Use configfs_file_open() so the path is resolved before opening,
> configfs-backed paths are rejected, and the resolved path is opened with
> file_open_root() while retaining the normal open-time permission and
> security checks.
> 
> Fixes: cae5b01a2afc ("nvmet: introduce the passthru configfs interface")
> Cc: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Assisted-by: LLM Codex
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

The problem and solution make sense to me, thanks.

Reviewed-by: Logan Gunthorpe <logang@deltataee.com>
