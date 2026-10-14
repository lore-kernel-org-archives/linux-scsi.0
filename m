Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4062A3955F1;
	Wed, 14 Oct 2026 02:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945053; cv=none; b=QCOdahHQpfl8CocYZatxeuFEiG0KXCmO87x7KZuAnBOPKAFhnsP3BmDSUWdAmVMGFehWbpRK31mRTiCwieSD8fp5K6y1Fmkm5RzD5ry7D8BIso+CSfI8s3fsfmcb5u1G8VvRLZAxjLyg+358NcjwsnH/YQ/jbFgQFgH0iblCAW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945053; c=relaxed/simple;
	bh=xOxw42noQ0R4FpW2J5uXPFMLUIvVJZw9sINx1MabYmc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=lTkZOl7ZQgYKHTT8wi6miZvMfzVgvQ+d6sbKQ8Ur3XQi/kKpltjPJx+GHBb1IaLG0WoF67OtUtT59/Z7zQAWKruRcA3PPcgk1v2lANGgJpg4sUsWRsGJr3O+4bvuyRn9jyPBu9AmXKnECHbUFE8RunJyC2tkJtTTOfp8GBTWLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chVYbpai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chVYbpai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA251F000FF;
	Wed, 14 Oct 2026 02:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791945051;
	bh=P4biUse1qOq81uNl/lpbGt4kYDOo6Jk1WfbWc535gaQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=chVYbpaiF8yeQ95xSVrbF3t7XXz0EyZUtx4qx/8SoXDykd9ojPAsv95HSaUsaPkHZ
	 tju8i0LMcf/BGsB/IqJxhhxt3B2JpcRo9htVlXICaxIASLc9BT4OSIQw/GskkI01/j
	 sBtDaukO1UX5QZ3Q+kSc4G8gU2jU5gKT3+sdQoMmyAEDheQB9UVJr1dmRXA/lzzGzQ
	 yStYIGEM4RtKYANywfnfTfAwcom8xx31nfJ9PfwDn0QjdzViOXSvH0C3A9uBWxVQaJ
	 hLXduOEHn5UzThvM+pEmY2svtr7l6/35ac7MOatAfuYqJFLpMBOgbS8bGRWloyTPZp
	 QWRuPaHbBqfHQ==
To: Bean Huo <beanhuo@iokpp.de>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Stanley Jhu <stanleyjhu@google.com>,  Alim
 Akhtar <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>,
  Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS
 reviewers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261006082907.3405554-1-beanhuo@iokpp.de>
Message-ID: <yq15wz5ggj2.fsf@mail.kernel.org>
References: <20261006082907.3405554-1-beanhuo@iokpp.de>
Date: Tue, 13 Oct 2026 22:30:50 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bean,

> Bean Huo and Stanley Jhu have been contributing to and reviewing
> changes in the UFS subsystem for a number of years, and would like to
> help share the review load going forward.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
