Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781627;
	b=JfmCOkZ7RoVURm29a9mlBfG3F96Bluhlz5c9mXoKpjQLfJs+n9YNUY/yQicBFLzRMGM3
	 j13/QEAMp9F+XXmfgMgGp9dIIQ0rczgWMQ7ypEEhUa6onesoQvTqK7qJVN8T3M7MRrtYt
	 tm1fJAuh9UX6vjf3MWSH6/a6mjBl/OaDmpIIJPZHow8doQgfhwzn718m7xtrP0JuE68iw
	 A3sDz749hY0cnS0HAjafRjk+YZtRZt3n+428jVRi5YdX1K1Vf7z5cXhvWh8WGJx/S18lH
	 i114IjNYQw/CmQWHCY3XcWl7K5cBUh4uYviN25BS9Zxqfegj7NaZLtNZx3wq4ocvSAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781627;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=kIwvQ2m8FTrcE+WK6Tj33njxckk9WhiI+63CgTuoiYk=;
	b=A+t88y3INNfeWehHDsbmNZc4+UZCqgfMbpu+bZdV2qmGdhZ7WLATmX7/NVe3OmFj7TIf
	 HIwCdxdmFHW0EIBM+n7HjaolK6I2IitDZezhOa/SaE4kMHzKC8sI3CGjD1gaPEmn1oFSw
	 wEvEEgAVEQn4VF9bH8LT+v+Cwjijyhb1wZQ48P7q5Bo4kL1bOnp5kmFpumWiWTswkzwdT
	 7Cn90NieZYjmMjK3NnEksxf18apyQo4qTn3BBwHHnyA2Wyy44Otxk213T+QFpVKI0PJuC
	 KeMDuOIVVtdxn+8JdgS/JSQTy5O83asXwX/lf6rspdS8ol+xPREjGuZXb6q01TsxvEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dl69mSdM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860E606A31B;
	Wed,  4 Nov 2026 08:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dl69mSdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AB91F000C1;
	Wed,  4 Nov 2026 08:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781627;
	bh=kIwvQ2m8FTrcE+WK6Tj33njxckk9WhiI+63CgTuoiYk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=Dl69mSdM8swdb8mVO3AyJaxzL/zQM3dwOAwGlllxEOjjCLvcTmB7j/+gRz7cW2oan
	 KUSqia84w/Oe9qo6nUrLcUMOOEcDiIfZEgBv4k/+Cy2fpWATz8hfd2e1g2OL9mZROR
	 V4OVWa4MtqdlWtv3CJBPPBS66NKa9Tmiq7W76WfBdYFruWshfz7KiXLwAN0VzB7v04
	 gbj06HzuU1dxPqMdFxxbeVcZ7jPK5vFNvGAnfGon6IsCc+sG1dQoeiJXzSnGiVH+QP
	 TZO14nSYo26b2tnBShgiVdDkfW3b8ayn4bwnoAy+lmPEkrZuLexTAygNu01bXTk9yg
	 ZKhF4XyvuPD0A==
Message-ID: <4e82a4bf-e2db-4a3b-bebd-9f9c473817a3@kernel.org>
Date: Wed, 4 Nov 2026 09:40:15 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/11] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>, imx@lists.linux.dev,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
 echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>
 <20261104-holistic-loon-of-agreement-db7b8f@quoll>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20261104-holistic-loon-of-agreement-db7b8f@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/11/2026 09:38, Krzysztof Kozlowski wrote:
> On Tue, Nov 03, 2026 at 02:32:12PM +0100, Larisa Grigore wrote:
>> Document the UFS host controller on the NXP S32N79 SoC.
>>
>> The S32N79 M-PHY has two data lanes per direction and the driver programs
>> both of them, so restrict lanes-per-direction to 2.
>>
>> The UFS core manages only the clocks added by the platform glue. Since
>> freq-table-hz is deprecated, the binding requires operating-points-v2 and
>> clock-names. As S32N79 does not scale the UFS clock, the OPP table contains
>> a single 0 Hz entry, which keeps the provider-configured rate while
>> allowing the clock to be enabled and gated.
>>
>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> 
> No lore links in the changelog and b4 diff:
> 
> b4 diff '20261103133215.1385823-1-larisa.grigore@oss.nxp.com'
> Looking up 20261103133215.1385823-1-larisa.grigore@oss.nxp.com
> Checking for older revisions
> Grabbing search results from lore.kernel.org
> ---
> Analyzing 91 messages in the thread
> Could not find lower series to compare against.
> 
> Is NXP going to switch to b4 or not? How many times this can be raised?
> 
> Sure, you do not have to switch, but then why is `b4 diff` not working
> on your patchset?
> 
> Dropping from DT patchwork.

Ah, found now v8 and previous feedback was not responded to, nor addressed.

Best regards,
Krzysztof
