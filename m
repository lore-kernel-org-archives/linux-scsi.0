Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F49513548;
	Wed, 30 Sep 2026 20:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800854; cv=none; b=J6FwWQ5ZhGunt2FomONcQrUAmUEyfeE7tG1dnUjruDWh7BCbG1l+J5XQjy3TO2PX2/jERh4/RaoP0XXi4E94aTupuHU+LgaDufRx7gBdRqXAL2CkAW2bSXEppSgWILhflut5bjKRPCeAwM7n+DBi6JBLwzykoV5Ef0NfJmCA+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800854; c=relaxed/simple;
	bh=nGsVBPukGYFIgbAYF/6HyToTJ0fS5hugRJsl4g7xTDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5AjwPc+QpIphicp13yHdZ9ZsM4tw61L0MrITL+nFBbsNi5vTkDRofw45HcwC4vy9KpNFAewKkIDY1O1s5eOcgoGgAP2zXZWQ+Jf+toAy1JRu2cS3ZGZWxjzqwn5DxE0sIHwhYnjSeojzZnrrfayg/wPROnm0noZ4IzWJPEWSWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEWJFsPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEWJFsPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA0F1F000FF;
	Wed, 30 Sep 2026 20:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790800852;
	bh=n+/a1Fb8Ug0GCDftVwdpOerALben2P2rRE0gyVz1Ts4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dEWJFsPpU43/56SU3Bu5f1TyIfQqJc2XEQlYluLoBKjnER3ungwcH+bko1hZNxbsh
	 hRfKlJP34dFn67W2mzG20GidmQTXpdibVS7HmftC6GZlUzDPYH0nGKMUSIZ8c9+k5u
	 DPeevTHfCnkBV+5B1lJBqUyvwvdlDA3apOyPLToJ4R79WPxjnOco4czpJ4C2lX8wBO
	 ytAMzOxqAb8JwCdA68bd2yZBaexmHEpgZSTe9wRBiU3pgfO6OFiO70dsFz3U/mmT9A
	 JzJDDCEiLnef91QTuTFhGqeb/cla4hEshTpUEql1/F+nUMmTO200LMFcHEi1xNSGfR
	 NVf/wGeQngzCg==
Date: Wed, 30 Sep 2026 15:40:51 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Xingui Yang <yangxingui@huawei.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to
 DT schema
Message-ID: <179080084957.185445.10605717465436345604.robh@kernel.org>
References: <20260923191511.2205564-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923191511.2205564-1-robh@kernel.org>


On Wed, 23 Sep 2026 14:15:10 -0500, Rob Herring (Arm) wrote:
> Convert the HiSilicon SAS controller binding to DT schema. It's a
> straight forward conversion.
> 
> Assisted-by: LLM
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v2:
>  - Fix truncated interrupts and add back descriptions
>  - Fix syscon offset descriptions
> ---
>  .../bindings/scsi/hisilicon,hip05-sas-v1.yaml | 158 ++++++++++++++++++
>  .../bindings/scsi/hisilicon-sas.txt           |  98 -----------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 159 insertions(+), 99 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
>  delete mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> 

Applied, thanks!

