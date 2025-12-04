Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE261632C8;
	Thu,  4 Dec 2025 01:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764812403; cv=none; b=Ghljky0xuX025vDtCv00JJZhcQ71zdpigN5dhfi5DudabOrSVFouNCsPNAG86ygt7T1/MytbWv+hHt1y3miffZOhJBbOMQEaXs947H176CJXOcHBRkh2D/82ToDovpgsdfwlyfPf+mIy5hBgoC01CamETpaq3fHkToexweczX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764812403; c=relaxed/simple;
	bh=Jpbe51PScgz44S9OIpdFm0SLOuxach8Elyq5Gs3im5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPRIrqhqJGdC9pYyF52xjLKsE1CbNYmCo35LdPuRg923VruZOLn+Ea35axN+W3E1ux8/hVnUPastbPnPd7By29rtTZiSb37LAcWysf8CUeaYyAc9Rm8iUv7lwnrMW86D3qG2ebAbUYWIIljeL+O9Rtih/jgwVYupuH52fv3z3+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRS1IBFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRS1IBFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D06C4CEF5;
	Thu,  4 Dec 2025 01:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764812402;
	bh=Jpbe51PScgz44S9OIpdFm0SLOuxach8Elyq5Gs3im5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IRS1IBFJ2uoAa1wtYZV0rdtWNVh+IAAcfFShrPXc7HRN08ZYkl2UhzZxY3tKwoVhD
	 pGj5DPXlT7VQNPStayk+PFCW0EYhsHfhaA+YX2umX8yl39Afwjype/zthl8az6MyE6
	 LX48TUwz6zLjR6qJ4sA/nRy36nGMaMVJqbkwjgVaSCjzz5vbJW1p5KD+gVndWNZ1Cn
	 6Jccd50jdPU5q5RFaPpo/u0b4zZ5PDDit8U8eu8cHuMpXkMpchdUmpjmCfGLAlO9s6
	 RTfhzLQIzGWyvG0CAl6+Y5xHtKBgaXNoeuqKMCBA73GO8n6wP98ds6sNYiZlXwtQJ8
	 oG3f/X63sX8LA==
Date: Wed, 3 Dec 2025 17:40:00 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: sw.prabhu6@gmail.com
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, bvanassche@acm.org,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: Re: [RFC v2 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
Message-ID: <aTDmcGKDXH5cav9J@bombadil.infradead.org>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
 <20251203230546.1275683-3-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203230546.1275683-3-sw.prabhu6@gmail.com>

On Wed, Dec 03, 2025 at 11:05:47PM +0000, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> Now that block layer can support block size > PAGE_SIZE
> and the issue with WRITE SAME(16) and WRITE SAME(10) are
> fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
> > PAGE_SIZE in scsi_debug.
> 
> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
