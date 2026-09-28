Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F76547046;
	Mon, 28 Sep 2026 05:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572344; cv=none; b=rCnfjjFgmIHt2TlDVKMlc7g+AXgIf4STenACVvLMz9rW6X9OhDyvZV23ejmxrqWRj/kOiRnll5e4n5oL1lD7m3jW6ij/qIC3i5tBlfozMW5bl26Re0YA02DO/lyvpSXOf90hnwbR4oSsll+8xsCSekHYnZrs+bolEyeJIv/BKCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572344; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXPiHu0HvaPyRucXT6K/27dWrqZF0VXB2PFNJ4U4YJuHmbbXckAfWgXDHR6kPylstTQnlOtsh0JykWELXJzvXe2AnMhiP7ebTImhNM2ramcRhf+FlfazhimTpl0gJc/zE0Zn3mYhN41Y9zD3gPKuU8eJ6zDjYAxWC++VdxASjP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9607668B05; Mon, 28 Sep 2026 07:12:09 +0200 (CEST)
Date: Mon, 28 Sep 2026 07:12:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Christoph Hellwig <hch@lst.de>, Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v7 0/4] nvmet: avoid recursive configfs open
Message-ID: <20260928051209.GB18753@lst.de>
References: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

