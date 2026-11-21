Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795226035;
	b=1yKcxEtqqb+WrmD/p0bnGGAhE+BpcwUM3rfjmICdY22MD+p4vinWC7V6dwmWO3YFn2K0
	 ZuFJK8Uwug2AVseoMmVFxrIWNn3GW6bhZIPC262Vr2r54dhrtjD7L3yT2m+Fv6QAu2nca
	 ucLxm99sp63buM7gBa4FcVpcINZzMrJ/ZmnhFY//MTQMCY6AkempICUuuC+SvRTlJfiqS
	 j4QFoWrhG7kaqg+TYNUZpBg3kYIRd8kB+fDuwPmCLQ6nrUyKLebF7wdXi37j+HKqc9B0j
	 UGa6byglHwguH0P1MpbaVnUCabE7kr4JBFSB0WkDDWBugmCNQn4qxNZ+1uH0qAps9+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795226035;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=bAEwXufd1aGDXQpyMZqUXHHvNXg6L4UcF55OuXC5FcA=;
	b=agTTBEs4IUrgzHlaszNman+gviJJLeomj930JmgodZBxaeffzGcL36Fe6xcL3vhG6h7D
	 434kT11icprU4VoFcw0znkgksk2/1NFYsQD0RmK2psBQMNQxU1JKp03bCY++2y8Eovmc7
	 uo9794NJKJKS+4lWEKCwtbGDq117nJCdceofk/exnF/vDaLzNFH8RtmEoD1jm6IxaZE24
	 IAdtxj7wy9ewKg/12VESbioJxemRYLpvIBmqy4ySgkyAOeaKIAeTPV8NeI75lQgrfE+FO
	 O7jV8yYf9R/CwZJ5cy1dX+ShYdh0m5KwibLirwE7V032MnLt5KLB1n0ie0FXEmE17gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opGg8+ns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D52606A6A5;
	Sat, 21 Nov 2026 01:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opGg8+ns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355461F000CA;
	Sat, 21 Nov 2026 01:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795226034;
	bh=bAEwXufd1aGDXQpyMZqUXHHvNXg6L4UcF55OuXC5FcA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=opGg8+nsP0elsmYvahbz6usW7HjsQqa3GSu6KnGpiohCy0PS8KdET/lScPkT7qAJr
	 F546mCR7J9WDqoMR+653GPF6weueRkSSRqmpDcIjCstgxi9ZA9/xqpQ0at6s1oSaeQ
	 LSMCPoudX3ER8CXSzgTqzugMMjTw7uVnU1k7/SXN48J0hEBGGgxxj+7dRBAwANfyXy
	 UCVsRkYNLWj+DeqrHRgz576m1vba5Pm1nF+kDCA4+7241ffwOgHTI1i6ZZ0X+Ch+RW
	 8WJ/3OONN4PAzYMJeo+nijM+KiY3Ps9Bw1mfPwqDRv3hRMKFTFMR1JOCimNNDYJHvs
	 nRrj7Q5UF9iLg==
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <martin.petersen@oracle.com>,  Adam Radford
 <aradford@gmail.com>,  Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
  Matthew Wilcox <willy@infradead.org>,  Hannes Reinecke <hare@suse.com>,
  Finn Thain <fthain@linux-m68k.org>,  Michael Schmitz
 <schmitzmic@gmail.com>,  Ram Vegesna <ram.vegesna@broadcom.com>,  Don
 Brace <don.brace@microchip.com>,  HighPoint Linux Team
 <linux@highpoint-tech.com>,  Brian King <brking@us.ibm.com>,  Kashyap
 Desai <kashyap.desai@broadcom.com>,  Sumit Saxena
 <sumit.saxena@broadcom.com>,  Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,  Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,  Jack Wang
 <jinpu.wang@cloud.ionos.com>,  Junrui Luo <moonafterrain@outlook.com>,
  Kees Cook <kees@kernel.org>,  Dave Jiang <dave.jiang@intel.com>,
  Giovanni Cabiddu <giovanni.cabiddu@intel.com>,  Bjorn Helgaas
 <bhelgaas@google.com>,  Lukas Wunner <lukas@wunner.de>,  Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>,  Thomas Gleixner <tglx@kernel.org>,
  Duoming Zhou <duoming@zju.edu.cn>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  target-devel@vger.kernel.org,
  storagedev@microchip.com,  megaraidlinux.pdl@broadcom.com,  Markus
 Schneider-Pargmann <msp@baylibre.com>
Subject: Re: [PATCH RESEND] scsi: Consistently define pci_device_ids using
 named initializers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
Message-ID: <yq1fqwvosps.fsf@mail.kernel.org>
References: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
Date: Fri, 20 Nov 2026 20:53:53 -0500
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


Uwe,

> ... and PCI device helpers.
>
> The various struct pci_device_id arrays were initialized mostly by one
> of the PCI_DEVICE macros and then list expressions. The latter isn't
> easily readable if you're not into PCI. Using named initializers is
> more explicit and thus easier to parse.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
