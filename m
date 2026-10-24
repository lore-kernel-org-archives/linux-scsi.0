Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792810693;
	b=Yd59eBGgPK0B3T8M+9PjPUoOm3vnqkpCoe86BSB0VsukWojG7QJNXJi37oPWKdkFURjo
	 GZsjjAfpzCOrSQJSKcqXVJk/aJtDyPWrgi98lEmTBDtFCTSzGuOinVfBpF1BxYTgnsk8p
	 nfN0lfVqSO65xKxU4EEcwPxFWldvE+GABAy2yHUs7mbKTuziIFRyjSXI6mYtaf1u/g4xV
	 v56C2jSXCuYcJ38kmBeHqcX7dgqNwy6EQaEQuykIVLk0u5+eu8Upmsxh6Ejwj1G64kyxx
	 9p7a0c+uxM8HpABbTDQZRiMccbddvbQLGagAaVqIUFo2go++AQVnB682AEN5D0S0cEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810693;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=cro+irZEQt3ZfMyNbr9CZBPfNTqSS+IOtvDsUXouYO0=;
	b=z4ziu7Z+kF2Ae41v2Re2m/lHaBKywcUAWnTyHbSfL2OL2wSLDR1cgCdwtQePPuvcb7p5
	 BcTPokdRA0Cw5mcMZ92s4B6BoI5eIHfBCHXRbgGk83t1HU89y8je33uY427d3y54ETgEF
	 XPYCB+hrip/skLivFPoeDVtl85FO+WObT/im1t7FfCPf5DIhT5M/+ngpbAh6z7jWutRbr
	 SrSBOJMjJr5b3OP7ulMgmPrvHFuJOC8u2XZ8W04RhRwVsd0Eeua9v9HwK0yatv3MOuv26
	 Q88JM/oxbA+RzRfl+gaYARpzUp1kUsl9r5ix3iIM7uEEzj1uQKRgvfjGYF2miO4Fy0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkHsYrGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2B8606A31A;
	Sat, 24 Oct 2026 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkHsYrGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0B61F01825;
	Sat, 24 Oct 2026 02:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792810692;
	bh=cro+irZEQt3ZfMyNbr9CZBPfNTqSS+IOtvDsUXouYO0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=UkHsYrGat/WNXin99vA8QbdU41M6j6dAUzuYgVs1ofrZcuS4cCdqHKBiwLI5mbkog
	 abhHQiqG9yitk07Rmam4z5ZWWn4HVpZqKME6JSEf9+ovWqFilcU9Ccn3ZPcVxS94Il
	 f9vcoAKzt98z6Ye14y5c9Z/Yen+q8TtoRicXt8lfE0WdqeuXbDvmkgMj2968gECK5J
	 wH8F1c/5Tgb9KrEx1O+blxvBfsUIvQRtUqRLtlYRDBKd9W5m/9Mbt4bFQcL8OZNQbo
	 8aDSYtGboeIt/gYZTccaQ123hX5DYghfRlO4hlMtETzX3xLJ/+/GShBkYgWWG9w7xk
	 Ajwg2ZllvgvAA==
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  Phillip Potter <phil@philpotter.co.uk>,  Jens Axboe
 <axboe@kernel.dk>,  linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: core: update cdrom.h coments
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261020170603.3692218-1-rdunlap@infradead.org>
Message-ID: <yq18q3n955h.fsf@mail.kernel.org>
References: <20261020170603.3692218-1-rdunlap@infradead.org>
Date: Fri, 23 Oct 2026 22:58:11 -0400
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


Randy,

> Update the location and ending value of the cdrom ioctls.

Adjusted start value and applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
