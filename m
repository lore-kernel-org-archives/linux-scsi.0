Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793110101;
	b=k8Knaukqp1Te/MU7i3CJo9F0kKPW+8GOPspzPROmd5YmeRgEhzaRJecPJIeaIRDnOiWB
	 zEzPKRDD1H6gMSXYlErEsEWblkQyl2Sri4sU2nZxQZ4+UXmHWoIq3eggkBbRnCm9z97C+
	 5VvvZt/+llho50ygg5zIBfaqh3ygoig8vuWASusaXgLCkFnFGR5vJSrM5Kcvtls+A+5Zz
	 KSnBdKGnXjBHwZWF5m4+EESc6IK4vZYGFUs/8DgrVCQbuC5OVoRVtltq5FpY0xh2OPTvr
	 uY6isOkr1hDLyUk3sjKaQdwGy0++fO4UiEx8E8Ndp6AA2SWSLArUomPgbwpG5vNhNow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110101;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=yE6Yh8nRyVDcjdtvJCKPkA7gLaolSB4uHiKRdyI0rIM=;
	b=eGar8CuoJEb7DDF7CE5VB8YV/NfgB/Hvg8vlnlB9X9BQeCTPtxwH9ke/oTFF45t/P+PW
	 f8Mv3TI8yzuvudDYQQZ64FeydXRcEGoQ4mjveEDHnO1eQgBapzHUEUEu757gqd7A5b0v7
	 8IFGn7iqH/0oG2dCVDqutq15EuTqDJBhNkVGK8PSoYxe8dhQ+Hpj9cTKBfj1MHsIlSai7
	 Ca7oNI/5yuKPKSP1JKzxDGnpglWYXM3ulucRyLLH0rL0cQ0TJS1+V4D+Arcbe8eatjkb3
	 u4vQoByZ7OFh/hNcJaDq3u1ApWzRC0hDiqzg0vhqGppn7YTw04X77GGk8QQXGS5rBDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ONeMug7g;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BDB606A320;
	Tue, 27 Oct 2026 14:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05BDB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ONeMug7g
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R5iGdG1503999;
	Tue, 27 Oct 2026 14:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yE6Yh8nRyVDcjdtvJCKPkA7gLaolSB
	4uHiKRdyI0rIM=; b=ONeMug7gCA9gVLKwJGAYG5wBuTk3vn+hndjiWb0qKtuSvt
	Sq+JHOYwl70/7psKwmc17vT9kkJ5WemH3mf8pIo2vLqTzCT/lOQv1oeqw30zNTRo
	JHJImEITWNOep2oVG9wq9GIfpfkENQ44xJc8I8tjhNSFMJ0zf5nXXtHLtcMasQYT
	n8dtowMxz8VHH/BSyKUzbW6J8NQNbu16hpk90yLVxHdagoLLP9ZbJa9/3QfA4FFI
	brPBIZmAEK1UT52Fbb3PE8wyXkf2zBx10CQVDQDykctbUBxR2dcA6Q0B1ECurxKp
	c9Y9ro8reQaafXY9hzhnd4CMUr5K/hV28PZOS9fQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgmd6yt30-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 14:08:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69RDoQIL097227;
	Tue, 27 Oct 2026 14:08:17 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8gh307n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 14:08:17 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69RE8HvO14746306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Oct 2026 14:08:17 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 320AE58067;
	Tue, 27 Oct 2026 14:08:17 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EECF05803F;
	Tue, 27 Oct 2026 14:08:16 +0000 (GMT)
Received: from e (unknown [9.61.53.188])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 27 Oct 2026 14:08:16 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v16 09/12] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
In-Reply-To: <sashiko-outbox-185515@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 26 Oct 2026 16:24:16 +0000")
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
	<20261026-ibmvfc-fpin-support-v16-9-a900aa657ed5@linux.ibm.com>
	<sashiko-outbox-185515@kernel.org>
Date: Tue, 27 Oct 2026 09:08:16 -0500
Message-ID: <877bj3fd7z.fsf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=ZYOIpcVA c=1 sm=1 tr=0 ts=6ae0b052 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=lgx1sjMKL3iQhMCxiSoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA1NCBTYWx0ZWRfX8R7td/yXkBtx
 UAPY/VUgvezovDbfodP29QM4Eoy2Rf551Dqj/TANXaOOQ2mvts908pgVgJouP5kVJckfNf2IAH5
 BNcQe1ITTmoKvFoj9jAuP6s/Jwf5k6dZseKSYv/M3bH6C7XAU8u3ZOhMnvy6pHSwU4TLFke/9KR
 e4PSFqTe9oXE+jGV7m0qIoRObHjaf1qo+OVu6lFSz2oqNsXhHur/9vxYxyfjd1tTSihw/2+OB47
 W53wF+TGyGBvU0XQFlBSp/65j2LhiZa2PL6ZlpG8st+SkBUyH2a8G4qqs6AMOXjrD1qPilE7ahr
 B6nx0sCHlIdmZflm4g7WUUSry09Faf4CGrWFP7aj+hGVU4YW1R24uTRfbVhzoj+481Mo6kflXGZ
 i8quVvCDasbY74XdyCnTsyQlEMxtPau3O72X7weuTqJbyAlIn3xkLqPD+dMM20ffCAFfSJ+YoAx
 Ieooq0LYIXPl0Hdx9Pw==
X-Proofpoint-GUID: tw_NDnbAQpGwlypYonKoE-NeZJkApjMT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA1NCBTYWx0ZWRfX/bbufX7Zbrfo
 LqfvyITFTFzI2EyFUWcrzkNIuZeCUaP5fnc3hfBFfitZhDm4jITaAkOokLsBC5FXd4cr2Hfi2mf
 9q4DPqJj26916tbZz3EI9tO7X9/DnHI=
X-Proofpoint-ORIG-GUID: tw_NDnbAQpGwlypYonKoE-NeZJkApjMT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270054

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 64981a5a39fbf..2cb38757333a4 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -4387,6 +4387,72 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  	return crq;
>>  }
>>  
>> +static struct ibmvfc_async_sub_crq *ibmvfc_next_async_scrq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_async_sub_crq *crq;
>> +
>> +	crq = &scrq->msgs.async_scrq[scrq->cur];
>> +	if (crq->valid & 0x80) {
>> +		if (++scrq->cur == scrq->size)
>> +			scrq->cur = 0;
>> +		rmb();
>> +	} else
>> +		crq = NULL;
>> +
>> +	return crq;
>> +}
>> +
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_host *vhost = scrq->vhost;
>> +	struct ibmvfc_async_crq_event ae = {
>> +		.type = IBMVFC_ASYNC_CRQ_SUB,
>> +	};
>> +	struct ibmvfc_async_sub_crq *crq;
>> +	unsigned long flags;
>> +	int done = 0;
>> +
>> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +	spin_lock(scrq->q_lock);
>> +	while (!done) {
>> +		while ((crq = ibmvfc_next_async_scrq(scrq)) != NULL) {
>> +			ae.subq = *crq;
>> +			ibmvfc_handle_async(&ae, scrq->vhost);
>
> [Severity: High]
> Can calling ibmvfc_handle_async() while holding scrq->q_lock trigger a
> lockdep recursive locking warning?
>
> Every struct ibmvfc_queue (including async_scrqs, scsi_scrqs, and nvme_scrqs)
> initializes queue->_lock at the same call site in ibmvfc_alloc_queue():
>
> 	spin_lock_init(&queue->_lock);
> 	queue->q_lock = &queue->_lock;
>
> This places scrq->q_lock, scsi_q[i].q_lock, and nvme_q[i].q_lock into the
> same lockdep class.
>
> When ibmvfc_drain_async_subq() processes a reset-triggering async event
> (such as IBMVFC_AE_RESUME, IBMVFC_AE_LINK_UP, IBMVFC_AE_SCN_FABRIC, or
> IBMVFC_AE_SCN_DOMAIN) while vhost->action is IBMVFC_HOST_ACTION_LOGO_WAIT
> (for example, if a second async event arrives while NPIV logout is in flight
> with vhost->using_channels set) or vhost->state is IBMVFC_HOST_OFFLINE, the
> call chain reaches ibmvfc_purge_requests():
>
>   ibmvfc_drain_async_subq()
>     spin_lock(scrq->q_lock)
>     ibmvfc_handle_async()
>       __ibmvfc_reset_host()
>         ibmvfc_hard_reset_host()
>           ibmvfc_purge_requests()
>
> In ibmvfc_purge_requests(), the loops over active SCSI and NVMe sub-queues
> acquire scsi_q[i].q_lock and nvme_q[i].q_lock at subclass 0 while
> scrq->q_lock of the same lockdep class is still held:
>
> 	for (i = 0; i < shwqs; i++) {
> 		spin_lock_irqsave(scsi_q[i].q_lock, flags);
> 		spin_lock(&scsi_q[i].l_lock);
> 		...
> 	}
>
> 	for (i = 0; i < nhwqs; i++) {
> 		spin_lock_irqsave(nvme_q[i].q_lock, flags);
> 		spin_lock(&nvme_q[i].l_lock);
> 		...
> 	}
>
> Should async sub-queue locks use a separate lockdep class or subclass, or
> should ibmvfc_handle_async() be called without holding scrq->q_lock?

I'm rewriting ibmvfc_drain_async_subq() to create a list of events to
handle, similar to the way ibmvfc_drain_sub_crq() does it, then unlock
the queue lock, and then call ibmvfc_handle_async() for each event. This
resolves the lockdep issue.

-Dave
