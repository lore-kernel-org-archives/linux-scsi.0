Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408927;
	b=2kserRppunfPsYk4aNZtyW2S/LTiqHkD/rYYPk7fkFGQbktv0pIt4cuEsJ+fFR8fC2p+
	 z2u8CD+ekc5KyRWr2dzevxr9clt5dQBIk2lYYY4u7UVW/4FdZSU4jrqIRhGgR+G8pkEVu
	 COtN2Tsz3rxdn+Dmjn0w/H1osqcNITA7OX4KcpTPse5TIWeuq8mY2ytuaLk/o6VskPRJ2
	 q/Ub5TeR7BsQnHGpcahWbI4pAfsn38425pzyD43exf8S1ytbK7HX71ZcWLABFMGjJ4HA8
	 mrPKB3G+i7INU1e8/uvKOc24jgX6RpUz7Qax0GFqF2w/Iya4TWlnD5Bbydo7LOHLgEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408927;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=eViav/XowKysmIuwTl3kWVetVXdq1+mWSeIjuEUQMnk=;
	b=ND4sNYiNmnFmnCywOdY6PFYs6x8KunFwGDIYeEYaIFzCcIdgwWCMQse83U9ygIL1lrro
	 YiO6KeHf/d7vre2uqWbSm7AD4S4noZvyAJxA0sIhtYQh3p580n7avQz+rw89F2cOL4ANE
	 pLYo3HuxqH+UaorI0FdcbV++hXB8hL+EAbwrVSF+kwzGaAEiqRUMtpRJzT9sbSIcVELeH
	 WuyGLRRLA7TRdTi25QRKbvLNasu75YNlO9TzxO9LsUrvIyAYwbVAvRMv1Ni/ZLh2Ov6nO
	 laKzPdM8T9F24QhUrlN1HwuNn8xj3nO+oFprwi3ok3dRh6DpGLd2J23c+DsFKnuWfqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iFnVonJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F26606A31A;
	Sat, 31 Oct 2026 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iFnVonJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC481F000C1;
	Sat, 31 Oct 2026 01:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793408927;
	bh=eViav/XowKysmIuwTl3kWVetVXdq1+mWSeIjuEUQMnk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=iFnVonJcX/fyAh6eO6DBreKWrZMoL5pxxuEyIy4zonLtCmWA7BErQnHhUHgh680hY
	 NnopKmnFF3fNSswQ8u/gIL/18EhhsyZhi0WRw+V2zRe0SLskfGIH97cn2HQ7x4Cm6t
	 mw/p06fNb/0PPolW8EKM/rHtzrLAKKh4Wm3qQdEYPCLjlF4D3zqACVSOuIFGPURaMF
	 cEaRVB8NakHysFUQlYAfJLU3E4fkxYMaX/HgLlUwpI2UhM2gctBtNPyGwr2heWuIaF
	 9SCnib1bKJVD6/6YugOdHg1HUYi0OsAsu8HhMqNqEu1aOfZUCZV1W+nKw8swO2+YZE
	 lkhYpyf3x80MA==
To: Yingjie Wang <x-professor@outlook.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,  "Martin K .
 Petersen" <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Bart Van Assche
 <bvanassche@acm.org>,  Jens Axboe <axboe@kernel.dk>,  Yang Xiuwei
 <yangxiuwei@kylinos.cn>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] scsi: bsg: report data copyback failures
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <cover.1792772194.git.x-professor@outlook.com>
Message-ID: <yq1mrru3cdt.fsf@mail.kernel.org>
References: <cover.1792772194.git.x-professor@outlook.com>
Date: Fri, 30 Oct 2026 21:08:45 -0400
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


Yingjie,

> The synchronous and io_uring SCSI BSG completion paths discard the
> return value from blk_rq_unmap_user(). For data-in commands that use a
> bounce buffer, unmapping copies the completed data back to userspace.
> A failure during that copyback is then lost, so SG_IO can return
> success and io_uring can post a CQE with res == 0 despite the copyback
> failure.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
