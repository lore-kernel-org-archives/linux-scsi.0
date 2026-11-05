Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917732;
	b=wY2CaTfyA2kWs4GzDw41VqB/uvthlcZaNJZ38INzM9YmuPCu0du3eC60zEvQCk3RZb9o
	 3V6Ialc/XTXmDuhi4nAGNWdtCnkEW8shkg90p6MhdVdsSozaIcbv9Wec+MpXseWDRtxPe
	 EKwup87qwlA2qjnTGaS3/DnwJvTH9sn8khmESUW8wPJipk6YqSZ88+yD16ZBWBk7q2hq9
	 mC+2bULwVKxJe5XA32fqpzEqIsANkf4EP5xD/aOFiW7oqi4btrXth/WmqyTqcivo28BOk
	 /I6gPjou574RmAfLJuoJKUjyafG0bVs1i/QpKrLv2dMktUyo4Xzgq1gdiQuqhh/yXeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917732;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XqsYd2lSw1RdFz5E61n1O+coqJoZOdGtSJ3MY64jZ+k=;
	b=s6FWq/iH30rUfW1yfOKCZ7s9SXMGjp5dvOZlXwMuTsVxxrXxngfcEJ2ih6e+Dwz71FFH
	 U3gUkYb/8Lyt54dPFJkstLyLA0WYnHNwcR2Tn0NZdwt7VxlTKVmgYhavyRvSOYNhPbPZj
	 9XBBzkDXbDmAKwDzxu4HCjbCokBh3SaGVQlYBSKGLmuWplaoJh0DNC+ts/NuQpYuHhnJs
	 S5jiqAz0qS8j5GGBkn7KKVrZ5F3EGwisptPfdgfhrkaZf2EhVr2ARHNV/epPwnrXP54D3
	 p0xru+SxEw2aqMvU7k370nwWKIN+oY3uNmI5uI6RROwGGLv+HdNEQUbuDWPsAu9Wbzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="I/6Xo7Fa";
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2EE606A338;
	Thu,  5 Nov 2026 22:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F2EE606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=I/6Xo7Fa
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5LEjHF652789;
	Thu, 5 Nov 2026 22:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XqsYd2lSw1RdFz5E61n1O+coqJoZOd
	GtSJ3MY64jZ+k=; b=I/6Xo7FaFK4UtU+6VKF256GqY5y8wH9qZ4rC7HPIMH8Rcl
	H+xaxAlpFdHr6kvjqSjykXfDtk4Xg/phbJ0lu9+eo57lovh9g9YCMybTPPEJFhqk
	03USh6/wHyOa5PSroQYkNLE/OdD6AKrY6RhgsayII+hUqt62Uc3jWIoZDW0eS0FP
	DU93m9PnztIY+X+dkxJkkEp4rNdmchpv82NIwiaPQO2fjR4MUCUWM51P5/4Kr4YK
	vHNWMqNeoaV3A5Vw0azkUZ93/Tmyb8IrVpAJ5heiMcTi4iaPrM6wACg4KcHq5oFs
	SJA5jYPQ8DRpgEz+KfKX7EWUZVaRif6f6DF/47UQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn7u3wdc7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 22:28:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5L5vnN2215518;
	Thu, 5 Nov 2026 22:28:49 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hrk9mmn13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Nov 2026 22:28:49 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A5MSm0A30147216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Nov 2026 22:28:48 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B56D58061;
	Thu,  5 Nov 2026 22:28:48 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5336058058;
	Thu,  5 Nov 2026 22:28:48 +0000 (GMT)
Received: from e (unknown [9.16.46.225])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Nov 2026 22:28:48 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 10/13] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
In-Reply-To: <sashiko-outbox-199779@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 18:37:18 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-10-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199779@kernel.org>
Date: Thu, 05 Nov 2026 16:28:48 -0600
Message-ID: <871p8y9alb.fsf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=Zsp4uN7G c=1 sm=1 tr=0 ts=6aed0322 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=W88SEZPU-MM6QhTnnt4A:9
X-Proofpoint-ORIG-GUID: WKqBcT7hJ3bC_jK0vF_ZiBH0KKcM9b7U
X-Proofpoint-GUID: WKqBcT7hJ3bC_jK0vF_ZiBH0KKcM9b7U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA4OCBTYWx0ZWRfX/5PPS2OP5FZx
 B8HKYeq8J3+LWiiFnDUTPO6DEVwSM+/hcagw3X7GfMrOUvsHYTVqy7moQO36KlXjOZKZwIoMvYT
 BhHw+krOfLaQCh4sVWJ5o8djr/IqLD3hdBp0VEsymWAVitOUlrVOSDeyJ/s/DiN0gJXyA4DhH08
 8Rztp6LiCcpFfqWmKw1j7dd/9p7RdQZk2HRyt6GFIk6TEmeEVoeOaEvYkwwaFLFdik2f7QyaukK
 WR2kHs9WZuR6eSOdMVpX9ehvOWysNqSiSmnyE0Ms6xymEwmVOFG4F0xdZSWaWwEa1M43fucdH0h
 86uLcffVpSZdfdEhK1JpYBZQyDPmlxza+mz3PY3DGdlh4NxLMHLxyxPzOu2KIZUaU+Gg0ebj8Rs
 jhxixFCa4G3PPmXEzy3JZ8JcmlOrj537P1NCQaslGntlT6jfK37T81omBgVQ+TNpzIH+xb1N6GM
 Yb+Qf3XDby1dPytcikg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA4OCBTYWx0ZWRfX18F7olmuplXA
 jWIgjjkrS7bC9XkxNl03nFSoS8FQ/9y6kWodj13Homq4NCeg2gHqT0nuAPul2+PCoqFGI6I4+06
 47JIfgBVwk4J++4nW8EjATO/ZffQqDw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050088

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 7406e7182777c..5dba084086d5f 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -4456,6 +4456,106 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>
> [ ... ]
>
>> +static void ibmvfc_queue_async_subq_entry(struct ibmvfc_host *vhost,
>> +					  struct ibmvfc_async_sub_crq *crq,
>> +					  struct list_head *doneq)
>> +{
>> +	struct ibmvfc_async_drain_entry *entry;
>> +
>> +	entry = kzalloc_obj(*entry, GFP_ATOMIC);
>> +	if (entry) {
>> +		entry->event.type = IBMVFC_ASYNC_CRQ_SUB;
>> +		entry->event.subq = *crq;
>
> [Severity: High]
> Can dispatching an IBMVFC_ASYNC_CRQ_SUB FPIN event here lead to a NULL
> pointer dereference in ibmvfc_process_async_work()?
>
> When ibmvfc_drain_async_subq() passes entry->event to ibmvfc_handle_async()
> for an IBMVFC_AE_FPIN event, it queues ibmvfc_process_async_work() with
> aw->event.type == IBMVFC_ASYNC_CRQ_SUB.
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work(), crq is
> initialized to NULL and remains NULL on the IBMVFC_ASYNC_CRQ_SUB branch:
>
> 	struct ibmvfc_async_sub_crq *subq = NULL;
> 	struct ibmvfc_async_work *aw;
> 	struct ibmvfc_async_crq *crq = NULL;
> 	...
> 	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
> 		subq = &aw->event.subq;
> 		scsi_id = 0;
> 		wwpn = subq->wwpn;
> 		...
> 	}
>
> If the sub-CRQ FPIN event has all-zero target identifiers (for example, a
> host-scope IBMVFC_AE_FPIN_LINK_CONGESTED or
> IBMVFC_AE_FPIN_CONGESTION_CLEARED event with zero wwpn and zero
> node_name/assoc_id, or with IBMVFC_ASYNC_IS_FPIN_EXT set and wwpn == 0),
> ibmvfc_process_async_work() unconditionally calls ibmvfc_basic_fpin_to_desc()
> with crq == NULL instead of ibmvfc_full_fpin_to_desc(subq, ...):
>
> 	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
> 		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
> 		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> 			fpin = ibmvfc_basic_fpin_to_desc(crq,
> 					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 		goto send_fpin;
> 	}
>
> ibmvfc_basic_fpin_to_desc() then immediately dereferences crq->fpin_status.
> Should this path check if (crq) vs else ibmvfc_full_fpin_to_desc(subq, ...)
> in the same way as the !tgt fallback below it?

Fixed in the next revision of patch 9.

>> +		list_add_tail(&entry->list, doneq);
>> +	} else
>> +		dev_err_ratelimited(vhost->dev,
>> +				    "Couldn't allocate async drain entry\n");
>> +	crq->valid = 0;
>> +	wmb();	/* complete write */
>> +}
>> +
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>
> [ ... ]
>
>> +	list_for_each_entry_safe(entry, temp, &doneq, list) {
>> +		list_del(&entry->list);
>> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +		ibmvfc_handle_async(&entry->event, vhost);
>
> [Severity: High]
> When ibmvfc_handle_async() queues ibmvfc_process_async_work() for an
> IBMVFC_AE_FPIN event with all-zero target identifiers, can tgt be used
> uninitialized at the send_fpin label?
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work(), tgt is
> declared without initialization, and the all-zero identifier check jumps
> over ibmvfc_find_target() directly to send_fpin:
>
> 	struct ibmvfc_target *tgt;
> 	...
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
>
> Wouldn't that evaluate if (tgt) and call kref_put() on an uninitialized
> stack pointer?

Fixed in the next revision of patch 6.

-Dave
