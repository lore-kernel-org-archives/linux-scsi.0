Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C26212564;
	Tue,  6 Oct 2026 01:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791250593; cv=none; b=j2/MMMwYdXOm2w0ZfyE0jraob6HhYZg4iK4L8/2kbcgrFzOEHaD7HAvQ2dgD8CLHOisikTTUjSXJliLHyXJ6dYJSsK/u1GTUp1G8cBW8tcVhi3tHwFtysouEAOlMqqEbVH7AzXVVVLjUECiRxEbp/8LTR/Gc+p5P4cgUDqr22V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791250593; c=relaxed/simple;
	bh=i6E5MeaEdIgUeWd5Ijpb2at9MObWyE/kdCk+O/bii1E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=tmuhoNlOqqpJj/LlMtWRC64WXu7wVG2fv5RrN199AAFIuPdC1YANjXipXBIxWSEVsBlCb8wnlezhkispuoYs8A/ijVVmaBBPp1KZT3Sllh50rEbd7pTvcHHElfVFNfUwaEatltt9M8wWVNGqfBIhmjHFtmSq9ZifaaDyJkZUyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDR/D9FP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDR/D9FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589EF1F000FF;
	Tue,  6 Oct 2026 01:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791250591;
	bh=GIvVcW88RZglILDCoyyKFwSsMO7B/P0C1cMLxL640b4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fDR/D9FPhrsjCzG+QJW6GwqhtUAMM0KTHoRu2nSTkBF3WKpPzmF8MXPJCIwohBHfF
	 dyiiuKlvCsVNCF9yoKT2fdTV5SgbfwZhY+EgYf/yDt/vfDCxn8ONaoBvG9dv3nM3ks
	 18N+jC0gzvEN6MBBowNONdAI3OoqmhUFgwGQsrYQVzA9gpZGjV6vdKQhDLbiLncdPl
	 j+tt+Q5UJMcSIyHky9gmxh7ltDXqLYk7E08qHcz2GSTE/QL6ZbYoYbs3HErNeGXNHN
	 zfJHVyH0LCzo30GXf8DM4RrqXvYBF6tF5XjFgxGEQqLy3wrCDtsMPHq/BWFqX2x4+m
	 DCXcbrsnScevg==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,  Avri Altman
 <avri.altman@sandisk.com>,  Alim Akhtar <alim.akhtar@samsung.com>,  Bart
 Van Assche <bvanassche@acm.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260930135947.2339918-1-stanleyjhu@google.com>
Message-ID: <yq1ld8bk3uj.fsf@mail.kernel.org>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
Date: Mon, 05 Oct 2026 21:36:30 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> At Avri's request, remove him as a reviewer of the UFS host
> controller driver. The listed wdc.com address also bounces.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
