Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C61A3166
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759940183; cv=none; b=BgUQgRhN2wOIcOim2+ButBNRwymrvGO/LG0NUOEZxClRLnc6BGqrMTpPLhFF8IlpH81z1GZq6GqoEEPI1UwgUZ61XbcaE1z7fg4bWgYoSNpM7fpJYMWagW9bDbK/wiyjppFYUItF9PqFr+5asv5jFNm+7O+9L96TGlLKterShhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759940183; c=relaxed/simple;
	bh=kBop869ILNKe1Vs0yODLOvFnk6j0t2FjwHWSyU4Spbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ulXkijfcL+wixzlG3vsTU9wsQZhBtSmMWDcnhA8qjlWhtpn451fQQ0EeJINg1DCLss+oT6ARBSGLTagcVvnjSKWf2oxTdBhxEhTEXGo7aCoq9b5KFco30acSyzHUXs2bcMlI3mwsm8mvdg2OeAqZAqm44CPbxm3IpyZWfMJL37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k8ZsGfUf; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k8ZsGfUf"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4chdRM4Mrlzm0ytD;
	Wed,  8 Oct 2025 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759940172; x=1762532173; bh=kBop869ILNKe1Vs0yODLOvFn
	k6j0t2FjwHWSyU4Spbw=; b=k8ZsGfUfn6xjR9f0L4rLvgW0G/60DXx24UxCQ0bg
	3MVfdQLh1RK3lQivHEYCGCGol2R6/0YM3KVG6q1OHNCaN0MuTXDCsg3kc/RiDov8
	PqEcvtb4I/5lVTuLwgp9gKxHGRyy6eb/tcn1W9s+wLyI41iMNPd6/2FzOW+kzw0V
	2dKFd3kG8Z6WDzHlbMEvjYWusBtugzdH6airnDAYy2dmXwOlfAc/q5KErO+mjsRo
	FY/+7yGdNsMsnaGQanqQSu1y62CezKv2ojcteiFN2QO1Wks6ohHxdafKR9L6P/OH
	GMaGv0UyYnN/Py7DrCVnKUgzS+31Qh4Gl6qyMj1zvmWTgA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eAKCqr_Msxv8; Wed,  8 Oct 2025 16:16:12 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4chdR44rrXzm16kk;
	Wed,  8 Oct 2025 16:15:59 +0000 (UTC)
Message-ID: <c1f86c8b-3a09-4fed-9c7e-fdb26a4cbfdb@acm.org>
Date: Wed, 8 Oct 2025 09:15:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Enhance UFS Mediatek Driver
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
 <Chun-hung.Wu@mediatek.com>, =?UTF-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
 <Yi-fan.Peng@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
 <e818d9ef6f5625de02330a6a92a2ab2b77229c87.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e818d9ef6f5625de02330a6a92a2ab2b77229c87.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/8/25 12:31 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Just a gentle ping to consider merging this patch series.

We are in the middle of the merge window. Please rebase, retest and
repost this patch series after the merge window has closed (next
Monday?).

Thanks,

Bart.
