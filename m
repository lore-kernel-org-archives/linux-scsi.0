Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5D21A9B24;
	Thu,  3 Sep 2026 03:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405028; cv=none; b=NK3CPfqu+li23KNH/hCK/+1nAMbeaYUbhXR3XIrPikUfnUDXbt+rlMvQkTsKImKqZcQbOFT0B8Iwtxf0vMmuGCWsAhYFGrdM1x0JjrMApMZYbuo4LTqBoyfDURqmL0HGxMENQTEe49rssmr2sOra438nauRgFJJ2qDOEy45LLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405028; c=relaxed/simple;
	bh=wMwjnUIqv6wFeNjqfbo3PZVBRMjA2EFba3AGN6LbpxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IU3h0gm1SqVwFwUaXVhtcHqiTDbgQWsDPJYopVdUQJOf1BOJbMv4GW6Fpjcmps44e+HSFVcwDQCB67OPqGXEo9J7MO1XTxsaEgeQoJFokt/0YCGpT+DWtL5Tlcoozv7Ip4FXcyye8ti3x94OuYJdImhV1+XmF5U3Mu4gG3ddF/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pqx/rl34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pqx/rl34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8061F000E9;
	Thu,  3 Sep 2026 03:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405026;
	bh=piM931iS3QcfCvF/iNCzNGuy1jpOOsm4i5NMdfyql7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pqx/rl34GXIy2YUVQIAN8KcHzRqFCKapNXV1jX4PRub8FPpiWJe3GPRjv0nqjy3Li
	 oGUWKRwiqghdEnN315R1fxtCUjwW58jttnYawIWL4ZfZyGXSKW6Y6zSNJam7XEsoNQ
	 rNZcb9mx60taj89JBpVXLZhjOEB4LW7RNYtOmGs5yqNzZofqHt3qcn/18bYCHBBqnI
	 Gktdmtn44aLWnBO2UXc/FnTSQMRRmjCArGZ/knNvlpLGLrUsoBnBaRJb+TeXZfe+hJ
	 JAgJhIFTXIEQ01DVh58ybiI3SuHijVm2elKoWWH6lL4NbOv6oR+JWiCnaQC6mfO2RV
	 kHbOf32YGsLcQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <chleroy@kernel.org>
Subject: Re: [PATCH 1/2] scsi: ibmvfc: fix kernel-doc name for ibmvfc_scsi_relogin()
Date: Wed,  2 Sep 2026 23:10:06 -0400
Message-ID: <178840472584.670675.12007008371974390707.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 27 Aug 2026 16:50:37 +0530, Muhammad Falak R Wani wrote:

> Commit e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as
> SCSI") renamed ibmvfc_relogin() to ibmvfc_scsi_relogin() but left the
> kernel-doc comment referring to the old name, so a W=1 build warns:
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:1901: warning: expecting prototype
>   for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] scsi: ibmvfc: fix kernel-doc name for ibmvfc_scsi_relogin()
      https://git.kernel.org/mkp/scsi/c/9a0716348daf
[2/2] scsi: ibmvfc: document protocol parameter of ibmvfc_alloc_target()
      https://git.kernel.org/mkp/scsi/c/9a69cc5f192f

-- 
Martin K. Petersen
