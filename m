Received: from mail-m32121.qiye.163.com (mail-m32121.qiye.163.com [220.197.32.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CDB31F994;
	Wed, 11 Mar 2026 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773236201; cv=none; b=Er7SPHZj0RCc2VSjiZ5QbR/+mkhAbWw4FLKvlrklKW8RW0LT32fPB7DDbSajnjmshyu8EcXuAKZiVd/VISNSEThnyis6M3w3CGVWb0YixTBMRlBFxqbfcB7y3vqOzLTUlIFD0oXeoTt24vk5sPt/9OS3rcmUrkHy1M4NeOBaK/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773236201; c=relaxed/simple;
	bh=QyjAQVTIOPnkchNcPNron97S1VEpxL4vtqkhK+YpjuU=;
	h=Cc:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Vbk7seGXVolZmkDBd+KQyTSKlXUY4wy31bWX9j3lJ6Hw8G3E8iJ3EuuvG6n/1+jCSl2jduIadvYDjC0LVqocu6VpXeBNj7EAuHMBQvpwJtOKZYEkhJdopfUab6yzSrJK8mYeN+4Cg2DdTM0fWf/+LnyqYJbJ8yEQ8k/L1qAme0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=BWNzzvbm; arc=none smtp.client-ip=220.197.32.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="BWNzzvbm"
Received: from [172.16.12.17] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3692ae640;
	Wed, 11 Mar 2026 21:36:28 +0800 (GMT+08:00)
Cc: shawn.lin@rock-chips.com,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, devicetree@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: dts: rockchip: Add mphy reset to ufshc node
To: Krzysztof Kozlowski <krzk@kernel.org>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
 <1773193218-215988-3-git-send-email-shawn.lin@rock-chips.com>
 <20260311-rich-colorful-vicugna-abb4f7@quoll>
From: Shawn Lin <shawn.lin@rock-chips.com>
Message-ID: <83c2b26c-cee9-9109-3bb1-e053b72040cc@rock-chips.com>
Date: Wed, 11 Mar 2026 21:36:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260311-rich-colorful-vicugna-abb4f7@quoll>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9cdd1cf65509cckunmceb236d4132ca
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQh5KGlZCHR0ZSU0fGh4YGE5WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=BWNzzvbmw27eTxI+XjnJ44RxoO8/XHFeD2qLW3ckWP08HqkTvgZLa+MuRhYw8LOUx5zhjkibwNHLJZL14w1bENhZWUnPPP+zXl+YUCt+vWHnmWkcfwc9hbjc/b3EYwdls24KB2gU68i1RVqJRgAvdpE/g+EzyGCrqlj9ud1z0j4=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=pUA5wRzeY6t+IotBZS1hhgdRzPTcvIZMRhCj0BXlp04=;
	h=date:mime-version:subject:message-id:from;

在 2026/03/11 星期三 21:11, Krzysztof Kozlowski 写道:
> On Wed, Mar 11, 2026 at 09:40:18AM +0800, Shawn Lin wrote:
>> Add mphy reset to ufshc node to fully reset the whole UFS blocks
>> if needed. Otherwise, it may occasionally prevent the UFS controller
>> from successfully linking up with the device.
>>
>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>> ---
>>
> 
> You must not combine DTS changes with patchset targetting SCSI/UFS,
> because they apply entire set and this DTS CANNOT go there.
> 

Well, I was thinking that dt-bingdings will go via UFS tree but DTS is
picked up via rockchip tree. Combine them together is easy for folks to
reviewed. Will send them separately.

> NAK
> 
> Best regards,
> Krzysztof
> 
> 
