Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE711F819C
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729024732; cv=none; b=oMLMEkoYqT9RHdYM2RHwUs9RALwtAq5AkywWzfPhIL98OYnFDPs+L/pCGid3gTOdoX9J+7CmwdFbGux390uFjqyldHuwJYEydj+7W8s752K9ZjV1EcKWksBE6ps+QOJ/uESul3nzxXkKv3RiDukwwX+l9y7DJeeG6esvvYrtFLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729024732; c=relaxed/simple;
	bh=MkUgiPSAIek9EchDqI+2aiiSPQMlolTeEEyC8ErfwPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=q/OoCpN09/+FjCEHi6d9Ip4j8aw3wPfQ9XEFlpVyWt24is8Yj1alyY203ARMn6RRoxpz7uOyCR9gjvCqCjn5qjLjiXkpxtQcm0QVN06FZgjh2GSVon5ihvheas7if3+A/SKYIkqzLI1t6WwYESuBpkvHzxUYOE5VpUZg6Tm39Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pLeO2gWy; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pLeO2gWy"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XSmCZ42v5zlgMVp;
	Tue, 15 Oct 2024 20:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729024729; x=1731616730; bh=0EIOYOg9dfHy1Iwqk8uKy+vG
	5tHBipkEegv+VQqogmI=; b=pLeO2gWy6CFPFT4W8wnNdqKh3tWuU0Vmrst5fxeA
	24bk5syRjrt+ldCOZHJKrvyRaLkr1f41DmZJGHotLMa3s3OAiNX6RK17M/RHIWi+
	YgPSLQvF/cn3x4RuA8tWrFYNft68Za8kiCvoS3B8r1txO73drdr53HihKKavegEm
	EXNxg89bAoDQ6JXP5Iom2ETPbDJfqlYtDi1YjwVWxsOUAxDFo4OzuJ0v6TP5hdg6
	Of3M/Iq8KP9BgbFelOJxiI9UJtLn0rgImqCSIumIvtP510Z3tcyfoH1itbxrEFpD
	kZzgL7dcAuCE2zm/udT/F9/Oi/D3f0/0E6IbcjmV9/8Rng==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RMdehTrH1jfe; Tue, 15 Oct 2024 20:38:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XSmCY0LR5zlgMVh;
	Tue, 15 Oct 2024 20:38:48 +0000 (UTC)
Message-ID: <80cac88a-9eb3-4301-b2b7-ebb5f7fdb7d4@acm.org>
Date: Tue, 15 Oct 2024 13:38:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Remove unused host error code strings
To: Himanshu Madhani <himanshu.madhani@oracle.com>,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20241015183948.86394-1-himanshu.madhani@oracle.com>
 <6a587c9a-b573-4860-86b9-3a27572d39db@acm.org>
 <2001a656-3bfd-4657-b47a-68192894ad18@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2001a656-3bfd-4657-b47a-68192894ad18@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/15/24 12:57 PM, Himanshu Madhani wrote:
>=20
>=20
> On 10/15/24 12:15, Bart Van Assche wrote:
>> On 10/15/24 11:39 AM, himanshu.madhani@oracle.com wrote:
>>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>>> index 340785536998..b74c3f505300 100644
>>> --- a/drivers/scsi/constants.c
>>> +++ b/drivers/scsi/constants.c
>>> @@ -403,8 +403,8 @@ static const char * const hostbyte_table[]=3D{
>>> =C2=A0 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT",=20
>>> "DID_BAD_TARGET",
>>> =C2=A0 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_=
INTR",
>>> =C2=A0 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQ=
UEUE",
>>> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",=20
>>> "DID_TARGET_FAILURE",
>>> -"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };
>>> +"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
>>> +"DID_TRANSPORT_MARGINAL" };
>>
>> That doesn't look right. "DID_TRANSPORT_MARGINAL" occurs at the wrong
>> position in the array. Please use designated initializers instead of a
>> traditional array initialization list.
>>
>=20
> Can you elaborate? From what I see, enum scsi_host_status{ } maps to=20
> these strings. So, accordingly, "DID_TRANSPORT_MARGINAL" is placed afte=
r=20
> "DID_TRANSPORT_FAILFAST" in this array.
>=20
> Am I missing something obvious?

The above patch places the "DID_TRANSPORT_MARGINAL" string at index 16.
I think that should be index 20 (0x14) instead. From scsi_status.h:

	DID_TRANSPORT_MARGINAL =3D 0x14, /* Transport marginal errors */

Thanks,

Bart.
