Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3B4A9D46;
	Wed,  2 Sep 2026 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365011; cv=none; b=c7f8GB9Ti/wqz0g6Np3a6Hdnu27weForkXKgn5bTkhM4W2VF8ESXU4TLURy/QEUTP97wxaAmv7/kbcDSrY3/OhvMgnKoOsKgHyKN90vq7eSuAX/Q48808VasfpKJ4ifUUMo2PVyK71t55/XErw27Og2i1vap/7OQY0WaUFQwG4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365011; c=relaxed/simple;
	bh=fLTeMmI5xUig5Vttbbl/TZTqRFx+UOuhJ6v4Y6wbZpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLX9cuWjIGCAF53G4Q4t5sEqvl1pMYW0JmDXl9cnRE7c1aCwBbfYCQ3GKAopXBjf/IMIJCVsxEvtfI9QI9f76qs+0wKMnL8X55oRDG4XebAhRTZNAf04H0sS1yFagHNYAvNk3e7RFSCaAfuBFZRwG+fQrx9UAxJpw5Jw48o1YSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gb5h/tX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gb5h/tX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05C51F000E9;
	Wed,  2 Sep 2026 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365009;
	bh=uWMX8nK1sTwEnftW8ux1m95G1IaWAidfgW3CMojm9q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gb5h/tX0phK0tv+aJP1VqNeiPlaBns8pkcFVXHYWUlebKxGS+kMW3MJRKdwL/+Hls
	 2Cfumqw9gGB9SIxENzJoaKbGIlV943tqgWF1TRdZeRnnYSgAaq4DA043SJzvddjrQj
	 jMZPby5LTcl9YQ2Y1zgLoWR5zVMm7l1KHPWN3liQ/b8ZUfD5/LDBj7oxHdzkCAUKTu
	 4Uhp1sqntP9CQe2w2WJoYOkxqcmjcy7Dx/d/tPO0BUsygG6FHlFmXnVWlyE2PTocsf
	 8okJtrxw/usMyJBEz9JnFpB3IfGS/gNhet9pIJogHdtHuVWkxvesfpB6FTOJb4PFLR
	 ypIR5YPB8Nw4A==
Date: Wed, 2 Sep 2026 18:03:11 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org, 
	andersson@kernel.org, konradybcio@kernel.org, James.Bottomley@hansenpartnership.com, 
	mkp@kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V1 2/2] arm64: dts: qcom: Set specified gear
 configuration for Hamoa
Message-ID: <td4esbrt5b24rypdjauneraaeqo6p4ewwgmf3po7mvzzv745wy@3jnxzqi5jiey>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-3-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260829074355.946543-3-nitin.rawat@oss.qualcomm.com>

On Sat, Aug 29, 2026 at 01:13:55PM +0530, Nitin Rawat wrote:
> Assign the appropriate UFS HS gear speed levels to each OPP frequency
> entry in the device tree, enabling proper per-frequency gear
> scaling (G1 at 75MHz, G3 at 150MHz, G5 at 300MHz).
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
