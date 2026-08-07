Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BBE3F4101;
	Fri,  7 Aug 2026 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786106037; cv=none; b=Hmzj3d/G1AXX+HaJ+u2V47319k/irIFSs6ulDPyp7u3t2IkjQzxu7b78bqdSpgtiBhfstswq3m8YsrhTty//CUx1VoUFKJ7sEicjCHq/OC9EYAsKEGtCbgYny8LgrUta0uDzGbzF8YVvRueUHZGcjWE2qSOEucXUW+c+6YSv+DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786106037; c=relaxed/simple;
	bh=l/XJxKFTwwVZux1+CD/dRnUhXxjQvN18eE2oozL1l58=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Bh8Db0I20pwK2m2zIMg6dRgQevgEJDko5QihpMFXuD69ZTEaW9B4QYkksXLKWzzDYslEtjkO64t2bTOH/Tare8+/gmINHD/L2s4TR8i8+cUreZa4K7c5RrRS799Goqo4Xi57oEIp6PYiQE4X1jlT0/NztKgJIYtFNqMxH9WyY7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCr7wOET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCr7wOET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7B31F00A3A;
	Fri,  7 Aug 2026 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786106025;
	bh=yu30CmLHdcupAYPZDp6KDE7U2islzsgE+mIUIZBMQXU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VCr7wOETuVsQjU5IIIDrdNF+V0HkZaBtZEkvgewU6Dq9/CPBLZi8w305tudtEjCXk
	 ruIam/2eATu5cP+eYAiFBEQIuQvPRkdDdjc93JXsf/zQX8X5vSNKBzHvoNT/R+rxof
	 XC0IixLW1eZrasf46bZssYXU37kD3qbyjQzuxsf2YKtYi6uIqPu59BniDE31fNCLh6
	 r0IJvGdJXDarjtNyP4FBhJUNC2Ixv/5qba1LyCsnIeaE7Cn7I/4Hr4wf7BxQ57jLwN
	 EHgIsYvxtU7LJY1HvA61PqDDE6HK2Llrg/2GnOutLnud3tCv384uAzM/hPHxpoSvlD
	 Rxm2/cODdVSDQ==
From: Vinod Koul <vkoul@kernel.org>
To: neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org, 
 conor+dt@kernel.org, mani@kernel.org, alim.akhtar@samsung.com, 
 bvanassche@acm.org, andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com, 
 abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com, 
 palash.kambar@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
In-Reply-To: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
References: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
Subject: Re: [PATCH v5 0/2] Add Hawi UFS PHY and Controller support
Message-Id: <178610601868.740291.16011800286609976771.b4-ty@kernel.org>
Date: Fri, 07 Aug 2026 18:03:38 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Mon, 03 Aug 2026 18:38:50 +0530, palash.kambar@oss.qualcomm.com wrote:
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

[1/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
      commit: 2f7b4bc47b1e22c3e510ff6e25985edbe9cd9f97
[2/2] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
      commit: 24d886d9344c7973e202a7f275ff8280b742446c

Best regards,
-- 
~Vinod


