Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07621339375;
	Thu, 10 Sep 2026 01:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005559; cv=none; b=S0JupPK1teTYBHmgyN2oUFYSaj2IupEK8i/+uLX1ruW8ICUyTbsUTrk7SgdJnxmCBU0RkzfvVbqid+CM8kWPBFa5DIEkRobYS1UXwibmbpy6jJKP+FErNLyv1PyhV60PmOL6A9SnCm3NncgQxS/lhoJ7PrQWH9ZSjTZAyYrOL/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005559; c=relaxed/simple;
	bh=yMcLrII1F9t9n6wEoypnjFH0EXjbZPj8dvKx14Q5Mic=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Em/25n4H1ZirXjIOEOA95p3Y1WZUU8PsuKoIUOmho2bYC2vCO93P9kPW8sXsMynRMyf4AKf529Qwoir3W/SINGh7XgMwrfX6kIICZmR0dDYDlgX1pj6IcvL9ByioVAj6kfojKVfFqSoGbM28q9a7gwkvL+lllt7Svi1/6qtxpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccA61knI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccA61knI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C15D1F0089A;
	Thu, 10 Sep 2026 01:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789005557;
	bh=XzoY9CGQ2h20Uwy8PDrDd7+SbG37XW+ZqPfbqM5fceU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ccA61knIPjqgLDYrX68Khye42Pb5D/3JGsZq1PWYdUg9nGtgm3u7w8BduIdeSYeew
	 WLoHhXXhu0YQHN2ywThdfRyrKMLzVvQqD5sU7jWImCPIlbmzdcAFyssUOsukCNPCpM
	 dbLfVZOvmmne1X5uENztjIfVCypNVwbsTTnrEsHez27OTdFs9h/iplcBVTN6lZhv67
	 57vkefW7zGrrNB3HqjjnkSjWD/SSIanuPPCus4HzrQzYBnsb+eCOYLkTXBpO77BcrJ
	 Y2kafVM/c9lrbeEgJSk07O6ok4kgLzHOw2JpXsY8/twSN8qkU0zcBGJf7b021jya3w
	 WzuPIfs9RWSUw==
To: John Garry <john.garry@linux.dev>
Cc: James.Bottomley@HansenPartnership.com,  mkp@kernel.org,
  linux-scsi@vger.kernel.org,  djwong@kernel.org,  hch@lst.de,
  fstests@vger.kernel.org,  bvanassche@acm.org
Subject: Re: [PATCH] scsi: scsi_debug: default to a higher throughput config
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260902092844.1741533-1-john.garry@linux.dev> (John Garry's
	message of "Wed, 2 Sep 2026 10:28:44 +0100")
Message-ID: <yq1ecf1c1ez.fsf@mail.kernel.org>
References: <20260902092844.1741533-1-john.garry@linux.dev>
Date: Wed, 09 Sep 2026 21:59:16 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


John,

> Currently the default config goes not give as high a throughput as
> some would like.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
