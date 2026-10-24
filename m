Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812305;
	b=qDn1dnV80UnEgx7gku7VOvzdTvZMjNoUyEhM5tiBvc5NlyNeLA3btG0oymx2F6txeIYm
	 Wi8AJRFpAGxoSt0/nf8TAqN4kQWf+C5UlDPCMegvJuvVISjOkA5GCQyHJvKHkWsnq7Lx/
	 MGoJ/kfAws+03pp5hdNo2ORcEJAAfuo553ZsubbHxcriVWShaMC39FMO1glGSKMlmvUTZ
	 ExFfOzOoGgX47kqgWAe/pv9KNhywXvnM4ISQArlpMoEprCHh5GKHQqz/L5hI99O47xd5O
	 AXfNLWAaEkO/R5K0MX3r6W85T4UnQNtwtL/xcswtTvgMH4bCgjPPbg0eN318CSU6dgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cnSTYXf5qOeDwq3y8p6oFs7NSG8g86tBrXmkTuL33W8=;
	b=i3kRwlihuJ23A5niboFrd45f2Uec/L1mEYqghtbKpHkXg+7q2xkKG7CtuCE/gyyHgcTW
	 s2cDEmNnYCWD6slEth5QIMfPWZQX8EzwwZ8Yg7hfjJVGW6hI+R9Nb6IM5BCNgkEjbhZOF
	 pu8VhbHetKYy2eTUcyJiLublii8AXz+08a4Zl9CeFV0jzgafzFY251xm/QsMNEbCc6wLZ
	 fi+cZNNQV4RzlPd0TBejGFffq/mSO06rU4A7BbfSGwgpYzZTBRm0Q1K8dU5Bxvj83wFKs
	 LW+lgRp86S6z7ml2eIQ9ykxPvHvD+OnRK4N+mLAhMIy752hQ2l6LaTsf47+gVeJwWyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvAXQPZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C60606A32D
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 03:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvAXQPZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467CA1F01828;
	Sat, 24 Oct 2026 03:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812304;
	bh=cnSTYXf5qOeDwq3y8p6oFs7NSG8g86tBrXmkTuL33W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvAXQPZR+7NGMevCXeX+EsVpeEX+aKVE4wnKeIxszcf0/lZa6faTqpOiRNoEGBDJu
	 RNCpaTkIDSG1wGImQaGLePEdNzq8W5RZOHvGdnH7DMK7OwB2WfGv+XfC8xeBHABk3s
	 iSAbzwOMRD4EJ80p4AfsIc9CrUTrckB+B9mQyk5PFEfZFx5NbTpVlq5DFbyu46oahQ
	 Qp5UrHBMHEpn/HYWmBg0A2cDcNtUnh66C5hkmqVpjHsDLFisyrN7oyb4duHZE0aVWi
	 U6AWRGHhK6VoCdt3qjP3GDa2vdcZFjQf/QkdgeSqBX1uOsiRPTi8DQB3Hffxg089Aq
	 6Ir/p8Tr2jJdw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 0/8] [PATCH v6 0/8] scsi_debug: Enable lock context analysis
Date: Fri, 23 Oct 2026 23:24:53 -0400
Message-ID: <179280384854.3823844.2395760571156950075.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791924924.git.bvanassche@acm.org>
References: <cover.1791924924.git.bvanassche@acm.org>
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

On Tue, 13 Oct 2026 15:10:01 -0700, Bart Van Assche wrote:

> This patch series enables compiler-based lock context analysis for the
> scsi_debug driver. Conditional locking is eliminated across command response
> and error injection functions so that static analysis can verify lock
> acquisitions and releases. Internal locking helper functions are annotated
> with __acquires(),__releases(), __acquires_shared() and __releases_shared()
> attributes. An error-path lock leak in resp_write_same() is fixed. Finally,
> lock context analysis is enabled in drivers/scsi/Makefile.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/8] scsi: scsi_debug: Fix a locking bug in resp_write_same()
      https://git.kernel.org/mkp/scsi/c/2f50ca3d46b4
[2/8] scsi: scsi_debug: Split resp_write_same()
      https://git.kernel.org/mkp/scsi/c/2bc11c1d4571
[3/8] scsi: scsi_debug: Split corrupt_lbas()
      https://git.kernel.org/mkp/scsi/c/06bce26589f4
[4/8] scsi: scsi_debug: Split resp_read_dt0()
      https://git.kernel.org/mkp/scsi/c/06c3166f2566
[5/8] scsi: scsi_debug: Split resp_write_dt0()
      https://git.kernel.org/mkp/scsi/c/6544f731e470
[6/8] scsi: scsi_debug: Split resp_atomic_write()
      https://git.kernel.org/mkp/scsi/c/20a26ca89e71
[7/8] scsi: scsi_debug: Improve lock context annotations
      https://git.kernel.org/mkp/scsi/c/0f81d5ea524d
[8/8] scsi: core: Enable lock context analysis for the scsi_debug driver
      https://git.kernel.org/mkp/scsi/c/aea9bae78b40

-- 
Martin K. Petersen
