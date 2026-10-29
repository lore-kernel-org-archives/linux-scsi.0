Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290949;
	b=VhNKrs2QFvroqXNcfgIF63Z+mHh9UU+fPw4NVOAR7qSoe9U4kPSIp13qsQFGZDXpGcmG
	 g8Ea+p3P/5iVkmAOo11eSai6DtxnO70fZq72n6h/dLLLOSwH4QYGDasEtO85fGyLawGQc
	 NHe4MnWboVg6EE/4NaBBmbKFfNcbvnu7Vfsqxq7iQqFo23FJXPgoa04SCmOtPuVVtndZF
	 SLD6APJoKAlTZiFxmzzXiipL/oyZ+V/IkLGrj3FMT6C1HzoXiuJw4Ngc9QeLhqGppjmdB
	 1H3toGrYUVTFdMfK9LfWnTVExDol5Lt66r/AsLJkbar/EzqxG/NxvCIzqITi/bPaoPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290949;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=UnHaiT6f8rBQ6CKI63CHdhJ/Xr/kcs3vREBrCKJzks0=;
	b=1Cqb/R9fl3+BG3Ils7EK73hTRarhFVUU8IHhczlgGd8Zroc8ciBVtDKIMywm9KFfl5gT
	 SXRc3tPSjnvCKyetODAhVwUUu44Ncn0lt/vQW2ybnzLJ4yemgQVEL5R0wix+VQrMxyiVI
	 USKd30Qj9jSIgno/CwahHAIts5RwvYO0E/Ibga5XNHTwTNLr3PRYhUBB/O9c5ME1MVjrs
	 0chiyr/7F5d09FnTxLVta+UwYLwF7uxI63dH98jbU3n9P46LXBEUhTOvBoKR1UY53MaBE
	 tSKElFr55Q5w183gfLM6hf+rc0iqzq2++5RasBBSbMNj25kjbAbfeDel95SS8G9ybIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v6P00A4d;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36423606A31E;
	Thu, 29 Oct 2026 16:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36423606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v6P00A4d
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jFqJN4FfLz1XM30h;
	Thu, 29 Oct 2026 16:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793290945; x=1795882946; bh=UnHaiT6f8rBQ6CKI63CHdhJ/
	Xr/kcs3vREBrCKJzks0=; b=v6P00A4dD14HahslZHsrMfKF3/GViNJxl7zDfAGg
	qr1OeHdDhp+b+Pyn7ad0oCbYrZvG+0Zk2ks/heZc/yUdYmkeSvEnjqzxdygW7wIM
	cKOH9/LsZVSH64+eIXeABM2Fx8PjDGcX4Ig6HFIHdXf/Wffcexw57DlW9hJw9OSq
	hV67OpqRRiZw8gWu4Eoa03Jp/ebasenzq71xCVECoW1DCja8ynI/02dt72xLqqgt
	wZ+993x+XD5y2+We9kM3nfKnaMfhG36CmGBvYAzWl53ltmaJCxc+KH7IIGsX6NX7
	vr81gQtWygtEaxtPkJfE0nag8WwKGH46d1g9xfDinFqytw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FmKFEPZA3eRk; Thu, 29 Oct 2026 16:22:25 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jFqJJ3gTQz1XM4Tl;
	Thu, 29 Oct 2026 16:22:24 +0000 (UTC)
Message-ID: <8125a75a-ea47-49f8-90e4-7f7c83db90e2@acm.org>
Date: Thu, 29 Oct 2026 09:22:23 -0700
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
Subject: Re: [PATCH] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when
 already active
To: Stanley Jhu <stanleyjhu@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261029040001.2100001-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261029040001.2100001-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 12:08 AM, Stanley Jhu wrote:
> 2. The first runtime resume fails in the driver callback, and
>     blk_post_runtime_resume() sets q->rpm_status to RPM_ACTIVE and calls
>     blk_clear_pm_only(), decrementing q->pm_only from 1 to 0 so recovery
>     commands can enter the queue (intended since
>     commit 6e1fcab00a23 ("scsi: block: pm: Always set request queue
>     runtime active in blk_post_runtime_resume()")).

q->rpm_status should be changed back to RPM_SUSPENDED if a runtime
resume fails. The changes made my this patch don't look right to me.

Bart.
