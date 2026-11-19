Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795112450;
	b=wIk/fRQzMAh7NHkaeoCiOia2aM7uR3FxR7zXifMeut/cLC9ExHzDqjgpxhCSKDmUnTC4
	 ZuEWNBppQcoxQIkUVi3vK8j+XFSgHofmsyrhZLhU4pZzgWx035iR0oSN5HtXAI1z0cwkF
	 nLl1l9gr6jg/wgOVV46OoebxBsag3UyBhVrLoUtc/fr3WrsYpeoabf1BBQ4e9vwK27IpS
	 qf5u7eT+Rjan5he2nxDIX9xuLAMvnLJDA+0LZ70ay7R0ZTldMBQWlm/bWfyEGfXWdr7tO
	 +C6N6RA4QxbuMljEvIi0pOvt+30XARC/70kYeFhOfjDj95mWmsL4bIoQsEgjh+xz4vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795112450;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=5cY+QOFSRab+vw7Ar5Uc+Mh1ld4eiD0jvPyComZKkI8=;
	b=MvCGHQeSVJeruMRl0a27+xVHcKTpNwtpxb7U+IAugbJqU2xMORWeZcZ+00XwvUKb/I6n
	 KvhkbrKVemkwkJ+27LiniKf0vinp9mtOk45CmuZvERsK354OWiqgEAdJKyVSfP4Nu52aP
	 dZblhoHdgcoR7u8qREJxVz1rVYZzaqYk5GfKuCMtBFKzKNeSRqC7E4oK0fgRWTWEs89UG
	 Y5zJKG78ctaC0TuSKSIQhHvRkg2lgk8xFwdNTBfK3QFrPkyNSoAnt08EFYwvIJG3RD3un
	 l5e5mgE2SL2LTQeLzRVPM/0HH860l4fLJnCEY2wpLi93/JLduiwphEH3cOb4PUkFdGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFVkDPWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E5606A325;
	Thu, 19 Nov 2026 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFVkDPWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0EC1F000C5;
	Thu, 19 Nov 2026 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112449;
	bh=5cY+QOFSRab+vw7Ar5Uc+Mh1ld4eiD0jvPyComZKkI8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mFVkDPWNUUaI/lD8LZupI2Dv6P1hrK9IDKEmnqQP3hRcjIokrajVdotKHQAyu0NV/
	 LRn7QDpEIl7PkujuQRr3JBOYQ+mJ0JJKhFd3EksrdvpLpq/b5w75RdtGldsmRSuWuG
	 Ej9e2CQPJJ3vc6ty6KfikChr+J+4TieOCN5RUxlTysnTo90F+i3dQL/yhRCP6r9QKI
	 ZUEOfNqI0qQI7nJ3efrl+mVFZSuYADsTl8cPGElqU4t+ZqtyImk+pdJ6b3Tve3I3qk
	 6SUHTGBRqWjRzEw9B/SNFUNcnVx4t7sMsIkZvT0Ltu1LVrPnQ/gifStw7uYoI+dALN
	 894KwzJuU9EZw==
From: Lee Jones <lee@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org
In-Reply-To: <20261109-halliday-dts-v1-5-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-5-289114ab8197@gmail.com>
Subject: Re: (subset) [PATCH 05/17] dt-bindings: mfd: qcom,tcsr: Add
 Halliday TCSR
Message-Id: <179511244123.91992.13336083093444200069.b4-ty@b4>
Date: Thu, 19 Nov 2026 18:20:41 +0000
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
X-Mailer: b4 0.16-dev-ad80c

On Mon, 09 Nov 2026 00:33:17 +0000, Stanislav Aleksandrov wrote:
> Document the TCSR block on the Qualcomm Halliday SoC.

Applied, thanks!

[05/17] dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
        commit: 51a1764ff434dff86994f7e03125033deebda6e3

--
Lee Jones [李琼斯]

