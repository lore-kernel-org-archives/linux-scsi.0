Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C521D59B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 19:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753732506; cv=none; b=Ir5Yf/9Tw0+3ffnfefqWpMYI8yVCQ2PeNI7DDBq/lVajvq2TjUJ1q0E01016i1Ve6fo3DKRiuR5/GoIUll4i7SUx7W8OyPXsR0T2V22niAY60d50+0kcuhx4CJ1TrnDr2gIkH3sS65UCKNmpt806UIHt6l9u3OjjqpozQ3zw3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753732506; c=relaxed/simple;
	bh=wzOZmKdYr2XDNsPEJe0/216HRPZVpM832zpy6yN02Xg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dnudSPnyFg2B4QQ1S6FRD4YIFiLXARWfUwZ+tkDp+csRI12E1jWiAbk1EAvjnSgWMfiJeIrMXOv+HN6olnwRetPRRsscxXOBE86LJBcbtMgzEgjJMtI2AY0Up5FuN+NWKBYyJ37QWuntStKYULx0yv6euqb+XD9tTSrCHTAOjwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=Vm89DGaE; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="Vm89DGaE"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id g5ogugtGhcOgkgTw1uMKZa; Mon, 28 Jul 2025 19:54:57 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id gTw0uyOOSBuAYgTw0uESgZ; Mon, 28 Jul 2025 19:54:56 +0000
X-Authority-Analysis: v=2.4 cv=PKsJ++qC c=1 sm=1 tr=0 ts=6887d590
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10
 a=VBor_q6NEPEnCzcv8DoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E0qGcwBYr1bbIB0m3Gszulve26FolcFHxXey11owiBc=; b=Vm89DGaExhbK+ngc3b6i4I/rUf
	RrQnvtHhz+3MyGDzr6FkgJpRWT06veaNTq0dtaHqG03LXnyhU07VpDPKBsUdKbq6wktgebm35qrPS
	3xVCmP11OEsOXkVhhJCBpVQ3ErSDmEn4tR9UdMIDU7T3OKRHYhHoEOv/R4DpoUfClyYLjV1G4HIy4
	qRSZkb3BJLEEvaNN1JrY05nPOP0JLbYzJP6xmZPNmHjOIO08mlsWRCx+zvMt0UT6OhHlE3lfMEkcJ
	h670seCNrJEa8Pe7atOWbtWglneO325WPavEQdrv+SshUlKIbda6Bcyb1VfvwavwevtSmveZTQXgK
	gVuaoA4A==;
Received: from [177.238.16.239] (port=40448 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ugTvz-00000000Bbc-1mt8;
	Mon, 28 Jul 2025 14:54:56 -0500
Message-ID: <c157fcc7-9fc0-404d-8fd5-7c60d44a27c9@embeddedor.com>
Date: Mon, 28 Jul 2025 13:54:49 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>,
 Bryan Gurney <bgurney@redhat.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
Content-Language: en-US
In-Reply-To: <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.239
X-Source-L: No
X-Exim-ID: 1ugTvz-00000000Bbc-1mt8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:40448
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 13
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGkIrEi6cKkqikQYcfNwGhg0jmWd0RHth7hGZCTYtia5mhTOqXJXl7lJhRXl2R9DXF2UAwyAVaaY6JVwsJ9rpBwyn2IG/LP/bMOeLTKPYF591Xy3OQU5
 8yXkj1cehTTf1Dq01qzgv6P9S4yk+NWSjrqbsh7DJUovc81aX9waLOHlGfH5qGCgHi7GSi7b9NU2M06m6iiRHulm0oWtM1+2MPaMLzjw6UmMpLiHOjBOLXjV


>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -1077,17 +1077,17 @@ static struct purex_item *
>>   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>>   {
>>       struct purex_item *item = NULL;
>> -    uint8_t item_hdr_size = sizeof(*item);
>>       if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
>> -        item = kzalloc(item_hdr_size +
>> -            (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
>> +        item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
> 
> With the inclusion of `counted_by`, I think `item->size` should be updated
> here:
>          item->size = size;
> 
>>       } else {
>>           if (atomic_inc_return(&vha->default_item.in_use) == 1) {
>> -            item = &vha->default_item;
>> +            item = (struct purex_item *)&vha->default_item;
>>               goto initialize_purex_header;
>>           } else {
>> -            item = kzalloc(item_hdr_size, GFP_ATOMIC);
>> +            item = kzalloc(
>> +                struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
>> +                GFP_ATOMIC);
> 
> ...and here:
>              item->size = QLA_DEFAULT_PAYLOAD_SIZE;
> 
> Then remove `item->size = size;` just before `return item;`

... or probably set to zero `item->size = 0;` ?

Thanks
-Gustavo

