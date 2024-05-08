Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2021373
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715200840; cv=none; b=YBd6B0e47mEJqWpTLor536o6638U4/lTOZssqi6h27v+DQTvYf2A4fHgELgFLN2ARlHHT8P10wa7XuA4KX6hlEQIMTpd7NDSiR1eOVT6+p/4Kg4gPxmmLsWBADDpXmp/G4TTx1k0hmKdQiYJu5PI1ihWgG+s8k8XNwfYOkCS7zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715200840; c=relaxed/simple;
	bh=ih4GZLwgJgNj/JVk+oKFu9ubqKTfIbJ2n8OQ/YafGTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hl5zQFcHYxErpikj69rbZtIPa0iQf3OUqCJTfYJvT7YMVAYzkArbAdgqr/OO40DZ4/BmtLpguDiR0CwCwnRkqI1fsuQw186KpaBvbwoWJAoIvDAK8GtW1BY6Hsoei2HUKg33YZNzokx0oHQIWzkeX/IWTL0aYTlavSF8L1iK130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OdZZPlYz; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OdZZPlYz"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VZRqN3nN5zlgVnf;
	Wed,  8 May 2024 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715200831; x=1717792832; bh=EOZPBCBy2xG+IowIuIL3IOeH
	RTG6TigXL2VYLZqA6fw=; b=OdZZPlYzVHuMf4QGUDwhwTv7yUNpRSJY/qLCi3ZE
	0mEgCHEBFV5NGJLIIj3YUCWfpZTaZfEbE/FMy4Si7J1+CcT+2zpVCVPMSN7whT2F
	afsOxtJzMfghKT0oZfp7Md8Ahi4L6edPzDfWHFlPFu3uYvR5Y3p2EbBIPxu6rmFm
	q8DHYCwv61y9PcxwLyHTQHn0K6Xo4gCZW5IACSvnc4MdUCKvWnanBt0gStGzFtW2
	YE29ixEQeP3Z52LEkjAz/0JK5RxgHDMUtZFSiiKA3ci2V1lFd4TO6J82XWtpaSld
	3TyhzOkrEez+GFDrncxukcuTnthS7wzbf2HrnNNWd6/I4A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fzSC6cR_q2n8; Wed,  8 May 2024 20:40:31 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VZRqM0lFbzlgVnW;
	Wed,  8 May 2024 20:40:30 +0000 (UTC)
Message-ID: <048d8f26-d638-44e3-bfae-db60531a7741@acm.org>
Date: Wed, 8 May 2024 13:40:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi-cli tool for storage devices
To: Himanshu Madhani <himanshu.madhani@oracle.com>, linux-scsi@vger.kernel.org
References: <e35e1368-34b7-4b3b-a08e-e2292d3a4a6e@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e35e1368-34b7-4b3b-a08e-e2292d3a4a6e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/24 9:06 AM, Himanshu Madhani wrote:
> I have been working on the scsi-cli [1] tool to help find information 
> for various storage devices from the host in a simple, readable format 
> with no knowledge of sysfs hooks.
> 
> scsi-cli tool is a very lightweight tool which aims to provide details 
> of storage devices on a system in a very user-friendly way. Any user 
> trying to figure out devices on the system should be able to issue a 
> simple, easy to remember sub-command such as "list" to get display of 
> all the devices present in the system in a summary form. If the user 
> needs to get more details for a specific device, then "show" sub-command 
> with the device type and device name input will display more detail 
> information for the device in question. Additional commands such as 
> 'stats' provide statistical data for the device. More sub-command 
> support will be added in future release.
> 
> In this early release, I am supporting Fibre channel and Block disk 
> devices. An iSCSI transport provides limited information at the moment, 
> and more details will be enhanced based on request and feedback. 
> Additional transports will be added in the future releases.
> 
> In this initial release few commands such as list, stats, show are 
> supported and other command support will be added soon. When this tool 
> is instantiated, it will display placeholders for the commands that will 
> be supported in the near future.
> 
> I encourage everybody to take a look and provide input/suggestions on 
> how this tool can be improved.
> 
> 1. https://github.com/oracle-samples/scsi-cli

Is there any overlap in functionality with the tools in sg3_utils? If
so, how about integrating the scsi-cli functionality in sg3_utils?

Thanks,

Bart.



