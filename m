Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7E016EBEC;
	Wed, 13 Nov 2024 05:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731474382; cv=none; b=sqtWGmGsDvxoS8v7KIU7VLI0mbb3TN7IBI2qk0A2XX23rN4eKgSBueQCXFhnZLYe3o+pGrwPtBFQVIN+aMBRqfwJmix6dhjUEULnxVB4vZOTtsog/KUibrFdYj4Usjp0sXnlvSL/UIRj2qLHm2maE2QadDBSW5kGdMpNqjIdYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731474382; c=relaxed/simple;
	bh=Qy5E6zYDWt24nluEUcitYeyeB2elOD1/kL34RwAdV1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3UarcOFx+cmaOHNFSfxZKLBhNB+X9BQhU3BlpyGGmzu6eQJGQho73ppX73uQk0LCk8K7Wu739Ann+Ph5DQxIeEmzw6CDC/hva/DUQXPimRqE0G/5pslKx6rC+Gx8Vp1mGP+yL+OECqRQqU1PtOkHQyJ3cMyX/rnyk/0LfgWtIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE5B668AFE; Wed, 13 Nov 2024 06:06:16 +0100 (CET)
Date: Wed, 13 Nov 2024 06:06:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
Message-ID: <20241113050616.GA20749@lst.de>
References: <20241112170050.1612998-1-hch@lst.de> <20241112170050.1612998-3-hch@lst.de> <b7746182-f2d4-4cb0-8028-93e405b1c4ec@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7746182-f2d4-4cb0-8028-93e405b1c4ec@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 06:22:24PM +0000, John Garry wrote:
> And at many points bio->bi_ioprio is written without using bio_set_prio(), 
> so I doubt the use of that one as well..
>
> I do realize that all this is outside the scope of this series.

Agreed to all of the above.  If anyone is in for an easy cleanup, go
for it!

