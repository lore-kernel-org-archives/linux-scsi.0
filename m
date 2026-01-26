Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AF32475CB;
	Mon, 26 Jan 2026 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769454778; cv=none; b=tCE6Db7XB8gd/O0MLYISkCM1ljgvuhZkH3GOxY79tbRJiiJyPIB3RryZucnPlJMsiaBjMTJcZ3HjPjrdBoghjtapUL2zui4S6jPZ0NfF1zsJBeXBOfpQvovdzPyxsl4PDw8k0VWD0keZd9wzl1uI8h41kaMTDkuwXNyReWFzDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769454778; c=relaxed/simple;
	bh=L0UW6hrzAJav4BEvDCb4gbxi00lWcyoTcmwxw8Bcxic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RphQD2L4E2NphHGEepuBCIt5NnoW50KitRnWmtCO28KCYDlH0h12H34N3xzmVEee/sTKcviCjDCPiJhDEeXyuVOwoOHldeYHuS9CAnbksWUOoE0InT6jxCURcdO/a3SI9zyXiAbXzCTH7e0Umyr5MfxgaMuFL2IHyzB5vsASBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x9resg0i; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x9resg0i"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f0J8S1wxMzlh1Sr;
	Mon, 26 Jan 2026 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769454774; x=1772046775; bh=L0UW6hrzAJav4BEvDCb4gbxi
	00lWcyoTcmwxw8Bcxic=; b=x9resg0iOiWbYn2mxnm98i5bEHONSybLK2oB8a1T
	SRjspSI2/X14fh0ao0snL5N/804jAse8Ve37KaTm2oNi8/TZ9pqll+JI+eQ8xISH
	H4YFcmJu6nAk9I1557/n1Gw/XPps2rQwqPjKa+jo8wLLImUZedhihq8msSfYQggT
	4wOOO50kyXKMpbU0zfLUa/MrYFd/GxH3CkfC7C/QZ4+lPXSzLtGRiaT+55lfrvjs
	cZr1jdoOvB5O0z9p3Jmjpw2eJ/6VYsk2GIWz6UZTNnC0ItyhAu8ep3PrUzBP4ZdQ
	/uC3RJfhmeC4Qbw7vRGbJPUeTCpN88sFWw+ny8PIsmf33g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kdWDbU6Uevu5; Mon, 26 Jan 2026 19:12:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f0J8P4wn3zlh1SG;
	Mon, 26 Jan 2026 19:12:53 +0000 (UTC)
Message-ID: <5273400e-5cf8-4d70-a85d-accfb2977d8e@acm.org>
Date: Mon, 26 Jan 2026 11:12:52 -0800
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <eab078c99e17e45632c6b35e2fe1145e9459ff2f.camel@dubeyko.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 10:18 AM, Viacheslav Dubeyko wrote:
> I am not completely sure that copy offloading to the storage device can
> reduce energy consumption. The storage device needs to spend energy for
> executing this operation, anyway. Do you have any numbers that can
> prove your point?

Yes, we have measurements that prove this point but unfortunately the
vendor that collected this data does not allow us to publish that data.

Reducing energy consumption matters for mobile devices. There are other
applications for copy offloading, e.g. in data centers and in enterprise
applications. I don't think that these other users care as much about
reducing energy consumption as we do.

> Which file system have you considered as working model of your approach?
Every LFS for zoned storage has to perform garbage collection, isn't it?
I think that we can discuss copy offloading without having to discuss
filesystem implementation details.

Thanks,

Bart.

