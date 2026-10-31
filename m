Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410822;
	b=G5Pd0XL+bLWYhUOcWb6F2ki+A8nuvUXnftbHAADLv2mWf6TNQVRM3bfzJeyWSIOPp/0h
	 ZoZxPTe/mIw7aRnsf0AEk1N+50NKTJqaSa10T6ws6PNmxTGmTJCAg0ZKABw8AwwTCqaWt
	 gig6dEmq0T81/VrULAeOKR9XA3QId+xyChi0InaDs6HNQMO1CIa5HiUfXQE0pEsQps4dN
	 NNtk9SLHiBewyOkG36/zgLnEy7QVGQai16KF9oFPzLGLJKU16v/abldPQjqGOMOW3mL6C
	 N2Q+JJnE3JGIXrYTj/g9IIzv8lBnRxCsTu/OXbqByl9nTyGXIoZXAod12Qs0hjWnPtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NTaxt+WtfZqD3/kOXXQ7NoHyPIARUZ1WVsg881+jv4o=;
	b=fHkuxF1Ezwl90Nd+yUjxQxuFecGGiBAkrpQ20OgnnRwMtgjLttAIgEPXjHj7FOFTJsrJ
	 wikGhyKjedH3SCr9BygfVFb8zmj4i7Syk1i+TAzrI9XxBGe2QeZk4SWfNVyshwXB5vQ59
	 W6SpOKoEPBObbpwSlcSopSskyWGHqasGBhUIpGqozEj6tOfsBfU7/0ViPi6gBHkXpzzMQ
	 hy16ZUo45t1Y63SnCpez2j326c/jJDMksYlqZOPQ/lf9zkGLLZaP36zXm0uX6ZCsOoy3D
	 iBb5I4TWfMqlKpVO3O7+w89o1Y1+Iep8VRIRaYcgT4gRH1ExrbxXMGziS+62mkd2sbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Lb/aHQ6y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D55606A322
	for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lb/aHQ6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438161F000C1;
	Sat, 31 Oct 2026 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410821;
	bh=NTaxt+WtfZqD3/kOXXQ7NoHyPIARUZ1WVsg881+jv4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lb/aHQ6yDNbMaHvAfMCZSSka+YjdLCN9aJnMpfow2OhqXjD5KH/zr/6kZHQU7zjQe
	 xfVMU6j6Fh1dFRjVydI9q1UPa4zVQ+2NRxmHAclUHrYcNdY889Oh8EzRLnpKXJaoco
	 Gxaob/KxkXhFprjZNgk8P+0rNL9HepQzN/8TAdvh3Hdm3o6zpnn+2ZOtTpL2C2Iojb
	 sCyAkTz466KpDAL4qJOFDUDKJYpuVpMBajYf3wSujG0tCzpPhh68HeB+XJnTi9NXgH
	 fTFyTJx7q4bY9XrS/OPahCEHlVM0DUyVib9e0fV/ran13YPsVfDl6lRAs6BhLMvupE
	 3p4FxtxRY9Ybw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
Subject: Re: (subset) [PATCH v4 00/54] scsi: Enable context analysis for most drivers
Date: Fri, 30 Oct 2026 21:40:07 -0400
Message-ID: <179340755636.952351.17539139032571781506.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
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

On Fri, 25 Sep 2026 11:25:38 -0700, Bart Van Assche wrote:

> This patch series enables lock context analysis for all SCSI drivers in the
> drivers/scsi/ directory except scsi_debug. The advantages are as follows:
>  - The compiler (only Clang) verifies whether the lock and unlock calls match
>    what has been declared via __must_hold(), __acquires() or __releases().
>    This is useful for catching locking bugs in error paths.
>  - Support for __guarded_by() is enabled. If a member variable is annotated
>    with __guarded_by(lock), the compiler will issue a warning if that member
>    variable is accessed without holding 'lock'.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[04/54] scsi: BusLogic: Pass the host pointer directly to several functions
        https://git.kernel.org/mkp/scsi/c/b54bd8da110d
[05/54] scsi: BusLogic: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/ba80a742b3e1

-- 
Martin K. Petersen
