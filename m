Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940789;
	b=H9PEJz8o1EXkZ6GXjgIlxUEudn0Gj2SZJfjylCErQ5yjuVQ7tG6pbutjNbfxQERcE1Hj
	 dn5tP5w1DzO9NP1+bJuOvK4p795kJxmd6MqvfUIk3PtkK9pBug8uCnTOeO+AL3jsKxwQv
	 PeZYcgS0jEprryjh9Sw8bsHMaVQN24tMCtfxHH0fnsCixef8N7gaj+jXM6un31TipXz/a
	 boHtFJcQkfqfzkSDEhOenO4OTfJtP74J9xqpE8KkGQE3D0/zXcfghMmymGZGr7g0B7kog
	 moDCWWJ8APbVrUAd0SmKb+utdxtxOL5MLxtH/l0rOrFFdc7c6+V3Z0KyPksK17dHUeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=A3iaojd0u5LRYK47IOsfEQKjoWfkfMB3b9TkiZxTL+U=;
	b=1MgocmqbsyTKwHYPsTKVukeNj/hgq48IFTqh7sAIn2WfJq6MNOi+PN01wbrNfauQXAFx
	 5GqkdzqipM76d/IzsufQXvaFb2MXcmH0qz75hiXJs9K4+e7cZ8TZwU+NaC4V8pNgpmuB2
	 NaIDBZRzevf7h1qZEUWSRDQkJakvRoAjYloSSSvvUu/cQgybOFR5AnD/9kbCW9X6xXmpB
	 WHxv30HvRAynsyBCKlsF+NXRG8mekzEz00qzzTIaT/R5L66NsyzDLjgiypbtBmLkL2acB
	 cqkYGMo75ruzmuQCyckUj/eJwbglTeaxgn6XeVbTJSShF6FifjNIqWtudnmJaY7rujg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JRQGFzbc;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C3606A31B;
	Fri,  6 Nov 2026 04:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A1C3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JRQGFzbc
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jLRdH6jJBzlfvq8;
	Fri,  6 Nov 2026 04:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793940786; x=1796532787; bh=A3iaojd0u5LRYK47IOsfEQKj
	oWfkfMB3b9TkiZxTL+U=; b=JRQGFzbcXFWA/RHLUmIwBAmTWWd8PStSbtucWuGE
	kVfTpZvsE8TWVXWTPYx9MsbY3VpMbixh/b/k6moI10XFN0z6nCkZzTgltQCksGDa
	b/D8AXSCrp+JSMIqVxReQ0bc3BvJvrOPMTXwZGnfWDF4k8C4kJL6C8S6GZ4k9ZQY
	uX3LMO1QGGorQ1dl7oBmJJZ2MoxWBMSowN/YCkESlchcbl3pm+VKx2tmjqmOt+3c
	5V/1DtmgBFJS9aU+m2UdIUU/A482MVlmTm5LqooguHEIIEj549koym3TIjyWxpRa
	XZphBENkXWlscTdAOrNJykidtwyQ1nxCLi+lFHi4wUhuDQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QxKiEhXhh_Dn; Fri,  6 Nov 2026 04:53:06 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRdF5DV0zlfvq7;
	Fri,  6 Nov 2026 04:53:05 +0000 (UTC)
Message-ID: <1029b915-d467-4bdc-9ed5-90fd4391e66a@acm.org>
Date: Thu, 5 Nov 2026 20:53:05 -0800
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
Subject: Re: [PATCH v7 2/2] scsi: ufs: mcq: poll OCS after sq cleanup for
 device management commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <cover.1793938245.git.kwmad.kim@samsung.com>
 <CGME20261106041303epcas2p19b0c317d409503c833ae125ba91fe053@epcas2p1.samsung.com>
 <a1af44cd90dca0dd8a9a06d09a254a4e7e0861b2.1793938245.git.kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a1af44cd90dca0dd8a9a06d09a254a4e7e0861b2.1793938245.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 8:12 PM, Kiwoong Kim wrote:
 > +static enum utp_ocs ufshcd_mcq_poll_ocs(struct ufs_hba *hba,
 > +					struct ufs_hw_queue *hwq,
 > +					struct ufshcd_lrb *lrbp)
 > +{
 > +	ufshcd_mcq_poll_cqe_lock(hba, hwq);
 > +
 > +	guard(spinlock_irqsave)(&hwq->cq_lock);
 > +	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
 > +}

As mentioned before, READ_ONCE() is not necessary since the OCS is read
with cq_lock held.

 > means the cleanup has completed.
 > The UFSHCI specification says "The host controller shall free up

Please insert a blank line before "The UFSHCI specification says" and
mention the version and section number of the UFSHCI specification.

With the above addressed, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
