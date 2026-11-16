Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870281;
	b=NTfwmf1ClpKkJLDsTrlJhN365imsx5lMICwewVy1Rz/wPDzUKwFE146jcf40tchCxR8m
	 VQtPHCjCYSkLGl8NQLAUoJ5p+w2Lsugczb3zFx1G0Y9tqVFDKmJElE8kCl+v3aTjvMFsw
	 SUfZ6aBiIo6JRRr2FVXMOthvpEybnrFPWYygl6RwnFTQQVasAb1Cplg0WIPtl5B/nYF7F
	 7EVApnJuD4fdkABeukbpL/GwofEpwrrXccoiESgUGXNMhhz5IdM33yfqQkqmz3loLBRyS
	 hcStnDUGGmBs/SMgSJ8bLZOfrlxgGIb1OlFk/vhxNAHnx/Ez2CsNxrO3TLqm4kNuNbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=59h26j36EXapQeg82aYdCBQfQ7s9UKJKsn9I61U5fEc=;
	b=ijbVfUT5v5d5lY0pLHGTwkCrvqsizsBR8McAkpvgLivyymAORRkKQlk0Z/lACA7M4RRB
	 eX2j7AkaqHtT1dP33jC5SiaH/X+78MzFcWUYfF4Z1sMoYtXdAfVoCI3gltjiseTTqOZpg
	 T1ONNZUnN7ZgFhWZB1//ezMh2B42T7D9m5DUSuE6VMeerSWBNwlbnpPwinDHJrfDffGwE
	 PlJFHmzlW+flpsHcK7Y5nep3IsIt8Fq7fSh/oGQgQEich5mQLKlLATL+HIm9UNKCzK+07
	 szdcQwWfhZRalIvMYOsdlX5iDX9JHDhhZSOGXZcFPQZixkXrbJ0+luYIEVKzvRa5ieA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=wZDQQiuB;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A2606A323;
	Mon, 16 Nov 2026 23:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B3A2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=wZDQQiuB
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jT3N852Zfz1XLkrn;
	Mon, 16 Nov 2026 23:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794870278; x=1797462279; bh=59h26j36EXapQeg82aYdCBQf
	Q7s9UKJKsn9I61U5fEc=; b=wZDQQiuBwzyOlCka2avzO3V39W6erKnYwmI99geA
	raiRduSpvWkros2eE6X3HvVwogYXkHr1thRbvk+lGVOj3lQF1HQw9SI6zMucjMI6
	HjpHq/0l/pUkvajEYeNGAMTU4+Kx7Z9GCSvAVt5eXEklsKr/aqbm3rFeZlBGqLmC
	6ArRn17Qqc0ZOd3ghw92LUvuVa2JsP0W2O+oN34DfUGQE4p9o7Apuo1fVRCR088+
	M9rN5O4tG3OQU2yD0jXgn5T+5h2lt11Cbev9hSaY7RwE9lNoJa7HCZfLk84u+Oed
	qCj1RqXdv6gTOOSn9q9ljwFivsyKpCLOZP+zOnxJMV+oLg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W0SspuPOZSBi; Mon, 16 Nov 2026 23:04:38 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jT3N632Vvz1XM0nk;
	Mon, 16 Nov 2026 23:04:38 +0000 (UTC)
Message-ID: <1401d9ab-4075-46fd-8a99-ed818762bb1a@acm.org>
Date: Mon, 16 Nov 2026 15:04:37 -0800
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
Subject: Re: [PATCH] scsi: pm8001: Offset hardware queue index for MSI-X
 pre-vector
To: TJ Adams <tadamsjr@google.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261116224811.3362188-1-tadamsjr@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261116224811.3362188-1-tadamsjr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/26 2:48 PM, TJ Adams wrote:
> -	return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq));
> +	if (pm8001_ha->number_of_intr > 1)
> +		return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq)) + 1;

If "1" in the above statement is not changed into a symbolic constant,
it will be very hard for anyone who reads the code of this driver to
determine where that constant comes from.

Thanks,

Bart.
