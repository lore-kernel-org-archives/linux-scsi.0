Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2203A1EEA3C;
	Wed, 12 Aug 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560376; cv=none; b=AtwRsdDJ0m9nuRzJvpkWkZN3jJ+uM/65EM/hTK8/ZTIm/XcmtaLqpfg46B48llxNVxyHk2f3EvNzfVKUO3pLAnraubV+q0CqyYqOEdBfY0+vSMRg4In7UCdkS+AvvsllISt6m5LcKLSRpOU5k3RlDp7iXkgaVVh+uCjV7N6iJ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560376; c=relaxed/simple;
	bh=CoJsv+YI/gw+I/FkPkHdoR0AOO+DXK7deAe12IFRxV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fazi4OvCqnP1VJv6/R1vzZOwXZcFH1CYtjt3p8kVCXpEkSJeQbNKy0EzginWBmYeopopPaWNXDmz5xLmLQ1DMeCsUzk2qZIrRkQBjTJ3FSdSuV21H7mhYMpWVPOf2dxo85d21qkOxW//ge0JSkDWkd/oAIjq2LQ0i9ObV+02tC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vu2X01EU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vu2X01EU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Jr+riEGEsS/VOhubSi5DovEz/y3HPj5YnJq+sm5In0g=; b=Vu2X01EU/1bVpG+XkJjiJmgcuf
	9E03KScB/F5OvSyhw8abbrb4MvAtlPWsCgJGHYBGO6G/fpiJlB8zCFz1Ok68ux/FxjOYPX9Bvc8x1
	Q3A+EMxAL23e7W7+wAUYKx+EXoZQMHxwGUFik0Obm/0mV2oht3O8j57ciJzOnSwkeoYKtN0VYrvt2
	ASzVLNesl8Prgc8674UNlih+2z6KbU0OIqMHycSMxkFWPXm6PACaJM5rwsceigBBGAqFYEuwcgPiY
	+wTFNZdO1Gfvxlws8aA909kAt8PXIMOnmshbrjhg6XSwiPRzUtyy0kBZCAPlqD1qn/O47qQzxqAMv
	eKfsX2WQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuDxq-0000000Govz-1gDG;
	Wed, 12 Aug 2026 18:46:10 +0000
Message-ID: <52c3bed5-4c66-4baf-a772-6da2b5b7a815@infradead.org>
Date: Wed, 12 Aug 2026 11:46:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] docs: nvme-multipath: Add FC-NVMe marginal state
To: Jesse Taube <jtaubepe@redhat.com>, linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Justin Tee <justin.tee@broadcom.com>,
 Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
 Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 Hannes Reinecke <hare@suse.de>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, John Meneghini <jmeneghi@redhat.com>,
 Bryan Gurney <bgurney@redhat.com>, Chris Leech <cleech@redhat.com>,
 "Ewan D . Milne" <emilne@redhat.com>, shinichiro.kawasaki@wdc.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-14-jtaubepe@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260812181300.3712426-14-jtaubepe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/12/26 11:13 AM, Jesse Taube wrote:
> Adds documentation for the new marginal state for
> NVMe over Fibre Channel. Documents how to check and reset the state,
> as well as a description of how it affects multipath policies.
> 
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> ---
>  Documentation/admin-guide/nvme-multipath.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

'make htmldocs' build warnings:

linux-next/Documentation/admin-guide/nvme-multipath.rst:35: WARNING: Title underline too short.

FC-NVMe
---- [docutils]
linux-next/Documentation/admin-guide/nvme-multipath.rst:50: ERROR: Unexpected indentation. [docutils]

> diff --git a/Documentation/admin-guide/nvme-multipath.rst b/Documentation/admin-guide/nvme-multipath.rst
> index 97ca1ccef459..8df4235d4d10 100644
> --- a/Documentation/admin-guide/nvme-multipath.rst
> +++ b/Documentation/admin-guide/nvme-multipath.rst
> @@ -31,6 +31,23 @@ To set the desired policy (e.g., round-robin), use one of the following methods:
>     1. echo -n "round-robin" > /sys/module/nvme_core/parameters/iopolicy
>     2. or add the "nvme_core.iopolicy=round-robin" to cmdline.
>  
> +FC-NVMe
> +----
> +On NVMe over Fibre Channel there is an additional state called `marginal`
> +All policies will treat this path as offline and will not use it unless
> +all other paths are marginal or unavailable. In that case, the policy will
> +select the best path based on the policy.
> +
> +To see the current path state, use one of the following methods:
> +   1. cat /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
> +   2. cat /sys/devices/virtual/nvme-subsystem/nvme-subsys*/nvme*/state
> +To reset a path to online use:
> +   1. echo "Online" > /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
> +
> +The marginal state is caused by a
> +FPIN-LI (Fabric Performance Impact Notification - Link Impact) event.
> +FPIN-LI event counters can be seen with:
> +   1. cat /sys/class/fc_host/host*/statistics/fpin_li*
>  
>  NUMA
>  ----

-- 
~Randy

