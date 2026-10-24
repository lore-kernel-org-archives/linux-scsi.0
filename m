Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812302;
	b=4dSYrddwxjPg5LfwlvmqnAX9qqujnMdpWYQq9GZ/WPtRmzcYwP0BhUFd9bS0wyUQe3In
	 OCrkbMIHhq9TULMrRUyeTCpna787/CUvUqBuQU1lDt+Jd6vBwuTzc29Hxmefb0Yp2Q5b2
	 Myz0bLxpY3EfxNNO5j/FEPjhcnJkZdFfYQuxdTVvI3BMYu1VlhyV2l+Iyr68wjFu+G8TN
	 u7I3XHWhXFeRt9bckh39HG7VXmDm9D5akuYGtPxSq8hYMRiks6J12WmJXFzQUF+3Tzatt
	 zBOaRnz0GmrvpdZgEUaTI/JOQBNutap6CNwyNNRIM5+rkxmOldN458KNrrMbAdc56Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1y0m+RW72zjkvSIvGPKNGDgucS1gVoG5fbX6Ia8hh2M=;
	b=inxGhpAraTGyvUwHqZ7clhy70dnCLisvpTCRsN2W/5EaJnKNQfEbAXJK4vmAW6Fx1HrU
	 +i1sJCKcDI/pdAC6hrGnhsgGtLYkypNKFeYu/kSGZMcBcxAyMjHcGCQxGOFjQGM5uDWxR
	 G8qnLyxG1E5eKD6uy3o1cwuN0gWshwxaDl/meSHnq1v3D6/1M++BXTjqOX6wAYB4FJyfI
	 DLCOQGleRGR7X5rt3WdJwyhTWldos6C30TwaWptE1ipQE6U2Azr5Hdrbj0qL1GEv2qbcU
	 /2nBaT6gMOaN9XwlimhFUTtwsfNhc9Mh3GMU5eSEPSoYVZunEos+OMlbNfGJveKklnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5uRrMIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FBF606A31A;
	Sat, 24 Oct 2026 03:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5uRrMIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226001F01825;
	Sat, 24 Oct 2026 03:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812302;
	bh=1y0m+RW72zjkvSIvGPKNGDgucS1gVoG5fbX6Ia8hh2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5uRrMIUL7UPI4YVEdsW4VSsNLmLCpv3moGh83ysNiQBeBXF5lRJxfiW4k+1Ky01Y
	 IR2jfQXa8xbBUgDYHRdf5gF1PxYt4y5pBSwmmkh/jQH56wlYTq6lNuRZjZZAUTF99y
	 N8OZ17ewBcKDBf2ubfUKYCFSY1FTb6H8f4X2DpbHjHYNd44DjYRAJ/ACroVo8u+mGW
	 NxN1oIFqNXoMaMS8YkSdl1p8fT0tiRyeXl1UEaZKenQ6NaDwEM8fBGj+bPj7nHPQBo
	 7JUebaOm2WkqRb6impi/Ad9rB8bDqtPm4CWaXIA6DafKAxYeEHq379iC4Ei0/6YSYI
	 A5Oe7ykDnbymA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: ufs: ufs-qcom: Don't define variable in the middle of the code
Date: Fri, 23 Oct 2026 23:24:50 -0400
Message-ID: <179280384850.3823844.12942695742237789253.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
References: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 11:59:24 +0200, Andy Shevchenko wrote:

> While the C11 allows us to define variables in the code, we do not
> do this style (see more at [1]). Move the declaration to the top of
> the function.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-qcom: Don't define variable in the middle of the code
      https://git.kernel.org/mkp/scsi/c/fb20fe062b00

-- 
Martin K. Petersen
