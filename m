Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1C5368D69;
	Thu,  4 Jun 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780588239; cv=none; b=dzzdFxwL8EzCFvSODtq04xu4c3kJOI/CNncQA6qi05mqpE7+73HULYlnxKSsA5ylivv9XITefq353wqcX0E83mXejrybWDYUQ7/52YgSHf6oxeWVIQGj2IYcxmPeOLwff6LShYiAEf8eFtCOLOnacrNtakhLVEvayOxpWMxB4rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780588239; c=relaxed/simple;
	bh=H74fefXSB/12TlG5obTx8TtDvDsyIAuEjpjZbfzKNY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsgmOe6uBU85YZ/UmoMVPt5LD2pTRxR338Ywo9/t0pxxPRk3DdKtHgKZnItMlB50QuTXzjuxnyE9Bd3OuXibawbeNsaXQCvOGT9Vi+mtiD3hMLGBNdjusbDOXdk4GbZ6z3D2087QjR/q/5m9TqmMOoWEttW1SYhp+Ti5aCjnqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FV1leItp; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FV1leItp"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gWTYT3rYXz1XM0pG;
	Thu,  4 Jun 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780588228; x=1783180229; bh=H74fefXSB/12TlG5obTx8TtD
	vDsyIAuEjpjZbfzKNY0=; b=FV1leItpqhi1/DEqhTBuCU8HgUO85wt1mWnrhENw
	HReLD7ocy/HMr61BLSZm+OnX3hhh9y2ZwzHissohXUJJDbUY17LvRTVeqUArZkip
	JRYra0i65DPLfJCkKDXzVytxeeBmAU3VIAa6IcmgdB0f2wL2gdQTY7ST1K9+TCpw
	9xJpkFPE0tKfSUfKoFzpxabEfQMsrthA67LnrT84VxrIFF8YrdkhzY/8OfrA2DBR
	M0Kol/s8F+ujlOXKrGYa3cb8uaF1iPKFGJDYrxudAl8eZSYgW+Ehjnte8KRqxQ8I
	t2znNq6NbWwZhqIjXhHP0VLg+zLUEINqHDu26sZ8tjbF7w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ONraRJRSD5j4; Thu,  4 Jun 2026 15:50:28 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gWTYC3yVrz1XM5kD;
	Thu,  4 Jun 2026 15:50:23 +0000 (UTC)
Message-ID: <96a48e65-6ee2-4b81-91f8-821a2de707db@acm.org>
Date: Thu, 4 Jun 2026 08:50:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] Remove remaining references to the pktcdvd driver
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
 Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
 <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/26 6:20 AM, Catalin Iacob wrote:
> Found this incidentally while looking at kernel sources to understand
> what pktcdvd is
If this series is reposted, please combine patches 1/6 and 2/6. Anyway,
this series looks good to me.

Thanks,

Bart.
