Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143938;
	b=UOjzfgunonSgLpeiQoNca3hiYQnhwzl0kzNl6FQkXLOOv+aWdBs1v5M6eN6MT8zFJOyi
	 4/ryNNVmFfjo1JuvmCnm2P8UdY1OxR8MYL6a5zl8uRiNZW0TJZS3lck5omXm4OH6N3XuI
	 2RxTOEcYNpkvgWIu6CX5tc3Hrqv12GiqJ4daIcjNXUUKS36aQqFiafkFqMdqYRLmfpcrm
	 lm5uvR9wsJnoE+ViM5TGJ1grLJ4yi89V5nzLSzQnyotmqSNVR6QYdwbLKEaRnZ25KfOxJ
	 5qtW0grr9AS4TGHdZ5+N8QyoD3KYi7lv5j9UN/kdQdjUvDkM1TvTMhTM8uR5rgp+oKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143938;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=c3kFlEfqICMl98Y4ENwHSDXDjmBA7a5dn2l5FKiRry0=;
	b=PZK11wsL7KxVKm10BzDDJ34Xc+eXRcmpCN8LHdlyrS1l/eVuhrwNkhvKYcGFSTTdvV5q
	 /38MlNyq90SupMv45eLp3A9rs7ob4oS1H0PVhBdkpk2nC5tZVKrwKyg31FBOjD4Hwo0/g
	 lu7uXSYq7rRt7wk7jne7dj83vjG5x4Fcp6jgEBsqbJhrp5FZ3QWrGLSjZOVLBaaR0CNU2
	 TV3aZxUx62R6MhlzaR4rzwR1VoUZs/5q5VSqN1G3PFvNdaA9EyNbx4ieLbzmJ1T9AU5tm
	 llRfIGlWkMwrzsHn6uAT1gGZEKW0xV/DoA5ccEYvll5Cmjnx+AvbrOo3Xq7tPsMnB/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fco7HaVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52494606A320;
	Fri, 20 Nov 2026 03:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fco7HaVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14A71F000C4;
	Fri, 20 Nov 2026 03:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795143938;
	bh=c3kFlEfqICMl98Y4ENwHSDXDjmBA7a5dn2l5FKiRry0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fco7HaVmtYU8CrRbWtLLmsnUBlbqKsJ4xADEKuxT/I76TbUxvMOO78SMlaW9g6DsA
	 xYAl7wMsL7BgrR0maWab+PJ/RyLNpB76GHFXCJlSlzivmjWvEiEInSuc7DHaX13+9r
	 0z2M2vos5DXxbl8O9HB5jMxqocjB/khHuMLBXAlQIgSfWuvbX4qifA1ozqu61Q1h+9
	 yPKWwh7/HCWpeGcHIdiH7DJ73/9QxC8ntDOgjBaDcyIyOJCEKXT+6eJLQLrsjVBHax
	 16AOxLF2oYJFWqkPtyDGGfK78PwjA34M5LDinkplI/Jp3kGaUYXu4+3g+F/mOtsEo5
	 +L7go9I1F4lWQ==
To: Minda Chen <minda.chen@starfivetech.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,  Sai Krishna Potthuri
 <sai.krishna.potthuri@amd.com>,  Ajay Neeli <ajay.neeli@amd.com>,  "James
 E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K .
 Petersen" <martin.petersen@oracle.com>,  Pedro Sousa
 <pedrom.sousa@synopsys.com>,  Arnd Bergmann <arnd@arndb.de>,
  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
  Bart Van Assche <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>,
  Stanley Jhu <stanleyjhu@google.com>,  Conor Dooley <conor@kernel.org>,
  Rob Herring <robh+dt@kernel.org>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Add StarFive JHB100 soc UFS platform driver
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261112075616.118436-1-minda.chen@starfivetech.com>
Message-ID: <yq1qzggp5ho.fsf@mail.kernel.org>
References: <20261112075616.118436-1-minda.chen@starfivetech.com>
Date: Thu, 19 Nov 2026 22:05:36 -0500
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


Minda,

> JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
> Managent Controller). Similar with Aspeed 27x0.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
