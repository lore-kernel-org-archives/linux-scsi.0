Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0D53F54D1;
	Sun,  4 Oct 2026 22:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791153738; cv=none; b=BetXUJHTLYqDmEbahZCXD6UA8qHF+jwxzboN+TXlopKo16vnW/suI36Tavy9pMli/CWaq2T5eDe+lo+vccunHoifcVu1kepKOItbclB1utNab39fqNzTzL4fiX26oYExST4/dAW2FHuwueQylj5XY+FkDFkELgE6WvUAR3i66PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791153738; c=relaxed/simple;
	bh=GtfR5C9b840K08oo+SPYRgQB4SrBLBp6itcK7VpOH0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNFqPu1gWkhY9kJ4yoPPE3XEiKT3jtbDXUZHEJndPFZNQ5VYkl7ukKAfMh8pu4pIgDm4Os2kPvLzb3YFrNAfm7+ygACcXgQehQNfuXv+Cjdjj5SmmIOx3hPmrZxGigv0qrQ7PyysFVXYI3RupNhXMKF3SCymGqjxI1eWIlElyXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wGwwnSDz; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wGwwnSDz"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hycw867lszlfvpb;
	Sun,  4 Oct 2026 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791153733; x=1793745734; bh=GtfR5C9b840K08oo+SPYRgQB
	4SrBLBp6itcK7VpOH0w=; b=wGwwnSDzAcHWSBa3eVI4QdNWCNPuIEDHYi3mMtuP
	jDvT555QM9nkJiKn6VF64yF+nrCqwp24xjyhVvifAY8qlH+UGjGPHJw6vpsi4mys
	AbPsvpyVDladucMUE1g87dUBD3WmI/ZjBg05qk7ED+ocqtJNcTRkrf3AH/mALpyn
	NIVPVxuVHhN1APaZnz8QLM8CRLZu0sx3CBfyZojx3WqSxwF6JOBSrmi6MRcUc4m2
	xzB3ifsclmqxB2i7nPD8szZNivFRxgzKvwuhT35K9Dcs/SOiQ6XChz7jkNy31Rp+
	62VVWk9LKBfg9cR7FuQArmB/Y1zS8O/5EgN+CiSup9MQvg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LwZAxfT1ooHy; Sun,  4 Oct 2026 22:42:13 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hycw26293zlfvpT;
	Sun,  4 Oct 2026 22:42:10 +0000 (UTC)
Message-ID: <21853b19-d02a-4268-80a7-e457ef813522@acm.org>
Date: Sun, 4 Oct 2026 15:42:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
To: Bean Huo <beanhuo@iokpp.de>, Avri Altman <Avri.Altman@sandisk.com>,
 Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
 <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
 <20261002134158.2844652-1-stanleyjhu@google.com>
 <BL3PR16MB4473EF5053283779F18B4161E5972@BL3PR16MB4473.namprd16.prod.outlook.com>
 <481d737323a2925e68f08e1129e1ca904effbea5.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <481d737323a2925e68f08e1129e1ca904effbea5.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/4/26 3:10 AM, Bean Huo wrote:
> On Sun, 2026-10-04 at 08:21 +0000, Avri Altman wrote:
>>
>>> It was off-list. I asked Avri on Sep 29 about updating the bouncing w=
dc.com
>>> address, and he asked to be removed as a reviewer instead.
>>>
>>> Avri, could you reply with your Acked-by?
>> Acked-by: Avri Altman <avri.altman@sandisk.com>
>>
>> Stanley thanks - sorry for my late response.
>> I do feel that the reviewer role is no longer needed for the ufs drive=
r.
>=20
> A sad day for the UFS driver, we=E2=80=99ve just lost a brilliant revie=
wer!

Thanks Avri for your numerous high-quality reviews of UFS kernel driver
patches!

Bart.
