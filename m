Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688AD40F759;
	Wed, 14 Oct 2026 03:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950238; cv=none; b=HhWG1WmYmxQqw2vj+m0nsISFPCLDMCK/KrLbatryTTsxDji5X8Kn9u7xAycnET3FrGKHv+x728EOB1f1+j9TH78ro+3P/UqSVtf9wKODvizHexnje14Y2GFUdgpgR44AwpIy+qfdJ54eh/NvYuMaWYcpnPEOpEuyGtiSdsIaTiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950238; c=relaxed/simple;
	bh=Nn088Is9vLz7pIMLub1T/Ylzg9Tk9yEr+lmk/Vwdawo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Na2BiLX9NHVt1Pq8+jzc4H4gOkm48vYbEbrJagYTdLnmFrsnPB95NVlQzYErdk5A/7WUfVzxZVPD0/CVCJ+7IObxaspIdf2ztDygIdEpdeVVeymkMFJgM898kuygIV5dQVRKmHCSpeSoqc4szlgjMFQw1oi9Pv+puIPbqrNsJF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y26SVBq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y26SVBq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228F61F000FF;
	Wed, 14 Oct 2026 03:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950237;
	bh=l97hTG8vmW4cca5oN1cg8rBkUckbFgeeVTbkelusRj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y26SVBq/axJCCJeNQ/tVvCp/RBFISL3/V/ODrZWmRRXUGk5NpRgZcs8skrruMfA77
	 LWpDhSDZfbENP2dgmPcE8r5w1oAREB3NmtGRAor9PMbUbn4BZViHWoqzMNiO8WDI5i
	 XUxOMq7wdWTTEYGR2ZO6wuYBiCDAcvkBYlhpoZTX8q6P1VLMns4mXHeMVwYmpSC9aa
	 1mjd7AyfqpGEemyKADSzPvnm9KyRlKlzi2SYFhsoqqwvO9vzoV//gXeS4fYe2HNZKP
	 ZpedtMNucQ0w5oi8D7T5xnbjq6FrbqM+p5ZEBBIRD6N3FdmVZ3kM3y7ws32TUDF8Jd
	 hsOHq67EOkcbA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: Avri Altman <avri.altman@sandisk.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
Date: Tue, 13 Oct 2026 23:56:51 -0400
Message-ID: <179159633705.2229379.14770324676188015248.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930135947.2339918-1-stanleyjhu@google.com>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 21:59:47 +0800, Stanley Jhu wrote:

> At Avri's request, remove him as a reviewer of the UFS host
> controller driver. The listed wdc.com address also bounces.

Applied to 7.4/scsi-queue, thanks!

[1/1] MAINTAINERS: Remove Avri Altman as UFS reviewer
      https://git.kernel.org/mkp/scsi/c/80f75e32786a

-- 
Martin K. Petersen
