Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113207;
	b=PZgby4EwTYJx/ZHjDQUxd1YKLLaxjX6JHt90mwuKB95/TfvcomkB4B3UbURBXAMsgqP4
	 X6bJEIoal0I+jEDDQlm95pYyQpPOE5kO9B5ZHU7rL+Ecn153CQLeAmq1pzUgEz6wNPpqX
	 ihhbZAHhnEHdUe/xYDq42OGCu2b0AUQhuDSnidyyYDl7Y610Z05KS0cDfXfazBAnMh6eZ
	 RH906/6hOL0VaJnwrX4VHg1+qu7oLhtMaf2pvRfkczRT5CblwzRxUDPfd7RMWTxPBAglv
	 +cJEhYt+okNCBfIXeLlD80vJrCFBhhZ/KOtJXAAYDhnqszGXCvik4lXAsKE3pKYquHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113207;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XHQfiKtPdkI+qQN5A+OAu1s8V87Csk6xJeYTXj1qd6k=;
	b=tMdTvpfyKechapb4VhlJzanq6+1gWOfVSrZPNqNjAzqIZD5GLjAdxPZjiil6ccODQUzG
	 96WoQxh4vtKM8IHAFbOudekZp5Zi8hTscrNLRsV2MfXFrqN4IyhnJTdtgTnljVN4qOtTt
	 EFirGGnB/I3+7tvGrrGcnuzjKp0+KlxYyGIe4TPMe7CBlK483Vv5k0euJUqTEytM1q7bk
	 nVIAxX3k7vEXNa10hj9bR43a9ANdOue/spkKt66GtlAFoUf8SiXwXpAbVamZQkjwiEKZp
	 3a1VUixARof97KfDugjHUEv4QLHcQZS9hynrccbEPZ9QS+Lu6Q+wE9I5dc0Xh2NgMAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Xoe6shP2;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4445606BA82;
	Tue, 27 Oct 2026 15:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4445606BA82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Xoe6shP2
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69REEJWD2607568;
	Tue, 27 Oct 2026 15:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XHQfiKtPdkI+qQN5A+OAu1s8V87Csk
	6xJeYTXj1qd6k=; b=Xoe6shP2qa1RWggo4BXz4wPzW4j/lQIfdP2twBF0Akf3X6
	1rhkAaGChuN+83gUDEaauUf+8lhojRutSGB+iNWJocr4A2PvA5tZ5/BjwYptHsFO
	+t1I1lGlj9DT22VydmXeo1h8vj2ly5wrrLNmAgTz9I8cI6wQbpZ03OIq7kS5MmN4
	TLt+6bnZBLqpL3o+mDNNTKzpSNV9G+ubRtFtX3FJStNTwpL7LvK6/XpYBZsYcvyF
	f0YdQ11rwE2Z8mNkFXgfW0G0689DA9mbv/h9i7CrfBUnZrbIXnhgQIXkIVJz5Xun
	qiigRwpfH83HtBbZzq+jORyRPH5CRwrU55sVTx8A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgj3m87fn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 15:00:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69RDobwk4190222;
	Tue, 27 Oct 2026 15:00:02 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hjtnn8w7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 15:00:02 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69RF01Qh34472642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Oct 2026 15:00:02 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC3EC5803F;
	Tue, 27 Oct 2026 15:00:01 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CA5A58062;
	Tue, 27 Oct 2026 15:00:01 +0000 (GMT)
Received: from e (unknown [9.61.53.188])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 27 Oct 2026 15:00:01 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v16 11/12] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <sashiko-outbox-185519@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 26 Oct 2026 16:31:51 +0000")
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
	<20261026-ibmvfc-fpin-support-v16-11-a900aa657ed5@linux.ibm.com>
	<sashiko-outbox-185519@kernel.org>
Date: Tue, 27 Oct 2026 10:00:00 -0500
Message-ID: <8733trfatr.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA1OCBTYWx0ZWRfXxKf2lhPOyxkK
 cKlMpCDbNdze+eqt5za1ZGyp5JAL7twL4qgy/fCVEF8fWpZRf7r7mG3xzxGRdO+rBiwhPEX9KuY
 ghY1ZYTBZBmZrdovgDCxllG6F3Aeysw=
X-Proofpoint-ORIG-GUID: bEt2tR8JwAiv3Zz_SCQKz5V_NLI-kjrz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA1OCBTYWx0ZWRfX4x71BB+n+q4V
 Or0jMwVQaum4Lf42VWK/vrVaXdCtdEPJ1kpRIzKngNcsRkha0YxIcrOq1xNBOD8hyfEaLMi8Vgq
 yMikBsGYNPUmk4XLHdvwVdRFl1fbc8P8Cg1N8rdM0j3DC9h/43zXs1uKbLQhLNVME91CNbhITXl
 S8Ijsclw9IEJeRwyxnAqbsVO/QauA6vHoQolPmi9HNbq63eIQSMJFh/FOWhPYJP9SzytDUcdq0W
 ifhR5PDIl8fqkxuzIs7XkAC1SbS0YgLdXJ6DU2KybECC1KttrjaEk15gfT4BycoVUgWTlzxP4fG
 1aoJkEFSLvPh7SK7BABzdJzt4hWTeZd23KwR2U2b6hNLdoQD+1xkq3lyZTyAa/BoZkLbiqZL0xP
 u8ITKxD1hxQDIAzojNjphVr4q7KW7Q1/5NkBZ2FkK1SdbpnyGH5vHw1mdfjhIZYEcG+sin+k/yf
 opA1umYOLrivdt0LBRw==
X-Authority-Analysis: v=2.4 cv=G7uJgNk5 c=1 sm=1 tr=0 ts=6ae0bc72 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=zVL8yDj8or86wofaLOcA:9
X-Proofpoint-GUID: bEt2tR8JwAiv3Zz_SCQKz5V_NLI-kjrz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270058

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index af11726b76beb..4d4ebe5f6f123 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -988,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>>  	spin_unlock(vhost->crq.q_lock);
>>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>>  
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>>  
> [ ... ]
>> @@ -1044,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>>  	spin_unlock(vhost->crq.q_lock);
>>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>>  
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>>  
> [ ... ]
>> @@ -6976,25 +6994,45 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  }
>>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
>>  
>> -static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
> [ ... ]
>> +static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>>  				struct ibmvfc_channels *channels)
>>  {
>> +	unsigned long flags;
>>  	int i, j;
>>  
>>  	ENTER;
>>  	if (!vhost->mq_enabled || !channels->scrqs)
>> -		return;
>> +		return 0;
>>  
>>  	for (i = 0; i < channels->max_queues; i++) {
>>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>>  			for (j = i; j > 0; j--)
>>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
>> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>>  			vhost->do_enquiry = 0;
>> -			return;
>> +			vhost->mq_enabled = 0;
>> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +			return -1;
>>  		}
>>  	}
>>  
>>  	LEAVE;
>> +	return 0;
>>  }
> [ ... ]
>> @@ -7083,9 +7102,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>>  	}
>>  }
>>  
> [ ... ]
>> +static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>> +{
>> +	unsigned long flags;
>> +
>> +	ENTER;
>> +	if (!vhost->mq_enabled)
>> +		return;
>> +
>> +	/* register async_sub_crq channel */
>> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
>> +		goto out;
>> +
>> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
>> +		goto release_async_sub_crq;
>> +
>> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
>> +		goto deregister_async_sub_crq;
>> +
>> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
>> +		goto release_scsi_sub_crqs;
>> +
>> +	if (vhost->nvme_enabled) {
>> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
>> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +			vhost->nvme_enabled = 0;
>> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
>> +			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
>> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +			vhost->nvme_enabled = 0;
>> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +		}
>> +	}
>
> [Severity: High]
> Does clearing vhost->do_enquiry and vhost->mq_enabled unconditionally inside
> ibmvfc_reg_sub_crqs() cause inconsistent state and leaked sub-CRQ
> registrations when a later channel set fails to register?
>
> In ibmvfc_init_sub_crqs(), vhost->async_scrqs and vhost->scsi_scrqs are
> allocated and registered first. When vhost->nvme_enabled is set and
> ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs) fails, ibmvfc_init_sub_crqs()
> appears to intend to only disable NVMe by releasing vhost->nvme_scrqs and
> setting vhost->nvme_enabled = 0.
>
> However, because ibmvfc_reg_sub_crqs() has already set vhost->do_enquiry = 0
> and vhost->mq_enabled = 0, multi-queue and channel enquiry are disabled for
> the entire host while vhost->async_scrqs and vhost->scsi_scrqs remain
> allocated and registered with the hypervisor with active IRQ handlers.
>
> Similarly, in ibmvfc_reenable_crq_queue() and ibmvfc_reset_crq():
>
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>
> If registering vhost->async_scrqs succeeds, and a subsequent call to
> ibmvfc_reg_sub_crqs() for vhost->scsi_scrqs or vhost->nvme_scrqs fails,
> vhost->mq_enabled and vhost->do_enquiry are cleared to 0, but the already
> registered channel sets are not deregistered via ibmvfc_dereg_sub_crqs().
>
> Should the caller handle clearing vhost->mq_enabled and vhost->do_enquiry (or
> unwinding previously registered channel sets) instead of clearing those flags
> unconditionally in ibmvfc_reg_sub_crqs()?

The callers will handle deregistering sub CRQs and clearing
vhost->mq_enabled and vhost->do_enquiry in the next revision.

-Dave
