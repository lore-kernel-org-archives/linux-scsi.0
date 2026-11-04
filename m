Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817292;
	b=AlfNIby6VGqCUE3AobOXEhKFSU2eNSB0g6gOLaarR82HuZSL43W01kY6l5djsRR3RJv1
	 m0sU4SgAm2sQuMRvRpSjUAnPQOSLOfK3i+L19r7hPk+cjTpsIosaWgsa50sBp1qlIG4um
	 iWLKHG9SZuk47PjE/sNrx83chBn4Hys1+Id7rkCY9UEs+lKSIVs1IsIXynqk/YSaoLmTb
	 Z6YLao0k/uSYyMIf7GZymNq3hSf4bXSZBYLDYO54q1kbwXYjft0sT5B5oVCeJX8YQG8/H
	 Z8F/lN/vnDIELYHvckKc8qw5h+cu8h9VwdibFuzih8L70lXMJ7s4pdvN9i5NvCyzhBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817292;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=NfxT0sqcleYaY8Ga2KzCjtCATlcCj9RfsbOGm3hC7pc=;
	b=kmRn8GIrf3EZPYyl4NzwoEXyPgbCXGxi52l1a10zzS+EEseplLJfWK1wHcp17/5R0KxJ
	 ODV3oqTKhufj+cVnCas/taTtCrbckQAh7D7K2hKbqfESwD/uckKW7PCCCWxVot4UTi/Hp
	 rcF8cR0uhkll1KJU4A9HSwlTf+NyvJrghUxyS5iZbBmPbEje7kqT81MlqCdL1pYv/6MhA
	 ny7SaOEd/BYkFQQHWTfl2x1WVw+08D9k95QvWB82k+5nt+90WJywdgET3moh35o2Txm4B
	 O22L9lvozYU4/EoZGN3BZ8k/S4ToutJ78kRe9sJH2Aoyf4AI3k2/hMWv3uFBXxCXvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3I7Vj4tZ;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF34606A33D;
	Wed,  4 Nov 2026 18:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CF34606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3I7Vj4tZ
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jKYyM2nMFzlffvH;
	Wed,  4 Nov 2026 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793817289; x=1796409290; bh=NfxT0sqcleYaY8Ga2KzCjtCA
	TlcCj9RfsbOGm3hC7pc=; b=3I7Vj4tZjRD5dWk+LQypRBd2dlG7y/f9/d/G3ndI
	zzjbC7CmzfOsQhCpF9Wffqi91nVMzNDnIX+i4WeRYnGGOhdP3FCnAe3xE88qxqOA
	+hJbfNbtDlovEiw0uGffeop7+Qo7f+lQCKu8jhymWj9VwfMc6OUF6M7LalcsgQGu
	qdF3ogZHWTAhr6jqIMRGTHN7VtBW/q/J5CiiKgPRcVBBzmQAd0VMV1i+ZGtgwCzG
	4rTZOY3cS2Vtxcr8w+PA3GauXfEiXkeYv8sD2HYHm+THrylQOrFLJBqY/naTily8
	PI1sJEoJx5qGVtnoxtnYBPwso3tk8c/h9PlJEfER++rwGw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id miuA7hPYHUMx; Wed,  4 Nov 2026 18:34:49 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:cf61:6f8e:9bfc:37ad] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jKYyJ6Jd6zlfl5v;
	Wed,  4 Nov 2026 18:34:48 +0000 (UTC)
Message-ID: <5f523a2c-c2ef-4285-9501-44d373569f7f@acm.org>
Date: Wed, 4 Nov 2026 10:34:47 -0800
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
Subject: Re: [PATCH v2] block: Keep RPM_ACTIVE in blk_pre_runtime_resume()
 when already active
To: Stanley Jhu <stanleyjhu@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: Brian Norris <briannorris@chromium.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261104112744.1630864-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261104112744.1630864-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 3:27 AM, Stanley Jhu wrote:
> Differences from v1:
> - Move SUSPENDED -> RESUMING explicitly in blk_pre_runtime_resume() and
>    clear pm_only only for RPM_RESUMING in blk_post_runtime_resume()

Hi Stanley,

Thank you for having addressed my concerns. There is an existing
issues that you may want to address with a future patch: Queue ACTIVE,
device suspended: after a failed resume, the queue is ACTIVE with
pm_only == 0 while the device is still RPM_SUSPENDED. So
blk_pm_resume_queue() never asks for a resume, and normal I/O goes to
a device the PM core thinks is suspended. A retry only happens if
something else calls pm_runtime_get*(). Commit 6e1fcab00a23 introduced
this behavior on purpose.

Thanks,

Bart.
