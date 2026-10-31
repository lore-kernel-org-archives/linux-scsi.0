Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410820;
	b=Qf/zKdxrMsElztIBFtjR68GDCStoyPb+LOeuMrnVcLx0E8U24rgcJd4LBTcfxf6oz+os
	 FUo7w7RvxXa+VESY91BnSccUMX0VJwqDEqxp1fEboASxnzvDMzESTbWrjtike/slSHaXv
	 KuRYxwyASdRCLtDXsNzwjHKDuJGaF/K5F5NqteNekcdpGCiFSfx3rF83L4Cj7oH6F8ba6
	 owdlolpQmB+TGsj2wYgcmBwOeMH1Hv1tmsMkXRNFjw1ZWToFV+flW+xtAYUFPy6aR5MyY
	 Gy+X8bG1fVso303ekBLoSI6ZVGFV0vlhwWYR5UZJTi2BWYZhS97RPcNshN3iIQJu0jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7gCcfi9QJ24HFTf9X+SiW5u0+r1lkDm7RjJiYGUcYts=;
	b=ItJZR3mpSoJrGSxrfiMQmtXI6MfEl01Nqa+INOmX/09Wxeo0photN5z0e7EtM5V/agHW
	 9f4bhzJGwAsa+rwk+hpz8TyZA7OOp4l6KuuK5kThpAT5kYLRv0Cf4yvEyftZanVLDJ15c
	 IYR2xpLHd+KqpigyqX7HYaPyzJPCrFHSOxqKWBoCKDP6D/BrL+bb3WULhPeenCERUqrSL
	 Iwy68rZoI6mAYCidZvtgVNMDCTTWP7nQolMCNrhCOyHUqrSufKNSXDs3ObicwvJeft0NI
	 otoi8CvimbCwRGKTHPLv3GaP5ehzyBAihDrRS8I9YRw3RZUVJYBqeZPcIqWZLxCWUmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vc7yowoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6F606A31A;
	Sat, 31 Oct 2026 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vc7yowoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D951F000C1;
	Sat, 31 Oct 2026 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410819;
	bh=7gCcfi9QJ24HFTf9X+SiW5u0+r1lkDm7RjJiYGUcYts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc7yowoNEft398+xVtBB+QnywT/Ipnh7Sw7CQjcgzgC/bMU2FnQbbEO9YnGHR06kt
	 PCJaxoq8cTYVQTy/1LFh04VoOq9JtWox2RG7w+uVfoVlrP44i0HromERQtaBcJT0TZ
	 iFZG5ELlPXZ6bw+p/RpnzyvCKAuahI1sNkmBaLoRMmRPNcYhrdK/lKmqf6kuRe5gSm
	 +E11iNd7iZ38Fe8FUcSWqYn/AiCIEvrpzvpaOAyDkuViYNu9eBQYaest6/BeWkdWye
	 56N1+N8owsIZiLgf7W0j6+lKOXVO9rinXr7LiPAHRDZLnSKtc4xGni+7NbNCIhP3cC
	 uo3VhIF5UZVBg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Add __printf attribute to sas_ata_printk()
Date: Fri, 30 Oct 2026 21:40:05 -0400
Message-ID: <179340755642.952351.10711427371236359792.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
References: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
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

On Tue, 20 Oct 2026 21:59:34 +0200, Adrián García Casado wrote:

> sas_ata_printk() formats its variadic arguments via struct va_format and
> %pV before passing them to printk().
> 
> Because %pV hides the format string from the compiler, GCC does not suggest
> the format attribute under -Wsuggest-attribute=format, and callers do not
> get compile-time format string validation.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: libsas: Add __printf attribute to sas_ata_printk()
      https://git.kernel.org/mkp/scsi/c/503e6172fa74

-- 
Martin K. Petersen
