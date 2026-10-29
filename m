Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239402;
	b=QOOqi73DypE5DxGjnAyeYFGXrnVDjk9Hre+X4lnoH1nBuAyxTLyG38A/FRAKu3/IGKdi
	 OzdWcPWsT6ZYglkVyNNpB06WdmtIoHtoAY21PJ1ybzS+3KsaJTlhXTSFtnPBABw+jBKt2
	 NX/oJQjmeCkLHrLJ3ySx8nA3aaJUpaC/uam67c1RfeZ2v93x8bd8has84Z5mX00DcS1t+
	 qXTC75sVjbaO1Gcsg/O3im6KHSL82kBaRlFBx2amCB1xDhYZmvwEo9P7VnoVlGJ9Aybpq
	 0hvj05uf2MXxF49Qy8mxMCOhIRrEcfFlzvk1vSl/F2CGkggORw74GnW2V/uI1ZmyLZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DmcTuxJ5ereCWpEGx6u3lTJI7KhpfUv0qWYgD0OSYH4=;
	b=lgXe9d0DUX69raOdKzvrvYXBUj+f+hGCrhX5zTR6hGzjfPGEKoS4HbPBBRW2v1+6FvW7
	 7DMZAMyQLpc4mRAw4zyiq+YVqKA0v8SnjPIQAOn6z684JjdAuF6m89Yr3iWnPD40we5b1
	 vvsx0iwi1+1Bq+atezwmXbLLjpC+JXHi26xoaie2UeiRKnCAsdNFKD2EcpFM2HBwt+/iC
	 VGzLLb7tUgulexP79Rk6QHhR//T3B4q91/Re6BGe3mspDNbY50Kl4Z5tW6OQuxiSO6lQi
	 /h8VcMW0CmwWbi2T2r+I9tZXQXhnWV4v8ORtorjmkni+RTfarKR6EEPjLvsB0rLioLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRgn47HH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35D560A2636
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRgn47HH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F51F01825;
	Thu, 29 Oct 2026 02:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239401;
	bh=DmcTuxJ5ereCWpEGx6u3lTJI7KhpfUv0qWYgD0OSYH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRgn47HHjf0YNL/FXOJ7i9BEqJ+R3qglwl2i8QFnz5A2U+/QCV/H8KVGDguHXRc4C
	 1PyApeToPYkzgGZQqufnUnW/ejhmUXx5mjgsG9nHuPk34zImz8mefMQTtd7rpVaRBh
	 i1r+3b15mXNW20u14qXUp9Iz98e6tq+IC14EqQOKZ9BdQJTAuYV4tb8fKZ/Nh9vAlU
	 TZJRKw/sRTENmHJfPCcoj5j5lUbjQv94uBjpm3LPa2w/wWpaGLqnxOyHmkgaxpxwXI
	 wuM0qgPWxnVW49YpCi2eA8nDcTrB7Xq0I2s/03TI6T5XEw01yICS8aTkZ8jyn3Uu1j
	 WyarnrjJW5quQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v3] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
Date: Wed, 28 Oct 2026 22:02:56 -0400
Message-ID: <179323465381.491807.13158615017305500324.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
References: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
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

On Mon, 19 Oct 2026 08:34:22 +0800, Shawn Lin wrote:

> The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
> has such a member (it was removed when the dedicated hwq for device
> commands was dropped). Reword it to describe the actual requirement:
> the queue is a host controller capability and it serves both non-polled
> SCSI commands and UFS device management commands.
> 
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
      https://git.kernel.org/mkp/scsi/c/a7ac98eb6c39

-- 
Martin K. Petersen
