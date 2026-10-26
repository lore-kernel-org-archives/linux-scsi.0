Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793049463;
	b=LbSV9ywcVyZ3b8XehhjTkkFLFf2QSGidcHyhWCG1LBiThRQ0vlFfCHRU0YLKQ8gGkQUh
	 ddQiYuxgJPhtRVW+Hwl9LupBtUkVIHrSdu/dLjvXJD/p87zCsgjcWVSFsz66R64Ehw8qc
	 Gjcjrf22RZX2aI5S1Z+jbc1as3clrBoiDiXLCPu7ITug+fkm/qjf87bytyeXPg2NOwfri
	 YplQ+wOHD6UKz7nxpOsBIr2k2vvxfYO9H55HqiT3p0ATY5zyoOTt/Wgf+SIdTlaYjigjP
	 3KqPj2YN2aZ4EYhfc+JVypHZIxkpVi8pImM2iu5Aqx+Z+AT8LWRAZwsDU924UHEHK7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793049463;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=e2Ui39yGphVQXmHqV++3fx2VRkqj2x1+yGDqIiiKip4=;
	b=2YOt0lnKZg40PEQ+R5m95Hj6dUQUzgq30kgUAT1VqzaqAaG3gZfJXB23n0SYlj+qMxJd
	 yhpoua0ArnjKqszaVWbXY10b7IusJSUmWKa6Rf9Ju0peUNzhkPp4mGo9T2lWVSt1Ixh8E
	 lSX8sivBDBifIbYyb5SKwn7stRzFJ2/kGKaeM1B80smTYF776DKlAlZM2sNhb8EwjybRZ
	 CcDxtoEDmHoMJSAY8Jn3klRy+qBiEJUmCB4DeUBWG4BS6DkAxtHRYgxpYYb9zOZOearEm
	 3vFXi2/vH/9CmRSWCPZgPCOnSeCAWjpqZmAt9GK+17EocQQHjich3RNy1FAveu1/q7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=cTbFXiZC;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB76606A31A;
	Mon, 26 Oct 2026 21:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EB76606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=cTbFXiZC
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QJFHw3276673;
	Mon, 26 Oct 2026 21:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=e2Ui39yGphVQXmHqV++3fx2VRkqj2x
	1+yGDqIiiKip4=; b=cTbFXiZCduDDRZfa8/6oWlRR35izjm9jnI2pTbz8+n1XEn
	nedsOqJQ5LmbMrcZLiGLFSUNpFIr0pK8ig2UtzSp9ImodFgl+v+MMazyGCosIKZe
	qfrnDrlynm5zLXVKXdQ8lLBVIiIh3DyWb3t8cU+e+hoxtBqUSJ0JmpRkDxeOGl33
	atvcUL1ykeTCb6DEKVmMd75ovwZ57q8SkHfi+b97uLtegYenvHMZM7wzoir2nqxb
	rBAInGFZcvff+E9bT83VzrdRDSlJiy/Npt3WDnZd3p8UMgx96Fo/7diqGltrSSxf
	zuDoKV3QNTMvd7Lkc72m3rbyDpqTuGvOyYk76Ucg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgmavc1d2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 21:17:40 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIovvI3043177;
	Mon, 26 Oct 2026 21:17:39 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8ggywpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 21:17:39 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69QLHc0K50659632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Oct 2026 21:17:39 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E20E358055;
	Mon, 26 Oct 2026 21:17:38 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C365C58043;
	Mon, 26 Oct 2026 21:17:38 +0000 (GMT)
Received: from e (unknown [9.61.189.219])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Oct 2026 21:17:38 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v16 03/12] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
In-Reply-To: <sashiko-outbox-185517@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 26 Oct 2026 16:26:58 +0000")
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
	<20261026-ibmvfc-fpin-support-v16-3-a900aa657ed5@linux.ibm.com>
	<sashiko-outbox-185517@kernel.org>
Date: Mon, 26 Oct 2026 16:17:38 -0500
Message-ID: <87fqxsf9fx.fsf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=P8SvFSAu c=1 sm=1 tr=0 ts=6adfc374 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=TxC64Fj3QtcIoGYGvycA:9
X-Proofpoint-GUID: cEz9mXxV2YixcaGcLimKAsRdGVF2UX0A
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NCBTYWx0ZWRfX3JvF+OycFehH
 6PwncLv+soUD+YgBh0Xlq2bgzkldHgFGqhmvjj1R+v1bXLlZMyFPlti69Nukv1OZF5fvV1Ior8f
 Ic/8q0XgkKu8oHflDUdzrvCWed/kYMo=
X-Proofpoint-ORIG-GUID: cEz9mXxV2YixcaGcLimKAsRdGVF2UX0A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NCBTYWx0ZWRfXxw067mLq0l2v
 XjQOCwz7oU9c4OoeIksZ8P6KxxsrbYLDuL/aHupFzi+PcCxW/BNxvBF5MMktLucRM6NGleEeNu6
 s5UzAR2k3cu3CFi3kA63GSgh0Ym1IQ4F76Y/E9Wt4YO9mX1HncKNXlLOcjA15AIAgvlsOKC4M9j
 C6ewCm3uznAj3Ex4cNDEAaZKUdx1yelYHjLKeaWqq1uvM26GoBG0AZV6AJePIsg/STQzEgIc4lV
 tW80XOHaNYvHkWx4ueGljFNwFNVIBhAP9jD4RY72jGgqBrQqetImOrD5uDs7k0AxRSyfJ47j3BW
 nRHtO+Fh1aDNB9m+rKNED1HUTfr7ewQmU5ms9TRsUhA+K6Q9EQNb9XoIOHh9/dAoOebdmLi0pab
 INZ/5Es/LNBbjB/ZeQYZ7KIDUWlUDygeG1+aHSz8u/JQTASq7Cb+GmfIhG3cKu5YjKShpYEYSb6
 Zu31zLQV+CRkylPPScQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260084

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] scsi: ibmvfc: build failure when CONFIG_KUNIT is disabled
> --
>
> commit e6767e190b474e7d3a6e33d2ed96de8dbb05ff1a
> Author: Tyrel Datwyler <tyreld@linux.ibm.com>
>
> scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation
>
> This commit guards ibmvfc_deregister_channel() against freeing an
> unregistered sub-CRQ or clearing an unallocated message buffer, and adds a
> KUnit test suite to verify the guard conditions.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 145d559041f12..f0502d7482105 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -6450,11 +6450,23 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>>  	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
>>  reg_failed:
>> +	scrq->cookie = 0;
>>  	LEAVE;
>>  	return rc;
>>  }
>>  
>> -static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>> +/**
>> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hypervisor
>> + * @vhost:	ibmvfc host struct
>> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
>> + * @index:	index into the sub-CRQ array
>> + *
>> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ to
>> + * release the sub-CRQ with the hypervisor. On success the queue message
>> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fails,
>> + * an error is logged but the channel resources are cleaned up regardless.
>> + */
>> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  				      struct ibmvfc_channels *channels,
>>  				      int index)
>>  {
>> @@ -6471,20 +6483,28 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  		scrq->irq = 0;
>>  	}
>>  
>> -	do {
>> -		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
>> -					scrq->cookie);
>> -	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>> +	if (scrq->cookie) {
>> +		do {
>> +			rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
>> +						scrq->cookie);
>> +		} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>>  
>> -	if (rc)
>> -		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
>> +		if (rc)
>> +			dev_err(dev, "Failed to free protocol (%d) sub-crq[%d]: rc=%ld\n",
>> +				channels->protocol, index, rc);
>> +		else
>> +			scrq->cookie = 0;
>> +	}
>>  
>>  	/* Clean out the queue */
>> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
>> -	scrq->cur = 0;
>> +	if (scrq->msgs.handle) {
>> +		memset(scrq->msgs.crq, 0, PAGE_SIZE);
>> +		scrq->cur = 0;
>> +	}
>>  
>>  	LEAVE;
>>  }
>> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
>
> [ ... ]
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
>> index ca80ceffe53a5..421ce8bc3ea33 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
>> @@ -1088,4 +1088,12 @@ static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channel
>>  #define ibmvfc_remove_trace_file(kobj, attr) do { } while (0)
>>  #endif
>>  
>> +#if IS_ENABLED(CONFIG_KUNIT)
>> +#include <kunit/visibility.h>
>> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>> +						struct ibmvfc_channels *channels,
>> +						int index);
>> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
>> +#endif
>
> [Severity: Low]
> Does this break the build when CONFIG_SCSI_IBMVFC is enabled and CONFIG_KUNIT
> is disabled?
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c, ibmvfc_deregister_channel() uses
> VISIBLE_IF_KUNIT and EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel)
> outside of any CONFIG_KUNIT guard.
>
> However, drivers/scsi/ibmvscsi/ibmvfc.h only includes <kunit/visibility.h>
> when CONFIG_KUNIT is enabled, so the fallback definitions in
> include/kunit/visibility.h:
>
> #else
>     #define VISIBLE_IF_KUNIT static
>     #define EXPORT_SYMBOL_IF_KUNIT(symbol)
> #endif
>
> are never pulled in when CONFIG_KUNIT is disabled, causing compilation of
> drivers/scsi/ibmvscsi/ibmvfc-core.c to fail due to unknown macros.
>
> A later commit in the series, commit 1bc41de0e60f ("scsi: ibmvfc: add basic
> FPIN support"), adds an unconditional #include <kunit/visibility.h> to
> drivers/scsi/ibmvscsi/ibmvfc-core.c, though leaving this commit and commit
> 1b37c48a1902 ("scsi: ibmvfc: add link state to host struct") unbuildable with
> CONFIG_KUNIT=n during bisection.
>
> Should <kunit/visibility.h> be included unconditionally in
> drivers/scsi/ibmvscsi/ibmvfc.h (or drivers/scsi/ibmvscsi/ibmvfc-core.c) in
> this commit?

I'm configured a kernel build pseries_le_defconfig and then turned
CONFIG_KUNIT off. Indeed, there's an error when building ibmvfc-core.c.

I tried including <kunit/visibility.h> unconditionally in ibmvfc.h, but
that caused build warnings for ibmvfc-nvme.c about unused
functions. Including <kunit/visibility.h> in ibmvfc-core.c resolved the
issue.

This will be the fix in v17.

-Dave
