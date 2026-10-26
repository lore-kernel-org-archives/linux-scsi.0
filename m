Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052701;
	b=hJXtrsCjEtW64luAPtbbSwlzAk9eVnnzwsRMxhDl17UAqTuSgQ8t9IIir9Cn4mnRbCWP
	 naCEdTO+nmpUzhVy3SWhflEYCGj0OWlnV1ELXMd6GCSDG5z2QgvDH7qCuDvbKYBUx13xZ
	 3YMzwOIM+pTa5IWkC2J3aygNT6QmJ1aSRIPaxhN2o8eGLhDq1r/EvPdxqIa/G29dCCrA/
	 GLEMnaE7fXcNrArTaDVsqv0E+tpOxbw/rEK6RE/itOQVe6seh1hauDC+jxtKAy9H2ZMQD
	 caegQr3reqK8afAiRnQdaxVhz65YsAs2lcTlphyduED+o926Ozszeq3BTbQh3zjKtmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052701;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=B8wgkW9Guv3xYAvJFD5+NUvZAJ/JB1rAg8hkSwTJhVw=;
	b=MJYCRqfMahjpLndk0ROwdqNXRWlDGCCJ0MO71qPI3k9HH8G3P39sVTcWSz2OCddtm53Y
	 XxWZRMpS2fWyoF18kcw4uLbWpqlJtOpwEf5IMjyPv/9Lkk40vPSPdXUSIwymGAh+JDrIa
	 cJTGeX+9BFH1WOFR8KhvtWO3yjvmjgxyoxtTy6TmlVvQISM9tLrxOWvhdCrT8cQ+03r2X
	 q+mgLiZoBd3BKGfNdLjk5BPEhBs8I5noxQQv7wTwitdDdBgWQFcoSfrh44GvkSGioK4ra
	 TLhXAAukR0swtVb+rMkbxsTs/5JMgZIkRaWitf8ze1GNsFzy3iDq+2q8BiGnAHbgh9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lhBhysKj;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15667606A31A;
	Mon, 26 Oct 2026 22:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15667606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lhBhysKj
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QJELMv189680;
	Mon, 26 Oct 2026 22:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=B8wgkW9Guv3xYAvJFD5+NUvZAJ/JB1
	rAg8hkSwTJhVw=; b=lhBhysKjxQQBP7h8pydJ2mjhoQvv25ks+xd0CDWRxo1kxp
	j3iNruaS0tmWxSYUrvRQFTViCMJPYmyfnHMzC0X24W5DdiiOliaCgUpbVyx0Q+D+
	sFNmsEFkNvp6TJ3cICIgDF6c+OI6EgIZ+135mfFT+SiOzeNG7xwqckEGXWCSrQDk
	dMDQXXjc8hOBtKRd4YG3fjLRpxiBec0n3kjpskGef0jKBoSkl6Ent4VIYeHWASSC
	hVQ3Q7Fd+Nq6aCW4NmmXU9VeiY2901QuTGv45xrThtS0GBQnbJzpvJ32Ru4/JeCc
	MZGHqh6QGX4qytnkB6PmNQDh0MbYHjfvQuKx0neQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgj3m4se9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 22:11:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIpCFi3004949;
	Mon, 26 Oct 2026 22:11:37 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hh70prbb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 22:11:37 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69QMBbrc5833268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Oct 2026 22:11:37 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 051B25805A;
	Mon, 26 Oct 2026 22:11:37 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC80658052;
	Mon, 26 Oct 2026 22:11:36 +0000 (GMT)
Received: from e (unknown [9.61.189.219])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Oct 2026 22:11:36 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v16 05/12] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <sashiko-outbox-185513@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 26 Oct 2026 16:24:10 +0000")
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
	<20261026-ibmvfc-fpin-support-v16-5-a900aa657ed5@linux.ibm.com>
	<sashiko-outbox-185513@kernel.org>
Date: Mon, 26 Oct 2026 17:11:36 -0500
Message-ID: <87bj8gf6xz.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfX5dAaeIfwoACi
 PHUfMRGHuqil5AdqJsYZ4L+gL052Yvx5AU+ZzFaBA4Fs2tB5G7UdYvfbXde0aZayCLQIseNAPaL
 +BV1j/udQ++KxmjN7Q7Vpp+utKcbwKw=
X-Proofpoint-ORIG-GUID: PChiCZRu_21Fepiyz2r9InosAEpQ201f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfX/s49P1xF3MsX
 Q+HusCvvxc9JrklfQXSewal4xEZIMQT4aCB9hIVbaIc7dKZmT8NIG1/th34iwW4O8bw1IzSDaOO
 klp9/QxA4na2c0/mDtkrHPeYN2EZ+OhrX2l4JHLsgITLdn4VW2RFENntZ5KjZqIe0nNFxsMISyr
 ED3KvEJFzzkvtLsfVhha+IssAM4VUOreWGWXl3W1HUZYzTVTgkE4W6onGPp035HJhBXHsG9/WJg
 BpyH7fvBq2nJUls3mEulyYiPH74hZVQQKDBoViJZbuGFbeMan+tuoBIzk+tJ7Fr+w3VIAZPrmd+
 ebP38umGXqHxAYM9k8pyJPhTPNdD/sF298HXKSfxdKUWkONNfL1zrmsoycdUOF0u/mRhLcTru0n
 nz436sycdxIESOSRGD1j4RFmKCIOKSGy1BwWbwGNH2YrHwkhH95A6OfLOe4U6I2EXdStfVgaKY7
 3uHg+CEa31Y8iH823GA==
X-Authority-Analysis: v=2.4 cv=G7uJgNk5 c=1 sm=1 tr=0 ts=6adfd01a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=j9RR-ouNwWIpI61htBwA:9
X-Proofpoint-GUID: PChiCZRu_21Fepiyz2r9InosAEpQ201f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260086

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b63b341efb074..1cd39d36edf5c 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -6900,9 +7171,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
>>  	mutex_init(&vhost->passthru_mutex);
>>  
>> -	if ((rc = ibmvfc_alloc_mem(vhost)))
>> +	vhost->fpin_workq = alloc_ordered_workqueue("%s-fpin-workq-%u", 0,
>> +						    IBMVFC_NAME, shost->host_no);
>> +	if (!vhost->fpin_workq)
>>  		goto free_scsi_host;
>>  
>> +	rc = ibmvfc_alloc_mem(vhost);
>> +	if (rc)
>> +		goto free_workq;
>> +
>>  	vhost->work_thread = kthread_run(ibmvfc_work, vhost, "%s_%d", IBMVFC_NAME,
>>  					 shost->host_no);
>>  
>> @@ -6910,7 +7187,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  		dev_err(dev, "Couldn't create kernel thread: %ld\n",
>>  			PTR_ERR(vhost->work_thread));
>>  		rc = PTR_ERR(vhost->work_thread);
>> -		goto free_host_mem;
>> +		goto free_workq;
>>  	}
>>  
>>  	if ((rc = ibmvfc_init_crq(vhost))) {
>> @@ -6946,7 +7223,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  	ibmvfc_release_crq_queue(vhost);
>>  kill_kthread:
>>  	kthread_stop(vhost->work_thread);
>> -free_host_mem:
>> +free_workq:
>> +	destroy_workqueue(vhost->fpin_workq);
>>  	ibmvfc_free_mem(vhost);
>
> [Severity: High]
> Does jumping to free_workq when ibmvfc_alloc_mem(vhost) fails in
> ibmvfc_probe() cause a double free in ibmvfc_free_mem(vhost)?
>
> When an allocation fails inside ibmvfc_alloc_mem(), it already unwinds and
> frees everything allocated up to that point before returning -ENOMEM, leaving
> non-NULL dangling pointers in vhost:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_mem() {
> 	...
> free_tgt_pool:
> 	mempool_destroy(vhost->tgt_pool);
> free_trace:
> 	kfree(vhost->trace);
> free_nvme_disc_buffer:
> 	ibmvfc_free_disc_buf(dev, &vhost->nvme_scrqs);
> free_scsi_disc_buffer:
> 	ibmvfc_free_disc_buf(dev, &vhost->scsi_scrqs);
> free_login_buffer:
> 	dma_free_coherent(dev, sizeof(*vhost->login_buf),
> 			  vhost->login_buf, vhost->login_buf_dma);
> free_sg_pool:
> 	dma_pool_destroy(vhost->sg_pool);
> unmap_async_crq:
> 	ibmvfc_free_queue(vhost, async_q);
> nomem:
> 	LEAVE;
> 	return -ENOMEM;
> }
>
> In ibmvfc_probe(), jumping to free_workq when ibmvfc_alloc_mem() fails
> destroys vhost->fpin_workq and then falls through into ibmvfc_free_mem(vhost),
> which frees all of those host resources a second time and calls
> dma_free_coherent() on NULL pointers such as vhost->channel_setup_buf.
>
> Should ibmvfc_alloc_mem(vhost) be called before alloc_ordered_workqueue()
> (or use separate error labels for freeing host memory and destroying
> vhost->fpin_workq) so that an ibmvfc_alloc_mem() failure skips
> ibmvfc_free_mem()?

Yes, this is a valid issue. If ibmvfc_free_mem() zeroed out all the
pointers, this call to ibmvfc_free_mem() might be fine. v17 will
allocate the ordered workqueue after allocating memory
(ibmvfc_alloc_mem()) and use a separate label in order to skip
ibmvfc_free_mem() if ibmvfc_alloc_mem() fails.

-Dave
