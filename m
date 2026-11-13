Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565813;
	b=FtcUSCa3xXR//Nemvvf1EPzxfsE0Mt9eXvrRoLIPNhYdbi13kHKee6MabdkGRrtrdIeK
	 DB/+jZm2GX/gkxZbO7t0NzFR0ItC/k7FD9XoIOFBOUwcGPBDRMDtgYcC0RTBzabbR6gzf
	 NibrDd1OYCIuvSwEVUSsdBIM2NftURsWjgJKjY5vuGDLKSQWk7hPjljpDeQl2vTpb8apG
	 KxVIX5KaPvbivsEvXuHt+YVz4RP6Afch4fqqdnn1LUV4TNWgze1ErsbLb+8kxt9/h8oiu
	 PppxC0znq1YYVXrLXBWM19BFa1HpQ/4NwzVdXXm1kcnedcpL3yp4SamEgbJjJpBM0aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565813;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Onr+sY6kcwIMhOVzt4cQhVPIJDQGs2ul9JBzovMMmy4=;
	b=faTBWiGm9Cmjl3xCbySBmZxUIEf30kNRHza+qsHsSu3Uv2N9QDfGYtWtp7I6l1UF/W2+
	 oc/1GdvLwIYMMHnDkWM6oWqSDvYrwOPjamaqlOSnDnE909StoMcm/9d4Oh2/vYu/t0BMi
	 p01keFokqAybC+PFUkB+b6mkTwwydgRCBAEP3bHw1Q2d4u3xWVNm/CgDMcEdCazp2xUTu
	 sAUNg6B5PBWXHP2KDwDLXN/B/pfjP5MJWc17Ur1sZszDrHPv5KJJwAuD1R9Sn5HDojg/O
	 tcXQAnQHM7Jh8esxmfxb+2KrGcVmYQvpTLorVk17raFhTHXdqkXTVSMO54vmWEYLMAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyW6dvkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC165606A32D;
	Fri, 13 Nov 2026 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyW6dvkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7ED1F000C4;
	Fri, 13 Nov 2026 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565813;
	bh=Onr+sY6kcwIMhOVzt4cQhVPIJDQGs2ul9JBzovMMmy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WyW6dvkXp3VMY6ez01G39IuLblyIP0eftCaqkFX/CgDfI+LyRX8V+6PGJO4eq8NWx
	 BeRaEb9ub7lPdisSDGlmbTz1SHcjJNUqBvxAIqNfvULRWlm42ILlcnn2hhuRDX6dQD
	 u5z3OOZ9vIxD0Gy6ZNXiSNa96efIzTx1w9VQOfvlGPlqidpWyPs+oxOHwXwN6KrbiU
	 /clX6zx4cJJByxgmh3qnGIXp2vG6ndspOQZflQWsZVdfWX6ba1KTjaWURmhAjKSgQg
	 dxAPOsw3YBGfgkBQ0r5FRdw6VML2hHYehcu86PfLiTnqLxBaf+sNALfskE1g//Fn8t
	 gozLfOdTK2qeQ==
Date: Fri, 13 Nov 2026 11:30:10 +0100
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
Subject: Re: [PATCH 14/17] dt-bindings: interconnect: OSM L3: Add Halliday
 EPSS L3 compatible
Message-ID: <20261113-quizzical-ivory-gharial-1fcb14@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-14-289114ab8197@gmail.com>
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
In-Reply-To: <20261109-halliday-dts-v1-14-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:26AM +0000, Stanislav Aleksandrov wrote:
> Document the EPSS L3 interconnect on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

