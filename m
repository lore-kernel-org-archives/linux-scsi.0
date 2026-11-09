Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195197;
	b=WXgP6zhbmX1OzC87ux+wY97zz2zChSzUMgubMqEELZDUXsKQ2WgEp9SfRsvNz0lUc9zc
	 kClAbSGKzLfP8MTlUV3OwEVNLRqN0jenE2mon7l1mYRheUec077ae/Bj+ZRwl7C2CbzOl
	 /5x7ArfCluDqOlxEBrr82+MD3hgsisUrtTRbQYkKFuNk3Hz5PrSeE37sFimGijyE0O6Bx
	 ZGRJZAa8MRGL3TPrP7JZ1Ncx7Hm8mf0FyMEKifW94eUaDYIUyDXyd9eaHMw7UubzE3QyT
	 eNR6QgWWPnrRZ4IL/3+nJA4JmRHy2RfQM3CHAKlMQeQB2sxVmX7Sk9UC7D9Jgu0zAbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195197;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=hZeWcvJmcWSh6f8njGGlnk6OtxBT31JFdhmDrEkmf1g=;
	b=XNRCr8QT/tj05z31pspL+LKJpkmEjUnu5Eb0mBTWl+SWx9LP5V8WI2riDpBBxVYd+/jF
	 nXMCwKU35c89I1bjnV+gChsoKCQHwcEGenNCnuGBb5gwvqUu+CynNBoq5sawNuU2dgWSB
	 CzqwMkWr293133cXHKKahaBDKfqWojZVLbkePylmX72thpM14cWwoOcCbY+g+LFFlt/cK
	 O2xhrEJSRHtv/8oI38AsqXnKfxpkyv4r/uGg+oOxHu6JBJl00Iyjy7GYR5PAQzkk8mto2
	 Szn6ZhF3EyiKRCETOmi9ODrbK6BiNr0q/45sFglnBE6JAh7Xk175JabPZtPYzjET+JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBjSP9FM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23079606A321;
	Mon,  9 Nov 2026 03:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBjSP9FM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5841E1F008AB;
	Mon,  9 Nov 2026 03:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794195196;
	bh=hZeWcvJmcWSh6f8njGGlnk6OtxBT31JFdhmDrEkmf1g=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=oBjSP9FMQk8gkTQfwSVISUnjhd63EJhcZKQ81yIBlArAeFHB1+WEcnnZCUNUlKvkA
	 FBCVO+FHBlL58sYhcAJn+vZcuJY+QwRro0QT8OOCqaPMvk0FRYuQXN5wvVodf61iQf
	 WBRTBk8CW+y0fhpSQsypp/0X3V1PZVOwb8QiS8FxPuWkbU6cER0jxlRs2Ezg1ukVXR
	 /itD5B2V8GGcpFK4yOgJbe+ZTMj57Y+TSviO+B2c3uP16KDRWbamRYcuXG2kF+dl5V
	 EKFDB0yWTapSNefB2lGhrjyRW1vMUEitpF5iacjljN+iARAwoD/B/G9iT+LGiYWC7v
	 Hit01yGUgeNnw==
To: <shao.mingyin@zte.com.cn>
Cc: <mkp@kernel.org>,  <linux-scsi@vger.kernel.org>,
  <target-devel@vger.kernel.org>,  <James.Bottomley@HansenPartnership.com>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] target: remove dead kmap checks
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
Message-ID: <yq1a4niwufi.fsf@mail.kernel.org>
References: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
Date: Sun, 08 Nov 2026 22:33:15 -0500
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


> kmap() and kmap_local_page() never return NULL, so the checks after
> them are dead code. Remove them.
>
> No functional change intended; both patches are independent and can be
> applied on their own or as a subset.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
