Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794260538;
	b=iBT1/CNog2P3CSKm183aXgWb48mOToorCurllMvpJGdAmXpGuzLbXNxjZliXsZoA/O0R
	 eQXzmTVBo7BTeSah0VK9cl2G6GSPwvv9GY4uKb0F9Aq4oo2KfmYQlvLy0lD2emNZ0I9Kb
	 5DpoTSsK8hqA+zNp2J8C84ZWQyKBmmRgr1jomPEVO+H2eQMG5SvFJThZ10Y8ljBuD2MJd
	 DD3gc55RMsOoydRPYskpsHPSmeV3DH7Fcu0IDVICYEhrIAgdXDOCmoJwJ6fxdBGPK1CCO
	 xXMm872EH1Wv64Y8Zx5NWHKDxtyfLkCLkyDORYe9qHyrPU0RQKPbatm35epuSz/F6/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260538;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Zy4UuoFBueAx92pWEU3ihUrngaeQDz2jIl4FOkbivHA=;
	b=NjfNrX7/WLl2goSrtyfXY8qoeR5uTcM/IWz1kZ9O07nJSeNI73Ke2JfRsgPIo/N1/7A1
	 +3TdopdxXnE/gF3xRyjX2DXB4//RNdSA/g/8Lu+SIVlMuBb/8eNd0F+D4Eovf8E9bm2ky
	 wr+sSoj7SUYyLiMnGdYb0qUGafr6pzaqW0/BJy0IUWcq9BkHbMH9LQqyq4oxzq5AieFng
	 xpLWs4brmFtOHawXI1pMCynDqpo1CzNbDAuBoALx6MwxQhRueUbdsumqr9soX35WE5SMK
	 uXsW3vbb3IAjgGUBZ8FBnMMn8P1i7m9TwB/OWzM9TTPj1MTzwNIZ0k7t5O2yZMffTdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cq1I4j7p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE04B606A31C;
	Mon,  9 Nov 2026 21:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cq1I4j7p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AFA1F0089F;
	Mon,  9 Nov 2026 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794260537;
	bh=Zy4UuoFBueAx92pWEU3ihUrngaeQDz2jIl4FOkbivHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cq1I4j7p9kn2a3YkfPnya0qAcRzUYH3PJ6quUDgY5Thpo4HrfbWUNZFercIbJM3dY
	 +O/I8tXwzBowbOdunSKvOjdq7CwzyUQw+nL0zm2hkZSkSEnssbJhi5BEYzSqXD0/Ag
	 xUWo2vXqPbl/AP7A9rJZeBsjls9/mfr+mHe7EFmydgvf4AIzjvdZKiToBpURj39c7Q
	 mhJJWAeqvY2vBq3whLVINqrdv0pnE67vdtHGy08rMoxJEMbtJxH46OtYQNMYmmOsd5
	 UqgOxhG09bFuq8oKAWLzfB8xq4twIxpBkGsIvD0RYupFYonKgbD5Y2BSqYLmQtW6Lt
	 NuByUpgcET7qQ==
Message-ID: <52f8c2d3-de0a-492e-89c0-f33487a97dc8@kernel.org>
Date: Mon, 9 Nov 2026 22:42:07 +0100
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
To: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
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
 <4e82a4bf-e2db-4a3b-bebd-9f9c473817a3@kernel.org>
 <17b24b80-c3bb-40a1-ad12-06242ca09c22@oss.nxp.com>
 <0820de78-679a-45c2-baf1-2905490ea926@kernel.org>
 <02fb96e2-391f-4fc3-8d41-ab8364a9b07b@oss.nxp.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <02fb96e2-391f-4fc3-8d41-ab8364a9b07b@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/11/2026 21:47, Larisa Ileana Grigore wrote:
> On 11/5/2026 8:28 PM, Krzysztof Kozlowski wrote:
>> On 04/11/2026 10:41, Larisa Ileana Grigore wrote:
>>> On 11/4/2026 10:40 AM, Krzysztof Kozlowski wrote:
>>> v8:
>>> https://lore.kernel.org/all/20261013103003.373156-1-larisa.grigore@oss.nxp.com/
>>> v9:
>>> https://lore.kernel.org/all/20261024122533.3609180-1-larisa.grigore@oss.nxp.com/
>>> v10:
>>> https://lore.kernel.org/all/20261103133215.1385823-1-larisa.grigore@oss.nxp.com
>>>
>>> Regarding your comments on v9:
>>>
>>> Frank's Reviewed-by was given publicly on v8 [1]. The series only looked
>>> like a v1 because of the wrong version number.
>>> The tag ordering was changed in v10 since the patch was changed.
>>> The single 0 Hz OPP entry: as discussed on v8 [2][3], the clock rate is
>>> set outside Linux and is not scaled. The OPP table lets the UFS core
>>
>> That is not the purpose of OPP table. OPP defines performance point.
>> Performance point of 0 makes no sense. You cannot use Linux limitations
>> as reason to add some DTS, because answer is simple: fix your Linux
>> limitations.
>>
> 
> Hi Krzysztof,
> 
> Thanks for the clarification. I understand that an OPP table is not 
> appropriate here.
> 
> Existing platform DTs, such as Hi3660 and MT8195, define freq-table-hz 
> containing only <0 0> pairs. This allows the UFS core to manage clock 
> enable/disable without setting their rates. With freq-table-hz 
> deprecated, there seems to be a gap for this use case, beyond S32N.
> 

Instead of passing 0, properties should be rather missing and that would
be hint for Linux. Is there a difference between missing properties and
some non-valid state (like freq=0)?


Best regards,
Krzysztof
