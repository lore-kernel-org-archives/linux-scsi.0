Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210192356C6;
	Tue, 17 Feb 2026 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771356798; cv=none; b=LrBeqSdPWx6jhkyO7jxaAatfIrGjM7AeYStYaCLpe2Xe+66EErrDaNyHIb755kXhHA1zl+/l4Wtf2jYhqFVLzzB28bj/Vdk6c+UCHpoFY0a2RGeA0/JviZEI2LYgYGiWdFystBtgYrTK6GxMjhuC9BWqcXRFjvWZdFMFrAxtuGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771356798; c=relaxed/simple;
	bh=roGhM713G9ODi+aw1FZZOWEHJgV5y4SCaqGFHLV1eUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZhWmrLRHjVQMsR5yT1Y0lqjv+19/5gFFl8Ho89QOdj51zEx0Ew0z2whMBOzi4LtyJjJr2IOb+vYQgUOh+jxTcNMkH/hSDSIgB218y+K//UNfIeYmxJOxpPNh77orF6Wx/C8kUswpLCWdniLhiGQnNwyKn8gC6t4tIOt1BtmYKC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2U3ts7V9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2U3ts7V9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fFqYm4mjgzlfftt;
	Tue, 17 Feb 2026 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771356795; x=1773948796; bh=T4bYYczNcYGm6Sri1HPrON3W
	M1fljoTB8513tgTbjpU=; b=2U3ts7V9suosHzmy4Op6FK+h8TusScpiHd2Rk1jD
	oVnCcmSnQmhmcZGASIkaYgXvIpNtitXKP27VHuvSL36nTSXgo6NL4O6yc+SMBiiJ
	rhAOCKUK1uLqgefLDP2hOU1orvaji4RdUAwvXAOFSA4VLKt8g8uAnZ9cZaD55cjm
	RDrV1uGSx+mj4WG/q7nScODxhGWC+gW38BZgvwRIF/vlYF4kvLLS23w+a+mnLEx0
	ssyNOMyaYtdak449gD/e8zSHjti03+Q5XaHAAWLe0Bo7ttFwE2lqcv8zzcNQXe4S
	MyGOVTQLRB9QcPOUbXBJunbL2/wXkuv7kmxxUHK0Cr/UeQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lpWsix-s36xa; Tue, 17 Feb 2026 19:33:15 +0000 (UTC)
Received: from [10.237.57.149] (173-255-98-114.utilitytelephone.net [173.255.98.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fFqYj5VCFzlfdfX;
	Tue, 17 Feb 2026 19:33:13 +0000 (UTC)
Message-ID: <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>
Date: Tue, 17 Feb 2026 11:33:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: John Garry <john.g.garry@oracle.com>, lsf-pc@lists.linux-foundation.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 6:19 AM, John Garry wrote:
> At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
> Let's discuss this topic at LSFMM.
> 
> The idea for this is that SCSI could natively support multipath, like 
> how NVMe host driver does today. It is intended as an alternative to dm- 
> multipath support.
> 
> I have been working on the implementation and I plan to post patches in 
> the next cycle. I am looking at a 3-stage approach:
> a. create a driver-agnostic multipath library, very heavily based on 
> NVMe host multipath support.
> The library would support features such as path management, path 
> selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
> management etc.
> b. switch NVMe over to use this library
> c. add native SCSI multipath support based on this common library

A minor comment: maybe "in-kernel" makes more clear what this proposal
is about than "native"?

More important: what will the performance impact be on SCSI devices that
do not need multipath support? UFS devices don't need multipath support
and soon (later this year) will support more than one million IOPS per
device. Further performance improvements are on the roadmap.

Thanks,

Bart.
