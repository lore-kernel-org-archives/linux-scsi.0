Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67504204594;
	Tue,  4 Mar 2025 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741096557; cv=none; b=HHJha8HwXEHXnP1hf1Adv/ZAIWyqq2+OyJaldUGy7/LIrH5zOW+B/mD6E6dxkreb6g4y+aLBCCKZ643xuC2WxFqUnZRHOrOWfpJQlp60cC2S4NlYYV/k2WLuOehea0ONT/QXM9EG5FBLl+DCeMeCmHA2ifiOCDb8mUtatwaOhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741096557; c=relaxed/simple;
	bh=w5Sqp6ajJUx18HBXCU4zI9bE29bBjjr9l3Mi6avbP3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt22Q7gJZ9yKT//k+utF3MM4hrHUTPhGYMXEfFgu0eJ+SYJN8szzLGDSp9QCmTy1KntrYd38evSSegGrTtUILVoFkZbl6RMgaOewy/SpssfYxtzzaWtVBUZFbtRJ4l4v/FyX1hgKIXQRagvfMD27lkpRhY9P9/Hgwkm3ekXNcQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54C6B68D05; Tue,  4 Mar 2025 14:55:47 +0100 (CET)
Date: Tue, 4 Mar 2025 14:55:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, anuj1072538@gmail.com,
	nikh1092@linux.ibm.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev, M Nikhil <nikhilm@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] block: ensure correct integrity capability
 propagation in stacked devices
Message-ID: <20250304135546.GA15571@lst.de>
References: <20250226112035.2571-1-anuj20.g@samsung.com> <CGME20250226112857epcas5p1654e62b5fff4551926622f19269c6ff4@epcas5p1.samsung.com> <20250226112035.2571-2-anuj20.g@samsung.com> <20250303141236.GB16268@lst.de> <20250304084833.GA29801@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304084833.GA29801@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 04, 2025 at 02:18:33PM +0530, Anuj Gupta wrote:
> Christoph,
> Right, based on your comment modified this patch.
> Does this look ok?

Yes, this looks good.

