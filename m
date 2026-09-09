Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731D344DAD;
	Wed,  9 Sep 2026 10:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788949464; cv=none; b=NCQBrM2tkiqelNyJCwozWhj1dLhUn7mugb3XjpudsW3vzyJnOwlCVuCsXocB6i48/wq5H2fJ9rxikncHo2Dm/FXoPKBJMZyAUiQ5g1XokhntC1tBhnegU2qITtjlC5PrDcW46HZEdmuNWwUc13ZtSu36UU5jHabnEBBbZ7R1zEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788949464; c=relaxed/simple;
	bh=d0OcXfOeKeB1PepNn16nKQm79+aKL8RIZMzJPM6MGHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pr90TaIKWXfCHYul47x7wpB8hvEjBSe9gVD2/msgrXp/YhOx0Ajy0M/Rx0KmVepoXY1kTuzzpxbmnL1exEdTBMD25FolAliTOLx0YK9XH4JFM8Tp/qtZbgg320CCssF7FY3V8JQ+3pSxQ9V9YA2dldXnCLWJhjXg65fxD3OA7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9Po5JEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9Po5JEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989831F00A3A;
	Wed,  9 Sep 2026 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788949463;
	bh=uWFw+U6UJttEdnq2ulknrQhh3b+GNRudpLVU2iXk24g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k9Po5JEhvhBiie+MZ6X4n5pcCW71gH9MB+6xcZewQUcB/D3rszf57oT1R61s6NWHG
	 kd9ErKPMSBTnHnVfViHiLewnTJ8dsBkHpe+7iiwxYmPAb1yM6mjmxkWUZ8DQfbaJOB
	 qSm6LrXH9SpRQwP31HFGt75wZBTF82wjO9HaLtVdGHmUDahsTcEIwz6zpJypFRjz/z
	 nxIW0gskeqevT46m3Nt8qFCOpvSqsb2U9qsgjglrRLIFtrgXrdf1FTnhUxmZb4kZcq
	 x48xY+U4JaYui2qCUG92aPCy5wLIRRcMYkTh5tlEdCriZe0kdma8j8Kl2kI96liDoa
	 UvCu99RF0HTjg==
Date: Wed, 9 Sep 2026 12:24:16 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Message-ID: <64e7pk62sjzclf4abpr6745ftcxmedn7eyptxmbtdb3amyxait@dp4xtzovxyp4>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>

On Tue, Jul 28, 2026 at 01:11:04PM +0800, Shawn Guo wrote:
> The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
> the driver to silently fall back to SDB mode even when MCQ resource is
> available. Wire up the same MCQ ops used by the standard qcom vops,
> so that MCQ mode works on sa8255p.
> 
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
