Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FAC3563F7;
	Tue, 27 Jan 2026 19:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769541106; cv=none; b=fg5Xc5+pve0FZpN9YSIMoTSkP+4i2Mj2X6qOl+TxT2W5gOzWZ4HsjgoJxJCFvgbrebZyzgEhsqTw6xO1PZmIKyDKwFJCxhDQ5zAZTI7G8BlH8bFDbZmHtOgdmsbofrMx2hzrzUs+wf/v0gtAT4WbCUJ9xxLGODfvCODiJb67xrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769541106; c=relaxed/simple;
	bh=DUMJe/VxGA+6yV8AzRB+ip/UczIzPN0SiwsyJmHnyns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naaPLAe7Cy5UbBvAIprMAasod9vO3lEn/U6w3TfEqvbDBPM3rLn5ll3Q0H+tTqK8/PSXrMT6Un/1HIK5NQAjs48weUaLiHo+wjpIpKRqaFy1KxyR3AON5fyk/XlbxjeG+gQ5ElFX9ZmVA7CuW6HOTeI/csKkCZ3pkVoIgww6btQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VX3cQvzX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VX3cQvzX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f0w4P3Vj4z1XLwWq;
	Tue, 27 Jan 2026 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769541091; x=1772133092; bh=/Nelkyz1DwIXiGdmAwkkHf/1
	f9ijeOdEKCLoXCN3G+M=; b=VX3cQvzXloGUZCdvcYCnkOqyMZ1JbJpoNhMNSk45
	zGTbleVrPtQFz1KO7XlJC0rXsBTPbxQpGkg9KqI9ASKQNOwyr0zQI9I2kGAk/gWQ
	6Nn+2H9bos6FHKvDYTHsdSp8iRXxFdgRbYCNDmtN8Z4itKiMKVAxgsM5bett+MYA
	ARk/sTpieRpDybGN9uoJby4Z6mWpvsKZqIdI8CKPsI3hEYnSNKEO7hf3JG5vGdal
	z+CG2cxPvxyPO4uwevRmtyeAaBfI9k/IIhekTdkyCM8PmaSefcR4niEwYiyUKfXD
	/+M67wedPrmQ8U9nxe32XK1/PDrzdX2mXIL6rJP11bgzHA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0hSH0Or-G6py; Tue, 27 Jan 2026 19:11:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f0w4L2p2jz1XLyhf;
	Tue, 27 Jan 2026 19:11:30 +0000 (UTC)
Message-ID: <6d648dab-fe05-437e-be25-6c026302322e@acm.org>
Date: Tue, 27 Jan 2026 11:11:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Block storage copy offloading
To: Viacheslav Dubeyko <slava@dubeyko.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, Jaegeuk Kim <jaegeuk@kernel.org>
References: <0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org>
 <eab078c99e17e45632c6b35e2fe1145e9459ff2f.camel@dubeyko.com>
 <5273400e-5cf8-4d70-a85d-accfb2977d8e@acm.org>
 <fcd8fae5950ea5888eab5279fa3ebcad1d27bfa4.camel@dubeyko.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fcd8fae5950ea5888eab5279fa3ebcad1d27bfa4.camel@dubeyko.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/26 10:03 AM, Viacheslav Dubeyko wrote:
> So, frankly speaking, currently, I don't see the generic technique that
> can work for all LFS file systems.
If I change my topic proposal such that it says "some LFS can benefit 
from copy offloading" instead of "all LFS can benefit from copy
offloading", is that sufficient to agree?

Thanks,

Bart.
