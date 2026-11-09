Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245394;
	b=lOvoGTzgMChAsC8dYm/wBB5S3W+Tiax56Of+XIVVMksmHwDvsUCOby9pNPJ1lYqO1PiW
	 h1NbkG0Dj50DdzqcMH79wnnE4cu/dL4QGO1uL3epE71t99jyu6FgmlSI+kitJC5aoHC/8
	 OxgIZGMdPX0p1vdxYzlLWL3Kr4wUCek6mZwYy2pRayIky2pblTmzmX312Xi/efBL3nk5C
	 uNQmqYaGOdUAD3O+eOyYljVmtdwjNHz0ktqdJmMp4WjaktNMMCAjbcFki6qqJyjVnCiYZ
	 un3p/EfZSOgAebuWxwOp0eRgI5z4MzTnS8xXhqyIrCIyrvT8IEjo83nrXFZBnlZSxbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245394;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Go01UNxaSZMMKwj4XxWgUsxN4oQmpJld0dIw5K9cYR4=;
	b=T4uWmQQOfOIW4FdsdVdYKi7oRIX9PK0DvFc1MGLgjBvHDdkjGVITSNg+lLwK7bgSYH6n
	 XEEC4VhGz2JLpPLxVX4Q3mEKN6JssoW3QXc17v1mpau6m6WB63zGWRJ5joE0x2qjuPF3i
	 RhZr+nlEIj8MmKV8CZIw2JDclqUUPPkMGIROMiaxRjFWVBQfgT91flbpJKHx3I0lO+LaI
	 A52KTbzr3l+xTB3rVDlYgLRvZ+Oza02gXUsJw9zXHtlMCjq1Pcqw2+JlMCx3yhLsRD2sG
	 j4O3vYRZXeT1Up8k5cZKuw6FomVs69bM6KQrAqGbI0EfQ+sZ4sjQCKMUqxNgy7onAJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=i4b93Vp3;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5E7606A31C;
	Mon,  9 Nov 2026 17:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA5E7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=i4b93Vp3
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9H7Z5g3508114;
	Mon, 9 Nov 2026 17:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Go01UNxaSZMMKwj4XxWgUsxN4oQmpJ
	ld0dIw5K9cYR4=; b=i4b93Vp3w5WSzeauArWACysYfjj2usN7jqhkZ9PGWwEF5y
	b0SZExYsoivsmv+HbmCiZ/6mqBQX1zo2X1qPhsgt1J46PoxIPrtZjgvOKBNCIEgG
	PmzlMeMctYHKjnyerATDKm68Hbg7N0y6nlhzpCNwQF2UDCry6JcatqmYnvAarm/F
	aLGCjNV/N8ynW8t7LiOzIIWbCBr5li4ZmALkVaSexgQBfEpUSGy68Dn2y2bL4Viw
	3E1LG/hcM9M+4MVf9k3GV9F0c8Mbk7VKm0z0FCl3NPBheIrf8GvkSdwQqreO24B8
	PZU2ENWk1ulS4QSTLcA68vu3La5tAUYKSDIydZRg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsumuq751-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Nov 2026 17:29:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9HKL7k3501580;
	Mon, 9 Nov 2026 17:29:49 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4htghg1qn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Nov 2026 17:29:49 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A9HTmtq33620616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Nov 2026 17:29:48 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFE5A58158;
	Mon,  9 Nov 2026 17:29:48 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B31158157;
	Mon,  9 Nov 2026 17:29:48 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  9 Nov 2026 17:29:48 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 12/13] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <sashiko-outbox-199806@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 19:03:54 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-12-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199806@kernel.org>
Date: Mon, 09 Nov 2026 11:29:48 -0600
Message-ID: <87fqx9x69f.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA2OCBTYWx0ZWRfX2mJBTrwXUqD9
 QKf7hwrbG8TK1qAV5HYsTZCfCRKVStLnO3cQJPF4RUni0/BeW5C26iKBbUDuvCc9yM74stj+OLR
 VpK3paJ8I5A+SxrRvUBfthEkDgYOoN0=
X-Authority-Analysis: v=2.4 cv=GISdgeNK c=1 sm=1 tr=0 ts=6af2030d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=I2Lrlv6YBn3PQ1EVz3sA:9
X-Proofpoint-GUID: ZcicQ7Tv19M5VlcT7xhmFuNGbDEfIu-_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA2OCBTYWx0ZWRfXz0YIbO/scw59
 zMVJ9iEbL2w0Dn8w6wABy0YAQ+vSfVSD0QFGioWhPpCSDg5kHZyB0AdapLZrJ5QBQWmuK5BJC3X
 oOIjz0ViHHmCUlWfSeqod8xTLsRxu5p536TrhXqYS/lx5XxCTtNVIZFqRjAHMTNCMtVbHvqBuDC
 bAZeVCUiBnRQ55eVpcBRqTcYc9Mc8olxRSm+d7QE8XSqycvffE9RtTdqIvpon+uKM074I88JPhx
 y1PfgzvfrbECfiBlQ1XRM3IhKtm6d4NG640Xe5IvUZ6qIql23Kz/bsO09ETTg3mS0/Yl6t+kN9x
 AS4iT+1RrJCitiwfns28N84aQzmYW8oBts+Jj4misBfYrHPoZzEe354zGISif9C+98xNpeQFhi7
 tfRcl9fe606FkuwyaEG9PQkakl2QMXx+nkhSTuSv713E5Ne7svnDrPRSrNSRSfLf3vMZIlYytMt
 7+Hr0uChqlrAg+cXeow==
X-Proofpoint-ORIG-GUID: ZcicQ7Tv19M5VlcT7xhmFuNGbDEfIu-_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090068

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 7b52401ae4d52..6e1ecf6891c71 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>>  	spin_unlock(vhost->crq.q_lock);
>>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>>  
>> -	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>> -	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
>> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
>> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
>> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +		vhost->do_enquiry = 0;
>> +		vhost->mq_enabled = 0;
>> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +	}
>>  
>>  	return rc;
>>  }
>
> [ ... ]
>
>> @@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>>  	spin_unlock(vhost->crq.q_lock);
>>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>>  
>> -	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>> -	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
>> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
>> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
>> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +		vhost->do_enquiry = 0;
>> +		vhost->mq_enabled = 0;
>> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +	}
>>  
>>  	return rc;
>>  }
>
> [Severity: Medium]
> When ibmvfc_reg_sub_crqs() fails in ibmvfc_reenable_crq_queue() or
> ibmvfc_reset_crq(), all three channel sets are deregistered via
> ibmvfc_dereg_sub_crqs() and vhost->do_enquiry and vhost->mq_enabled are
> cleared to fall back to single-queue mode, but channels->active_queues is
> never reset to 0:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_dereg_sub_crqs() {
> 	if (!channels->scrqs)
> 		return;
>
> 	for (i = 0; i < channels->max_queues; i++)
> 		ibmvfc_deregister_channel(vhost, channels, i);
> }
>
> Because clearing vhost->mq_enabled and vhost->do_enquiry causes subsequent
> NPIV login to skip ibmvfc_channel_setup_done(), active_queues remains
> non-zero on the deregistered channel sets.
>
> In drivers/scsi/ibmvscsi/ibmvfc-nvme.c, ibmvfc_nvme_create_queue() checks
> only active_queues:
>
> 	if (!vhost->nvme_scrqs.active_queues)
> 		return -ENODEV;
>
> Won't leaving active_queues non-zero after deregistering the sub-CRQs cause
> ibmvfc_nvme_create_queue() to bind NVMe queues to deregistered nvme_scrqs
> entries that no longer have hypervisor registrations or IRQ handlers?

This will be fixed in v19.

>> @@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  
>>  	if (vhost->mq_enabled || vhost->using_channels) {
>>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> +		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
>> +		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
>> +		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
>>  		if (vhost->nvme_enabled) {
>>  			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
>> -			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
>>  			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
>>  		}
>>  	}
>
> [Severity: Critical]
> Now that ibmvfc_set_login_info() advertises IBMVFC_USE_ASYNC_SUBQ and
> IBMVFC_CAN_HANDLE_FPIN, the VIOS can deliver FPIN events that are queued to
> ibmvfc_process_async_work() via
> ibmvfc_interrupt_async_subq()->ibmvfc_drain_async_subq()->ibmvfc_handle_async().
>
> In ibmvfc_process_async_work(), there appear to be two regressions when an
> FPIN event arrives with all-zero target identifiers (!scsi_id && !wwpn &&
> !node_name && !assoc_id), such as a host-scope IBMVFC_AE_FPIN_LINK_CONGESTED
> or IBMVFC_AE_FPIN_CONGESTION_CLEARED event:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work() {
> 	struct ibmvfc_async_sub_crq *subq = NULL;
> 	struct ibmvfc_async_work *aw;
> 	struct ibmvfc_async_crq *crq = NULL;
> 	struct ibmvfc_target *tgt;
> 	...
> 	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
> 		subq = &aw->event.subq;
> 		...
> 	} else {
> 		crq = &aw->event.async_crq;
> 		...
> 	}
>
> 	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
> 		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
> 		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> 			fpin = ibmvfc_basic_fpin_to_desc(crq,
> 					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 		goto send_fpin;
> 	}
> 	...
> send_fpin:
> 	...
> 	if (tgt)
> 		kref_put(&tgt->kref, ibmvfc_release_tgt);
> }
>
> First, tgt is declared without being initialized to NULL, and the
> (!scsi_id && !wwpn && !node_name && !assoc_id) branch jumps directly to
> send_fpin before tgt is assigned by ibmvfc_find_target(), so kref_put()
> dereferences an uninitialized stack pointer.
>
> Second, when aw->event.type == IBMVFC_ASYNC_CRQ_SUB, crq is NULL, but that
> same branch unconditionally calls ibmvfc_basic_fpin_to_desc(crq, ...)
> instead of checking crq vs subq and calling ibmvfc_full_fpin_to_desc(subq,
> ...), which immediately dereferences crq->fpin_status in
> ibmvfc_basic_fpin_to_desc().
>
> Can tgt be initialized to NULL and this branch dispatch between
> ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc() like the other
> call sites in ibmvfc_process_async_work()?

This will be fixed in patch 6 in v19.

>> @@ -5907,6 +5929,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  {
>>  	struct ibmvfc_host *vhost = evt->vhost;
>>  	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
>> +	struct ibmvfc_channels *async = &vhost->async_scrqs;
>>  	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
>>  	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
>>  	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
>> @@ -5920,8 +5943,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
>>  		flags = be32_to_cpu(setup->flags);
>>  		vhost->do_enquiry = 0;
>> -		scsi->active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
>> -		nvme->active_queues = be32_to_cpu(setup->num_nvme_subq_channels);
>> +		scsi->active_queues = min(be32_to_cpu(setup->num_scsi_subq_channels),
>> +					  scsi->max_queues);
>> +		nvme->active_queues = min(be32_to_cpu(setup->num_nvme_subq_channels),
>> +					  nvme->max_queues);
>> +		async->active_queues = (async->scrqs && setup->async_sub_crq_handle) ? 1 : 0;
>>  
>>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
>> @@ -5937,6 +5963,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		for (i = 0; i < nvme->active_queues; i++)
>>  			nvme->scrqs[i].vios_cookie =
>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>> +		for (i = 0; i < async->active_queues; i++)
>> +			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>>  
>>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>>  			   scsi->active_queues);
>> @@ -5971,6 +5999,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>  	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
>>  	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
>>  	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
>> +	struct ibmvfc_channels *async = &vhost->async_scrqs;
>>  	unsigned int scsi_channels =
>>  		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
>>  	unsigned int nvme_channels =
>> @@ -5998,6 +6027,9 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>  				cpu_to_be64(nvme->scrqs[i].cookie);
>>  	}
>>  
>> +	if (async->scrqs)
>> +		setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
>> +
>>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
>>  	mad = &evt->iu.channel_setup;
>>  	memset(mad, 0, sizeof(*mad));
>
> [ ... ]
>
>> @@ -7191,9 +7223,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>>  	}
>>  }
>>  
>> +/**
>> + * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
>> + * @vhost:	ibmvfc host struct
>> + *
>> + * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
>> + * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
>> + *
>> + * On failure at any stage, previously registered and allocated channel sets
>> + * are deregistered and freed in reverse order, and vhost->mq_enabled and
>> + * vhost->do_enquiry are cleared under host_lock to prevent the host state
>> + * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
>> + */
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
> In ibmvfc_probe(), vhost->nvme_scrqs.desired_queues and
> vhost->nvme_scrqs.max_queues are initialized to non-zero values even when
> vhost->nvme_enabled is 0:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_probe() {
> 	vhost->nvme_enabled = mq_enabled ? nvme_enabled : 0;
> 	vhost->nvme_scrqs.desired_queues = min(max_nvme_queues, nr_nvme_channels);
> 	vhost->nvme_scrqs.max_queues = max_nvme_queues;
> }
>
> When vhost->nvme_enabled is 0, or when allocating or registering
> vhost->nvme_scrqs fails in ibmvfc_init_sub_crqs() after async_scrqs and
> scsi_scrqs succeed, vhost->nvme_scrqs.scrqs remains NULL while
> vhost->mq_enabled and vhost->do_enquiry remain 1 and desired_queues and
> max_queues remain non-zero.
>
> During channel enquiry and setup
> (ibmvfc_channel_enquiry_done()->ibmvfc_channel_setup()), if the VIOS reports
> num_nvme_subq_channels > 0, ibmvfc_channel_setup() computes a non-zero
> nvme_channels without checking vhost->nvme_enabled or nvme->scrqs:
>
> 	for (i = 0; i < nvme_channels; i++)
> 		setup_buf->channel_handles[scsi_channels + i] =
> 			cpu_to_be64(nvme->scrqs[i].cookie);
>
> Similarly, in ibmvfc_channel_setup_done(), nvme->active_queues is clamped to
> nvme->max_queues without checking whether nvme->scrqs is non-NULL, which
> then dereferences nvme->scrqs[i].vios_cookie in the loop.
>
> Should ibmvfc_channel_setup() and ibmvfc_channel_setup_done() guard the
> nvme->scrqs accesses (or zero desired_queues and max_queues when
> nvme_enabled is 0) in the same way async->scrqs is guarded?

Yes, this will be fixed in v19.

-Dave
