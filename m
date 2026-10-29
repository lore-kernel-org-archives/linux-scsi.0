Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236559;
	b=UfIZlMeTiDvOmIk5L4dRonh79wFgXNrTITksr9XEB3znovUpdB0cCKzBFChPFB1rD7JF
	 M/EX/nubgAHljj/ebYjW29t/XAp36e0mmi2hAIRzBA0HF39d6J/mJS/mE1QdERRnxX101
	 kUyUiWQBKAo/a6C2ec0KBoM4EV0UxIxCh3ntR/ahICTid+C7fZUKyi+8kT8laxj+N3PSt
	 LOasaBOXdeQBzCxPPU3ivhqFPoYEjacakkw8K3vbjRzjMXdP0V20adbfjSFh9yNNrBLSU
	 vXfW0OiZkM/iXO5msw+SG5oikkUGRR8gzZcfUJk5EpuT3ivaRa65ZRqFSNULWmfvFjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236559;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=AUAwPqkN/Y1WfYHC0ZYGHq8NWs4YMldRqACuYYfGQJU=;
	b=D+1ofeBDggsIXdLBsjWl4klRXNtvqAJYLu+dxByH3BmnecyiP7+w0eIniZISfXpUI968
	 EP0oGFJLdX96S5NHDfSJYVFJq8ktdvBGRANQoHjRWHDp2fQA7S+5X4Au9XNN8psunJxWI
	 3q9YqRzT0aZ+32QoZ1+fhDEiK6X+QR45L0FGte0i48VuN9EXDP1mumxPCIbJovm68HrpU
	 pTW9XXJATgY4tw6uXn+IB3zqzpha4OL7qgdBp43MMldHVoTcBqrm5O+86FGfLKvWqttFj
	 FbDQiVd1GfGo2BK/nz2/IJoSN/2FGnNhu65oUbnYepoF69t1X2sqauq+hMJP6jGfj/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFH7Hqpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCB606A31A;
	Thu, 29 Oct 2026 01:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFH7Hqpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15111F01825;
	Thu, 29 Oct 2026 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793236559;
	bh=AUAwPqkN/Y1WfYHC0ZYGHq8NWs4YMldRqACuYYfGQJU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=WFH7Hqpy3lyCPkoqZAEmFfamRf6y0h+3Bl/jCT94SiVnD6Qruc1i2NRep/O/08t9X
	 psVpZgxqqS7dOJ09aOT2z4uKvkotKewszygaj5fMRsrWYpLQd8C5iXPcsMak7Hd6H2
	 a9LTc/PNjpRExxAGHZvKky/8QbN9BbYpHAvTsWneSnfOMxmCOsenufeo3jSPDygnNG
	 rXB0aZNPHjiSSy5doXCOm7Ajcv7xFnd+bS5L5jCN31625ELxTR+eC6GWPHMFbWRyjQ
	 xR6ehU03Il5CSuLHp6g3+bPtNGL3wTTGr2xRWfSEDzaXEudN7szMB9PdR2iFIMN1Tk
	 ecIGedu/8az0A==
To: Imre Kaloz <kaloz@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>,  James.Bottomley@HansenPartnership.com,
  "Martin K . Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Use default settings on the SGI O2
 onboard controllers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026131432.26065-1-kaloz@kernel.org>
Message-ID: <yq1ecd95mt9.fsf@mail.kernel.org>
References: <20261026131432.26065-1-kaloz@kernel.org>
Date: Wed, 28 Oct 2026 21:15:57 -0400
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


Imre,

> The SGI O2 firmware runs its onboard aic7880s without the Adaptec
> BIOS, so scratch RAM holds no settings. The left over BIOS path reads
> uninitialised bytes, and bad parity panics the boot.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
