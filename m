Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195636;
	b=qP/5slv2c30WW+hdoXz/m0KdKc/GfNrTWa4vVy0TAC3dBliaOlAL7HjoU6mbCZXxeBXz
	 Pn6uQtja6iSMY8AYQx0gaNqH/zkZfkZso2S1ZnFQB0T9NchTeQR4Nv/vxvgULS+NP0BAL
	 M38sLgoF8OYKynsa5Kat8N/wvAPnb0+5HJ7Fg4x8JWxfhYaMfeh6DweZ1tx0j4ZzVhQML
	 2oVFhHq6ozJ+2KuN1Krp7FvIu6oVAFc3rGXcqs+QQG69STkB5TMBpCsytKKlNmyZQUbjv
	 iuCozZj0y64b7Uee1Ofy4KOV/SRYz76NqWKAMiFaUeAkmjNFww0AwcpjjrnnOnUL7YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195636;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Mf+5HVEfTVCJlO7VMU2yNmH62eEcorD/HlNl9+UzR3o=;
	b=RUQMK1PJmkPDNcGJ32DvnJDU2zDNnbtBGLqb5dgEfYsHkCaN0LRSvp+otVj2VaiREiom
	 rP7rGSjpGSVvL/irNV4kVQfHIuP0LU47zgBHYTFmpqwEkbRjJxP4nywO32N7jdXTZyZvG
	 w72iVFOjqD5sp2UL3UmrjaXaUrxGowKSLoFRkAD5Ehq0N28z1VHrs7mnxuZUx797EWMot
	 5ova2Wn/mFXHhdHeFBt7FYmRS1NRYOrhuqbP2N2f0U6wKQ+ggoEeJ30huGb2cr6ejBIkY
	 z1ITSIPVhHVZYzjukh1UhwAfmwHWS447TTixJrRXucL59tATM5zYKqeAZsnrO4qgS6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUjezWmc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E73606A32C;
	Fri, 20 Nov 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUjezWmc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12CD1F000CA;
	Fri, 20 Nov 2026 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795195635;
	bh=Mf+5HVEfTVCJlO7VMU2yNmH62eEcorD/HlNl9+UzR3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TUjezWmc+HDlIPN51cTI31CAReBjrxQsArm06uhQSw0xzinS7EMijzn6MVCq4wfHG
	 P3gcNxd0tMaBZl3jc66MEdNYsiomByMTGd3UGzCJcD0Q4bR7WQfe4XQMFaBpou/QG7
	 idkQnEhwFEAk5Py+8kOt9VoHITM+Az674YbkbgPKL28gUL2MYv874yI58r/F3mVurQ
	 Tww6c8NgpzWUufeVp+Obl8n1QwW2/h+/dPZMuKSbRfxTDjcbaflJtl7OGK3fQzFyH7
	 qF4BqHzSX0W/JCTm7lZ4dP2bgOHRT9eP4YhgIEkB/xSiwHibWCKNa6Ka07ebakMEcC
	 gE4f/xP5wmRzg==
Message-ID: <ac126584-6fa3-4cdb-b6c3-ec99f75dafff@kernel.org>
Date: Fri, 20 Nov 2026 09:27:15 -0800
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
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-9-dlemoal@kernel.org> <20261120152038.GB26913@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261120152038.GB26913@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/26 07:20, Christoph Hellwig wrote:
> I think the Sashiko comment here needs adressing - nothing in the remove
> path synchronizes against the raw underlying device access.  Lifting the
> stor_elements_lock critical section from zloop_forget_cache to the
> caller and making it unconditional should fix that.

I do not think that is enough because remove and restore drop the stor lock for
the msleep. So this would still be very racy. But adding a disk ref get/put
around remove/restore code should solve all issues cleanly as that will prevent
the drive being removed while these operations are on-going.

> Otherwise this looks good.


-- 
Damien Le Moal
Western Digital Research
