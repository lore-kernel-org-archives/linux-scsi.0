Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CE8476CF1;
	Fri,  7 Aug 2026 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786106053; cv=none; b=LGxRwnRk777eBKZLtOo0hzd9iVcF4x2v3ThtHIepuiPNZTTi8CVJ+bDT3WGau+8fQtsGaJnm4X2hbTHte9Y9M7dfBR3iq3Eo6blQZS9Y85R+8zoJ01BITOW9GA9DlXDG/uMV2C6ciYm3oChmCGMRkE6c2VISdn51HE3bFYRzCb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786106053; c=relaxed/simple;
	bh=t6K2nemfe/lc/d+uY+vZO4+GYJRJyIV3I0D6GphDfSw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MHfUrwvmU50zzXYMOwbVtBsBmOoxwNCXATGixn/i9lkC9Zmq/SLmtdc7vherM71i3jRksX1UuuxsOLPzstuc329EMzukZfPvoWF6r5vsxa5k0FMJFNnJl/EQHP7vrVJRNvk0UVNqU2wbJ1khc21vl6oKqibQYfIDQQLncxopT1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWDU6UJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWDU6UJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680F51F00A3D;
	Fri,  7 Aug 2026 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786106032;
	bh=1PB29BHNyw+fYmasKpwWphQJfW+LhnS0f4nBSThCOXw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SWDU6UJsmBuq++L7G3Le0B/TeTFxHxxDsHX5OxTXn0l1lLUHaopfajiFGP6YGD8Xh
	 l+5zFyr8Umjqjv+eH8tfM7koZ90yYDjXw69RkDOq9aO0TMnM9/6Byq5dLBTXkJafy8
	 +pLRlSsHNHJqFAKX1z6fNak20FfTsqkqWiAqKBAVLqmF61JrldZLec7/z2L3oYmfKx
	 TaVl+tQ/ZOzfMTdqhXc39zNVyS+XdJ0000Ce7Xfr8jFEAblVgYnM5leeIveXFeCYPc
	 QnPRvY+DwmMKcmGL7UG0lEx1sqHCBkLvWTk2Yb6A+vI2wgFd7oeem1+YZqmklHKiEH
	 woQEXjW19xwMQ==
From: Vinod Koul <vkoul@kernel.org>
To: neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org, 
 conor+dt@kernel.org, mani@kernel.org, alim.akhtar@samsung.com, 
 bvanassche@acm.org, andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com, 
 abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com, 
 palash.kambar@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
In-Reply-To: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
References: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
Subject: Re: [PATCH v6 0/2] Add Hawi UFS PHY and Controller support
Message-Id: <178610602505.740291.14877163143067387433.b4-ty@kernel.org>
Date: Fri, 07 Aug 2026 18:03:45 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Thu, 06 Aug 2026 21:42:59 +0530, palash.kambar@oss.qualcomm.com wrote:
> This series introduces devicetree binding documentation and PHY
> initialization support required to enable UFS on this platform.
> 
> 1. Devicetree binding documentation for the QMP UFS PHY
>      used on Qualcomm Hawi.
>   2. Initialization sequence tables and configuration required
>      for the QMP UFS PHY on Hawi SoC.
> 
> [...]

Applied, thanks!

[1/2] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
      commit: 24d886d9344c7973e202a7f275ff8280b742446c
[2/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
      commit: 2f7b4bc47b1e22c3e510ff6e25985edbe9cd9f97

Best regards,
-- 
~Vinod


