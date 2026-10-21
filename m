Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600650;
	b=JDP6C40FkENIBrav2CR+M1WnKIg8/9OnX6iTTmw7xGt80mBnKV2E+I4skStm9U7uE5G4
	 XtJu+yebHaiSQndKqCXsTws/dESnboI7yJqCWsR62JxlHh4kvbBnI4B9W9iiN0VlRD/6D
	 67Tuu9+u35vVTrSSzlFxvtQnZKplcSoXHmrk//NfIbDuHBKmYUI5oGucrs3GFAJtDd14b
	 HeNq4VRoKbI7WxlONeoGxW4DvmcAyobTcJ7rJvqwYWa4+Eyzh+ympTwRkPJfjC4ovAVId
	 k51jct3q6Dvv+Vj4puQMBF7EsWBqFlMRnPaF8zNEXywml7L0GTeuRLJFKfklyFvuOPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600650;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YLCxMKcoPqJQvB6O+KV4fn7PG1sEtJ+RVWenhox/UVk=;
	b=xvOmuG4akAfMaLryuXeRnxE/8BXvrfSQZBZx8lhF83kyPqOeqmsH9DGA7EF2PeoNTvnR
	 VeNbGK0Er9qRSAZMfQCSB59yauKsPFjrJ7HqGbts2ZGmMwKGzO0KpzbeDwnk5oy1ibJ87
	 5BY9XMtoalv3T5uRDFYYJr/JwiAb51E4nY7roQu6SAVY8ofTtuv7/6nIDP54fRMngYp6z
	 gwRkY6ynqPn3ozYmt1zpIovoj7LpcHwnvVgIICIY4dCnx/EpraSeeK1XaMibzc6zJX6WB
	 IXiWQHoWHgKpdRpu8EHSrgCFSwbWY+K7ZeUR1US5kWnADpq1P7iAEfFvkAwyqXwxu5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=W0F44w4k;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B962A606A31E;
	Wed, 21 Oct 2026 16:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B962A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=W0F44w4k
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8w1P0dpKz1XM4Tn;
	Wed, 21 Oct 2026 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792600645; x=1795192646; bh=YLCxMKcoPqJQvB6O+KV4fn7P
	G1sEtJ+RVWenhox/UVk=; b=W0F44w4kMysnjqfe10crB0r4/w1Yzt8bKB3ayzBW
	IOWFsntacPGYef7vUzP7UAtjURQClKa735i4DvUpGE4IsQEgYi2wR60Pup/Wdnxi
	ImBMz2TKQ8+IfZ5dNMHR1QXBfHH8bWBsGZnxcZGbDBGtykpCrzL0PgTjpIT8B4fj
	s5Qtom2aERpqDd/2auNwgyMAubA3EOruaafByt3X+qrBXwpQych9IpmdmBdIgINX
	1wo1NbUxVwahvgkFk1dzbgiokPn5aGc4rDoGGe4tCKNMJqP9hshisF5FFWtgGlxi
	lT5izhQ1z7EWm6fZKTclyrGi9+SToe2oxnhDxEGRrD82bg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 56L81EbwRjUK; Wed, 21 Oct 2026 16:37:25 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8w1J3QJwz1XM4Tl;
	Wed, 21 Oct 2026 16:37:24 +0000 (UTC)
Message-ID: <fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org>
Date: Wed, 21 Oct 2026 09:37:23 -0700
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
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
To: Stanley Jhu <stanleyjhu@google.com>, Peter Wang <peter.wang@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261021035450.3488805-1-stanleyjhu@google.com>
 <20261021040615.3566831-1-stanleyjhu@google.com>
 <20261021040615.3566831-3-stanleyjhu@google.com>
 <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
 <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/26 6:28 AM, Stanley Jhu wrote:
> A return value of 0 here means the completion path, rather than
> this abort path, has claimed the tag and may still be running
> ufshcd_release_scsi_cmd() after it dropped outstanding_lock.
Do we really need the code that checks that a command has completed
without notification interrupt? I have never encountered any logs on
any test setup that indicates that this happened.

Thanks,

Bart.
