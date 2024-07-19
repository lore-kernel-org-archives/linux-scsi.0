Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934C71A269
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2024 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721375225; cv=none; b=nDImV5qfy8VkTeqscR2yCh3ZySaGm4F79xgCTxBKek8ZcZLH7RzDyFwsNrJJWU1jj8ifu5Mm77ds8vEFxzC7gXeICd/WeBEHud5ivu35hFxuAsftqAXaJgVRi/BeJOj46OCd+UCXQ8ivvJ1+cVgCLxswDBSA8exCIm3V+Ql2H2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721375225; c=relaxed/simple;
	bh=UONXKHEhxiLDDRqyaKZR6azz2g252MDsaUr7pKqQKxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lb7b9AyZej1ySBPjmUyyp4OE/1DY6xYM36wBJm3tWMI3YR+YCAr5VwNHR+33fTzByepxcX3CZZYQot8u+U4g+TRJb0q50TBtC7rjKqxKmA+yv3g8b8N/xFgSKDGsSID6Po+r/ZJw2alFZrqhLa+TMbxkuRr+SDLbytHWJMZCZhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BCF2E68C4E; Fri, 19 Jul 2024 09:46:58 +0200 (CEST)
Date: Fri, 19 Jul 2024 09:46:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 0/2] Fix IOMMU page fault on report zones
Message-ID: <20240719074658.GA25105@lst.de>
References: <20240719073913.179559-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240719073913.179559-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Pretty sad that people think they can get away with this, but as we'll
have to deal with it:

Reviewed-by: Christoph Hellwig <hch@lst.de>

