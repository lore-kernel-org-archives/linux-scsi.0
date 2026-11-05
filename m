Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912107;
	b=Jh6orRq4jZKJkQypSxlmTwekpkNVS//ZZmmfUBaeVLAYl15xYiG4QhwvVmh6A5xnc1LM
	 C7zu+azpgIazXy3uZxADRc1fffg8H2ui6j2+2XZWQ/26UMmnyAcyMrYAx2gvyEp6DBh/t
	 2wo6zs/hKcvIWkbPwLynhEKDVv5PJ+b9d2yMD+b9wCLwKqgMjFAiEvoNhcsOmWYcDq/MK
	 DESTjrnMAOC+IHE2hhoZzScmnRwcxPa9UHOR/1ADlIh1IkZ76stbc7JZWyzc6/at7IugG
	 Z8kgUaefHf+jzkswo2cc7iFzpYhBBIimGXwO4xbkel8vn1dpSss8XOyhLkZUCGnjACg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912107;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=pF08kafzfXvVtCQo/jKb1ohJwGhPhadcAvha2QPeX40=;
	b=KwYUPkikWSVvSnC2otOH9ihaZKJDuOhL7lpIcISq1I6UvFDeI5gYAAGncsns1B2v+/7p
	 wPxuenJysvolL+c49CSZjaX4ite24HQ+ywMBrMXWqH02N5or0kIkV3Dsns5JySZCg5n9t
	 ZymXchcIdxDsqbUM2ojDXniLX/tFK0juTtYe3wRV0sP6CpaQVMCyL+bsujxRg8Tzi27Fg
	 AtdsZUdoaeCczgJ+UB2m8PpNH3IZYPpEwLDba2h6dHSOsUZxs6uc1zp07igtM7FkaTdEl
	 GV1FKa5wVExnpiVA19dR5hL3ok6jZWKqgTBFHGhsKw/j5buHUuZzOQAVBDMlsVoT+6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=odVD9BF7;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC9606A326;
	Thu,  5 Nov 2026 20:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEDC9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=odVD9BF7
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HiI434137722;
	Thu, 5 Nov 2026 20:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=pF08kafzfXvVtCQo/jKb1ohJwGhPha
	dcAvha2QPeX40=; b=odVD9BF7ImgzJEI79G1Ma5PsNnp+Gsy+IGn+MX+Re39/ov
	0az07mUyZE+ysPo3y4kuZBSGULs71Ga2ROHK5IygkyrTtbzcse1hZy05YSpaS097
	sMmoJvqXW+WjosliwYUJ2HdKdaISvS9YbN2Nob5q/FL40OQV0mIQ0PqDl9YlEn5I
	2uQxjXxwdLNAgoBwS1/dvJYtIdTjDZmIJjrAKwf8QMuvJJ4nWVzlPyCV95QRF1aO
	PiFRa04H20IOKQ3XA/xJIfMQ5ZMqAmI7o0q6BjHDotC/KAzWi3m/zalRO9aWGw4f
	+/voXCzInDGDQzmzGoSFQIQkRtX8IW2JzypypJkg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn5rj4n1k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 20:55:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5I4rlG2035692;
	Thu, 5 Nov 2026 20:55:03 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hqv1v2abk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 20:55:03 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A5KsDkM47382896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Nov 2026 20:54:14 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E179658053;
	Thu,  5 Nov 2026 20:55:02 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E68658063;
	Thu,  5 Nov 2026 20:55:02 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Nov 2026 20:55:02 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 05/13] scsi: ibmvfc: fix resource leaks on partial
 queue allocation failure
In-Reply-To: <sashiko-outbox-199681@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 18:00:57 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-5-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199681@kernel.org>
Date: Thu, 05 Nov 2026 14:55:01 -0600
Message-ID: <87h5hv80d6.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3XLtwv6wkYrYSxRsolhcYH9lSSMa_hFD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA4MiBTYWx0ZWRfX8trOI9kD4SxU
 lcPYXF9BsRjWTQp11e1dJpzwtP8KDl2pdlIxTeo7d0dyVlWx2K96Ru+OSxXeFWofZ50ROBvrn6O
 QR8EM1xh0unYkRhYTd3qru4tJMl2e0s=
X-Authority-Analysis: v=2.4 cv=LokHWXdc c=1 sm=1 tr=0 ts=6aeced27 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=FhQ6rqufjDsxu-Tu8ZMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA4MiBTYWx0ZWRfX7/Y03ix9rEAf
 tuivKnDcPNnEiOpWkTEj3PqfRTGJ8DuhomNLhi4Q5RAJSDUw79rX8VbJLfwX4LMW9GOokDa2y59
 KxBzyreRjMXEqEUV/m5uWB21wZzBF1IFAya0+bGrYGDsSUyRpzTG8WlS7QDrq5yd6wO3UJtn+mj
 UH77trx23dVXDIN7jM/uv66wdC5S6sJWKMVkPigsKqjc4GW/lAAQj+1FcLoSrB2ZAIigmw4ItRN
 DG2GNvKbfJH8QZYTJ/yM3f31fn2a1TmXJTWpMjrawQaRXohMxc2XcQBQUkVQ1mEVtqfBUY+d1Az
 bsO4A/QRV/aGKNlhGliBmG3Q+FZqQhFXfyMUDaCUwjmetTAPaxIy4VMlobnepqFa09kEr0C3MuU
 XuNBDbL+hNKjWz5Ldsgjuw99EpjV7Uvk2BJGiZShRi083YNmqvCUh+OZ3yd9tlnRAvEjmx/JI6x
 vcL2CvPfT+wdkSRU1mA==
X-Proofpoint-GUID: 3XLtwv6wkYrYSxRsolhcYH9lSSMa_hFD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050082

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: stale evt_pool state in ibmvfc_free_queue() on partial alloc
> --
>
> commit 226240ace51c2767f2bb52b147409116cfbb8d78
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: fix resource leaks on partial queue allocation failure
>
> This commit guards dma_unmap_single() and free_page() in ibmvfc_free_queue()
> under a queue->msgs.handle check and adds ibmvfc_free_event_pool() calls on
> the error paths of ibmvfc_alloc_queue() after ibmvfc_init_event_pool()
> succeeds.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 77c685f6f959b..e04c80050b981 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -914,9 +914,11 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
>>  {
>>  	struct device *dev = vhost->dev;
>>  
>> -	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
>> -	free_page((unsigned long)queue->msgs.handle);
>> -	queue->msgs.handle = NULL;
>> +	if (queue->msgs.handle) {
>> +		dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
>> +		free_page((unsigned long)queue->msgs.handle);
>> +		queue->msgs.handle = NULL;
>> +	}
>>  
>>  	ibmvfc_free_event_pool(vhost, queue);
>>  }
>> @@ -6303,8 +6305,10 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
>>  	}
>>  
>>  	queue->msgs.handle = (void *)get_zeroed_page(GFP_KERNEL);
>> -	if (!queue->msgs.handle)
>> +	if (!queue->msgs.handle) {
>> +		ibmvfc_free_event_pool(vhost, queue);
>>  		return -ENOMEM;
>> +	}
>>  
>>  	queue->msg_token = dma_map_single(dev, queue->msgs.handle, PAGE_SIZE,
>>  					  DMA_BIDIRECTIONAL);
>> @@ -6312,6 +6316,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
>>  	if (dma_mapping_error(dev, queue->msg_token)) {
>>  		free_page((unsigned long)queue->msgs.handle);
>>  		queue->msgs.handle = NULL;
>> +		ibmvfc_free_event_pool(vhost, queue);
>>  		return -ENOMEM;
>>  	}
>
> [Severity: High]
> The commit message states that guarding dma_unmap_single() and free_page()
> under queue->msgs.handle makes ibmvfc_free_queue() safe to call on a
> partially initialized queue. However, does calling ibmvfc_free_queue() after
> a partial queue allocation failure still trigger a use-after-free,
> double-free, or NULL pointer dereference in ibmvfc_free_event_pool()?
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c, ibmvfc_init_event_pool() sets
> pool->size before allocating pool->events and pool->iu_storage, and does not
> reset pool->size or clear pool->events on failure:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_init_event_pool() {
> 	...
> 	pool->size = queue->total_depth;
> 	pool->events = kzalloc_objs(*pool->events, pool->size);
> 	if (!pool->events)
> 		return -ENOMEM;
>
> 	pool->iu_storage = dma_alloc_coherent(vhost->dev,
> 					      pool->size * sizeof(*pool->iu_storage),
> 					      &pool->iu_token, 0);
>
> 	if (!pool->iu_storage) {
> 		kfree(pool->events);
> 		return -ENOMEM;
> 	}
> 	...
> }
>
> Similarly, when ibmvfc_alloc_queue() fails at get_zeroed_page() or
> dma_mapping_error() and calls ibmvfc_free_event_pool(), pool->events and
> pool->iu_storage are freed, but pool->size, pool->events, and
> pool->iu_storage are left with their old values:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_free_event_pool() {
> 	...
> 	for (i = 0; i < pool->size; ++i) {
> 		list_del(&pool->events[i].queue_list);
> 		BUG_ON(atomic_read(&pool->events[i].free) != 1);
> 		if (pool->events[i].ext_list)
> 			dma_pool_free(vhost->sg_pool,
> 				      pool->events[i].ext_list,
> 				      pool->events[i].ext_list_token);
> 	}
>
> 	kfree(pool->events);
> 	dma_free_coherent(vhost->dev,
> 			  pool->size * sizeof(*pool->iu_storage),
> 			  pool->iu_storage, pool->iu_token);
> 	LEAVE;
> }
>
> Because ibmvfc_free_queue() still calls ibmvfc_free_event_pool()
> unconditionally outside the if (queue->msgs.handle) check, calling
> ibmvfc_free_queue() on a queue after ibmvfc_alloc_queue() fails (for
> IBMVFC_CRQ_FMT or IBMVFC_SUB_CRQ_FMT where queue->total_depth is non-zero)
> will iterate over the stale pool->size and either dereference a NULL
> pool->events pointer or access and free pool->events and pool->iu_storage a
> second time.
>
> Should ibmvfc_free_event_pool() also be guarded or reset pool->size,
> pool->events, and pool->iu_storage so that ibmvfc_free_queue() is safe on a
> partially initialized queue?

These problems aren't reachable as the code stands
today. ibmvfc_alloc_queue() frees the event pool itself on failure, and none
of its callers call ibmvfc_free_queue() on a queue it failed to
allocate. ibmvfc_alloc_channels() unwinds only the queues that
succeeded. ibmvfc_init_crq() and ibmvfc_alloc_mem() return without
freeing. I'll reword the commit message so it doesn't claim
ibmvfc_free_queue() is safe after a failed alloc.

-Dave
