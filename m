Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977426;
	b=qd8ZYcWi5capA80fWsZsVkt2/lPWwDnpPjR8jmGCslQlFTrwxruDfzYhTfzXOayxfJ3l
	 EstPumlgp/p5N2Q1JJ3LwtZ+Ae6inWvV9Edo8GX3n+IojBLI4ijZeBglkbbLaLAilaFqe
	 hqBSimXmK6VgC0oP5VKFK+oihQwdNy26ijEPjTJMLuq5QTXJECipXpoIrHlJq3p3yF6dW
	 L6n3Bds2cXaCPS1eY1WYNp8rbB0fAuoMuomFastt3p8UKtXwwIJn/VanJCFMJBvx/haDz
	 ekgWxSbJeYD68dugLu7l8uz7ZNHmobifMsOXBbeZyjYkQzOA6GnfBCIs9vguSSynfAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=PI1DJODybpp7+Rir8TXN2Ru5NnclPzCIXFfpsOUsRhw=;
	b=JeumuLHJYTtvQ1eVF0sZ7Eej5A/KF2u7Kq51q5jyszaZn5tIkIMZbDPyO3Xun1AlDisC
	 G9RxdjQSsozJPbBcynFoKcGGDChSWh030hJo1Z5T/nhJPiS7R8iLK1XF0LqpjtbTTi6Ag
	 bgrIWgWbaA/E4P4YZSWKcPe+KfpCSTHGiTWjmvFHA9Koi7o2bfkGzOeL5fk/BnFw8telS
	 MI9U9bxldMpTFQFerzlfZl1wkWhkIIV+KIkRc6hqQ1WUImSPu/TaZX8E0iOI35Q0uzXsB
	 LfO5d27JVLiAjxIdNnBwzAPYH9cLGtXVmGZ78s8/aKB/txKUNrKC8j45Jw85suhygUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehjwmY+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AA1606A334;
	Wed, 18 Nov 2026 04:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehjwmY+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2774A1F000CF;
	Wed, 18 Nov 2026 04:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977425;
	bh=PI1DJODybpp7+Rir8TXN2Ru5NnclPzCIXFfpsOUsRhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehjwmY+9HOv43qkEH0TycH4f8Wrf0rho9Iqqg9/HmeF7bKSLCYf0J33WxXtPBeM/W
	 njnaDMkUsdh+4vu9Dz0ov96WwHLkR9g6j3ieJK5JVci6EwgzC26Gu/t87Sje/QYgKT
	 Z7WvBJIqtlvmSc1Wp3er4is6pL6YwEZe3t9k0/qai3Jmvxxv+3z8ZcT4ali9pXIvqC
	 3DTW8mjpuwVBsW2Pwmjyqn4yiNvFbzgkVTPfDvqb4rzUX/cK+f3u4ZDj+EfY0PSmsk
	 WZIjImd6pual1oxPZSWRZX06YIJ5zbdOA/NB+9xpdWRwNG7aBsKp7STbcITdE3wZjK
	 y74bC6X+k9Ptg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	Torra Sowmya <sowmyatorra@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	johannes.thumshirn@wdc.com,
	axboe@kernel.dk,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	outreachy@lists.linux.dev,
	rostedt@goodmis.org,
	julianbraha@gmail.com,
	julia.lawall@inria.fr
Subject: Re: [PATCH] scsi: sd: Remove unused zone append tracepoints
Date: Tue, 17 Nov 2026 23:50:15 -0500
Message-ID: <179485091812.1479907.4105303097748996547.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261108064626.5539-1-sowmyatorra@gmail.com>
References: <20261108064626.5539-1-sowmyatorra@gmail.com>
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

On Sun, 08 Nov 2026 12:16:26 +0530, Torra Sowmya wrote:

> Commit 1846f308d66f ("scsi: sd: Use the block layer zone append
> emulation") removed the calls to scsi_prepare_zone_append and
> scsi_zone_wp_update, but left their definitions in sd_trace.h.
> Consequently, sd_zbc.c still generates code and data for events
> that have no remaining callers.
> 
> Remove sd_trace.h, which contains only these two events, and
> remove its include and CREATE_TRACE_POINTS definition from
> sd_zbc.c.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: sd: Remove unused zone append tracepoints
      https://git.kernel.org/mkp/scsi/c/ae8ecbc1e286

-- 
Martin K. Petersen
