Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794420095;
	b=llcnzgtJBdwQDBtp85btCAgrOt/IuGN+EcqarAmxpiXhFmaWnVt91JFd98thNPJu9yeh
	 0FqiyM7VQ610O6RZCZh5v8GrXGqDKQK/uZBfC4quNLyQKl6ywl5uYrAq7DGFUm+ucHTFA
	 XM35Qv2fLEtlZfW0VRAWizQgHtz/xL0aExkhCfVHuUZo5GTMoLMykpZu4qbu63WwaEjUt
	 SQPgWK7bEYn2p1aPkVr5eqEwuXAlCwWEEUgVDoHFPaS4ZRNYdVY2Jj9FGek6WoeEGQgZT
	 Kb1sCytvGsE0H4l2Nq+v9+DfvF1fKZxZ3Saoeg1zki6AGLr1sbMkMyrdSa/91KVp2RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794420095;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xkKB/6JlXiA5b+HTPJzwSIjwVffaKzmj2FfhyQqfzds=;
	b=TmuWVj40yLcaDfngt9StWdOJo+3ETJ+BgpndEpNBbXF0yWi3zLkPNdOpG3v5mDw/IocC
	 TWxtl//UwXTb2ErSjaLTdrTq42grNQ2Hxea6sE4XUytZXTG9WOPsxHRIEn8iETuQt05J5
	 els0TAJ/Dej/9kXSQKFsJyq4MPZmCIjYf9ZpmAuHAB476nejoLijOw6/D1OoGnsB8g1nu
	 uNgPx6YGG587ieTnck+wJCQM7xZLvaYdapXQoasgp8zlK4TqQ3eS9oxrC0vBcuL3+sB2H
	 AmFcKIYBhU92pgK2TnvejdqUIfUK5hGPP4cGinJr9kKWcWDR3mUZixbPdhjYzQIAi7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NiUBiJEr;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257E2606A32A;
	Wed, 11 Nov 2026 18:01:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 257E2606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NiUBiJEr
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABFE6WK4004915;
	Wed, 11 Nov 2026 18:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xkKB/6JlXiA5b+HTPJzwSIjwVffaKz
	mj2FfhyQqfzds=; b=NiUBiJErtIDXwq9hJTdd2COZ8mEtzQxAHRI7rXgS/lBqQg
	QSBgENxa7WaxfD73IPTKwiBzaAd1VDpsTDh1TxH2dGF0LYH++KNA0bM6zZAbTvnr
	tsN7GNzr4LQWAxXspUtJw82jB43zZ93RAKqsR/BnOMrxzq/BqAxPbRKfdFNIc6aM
	JvNAlRSso9CMvJREEsKdm0wECPWiddOae6SmDCUDpWk/O4mglwG9sPF9hHvJD2h/
	rrd1n0LBvCcRKB/UWAIq+D2nhK41vBz2MGmBYuuejkb042VofXvqtpQPGdNinN47
	qqHmKxS6UQWmEjG2HLDj1tPk4W/TRjnHIHqwZkGA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsuntbtdw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 18:01:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABF4vKw3451767;
	Wed, 11 Nov 2026 18:01:31 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hv3325j2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 18:01:31 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ABI1V0a35979804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2026 18:01:31 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3840C58059;
	Wed, 11 Nov 2026 18:01:31 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0C7758017;
	Wed, 11 Nov 2026 18:01:30 +0000 (GMT)
Received: from e (unknown [9.61.143.75])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 11 Nov 2026 18:01:30 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v18 13/13] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <sashiko-outbox-199829@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 05 Nov 2026 19:15:32 +0000")
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
	<20261105-ibmvfc-fpin-support-v18-13-d683b74736a3@linux.ibm.com>
	<sashiko-outbox-199829@kernel.org>
Date: Wed, 11 Nov 2026 12:01:30 -0600
Message-ID: <87fqx7b62t.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MCBTYWx0ZWRfXzXHk98NfOJ3b
 frXVf0PN6CTc2+2LRvEkJgPqwcXl/jEYIq8ew33+bSjS5FOTehJ0KTPuEuet9JcBxMUkhNoB1pn
 OA0rmlYj2ZysWZE6ZgL+ncfxcGOPz4yohWw5lsST2z32cCAghyarLCGI03jqozUKUU/qkUGuQLR
 XZBnL4oCecEThfERoYlHa9LH/i3S45kK3odDgU8yTOqwQ99EuybmZnq+M98/dYePgSM6ffyJMi0
 MDbJAefhEO/RqxOYYkm5jAvVEgJv0oCjv/z7Xh24zv/dLq7sWFyl+nNXGckFt5exqe3WEx19mYD
 zDmFVORMD9chlKkGDIGOzHSM3A2VMgMoxwksRb56yDaoS4To1MliIElbDFGFz5Or9ZyOLIYNqAu
 hmCHVDNAeACNgrw6FWEfEt6fBvxaS76lszah4c4lUVX3xQLxF+UB/sa6I5UxQpHFpYAF/SCYH2s
 nI1S7cqSsrjv+WbbSUQ==
X-Proofpoint-ORIG-GUID: GLEtfslZ1TOJq0BkFglbT3aWs49ZoZXc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MCBTYWx0ZWRfX1U/ERD9/hqmZ
 EotcaejHVZW4n+F965K8AFpo64SIyG1satiyFVlYWl4rblsJ38CVlWGjVlQ9jujcPtn7yrXNSf9
 nTuYpCoS06MMknw5bnz/DAFF5hQRVqo=
X-Authority-Analysis: v=2.4 cv=euZKXYpX c=1 sm=1 tr=0 ts=6af4ad7c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=bHtrxmW-Cm59waH3iFsA:9
X-Proofpoint-GUID: GLEtfslZ1TOJq0BkFglbT3aWs49ZoZXc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_04,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110070

sashiko-bot@kernel.org writes:

>>     scsi: ibmvfc: handle extended FPIN events
>>     
>>     Implement support for extended FPIN messages received via the
>>     asynchronous sub-queue, completing full FPIN functionality.
>>     
>>     Extended FPIN messages provide more detailed information about fabric
>>     events compared to basic FPIN messages, including specific event types,
>>     modifiers, thresholds, event counts, and severity.
>>     
>>     Add ibmvfc_ext_fpin_to_desc() to convert extended FPIN messages from
>>     async sub-queue format to fc_els_fpin structures with complete descriptor
>>     information. Thread detecting_wwpn (fc_host_port_name()) through
>>     ibmvfc_ext_fpin_to_desc() to ibmvfc_common_fpin_to_desc() consistent
>>     with ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc(). Update
>>     ibmvfc_process_async_work() and ibmvfc_handle_async() to zero node_name
>>     and dispatch to ibmvfc_ext_fpin_to_desc() when the
>>     IBMVFC_ASYNC_IS_FPIN_EXT flag is set.
>>     
>>     Extend ibmvfc_common_fpin_to_desc() with a severity parameter so that
>>     extended FPIN events can propagate the severity value from the VIOS when
>>     IBMVFC_FPIN_SEVERITY_VALID is set, rather than always defaulting to
>>     FPIN_CONGN_SEVERITY_WARNING. Severity is only carried by the congestion
>>     descriptor used for IBMVFC_AE_FPIN_LINK_CONGESTED and
>>     IBMVFC_AE_FPIN_CONGESTION_CLEARED; the peer congestion and link
>>     integrity descriptors have no severity field, so a severity supplied
>>     for the other FPIN statuses is ignored.
>>     
>>     Set the IBMVFC_CAN_HANDLE_FPIN_EXT capability bit (0x800) during login
>>     to inform the VIOS that the client can process extended FPIN messages.
>>     Add the IBMVFC_CAN_CLS_CRQ_PRE_DMP capability bit (0x400) definition
>>     for the intervening protocol-defined capability. Also add the
>>     IBMVFC_SUPPORT_FPIN_EXT response capability bit definition used to gate
>>     extended FPIN processing.
>>     
>>     In ibmvfc_process_async_work(), use goto to bypass the generic "FPIN
>>     event received, unable to process" error message when a more specific
>>     diagnostic has already been emitted for invalid or unsupported extended
>>     FPIN events.
>>     
>>     Add a KUnit test, ibmvfc_extended_fpin_test(), that sends extended FPIN
>>     events through ibmvfc_process_async_work() for each FPIN status with
>>     the event types valid for that status, setting only
>>     IBMVFC_FPIN_EVENT_TYPE_VALID, and checks that the matching fc_host or
>>     rport FPIN statistic is incremented. The test is skipped if no ibmvfc
>>     device, online target rport, or IBMVFC_SUPPORT_FPIN_EXT capability is
>>     available. It does not exercise the modifier, threshold, severity or
>>     event count fields, nor the error paths for a missing
>>     IBMVFC_FPIN_EVENT_TYPE_VALID flag or an unadvertised
>>     IBMVFC_SUPPORT_FPIN_EXT capability.
>>     
>>     Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>>     Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
>
> [Severity: Low]
> This isn't a bug in the code, but does the commit message match the changes
> in this patch?
>
> The third paragraph states that this patch updates
> ibmvfc_process_async_work() and ibmvfc_handle_async() to zero node_name when
> IBMVFC_ASYNC_IS_FPIN_EXT is set, however ibmvfc_handle_async() is untouched
> here and zeroing node_name in both functions was already introduced in
> commit 6abed589f0fb ("scsi: ibmvfc: extend async event handlers for async
> sub-CRQ events").
>
> Conversely, setting severity = 0 for IBMVFC_AE_FPIN_PORT_CLEARED and
> IBMVFC_AE_FPIN_CONGESTION_CLEARED in ibmvfc_basic_fpin_to_desc() and
> ibmvfc_full_fpin_to_desc() is done in this commit, whereas it was described
> in the commit message for 6abed589f0fb.

Right on both counts. node_name zeroing is already added in patch 9, and
patch 13 doesn't change ibmvfc_handle_async(). severity = 0 handling is
implemented in patch 13.

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 6e1ecf6891c71..bc65c4d9cb7ec 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -3507,7 +3517,48 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin,
>>  	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, detecting_wwpn,
>>  					  cpu_to_be64(wwpn), type, cpu_to_be16(0),
>>  					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> -					  cpu_to_be32(1));
>> +					  cpu_to_be32(1), severity);
>> +}
>> +
>> +/**
>> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
>> + * containing a descriptor.
>> + * @ibmvfc_fpin:	Pointer to async subq FPIN data
>> + * @detecting_wwpn:	WWPN of the local port that detected the event (big-endian)
>> + * @wwpn:		attached port WWPN (host-endian)
>> + *
>> + * Allocate a struct fc_els_fpin containing a descriptor and populate
>> + * based on data from *ibmvfc_fpin. The caller must have verified that
>> + * IBMVFC_FPIN_EVENT_TYPE_VALID is set in the FPIN data flags.
>> + *
>> + * Return:
>> + * NULL     - unable to allocate structure
>> + * non-NULL - pointer to populated struct fc_els_fpin
>> + */
>> +static struct fc_els_fpin *
>> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin,
>> +			__be64 detecting_wwpn, u64 wwpn)
>> +{
>> +	u8 flags = ibmvfc_fpin->fpin_data.flags;
>> +	__be32 threshold = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
>> +	__be16 modifier = 0;
>> +	__be32 count = cpu_to_be32(1);
>> +	__be16 type = ibmvfc_fpin->fpin_data.event_type;
>> +	__u8 severity = FPIN_CONGN_SEVERITY_WARNING;
>> +
>> +	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
>> +		modifier = ibmvfc_fpin->fpin_data.event_type_modifier;
>> +	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
>> +		threshold = ibmvfc_fpin->fpin_data.event_threshold;
>> +	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
>> +		count = ibmvfc_fpin->fpin_data.event_data.event_count;
>> +	if (flags & IBMVFC_FPIN_SEVERITY_VALID)
>> +		severity = ibmvfc_fpin->fpin_data.event_data.severity;
>> +
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, detecting_wwpn,
>> +					  cpu_to_be64(wwpn), type,
>> +					  modifier, threshold, count,
>> +					  severity);
>>  }
>
> [Severity: Medium]
> Should severity in ibmvfc_ext_fpin_to_desc() default to 0 for cleared
> congestion events when IBMVFC_FPIN_SEVERITY_VALID is not set?
>
> In ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc(), this patch
> sets severity = 0 for IBMVFC_AE_FPIN_PORT_CLEARED and
> IBMVFC_AE_FPIN_CONGESTION_CLEARED:
>
> 	case IBMVFC_AE_FPIN_PORT_CLEARED:
> 	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> 		type = cpu_to_be16(FPIN_CONGN_CLEAR);
> 		severity = 0;
> 		break;
>
> In ibmvfc_ext_fpin_to_desc(), severity is initialized to
> FPIN_CONGN_SEVERITY_WARNING and is only updated if
> IBMVFC_FPIN_SEVERITY_VALID is set in flags. When an extended FPIN event for
> IBMVFC_AE_FPIN_CONGESTION_CLEARED (or with event_type FPIN_CONGN_CLEAR) is
> received without the optional IBMVFC_FPIN_SEVERITY_VALID flag (as in
> ibmvfc_extended_fpin_test()), cdesc->severity in the ELS FPIN descriptor is
> populated with FPIN_CONGN_SEVERITY_WARNING instead of 0.

I agree. In v19, for IBMVFC_AE_FPIN_PORT_CLEARED and
IBMVFC_AE_FPIN_CONGESTION_CLEARED, ibmvfc_ext_fpin_to_desc() will
default severity to 0, like the basic and full conversion routines, and
only used the VIOS-provided severity when IBMVFC_FPIN_SEVERITY_VALID is
set.

>> @@ -3624,14 +3681,30 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>>  		goto free;
>>  	}
>>  
>> -	if (crq)
>> +	if (crq) {
>>  		fpin = ibmvfc_basic_fpin_to_desc(crq,
>>  				cpu_to_be64(fc_host_port_name(vhost->host)),
>>  				tgt->wwpn);
>> -	else
>> -		fpin = ibmvfc_full_fpin_to_desc(subq,
>> -				cpu_to_be64(fc_host_port_name(vhost->host)),
>> -				tgt->wwpn);
>> +	} else {
>> +		sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
>> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) == 0) {
>> +			fpin = ibmvfc_full_fpin_to_desc(subq,
>> +					cpu_to_be64(fc_host_port_name(vhost->host)),
>> +					tgt->wwpn);
>> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
>> +			dev_err_ratelimited(vhost->dev,
>> +					    "Invalid extended FPIN event received\n");
>> +			goto skip_generic_error;
>> +		} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
>> +			dev_err_ratelimited(vhost->dev,
>> +					    "Unexpected extended FPIN event received\n");
>> +			goto skip_generic_error;
>> +		} else {
>> +			fpin = ibmvfc_ext_fpin_to_desc(sqfpin,
>> +					cpu_to_be64(fc_host_port_name(vhost->host)),
>> +					tgt->wwpn);
>> +		}
>> +	}
>
> [Severity: High]
> What happens in ibmvfc_process_async_work() when a host-scope FPIN event
> (IBMVFC_AE_FPIN_LINK_CONGESTED or IBMVFC_AE_FPIN_CONGESTION_CLEARED) arrives
> on the async sub-CRQ with wwpn == 0 or with a WWPN that does not match a
> target in scsi_scrqs or nvme_scrqs?
>
> Earlier in ibmvfc_process_async_work(), when aw->event.type ==
> IBMVFC_ASYNC_CRQ_SUB and IBMVFC_ASYNC_IS_FPIN_EXT is set, scsi_id,
> node_name, and assoc_id are all set to 0, while crq remains NULL:
>
> 	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
> 		subq = &aw->event.subq;
> 		scsi_id = 0;
> 		wwpn = subq->wwpn;
> 		fpin_status = subq->fpin_status;
> 		if (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) {
> 			node_name = 0;
> 			assoc_id = subq->id.assoc_id;
> 		} else if (subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) {
> 			node_name = 0;
> 			assoc_id = 0;
> 		} else {
> 			node_name = subq->id.node_name;
> 			assoc_id = 0;
> 		}
> 	}
>
> If wwpn is also 0, the zero-identifier check right after that is taken:
>
> 	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
> 		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
> 		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> 			fpin = ibmvfc_basic_fpin_to_desc(crq,
> 					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 		goto send_fpin;
> 	}
>
> Here crq is NULL, so ibmvfc_basic_fpin_to_desc(crq, ...) dereferences
> crq->fpin_status on a NULL pointer.
>
> In addition, if wwpn is non-zero (for example, set to the host's own WWPN or
> a target whose rport/nvme_remote_port is no longer present) so
> ibmvfc_find_target() returns NULL, the fallback path only calls
> ibmvfc_basic_fpin_to_desc() or ibmvfc_full_fpin_to_desc():
>
> 	} else {
> 		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> 		if (fpin_status == IBMVFC_AE_FPIN_LINK_CONGESTED ||
> 		    fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED) {
> 			if (crq)
> 				fpin = ibmvfc_basic_fpin_to_desc(crq,
> 						cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 			else
> 				fpin = ibmvfc_full_fpin_to_desc(subq,
> 						cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> 			goto send_fpin;
> 		}
>
> Because IBMVFC_ASYNC_IS_FPIN_EXT and ibmvfc_ext_fpin_to_desc() are only
> handled on the tgt != NULL path, shouldn't the zero-identifier and
> target-not-found host-scope paths also handle subq and
> IBMVFC_ASYNC_IS_FPIN_EXT?

The zero identifier branch will be addressed in patch 9 in the next
revision. You're right that the host-scop paths only use the full
helper. I'll fix this in v19.

>>  send_fpin:
>>  	if (fpin) {
>> @@ -3642,6 +3715,7 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>>  	} else
>>  		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
>>  
>> + skip_generic_error:
>>  	if (tgt)
>>  		kref_put(&tgt->kref, ibmvfc_release_tgt);
>>   free:
>
> [Severity: Critical]
> Can tgt be uninitialized when reaching kref_put(&tgt->kref,
> ibmvfc_release_tgt) in ibmvfc_process_async_work()?
>
> At the top of ibmvfc_process_async_work(), tgt is declared without being
> initialized to NULL:
>
> 	struct ibmvfc_target *tgt;
>
> When all target identifiers are zero (!scsi_id && !wwpn && !node_name &&
> !assoc_id, such as for host-scope FPIN events or the zero-identifier test
> cases in ibmvfc_async_fpin_test()), the function jumps to send_fpin before
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
> After send_fpin, execution falls through to skip_generic_error and checks
> if (tgt) kref_put(&tgt->kref, ibmvfc_release_tgt) using the uninitialized
> tgt pointer on the stack. Should tgt be initialized to NULL at declaration?

This will be fixed in patch 6 by initializing tgt and fpin to NULL, and
the NULL crq issue will be fixed in patch 9.

-Dave
