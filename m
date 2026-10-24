Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792809254;
	b=dKpr76CcP3IZR0HF6Z/3H3QbQ6oiFTQvaUe8eCxukcLeUZAN8xSfUNugm+bCVgt4KcfV
	 RspwhhyQCjt8LskA+9fRFr5uPEUAr3HTbGu316Rw8wh3HTde9UP5dR2njIhF6MDoK2Km3
	 9mZhWRdZqxmSKM2mT68eqlHNmECZiUJAdKSGgCePsItv6c52odtaULPX/A0v2pM4/NzuU
	 o0eBWo3ccp7qriwfVjzBbTxKRu0k1N1UIMdigJ/waqlUv3TzXIjCY0cf+SXLr6QWoSgS9
	 gv4n+JcHlSmuX+wNGyvLmuCOfN0Y8Cc1k88iXg5DGweqJ+sNZBe5Z7nBDQ0c1WIKcQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792809254;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=dH5vkbBKEM5au013l0qgYLpDW9rC1uOsljqA78FDWe8=;
	b=qjC4ObhX3o/ylrMZdrmrLBdZQVOjRxqmp66TXxIEjJjDgnzQK8UH9ja4Ccu+rImmrsh7
	 X2Qg3IcHWRCBGLGMDWe7IGNq9BJcwMd/bNP9xAKDrXTwMkibmM67WcOGT5b46UJAjyHd8
	 ANvesWWW+BMRCJAeqGbit49WU3xDI3iwlLdwEmhHaHdWxuwKeM8yE9KsYTJhECtYna0Xn
	 EsCei58ST9hp1WCOMcT21BPi4Weo+vpGWL++MLvPGUCKEWTrjaq3RWdN4smcxRJj6MiN+
	 7I8LgGr3NOZpDHK9Q0UVuoRBm375uipf/zw8bGkx9Qwqia1Kk1VzllADp/6MbrvxA5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCBJXUya;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDA6606A324
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 02:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCBJXUya
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08251F01825;
	Sat, 24 Oct 2026 02:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809253;
	bh=dH5vkbBKEM5au013l0qgYLpDW9rC1uOsljqA78FDWe8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=DCBJXUya8owLLYUnTXdZiu+KVVURC341m8SByKrftTcDy7cvHEgdjth4LdznPM+Lo
	 UIUsa9C/Fu1CKX5jjS8gPVnERCOH28Nui2/N/RG1GHQ5NM22xQXzv3ooB0QwAAkZGW
	 QQeId2bxHIi3VDQOFgZ3I5gkQ5jjNWR6D4ubfwg94I/+AVZ6uJYrZbAwbH2uHTNLVv
	 C8pcW4T5O8ZDdgORSlveARmNFBduiiIaMp+zrFnVY9Elk0dkp18iESRCh+OcXaZBQy
	 cPhVMdbJnjMyPK+BNAcwCZ12Ur8ED/JtB2Enlgvmvrjr7AaH6sblM8GQkq2zZHBRk5
	 uG0hOhHApERug==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  Brian King <brking@us.ibm.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>
Subject: Re: [PATCH] scsi: ipr: Fix two kernel-doc comments
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <64f80584ea0f557accbdc28c0c35d0d4c1db35ae.1792106985.git.bvanassche@acm.org>
Message-ID: <yq1ik2raktg.fsf@mail.kernel.org>
References: <64f80584ea0f557accbdc28c0c35d0d4c1db35ae.1792106985.git.bvanassche@acm.org>
Date: Fri, 23 Oct 2026 22:34:11 -0400
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


Bart,

> Commit e2bb4cd08080 added the SCSI host as function argument to
> multiple functions but not all kernel-doc comments were updated. Fix
> this.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
