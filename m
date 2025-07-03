Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6BE2E6D32
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543265; cv=none; b=WvshIKGBGaEiSWnhSyZ51Za3BSEJV+DaOGNefzRIeYIlmZ/GbPH0ZQP8Pu7dSMYWOVxkDt6rUDuI5lXx9Y28/wcyJNAmlvRnRg0sI9OEXpM2o1kRZue3RqGloIb1mkX8P1WVtFGjSDZHITPCs/Yl+SCWFRJk4u0ocleMTJDflWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543265; c=relaxed/simple;
	bh=S7TpwuWdOA3YFW8mpptk3m4MOXBpExOWzgVS1lhHshM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfRVVqL1dSb/dikNd0hE9i+EYNB2TO68Bk008goKYjPvfLdke6Oe90x20J6TIuKuDL+1Ks6QJjfISCST3OAQCH0nF+Gdfo4veTtMyA94Q9/W7yMJ7RtbTf5JoK+ihTrCpQKZpfm35+wu6NL4SPBv75rbyf0Lz5HIoQABofX/9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD0CB68C4E; Thu,  3 Jul 2025 13:47:40 +0200 (CEST)
Date: Thu, 3 Jul 2025 13:47:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bryan Gurney <bgurney@redhat.com>
Cc: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com,
	dick.kennedy@broadcom.com, njavali@marvell.com,
	linux-scsi@vger.kernel.org, hare@suse.de, jmeneghi@redhat.com
Subject: Re: [PATCH v7 2/6] nvme-fc: marginal path handling
Message-ID: <20250703114740.GF17686@lst.de>
References: <20250624202020.42612-1-bgurney@redhat.com> <20250624202020.42612-3-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624202020.42612-3-bgurney@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 24, 2025 at 04:20:16PM -0400, Bryan Gurney wrote:
>  drivers/nvme/host/core.c      |  1 +
>  drivers/nvme/host/fc.c        |  4 ++++
>  drivers/nvme/host/multipath.c | 17 +++++++++++------
>  drivers/nvme/host/nvme.h      |  6 ++++++

This is not a nvme-fc patch.  Please split out the core patches into a
separate well described patch.
