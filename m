Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912948;
	b=rZz5+3FEd9kbvpFzJ5XvF8tSgogeobacblIeoXmycsthMBD4Rl3Ins0pZrmnR914Ug6P
	 ZiRhDlbKhmsHU1uz4zZZBrcyoRXydu4W49/KNVRkacAOed2WbguftV4LNc5l2F18PvHjP
	 uLVdA3XN2ihZ9w8u6X2V4YR2EnJXlOUDG3hePtnAAbdHIRwDDJGztyFIH8wzSbaN1GXL6
	 +HZ/1MA+941uSKph6ktuRwqrecgDjFk0Gh1ZDHw0rCJY8YTitG5VhojusZA/1zZCRiwuo
	 L/pmcNsgaefRz0PgYAcBfV5dsz0CMNPIKbFMfFn6CoL+6aTgAa9rxb0mUDk8DLiEcLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912948;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bvnIkSD0OgdY/8kmNGQfd0pnoIjGx25FyoFeuWj8co0=;
	b=gssJgBI4wwpyhkADHLZzAGkxldQyjWAGI7iVvpuUBqZXHPFR0q2c4oGoDTKOwI/rkSeZ
	 q9LWdzEZ3axUf/na3sElPCUVUXOhUhaFutzQE0zyLGNnrhM06Wc7a0aGrRQbjbDyjvlbB
	 5/NGmto2RKeCVpEfz7aBiqYgSF7BRH1oAYFZSd2mY7lg+jC4+7VpBpGFQ0ghDMZ3jYbmY
	 URAwBnZdZlwoG4JT90co7o36cyrCpiGiMyP8Tqc/T6lAUeNdTIWC6nSJgXtXDgKFz2a5G
	 2UlPdR0dsrEGiv9dcF/KsBr3lZfTdwFvXQPSB25nycuvOM9aQFGFGNhNFvCgFEPWQwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=nizqZ9Le;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B6606A328;
	Thu,  5 Nov 2026 21:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D00B6606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=nizqZ9Le
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5Hi2Cc226669;
	Thu, 5 Nov 2026 21:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bvnIkSD0OgdY/8kmNGQfd0pnoIjGx2
	5FyoFeuWj8co0=; b=nizqZ9LemGfMc2UnQg8K8UD/tXZrNUtsffYzhCsFZsPnyg
	M6WHkr2uvHuJ9w2NlK/E0mP4wbdSWWW/LwxOlfa195wmvbPXcrKOL7OWp0Waem3z
	qsAOHissLcuAwM18sYWs4QNJgGbG/yQG78NpZ+c/vh2wtC52cXE0V1LKHFf92hK9
	9vmJYTwILULP4MPntissnS4uNP93Y7bBX3d0yWz801VIDi2kdSwpCgwIA8hLGiMl
	0IYEqfITRUHt9XyY5FIrn8HGk3sy60XM76L0X+ZdsK36yvtdVVajkqJPsRg78xZk
	fnQbiGC9JT1lgzfEWMApFR4HVMUkzeAuONC9aNbw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn7u3w1p6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 21:09:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5L6Ced2298705;
	Thu, 5 Nov 2026 21:09:04 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hrdd7ns7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 21:09:04 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A5L93eK9962026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Nov 2026 21:09:04 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D1F158052;
	Thu,  5 Nov 2026 21:09:03 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B09C58054;
	Thu,  5 Nov 2026 21:09:03 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Nov 2026 21:09:03 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 06/13] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <sashiko-outbox-199695@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 18:09:00 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-6-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199695@kernel.org>
Date: Thu, 05 Nov 2026 15:09:02 -0600
Message-ID: <87cxsj7zpt.fsf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=Zsp4uN7G c=1 sm=1 tr=0 ts=6aecf071 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=UAWjN2OW0Dv6p6HftGwA:9
X-Proofpoint-ORIG-GUID: L9mcHLJDFCO3dz9CNOnVn0Unh0LpjK_p
X-Proofpoint-GUID: L9mcHLJDFCO3dz9CNOnVn0Unh0LpjK_p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA4MiBTYWx0ZWRfX8nm6F4ZGxLsB
 Bd7GRsxwDSVHJE8FnkbLlmvq2EIx6v1laYzfuhEtnanb/MUM4CrmPxaFPHf0GrMisiPhnvq3LxF
 0oZvWB9wvnCZlPkMwxTYX13RTgVQbGS0zEqbB2VZtLqwwxpUHdHvcTVcoCE10zIjTNKotU4KZsq
 aSMQMo+Dz1tb4cwLOMmCUgExFNvNm3r8ZjlMk4BtjSDHCBGfvVNvpNOMjwvgYol8BzNP09IANnS
 0G/gDTgzEHsR8AH0MRBAIdAyWBE+X3Lksqi4z8Ppcvf3B3z2C4zLavadmdst7Q148Hebqb+N7dV
 ccEM/61od8r612R5pfTlDOSkJsxK++NWkOPkh0WpnKtbbGxZPwUYZl7f3m6F1MTgId7Bn25rAkg
 KYPuV5ato2Hh0GmFKHTmmVuKD5KavzsUfZioq/OPpyh9mw00AhHXQBs9uvn+WmDsU7iIZgrSd41
 3KcKDFqewAKs0nc/aJA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA4MiBTYWx0ZWRfXz2LQQV4wnBfA
 R4k1oe7Q8bRgiSATs2bvIkHj1KSCRrLkjb5ijaSqkJpl6/bimL5MvbauL1FK2L5Gh2tAEZxyw1i
 xQEkteo8/bygCTbNe2OyrEpPlG7KmcE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050082

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index e04c80050b981..a87beaeca13c8 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -3264,6 +3268,277 @@ static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
>
> [ ... ]
>
>> +/**
>> + * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from work queue
>> + * @work: pointer to work_struct
>> + */
>> +VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>> +{
>> +	struct ibmvfc_async_work *aw;
>> +	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct fc_els_fpin *fpin;
>> +	unsigned long flags;
>> +
>> +	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>> +	vhost = aw->vhost;
>> +	crq = &aw->crq;
>> +
>> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name) {
>> +		if (crq->fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
>> +		    crq->fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>> +			fpin = ibmvfc_basic_fpin_to_desc(crq,
>> +					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
>> +		goto send_fpin;
>> +	}
>> +
>> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
>> +				 crq->wwpn, crq->node_name);
>> +	if (!tgt) {
>> +		/* Target not found in scsi_scrqs, search nvme_scrqs */
>> +		tgt = ibmvfc_find_target(&vhost->nvme_scrqs.targets,
>> +					 crq->scsi_id, crq->wwpn,
>> +					 crq->node_name);
>> +	}
>> +
>> +	if (tgt) {
>> +		kref_get(&tgt->kref);
>> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +	} else {
>> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
>> +		goto free;
>> +	}
>> +
>> +	fpin = ibmvfc_basic_fpin_to_desc(crq,
>> +				cpu_to_be64(fc_host_port_name(vhost->host)),
>> +				tgt->wwpn);
>> +send_fpin:
>> +	if (fpin) {
>> +		fc_host_fpin_rcv(vhost->host,
>> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>> +				 (char *)fpin, 0);
>> +		kfree(fpin);
>> +	} else
>> +		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
>> +
>> +	if (tgt)
>> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
>
> [Severity: Critical]
> In ibmvfc_process_async_work() in drivers/scsi/ibmvscsi/ibmvfc-core.c, both
> tgt and fpin are declared on the stack without being initialized to NULL.
>
> When crq->scsi_id, crq->wwpn, and crq->node_name are all zero, the function
> jumps directly to the send_fpin label without ever initializing tgt. At
> send_fpin, checking if (tgt) and calling kref_put(&tgt->kref,
> ibmvfc_release_tgt) will operate on an uninitialized stack pointer on every
> zero-identifier FPIN event, including valid host-scope
> IBMVFC_AE_FPIN_LINK_CONGESTED and IBMVFC_AE_FPIN_CONGESTION_CLEARED events.
>
> Furthermore, if crq->fpin_status on that zero-identifier path is neither
> IBMVFC_AE_FPIN_LINK_CONGESTED nor IBMVFC_AE_FPIN_CONGESTION_CLEARED (such as
> the zero-identifier IBMVFC_AE_FPIN_PORT_CONGESTED case exercised by
> ibmvfc_async_fpin_test() in drivers/scsi/ibmvscsi/ibmvfc_kunit.c), fpin is
> also left uninitialized before jumping to send_fpin. If the uninitialized
> fpin pointer on the stack is non-zero, send_fpin will dereference
> fpin->desc_len, pass the garbage pointer to fc_host_fpin_rcv(), and pass it
> to kfree(fpin).
>
> Note that while the subsequent commit 6abed589f0fb ("scsi: ibmvfc: extend
> async event handlers for async sub-CRQ events") initializes fpin to NULL, tgt
> still remains uninitialized on the zero-identifier goto send_fpin path.
>
> Should both tgt and fpin be initialized to NULL at declaration in
> ibmvfc_process_async_work()?

Yes, tgt and fpin should be initialized to NULL. I'll update this in the
next revision.

-Dave
