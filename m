Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD6E18CC03
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382905; cv=none; b=LSAeU8RfAx5cNoJuR2/m5DMi8reRG2DtIq8SHdi09ikNQjzKiKF3Qd2phrh7XEemUeMpEArb5oRTkchmZoOK35fS9O/VlNdgJrXpU7tnxWf5INCNJbBhsKKRdYWeYOG8RUtP1W7QWGIZ6m1V0AA+HjYmubWSqbSZr72cco+KU1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382905; c=relaxed/simple;
	bh=JDC1U8Yh1jwXw0aW3ZgRmgJdTXwznf4fWFUK4vN4C6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ok6CgXFXccYlQezLY7eyukAg7fuKg2Ri9TPzQEj5K0dSGOqyOxaFRICjkIhNyOFsu2x6IORftQ9El4TG2r1zerRvnYnmeXI2B6ug3lHlq5w1QgOjqMOpJkAqSLezC+pIqidOZpGKcli8Wgi8BrL+h3j0+YKXc54j4o7prOJPFtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVu/zZs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVu/zZs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B99C32782;
	Tue, 30 Jul 2024 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722382905;
	bh=JDC1U8Yh1jwXw0aW3ZgRmgJdTXwznf4fWFUK4vN4C6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iVu/zZs9CzjgWR8V4/LYrhGXEKjj3YbuwOa3vglISAegJcDH+F/uEp85WsDGCRrGx
	 /0MZO0z0lxF+7PAfs+BJFVMJ7kOW7ppkcx+b/mNq1Udob983PoT5fFQFKUuPTtG7WW
	 va1I4sTC6JMxl/v92s5EkD1+MtiQGS0zK1NAXiJriSJE888f66ktTQrbGxCd3PSGeE
	 YvcMIH8/IHN/j9mEyyFUT8QBBpAOdIRXblC1H0QzOPbErToA5N3Jl7qb1XNGIoitH0
	 BxOqwJ7KvFjAuknFQbXvEkuoofks71lhSCd7wsnlPFjLPWqRdEdnJtHLfJtbbNTwSX
	 IDYGLffPLOBiw==
Message-ID: <27af4997-b76d-441f-90bc-3b4a66923d4b@kernel.org>
Date: Wed, 31 Jul 2024 08:41:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] scsi: sd: Move the sd_remove() function definition
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-2-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Move the sd_remove() function definition such that the sd_shutdown()
> forward declaration can be removed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks fine to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

