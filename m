Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416B8231C90;
	Sat,  5 Oct 2024 19:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728155758; cv=none; b=N4XLqnw1ww+Fr6FOJE34PnwhJjffhn5fiKnaOLUccEOY+wAotg06rZ6kN3DktPTtnTj5TxqEIbyRMqgs+kfOxg0g3KuWUSEBi1tXTY7LN799VRQ/OS4dNcY7qHOjnm22IGLxvSvCiegyVjAxDp+s+HMLgLGJtTVPuj/Fm7jh//I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728155758; c=relaxed/simple;
	bh=aLtWSLImy2bvmkbLelAmy8F1uAkKcXUzBjznT/XUhQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CntaQ4JB+b5Odj6hC2HLdQ+bkWcgEiriS7RixLHZkREzOpXqM8rfqmI+Q+B7gU910hlgfBjx+Plfl05MeokgNUquxlvlZjUYYwKVFGrqt4Opa7yntbFUmz/2qbRKaKhgs6qT43BHfzrqYMwUr6A8f8gjilAyW9YEqvrMKZXrIFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o47rv0+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o47rv0+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A944C4CEC2;
	Sat,  5 Oct 2024 19:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728155757;
	bh=aLtWSLImy2bvmkbLelAmy8F1uAkKcXUzBjznT/XUhQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o47rv0+QKugV04q4LlL9Kq8m8OlDpfIK1+c+chLdb4DL6Or/RkPHm3ahs9dVE6WSI
	 D1a23P0iLAUqpHYhR7x9lg9/xDc5aO+c/8qphBJXS4NSemym1NlfuycvM7yJlWd1q0
	 W2cdFVuxChh9YCeA0telEh9Lx6aUXx9Ax3wwMqLfpdAnxW/VpAQ3lIHAomOhsxpSre
	 EuES5Uw7uNzeZLt13GIwzER+xksi17TTC2xFdVgo00zEbVfVHHuozxAqHCTx7ZGxpT
	 bregS5Pb2CQHdtI4L4AhKfT8X18l5DXNoxWU3U1n7VgK0dZNwWi+Feh5GHsqTzr8UT
	 DFFUxfgm07Wew==
Date: Sat, 5 Oct 2024 12:15:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: manivannan.sadhasivam@linaro.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, andersson@kernel.org,
	konrad.dybcio@linaro.org, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, agross@kernel.org,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_narepall@quicinc.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH V1 1/3] dt-bindings: ufs: qcom: Document ice
 configuration table
Message-ID: <20241005191555.GA10813@sol.localdomain>
References: <20241005064307.18972-1-quic_rdwivedi@quicinc.com>
 <20241005064307.18972-2-quic_rdwivedi@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005064307.18972-2-quic_rdwivedi@quicinc.com>

On Sat, Oct 05, 2024 at 12:13:05PM +0530, Ram Kumar Dwivedi wrote:
> There are three algorithms supported for inline crypto engine:
> Floor based, Static and Instantaneous algorithm.

No.  The algorithms supported by ICE are AES-XTS, AES-ECB, AES-CBC, etc.  So I'm
afraid this terminology is already taken.

This new thing seems to be about how work is distributed among different
hardware cores, so calling these "ICE schedulers" or something might make sense.

- Eric
