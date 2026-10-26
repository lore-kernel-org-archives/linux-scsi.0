Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046611;
	b=d/vWBSM39OQQsGK6e+L4Wee7NdjW681Mywq4Um9RA1MhrOI8IlgH0kOQAoWXXLvqjBCT
	 Xrv99SJzP4MPADxuj3hjbDEuUEmcyur25O3ZNRsKf9piqBhFiY4dLxGozuEAokC3gqKFv
	 5pvklZAdEtDThcXWrsS/GAW38SNIU72iI5tKXYIwykGm92wDJO6Xzltf9qt76t4Y+4Nl2
	 QEuk0Ia3NB2tAIfEfg3ZjEpIng3DjoUCP9oZ2q/bQPwZFY6MnkMqmYjKBjL8bDpW6Elmp
	 rLRNmLxc9386TLI4Sw/8EipXXizy1o6yb+2TrVrgZVv49LTmCCTpZzJg9BG6yQyzSLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046611;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZU382VR9VFvP+88q69iBNd3gx3rQknKjVsiESDHwxak=;
	b=qB66kfC4LtltW5t2MqxXqqJM2Qrk5lJuBHEU2HXcO56xA7EEwShVbnQKXHccrrt7J9nX
	 FXb9FSP7fiVrPSq2EraTiXbjTILdG2t8O+CDKyBEVXwE6ly2h3OzkUc74dJtkJSZzhLnj
	 ITu2i/axzyF5l07nGWxqxdDdoJF/nRAgitZb/8uwgaWmF1BRI6+V5bq7QHBuI9z57lWeU
	 RjJCZvtJ+ZARAGzysEQqaic1LdCRVS4jVItZgReaueUjdQMcCCIqDsOcvED6NVwhxFURw
	 pIv5y0pY0HaE60DKHcJFc0P9rrutafpoC7+xcwMth5dPbhhT65ZdOYZhUnvKRKSHuQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WbL3yBWI;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC3B606A31F;
	Mon, 26 Oct 2026 20:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BC3B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WbL3yBWI
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jD4xY74C1z1XM30g;
	Mon, 26 Oct 2026 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793046607; x=1795638608; bh=ZU382VR9VFvP+88q69iBNd3g
	x3rQknKjVsiESDHwxak=; b=WbL3yBWI8skb1sIL1KDWTfndvB4f6GYkqEIYEhGK
	tVap9QkZZxmF/JNnXs+qsU35vKsRQ/UauU8Tyqt9YXeafGf5MftZSHdoyLPckCAj
	kOxHldWg8EMkHqHixIbK/xLBclS1MYt4l0D/uJ4VhgN5bD1Vf9v8MDN0Z+w9VLRi
	QdaTO3Wu3wy8I8zo3CjZXqz9KBEWHP+yuon4XHOAwynnS1MsTthpt9ZJ9SkVt5DG
	uedFWaN+UoxrF+fo9KH3yWbidWLJQjbEAxUsVbVG6MKfIh8Die7h6MOcTC6ZJk5T
	AwvBJTUWONXnfoPEx3YiU0x46T/u+EDzratVH3N4qpVB5w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c_-km9dqUKSi; Mon, 26 Oct 2026 20:30:07 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jD4xW3pWnz1XM4Tl;
	Mon, 26 Oct 2026 20:30:07 +0000 (UTC)
Message-ID: <7f77627b-91eb-4d94-913f-9e4164f24a86@acm.org>
Date: Mon, 26 Oct 2026 13:30:06 -0700
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
Subject: Re: [PATCH] scsi: core: Balance the pseudo target reap reference
To: Giuseppe Piscitelli <ooonea@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261026202119.667348-1-ooonea@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261026202119.667348-1-ooonea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 1:21 PM, Giuseppe Piscitelli wrote:
> OpenAI Codex analyzed the teardown warnings and wrote this fix and its
> local validation.

Please include the teardown warning in the patch description.

Otherwise this patch looks good to me.

Thanks,

Bart.
