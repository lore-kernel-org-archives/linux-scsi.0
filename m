Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0B02AD00;
	Wed, 12 Aug 2026 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560639; cv=none; b=lcnSfsDYsLyUNDjQTUo2YEi8o7rmRwyRYBpzeYdQUhPN97quAOYcpDNCkevgzXHHLVZdoD+VqEfhLS0b+u5L2clXE5tMGQGnpXqgzLnoOWRYqZMmVGqkApRxZckNGGAce+CJ+lMbWIG63iLIyoZC55zr/jPNZJDVFU2Vxyw7OhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560639; c=relaxed/simple;
	bh=3ccRzMuP4gqu0fgXoWno8PybBKy40A2A/4CMsZwT3GM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WtZ/ZPuLx0fOJucxwg8mzSbCInPmdOoF1BB/xDW/UeVLDzoU3vyZIg+AYU+0OXmGdIsyTPIffDbi7LDgTw7wUsY/Atc87Yr2zrza4xrB73YvCyWbWI1NAyBCQwUYn8a9P1YEEs4oO7LaJWb9xact/E2/+QORVikYnAj09/KgD8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gPc3aWE4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gPc3aWE4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Pm7wIe1C2PI4FMXVf1XL9Kb99YTk38xyDebS5gIgCaU=; b=gPc3aWE41J5xvJYFivx5JZ0JHR
	LXHPLJdEzACRWqUhh67AqqElchySb9yUHiMgTgnCjmut66cygiOmRM2WoS3p33s5A8XwBCu01JNev
	opINhpX2CKxCdWObEFb2sU+T0RjojS6KzRcbPs0UdBfttZ5KWRTkFLzPAMnA9aSJy0ktuiHxHqUgX
	bYSo5hp8cE6+whmXvqYfnYn0BaMgA2LdiLcoTY17ik2HmTdW0O4NYnZmRNtS07xJQ81jJ4Lu+KAxr
	fvjkMoBeAEm2oZxOw0tPt9IdT+gce5Gepfav9UHdVrw6PqG/F3z2HtYu46Lty1wb/vroQTGQTBVrI
	lxiXPP6g==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuE28-0000000GpZd-0EaI;
	Wed, 12 Aug 2026 18:50:36 +0000
Message-ID: <0028f4eb-1b97-46eb-b8f2-c674df118e10@infradead.org>
Date: Wed, 12 Aug 2026 11:50:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] docs: nvme-multipath: Add FC-NVMe marginal state
From: Randy Dunlap <rdunlap@infradead.org>
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
 <52c3bed5-4c66-4baf-a772-6da2b5b7a815@infradead.org>
Content-Language: en-US
In-Reply-To: <52c3bed5-4c66-4baf-a772-6da2b5b7a815@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/12/26 11:46 AM, Randy Dunlap wrote:
> 
> 
> On 8/12/26 11:13 AM, Jesse Taube wrote:
>> Adds documentation for the new marginal state for
>> NVMe over Fibre Channel. Documents how to check and reset the state,
>> as well as a description of how it affects multipath policies.
>>
>> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
>> ---
>>  Documentation/admin-guide/nvme-multipath.rst | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
> 
> 'make htmldocs' build warnings:
> 
> linux-next/Documentation/admin-guide/nvme-multipath.rst:35: WARNING: Title underline too short.
> 
> FC-NVMe
> ---- [docutils]
> linux-next/Documentation/admin-guide/nvme-multipath.rst:50: ERROR: Unexpected indentation. [docutils]

Some fixes below.

>> diff --git a/Documentation/admin-guide/nvme-multipath.rst b/Documentation/admin-guide/nvme-multipath.rst
>> index 97ca1ccef459..8df4235d4d10 100644
>> --- a/Documentation/admin-guide/nvme-multipath.rst
>> +++ b/Documentation/admin-guide/nvme-multipath.rst
>> @@ -31,6 +31,23 @@ To set the desired policy (e.g., round-robin), use one of the following methods:
>>     1. echo -n "round-robin" > /sys/module/nvme_core/parameters/iopolicy
>>     2. or add the "nvme_core.iopolicy=round-robin" to cmdline.
>>  
>> +FC-NVMe
>> +----

    -------

>> +On NVMe over Fibre Channel there is an additional state called `marginal`
>> +All policies will treat this path as offline and will not use it unless
>> +all other paths are marginal or unavailable. In that case, the policy will
>> +select the best path based on the policy.
>> +
>> +To see the current path state, use one of the following methods:
>> +   1. cat /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
>> +   2. cat /sys/devices/virtual/nvme-subsystem/nvme-subsys*/nvme*/state
>> +To reset a path to online use:
>> +   1. echo "Online" > /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
>> +
>> +The marginal state is caused by a
>> +FPIN-LI (Fabric Performance Impact Notification - Link Impact) event.
>> +FPIN-LI event counters can be seen with:
>> +   1. cat /sys/class/fc_host/host*/statistics/fpin_li*

The marginal state is caused by a
FPIN-LI (Fabric Performance Impact Notification - Link Impact) event.
FPIN-LI event counters can be seen with::

  cat /sys/class/fc_host/host*/statistics/fpin_li*


>>  NUMA
>>  ----
> 

-- 
~Randy

