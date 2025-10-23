Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE975D515
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761237187; cv=none; b=E+4WThsMoG5KN1WpwgfOuhjQyjjczOo1po3ti0jXdwwdJP1gY6uxMP/OYjMUgHuwQ8uJVN2uQDI3waAdgkto+R106tZFUrFgJ1fR9R4Qzk7DU0sIFe2g6CZBdmUNF+Qn1GlHpflZL9HNN5I53rtJaksO3ZQHSxh4ucYWAmgabG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761237187; c=relaxed/simple;
	bh=BvF0R0+KO2HiHcHTDH376iPlgIcgteZEOppTNTKzkVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZDGaj6zzW+aGkI5rSY78tViNpaoGUQ8u6zoWxZCp2F86zF6qxYRCmJkALs0oXCxFg+Ix1ubOxqveIn24UjveUHA4phjSQfA1TcFYSCnDGpr9/Vm9QwofgSuBUznupETFomvIW3fe5eSHZ3H8932ZUG/Qx4vOmaUrzPgYwDXgsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Vge6kbLF; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Vge6kbLF"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4css5r5l2tzlgqVq;
	Thu, 23 Oct 2025 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761237183; x=1763829184; bh=0UEPAeRYSw3yDYyImK26BKNP
	S4gxQwCy5iaxJ+pKs0E=; b=Vge6kbLFeT9ortap/CKsoHCMoto1BjssXGfIxZbK
	EU0X7G2gIhseIPHwsyZtvBbbcePbg3REgXoOsAA/PiKTtX4bKQZn/eBdDs1+XcUU
	okSuqdZO5W+oN4EHeXNtmDr+j7oeUiDQx/e6nrcSkNdL2cvcZtf8woYdLzwjDo4e
	hsILA6jMkEn7AkXVjf62C5fJiUhXRx28UiFx6KgjL1LUO8gdnjZdyxnBVcr1B856
	4Iq7EM3unus9EJtTy6Hz+x4Q9u7Yh/de5LgGdLY0ppQf7dJLj2JDvqhXUt2we9Qu
	kaJk/sCp5bAdO8/xTGfh/kMlo/e575MhLkHRudKwbvXF2Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o8Zk3MtznKkg; Thu, 23 Oct 2025 16:33:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4css5l6XV0zlgqV1;
	Thu, 23 Oct 2025 16:32:58 +0000 (UTC)
Message-ID: <4ac55689-eb71-4298-9039-b625a550e14f@acm.org>
Date: Thu, 23 Oct 2025 09:32:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Minor comment fixes for scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org
References: <20251023082759.3927000-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251023082759.3927000-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 1:27 AM, John Garry wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index cc5d05dc395c4..eb224a338fa21 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -604,8 +604,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data)
>   }
>   
>   /**
> - * scsi_host_busy - Return the host busy counter
> - * @shost:	Pointer to Scsi_Host to inc.
> + * scsi_host_busy - Return the count of in-flight commands
> + * @shost:	Pointer to Scsi_Host
>    **/
>   int scsi_host_busy(struct Scsi_Host *shost)
>   {

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

