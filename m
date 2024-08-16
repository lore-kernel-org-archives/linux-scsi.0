Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA89A1BE241
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723827411; cv=none; b=su1gs/VZCbLhIP6bEvPp3UDJvtaxBEc1D91ACo0vteWL3Np1xciSrp994nY4ZxuUuHfirODY77NI5HI8B5FO+L4PotSl0RoqZRNQ1BJshm6o9nGQi8D1g2h7upQyKE4IOC+yh3OfBBQUOWOvuY8cPQAsFHC7cKa98JdCIvl+AsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723827411; c=relaxed/simple;
	bh=DMzPmYZtT3DxiIAmdEk78Lu8XeP2nkbgKFGmzAYMXbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itzv0bgVDJIqVRPIk29yvR++FYhqHFjeqJbGzCn6hRbzyF0TMJsqIum300In702XnZFKjJHSsGu8g8rnOBiVAdQlwIKCtgBUs0D25SvulvomMhgFn0gPPlgu5BRGxArkAuv2rDi3FMRlv97fr+1HHnfN52Un97DeFhMSG8urIrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xf3WcKOA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xf3WcKOA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wlp6z3DYWzlgMVQ;
	Fri, 16 Aug 2024 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723827402; x=1726419403; bh=f32R5/8IUc97E7XTMvMRBH2c
	nq8LNBSNGJ8Gmeuue3c=; b=xf3WcKOAxrfS3a+BUXt1ChLB6C5zDYAPJ6L4BZwS
	+5sRSex1xB+fU380JAemVid7a6sewRX72t8BVTJzdGymXzihm5jNU0r03A6fzw4p
	KhZhBL/6alHq7vt7AT6NXePLjL5h59nre+9VuStaOIAMRXmwPRll1Mi8jqiGKlO3
	vIE7Z3S5SvJmv8+uq15EA3IHDYvJj0NNqm5BRRG5V6IrnWRCWIyiTgViywVUs5ej
	lbj/W788wvMXke1YJpWhJxgkBPFpT4YE3Si6kacAbOfPDpwIrK5taNj+TqlPsQy4
	UAsFxzSczNePhhKbAeTgMJcTfQQ3FBTpvoUp0NDdlP/pgw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YcOg3wvKXoSI; Fri, 16 Aug 2024 16:56:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlp6x3T4dzlgT1H;
	Fri, 16 Aug 2024 16:56:41 +0000 (UTC)
Message-ID: <0e25a5fd-1013-429a-ae67-8cd4036fd7f5@acm.org>
Date: Fri, 16 Aug 2024 09:56:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add header files to SCSI SUBSYSTEM
To: Simon Horman <horms@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240816-scsi-mnt-v1-1-439af8b1c28b@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240816-scsi-mnt-v1-1-439af8b1c28b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 5:59 AM, Simon Horman wrote:
> This is part of an effort to assign a section in MAINTAINERS to header
> files that relate to Networking [1]. In this case the files with "net" in
> their name.
> 
> [1] https://lore.kernel.org/netdev/20240816-net-mnt-v1-0-ef946b47ced4@kernel.org/
> 
> As part of that effort these files came up:
> * include/uapi/scsi/scsi_netlink_fc.h
> * include/uapi/scsi/scsi_netlink.h
> 
> Unlike all the other matching files, these one seem to relate more
> closely to SCSI than Networking, so I have added them to the SCSI
> SUBSYSTEM section.
> 
> In order to simplify things, and for consistency, I have added the
> entire include/uapi/scsi rather than the individual files.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
