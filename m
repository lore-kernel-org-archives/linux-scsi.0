Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812304;
	b=XaspDXzMV1BXnRL/ejzNTIZTJIaeTV0CHz4D+KXMleXCZxSuLy8oGlOTze541utWJI4a
	 lj6qK/nQlp95SXC0y8b5v6vFVV1LaKHYHvrwLhfYc050GP4fdZo8TxBXYKf4L/QBB4owC
	 tt//B9l4jD5ojO191AdDPYHsBbozp9y4ieHjBl2XUJcPkSrFEHbU+1XGFDywcDN8D6gkc
	 XgEwMXmBFBuQ5a76BEzesapJG77aiBvX26W3Ku++RHo8ImSqiSV6nfc/jXc/bf2sMTXQS
	 Y3wdoi5XwmBA2G/2d0mWMZu9S3GQYCoStnmyyVb2pYzGNnfmGzW1oxVrFFFlH5dxnWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cfGHN4JKd/AUlO63Wg5o9yEEqpmqnzj9Ur1v5MiFYEI=;
	b=L8qxPKP23SPberX8CMj7k3ff3id8J4DFOw3qWlwrlGOsUj90gESnRZ0My4/PR2S6K155
	 4MDRoY/wh5f8Ljv+BgBriV6PMjqZa82V8LDuRAF2oKbm6pquA3aHSaz9L/WI/DVI5CiW+
	 ocsaRDDAIGldQaNLT5evX49W0V3y+E5RTUHQ1hNgzqd5bkTwrtKtz13BOzmnCVa27C0dM
	 xEJXQrntkNeq5ZC7Kp4p5u2aNIE7UE4vBIqqXD4baO2M8czcEVnc9LTjJ5SRKvqLmStDh
	 631SOIalRR3NuL0DJxTLETFr9XTdGmdZXr44fWNJObAAgjiiaevRNis4nCQLsQV/6DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T8D0EGFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB434606A322;
	Sat, 24 Oct 2026 03:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T8D0EGFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5107C1F031E0;
	Sat, 24 Oct 2026 03:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812303;
	bh=cfGHN4JKd/AUlO63Wg5o9yEEqpmqnzj9Ur1v5MiFYEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8D0EGFxeCtWmCXzZeN6YZMQvGN0sOEJKufwYKQHDmaqw/LYDOQZ445wzVd5pbcqz
	 icMxHii8qaxQEYIwmAVAzi0VIGSJCRjbtZRZCgcazKHOOFi2vE2b98n2VvgnuNa2cT
	 UACTirdISpSoeLSpLfd+8YjxLSwUCECS6Gaw+WPPU3ib418TfnjVWuX5i2lCcvwAI/
	 RurXvGhBTrrSG51scY70dntQ7FT5HShjJ8grkTnOKQHUe6YIZmjZCg9stxZ2UAOlx9
	 ZTIdsZCJ8JQcNgwKmzYUljAM8476T0mDYEqpDIN/5jmIRSN45B7QQsHoh9UHPxwvv8
	 CNHtjGGdtyaOw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bean Huo <beanhuo@iokpp.de>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stanley Jhu <stanleyjhu@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS reviewers
Date: Fri, 23 Oct 2026 23:24:51 -0400
Message-ID: <179280384848.3823844.17189538822093388567.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006082907.3405554-1-beanhuo@iokpp.de>
References: <20261006082907.3405554-1-beanhuo@iokpp.de>
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

On Tue, 06 Oct 2026 10:29:07 +0200, Bean Huo wrote:

> Bean Huo and Stanley Jhu have been contributing to and reviewing
> changes in the UFS subsystem for a number of years, and would like
> to help share the review load going forward.
> 
> Add both as reviewers (R:) for the UFS subsystem.
> 
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS reviewers
      https://git.kernel.org/mkp/scsi/c/e7d41f493e73

-- 
Martin K. Petersen
