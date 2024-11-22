Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466D62AE96;
	Fri, 22 Nov 2024 12:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732277098; cv=none; b=t0UoSB5wfdWDUlvrY1K610N+VyGnsR+oNes/YwP/Sqocixh9HyBIcl7vuTkADI46oS1OftZ33hTARRB9v9O12GMVHqCvkLJjn7mgi5RSU1CDxJUzR8qJsI0IeYDfcfOdUUWpVwZeTScsRm/kC/S/4w6kNXiaUuWRHnlszJZH+J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732277098; c=relaxed/simple;
	bh=+Dq5meN5ukeG5E5CVzMKP2NGpgL13KsyjObR6Jo/W94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODWlJpqspudc6/HhozSX12xgm76Th4uim2HZBoyQnYiTJtdEeBGu+GGyPoZL8wUcIsxeFGVVabKamV53XvoB5cVys0N+Hx3o75WSpuKbk/iZDQAa4qNptYo9gc+5LHlV+yK6s6qTxvBm7MBhXEwXDlYzRplXxxSb5Tu7E3xiIB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CD90E68C4E; Fri, 22 Nov 2024 13:04:44 +0100 (CET)
Date: Fri, 22 Nov 2024 13:04:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: hch@lst.de, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
Message-ID: <20241122120444.GA25679@lst.de>
References: <20241112170050.1612998-3-hch@lst.de> <20241122050419.21973-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122050419.21973-1-semen.protsenko@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 11:04:19PM -0600, Sam Protsenko wrote:
> Hi Christoph,
> 
> This patch causes a regression on E850-96 board. Specifically, there are
> two noticeable time lags when booting Debian rootfs:

What storage driver does this board use?  Anything else interesting
about the setup?

