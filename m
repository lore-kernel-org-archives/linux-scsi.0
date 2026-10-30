Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793355978;
	b=dFhLQ37F16qzkyg/yHhrvhr2LgWUulyn4MqO75IkOT+AObRbTyRIQv8ZF+0G0x9sWeHJ
	 3X+y6bFWLHZo39gxUELVuFqvcqmpVQOU807/SO1Ne+xKeBUvsJlqwkjX+cflM3/fs7ouG
	 9286gwyUIsmJxFqFp896kIdezwO7X1ZMoIu4i5mOCxrzWHWjEhjXIPAUB0vtohyJT1R9r
	 alKXbJu2AlvEMpsWjGQg1Ye+rsMoEx6Xwiom5Ii4rvVM6doKxcr8OUe7CeqJHg11TFC/k
	 7+m8JSTl+SpLJJ3YzD8nWcr3DK12TfYIoa0n99XFaNw5spCDyaKfQBMs4OG+TFiupzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793355978;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VNfOybxkm0VpBWxTZYKvoWRs/XSHeBtSNrSIMYV2+b8=;
	b=jkpY4Gk5gdGkF4wzPMTHjXPNr9Z9ixdF7GbHRE14WbXFm1gTPgrdwKiUuELBpqoVLkra
	 30LDMmRRXTFriacScJui/ro//Ldc4Vno44WrSjs7qYCpAo7CksQb5aDWhuul1Oqu6pxwR
	 HqJ4nLetB8kehBS9RwY8EWIZSpe3B7hB/pZ599zcWEQ9FUtei8ZBFi/QH7vp0LFT/7mB/
	 Bqn4Ogs/vJ1h+sT6WqCRndUwuz8NWYxCVK/DkLiXbPfDlFCvLTLTvYVyTVyvzpws9db+x
	 q613NYeflQ6I+DA63AV0HVhApMaM3lXpWvovn2UosdEuDsarBD6Eklz4z5RQw7Ikn7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dvp2R0Ll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08003606A327;
	Fri, 30 Oct 2026 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dvp2R0Ll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD91F00A17;
	Fri, 30 Oct 2026 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793355977;
	bh=VNfOybxkm0VpBWxTZYKvoWRs/XSHeBtSNrSIMYV2+b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dvp2R0LlRoOyMlVhqLNZ6JR5FLzlXD9NO4r59tgGTwNLIpkqHBDBQurJsdSFJ6kza
	 Q8tKS2MKnEPjsiSPNLxAqqqlZz26gzlQHmvHQfXnmACSYAA0Rqs67RbP3hCF72AhyI
	 eu8pDnMm3R5uW/OYIYdDTD7AqK/QZeivmBBkSY18XsCvXEYe2TusWHg03MmmV4G5vj
	 Z44Mz2QdSko67d3siqi2aeLl49xbNbxGHll+cM+2wSU+gCOLsls+mgQ6o1UDHLVOZT
	 zvkWnjYhTbKgieHBjgqb1CGEkcTcei3u+AmSiYHOQizb6idDe5b19Uod/dIzCZhq5L
	 d6T6nA2G9tbpA==
Date: Fri, 30 Oct 2026 10:26:11 +0000
From: Lee Jones <lee@kernel.org>
To: Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Marco Scardovi <scardracs@disroot.org>
Subject: Re: (subset) [RFC v10 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB
 LED driver for ROG NVMe enclosures
Message-ID: <20261030102611.GB3774906@google.com>
References: <20261015140051.1159817-1-nbg2974@gmail.com>
 <20261015140051.1159817-2-nbg2974@gmail.com>
 <179319085271.3664457.8130606663267466619.b4-ty@b4>
 <6ae1effd.d3aa34e6.c46b1.441f@mx.google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae1effd.d3aa34e6.c46b1.441f@mx.google.com>

On Wed, 28 Oct 2026, Liang Haowen wrote:

> Thanks, Lee. Your reviews along the way made the driver much
> better, and I'm glad to see it land.

You're very welcome.

-- 
Lee Jones
