Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115B535B120
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152357; cv=none; b=cccRpAL2ytYqxxOpKupZyZ5y7aqEFAYwc2d2BHhNb3nop+AbtUKL695i9dsqRYmsscQcA1jsXwSruWtTBbqRPa9cw2/Q/taiSv1WrPtEXHFZtDIkOH4BmM80AaDA1eqgENTJHeNWgz+cnNrbw5AH3M/TPNgl1MtX/LbfJPhItpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152357; c=relaxed/simple;
	bh=lmxq7bxjADToPnic/Cq1UBRrY/417IuYkAMY0gBOCeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rz62JiAwpVbdv8TYnyv0EIoz9Rb3M9mIsw5iZxNb3fV2p7Kqcldv2Vj7q6XwJAAqNuxi6e+Qlpm4O3Ix1HDFfwaxZ5BQmmz/MmZKpFeHML9esvEyyHnch+sWQW9jvLcjnnhD1XqLhoAsXYDYatQP7vR3qOoa5m5EUl+M6IWariw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xcAn2onK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xcAn2onK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4csFkT6y6XzlgqW1;
	Wed, 22 Oct 2025 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761152353; x=1763744354; bh=yUjy9DFkUcOIRYRY05K4wl7j
	z0d1vgGVT7tkuAcMYrE=; b=xcAn2onKZ+enCWChLV8ndjkDmZIq1jcFW12GJ5Wn
	e+HTRvfKpMgLs1+rv3151zpXlDsYgInsWO4HBnAgta0T2FVWhZwwN8f155aawCSy
	sA/hbVdxYJZF24nB/ZkYVmtF4ChweuY1GrHecmm+SHOxWYy7cfuFlqTovLC8Uabu
	B1hoghkh/xaxLnElx7iZ9aYUnrEaxA8mSbKe4amcmU3yZw4p5Z7tx5oPTAztrOon
	w1LsWI9HuRvKigdUWl0BozIx08Z1DKWlLJHeFHDGEgdkYTVe8iBrgcpcS7Y0gW1U
	cXf4ardaQqzjofpC525i2tOKkDdMkyWsHMMFf4G71kdEvQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BznWmFVMRcRC; Wed, 22 Oct 2025 16:59:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4csFkR35ykzlgqVJ;
	Wed, 22 Oct 2025 16:59:10 +0000 (UTC)
Message-ID: <f761feb4-6b58-4778-9417-067993a484fd@acm.org>
Date: Wed, 22 Oct 2025 09:59:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Eight small UFS patches
To: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
 <ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 4:04 AM, Manivannan Sadhasivam wrote:
> On Tue, Oct 21, 2025 at 10:13:39PM -0400, Martin K. Petersen wrote:
>>> This patch series includes two bug fixes for this development cycle
>>> and six small patches that are intended for the next merge window. If
>>> applying the first two patches only during the current development
>>> cycle would be inconvenient, postponing all patches until the next
>>> merge window is fine with me.
>>>
>>> Please consider including these patches in the upstream kernel.
>>
>> Applied to 6.19/scsi-staging, thanks!
> 
> Martin, could you please apply the first two patches to scsi-fixes? They are
> fixing bugs introduced in v6.18-rc1.

I'm not sure that's the best approach. The more patches that are moved
from scsi-staging into scsi-fixes, the more likely it becomes that Linus
will have to resolve a merge conflict during the next merge window.

Thanks,

Bart.
