Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794189405;
	b=5tLP48dZwMYF730fKORZTn4rC6Jd95rVCvlnif7vUP/lTAFXS78Mcjx/tSu3+FOrGAD8
	 eJzFBclJ9Kg+xjSwLadBK2Q1tqxF3lDIodtW0/2uZzn6RHAuB38Rq0Y95jiikkMUJX0TA
	 qYKPtStQXrjsISF/BzGcu7gplqgkJ21w+ppm4o2hoZ4Tzd5uRda5u49a7dvnLQzOwFYtL
	 fIgp6RmH1DOEoPssvoMY88L1ZF53ZoCRZmgmapSg6XUi0M6j13b5qnReu9e1C7UzSU9fd
	 H5BX4sKdi0MPan0RhcDqZq0IvBVVLm0V1d6m9vUW5pm5qGzAdY8S77qJSpWkgELYsFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794189405;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=oI88OX4vDmmafFVqCML7GZSmRUf5G0yckOIMQjJnQSQ=;
	b=B3++iNJPd/lzHqw8A6eTIzm3NS1V49ooHeIM/1dqcI1j5Q9vpZz1/uYggjIFdw5vyPAu
	 PDlBUzcCkstMDM5LvvqPEI25qN1NUi52X8hPFRBDFkkHUNeTdNgzClEuRpa5izqVfzqb4
	 6vX2sSTE26BuydV+DG03Kl31L9MS9clKFZGvDpEdiwvfnQK8F/2VkHCZAoYF5PRDIDwH0
	 0itRBsu9qXbNptsP2Pm+SwaKeyaxtEsyHWfza0RT5G3/Og2OK3hST2ApLI+RPthXWDIEg
	 cP/ZGXUeJCbtejSYPBJC4fVBKFEqfYoApjQbKvxATYQy5FlvBbu6iNqtmXbCgXmLp8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l/noCWx6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE428606A325;
	Mon,  9 Nov 2026 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l/noCWx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295161F0089F;
	Mon,  9 Nov 2026 01:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794189404;
	bh=oI88OX4vDmmafFVqCML7GZSmRUf5G0yckOIMQjJnQSQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=l/noCWx6I+dgBGuMSZ6Z9LG6ApOMQEmd+7cnliGmFsesZziVTo3BsrDLtme63xiY0
	 JE7cZ8WuhIG4VP3m2JKQeS0Rqk70vCq3IRSPwsuIoAHEmbl90wgus9NQ2guWTZp97S
	 O6oINiObYewrtgwr1sYdXGHjNaZeSP/ZwW41rLF/6OHw2DmyyxOzfxYmPZ0Fq/NltW
	 80WH67d1vqP1t4sFINoUMa0G80G4rOZZuAb5IE8FWUJg+dM+9wsvysFLnD3YRj9eKS
	 fRVffCJbhUNJdTY2YyugRXplS3X0qylcKoyzrd+/mWutIXiz3oTlYRh1CDHS1KD5W5
	 hKvgQOMiXYCyA==
To: Torra Sowmya <sowmyatorra@gmail.com>
Cc: James.Bottomley@HansenPartnership.com,  mkp@kernel.org,
  johannes.thumshirn@wdc.com,  axboe@kernel.dk,  dlemoal@kernel.org,
  bvanassche@acm.org,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  outreachy@lists.linux.dev,
  rostedt@goodmis.org,  julianbraha@gmail.com,  julia.lawall@inria.fr
Subject: Re: [PATCH] scsi: sd: Remove unused zone append tracepoints
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261108064626.5539-1-sowmyatorra@gmail.com>
Message-ID: <yq18q32ydm2.fsf@mail.kernel.org>
References: <20261025151702.13434-1-sowmyatorra@gmail.com>
	<20261108064626.5539-1-sowmyatorra@gmail.com>
Date: Sun, 08 Nov 2026 20:56:42 -0500
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


Torra,

> Remove sd_trace.h, which contains only these two events, and remove
> its include and CREATE_TRACE_POINTS definition from sd_zbc.c.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
