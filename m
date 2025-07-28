Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3B5137923
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753743331; cv=none; b=RkUa/ZMQHgQeNU9GzhXKgab1RJ2BfDGTCJgszHuRB+hyLTUPgm72WGX5phYrMqqka4H2Fzt8OB5jC4RC7swajztUold/cw9FefswMQVJXfI5VH0/M2fUEy7cruWRHc6PisuH6R+ybgvYyS8v5pHD/lv/DJ0thUMr28y9B2heQD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753743331; c=relaxed/simple;
	bh=bcUkzkFrkJcz2ljLwv8PAIsKYEFzm924u01GvZqWxzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c0S24SAQYD5HCjrcq6w6PeniZqFkXT1OsRMLEAkKoixEZqkd5AgKmbVlkl3pElcIY11zyualuXSI23+mJYwabfeHFwW3b7eBA7t+d9xPCzyq+UeQsQb10BlZCDrm1lj1qfv15YcHwOyirQsL9tkvE+9pfO71y9BzXU3E/v879i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=yXgv4wcB; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="yXgv4wcB"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id gOPkuOcuhuKaFgWkduZVBK; Mon, 28 Jul 2025 22:55:23 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id gWkcuk0EC19hEgWkduuP0o; Mon, 28 Jul 2025 22:55:23 +0000
X-Authority-Analysis: v=2.4 cv=F8ScdbhN c=1 sm=1 tr=0 ts=6887ffdb
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10
 a=sn5CVzENbF_ouhoeq3MA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MHkMvwiiDzh6dqiOwSbRGtsD5e/xZB7KY9HnIYqgtO4=; b=yXgv4wcBaJ3d1xKvNatMYQ45up
	H7bgCPRXbmwxjWuuEJ5htT/Ss90lK5NvTGwSoJTKORVU9FrUiDMptYIwtacWBNuJXJWGeD0raekxR
	pdmvZ8m38SOaM/BV48lFXO89PkyjtRM/6ScinO0G8Trk3XQ7ITKSGW7MxDSuBtk0KsS7va2m/bVAs
	Qtzdisbfrm/m/4H/gY+9g4Ut3uX77fewvFsisrC0odYP0wEBGALKrMK4KIxW+s1ha++238c8XrN6O
	zZH/xwx3d/uG+ez/sFTGiC+fAO/iD8OimdNoaH+npMXVTxIXaT4qwUF9ys7EoJta6gHVjLNtc9VKT
	3Frn1bGw==;
Received: from [177.238.16.239] (port=44066 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ugWkc-000000044nD-1KgR;
	Mon, 28 Jul 2025 17:55:22 -0500
Message-ID: <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
Date: Mon, 28 Jul 2025 16:55:12 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
 Kees Cook <kees@kernel.org>, Bryan Gurney <bgurney@redhat.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
 <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.239
X-Source-L: No
X-Exim-ID: 1ugWkc-000000044nD-1KgR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:44066
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNZi2NnisR4kVyCEOHAK3MQ6kFcYVAe5Yyh4ZWaRcmefhBuDvRYqLRtLwYH8fbR2dFfDc/isDtFkJquwJiT2649snVKTQ3x6pZGyhp1ITbA8RmNt4TuD
 QNrCXV9oes5JNvb7uEf0tAlJ+BNSWZbOXMAKuY7SURMN6s/mS6K7TqNyc9CbSBPhLyBPjlbvZ/wFvrhvFI9kMH4TPiOFUv/iBBtB5EOZHHp/vlZYcZt3/7oE



On 28/07/25 15:15, Chris Leech wrote:
> On Mon, Jul 28, 2025 at 01:43:10PM -0600, Gustavo A. R. Silva wrote:
>> On 28/07/25 12:57, Chris Leech wrote:
>>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>>> index fe98c76e9be32..a00c06a9898ec 100644
>>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>>> @@ -1077,17 +1077,17 @@ static struct purex_item *
>>>    qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>>>    {
>>>    	struct purex_item *item = NULL;
>>> -	uint8_t item_hdr_size = sizeof(*item);
>>>    	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
>>> -		item = kzalloc(item_hdr_size +
>>> -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
>>> +		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
>>
>> With the inclusion of `counted_by`, I think `item->size` should be updated
>> here:
>> 		item->size = size;
>>
>>>    	} else {
>>>    		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
>>> -			item = &vha->default_item;
>>> +			item = (struct purex_item *)&vha->default_item;
>>>    			goto initialize_purex_header;
>>>    		} else {
>>> -			item = kzalloc(item_hdr_size, GFP_ATOMIC);
>>> +			item = kzalloc(
>>> +				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
>>> +				GFP_ATOMIC);
>>
>> ...and here:
>> 			item->size = QLA_DEFAULT_PAYLOAD_SIZE;
>>
>> Then remove `item->size = size;` just before `return item;`
> 
> Hmm, I don't think I agree with that. The single assignment before
> returning just keeps the allocation failure check in one place.
> The conditional nesting in this function is a little odd, but I don't
> want to start reworking it completly for this.
> 
> Is there a problem with the size referenced by counted_by potentially
> being smaller than the allocation?  That looks possible in the case of
> using the single pre-allocated default_item, but not needing to use the
> entire 64-bytes (I don't know if that happens).

But if both allocations for `struct purex_item *item` fail, then
you'd end up with a flexible-array member of size 0, and `item->size`
potentially being greater than zero, since `default_item` doesn't
contain `uint8_t iocb[64];` anymore (it was turned into flex-array
member `uint8_t iocb[] __counted_by(size);`)... unless I'm missing
something?

Thanks
-Gustavo
