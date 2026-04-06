Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EEA3112AB;
	Mon,  6 Apr 2026 06:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775457420; cv=none; b=HpTXepdNZm/JNwXYYSD327kc9p3K9Zwv+Kw2Sn7cUfnKBBRag3Gd7iqNMvxzYuKVz/AhaZaCNPQkwg0OthCHMm7fwaqTTrFbjydr40lbLJC+NN+og7qQvDMo33EB1S+2qrymsJYoaIubuDDS26oJCnGKHlpQbqThCq+rApqMH2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775457420; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wq2aswLrASpnubpP+NI6fd0I6zzMhtQVexJOLNCHMbS8dyXiTs5LM5X/R29x1g/5QkD24VSjNQaw02hwT8QNDsaga4aJxf0YHJnhxfHX0wpcOzZ6fgngHxfcodb2JtI18m6pN7DwhDNchFR809b79pnS8HJDmrV+s9OQpbxWTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gO3lyvoS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gO3lyvoS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gO3lyvoS9UJGEWVMGq3xDYFSGI
	kG6seJbsOUkkAIMlxvMd97k3HReMtqO86NpQUqmfVg5ps7Y3uzRZoTpyZFIANbXLZDteCpafUJ1cg
	Sjq9SArofOecitu7UvoX4PVF53OoPYOQWpjqHfwvqM1VbYB4VpuoRM4lt82coHzV+0NnTQzXNd3O5
	0aFEck1FT8O3GB+aZO1X75wY4NsOoeWHhdMSQq5Oe3ccZTDmGGZCsEAIdUEY0HMzaFSTT9grM1j5z
	fXBi8JIm35wrqMo5s12nNqCtog+0RMGIRVYZScTrS0JX00jFVfXj19otWrhFGxTzsu9yXQ9gDShUL
	yDhVoJ7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9dZy-00000004r1z-1ksI;
	Mon, 06 Apr 2026 06:36:58 +0000
Date: Sun, 5 Apr 2026 23:36:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 5/6] t10-pi: use bio_integrity_intervals() helper
Message-ID: <adNUih3CWyA4Nj5f@infradead.org>
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-6-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403194109.2255933-6-csander@purestorage.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

