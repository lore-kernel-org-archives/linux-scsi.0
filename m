Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A3139901C;
	Wed,  3 Jun 2026 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780502803; cv=none; b=iJTvu4Jkf7HK1hXajiL7C2eMUAsuosfxLmjt3/N72MsTkhgsHtrIkYRo5VybAGoJhMJpTNamCB1OtGpjYmJwGKWNnTcl+XVMDpAw1pOFruZv0A3asLrMp/XTHmBhIFj68n41cJw4lCVUXSncheat5fGUeq6oBRw56Y6VxBzUi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780502803; c=relaxed/simple;
	bh=Tb6pP0YfQO6/h8DFVQ9em29yzCVL4xikLE2t1DmmA4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WU20TQCK0vyYHWAcjkqWG02aWGROTL0JTY/nil2P7DCGh/LpFi0DmdpIIcwGqw+kr4CUwNosy0jE6lT8u7A1v4gB6tglI3SxTdH4wu0L96zCwR3n8t4BwOSVj042+IeV/o3ECUGkJD7HC2A25SJBQEjRZpKIb9I3A9Ok6tykCiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WFhRJGC1; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WFhRJGC1"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gVsyT3ks9z1XM0pF;
	Wed,  3 Jun 2026 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780502790; x=1783094791; bh=bM1kqB2I7ccNsczdRZIIAAZK
	hxV1GPeCnq/iZ+usHRI=; b=WFhRJGC1VTOKqg4nbUqjw8wUmajyhrl20glXCTfd
	LYB7LGRo0dUZiohl1oPSb9dNBvdWnXwnMmMA0GNx8+XQsWCVJ75zMTVO0BGj5gdp
	XKOzAtbjQYtOojx5YiErCZ9mkbgpESywbHaW4VmjrLupv9pcGKK3BxhHOcM+qsgW
	scfdqsdqyFPqX414+BjQZBu+hGLIc+v6Ik94b4VyE37jmMcDwo3JZaBPBEIOgGsM
	5Gn3Yms08CLgGjcq+q4ZbfgW0PkMTOMFBujDZYNYKhTBC7dzA5+PfHwiPf2nOsS6
	aFjMotJljKzXKHXlYaeNl8kur3nL9jPyDQKCRn3/z9pBFg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4C0YUrlqjY_B; Wed,  3 Jun 2026 16:06:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gVsy85MS2z1XM5kW;
	Wed,  3 Jun 2026 16:06:24 +0000 (UTC)
Message-ID: <fe0177c2-815a-46a7-911e-754a27e212d4@acm.org>
Date: Wed, 3 Jun 2026 09:06:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Remove remaining references to the pktcdvd
 driver
To: Catalin Iacob <iacobcatalin@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
 <20260603-remove-pktcdvd-references-v2-1-c4402154d53a@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260603-remove-pktcdvd-references-v2-1-c4402154d53a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/26 6:27 AM, Catalin Iacob wrote:
> Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind some
> CONFIG_CONFIG_CDROM_PKTCDVD* references in defconfigs and around an
> export. Remove them.
> 
> Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
> ---
> Found this incidentally while looking at kernel sources to understand
> what pktcdvd is
> ---
> Changes in v2:
> - Reworded commit message on John Paul Adrian's suggestion to be about
>    the removed references not the export symbol
> - Link to v1: https://patch.msgid.link/20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com
> ---
>   arch/mips/configs/fuloong2e_defconfig    | 1 -
>   arch/mips/configs/ip22_defconfig         | 1 -
>   arch/mips/configs/ip27_defconfig         | 1 -
>   arch/mips/configs/ip30_defconfig         | 1 -
>   arch/mips/configs/jazz_defconfig         | 1 -
>   arch/mips/configs/malta_defconfig        | 1 -
>   arch/mips/configs/malta_kvm_defconfig    | 1 -
>   arch/mips/configs/maltaup_xpa_defconfig  | 1 -
>   arch/mips/configs/rm200_defconfig        | 1 -
>   arch/mips/configs/sb1250_swarm_defconfig | 1 -
>   arch/powerpc/configs/g5_defconfig        | 1 -
>   arch/powerpc/configs/ppc6xx_defconfig    | 1 -
>   arch/sh/configs/sh2007_defconfig         | 1 -
>   arch/sparc/configs/sparc64_defconfig     | 2 --
>   drivers/scsi/scsi_lib.c                  | 8 --------
>   15 files changed, 23 deletions(-)

Shouldn't this be split into two patches - one for the defconfig files
and a second patch for the SCSI core?

Thanks,

Bart.
