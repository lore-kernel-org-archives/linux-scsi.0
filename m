Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739279;
	b=0nEUJVusO+HhgJ/omWScYNTU0/PZi1+25ts+CP5vexkgKYqJNkPXtImii4JUaKMTAa7o
	 F5ugrwFcBiqZ1hI4lGHZTS11NOR2lRsx4T6MUrkVJDcX5CHKeYfi5M/JYUoAvqXbF0fww
	 MlICGSw/fi1OWGrW80tfrfHwjqFCiUwVwA0T73PkqvlNGQjuAL7kTuKhzKaXzGrp503VA
	 XFPmK2OdzMprWnOSgS0bkpccrt47fWldEPxJx9pkIpaAOGCgqCGtl90rmpdhsCIidNeA8
	 /UYN6dKEyKQBVn32TbXailfS8cFrBVZmXEVyYkuiD+04L1iSgyXHdbQAekZXtYEwYfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=U9zXQB+7vAN4+u9CA5J+kHq3aVzM2suNNiiqveHIdmU=;
	b=ch/wBg/U/FLkJqxPhz0MSgMDIp0/DJlnmhTYdr/C9lZYkPtWR9sLh8d9WClGC8BMe4It
	 0y/G0Ozisw9iuh2fZTEPf1VZg1ocAeMfDdNRnnvGUlvF7v8AbQieyS4l9xQPLBhbd5S+d
	 a9c+iQtcEs0vIiPncwAr710XGIWaq3z7wD11CkV06rIKtBuPWeStqIglFZfWplanDQfYe
	 +O1wPa9SOrVZUtNTKFcznkxDGOxNfacfGs9dpCMf5dE3kia4EAVUERkh+68+ydeUXVm8z
	 /T5vcSgISLeFE17sY5TltugWMmb4e06kgTf4RmgxEADI7cA+H17EfdStNAHlF/+R9nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RC3QCQEp;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE92606A32C;
	Tue,  3 Nov 2026 20:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDE92606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RC3QCQEp
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jK1661ZKHzlfwgG;
	Tue,  3 Nov 2026 20:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793739276; x=1796331277; bh=U9zXQB+7vAN4+u9CA5J+kHq3
	aVzM2suNNiiqveHIdmU=; b=RC3QCQEpaDjtm9JfU+Nued1GIc1zrvsBle9ZKDyb
	7xCeR1G3dOs4ybGu3i3e6SBNo8KW4OckbwAejKIsFRplzxMhLVidEPMgFmffMLfQ
	etYv+pxpzdK6CsGo4AEXwYWrVdBKqU7T8/MOx4uyfbW0G3FLTcARkbOApy/JfuPy
	UgXA7TRjbtj9rz5QE300cYxQY3LT6XOkzNHnYFxhKaBTU72yY/NfPhKuL1zO5VUN
	RUAHxW9uWmNN/XtL1m6IBN0cSue+THkKKnECwGbIw0g0rzd2x1jZi+H1Y2SJ1A1t
	OO+4Hhqa4kHoQHCiG+eDYe/eb8nMYwU4YnuaTJ3hXbHDxg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6OudQalGJVzn; Tue,  3 Nov 2026 20:54:36 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jK16367HszlfwgF;
	Tue,  3 Nov 2026 20:54:35 +0000 (UTC)
Message-ID: <6e42537e-c7da-4b44-90bf-dc4cf30be6cf@acm.org>
Date: Tue, 3 Nov 2026 12:54:35 -0800
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
Subject: Re: [PATCH] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when
 already active
To: Stanley Jhu <stanleyjhu@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261029040001.2100001-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261029040001.2100001-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 12:08 AM, Stanley Jhu wrote:
> @@ -153,7 +154,9 @@ void blk_pre_runtime_resume(struct request_queue *q)
>   		return;
>   
>   	spin_lock_irq(&q->queue_lock);
> -	q->rpm_status = RPM_RESUMING;
> +	/* Keep RPM_ACTIVE if a prior failed resume reactivated the queue. */
> +	if (q->rpm_status != RPM_ACTIVE)
> +		q->rpm_status = RPM_RESUMING;
>   	spin_unlock_irq(&q->queue_lock);
>   }
>   EXPORT_SYMBOL(blk_pre_runtime_resume);


Stanley, the analysis looks right to me. Could you make the invariant 
explicit? Only move SUSPENDED -> RESUMING in blk_pre_runtime_resume(), 
and only call blk_clear_pm_only() in blk_post_runtime_resume() if 
old_status == RPM_RESUMING. Please also describe in the commit message 
how this was tested. With those changes:

Reviewed-by: Bart Van Assche bvanassche@acm.org

Separately: since commit eef1d74bf88f, ufshcd_recover_pm_error() no 
longer sees power.runtime_error after a resume failure. Its handling of 
that case is probably dead code now.

Thanks,

Bart.
