Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795821307;
	b=pIyGwSlGnVKKafUtGOS3R9qC28xR/ilJ1yI7u5w0JuQu8+70LZiWvpeaCrWugaXBJT64
	 7G7sy+JwMcvBRmH12nvqPc/b5rHaprFd5YX0Aqed+dSQLc0DuhL8gj4jSjntN0FQOlFKl
	 +YzzU0OapuwzW22oiIaEdMIuHRfvSWMX77VxyI0aJhYmInCtCIVl8A//lEYEC0jrG3u3r
	 7VRtD91K3aWDxrJolQoaoCJ3r1nCtY4ytRHu9h9MEfzPoclk6U41ptQuGYqoy9AHtHZvA
	 xoCEcuzQgqatjpuXn1DLcdT1bkXDELwuX1lYGICMjx3z/zKhf2JKJLVMVGJX8N1bBJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795821307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
	b=kajqvH5PaStybRiHMhEeM8hkf6u2+WBvKb40vYhFXEqYjv3MHlBIJnY7ndHMG56HlBNz
	 LUQoxj/M5lyTE//b6ms1vFwK2Q0QORxg7aSSNLEtAPFUkUFO0+pWUkW5yIGKhJ4EvR5vn
	 QVUGYbYPvlTeIAx9bgeF5WAT7eKeiYJ5gDwevpZrFDBZecsYo+3hobQ2PvmOVivhQDP67
	 AUIYerFMnLbXp20eW4L93BMcopyXqNGMtV/H9BjXHjOuqtfYkGIGsXNK0dq1XlTn9tFUO
	 4w1VDyfmzsg7dR+1Bh318ZSNcOzVmgEySEfHP0pqlDXS4iLKA8xEcnGOioWgj3gqlag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WDrBk4z3;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B0606A336
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 23:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 501B0606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WDrBk4z3
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e46e449e8so5654795f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 15:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795821306; x=1796426106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
        b=WDrBk4z39jTSJg7fP1LZv5pSAmcolbmVo4wwWMjjlFQboYBu3wN5rJ9GYnYJV50K3+
         tkw+jwH1lJXR7gVV/OBT9/yk7tTAiZrdu2ajb+eYT+UVhWfUsEfp6iR0FSExSHMDzvsZ
         3fpjMgMby8qPK4rdWEnPxtHr3jKM0uthso6MfAww0lrr5k/+C3OtKtXfdvcLi7gHPltW
         qCeMSaWpCWUuLbQVELMCkcXgultuZ6nRhj58FRGzZaFMWHaLx3Tjc30C/hZ5vAlCSiMn
         7dF5c687gdpqCnnInSFJs2GpiUdsUfdCYGv9dUppGS+08fFr1MS5RebwLf1K2w2KKf8y
         FyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795821306; x=1796426106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
        b=lHdRXkjyDDvOI85X+QHksvdx5PkxXbCTkxwapkA9eTx/eObivUA45+VlKnFr/n6ppJ
         3dYT9/rHopf2WYo4zSXaMVY/qoMhvcYG1kNMeI6CZdNDWSXxUAIIxyzGVxKuPTL50Jqs
         b5yX86N02IQe/VJmr4Q0gE1rVITu8lt/lh9yfbmbutsz3tzqc1GAjL/vw2KlCDJofK9x
         HrXsbb7ezUafQBQCze/RHND8CLBX49l07fdS8pE0PN0Fb2ci5kj96QT838CluE2sSqzM
         eJAHFnzZVRbojdvqSXaf6UqF6tZWzw+sQyPsi/yOtyYN2Osje81TQlVeDwTstd2Nw3HN
         iZGg==
X-Forwarded-Encrypted: i=1; AL+hErFkDweqxJlvN5jQoDG4GhbqP0PfWNjBVTDF9a5ibsFY2YDd//CNU8S7d+c/V/+yFxib6n+393eZ8O7h@vger.kernel.org
X-Gm-Message-State: APuU4Z88lJ1hNmfo5LpXHFPfao56JzlWZzmSO26bqqXqag+WMfgbFOck
	rKHsTPI7glIazWATUTQ4mVIFVGlMPKABR4vSCfK3GNmI3X9SXEMd1J19
X-Gm-Gg: AZFdTZeRUU8CzAsx4Elua9ihgRJdCesAECL+o/aNA3uO+66fwa8hKW1xacCGfNnxyCD
	JOzAWP2kBuNfXp9JNgBkbBT/3c3VUlp4n1wOgCL4da0f2QK1lbgcdmp/bRIoRUrpjKJVG0tHZbn
	pd3APjfoQqkGjMsGw/3BRr4Z6DCo5ULLqaAWYIjjFkFmdHD/YcxF/OSmeRZP/xHTFEKsNsbRHV2
	wwm+FLM+2/DmSYPCh+Jt1jeMkYYJPwQktfDs/wgkczPFuVQsGQGTPsMqVtDihPR3zwOpYlln001
	vU3O5hk06Lr5angBAd+JYRBiBl6gYA2349zsGObroO+u/6QWm/erxDVLH49RaWE4voW+AImTSHJ
	uxkSWkOm7/j+/VnlkbAihB1ujBpUCrTC3ZEn41RGUMrGIKBOgUrWoPtT2nkCw0LX+CRsGlyoKG/
	hFhtrn3R9h32u6ZCtb8uGt2mF70YK+lmNR9LLjk0VZk/UADcdRlP3hNbkeZHckZMhNVmWjE1i8n
	Mhxix/H10dpbu2Jf/F5TZicfuOHnTBcy/LpagcvF5i/3aCdQHSwucEvCuE74HHTP+v8bDS4rPiL
	GXOP6HUNnUg1uKZmcJs4+uTyNSk=
X-Received: by 2002:a05:6000:178f:b0:4bb:c85e:d565 with SMTP id ffacd0b85a97d-4bbc86e17b5mr14733028f8f.55.1795821305534;
        Fri, 27 Nov 2026 15:15:05 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe48sm45269880f8f.23.2026.11.27.15.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 15:15:03 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
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
	Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 14/14] arm64: dts: qcom: Add Samsung Galaxy XR
Date: Fri, 27 Nov 2026 23:14:45 +0000
Message-ID: <20261127231445.3623202-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <87280d80-9047-405b-8dcc-11276d34d2dd@oss.qualcomm.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-14-5c8311c0b70b@gmail.com> <87280d80-9047-405b-8dcc-11276d34d2dd@oss.qualcomm.com>
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

On Fri, Nov 27, 2026 at 02:58:40PM +0100, Konrad Dybcio wrote:
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Thanks for the review.

I've implemented support for almost all of the hardware in my
local branch and I have found that the headset exists in multiple
revisions.

So, I'd like to make a split:

rename: halliday-samsung-xrvst2.dts -> halliday-samsung-xrvst2.dtsi
add: halliday-samsung-xrvst2-rev22.dts
add: halliday-samsung-xrvst2-rev25.dts

The .dts files will initially contain only compatibles.
The real differences between the revisions are the DMIC drive
strength, the display panels and their supply voltage, so the files
will be 'empty' until I send my sound and display series.

Is it OK if I send the split in a v4, or is it better
to do it in a follow-up?

Best regards,
Stanislav
