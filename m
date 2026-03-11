Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627D2E4257;
	Wed, 11 Mar 2026 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234710; cv=none; b=CRZkrIbtI6FYrq5HZMrstVlC8ZbptnA1S/D4GKM/85uOiw/Y1tPnrCur8GFC3yqcts5clqCeSsOlE7NDOhMLkPyxdDj0/97dNyBtR2iVeoOsByA8wmzlcl9J+QuAfc5i0/1jCsEz+EwudA+2C9PAy2MInomk7e9pvqjMSYFS6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234710; c=relaxed/simple;
	bh=qPtMt/NDDpi3DbxzDPM6BCFcXuiXe2i5KCuPaNa5B+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5lusMxOxN0eDMoItQ3cBn+s+5sCnXHBJwGi5B4gj12feKD/PDL0D9oaUno+rptL7sbfJUCwUFH08T9wLdlco9No6wczJxSVvrkY5W0Qybq3zyn21vXK9b21n1n6kGhBtBfZZopTBrsd/o7r96lESb7i483FIeqeV8wEI9JXiLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ttt/97pI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ttt/97pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DCFC4CEF7;
	Wed, 11 Mar 2026 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773234709;
	bh=qPtMt/NDDpi3DbxzDPM6BCFcXuiXe2i5KCuPaNa5B+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ttt/97pIEHQaV+021Sj8MuKvLia3b+6j+4auauCOYe8HSyBPTANWY33nHQgKMrGNJ
	 5dYc/d2nLfWHl5KNNYHUZu/WrO4MkwjLxdF/WyUzscd8+CIvl7OpkHPjuKbZqLEEIB
	 kSy/MBMn1XguE5oeSxYuQp23H6ER7Iwo4P/ltjDV3qo6HDUGAuLOnEkGLDZygFqB+r
	 wLgj0akn7WwzZ+q6mjKxU8U3epB9+K4T3pxU1Yn/PUSS323hjRR3zSbmZl88S3zqHK
	 oCC3cThbkYGdCpZHgADo9k2y2nBoZNrbREynxN7ASO7rhG0SK75ZMqi+q1GGEnBDR0
	 Jmig8zVnL5BxA==
Date: Wed, 11 Mar 2026 14:11:46 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: dts: rockchip: Add mphy reset to ufshc node
Message-ID: <20260311-rich-colorful-vicugna-abb4f7@quoll>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
 <1773193218-215988-3-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1773193218-215988-3-git-send-email-shawn.lin@rock-chips.com>

On Wed, Mar 11, 2026 at 09:40:18AM +0800, Shawn Lin wrote:
> Add mphy reset to ufshc node to fully reset the whole UFS blocks
> if needed. Otherwise, it may occasionally prevent the UFS controller
> from successfully linking up with the device.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
> 

You must not combine DTS changes with patchset targetting SCSI/UFS,
because they apply entire set and this DTS CANNOT go there.

NAK

Best regards,
Krzysztof

