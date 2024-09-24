Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFD8282F4
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727206618; cv=none; b=UbGgpT2Hr4cwOMx/kqYMmDFKmQE49A0JhivFdtUMchK00K2A/k3gKbPi8FPfBURIjDxkxwXUzWXicAHsMNfU/ddmKiLONMtkEpht6t9GBOZ7RODh8vGul+4OSE/d3exp2ZKEP/2+cahgdsnlMd5HrZ4ED7z5eQ8jxxuz1LPbHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727206618; c=relaxed/simple;
	bh=p3Fn0DiLqZBZx/Wn08nGpoiQ7ur/I7xHuyP6dZ9gpLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=It3zJZTkzLJA9DtVYBFJumn1fZcuslWJC/mEma1/birFcfZWWyvmcOo995nzTHXpfYIkQ7Bpnjf37qcLNWHx/WLsmoKB7Dl5AJgh4vYf6+YpTnU3f0/P3Nh82zs7AAjHw9PaS3AXtMh2d+WpC4dpMYARGv8aa+ja3U/YAkOO6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rLtHIAxF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rLtHIAxF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XCqqr1Nkcz6ClY9Z;
	Tue, 24 Sep 2024 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727206609; x=1729798610; bh=p3Fn0DiLqZBZx/Wn08nGpoiQ
	7ur/I7xHuyP6dZ9gpLs=; b=rLtHIAxFCGzBjKo8BT2UXNsRETVOHjwlxXV6xB5C
	q64VDh3WbaYokkl3MprmQFWqYCJseVu5PQV91zKDg+SWMp3XtGX66jOpdnltDDMg
	DNuaWPtCph6OypkL4H8sPgT05MdgkPK/cylLjFFtOCb4vMqHRPHcQc4HaPlP69kc
	mOSOrRnZ7W7bW2ZNjGwAiSHMrORoCWRHP/N7/Py5bOsckWO5VA+duDUsUpeq6a3R
	vaNdovK/FtIKjqwVM5pgiWB/FfSoAghIUDAMXiu+iH981JQ+OViMigN7JpXzgC2n
	o5ghBQpNpHZ6IeHyB2FmGJd0Qa60eA8KR8d0Fq7+7pvqyQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Dr4ojz5uoCJp; Tue, 24 Sep 2024 19:36:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XCqqf1LcPz6ClY9X;
	Tue, 24 Sep 2024 19:36:45 +0000 (UTC)
Message-ID: <fb02d4c2-bb0b-4d26-8d6c-f76f309679a1@acm.org>
Date: Tue, 24 Sep 2024 12:36:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240923080344.19084-1-peter.wang@mediatek.com>
 <20240923080344.19084-4-peter.wang@mediatek.com>
 <ce42d310-2a23-453f-bd14-71eeaf9f5664@acm.org>
 <e0cb5defb8894ea8fb058c617e9de3d3cfa9763f.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e0cb5defb8894ea8fb058c617e9de3d3cfa9763f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/24/24 1:51 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Is there any corner case that I might have overlooked?

Maybe I misunderstood how MediaTek controllers work. Anyway, if a
MediaTek controller reports the completion status OCS_ABORTED, is
there any chance that this status will be reported after
ufshcd_release_scsi_cmd() has been called? Is there any chance that
the controller writing OCS_ABORTED into the status field will race
with the host software overwriting that status field while submitting
a new command?

Thanks,

Bart.

