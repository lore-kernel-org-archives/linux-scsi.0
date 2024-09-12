Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7076188CDA;
	Thu, 12 Sep 2024 07:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127262; cv=none; b=On7HxHCa1nsidasp8/kiwpLTaRncCOU8k7vNqwXxkzuHImJIj7/Ez9AIy9ciY2C6s3V48LFBmWpD2kcGhPlRitDoFxvd658TgdF8uoHwxn3XDDU9tmI5s8aoVSVzZ/ZUhMxNlOoqaV48R8oTekLwPCVqSlMy5+IAayegFLZgpWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127262; c=relaxed/simple;
	bh=V2NqqVRi5yYsVdTYecqjECA9Vmpewt4M9cYmDSx3IyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pi3U3gKT54g4+k0F6MptKiPeqayViTipt7hMEDxJCMkRBqJMuJRlgdx9GC0f/JKgeVkD6eX9bBlVBRBJ38h+5Inni9Woon+iEQvtYzbzksDh4W0Y5hIZ8pDfvN3SCnFIMy04D5cX9N9HzMzxDYgIjVZigME2QH7Z1nxwbUprFo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B6EC168AFE; Thu, 12 Sep 2024 09:47:31 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:47:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
Message-ID: <20240912074731.GB8409@lst.de>
References: <20240911201240.3982856-1-kbusch@meta.com> <20240911201240.3982856-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-11-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good modulo the BUG thing:

Reviewed-by: Christoph Hellwig <hch@lst.de>
