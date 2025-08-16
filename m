Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA79133993
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305106; cv=none; b=VDoIJeBrhmbr70sAAhDL7B4dCQ01xAlJR+DOpLopbvKOthXzh4mlWppdIrKczVs7U+dubgtaO8ywg6L1PILP9s1oRbr9qW3Q1WUnksOuDkotr76e0Y3aURJcAz3lPW6ceoh2/e+Jqrcd8Do+QS9YuazMzXaaDV3Lt7PUO5jEbrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305106; c=relaxed/simple;
	bh=3XOlUOpH7lPGABJBBqdBgDsq8o6gp1I3EuGS1FscKFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xg2PpVEb7OY3USNQ5k0PPLl13RRuwnZKqp+Np/qg6rSimAFni4uR37Kimj2e4Pj6hVX2lx9oq+gZiKAV/CrhJUGafnYQsmJI0Gs5Aduyf4C+1+ITJqV5UJfg1HhNC+p95Yx7yMlIHhOUyI9uDF+xZAFb8hIFKWy6f2B2p3z5Zqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7DQLznP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7DQLznP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F25C4CEEB;
	Sat, 16 Aug 2025 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305106;
	bh=3XOlUOpH7lPGABJBBqdBgDsq8o6gp1I3EuGS1FscKFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h7DQLznPJk6XmHnszNrOi4h8kyViFBRfC0VQt5eMNRUSrnc3QcyS77Bv/gm747pfX
	 KMeRE7LTcj8jMktR0p1XqGG3c7BSvbivj5VE6Lw1pMQM9TZMjoZvNOEsYYKghri7CK
	 VayoLzL/PcliawHsxPEq3Iv6kSZzJxU3NoXWsswWjeLXKvwg7kQ3ZCbsvOHX1kYirp
	 au7MyIzsZJfNsu3h41xLC28NaGGWdtUy5CjepMIfTeHqdwa9ulfDmTbCjBXdRveLVF
	 JaIcR5Xe8G0qUBUqT2RhZNbjl3Xu9DeDgYW5/CMHvhihTA2hCPoiqbGjVyMEXuHvfC
	 Pli01umI8TPJQ==
Message-ID: <c21c5d79-1aca-4993-b098-6cc39d648f5a@kernel.org>
Date: Sat, 16 Aug 2025 09:45:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/8] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-6-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-6-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
