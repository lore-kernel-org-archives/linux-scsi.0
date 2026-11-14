Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794691849;
	b=tKhRVu9VP7JnY15Rko416SOwmm3z6Tm0qY7G1T5DmJvs3epLQyExfAClMh61pDjVrBXD
	 UQ4mP54l0mwHTJMwK6iFB/irdxU8FPtTN/3/0TkFfPfVg0Ity/0cZA+UC6qu5O2zw4Z+t
	 dtDnwv5u2FcWYdB4/1u/aaL2nWIzeYLKsd++ITgQziTVmvq9MFeCBUI9FZxOjSd8UC8wP
	 8oSXFUgvNqoDRS2JF3tiVi/RX1SEbA0j5kG9I6Ug9ZqY9kh7+WHSr2VvkZHo6Vewl4tpN
	 IK09MP/FqOINLCSAOnKCMJgyL1je+BQEwyPxqaW+H3nSv3MfTi604JUunqfFASCuBpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794691849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
	b=ymGQJeub4D2ziDIZXZ7q4AvVtlTKmBEahDhlBpwPsmvugx5TFiz235XtyZA7mG1l9hQ3
	 raBRcLdfJJAzy+4D9f8BGEnc/fryfbgq+FAiIn9NnKw47Mcx2obZvIJwNFHZvDnIfuMdU
	 sCJk11a3hpkZbtZ8NXYjjG4QprcvYQfasXLDxzmMkxLQWmKxzNdqK3Qnu/8IACCB//Hnk
	 iFSoi1CCTg0Ja6uCg53MGS3vPC4A9oz5rM52o6NlNbuBLF41S/PEvgQToezl2PqkANQ8N
	 bsfIBKerpFfPvGEuUUVTCuwe4qDGEjY2AW31ncaUIjDVEOWtGzJr2I4Bag5PZBYiiUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWlSLmZa;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B788E606A323
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 21:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B788E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWlSLmZa
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so17852705e9.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 13:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794691847; x=1795296647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
        b=lWlSLmZaPq3CwNa2GvJ5HLBZxwrHAyR4KYWcNLYDoejqq+bHE47WezKQusTce17cqB
         UTWjdD/IlmKTsXW86lcI5Re+obIoVIb9t86LrcMAeziz9eDWUmhlf0tEDJWLXl6iumFV
         A0KOTfltxQB7iH/1NZqAz8vQsctKFp7PZfZL10agBOyW0+/+Nlq4fquLxNOefQolK0q1
         7b1VyBrgPTzn3K2O93/7d5x0teNBV9W1gjmQsMpDfJX8yxuUQvPJ+6K/Js0FjGNLg/bj
         pddRJxGyyKNTa55ItmUV+vqh3pU2XKCHu2EjpM7+mnWtIVQHlY7yLwHWBA9Qc69Hd/il
         +DeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794691847; x=1795296647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
        b=r9scFA4VcDUoNXKi560jekcfeX6fqqEtnoCZlpbGcX8oz92Ghw+XbFGxn9ASzYQ7Ab
         WqJ4TPUnNISidWBtRPg7SBND7loosBhvjFb8Noqnt1vnwBK/zBmQZGSFxF9lCVzLd8p/
         L+A8ekWQ3sjJEjzgR5C6sj2LYueuv0+oRvMWAv797fijup0I4qcgoGX6f1ZoM9zeVftK
         bQTcj/q4x5FiMzzP/YtwDK+Qrbjij3lx0xED7UxUFoxs4ddgXt5lM7pmdeHi/z5p7vez
         1pM922MeCuPTzr/jrz2wWamAoxwAibYsIrXTW/OQxdOm7l4m4ONsYkiRTAZI7WTVHxry
         k1SA==
X-Forwarded-Encrypted: i=1; AL+hErFmsEL1d2+wyNPiNov968tF5M4g4HvBQmfNhqnLkCmD0qjGwlr2SyD8aonrJXjuOOu1qSW1wW8cLyIf@vger.kernel.org
X-Gm-Message-State: APuU4Z965kFm9hg8ZR3Op4wk1y6USmkru932ZdNbtiCNpnW05p2s7McC
	T01u4r6IGZuMPPmWnbjMmU2rMI7oxWZkjCJtSSNspqojkXDJ1/+/KxNX
X-Gm-Gg: AYBFou1tijNc2UaYoe/8vdQFIqxZvBu8Zy6Z+s9EihzqWT4+ulOF7AtW0IRNeonhrET
	U5v+PaG7LbnEcu1w+A9rGxAlAq0rMrp2jz/751Wcz5MRyznhlGw6a4yq8ETJHRX1mpSAz1xGfsx
	Q+U80348sdsRdr4nPGkgNTtCslMwCnPnU2uZStHgov2sKpC6xMiWCUyrX/karuiagquFr90LnYl
	iDP9BL/Iss6pmJ9TDCfTi0C1ik3a6GxrdSSOK1oZqr/tFC7hEkovRZtxiDWB2obs2wiCfEf52ml
	ctIW/a3m0vT7foGlOdRMc4n4pT48swEoAhzcKVyTvh862HYw25VtJpipTvUwRmnsFv+5h65Z8jp
	rBmom308Kbhkts0klhUl4xwh7BaPY8Dtj5q3WteamBtmXYeBmQ0F+Jcq47JIf58kbQlet1iZDuW
	0RFFrGer1SrVBFSYvJCMobgavQRs0vQKYZS5KUaIFua0SEADHYprxv/84U7HQBbj5qY5O+PYRtg
	+Y3JteL/otpSAeWw+zhxXFKdiwcDgfU9FbZ+5P7MZ91lnV4s5Do/1J8TF3f+okLqfYzgXgu8X6b
	AA7008M91fQB0LLetsPTXwumpvY=
X-Received: by 2002:a05:600c:2784:b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4bb4e2918b1mr187322445e9.2.1794691847097;
        Sat, 14 Nov 2026 13:30:47 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm12803478f8f.36.2026.11.14.13.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 13:30:46 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Lee Jones <lee@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
Date: Sat, 14 Nov 2026 21:30:28 +0000
Message-ID: <20261114213028.1933448-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0cac5090-a135-4a6c-8221-846b34ed5513@oss.qualcomm.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-16-289114ab8197@gmail.com> <0cac5090-a135-4a6c-8221-846b34ed5513@oss.qualcomm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 13/11/2026 13:10, Konrad Dybcio wrote:
> Please add the other idle states (D4 and E3) from the downstream
> devicetree and match the order of properties (psci-suspend param)
> to glymur.dtsi

Thanks for the review. D4 and E3 are already there, as cluster_sleep_0
(0x41000044) and cluster_sleep_1 (0x4100c344) in domain-idle-states,
just above idle-states. In v2 I'll move that node below idle-states and
order the properties like glymur.dtsi.

> Please use '0x0' for zeroes in reg values

> Let's break up such long lists into one-a-line

I'll fix both in v2.

Best regards,
Stanislav
