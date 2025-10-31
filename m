Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB8B280327;
	Fri, 31 Oct 2025 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761928097; cv=none; b=D/DKtsofuhYGS+daHqIJpK/x+2W8q1TrsRhgc4hUPkNqzIH23rVh8jwoh++3Ist4alzE6tjwb8yMkb+TTvSKB8IDYo+QJ9SyxqZYLEUXqUIWqKJUH/CAwQJYMDkPNb6pkVotbsB7AzvR3aYm7zI+qdhTnGPp4lJL6djKXlWvt4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761928097; c=relaxed/simple;
	bh=J84IQUL9bblDhG1K4MYDhAu/ebJSucswpnmmazP+pEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPw/3W8Wv1bfMgnYsCEzuCZZh5f4TcPIqprrO4hfMd1/lX2E8vTSgSuOkq4KgaFUpZCxoGTH+3YE8WX0A7IJ0OmtazI/sPnRBVL6j2vnbfLM5EKxm1/cIb7+SOkALks+F4GaFqCSd2Sgkm0cecvlb9b2hqQ7Os4ugbdAU5xYF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ii4vi4do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii4vi4do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42381C4CEE7;
	Fri, 31 Oct 2025 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761928094;
	bh=J84IQUL9bblDhG1K4MYDhAu/ebJSucswpnmmazP+pEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ii4vi4doCkLRPW1OiEegRLUvHoi9sSYnwbZx7UTKizmW4OWXgaXzOxHz70r9hpLvm
	 fmyU7HJh+wUsDj4YPZHrynwCyFwqUutuINETDIPoz9V62zoBzQusuL/KP/5JcanLSL
	 8LUSvnqGMiMWrmIIIy9xMOXdRDjULeBe6+zqsf38BYkhLYYJ6sdMoZ/dzWvaJ2MvIL
	 WcfEXE8fN/sD216LUHAytWSIFyHyvwyNg8ioVpKwaNCELZl3VO9CWH61HRycvoU0Fq
	 ocNnQBNxWoopcyYyPHIgg/zpxVhZg9f2ul65zTebNy8CdzzUQ9wJxhwFvB+sWRv+Nc
	 /ODyNG6ol2Kxw==
Date: Fri, 31 Oct 2025 11:28:13 -0500
From: Rob Herring <robh@kernel.org>
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, lgirdwood@gmail.com,
	broonie@kernel.org, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, wenst@chromium.org,
	michael@walle.cc, conor.dooley@microchip.com, chu.stanley@gmail.com,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
	naomi.chu@mediatek.com, ed.tsai@mediatek.com
Subject: Re: [PATCH v1] dt-bindings: ufs: mediatek,ufs: Update maintainer
 information in mediatek,ufs.yaml
Message-ID: <20251031162813.GA912533-robh@kernel.org>
References: <20251031122008.1517549-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031122008.1517549-1-peter.wang@mediatek.com>

On Fri, Oct 31, 2025 at 08:19:12PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

The ufs-phy binding also needs updating. You can do a single patch and 
I'll take it.

Rob
