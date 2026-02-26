Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E28D34CDD;
	Thu, 26 Feb 2026 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772102739; cv=none; b=C931bwqxKLrYgrO1LP92VSQSxtTzvCHXPavpWTSoOfbJw+0Y1dvg8rN0lx5x0a+7f/OC1Q3DB+1S54fHyfOhFrVk1GyvE7Vbn4ZMQM37TowotdlMgIc+dM+Kmn1QB4tGu+SlygJ8GzWhwAOmchbz1lQNZBKJbo2zqRj66hRKimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772102739; c=relaxed/simple;
	bh=6YFT7Dv9/RPthcEUnhhwy5zDoUaHap7U9kpRpUeIPV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOTRc2gOfVbwq9bqrcug3DkPE6kdcxnVS1VLXEt5WSjYUGDpzPk5ycYtZYNQcgV9CYVXVnn0Wk6/B2F2pmAJWQti/76kd7mfATYesPIhiMhH00KRs6bGjd/TJd0caaCX5qWfnWnalhL70Ih9XbLGI2TV+fQJ5brcyXRaJncussU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=aOKhl1gY; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="aOKhl1gY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772102736;
	bh=6YFT7Dv9/RPthcEUnhhwy5zDoUaHap7U9kpRpUeIPV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aOKhl1gYmC58Q5XnPaaVFV4AX+HRZb/FaZT8kvMrbAX4ocU8UvOwkOrmxuMbZExjm
	 q/5pxtHOPqwZtl4qTw/eJkvwmwu5Yj9BE8qGvk6kr1AVqhRzDERERpxn0XgjJTSvtj
	 wPWqCgfmYc2RdUxfhGerzWAUOPfTrzvqV1AHbpTXLngoKvpWhap3qPd5vgpOjw+QmD
	 jnx5GXl85lesOX+SfuCKuFHcINonNKENolDlEjaEzUzEdf6A2Y+z2QRqnjOM6Ck3Ao
	 xcyP/cF9XTE1tbDfDSOKNbv0yQ8lZjCVnr0uv25vTWPWTLA0Vw3Efc6/I3SM5fQhuC
	 zmAai5oTQnjcg==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6C83017E0029;
	Thu, 26 Feb 2026 11:45:35 +0100 (CET)
Message-ID: <84f22f00-e3eb-4ea5-999e-260c81f29338@collabora.com>
Date: Thu, 26 Feb 2026 11:45:34 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
 <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
 <2575185.irdbgypaU6@workhorse>
 <f0e97a38-a11b-4e69-902a-e0ccd0dc4540@collabora.com>
 <259b24885e5e721ae562d27dd761b02e6a68c971.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <259b24885e5e721ae562d27dd761b02e6a68c971.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 26/02/26 08:00, Peter Wang (王信友) ha scritto:
> On Wed, 2026-02-25 at 14:18 +0100, AngeloGioacchino Del Regno wrote:
>>> Depends on your view of what's useful information for the user.
>>>
>>> I can change both of these back to _info if I have to send out a
>>> next
>>> revision, just to get this through though.
>>>
>>
>> Definitely don't change that back to dev_info() as this is debugging
>> information
>> that spams the kernel log for no reason.
>>
>> This has to be dev_dbg().
>>
>> Regards,
>> Angelo
>>
>>>
> 
> Hi AngeloGioacchino, Nicolas,
> 
> At least, "device reset done" is important information that
> users would care about, and it should not spam the kernel log.
> You wouldn't expect device resets to occur repeatedly, would you?
> 

Sorry Peter, but I'd argue that the users don't care about how much and when
their UFS device resets. Users just want to use a device, without caring
about any implementation detail.
The spirit is: "radio silence as long as everything works good".

Power users might want to check the kernel log in a problematic scenario to
seek for a message that says that "something went horribly wrong", but other
than developers, nobody cares about when UFS resets.

 From a developer standpoint, I do agree with you in that we do *not* want to
see device resets occurring repeatedly, but we're talking about a user here.

See it like this... imagine if all of the device drivers in the Linux kernel
would say "device reset done": how many devices are present in one SoC (of
course, ignoring subdevices on a board)?

Of all those many devices, if all of them would print a message saying that
their reset is done (and operation is ok), the kernel log would get quite a
bit clogged, you'd need to have a bigger RAM carveout just for .. well, the
kernel log itself, and then you'd have to grep the log, hoping to find the
one single line that helps you finding an issue that you're having.

This is the reason why keeping any message that is not exactly a *single*
indication of an error (so, an actual issue) as a dev_dbg() is a sensible
thing to do (and of course, with dynamic debug in the kernel, you can always
activate that on-the-fly without recompiling to verify functionality should
you have any immediate doubt).

So while I agree about your reasons, I very strongly disagree about having
this message as a dev_info(), nor anything else that is not dev_dbg() really.

Regards,
Angelo

> Thanks
> Peter
> 

