Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398314A6CFE
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378767; cv=none; b=t2Rfu99gTkpRQwS6P83cOl11fpC6fOdqFAM6VY+MMpogYyvbkHVio4rMo/ZVYhWKQGhoXf71Jc/SqVNMlwGZHN6LGUrInuInHV9jnx/b91+qjOKV29sp/cdNW9zfw11rVSF+YcDZxVCXGObq+BPxQGqjFoq6HA22wwuf0shZF/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378767; c=relaxed/simple;
	bh=sXk8yjYowbEU/5nlCrNTEeTppk6tnJyFQv0QMOfJ3OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dh7iPmw8uNYOM8Gji2r2R7lGmK7fO+zQ1OcplUWZ0oMS78/+DjzQBUgNT6jCr2f22hXewSrwbK7Ia/jR+8jh0OOJiwWl3XWiXoVSoytgnDU9mStSmpOtP0oceyKI46mX9ZO4BJIqvkyAFtXe0yVcLfUxyVx+lVB/OR8GG2gQwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9024A68C4E; Wed,  7 Oct 2026 15:12:34 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:12:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 6/8] scsi: scsi_debug: Split resp_atomic_write()
Message-ID: <20261007131234.GD30647@lst.de>
References: <cover.1791349129.git.bvanassche@acm.org> <a1827bbfa6caefebd3c50ed171a869536f1bdb44.1791349129.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1827bbfa6caefebd3c50ed171a869536f1bdb44.1791349129.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 06, 2026 at 10:07:28PM -0700, Bart Van Assche wrote:
> Prepare for enabling lock context analysis by eliminating conditional
> locking.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

