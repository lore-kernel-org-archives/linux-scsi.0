Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90A74A99AE;
	Wed,  2 Sep 2026 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364367; cv=none; b=ds1nIPXdgbB7vk1fHUHBvIKBrYgegPgpj/rxbobk875uTwoXtfwWVqtheG58O6KR4CzyEuhQYHZzO8p9RNKd3C6c0qBZNUB/d9SPkrdojfmntpFMsvLmxeiHnq4xLmeBfmz9mc9MFDVZYVDxM9/93NdAz/DqPHYziY74Huf5IYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364367; c=relaxed/simple;
	bh=cc6ojcZlqjJYce0Pa+ZraMbBHc4qHtxHKN35Mxl3fQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rk6pvXZ+TDsJnm98ZTWOxDQilSXqU0h61IL28RHEfJg/xTfL60liU3FIW2x+BGiHBEsU5KN8Hazyt5X82tEos+yRZVKD+rdNrLtab0OBFgQUsCaApkETeQL0Av6XDV1cy89Dbf5fcygt7XXeqStFW4758qP0E32FJPMFqcg9o9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPZHiTHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPZHiTHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A3B1F00A3D;
	Wed,  2 Sep 2026 15:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364365;
	bh=uxnfMUaRrewY6o+IJUTm/G07b42rypfCR5Ewb6tmgmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bPZHiTHerXYuyKsaGFSaZOdJh//Iqw3TgkW9n1zdRZysg2C7hTaz4nm1m2hOsnQG1
	 i/QyZbEx430+kTRM3NJOrlyv4T/eRPLtcfeJiMYpgkHfbI+b+MEyfqRBF4QTofyMeW
	 bLMhXikDW/egLKGSw2FdlcHAab6/Z9Tq7FCYPBKrTy5FkZtyN0HCr5QGGS8ODmYD20
	 s3BUEzKiLZEfutgIpL5sJgzojiSK5TqnsO8sxldNX/QlpoDtMnqYWAjx7cpElbU/yX
	 814Al5cvOwvHLnEUSommOzg3vH8mINx/5xDYD9qweQ4UV94sGAmXipMG/EjXJgj6rh
	 t4t8+k/YGk+7A==
Date: Wed, 2 Sep 2026 17:52:32 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	konrad.dybcio@oss.qualcomm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2 0/2] ufs: ufs-qcom: Fixes and optimizations for
 Qualcomm UFS Controller
Message-ID: <3p2bb3jeh5vbltgz2zqjjrvzjyhvntk7jkrycmxhedojc3skub@zliooqk76qz4>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>

On Tue, Aug 25, 2026 at 08:22:01PM +0530, Nitin Rawat wrote:
> This patch series introduces few fixes and performance optimizations
> for the Qualcomm UFS host controller driver to improve performance
> and to align with Qualcomm UFS hardware programming sequence.
> 
> The series addresses below issues:
> 1. Hardware programming sequence alignment for UFS controller v6.2
> 2. Performance tuning for sequential read workloads.
> 

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
