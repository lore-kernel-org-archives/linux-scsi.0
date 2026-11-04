Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766873;
	b=rqmHWGOQqnBKYMC5+TSwhfsPYwvXhge+v3CxtUt7+gJnjz8d6JqXxnc/VmoR997UHQQZ
	 dtHm4DFKKk0IsSpMnrqZuE3QS1PWbHWKLWEvSnPY4P1Y3Q6OHeA86xznkRSFyQDywBDy7
	 LvUQQo2P7LS4sJTxQeDJw/PVwHrFJu6fUOg2DBAdZZQpbQq7oQLDQBbJ1oOQFrulKQDKO
	 M8n4/rRomVLi0s1KrYCyNxIdEii4TufZ8vbBu+s01gVA1ownB9GWBnB1REKRXRjnGinYU
	 GYxsfNCpfdepOI38ac9vDIP8uJFb3u9Clmt3A+5wdMq8qamSvUSXAmJ8PyAMKJUw1dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766873;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=G8YpZRCFVyivDxhoV9SWtIiaSEyFH4YpyaytLDtbGBY=;
	b=NyO0sq2n5SFSXVhM/YOJi3vVWmV2vG4eo7Z1PbS3TT2ByOFZLY+ecLUKmZFmWzMpwb89
	 A6tYtvUsU5s99kX30mEVdzotQ2cQXveDOzQTLQyY1WI37L+qSA9/qXDmg/WNOtm7UIxM0
	 Bof5p5NQN1SD6N7GPa6/9YAfRZzQhVN71ssxGhUkqRReAY4Y+qv9cw1MgCqHx3IOg394U
	 fzkfzdoJFBPbcOXWWXSslkY4BXeImef+XNhB9XJ8gxjD0yQi3/ht0Q7E5oK6gE5wQs8/5
	 fbj/9TjpghJLjl368r6CfYrGcUPYNJtGRxql/DvJnsF23ofv9n2J8V6+c636ZjkVYDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=KjWVFzDo;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D2606A31B;
	Wed,  4 Nov 2026 04:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B2D2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=KjWVFzDo
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jKCJm3tfVz1XMG49;
	Wed,  4 Nov 2026 04:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793766870; x=1796358871; bh=G8YpZRCFVyivDxhoV9SWtIia
	SEyFH4YpyaytLDtbGBY=; b=KjWVFzDocGMtKuuvAv0jt/J2w89cuR1b7AqdNMah
	dhCnPo2pJ1WnwljuaE68jpLdjvFhAO/omM0WP5GyMmk8SGPUTQwfVq0/hu43Tvrt
	6Xp+XcJUUlEXQmKWmlYJc7AbNpBm/1242YpLEttsuBKz2T/vjaWclRzhZtfzWFjp
	Cwok63Xv4AgNdx+7JRwFo+Mm1y2pVKGTeDF3vlaOgKRT0OEWjAiAMSCgcxrT9l8+
	dsnysGWozXU4uMCwv0V7leXfd5qFh/MLtrwp3KbNg1Pk0aIzY/0uwc2C7Dizd0Dm
	O04YwWtrJMyNSAVTpNy/3pIephEdZr+/jpCTG1bU4ltwmg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CJwdVMIBCeg7; Wed,  4 Nov 2026 04:34:30 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jKCJk324wz1XMFxK;
	Wed,  4 Nov 2026 04:34:30 +0000 (UTC)
Message-ID: <1eb498b1-5360-4eb0-86bd-ade1b46735eb@acm.org>
Date: Tue, 3 Nov 2026 20:34:28 -0800
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
Subject: Re: [PATCH v4 1/2] ufs: core: skip ABORT TASK for device management
 commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <cover.1793598099.git.kwmad.kim@samsung.com>
 <CGME20261102055315epcas2p4024322466144d1a59b4e8fdadfdbec2a@epcas2p4.samsung.com>
 <6e40b9a374f50616e84ce1f974da6ec27a79cbf5.1793598099.git.kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6e40b9a374f50616e84ce1f974da6ec27a79cbf5.1793598099.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/26 9:52 PM, Kiwoong Kim wrote:
> In MCQ mode, ufshcd_mcq_abort() falls through to ufshcd_try_to_abort_task()
> for all timed-out commands. However, device management commands (query, NOP)
> use reserved requests and are not SCSI I/O commands. The ABORT TASK task
> management function is designed for SCSI I/O UPIUs and is not applicable to
> device management UPIUs.
Reported-by: Bart Van Assche <bvanassche@acm.org>
