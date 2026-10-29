Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239396;
	b=klA9bhW9a+cb+J5/BgWvrL714RfF81IBaRRCoCBt8Kd7CDzN5E3W3sUUNBLh6fOEJZpp
	 vFhmZM1ZTDxQxGUJVo43fH31m7IZQ53PNB7YKselEIsi8uG9dU+/GCJxDciFJWr6cgPD+
	 TzECNKiQBz56CY05cj9H6BlJ+grwSzLEQ/LuQr8LH1+geQoXjwzOcIp4TeS1gRE4ycVRY
	 YubL4WfwF49PgAhzOcN/QM+UxFcgcpU6Cm6Do5iW4CnablE5KzJdP9OufTffaqRsytFxE
	 8MAe8GjwiDyKlu4+z2f9Kvr07cb+TBIYAWDX7vwZkKXTbJ3SxVjQ6g6mzWQVpuj7ovQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=lj8sPqHLYTb8BhmyM+0DQaiDeGB8ubhxLaV3vfoVVsA=;
	b=WX1v/SrfeijpkXNOd88cBVBmvjqncPpcg5p/m2n6t/DIe6I3KtoMxsC7Hd2dAOi6Dlj8
	 2oj9KF8kvfUh39S2jzqOrSvzXKokDU3dXuLWPMMckAGAIzqi2fCu0KDlipvZi6Hw6fHYL
	 Qi8fCa6LvQN8D8qwEzjbtmEN9UiARM+k/fz4NSi1xoyhsel/czuP5uedjPoEOafyi0IjI
	 s0/9zcLJKzVPQNe5y+l7O4P3nHj8u3vmMN413O3XGvMndVPX7LI07TNDFSAeO/o8z8df8
	 2q9r9GFvhNhLOGN3uST8LUsRixY5E1jQVnSksFoLvp+lXrkQIvIvEbSUsojUDhsMfBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cc/cc1DI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE30606A33B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cc/cc1DI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC5F1F01828;
	Thu, 29 Oct 2026 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239396;
	bh=lj8sPqHLYTb8BhmyM+0DQaiDeGB8ubhxLaV3vfoVVsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc/cc1DI28dPpQ7PkmpEHCVDcHgdEDcCrhzlG6rkzVEVpO1yR5GlNcmS9D8R62fTI
	 njKds3zDTzJL2wlz2WItPrkleoYeE9IrqI3w3gLA1pGXAqL/V0tagNCrsenzBaipKF
	 v87q9pq+jLky49/PTDjn1n9wFvA44KTx0bi7hSTkEYac3cKVmgPE/lwF+WOIpLnvna
	 jSqFTkMqsA+/cqdFjQv0zLl2LV2TX3O8lK/UU53G8by1lCZ0klT/9UusNYUvgUj/yg
	 fBdo2KFmRYlCwot3pkbKGJ0QQbv53PNZFR5hmbzJWYNieODnQ8bp7oR6o/Jzq278XK
	 CUw4wo3p208YA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Nilesh Javali <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	GR-ETH-Storage-Upstream@marvell.com
Subject: Re: [PATCH] MAINTAINERS: Update Marvell Ethernet storage maintainers
Date: Wed, 28 Oct 2026 22:02:52 -0400
Message-ID: <179323465392.491807.15502661346104752268.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023085112.1378540-1-njavali@marvell.com>
References: <20261023085112.1378540-1-njavali@marvell.com>
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

On Fri, 23 Oct 2026 14:21:12 +0530, Nilesh Javali wrote:

> Add Nilesh Javali and Manish Rangankar as co-maintainers
> for bnx2fc and qedf.
> Also update email alias for bnx2fc, bnx2i, qedf and qedi.

Applied to 7.4/scsi-queue, thanks!

[1/1] MAINTAINERS: Update Marvell Ethernet storage maintainers
      https://git.kernel.org/mkp/scsi/c/192cb22c59ec

-- 
Martin K. Petersen
