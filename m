Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8A31B810
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 11:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761131057; cv=none; b=snMnKHRA+ONjjKjP2aS9Urn9mUsZjSSLiYNoLoLFnS5m3rR7XfELbc+vD8LavlCsYySfe9H9705TV0acVv8R/JUdbrVqTyYcKcmUTs279Mn/8VC0WxhqxCnUTn6PWED3ku8jHmNm8Raq80hOKOwjV7bggfrYVXWd32g0C0W0THg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761131057; c=relaxed/simple;
	bh=9RunPgwiRX98oVcuCPJ74WeEmSxN97FiKSFNfcylcwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBOYlv9s3U8Dx9iJ8gDG0V8kUtBhxhmr/TB7FM5XFOLeMROY1J6/sJzwfUAAbTwfHaoEO2hqUBHt8Jz/7UpIifPl2KUCmt1uLJwu6uD6VMwH65lMgtzn/nsJZEUNBIxJ/5/G0nEPuuzGi3HfSrLcAlAb7WEF6wOJB5pxNRlxm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnz3fVck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnz3fVck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CBEC4CEF5;
	Wed, 22 Oct 2025 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761131056;
	bh=9RunPgwiRX98oVcuCPJ74WeEmSxN97FiKSFNfcylcwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lnz3fVckr0E/REW+CPlx2Xw2Mlriemz6+x6fxQ8S0I0n209KmyLTw5bWvbrjqlkEj
	 1RZNvCMGN09llw9/16o5j6l3ou4xyVIzpXmk0sP+e72zoqsYLn7Alo28K26m/nTCLb
	 eOh7MppdJaFHXsoPsE1+GTSnmwQ6vqdlGj6XZ64ed3fYAitQJXvy3T8MKpSkCOQkbt
	 YLok7LX8FST3p20hqIXq8Acd/LsdocMVWQnKn3tLFZeDyneZdyIjYwifJJtN6moYTL
	 p8au7Ix94mlkXVNx/zme66HN5CD1LMnKaMcSOTJV6MK7bN8Q3b8KX3oG3hsoSCc7hY
	 MQQ+QIA97C/gQ==
Date: Wed, 22 Oct 2025 16:34:05 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] Eight small UFS patches
Message-ID: <ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>

On Tue, Oct 21, 2025 at 10:13:39PM -0400, Martin K. Petersen wrote:
> 
> Bart,
> 
> > This patch series includes two bug fixes for this development cycle
> > and six small patches that are intended for the next merge window. If
> > applying the first two patches only during the current development
> > cycle would be inconvenient, postponing all patches until the next
> > merge window is fine with me.
> >
> > Please consider including these patches in the upstream kernel. 
> 
> Applied to 6.19/scsi-staging, thanks!
> 

Martin, could you please apply the first two patches to scsi-fixes? They are
fixing bugs introduced in v6.18-rc1.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
