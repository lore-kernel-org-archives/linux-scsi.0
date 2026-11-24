Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494109;
	b=syi0iaxWj7hl+3tynMy6r6pWP2BXLjYm8KotXMkYLw0Z14YYTdvBzQqFrSo6Dt+vQU8d
	 LBIIiHEVDc5FtcPhw/LxFzZ0RaO9Eo5kGiHYBnqEoWMQras4XWdl7/uinOS7e3HZYqst1
	 gNf9w/tFhVYiPfJ2+p8y5Tm/qUP3IxKsE1KJYagV/ZwIL6591V1gdQoJ1uJxXZGBpBask
	 gsHCR9THrrKYIQ4Uv+VQ9uQYDiJGo7QXQnkhEeQKTnPaqSKl2uNRnUiOwhvpkqU6pD9cu
	 G18vuyHe75CiwV7wxbdK49dNsz6xFf7fbnNMJu/M5F5J5YJCuRzK2nHPQVZWbl8NViw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494109;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:Content-Language:Organization:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=LKldhxXNiYiC7GZKjd/8KWT/sVAV78Vf7svU52Y0Buc=;
	b=g2Z/RrbeA8zNEXvDAGKjmA3bEPKZTCMf/z9kzMUWFkCCMfP+M7B5x0zhBw1MiOQslxla
	 QgDTU53wV6ZYWk+PYQV87ReE3FRmzDxAVtxCpj0n2FHhBj3vMcZoQcpwZ2gW36UNSK/qC
	 mAtcnqIM+Rc1dm8jZj7vTq2t5m1evT11vMtiD1NpH1jwSYycx96qHLNyZAeJj3BB2yFef
	 gUhrNHit48EhmqwjxH/nQ1nwwpwt9OvepbXPCKYNt2EpDCyUYX4dg8re9kzkGSY0q3hRv
	 78bwBKxgXyIAo8g2DjEX/as14RypNeyw9xbw2VWdd6TDA88UKsJb4BIUa/Bf5j0htRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QktVCE03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530E7606A31E;
	Tue, 24 Nov 2026 04:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QktVCE03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86361F000C0;
	Tue, 24 Nov 2026 04:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795494108;
	bh=LKldhxXNiYiC7GZKjd/8KWT/sVAV78Vf7svU52Y0Buc=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=QktVCE03VFjHzH1vaiVtObRsoO5RQTMo4q8nd7AAo/2bmagWF+9L8he0evEZMb5do
	 c1HsAuBsSmh56SMHmx6LFNqXovZhEpvLuk6c9po9Ra1PcaHI0t0Qq+/hSCuzkOFO+3
	 hGRHc96isBFoOKjPfE9sjv6pzLJk7ZSe77xcc/aNqcV4/V11NfImx8KLm6Almnv4J6
	 cR8yCZl7/UfXCEmi+ucF2TvfrMgFS5gd4QMWv8rvy2ukjA2/sftIywQ3PboKRr5upL
	 u0s998FCNaY4xGb9geDhM6KdCBhIPDZ8wZbhegtx+X2zLRlVB4BCXdqlRm7uil5flr
	 W7fJqeLKrl6qg==
Message-ID: <030447d1-7a63-4a9e-a439-36d56f64327c@kernel.org>
Date: Tue, 24 Nov 2026 13:21:46 +0900
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
 <bebc3f8c-822e-40b8-b7fb-c2fd8277b10f@kernel.org>
 <a0740379-6e93-43eb-a81b-02302423a6f9@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <a0740379-6e93-43eb-a81b-02302423a6f9@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/24/26 01:38, Hannes Reinecke wrote:
> On 11/19/26 1:57 PM, Damien Le Moal wrote:
>> On 11/18/26 23:24, Hannes Reinecke wrote:
>>> On 11/16/26 10:36 PM, Damien Le Moal wrote:
>>>> Emulate the storage element depopulation feature of SMR disks in the
>>>> zloop driver. This emulation is controlled using the new stor_elements
>>>> option. This option can take several values:
>>>>    - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>>>>    - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>>>>      (e.g.  read+write heads)
>>>>    - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>>>>      elements (e.g. pairs of read and write heads)
>>>>
>>>> If enabled with the value 1 or 2, the number of storage elements, or of
>>>> pairs of fractional access storage elements, is automatically calculated
>>>> based on the number of zones of the device so that we have at least 2 and
>>>> at most 32 storage elements or pairs of fractional access storage
>>>> elements.
>>>>
>>>> The mapping of zones to storage elements is defined simply as the modulo
>>>> of a zone number with the number of storage elements for the all access
>>>> storage elements emulation and with the number of storage element pairs
>>>> for the fractional access storage element emulation case. E.g, removing
>>>> a storage element from a set of 4 all access storage elements will
>>>> offline 1 zone every 4 zones.
>>>>
>>>> The storage element management operations are specified with the
>>>> structure zloop_se_ops (struct blk_se_ops).
>>>>
>>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>>> ---
>>>>    .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
>>>>    drivers/block/zloop.c                         | 710 +++++++++++++++++-
>>>>    2 files changed, 694 insertions(+), 27 deletions(-)
>>>>
>>> [ .. ]
>>>> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
>>>> index 6bb68022ab30..1731e4ad5c98 100644
>>>> --- a/drivers/block/zloop.c
>>>> +++ b/drivers/block/zloop.c
>>>> @@ -18,6 +18,7 @@
>>>>    #include <linux/parser.h>
>>>>    #include <linux/seq_file.h>
>>>>    #include <linux/xattr.h>
>>>> +#include <linux/delay.h>
>>>>       /*
>>>>     * Options for adding (and removing) a device.
>>>
>>> [ ..  ]
>>>
>>>> @@ -1149,6 +1699,74 @@ static int zloop_init_zone(struct zloop_device *zlo,
>>>> struct zloop_options *opts,
>>>>        return ret;
>>>>    }
>>>>    +#define ZLOOP_MIN_STOR_ELEMENTS            2
>>>> +#define ZLOOP_MAX_STOR_ELEMENTS            32
>>
>> This one is indeed a limit, so that we do not go crazy on the number of storage
>> elements, resulting in an emulation that is representative of a real disk. Note
>> that for a real disk, this would mean that we have 16-disks (1 head per surface,
>> 2 heads per disk) and no disk today on the market have that many. So this is
>> already "large".
>>
> Well, typically an emulation (on this level) also serves to evaluate
> scaling limitations, where HW limitations are less interesting.
> 
>>>> +#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS    32
>>
>> This one is not a limit, but rather what we aim for when the number of zones is
>> low so that we have a reasonable number of zones per element. Basically, to
>> avoid the rather silly case on one zone per element for small devices.
>>
> Oh, yeah, I get why you set these limits.
> My intention was more to use zloop to precisely evaluate these daft corner cases.

Well, a daft corner case would be a seriously broken HDD FW since the number of
heads is very limited and will be for a long time, until we can invite an
infinitely thin head-arm assembly to go in between an infinite number of very
thin platters :)

> Reviewed-by: Hannes Reinecke <hare@kernel.org>

Thanks.

> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
