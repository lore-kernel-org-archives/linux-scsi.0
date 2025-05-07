Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC8728B4FE;
	Wed,  7 May 2025 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746646048; cv=none; b=FVt6lB6LZNE3GO++6oVsR7oBPpCYlhnHESCGwAZx1AhUZzxQVDptJOpcQ8eKA3Dldzv/YB2PVmT8FtWNm7jzObNJuycwNsDgGnszURZ5KB0vsHXWyyl37OZg1WFf51/eU5aBNsIrRPVpp54QiE44xjTCGX11y/gOcmuLRdTNpSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746646048; c=relaxed/simple;
	bh=MevCUtC29kmg79Osqbp+iLHaV5bIefjb1T+Q1ufLpCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MzUSv3yD58yjAOX6lq/kfUJOveMNA4CoGTTE0xzkyqwC2UjxBBZSJT3Cy90cvhT2EnQjKIx9osz8+bTuMOng660w4yk4x+xO44oyWYL3MU5D7KJ3FUc4xl3lhbb5qNHEMV0bJjAMfXXQwb5J1B9SbzRAxltw7l8mxgiTRQQj0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pMTCjJd4; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pMTCjJd4"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Zt4yv2T13zm0yTm;
	Wed,  7 May 2025 19:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746646035; x=1749238036; bh=MevCUtC29kmg79Osqbp+iLHa
	V5bIefjb1T+Q1ufLpCI=; b=pMTCjJd4UP3qHHqV5FR4Dd3wbLC20/Do4ZF3qgu6
	i5Mm+C44DLrlXtwuOiJz1JpwZWRFo6joSytrhNucbIdRj5cuhvoj9DQFWA595Wgi
	6o0Pbg4kv/hMOFWvr0Tlx9vbJ1AEEhO1090Sv/Y/AX76RJnx60EiwMn9QAMHy5Sd
	Q1itCsQmZ1TRBjxblO/upiI93JYb3HPKKh+k11StpAR9rIpVbKaTY2+8L3YCPDTw
	MLqgdb3qsl4IIYo6uzBpj7r+1l/kQFISbxyqTU2F+A8BawNFmn05RQs1wbW5AfhT
	oE9E9E+984O0/GoAfAOJHxfQG2d4yVFSZBfETdpYdCITOQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JAJxBvassQb1; Wed,  7 May 2025 19:27:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Zt4yT3vTKzm0yTR;
	Wed,  7 May 2025 19:26:55 +0000 (UTC)
Message-ID: <95235015-270d-451e-989c-9fddcbfcb97e@acm.org>
Date: Wed, 7 May 2025 12:26:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix hwq_id type and value
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
Cc: =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>, =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
 <Lin.Gui@mediatek.com>, =?UTF-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
 <Yi-fan.Peng@mediatek.com>, =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
 <jiajie.hao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
 <Alice.Chao@mediatek.com>, =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
 <Ed.Tsai@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20250506124038.4071609-1-peter.wang@mediatek.com>
 <04fc1549-0fa6-4956-b522-df5fbc26100c@acm.org>
 <6c9e983154ff8d9b4a1e63eb503e8b147303eb68.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6c9e983154ff8d9b4a1e63eb503e8b147303eb68.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/6/25 9:03 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Whether it is necessary or not depends on how we define 'necessary.'
> If the criterion is simply to avoid errors, then indeed, this patch
> is not necessary. However, if we are addressing the warning caused
> by incorrect behavior (assigning int to u32), then it is necessary
> to fix it. After all, we shouldn't just be satisfied with avoiding
> errors, we should strive to make the Linux kernel as perfect as
> possible, shouldn't we?

Errors? Which errors? Using -1 instead of UINT_MAX is common in C code.
Assigning variables of signed integer type to unsigned variables is also
widespread. Using %d to format a negative number, although dubious, is
also common in C code. Several years ago gcc warned about using %d to
format unsigned integers. That warning was disabled again because there
is too much existing code that follows this practice.

> Additionally, there are many ways to determine whether MCQ is enabled,
> including reading the host capability or checking hba->mcq_enabled,
> etc.
> Moreover, MCQ is not a feature that trun on and off at runtime.
> It is at the end of the UFS initialization that the status of MCQ
> is determined, so it shouldn't be necessary to rely on this to
> determine whether MCQ is enabled, right?

If you want to proceed with this patch, please make it clear in the
patch description that this patch is a behavior change and not a bug
fix.

Thanks,

Bart.
