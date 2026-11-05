Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917466;
	b=erEt5BrHjUTbkEUdkH6wzYYG7TpgsAONuRaxouz73tO2mIxF5MS1zr/K/niPo96wXUER
	 tATZt7H43tGD9AR1rKJhBUTHWF8eqJv4dVUv3vc1i8MlF7P8Wb5Z7XDN7Q+fd/+sxbhc4
	 WDIK2Iv2RQ2OcYO2uBIknhR7qZQmWCV4uDbnMuzPt4vtxmXQuxEa6wOn3ynT6kWuZcBsR
	 4rvj2hYORAaJ36dmeCFHz343JwKFicDoAvlGL1Umgh6JEkYyuKCLoxYI9JOYCSxB1s96k
	 JtUxjtKn064FiSgFsG2H4CRry2xem3l+uZxwVPIh0yUm8lAlMrG2OnJFVHhNdJfUhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917466;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=yDULY1xTv/isLT5cXPK8DfkKRCZzzCeddznnkpD1CDg=;
	b=N1gkU14CmqdPDv3pJkrUfKjqDaZtRH1VHjOBLRqLROpqYUMmMKXv4/aQsYeQSWzreGpY
	 kNtCGocl2hBTVRL8tchNuBK2qy1uZgnSPlW4AOJoA4OHdr0JDpo3neKkHgBvHUczjdWfk
	 M6sYkHeM5rKUhLJJ65rnT5NSd72EUQihz8MAXPvAVYo7H8RiRuXiqiR6egL78xLRLDGOE
	 /BgvkT+lIsb+EMMi9l/1NG9P6S6oonXHoi5x4pEs3rIgj/Qg5aX6QnmoqT6kDI+TJhSzu
	 ba65vQ/SYQmXDsODNMBw3uY2JvokNjKlMzxm0jDUKp3gJSf0H6DG7kt2bzYgQ8w5+JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="WhxhbXH/";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE73A606A31B;
	Thu,  5 Nov 2026 22:24:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE73A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=WhxhbXH/
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5LEOOc3455024;
	Thu, 5 Nov 2026 22:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yDULY1xTv/isLT5cXPK8DfkKRCZzzC
	eddznnkpD1CDg=; b=WhxhbXH/7lmZHRLGz2dXqVd2Y/eJcdtK5Pbt8xXbynU77n
	L8szgQe8igVLBrX3fG5o9CyF2FwuIhycz6BvoEMH6lj0F8YRDxGZvts1t/ZaVcYU
	+g0rbu20scJ3lr35774UuXXnLSE7K+tNHE9sarQl680La1+F4mmX5kk7bcH8pHdU
	xp9MlX79uaz7o0o0b2X5HayT07acgtbTuEBhhaF2+dUR3j3x7mXaxgL5jjhASQ0T
	KsKxLUMcHGTIKIzuMVfebnPTWh+B9tZ5VYbwqF6vuNqLtyL6JVn9bnPNe6SM7Q/x
	43KwrjWkL1DqSkPWh7Ha6WO5TETOkgRNScofKpzw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn6rdmus8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 22:24:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5L5t6O2215496;
	Thu, 5 Nov 2026 22:24:22 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hrk9mmmqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 22:24:22 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A5MOLOv31654448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Nov 2026 22:24:21 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF2E15805A;
	Thu,  5 Nov 2026 22:24:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92E0158051;
	Thu,  5 Nov 2026 22:24:21 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Nov 2026 22:24:21 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 09/13] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
In-Reply-To: <sashiko-outbox-199759@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 18:25:37 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-9-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199759@kernel.org>
Date: Thu, 05 Nov 2026 16:24:21 -0600
Message-ID: <875wya9asq.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: lO8K-BvgehNDl10SXMYf1wfEy-VdwMs1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA4OCBTYWx0ZWRfX3Znl9Nhp1APZ
 RHUhPwSO372IV/EtAZIOz2QxQnH2/PS4F3DInvX+dCA8Rtr3mcyZQmrwiS6KzR7OZ9oTqz37Rty
 vBvvm7pndWZPnelcYufM1NM6OHOh+WVMHu5SbEoKhdZwMWu+OqaqmkVFBPYanOvgwat084xC2Rt
 6nj2RPiwUSiIdZyjwfZCtMELv/kpAFAr6qDKfl6jOQsvleQmPBQYS/1nl/Cab/Lnivou8xAC5/D
 2iX+b6jQfRiuibPXTHhNxcu6qBKMorLSWbbCmsCWsLlZYU6SFKqszYU46Yuru8fuJshIwSH2Q/Z
 hk6v/NiUQl8sUiovNc8W5dm8p3KXwk5iyEqsHSBi3TLJfHzgYmFWOXcAs4V+YB+RXKU4SS+sqGY
 I1VnyvLC+KdVldk8FHWrfUOTspl/+pPriQC3knAONGiWnkNsH+N78Y/iHRru8x36eOxFcs64uEo
 lz6RNb2bk1pMbyIwv/Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA4OCBTYWx0ZWRfX/KhNaZR8aaJl
 1SxuOKE3ueWPAIwqwRt+i3ePqGf6zpi1cYI3KBa37ZjvZyfapzrBkrJD4M9tQxDt3G0s2oZhXun
 el5u4Grgfus1diL0r1P54+h6TmjgagU=
X-Authority-Analysis: v=2.4 cv=QK391QLL c=1 sm=1 tr=0 ts=6aed0216 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=yvJfJh92zy_7So4gnYEA:9
X-Proofpoint-ORIG-GUID: lO8K-BvgehNDl10SXMYf1wfEy-VdwMs1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050088

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b9b571db44649..7406e7182777c 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3483,33 +3528,59 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>>   */
>>  VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>>  {
>> +	struct ibmvfc_async_sub_crq *subq = NULL;
>>  	struct ibmvfc_async_work *aw;
>> -	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_async_crq *crq = NULL;
>>  	struct ibmvfc_target *tgt;
>
> [Severity: High]
> Should tgt be initialized to NULL here?
>
> When scsi_id, wwpn, node_name, and assoc_id are all zero,
> ibmvfc_process_async_work() jumps directly to the send_fpin label before
> tgt is assigned by ibmvfc_find_target():
>
> 	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
> 		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
> 		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> 			fpin = ibmvfc_basic_fpin_to_desc(crq,
> 					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 		goto send_fpin;
> 	}
>
> At the end of send_fpin, the cleanup checks:
>
> 	if (tgt)
> 		kref_put(&tgt->kref, ibmvfc_release_tgt);
>
> Wouldn't that evaluate and potentially dereference an uninitialized tgt
> pointer on the zero-identifier path?

This will be fixed in patch 6, as discussed in the response to patch 6.

>>  	struct ibmvfc_host *vhost;
>> -	struct fc_els_fpin *fpin;
>> +	struct fc_els_fpin *fpin = NULL;
>>  	unsigned long flags;
>> +	__be64 assoc_id;
>> +	__be64 node_name;
>> +	__be64 scsi_id;
>> +	__be64 wwpn;
>> +	u8 fpin_status;
>>  
>>  	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>>  	vhost = aw->vhost;
>> -	crq = &aw->crq;
>> +	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
>> +		subq = &aw->event.subq;
>> +		scsi_id = 0;
>> +		wwpn = subq->wwpn;
>> +		fpin_status = subq->fpin_status;
>> +		if (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) {
>> +			node_name = 0;
>> +			assoc_id = subq->id.assoc_id;
>> +		} else if (subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) {
>> +			node_name = 0;
>> +			assoc_id = 0;
>> +		} else {
>> +			node_name = subq->id.node_name;
>> +			assoc_id = 0;
>> +		}
>> +	} else {
>> +		crq = &aw->event.async_crq;
>> +		scsi_id = crq->scsi_id;
>> +		wwpn = crq->wwpn;
>> +		node_name = crq->node_name;
>> +		fpin_status = crq->fpin_status;
>> +		assoc_id = 0;
>> +	}
>>  
>> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name) {
>> -		if (crq->fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
>> -		    crq->fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>> +	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
>> +		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
>> +		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>>  			fpin = ibmvfc_basic_fpin_to_desc(crq,
>>  					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
>>  		goto send_fpin;
>>  	}
>
> [Severity: High]
> Can this dereference a NULL crq pointer when handling an async sub-CRQ
> event?
>
> When aw->event.type is IBMVFC_ASYNC_CRQ_SUB, subq is populated and crq
> remains NULL. If scsi_id, wwpn, node_name, and assoc_id are all zero for a
> host-scope IBMVFC_AE_FPIN_LINK_CONGESTED or
> IBMVFC_AE_FPIN_CONGESTION_CLEARED event, this block unconditionally calls
> ibmvfc_basic_fpin_to_desc(crq, ...), which immediately dereferences
> crq->fpin_status:
>
> static struct fc_els_fpin *
> ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, __be64 detecting_wwpn,
> 			  u64 wwpn)
> {
> 	__be16 type;
>
> 	switch (crq->fpin_status) {
>
> Should this path check if (crq) and dispatch to
> ibmvfc_full_fpin_to_desc(subq, ...) when crq is NULL, matching the target
> fallback path further down in ibmvfc_process_async_work()?

Yes, this is problem. For the next revision the code will check whether
crq is NULL before calling ibmvfc_basic_fpin_to_desc(). If crq is NULL,
the else clause will call ibmvfc_full_fpin_to_desc() with subq.

-Dave
