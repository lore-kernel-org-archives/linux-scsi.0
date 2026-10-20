Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792511423;
	b=Jf+8mBnNFlbxWhcjvbsZmB4Ywnty17UpR4ItQuQsaLlZaQG52Qxcy/4c/sr73RouztYh
	 YOKTWpgaG/8WizhM2OWQaAl/sBRyFhSbiGzmhCfWnk6veQ4A0TETybonxhWZCLkw17vbA
	 IsvwHQTC0xKVY5JUbuH8MCOHXeiXNmlbHHwmxqviDo1qa6uvq/02YUumUyC2wySWgSWij
	 9Y8bXY9/GFQhVNfYG6+9A588jvc89gYCb2znJdrcBJo+uAtIndU5zizGYTcyHsLtFZWWw
	 vHlDkpQu6HtYxDiVHkOamOq00AI1B2rZMqVJPAOLhtIKzINwdvnyuMYnCd40rCYqq+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511423;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=AbcauNFsMvIFMj9DrGI69mbjEH96tjnPD90nswn6J9o=;
	b=Y2OCRrij+U6XgHN/UzXqkfy/rs5LO8Un8JB6o+tzWEYXvephDk+5DlHHEqQPnz84bP1P
	 nY1rrDASPf46OABT5xtkW49xBdkYHBIU0l0MW5KefLb1koSCPg99SyVF4k5cLgpRGELYi
	 WgO6pmvuyEbqw33hF7MPXHdULLYz8Eo0SaHHq+jTy8wofo4Ma4SjkosbtvjGiZCaVEW6M
	 PQ2UlKJOlvk7AsIjmHzIFfqixgJoCtU2ecx9YD6BoaZRCD2rEjtUWbIASgZoqqw475LrA
	 T/HL0sk12UVJh4SoQBbuqRwNhmLEtKsU3ajoPw2ZvK8mZq69dYF3kdsikNBQqZAvx6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Nj+bCtg5;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC82606A31F;
	Tue, 20 Oct 2026 15:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FC82606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Nj+bCtg5
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDE9cj2677984;
	Tue, 20 Oct 2026 15:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=AbcauNFsMvIFMj9DrGI69mbjEH96tj
	nPD90nswn6J9o=; b=Nj+bCtg5LQtv5b9kOdBRgD+y+3jtCnNDgftuKCmsvm2Xp/
	EuHIeEXU2rRwXtkuULpCgU9FpZNFO7ouYmZjOICoFdMrnCbbeLWzvS/jPy/woMTI
	nKK2wyrEz9+lDj2NSoL7Krh5BFidTZQ0UH84xYjM8NYOVILB9la/2i4870L4lUdz
	qviAbsOOoER0obe6/kUW4my16h/eX9p1xW0LLRjdLHuI4kR1oxn5SEbGht/3Z7lw
	Jd+NoFg3KcuTPrHW2vCqwIwtyjQZKHa5Qbq0l9J8d+P7u3kTxTmNvqvHuNgcDjBS
	vjMPerM5Qbf64EvXGVzF1latqnxT7UeMyTVYnbdA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58kscx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 15:49:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDJv5W1543022;
	Tue, 20 Oct 2026 15:49:50 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he6gq92ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 15:49:50 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69KFnnsS18875010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Oct 2026 15:49:49 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BB8B5805C;
	Tue, 20 Oct 2026 15:49:49 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E6725805A;
	Tue, 20 Oct 2026 15:49:49 +0000 (GMT)
Received: from e (unknown [9.61.26.156])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Oct 2026 15:49:49 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v15 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <sashiko-outbox-178325@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 19 Oct 2026 22:35:19 +0000")
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
	<20261019-ibmvfc-fpin-support-v15-4-a858726e178a@linux.ibm.com>
	<sashiko-outbox-178325@kernel.org>
Date: Tue, 20 Oct 2026 10:49:49 -0500
Message-ID: <87bj8ol6ci.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: vjIIQMieu-JBcIXx0Xsi0NSqVLdqQGYp
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA2MiBTYWx0ZWRfX6SpOG8KH04c9
 3NQEXei1bNkFQNUSIPoyHiSNzAQWy1Sdpx24U4O/SaRPIW8VjJt36rHHZdfQFt2gv1mT8qiMBEG
 WL0iCBH5tSDXNPKsIHb3N2urFbwOw7I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA2MiBTYWx0ZWRfXxONzXhU3f/rY
 zf3xjQXjoY6+P/1tAJfVb+klS3f+vsly7yT6rfWttpWIoHuQ9JCfycrvAu6KIBXM52RPy5e4kcd
 +1WBRcNX+rgRwsryE2WuK6nUAGXUcFsrFT0s/ZfzZRInTX8HcMRJk+G4icIOQdpxBZclez/Lrvx
 lYtGzRFTlKAlsAEby77xMT7IGyzWpgmxFpIA+zlbV7F1eap1wzqcvOTlwsBPB1qcQ61tTt5E4it
 WX89knNM4dwxoZBNRfEnoCZntXZYYLzUNV6F1KaQREAhSZiy/deAkBL7y1mxUU2W+lvbNqsW5XY
 NP4sZKeEa2LSGn3A1LqesvbkUOCWS6yZ8k0nsxXsO9rqnLPluAigncUwlbZgDAKN4KWrlBnQdZG
 hv4jLR8ixKTOlolaTI+QBwIIgCZ698Cwq7mSSxP71iquunKxwysXjeJfxbL78FabWmqenqacUju
 l8MxkcJc4ML+los22TA==
X-Proofpoint-ORIG-GUID: vjIIQMieu-JBcIXx0Xsi0NSqVLdqQGYp
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6ad78d9f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=v9ftGglcpUR1sx4fu-4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200062

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: wrong fpin_workq teardown order in ibmvfc_probe() error path
> --
>
> commit f3dce48358b69cb9e305579053b02a88579e0f88
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> This commit adds basic Fabric Performance Impact Notification (FPIN)
> support to the ibmvfc driver by offloading IBMVFC_AE_FPIN async events to
> a per-adapter ordered workqueue, converting VIOS FPIN messages into
> fc_els_fpin structures for fc_host_fpin_rcv(), and adding KUnit test
> coverage.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 0fe6b6f4260ba..0750e722c46c5 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -6898,9 +7169,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
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
>> @@ -6946,6 +7223,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  	kthread_stop(vhost->work_thread);
>>  free_host_mem:
>>  	ibmvfc_free_mem(vhost);
>> +free_workq:
>> +	destroy_workqueue(vhost->fpin_workq);
>>  free_scsi_host:
>>  	scsi_host_put(shost);
>>  out:
>
> [Severity: High]
> Can the error unwind order in ibmvfc_probe() cause a use-after-free of
> vhost->tgt_pool?
>
> In ibmvfc_remove(), destroy_workqueue(vhost->fpin_workq) is called after
> ibmvfc_release_crq_queue(vhost) and before ibmvfc_free_mem(vhost):
>
>     ibmvfc_release_crq_queue(vhost);
>     destroy_workqueue(vhost->fpin_workq);
>
>     ibmvfc_free_mem(vhost);
>
> As described in the commit message, this ordering ensures that queued FPIN
> work items are drained before ibmvfc_free_mem() destroys vhost->tgt_pool.
>
> In ibmvfc_probe(), however, vhost->fpin_workq is allocated before
> ibmvfc_alloc_mem(vhost), so the error unwind path runs ibmvfc_free_mem()
> before destroy_workqueue(vhost->fpin_workq):
>
>     release_crq:
>         ibmvfc_release_crq_queue(vhost);
>     kill_kthread:
>         kthread_stop(vhost->work_thread);
>     free_host_mem:
>         ibmvfc_free_mem(vhost);
>     free_workq:
>         destroy_workqueue(vhost->fpin_workq);
>
> Because vhost->work_thread is started and ibmvfc_init_crq() registers the
> CRQ and enables interrupts before scsi_add_host() and
> ibmvfc_create_trace_file() are called, a partner-initiated CRQ handshake
> and subsequent IBMVFC_AE_FPIN event can queue ibmvfc_process_async_work()
> on vhost->fpin_workq before scsi_add_host() or ibmvfc_create_trace_file()
> fails.
>
> If that happens, ibmvfc_free_mem() will call
> mempool_destroy(vhost->tgt_pool) while ibmvfc_process_async_work() is
> still running or pending, and ibmvfc_process_async_work() ->
> kref_put(&tgt->kref, ibmvfc_release_tgt) ->
> mempool_free(tgt, tgt->vhost->tgt_pool) will access the destroyed
> tgt_pool.
>
> Should vhost->fpin_workq be allocated after ibmvfc_alloc_mem(vhost) (or
> destroyed before ibmvfc_free_mem(vhost) on the error path) to match the
> teardown order in ibmvfc_remove()?

Yes. I'll change the teardown order to match the teardown order in
ibmvfc_remove().

-Dave
