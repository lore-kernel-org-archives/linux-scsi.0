Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812306;
	b=UN83V74W5bVdWHadBjoA6pzQ4qcbqe1Emh57qRYSNIN2Il0FkH6Io4T+x2FU6kEaN7ZD
	 lko3bo1ojbf2mrM7FDbrtlC5NvRcOE3Nggj8HESWbSXyalHrhONee8zbkPx5sa7tICM7L
	 CsgMEnZ5kCZeScjkV70TGQE8N8kLGAv5P7h1LxW31W9sW5+7yH2xLl1vJjaaXwqCaMRbr
	 zp2t6ZvMWSiHFh4Lix9zj0G6iiPmqZSqnyQ+WOGHW+GyGL8R5PkYNJiQs8q+AKTCfIxMM
	 AhqhxMB46eCY0Zd6fvGwKxWZmrMFNAyqY0LNXz6cvjmMElGrP/kYm367ZZAQRNMW8yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812306;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mlKVFicyJ09eC0P3851CJPrmUizXit4zBavA6Qb+JgU=;
	b=hTYoykNxwj76y0A+NPJg/kFHiOOb0GpFkNT7ibpiD4+dl2096liTcINCqNctYteuhQd9
	 hvWfWJLMq1SEGST5iaYR0q5QlryaMpDg79olHYI9gAYQ7MfcuXz9Ptk7EGavcbUYEEh+z
	 ZJLwwk4SGu/o+op+urFltyxwB/5Qng4l84VTnrjWOyWiMwPiusU9LsnrO3hlWzHdeSwEH
	 ytixyUKMp58V8lDzYdFNOJ/bc0T7Iu171Ql+psHa8wyPgOfEQJOpZBVJkEFHk7geQgL11
	 +sfQgzyxFAQD88x4p6hvadBm2Ep9GJSjH2XFoMNkEa1kjrEjPVV+DNzgI/vRayShyiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=2Lzfm64f;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16344606A31B;
	Wed,  4 Nov 2026 17:11:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16344606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=2Lzfm64f
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jKX6T332pzlfcTw;
	Wed,  4 Nov 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793812302; x=1796404303; bh=mlKVFicyJ09eC0P3851CJPrm
	UizXit4zBavA6Qb+JgU=; b=2Lzfm64fUv5Qx9EFSr84etmN2esaCCmR2AGo1psu
	4IquYX/jAgS4TAxWFkNP42MuyTSGrA+q2Q+2EA7FrW92hJDNfOOZnNKGYmv5NaAJ
	Cda0+ediHESmSHOBkD39raj93GFbcZLwizHsmNcbLtx9NRQe8kNNLj7WaAIbiT+/
	3JJtupTUZcIDW1HY5xasuxLqZIxXFoQrQyXS2NNYdcSCLVkLJhjEgougaqRIl5mh
	O3q3s22+WQFK1lvoCvJ2eJTY4x7uWOmZwgPrsiJgjayOqntp2M9RLkvmRlliTRvM
	ggd/5Bx+r+VchieruBNBATla6GIFYNmgPCV2lgk9q9ZMMw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cGQNmq_n9wrT; Wed,  4 Nov 2026 17:11:42 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jKX6Q0rwKzlffvb;
	Wed,  4 Nov 2026 17:11:42 +0000 (UTC)
Message-ID: <8adcbd80-f684-4e00-81b3-a2661fac895b@acm.org>
Date: Wed, 4 Nov 2026 09:11:40 -0800
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
Subject: Re: [PATCH v2] PM: runtime: Update runtime_pm.rst for non-fatal
 resume errors
To: Stanley Jhu <stanleyjhu@google.com>,
 "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Brian Norris <briannorris@chromium.org>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
 Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
 linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104151651.3035537-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261104151651.3035537-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 7:16 AM, Stanley Jhu wrote:
 > +  * If the resume callback returns an error code, the PM core sets the
 > +    device's runtime PM status back to 'suspended' and returns the error
 > +    code from synchronous resume helpers.  Unlike with the suspend
 > +    callback, failures in the resume callback are never considered 
fatal,
 > +    so the helper functions described in `Section 4`_ are not 
blocked and
 > +    a subsequent resume request can run the resume callback again.

Hi Stanley,

This matches what rpm_resume() does since commit eef1d74bf88f. A nit:
suspend callback failures with -EBUSY / -EAGAIN are not fatal either,
so "Unlike most suspend callback errors" may be slightly more accurate.
Either way:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Additionally, the kerneldoc of @runtime_error in include/linux/pm.h
("Fatal error code returned by a failing callback") could be updated
in a follow-up patch to mention ->runtime_suspend() explicitly.

Thanks,

Bart.
