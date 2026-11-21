Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231444;
	b=zD6eGj+94qiCybX1ng3r1o8C2yli6Da/84mAXg93pMXYsIlDeDrVLhsHKOO0XwjyABf8
	 4zf7jHwVmgvxIhCj3isnlyz1LZhLQP3bbSLDzLlHcZVEb1lRIOKHEAh+B5WVmJPs862Vm
	 ecvY92v2juzkD7lyljMP/ZTQ6SFGFRk2S7DEdEdP+v0kqp9YtaDniOFPA7ZOpkILXSuhK
	 PyzA3C3waoQnW3ruynOJ1QkZJ0sirHQtsbS1U2xvZkk/J63HuVczthOiU/kMrn1TisNGi
	 pla+qAAqTEQkYyXcpRzZMWxm6FQm8VTpf4g4byRpKHzQVb79305iDhHd9Elc0nqhQjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=8ZqqGS1stonUlE94QAUs93A9RzAR5iVuZQDEzLlcpIc=;
	b=2SIOo9aNltBbxBBix1pWZ92kAZ9lOD3L6IRK2CVjHV75FbxO4UZYYUEQ+PlhHFVOKX3h
	 Ue+mFw1iIFzfysZye0IZcGJ0vkqOUzhwj+moRkZv9CTen0HZDzDUJWtLu4e7qSOcP5tAn
	 j+yqzZcyvY0drC43AnHwnZOv9a+tAVEgK8qy+mMf1+XTfwXyqJQw6eHPQDSurkgPWJ+/F
	 0lGuXfMjMXQtL+4YLJueMJLSGrnIQyMPDYkj9CAhmNmVjZZYloVeIQ3Nr8oRUPiQFc8LT
	 y/fJ5fH79yXzoMt025C3PsncVVdMWbkgayaxOq5VTZtPFrE+EIux/y/0oc30Cg68wFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MR2fQyQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C757D606A6A8;
	Sat, 21 Nov 2026 03:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MR2fQyQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84F81F000C4;
	Sat, 21 Nov 2026 03:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231444;
	bh=8ZqqGS1stonUlE94QAUs93A9RzAR5iVuZQDEzLlcpIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MR2fQyQBacsmCArTCltXa+t+cXA3v3FiAKBq7PYtL3SStV1af1or7hrG6UbNU1t6q
	 Z83k8K8B/1P9MrBk91ogJBQwLfcMMEDqWRxczMkNq6Bz/PLp5ZlH01WfvNak8rZTG2
	 6coqgHc6/SscJKh5aqJyNGt2TaJTDUYnOvnGe4o19FlY5L346rApfWFP7x4VPSHHC2
	 U9X7DQQ0zSvPWyHoVi6HdnsTmUnnMjNxBtjqYpPte8hT+qe8gi3AReY8R7bV7GkObF
	 aCCej697z12Wq7hozHCyWefjXYUPTa3aGV8ahpVdOtfabhyFN3tPLL4bLqEjbL5Dnw
	 BevjGWHy8MwFg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Izaac Chong <izaacchong934@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Fix typo in kmem_cache creation error message
Date: Fri, 20 Nov 2026 22:23:57 -0500
Message-ID: <179523138185.420037.14693835253304960773.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114-fnic-typo-v1-1-a9f70c9c4a6b@gmail.com>
References: <20261114-fnic-typo-v1-1-a9f70c9c4a6b@gmail.com>
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

On Sat, 14 Nov 2026 08:33:43 +0800, Izaac Chong wrote:

> The error printed when the fdls_frame_recv kmem_cache cannot be
> created says "cach" instead of "cache". Fix the spelling so the
> message matches the other cache creation errors in fnic_init_module().

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: fnic: Fix typo in kmem_cache creation error message
      https://git.kernel.org/mkp/scsi/c/bd91f6b3b684

-- 
Martin K. Petersen
