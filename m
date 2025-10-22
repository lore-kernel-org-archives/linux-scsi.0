Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE0815687D
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153481; cv=none; b=kA5QfeXIusB0vjslkSjCRXckrLB1NqccPsIQ34sau5rc3vka3T3+uJCpjewv3B92sg1dZptvWFJAW/CfdrMIegckhiwrJQwehFWdRBMOXbJaWBIolw3QlOuoZn/nSWPIArPE8J35Vf+op7rpOiX+UZOjmjmf1CSPygIo20V6DZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153481; c=relaxed/simple;
	bh=uItbvKl0zJ6CPV/KP8GU+gvflv5asvj6f4Sj2rCfioU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUTeqi5XTOTdWEW05MoJKawcsalUpT9z3vE244GyfvUSR54yO/L10uALFrV2O39SnJi/TJelEHkef/31Z1st8OQSEem7Ta2et4pLpeOOMBs3Rx9qdsi7QBvtRP+NKDT84Ncn+D+vwBB830ZWG1MayWso4gyIQfBn8IOEc0PO1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DYmTSOBH; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DYmTSOBH"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4csG803GLszm0yV0;
	Wed, 22 Oct 2025 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761153471; x=1763745472; bh=Gv4SMlt8Mju9u3OXnM+x/Zsk
	Gn3MnSU/x5mSRaUF4Ac=; b=DYmTSOBH3V2WP5XWsPExeBLjlpQD7eQRapm790sM
	vOVA0peBKGwGy7i6RrZZciFPEJnByNoo0Ma/MRnQUoF0boh9MchboLONk37SnK8W
	vCQ9+Yy56PBKkzqbJ10ZZ2fBnlY+wlqweKGi/VmZ+GXyXaV91s19ip7voL0bHdQc
	YiYrSzBLR9C+vKUxRLVQzk7aDPiLDVHIIBVasAeHkdwN9P+GxRHRitKi13ditLFg
	EA3CqNzrjoJU3j+S9coEH8LOZUEWZ/izDO2tJkMJAXeM6pozmg7bRJjOlDdRc18U
	hv1/CN4sJ0Sw5aLoKFTFseloiMJDKJDw3y0ZKKsrBKuk9g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nClZn1ii3WJD; Wed, 22 Oct 2025 17:17:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4csG7w2ry7zm0ytL;
	Wed, 22 Oct 2025 17:17:47 +0000 (UTC)
Message-ID: <54b01a79-4141-4c2d-8907-dcb406da7ab4@acm.org>
Date: Wed, 22 Oct 2025 10:17:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Minor comment fix for scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org
References: <20251022090837.3590047-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251022090837.3590047-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/22/25 2:08 AM, John Garry wrote:
> I guess that the comment on scsi_host_busy() was copied from
> scsi_host_get() (as it is the same), however they do not do the same thing.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index cc5d05dc395c4..64de1a647b457 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -605,7 +605,7 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data)
>   
>   /**
>    * scsi_host_busy - Return the host busy counter
> - * @shost:	Pointer to Scsi_Host to inc.
> + * @shost:	Pointer to Scsi_Host
>    **/
>   int scsi_host_busy(struct Scsi_Host *shost)
>   {

Shouldn't "host busy counter" text be modified too, since the host busy
counter has been removed? A possible replacement text could be "number
of commands in flight".

Thanks,

Bart.
