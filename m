Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781513;
	b=bROgGtgDZE5l9sptGSSVsAGw8gSHi+UpBzufSfJxpyt5e0wKpJjM4b0tj6PQdIcCcaVC
	 aXvhukJR74Ic0ranQwqQxCUlG2gVLXQIwNwfdIqt7Z0Zwv+YC/xLEU1HpF6verSk1qnl3
	 3mfDgMy0po5w2qCh3b4qpBUFRVu3yT2wBYS41ZO9YzliKiQfL/UWq5mhf2lNpLLT9vZ3p
	 lKsB7PGrEuKTfIOpJZgFUTKfaIK1HUCPWDH+d06omwvB024VByae5F+5lOlFxiC5wSgo1
	 jk/qPqU9RQ5MM6mpFJr4txi+RnYdUQcoSshKC/oQ86mpxAWCtvI7NhwIn4hYGfaGZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781513;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=q22aHIIUbJVPLfqhclV4r9PQqlG7bSyft34WDd0FFLA=;
	b=QsQZtK4G7EMFSzlFllDZHIHj0MCAbGFwbGU548Mi+wsbgx8shjcuKRyRJmhf6t9s/CKt
	 C6eOeJ4zcFoDiP98Dqy1BCBZyF72AcZssmkvG/llte49p7S3BlSSjsva3ig7TxSgkKdsA
	 Z2ygYpM4SfXqrapMpjVl70zrn5NHAyieFDhTDLc9507mNcRT8/ueIzqEZKhB/Mn+pH8Me
	 w30JF0rB148NRb0DqzeiACcq6bCMWSUCisj5HgjAVR06zh9E+DQPLjWcl356rDLlMdRQk
	 M8k85rhCKPZOaDXDteTIGJYuHd8/Kew+daKH/c7oAfRfB0l6eHMM7Ndl9VFqm+KO/LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V+Iwv0f1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711B0606A31B;
	Wed,  4 Nov 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V+Iwv0f1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52201F000C1;
	Wed,  4 Nov 2026 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781512;
	bh=q22aHIIUbJVPLfqhclV4r9PQqlG7bSyft34WDd0FFLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V+Iwv0f1902KtZ6agV1pPHZ47f4xCxgMvDc/G0u4V3Ekt6WyR0be8FNoIXB7f/nnw
	 ycr3UTbJVqid1VhekrboxHhdFIL6JpKaMGRFMRM3Y9dcqH1bzpuB2gDkFU22E5vJAD
	 WJyxQtVd56wGyg+44CefZfbDQ0NxZQyrcAgf0tKqonllUCvNTOMkSDWr3G3KwbLQOb
	 3w9cX2kHAP5hViO86HsDUYv5J1vkWxNzRU3Ir5wkimBYPr8DBOX8u+NMD6sLr8UZ+h
	 pr09xc//7Pucl5bCiL5tl06JbiK4jc7gtou9rsE5N5jxm2yoOlCQGSAl1wnvTU3dQ2
	 +eEsnSs6MBH1A==
Date: Wed, 4 Nov 2026 09:38:29 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
	Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	Pedro Sousa <pedrom.sousa@synopsys.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Can Guo <quic_cang@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>, imx@lists.linux.dev, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com, 
	echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v10 08/11] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <20261104-holistic-loon-of-agreement-db7b8f@quoll>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>

On Tue, Nov 03, 2026 at 02:32:12PM +0100, Larisa Grigore wrote:
> Document the UFS host controller on the NXP S32N79 SoC.
> 
> The S32N79 M-PHY has two data lanes per direction and the driver programs
> both of them, so restrict lanes-per-direction to 2.
> 
> The UFS core manages only the clocks added by the platform glue. Since
> freq-table-hz is deprecated, the binding requires operating-points-v2 and
> clock-names. As S32N79 does not scale the UFS clock, the OPP table contains
> a single 0 Hz entry, which keeps the provider-configured rate while
> allowing the clock to be enabled and gated.
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>

No lore links in the changelog and b4 diff:

b4 diff '20261103133215.1385823-1-larisa.grigore@oss.nxp.com'
Looking up 20261103133215.1385823-1-larisa.grigore@oss.nxp.com
Checking for older revisions
Grabbing search results from lore.kernel.org
---
Analyzing 91 messages in the thread
Could not find lower series to compare against.

Is NXP going to switch to b4 or not? How many times this can be raised?

Sure, you do not have to switch, but then why is `b4 diff` not working
on your patchset?

Dropping from DT patchwork.

Best regards,
Krzysztof

