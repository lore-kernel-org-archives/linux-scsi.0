Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506446;
	b=vqQ5XS98PSsWoKPzNcJRN6UChHbps7TXtkGh8bv1p6Va9KxvpeUdkO2XfcFaQQRlLK33
	 ou0OcLyhTkr263kHMLN25tVJR+8Y2qYKzut0aeQ+sGPSza4uL+ghCup9ciSAZZlFfS660
	 aYKTGBmaMol/Q3iYWYb0E8WMXTRuVwjihu3JIYmV1FN5h3QoTIyY8rRmlEh32vjKehW4b
	 lCHQdyg81OMkYS2WFJkrCRKxQA3WUiOdKMtd4HV0FhGDhtK250rxgCQxObdKHAyZvFfL4
	 j1Z5uhhDqnMeJ2nEcEWTlD481o+qcyfLq6u9HTyvsjaU0Fer7me22QoWXx5bDfl+YOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506446;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=FV4cnaw7sRSsSt0x7slQQic/Dpvr2Ij5JXzJAPl6FIQ=;
	b=TqcZX0U2HFQk7ga9hazNCo/Y8It2whBTcHfqBVzkFL1bpAxXBiGw7gPzjGj8D4rlMn/V
	 GHIy/zMl0Aj2hPQmiDzQArBXP6/Irf1HsuB2tn7tFrtcMOsgSrpYMkpdfPWCPOiC/J8RZ
	 9LDv1BQfju32a7Q9/gKIqmy0n1cln+Ydm8WtbcsgxkgoHiR8w0gBD/JIxnh2Ug8fm0ANY
	 cWPqE0BMWibLdO+mi1HIMuI2LmvrQc0+Z5scUtVd7rjbv8LArwGNgFhIZwLEqgCeKV10A
	 b89uMmGm9Xy5FOqfEMSZ0JJMguW5HwWXrTuZvUAEQCJ4lkqGe3FoBlzpWB+oy16FHWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lGb3x3GC;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BEB606A31F;
	Tue, 20 Oct 2026 14:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4BEB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lGb3x3GC
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDEC3Y870541;
	Tue, 20 Oct 2026 14:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=FV4cnaw7sRSsSt0x7slQQic/Dpvr2I
	j5JXzJAPl6FIQ=; b=lGb3x3GCdnCbk115hL/vSalBfeKRA5ZIW7Ruta+u+h0TYB
	EzavphSGyMpMc0DhxdxoJVzxJZAE1OFu9V9Arl5Qhws8moqzb0TIKd+yqQIKsH05
	eYMByFl7ivMuRczy773ttR/8js+Hw9+BeJ9LLSETtsFEN5RkOsupRZYldpdRriSu
	RKSPauUwAJjUfgK2ptUPYrDe+Lc6rI8Y6RahX+Ijb12t6r9gOTQQtwR5kFtEDI78
	GfuO/dzIy04bF4Eht16kJhM13rYR5PAUL0+BgA1XkrVAFL+RH2OTp8FgUQBfobkj
	ES/GmL96ffHTLufofD3gJteqDALQ0ZPl8lcC1Beg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bbc4r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 14:26:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDK1oD350705;
	Tue, 20 Oct 2026 14:26:53 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hcnjh28nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 14:26:53 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69KEQ5ab52756760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Oct 2026 14:26:05 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BC275805D;
	Tue, 20 Oct 2026 14:26:52 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F10A858065;
	Tue, 20 Oct 2026 14:26:51 +0000 (GMT)
Received: from e (unknown [9.61.26.156])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Oct 2026 14:26:51 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v15 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
In-Reply-To: <sashiko-outbox-178320@kernel.org> (sashiko-bot@kernel.org's
	message of "Mon, 19 Oct 2026 22:29:27 +0000")
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
	<20261019-ibmvfc-fpin-support-v15-3-a858726e178a@linux.ibm.com>
	<sashiko-outbox-178320@kernel.org>
Date: Tue, 20 Oct 2026 09:26:51 -0500
Message-ID: <87fqy0la6s.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: rbqdMuafVYe9-JTqUFofQxsSCoC1rVS8
X-Proofpoint-ORIG-GUID: rbqdMuafVYe9-JTqUFofQxsSCoC1rVS8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA1NiBTYWx0ZWRfX9OUMHlgCUHii
 LPk69ELpJQpsWLdAZwNfozd3NjP4ktSyRJYtU1bfxLnTpQJnzTRIP9+H662Ofu/XVxx9yTT94g2
 6IZ0W48/V5Sqr918hLGQURaM/shxVx8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA1NiBTYWx0ZWRfX4IZNGx4m9K0f
 3mSIlV4bIQU+fvI3PufNILahjK0mA+3jxB8WtQxcMbiPauYC4VPvbg7mHVFCKOTZmXZEtU69wfR
 ZBnaMXyD198o+vZdQTlYp1bNm+9uJfWu6ejbInwqeh9b+FryuDzeuzmCNDC53pkHMxBImpzAY45
 tdOCAkkFbubFvIPd2Vqs6TJikUwhUhTrGdXfWD284EACH85C4DudhEuEDzH1SbMO+r2lEQVwzAs
 ziM5aPyI7A471q9kLb0GiMcpUOyQX35VHMMj7Sq74h/QRVt+8xGSlyO6Lua7uzo5AEGzad41UBn
 xWJMqDHI9HMxW2Ld0h9NtgeoDW5rrxHwnh/jgPlWKi6MqfejCC1929PzI6y3XF7c2L95D3HOERN
 fBFFiDmd2V+/0dUqBiIycG1Amr1LV6egQU7tfLvFUH8gv9xwrxRCIRL0hM3kSW0BTYBwwQzJjs8
 /zN5a3gwcNqEeNoVvTQ==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6ad77a2d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=p80Zfm7aPcmGqdMWmFsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200056

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi: ibmvfc: scrq->cookie not cleared on H_REG_SUB_CRQ failure in ibmvfc_register_channel()
> --
>
> commit 09a8086d40f44887491493f172cd7dd44285d18d
> Author: Tyrel Datwyler <tyreld@linux.ibm.com>
>
> scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation
>
> This commit guards ibmvfc_deregister_channel() against calling H_FREE_SUB_CRQ
> on an unregistered sub-CRQ queue and against zeroing an unallocated message
> buffer. It also adds a KUnit test suite to verify the deregistration guards.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 145d559041f12..0fe6b6f4260ba 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -6449,12 +6449,24 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  	do {
>>  		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>>  	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
>> +	scrq->cookie = 0;
>>  reg_failed:
>>  	LEAVE;
>>  	return rc;
>>  }
>
> [Severity: Medium]
> Should scrq->cookie = 0 be placed after the reg_failed label (or should
> h_reg_sub_crq() avoid writing *cookie on error)?
>
> Looking at h_reg_sub_crq() in drivers/scsi/ibmvscsi/ibmvfc-core.c, it
> unconditionally writes retbuf[0] into *cookie regardless of the return code:
>
> static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
> 			  unsigned long length, unsigned long *cookie,
> 			  unsigned long *irq)
> {
> 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
> 	long rc;
>
> 	rc = plpar_hcall(H_REG_SUB_CRQ, retbuf, unit_address, ioba, length);
> 	*cookie = retbuf[0];
> 	*irq = retbuf[1];
>
> 	return rc;
> }
>
> In plpar_hcall() (arch/powerpc/platforms/pseries/hvCall.S), r5 (unit_address)
> is moved into r4 before HVSC and r4 is unconditionally stored into retbuf[0]
> after HVSC, even when HVSC returns an error such as H_PARAMETER or H_RESOURCE.
>
> When h_reg_sub_crq() fails in ibmvfc_register_channel():
>
> 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
> 			   &scrq->cookie, &scrq->hw_irq);
>
> 	/* H_CLOSED indicates successful register, but no CRQ partner */
> 	if (rc && rc != H_CLOSED) {
> 		dev_warn(dev, "Error registering sub-crq: %d\n", rc);
> 		if (rc == H_PARAMETER)
> 			dev_warn_once(dev, "Firmware may not support MQ\n");
> 		goto reg_failed;
> 	}
>
> jumping to reg_failed skips scrq->cookie = 0, leaving a non-zero value in
> scrq->cookie. If ibmvfc_deregister_channel() is later called on this queue
> during reset or teardown (via ibmvfc_dereg_sub_crqs()), won't the new
> if (scrq->cookie) check evaluate to true and issue H_FREE_SUB_CRQ on a queue
> that failed registration?

Yes. I will move clearing scrq->cookie after the reg_failed label.

-Dave
