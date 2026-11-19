Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795093076;
	b=Pn8lwUM5K+CvaQ2+WS/s76oua4mwQPQXke/hCyOpRkkh9VTn4sFdPLTdpAan0EAdoB37
	 Kr4/ufPgaZkxPSI/DLNODRcOpflx3DC6mQE1TN4iz1z8waTpx+kbKbFFMTXF3qWBa6JpR
	 WmALVYBvEe4P0/HTIHjx9okO0xgGfzcD1aSYxpMXE9G3afIGpGMZSqK6r/evkj3X9mlgf
	 l+6MPFAeEgbhYEY1Vk6TnzclfxmjvrTvUhR7ghqCE3QwUyuO4nonnW76sl9Y+ouX/BjRB
	 EdFkl7PL2eaZMe7JHgy7o7QdzcxlpgBRi4iZsArgfQ9bEhj5GVllLd5sxqCzEA+AIgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093076;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Organization:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=7buAO69HsJQqVmkOp/61inkzCm1HvX813nhgkAHZo8k=;
	b=vIfb/AAiFC6NDrNrm9L24io+TBH8vkb+Qp+MOI1TZd6LqNxFThKq9EaxzeJCSY9t2P3P
	 eea3uW6q1k5sGahAIYJoEojY57nSrK6u/vw1e1nScdO8MzXI2DSJexYMKn2Jf/AapamiD
	 dxdnjz0wxyxckdqu48DfIUvqUfqZI6vAYOAEYPvikaZ8YCz6yui2XT9s31ls4laWzRKVE
	 i8YonY+aGbWBsue/dc/Tw7WAWXYELLf/XZq5cF18yPSKof753SFgaKbhF9fTVt9H2xB0I
	 r0i7V9AhIHHq9DUhytj2FqNWbVzeBgqhsmqg5/vhmami+gdsaueDXQbPFA9snUVqsew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHTQd3aU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B7606A320;
	Thu, 19 Nov 2026 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHTQd3aU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737761F000C6;
	Thu, 19 Nov 2026 12:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795093076;
	bh=7buAO69HsJQqVmkOp/61inkzCm1HvX813nhgkAHZo8k=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=GHTQd3aUHxO+HHKrG5dRFI8a6KNKafcJ/c82THRaqoVJQ82rIhcdX+mymFLgUhEBs
	 X4Uc76aPvtXDZqHOUfZ4wVOHWa8Gf9kWu0MfQWqsbDHU6N2Xs2wHSi0InqxLjeHgEZ
	 rNfMRkYWC0qIZ3PFmkq9J4X8T4CN/Qn4oCXpYRLeP2mH26/djj4qzaY+9Iad2yXIfy
	 QrdtWohWmxd28KSnnrxfZMNT0ISuPPqPEe1NEoZyGjI9wPFolGJaf6ZaCnrsheVQ8+
	 OD0HNJu+3ZpWC5Vc1k0m8YDEKChc6XnVU9zDVTOuTxEVuurBvP2Uo2XsLI2AcMowib
	 zOUq9QzSKxGLA==
Message-ID: <bebc3f8c-822e-40b8-b7fb-c2fd8277b10f@kernel.org>
Date: Thu, 19 Nov 2026 04:57:54 -0800
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
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-9-dlemoal@kernel.org>
 <a102ffd1-7eb3-420d-84eb-eb4705a43b4c@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a102ffd1-7eb3-420d-84eb-eb4705a43b4c@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 23:24, Hannes Reinecke wrote:
> On 11/16/26 10:36 PM, Damien Le Moal wrote:
>> Emulate the storage element depopulation feature of SMR disks in the
>> zloop driver. This emulation is controlled using the new stor_elements
>> option. This option can take several values:
>>   - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>>   - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>>     (e.g.  read+write heads)
>>   - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>>     elements (e.g. pairs of read and write heads)
>>
>> If enabled with the value 1 or 2, the number of storage elements, or of
>> pairs of fractional access storage elements, is automatically calculated
>> based on the number of zones of the device so that we have at least 2 and
>> at most 32 storage elements or pairs of fractional access storage
>> elements.
>>
>> The mapping of zones to storage elements is defined simply as the modulo
>> of a zone number with the number of storage elements for the all access
>> storage elements emulation and with the number of storage element pairs
>> for the fractional access storage element emulation case. E.g, removing
>> a storage element from a set of 4 all access storage elements will
>> offline 1 zone every 4 zones.
>>
>> The storage element management operations are specified with the
>> structure zloop_se_ops (struct blk_se_ops).
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
>>   drivers/block/zloop.c                         | 710 +++++++++++++++++-
>>   2 files changed, 694 insertions(+), 27 deletions(-)
>>
> [ .. ]
>> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
>> index 6bb68022ab30..1731e4ad5c98 100644
>> --- a/drivers/block/zloop.c
>> +++ b/drivers/block/zloop.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/parser.h>
>>   #include <linux/seq_file.h>
>>   #include <linux/xattr.h>
>> +#include <linux/delay.h>
>>   
>>   /*
>>    * Options for adding (and removing) a device.
> 
> [ ..  ]
> 
>> @@ -1149,6 +1699,74 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
>>   	return ret;
>>   }
>>   
>> +#define ZLOOP_MIN_STOR_ELEMENTS			2
>> +#define ZLOOP_MAX_STOR_ELEMENTS			32

This one is indeed a limit, so that we do not go crazy on the number of storage
elements, resulting in an emulation that is representative of a real disk. Note
that for a real disk, this would mean that we have 16-disks (1 head per surface,
2 heads per disk) and no disk today on the market have that many. So this is
already "large".

>> +#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32

This one is not a limit, but rather what we aim for when the number of zones is
low so that we have a reasonable number of zones per element. Basically, to
avoid the rather silly case on one zone per element for small devices.

>> +
> 
> Any particular reason for these limits?
> Can't we infer these limits from other settings
> (eg number of zones)?
> 
> Otherwise looks good.
> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
