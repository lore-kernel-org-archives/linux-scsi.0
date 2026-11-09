Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196586;
	b=dsOorC4y4nZOMmjcLOnDP5D4c97a4THTW60OVxi1R3+j9UcJ0PY6lMeAEMUnrXkGYnRe
	 6nxUjgvDedNOFcF+dmZ/Nxn5efBOwAp2HknCLkmwHhKbW1bRkQpQOFmrrVih+bsvcUCJc
	 hTDs/xoRxinQaY3PB3x0ha8R2Ltto7y/PDD0E3mlYbsgLHMErkm8An9kbLlb9oYpomDrP
	 womALmXZgPkRwsuMjPh7nx9wr9R0G4FnJZh33ZYLykJdXLfHnyq+p4V27cfYy9sNJaDoO
	 zOVo2TQn0uANqg0Y/nKBf6WYEarqyN7T2vcaUyGzXNJJt0zaOI0JKGuCQq7CLEFsqVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3s5vokyU8HjFWBf6tWTHxhwGPyIvOYZQizWa8mYZ8lA=;
	b=4CTL9S5SHG7lK8pt98DLJsV1b0rB/jxzKK9J7zW2ah/zBtZ1fgcjeQAnPz2b0OQ6OtDJ
	 +/Vv1w14u10ZPdveysIajrqBBHF7LwtD1WHOSF1P5pzJgbFVMA5wsfdzo12+cBkD+lqIq
	 1CdKCQil4aDsAyTgq7hK2Q0WuQQo5ID6ZKm3+qhRLR4NSSgFZ7L5p6PMwboIY1xzaJdpV
	 Ji2EoiAww7i9WsAGRz9ygypsapgoX+ZDFftPTIZk9K9wha3pTLF1jvFYye4LrCT0XQKm6
	 WZqfTW2D+yW5waJ2KXnLazWku67j+0IZ0+KE489glJHldW9uym42NxG2o/I482qYJvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5IW6JqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15947606A337
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5IW6JqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0481F008A2;
	Mon,  9 Nov 2026 03:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196585;
	bh=3s5vokyU8HjFWBf6tWTHxhwGPyIvOYZQizWa8mYZ8lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5IW6JqCgvHLlX2bAEucR5JiEzYCT1lhlKv0ci5pTMmgfUD601KuKQ3+HtVe3XIxa
	 XoNOzpjMa0EtFM/zK9c6UE0+P4cIIK+jiu6+f1X4xc/XApZC7KHbycnXEacFJLsD/X
	 bWlzI3BDTxhWhhb3r+BoK57J/RSDb/h0ZPkvlJ8RWqlrJuEwM7JgDefw0NtjshPTbm
	 uiA0hO/1EjerHza3tl/mAi+aAI9uuffi0xas1CC9P6wptlxH+Z4H56n9fjn7bkW3rS
	 ZmAxCq+r/3DyXe82X21pdQONcPN3dkhyltHl6HO05afBG4bYAMC/263ZbNoacOMOQf
	 V93lqN0BVUkqw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: vishal.bhakta@broadcom.com,
	linux-scsi@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	Matt Wang <matt.wang@broadcom.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: vmw_pvscsi: add support for ARM64 architecture
Date: Sun,  8 Nov 2026 22:56:14 -0500
Message-ID: <179419636235.1941631.865314246156290613.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019062959.426900-1-matt.wang@broadcom.com>
References: <20261019062959.426900-1-matt.wang@broadcom.com>
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

On Mon, 19 Oct 2026 14:29:58 +0800, Matt Wang wrote:

> This change adds PVSCSI support for the ARM64 architecture, restricted
> to little endian and 4K memory page size. Barrier usage is updated from
> compiler barriers, which were sufficient on x86, to the appropriate dma
> barriers.

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: vmw_pvscsi: add support for ARM64 architecture
      https://git.kernel.org/mkp/scsi/c/c78b78166c55

-- 
Martin K. Petersen
