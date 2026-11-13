Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565784;
	b=vVR9OiLuqeH8JBPe4NyuIZMdHkJ5KoKsRDGCgu0QkMtyZR+V4LfEXKQABB9sg9lNFqli
	 X/EMyIt883p/e+SD6R6v0xA2YyL5f2Uy5tLa/TjJF9OFQ4vlLclR9LA+C+lbg4ArPv+9G
	 18TU122Z8rFeKzeD2C/z7gUEY98tiI/zL7L9Mndk9byfumJutIrCoQZ25rxuJmKvGW+wB
	 nGMwrPshro1PwFFpPYIhcUUGDfguRQOAVjCT0FnG4G7DjxufCAvlyeRs52pXVOVwMR7II
	 NwtE912wt2zuiVNWNhhpkh2agYYBmRWB2K7lQ5nSHoHz20KD8ukvH3Vr1HgdI6PBasQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565784;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WSY+ANdltmdjp4hZAqbq3uTRH7NaIarF8ThTGR2AH9A=;
	b=FHVk9IrNbVc8UY0jrOxNxVyQVbXV4bHzCYLaOisju5mUYdqB8/pmxRxuhgxdJxzKVOgx
	 mMb1LQVTUm970mqXh4J/FfBiXdm1AnQnogutCXR720WJec9WJAGOwRW+VEecJejrElwb1
	 lHhPZOMrpFDVN+Tjb6EoCQTrhToIsGAEkLC4GkjpvgxYBknuEWMc7maTsxbsZGnJHGtr2
	 dAe7biqe3DEAxw74PmMevXFq8PtZmN6G0Z56gIPtKUKC0panw/MVATgs9dloGpKzXbM0L
	 XK5rYDi31ir6yo8vlnWVRHE2WY8wiNLiAu215L7jXlBG9UTF7gymnuEn5PMyFgjPR/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N3B3iDM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AE4606A327;
	Fri, 13 Nov 2026 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3B3iDM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970AE1F000C4;
	Fri, 13 Nov 2026 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565784;
	bh=WSY+ANdltmdjp4hZAqbq3uTRH7NaIarF8ThTGR2AH9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N3B3iDM/ljx4vAaf5Jrz/ajm1fa4aQGTl0CefZdslx+6VxkuARBxhjYSNmi4qMZFf
	 QkKLtsxQnbE33zPcPAahlPFIGDzefeYPn/GChO8RKvxkqM1+jeJu9Et9Q9cexMlMOi
	 Y2LAHbnJGYXj1OqCp6QwTTvPlu3p/jxUOE88QJniywunLueMhWz0TPZRG1UcPikn9q
	 Z+xuIMcai4dnLzzigGZCK0FpWlTYQWUm+cXDkkL4DMyUKGvMoICIOjVNnNmmPQkisH
	 6coL9DouEs1YexVKGveznBYverqxMXunO/dSm6+PLaJ9QpK4do7tS/Wufkn22KCzxo
	 N3l1ulc/hiATg==
Date: Fri, 13 Nov 2026 11:29:40 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Robert Marko <robimarko@gmail.com>, Guru Das Srinagesh <linux@gurudas.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mfd@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 15/17] dt-bindings: arm: qcom: Add Samsung Galaxy XR
Message-ID: <20261113-meek-laughing-orca-ea8a86@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-15-289114ab8197@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261109-halliday-dts-v1-15-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:27AM +0000, Stanislav Aleksandrov wrote:
> Document the Samsung Galaxy XR headset, which is based on the Qualcomm
> Halliday SoC (SXR2250P).
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
>  1 file changed, 5 insertions(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

