Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4B7170A3E;
	Sun,  6 Oct 2024 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728250239; cv=none; b=hhWYBEWmyGEYM79GdeIKubKS25DLwK/l+Sn5MGXU8fYOl1QAUy8xPDznP8iozl5gKC3wD5nVjzRDDHCREsVMroYl2UBCtDCw2iX/VVPwqp2i6ycutyFB8ggj8x7uLWu0IMOARxo39tyKsFvtaGnYdwZoQX8BpErZKhK1pE07ZDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728250239; c=relaxed/simple;
	bh=Go9eVPOOSWgQk0OmiiefFzRe81Cu/dnKZbWfLFJ9e0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSXulPBgzbp1XrRQy7EGuB5dbk89Us7Rmw6ajrfd4WRM3PSXV1DXI92EJUpM9gEur0bAj9H/AKWDP6Kf4dMTMgY8qA+FNyHkFhlBztN9sAXQFQKanPLuJzc4/pZI9wb13uUEpF/JghPW5j4znnbQrnuDNO/nPp3z7JpfvN9Karc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=UE8lX6zd; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="UE8lX6zd"
Received: from fpc (unknown [10.10.165.4])
	by mail.ispras.ru (Postfix) with ESMTPSA id 142104076160;
	Sun,  6 Oct 2024 21:30:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 142104076160
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1728250227;
	bh=2mQSb0GaqmEwoUhYwRKkgCaabkMQpNEdj6q6cM8UJj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UE8lX6zdDQcv0W9BVX8H8wFKaFRZMEMkxKSJW+/9WyIgLSAV6omg8EJ3ioYsEOomz
	 sdsfo275TaQHQqqL4omnw1V71pMwne7zmftgtKucgVz1jSAokaRsc7LwQTO2vMxess
	 PaIdVnbgChejNNr1VTJFf1gLW9cyKne/GberuvEg=
Date: Mon, 7 Oct 2024 00:30:22 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: pktgen: Avoid out-of-range in get_imix_entries
Message-ID: <20241007-509cc8cb5c0e184204e94255-pchelkin@ispras.ru>
References: <20241006210340.3627827-1-artem.chernyshev@red-soft.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241006210340.3627827-1-artem.chernyshev@red-soft.ru>

Hello, Artem.

This should have been sent to networking maintainers, of course. Why was
it sent here to the scsi subsystem??

On Mon, 07. Oct 00:03, Artem Chernyshev wrote:
> Fixes: 52a62f8603f9 ("pktgen: Parse internet mix (imix) input")
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>

The Fixes tag should go just before your Signed-off-by.

I guess it would be helpful for you to have a glance at some examples by
reading the output of `git log --grep="Found by Linux Verification Center"`

Thanks!
