Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5521E531;
	Wed,  5 Mar 2025 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741182100; cv=none; b=SJB6tjvfsvdGBBlCYSppybUEvB92diCmIjclq5NTxyWs7MVeM4ILDVIFmR8Qn46434rIpOKk+FEKlObD/NhZsulBVwMP8V+Yk8zbeB9vxvUCfv7X26DOUSPqwzdRLqNU2b903Zo95BGcqClw478ZpwIdnjwfbsPS2SmzWKclBdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741182100; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKCSCXihYE8Ef1uBLJ9iye1TiYpFvm6x4b6ZOJPRZIfzd1RO6bJ2FbWhxgNm4EZveX5LOlkZjD7/SeVvp6kuyymujw35Nuwday60kZKZG6Q6OV4+jU3EWeWiF8Ap5vbzcEbAn+p6lszV+dYFxAoVJjyhnEvgnwBhxqsPrFNDBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0283668AFE; Wed,  5 Mar 2025 14:32:18 +0100 (CET)
Date: Wed, 5 Mar 2025 14:32:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 1/2] block: ensure correct integrity capability
 propagation in stacked devices
Message-ID: <20250305133217.GA16755@lst.de>
References: <20250305063033.1813-1-anuj20.g@samsung.com> <CGME20250305063902epcas5p25cc1df91006f1bb35ea782ec430b6d4b@epcas5p2.samsung.com> <20250305063033.1813-2-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305063033.1813-2-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

