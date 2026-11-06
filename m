Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940530;
	b=veeNqq7ZJsGcMH8akPssyO8DTGXeY0YpItwWgFbPhPoYHZVn//jQg5PuxrWOFO78zn+y
	 1mp+j8aqFGLJK0vnp8TDUnPBA9I0sBAcpZZt15Ev6X3+8lNARWsBofIIiKwc6WU0e4qmz
	 U7wz1aJ10BEEMvMvRZr2A9tpj+TXQwBFZ21MBmVKtb6g+86PUpv5gVckZE6O8TjCU80D4
	 GPXwQDZBVe+BnK+VCrzJaDqIExpsZcOSJcJ/fxff7RUYvvVH7R1Afum6XHrkPDaccgrfa
	 mY5yv7i5ImhkHCFfL/HO7GoRM9B1WeRotvF5K4Mn0Mhfg30xciaTRST7b2RHvbFGCaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nN/yG1SHBo5EeoOWptudEh7n4nO7y2qQzDoB1k65PX8=;
	b=qSWjzgHNMjgNL1V8aD/6MuT8bqyo2EHrl+xiCbEUbRr80GThCuJ5ShmGLvTpwwvnVrrO
	 CKjuYqsPOVTE0dPoThVIWEDFLoWaQ/qsqCGoKYgxtcx3r9IzgWFY9I9iPmBBIeAXwlYP8
	 fX/P+qVRoGv7JksVJnEk69zHT+QDzXUuIxHSouJ5mWBJj4rH/0fmLp1LqmWwVW9xT+7A1
	 ibs2H7tjpejbXSrsa2YjYOMWVo2SjjZHrqbMwoCCR+6XAtWaI8ZeAgH708n7yNIX2RPtW
	 gJu87uaoPy8r/8WnOt7KT4LLDZs653OQEzVbwGbBPqT3NYH3dFpQ54ZUbbmihrOyt/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="o+r/oGzX";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB01606A31B;
	Fri,  6 Nov 2026 04:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BB01606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=o+r/oGzX
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLRXL0JCxz1XLVhJ;
	Fri,  6 Nov 2026 04:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793940527; x=1796532528; bh=nN/yG1SHBo5EeoOWptudEh7n
	4nO7y2qQzDoB1k65PX8=; b=o+r/oGzXrRL0c4C/NWep7wzmoFY9frO3XI2ohpXB
	5iQifP50ptuVm07wGB1OJ9tFITQ4N1ttSAXrtBk0WpCuNChZT4zpjyIJCdUh2htC
	63cF4dCCvyePLm4k4xt55KjAwDhJ1FTtbAWtcSpuhcXQBS1cRMwxk/uVaNCb9dyg
	hDzr7ReFvSEiBXnX3FU60QQTcmcLQOjKeg29ACPEUXs82inNHR3IvyN9N3TOJz0r
	Q3436NY5izmhcimgcNluv7TLtYdcRoLH4JOGUqg8hJKjMjM/a4IPH+kXO5stk/UR
	zMvXNllqm3cT0zTmJSf/Slr3jBeIlKtVWZjFcQTDy3EmgQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G84JF9xErjf7; Fri,  6 Nov 2026 04:48:47 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRXH0jzTz1XMYJZ;
	Fri,  6 Nov 2026 04:48:47 +0000 (UTC)
Message-ID: <8a1efb5c-1a59-4bc2-8732-1478d27af137@acm.org>
Date: Thu, 5 Nov 2026 20:48:45 -0800
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
Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1793931113.git.hy50.seo@samsung.com>
 <CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
 <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 6:15 PM, HOYOUNG SEO wrote:
 > Only take the early path while a runtime PM operation is in progress.
 > For the other PM operations the regular error handling is safe:
 >
 >   - the system PM callbacks hold host_sem from ufshcd_wl_suspend() until
 >     ufshcd_wl_resume() returns, so the error handler waits for them;
 >   - during shutdown and poweroff, hba->shutting_down makes the error
 >     handler stop.

The second claim only holds for poweroff after patch 3/3 has been
applied. With this patch applied but not patch 3/3, an error that is
reported during hibernation poweroff makes the error handler skip the
early path, acquire host_sem (ufshcd_wl_poweroff() does not hold it) and
call ufshcd_err_handling_prepare() and ufshcd_reset_and_restore()
concurrently with __ufshcd_wl_suspend(). Please move the patch that
serializes the error handler against ufshcd_wl_poweroff() in front of
this patch so that the series remains bisectable.

Additionally, during shutdown errors that occur while the final START
STOP UNIT command is being processed are no longer handled by the error
handler. Recovery then only happens through ufshcd_eh_timed_out(). I'm
fine with that, but please mention this behavior change in the patch
description.

 > -		if (hba->pm_op_in_progress) {
 > +		if (hba->runtime_pm_in_progress) {

runtime_pm_in_progress is modified by the runtime PM callbacks and read
by the error handler without any locking. Please use READ_ONCE() here
and WRITE_ONCE() in ufshcd_wl_runtime_suspend() and
ufshcd_wl_runtime_resume() to annotate these data races.

Thanks,

Bart.
