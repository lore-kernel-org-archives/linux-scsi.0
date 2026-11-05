Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849765;
	b=4krVVsQEusV0SlGtaYlLCL/hYHeN5qZKYLv7dAAth/fw7k+tsFIBj7yW7pJjO+IYa1/Q
	 CsVy5FEbbNW6GlbTLp8rRbsiu1OnU1A16cCi8TNkGcogXwa9jcSRjmbyLLSd0aOMcq5b1
	 Jsu6ZsB/0P+TPRMRgKHe/S4Ve6vzdlFjpQNi2f1nV2RvCbQXyihkjv9SS456sdg2hlsN3
	 BVhWie+VJyan1Dwnnxs5IgDPrhay8V8JSyOBaQGeFU1rbXmzE/5BDuwfg62ThQdjST6Ci
	 qHjvcEr+z08IssYTOgxft/xCL58tNXTb9b2goXHpJ64CpNvVrdCd7NHX5R53psWI2Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849765;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=QNkyOBP/k5uOV1YIXjtjZGLapjYszHI1U6l5vj9YO4E=;
	b=zc2MYqOQPLo57NyF8EPRl6UGlKjY0Aip7ywzRnLxfgGR4287s86lahR2H0hdqTLp9jYA
	 OYcTbPyJTnzdun1Vf5cGUIlse97rAGia0eLV7WQecZ8ezbjGlPR9jQhozWuI2Y39dfvoC
	 8y4Ru71ml5kqwtbfKX+W6u/ZnN8SM9OzM1DOzHUzlOwqnCoBDr72+VltrUbN7n9tRuB6b
	 ICDeJ54G2/vwrFgpQHL+KLH2XqMm2ZAL+JaLpiXaCI44V6ot1vR8xg/9FM5DnpYdboJDU
	 fxO8cpA0BPRGUFXQ3sblI/ubE7NmIbrQXtEpflFItXB9pmG9albr50bzE64icG8KRGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7oBaR2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C796E606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7oBaR2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100771F000C1;
	Thu,  5 Nov 2026 03:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849764;
	bh=QNkyOBP/k5uOV1YIXjtjZGLapjYszHI1U6l5vj9YO4E=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=N7oBaR2xdffzyIYUBOqvCjJmP70PBgIW7UNt8YE9iI4TE+OxNAnJ44bcm/DEcmuiF
	 xFFi97QmfJ8qS48XxJ6uzI4QZtsEUfuOniqhfObmr9eHny/6dRrKxI/fOZg/u10d1I
	 o40DtALKPObIIRUjBvJslowbEY8aKyna78HQ75XMY9Sgx87fEBWc2oK+GEqDizDFWJ
	 VSFFeKhCy7QciwfN1FpNB2+a73erliAYg59G3qmu6qijtmEfk/8YU/kdx0hc4MeFwz
	 fMnVXtWttx+Bwx8/7+0tJyGPjKAejkSGTFz6NHvGO3k/V2w7doJ6lqwJMV3sZxtwF/
	 ha0uxnmH0un3A==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  Alexey Charkov <alchark@flipper.net>
Subject: Re: [PATCH 0/5] Recover from persistent UNIT ATTENTION conditions
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
Message-ID: <yq1ecd0ymqc.fsf@mail.kernel.org>
References: <cover.1793400000.git.bvanassche@acm.org>
Date: Wed, 04 Nov 2026 22:36:02 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> Some SCSI targets do not clear a power-on or reset UNIT ATTENTION
> condition for all commands. BIWIN BWU2A05* UFS devices, for example,
> keep reporting UNIT ATTENTION for WRITE commands while TEST UNIT
> READY, READ and SYNCHRONIZE CACHE clear the condition.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
