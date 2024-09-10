Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0119ABB3;
	Tue, 10 Sep 2024 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982354; cv=none; b=qQ+gSfxo3E6v9gKublniIoF7owXQI6KHh979IDG1HBeHgWAqQPYfUZirEc4HgncdiWXlg0POVGYf9OpIW+L6Jp9l3GsTQy2bZMJ1ulAEUzn6rKCbyWa8pJzylxwYZBPWBSfyrHMWKGYcHcj8UgrlrnkVfpoI2jrazT6CjLiVH9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982354; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dlUavwFU/BC7jlC0PBCl8rjUz2PfqYoJAhqAoe0aTO7VmgOsWjMUmO7+dp03Ywz+IObj76aO5gFWzRfAAET5Ue+vadHLb5CjM5GG6djHHk9Dlw0ojRs//3vHLMm7RwxO72Qp1p11QT7cXG+LaTdSLPUIt/TX5VuAXRZjk1m3V4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47CBB227AAE; Tue, 10 Sep 2024 17:32:30 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:32:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 04/10] nvme-rdma: use request helper to get integrity
 segments
Message-ID: <20240910153229.GD23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

