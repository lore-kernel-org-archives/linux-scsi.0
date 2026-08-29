Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8A35893;
	Sat, 29 Aug 2026 01:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787968564; cv=none; b=gydsMl/I9PEXYNlOnKVcEn5DNZLR0hGN48Hw5sP2gRiTVI55eANmoNVww9ocsMrV9rVIdWA0FdKkyOl1Rv98S3LG+6kS+2CL1oDY4nJDmUBWzBLokbJ6+uMWgEC2MIHdPtWuttp11IM8fOTZSDTVkSq5l6KAJ02UtPngaKlp/aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787968564; c=relaxed/simple;
	bh=rouOJ0fn0NGR3hJb2Oo7sokwcDejIbaOe7O4dJsYHn8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=YP62AZgNxT074VBvf1f7rEc2a6T2YH/iSVtZZrRaEAlbrbpD4H4c7zXlQ1LKJqDln3dwFi/BHoNBp8vtIdhbSzBzqmRsx87r5zJpitUtyUYpCnWHGO7KXpsqbBG2HEVH7NKa9y+Edlv+oGNDGRieSzm63TAoDMiSYiukyabT0n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4E3M0ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4E3M0ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7CD1F000E9;
	Sat, 29 Aug 2026 01:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787968562;
	bh=p+iwwAa4aHtJ/dd0bS0M8FDBVd5ex315gZZmcp2Fz8E=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=G4E3M0ffBBD0AFZqMoz7fJwZD6oF5A8VTrcCOAogc7/uM1yxA6dnCcG4Ugsp98DVy
	 uPKIPalq6Iii7ByQsgtANvQauB9LHMF9fx+KYix4LCnC5eg94HKuqPHoQwUFHutIwB
	 UUfh7ewQ1TYodQ82rPqqBVPo+8L/q+r1iwKW3oMxZTYfv+b1y01TpWmtz8LcqcKvH4
	 ttiOSEGfNPMVepX/qPoR4fsJccZgF3pEzuZfPLzco7IZxgbyuDxvOMk5krVj6hGFfJ
	 AaQw4riGFFvIRkEol/oHHGcPCpLiRfmchmpVKJKGL56zZqzOiMGGGDE8AM+5UgQX2J
	 6IraR7LOA7Ssw==
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: mani@kernel.org,  James.Bottomley@HansenPartnership.com,
  martin.petersen@oracle.com,  konrad.dybcio@oss.qualcomm.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2 0/2] ufs: ufs-qcom: Fixes and optimizations for
 Qualcomm UFS Controller
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com> (Nitin
	Rawat's message of "Tue, 25 Aug 2026 20:22:01 +0530")
Message-ID: <yq17bl9k7vb.fsf@mail.kernel.org>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
Date: Fri, 28 Aug 2026 21:56:01 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Nitin,

> This patch series introduces few fixes and performance optimizations
> for the Qualcomm UFS host controller driver to improve performance and
> to align with Qualcomm UFS hardware programming sequence.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
