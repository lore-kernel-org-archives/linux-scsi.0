Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DE83A0B09
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943757; cv=none; b=cOe31+lqjMNLSnYxt5yvD7VOj02GW9g9wDujg8ldWqQ+LHoiGBbJGsyZYc/yEoszZyhHZoWvFbWkodmA1rnPRn29i+mtzJM3manRtZUXJCiz3tRFeLl4/3LpnKAX6F9dvz+Hgx5NwiYwIqHElfEwFww12wVMWOjvX9ygF1npr1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943757; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUYBLrDcme+UpdZYuYQtkZVXqqx3wXqhC+qkia8KHceItWcutGS+aiQ2bbf6ONGGlOYfcXqXOjRm3VWkPmZFyE1ojWC5kVmWjxVMGGalo7ctSb7CP8vQFJzTqbVzl4e1p4kNHyuImEhwgAJrT+i0njR03hG/15ZHtiizIXBTeUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D61B768C7B; Tue, 24 Feb 2026 15:35:53 +0100 (CET)
Date: Tue, 24 Feb 2026 15:35:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: kbusch@kernel.org, hch@lst.de, hare@suse.de, chaitanyak@nvidia.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com, mlombard@arkamax.eu,
	jmeneghi@redhat.com, emilne@redhat.com, bgurney@redhat.com
Subject: Re: [PATCH V2 1/3] lib: Introduce completion chain helper
Message-ID: <20260224143553.GA12308@lst.de>
References: <20260224122505.52401-1-mlombard@redhat.com> <20260224122505.52401-2-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224122505.52401-2-mlombard@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

