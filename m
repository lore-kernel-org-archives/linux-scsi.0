Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601081;
	b=biAaCr+VYiwrajK8VgHYB7qfrnpcOZlxwi8JZEETAPk2fFygH0UG6YuVlWY2lxl8djzc
	 ATM1K32ryN4fcEaDDomLvB4gZ+fJAvFJ7/11eLIQVCtQp5vIJJ4GzBtr0ef7fJeac/A0S
	 uZzueSpcMNXx8tOUX91H02dmYjmlykFwd58AyNfIBYCZ2SMDcmiuuH1tRmpEyfof7nQzw
	 6z3uIH7uN+XT6o6K6iWj4SZ72OqSkA73hoYA96Ou+1VDPzAvjsbwXxye317HzGHi6wBVd
	 qi39fmDTjjvmgVF4BsM2llEzmfzgfi5GBpe9Yx5DsLkIHxM4PwnHKmCkW5vVWE4MufA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601081;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=e31l6mY+7kYwd3xTWE7F78PbWC6bDsSOvajR5yk1q0Q=;
	b=V3A5NwFtI2hEvMAP8Mpqdm8v4JVtQJ0an1uzuyVjum06dpBPqC+og728dSvGoLYJ18it
	 pYnO2rOadmce7wIWEFUQIT302rro0V8rl+RjqkM1C3vxnE50LQZ9O/LoHF4ZKeAC2Fkhi
	 Z/oZSg6CUHN73EhzpnsQAFqMk4wPjFKlksRJCewgyLr6QhE+ripwayyAVyWF3UO7VSc3c
	 7fMrHA3ecqGlLudrzRRrb3VCbpQTC0C9v9xtqkAQGB73DZOOULDwHQnGdMnDkjaJq4VUW
	 3SqNdbCXtLx1IPjUFXsxGSe0ugRx88YviVxEkjkO/74UPf+JwyaQ3UFPt8lfbubbIfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=hZjVbvzb;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1005606A31A;
	Wed, 21 Oct 2026 16:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1005606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=hZjVbvzb
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFi9Lh1594211;
	Wed, 21 Oct 2026 16:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=e31l6mY+7kYwd3xTWE7F78PbWC6bDs
	SOvajR5yk1q0Q=; b=hZjVbvzbnfBdfrfEouGwGEHlBEbZ1H9zAyppysPDf28l+C
	ugCZyuChKKUIUB+o/+Fvh4epHLVEuZNkQHl5PE84Pp43DWU9gT1kGisjY8DSBMd6
	swRT/aKLkV9Cqjl+HQyhzxhAK/UuA/6QI+K+2vuSmLqXpaeXLn4J8t59355F1vtY
	5loLBWbi65NqJyGPgvYAPSRkzgJ/1K7agGxeyuAxB+CJ3tjSrCadA6ZSf7v/8ffP
	xlxNthvmQWjGh8V1aQZlNh4auqy+zfgw6dBAb/rFUo1ciZJJ92oxyoCgeA0rKCp6
	anof4hFvbRvDEBdW5QmpaEjokTj7khofVqt+//hw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5a21ny-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 16:44:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFZ3NV2114770;
	Wed, 21 Oct 2026 16:44:36 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hefss3ycc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 16:44:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69LGiaNa18022940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 16:44:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C9F258059;
	Wed, 21 Oct 2026 16:44:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD94158053;
	Wed, 21 Oct 2026 16:44:35 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 Oct 2026 16:44:35 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v15 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <sashiko-outbox-178317@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 19 Oct 2026 22:26:13 +0000")
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
	<20261019-ibmvfc-fpin-support-v15-10-a858726e178a@linux.ibm.com>
	<sashiko-outbox-178317@kernel.org>
Date: Wed, 21 Oct 2026 11:44:35 -0500
Message-ID: <87mrs7vw98.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NiBTYWx0ZWRfX1rKyDk4OHIQt
 c3A6TKrbIMXxHg01KBTUJeT1E2l4Fw2T8nI4qPF0hgz/IIiNKM2gv4UXVZHnIHMcmBzUwZX1l0E
 EOcj7j6VLaJJPGLK0rNKJQGSrBi/sIJtKy3sQCnVx/rKa+0Gv6UJmS5PzPJptRdWsCdeps8rQHc
 R0h7m9WDOMT5OOOcWBT0d+vs9ei+hZd8+QljLhi/46V5MmvYRgneBMdpY5xTMsQK/5numtvD7BE
 fgEMBik87C5fkCg1L1zdD8oMquinbmyZYszjfPoUhulmUe/wMs5GPpcQTorY52gpx9guRjDuKsV
 zMTdFk6/XZuC8ZYWwyGyu//Bc+aDYVEpMFtFt5HXqqFkM/bW8eyWaug20QL7NALoBaeVCSJ4+aD
 crP+59FBebKP7CEuNG9ezRq/gybCVoiFgKQh7cM+EAnIm7SiLgAJM3vtfiJSxz/HDESYqf+fQXt
 AoifjVkgbiIsq4P/hhw==
X-Proofpoint-ORIG-GUID: As4tNAfLRz_PnAozmdP2Iln76U5AOS3W
X-Proofpoint-GUID: As4tNAfLRz_PnAozmdP2Iln76U5AOS3W
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NiBTYWx0ZWRfX+Co6Ye2EElRg
 YhSt1kvVNbHELG3Nq0iYEs7DlmtiIhCEd8GKPijP+xhNlKN6kpD90GGYCuFqvSt9feTccKglZkB
 JH9TffaFA1bkl7QGyk+l7pEcyugflco=
X-Authority-Analysis: v=2.4 cv=ZfSIpcVA c=1 sm=1 tr=0 ts=6ad8ebf5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=lttzEiji57sduyQuKiQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210066

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi: ibmvfc: clearing mq_enabled in ibmvfc_reg_sub_crqs() skips deregistration
> - [High] scsi: ibmvfc: ibmvfc_init_sub_crqs() ignores ibmvfc_reg_sub_crqs() failures
> --
>
> commit 97f68806c8ca0b8cd795db2454a75c5e092d7ae9
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>
> This commit wires the asynchronous sub-CRQ into the sub-CRQ lifecycle by
> allocating, registering, and freeing vhost->async_scrqs alongside the SCSI
> and NVMe channel queues. It also updates channel setup and login info to
> handle the async sub-CRQ and multi-queue capabilities.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 7e012281d368c..0d603542fe348 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -6977,6 +6995,7 @@ EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
>>  static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>>  				struct ibmvfc_channels *channels)
>>  {
>> +	unsigned long flags;
>>  	int i, j;
>>  
>>  	ENTER;
>> @@ -6987,7 +7006,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>>  			for (j = i; j > 0; j--)
>>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
>> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>>  			vhost->do_enquiry = 0;
>> +			vhost->mq_enabled = 0;
>> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>>  			return;
>>  		}
>>  	}
>
> [Severity: High]
> Does clearing vhost->mq_enabled here prevent previously registered channel
> sets from ever being deregistered?
>
> In ibmvfc_init_sub_crqs(), ibmvfc_reenable_crq_queue(), and
> ibmvfc_reset_crq(), channel sets are registered sequentially:
>
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>
> If ibmvfc_reg_sub_crqs() succeeds for vhost->async_scrqs (or
> vhost->scsi_scrqs), and then fails on a later call for vhost->scsi_scrqs or
> vhost->nvme_scrqs, the error path in ibmvfc_reg_sub_crqs() only unwinds the
> current channels set and sets vhost->mq_enabled = 0, leaving the earlier
> channel sets registered with the hypervisor and their Linux IRQs active.
>
> Because ibmvfc_dereg_sub_crqs() guards deregistration on vhost->mq_enabled:
>
> 	if (!vhost->mq_enabled || !channels->scrqs)
> 		return;
>
> 	for (i = 0; i < channels->max_queues; i++)
> 		ibmvfc_deregister_channel(vhost, channels, i);
>
> all subsequent calls to ibmvfc_dereg_sub_crqs() in
> ibmvfc_reenable_crq_queue(), ibmvfc_reset_crq(), and
> ibmvfc_release_sub_crqs() will return early without calling
> ibmvfc_deregister_channel().
>
> When ibmvfc_release_sub_crqs() later runs during teardown,
> ibmvfc_dereg_sub_crqs() is skipped while ibmvfc_release_channels()
> unconditionally unmaps and frees each queue page (scrq->msgs.handle) and
> kfree()s channels->scrqs. Doesn't this leak the hypervisor sub-CRQ
> registrations and kernel IRQs, leaving the IRQ handler and hypervisor
> referencing freed scrq slab memory and DMA pages?
>
> [ ... ]

Yes, this is broken. I will remove the check for mq_enabled, as the
check for channels->scrq is all that is needed here.

>> @@ -7081,9 +7084,53 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>>  	}
>>  }
>>  
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
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>> +
>> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
>> +		goto deregister_async_sub_crq;
>> +
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>> +
>> +	if (vhost->nvme_enabled) {
>> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
>> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +			vhost->nvme_enabled = 0;
>> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +		} else
>> +			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>> +	}
>> +
>> +	LEAVE;
>> +	return;
>> +
>> +deregister_async_sub_crq:
>> +	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
>> +	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
>> +out:
>> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +	vhost->do_enquiry = 0;
>> +	vhost->mq_enabled = 0;
>> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +}
>
> [Severity: High]
> The commit message states that in ibmvfc_init_sub_crqs(), failure of either
> ibmvfc_alloc_channels() or ibmvfc_reg_sub_crqs() disables multi-queue and
> aborts init. However, ibmvfc_reg_sub_crqs() returns void and its failure is
> not checked here.
>
> If ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) fails, should
> ibmvfc_init_sub_crqs() release vhost->async_scrqs and return rather than
> continuing to allocate vhost->scsi_scrqs and vhost->nvme_scrqs?
>
> Similarly, if ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) fails after
> vhost->async_scrqs has been registered, shouldn't it release
> vhost->scsi_scrqs and jump to deregister_async_sub_crq so vhost->async_scrqs
> is deregistered and released instead of proceeding to allocate
> vhost->nvme_scrqs?

This code will be reworked for ibmvfc_reg_sub_crqs() returns int and
ibmvfc_init_sub_crqs() will take appropriate clean up actions when
ibmvfc_reg_sub_crqs() returns non-zero.

-Dave
