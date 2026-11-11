Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418978;
	b=zSNLugO0cmuTGBaCZSRbrvkP/VnxWtxtBe5gohBXbk+pXk5tpQ1ykc1XucyJ1noAz6F7
	 0PgIKmTM+C2kegning60i7y6u8+Ii2Z5Wz2yOLtzgsrSyOIVtX7s+d9+1daWpYz/y7xzA
	 aHRZF2Y+Lzvo6obAqN4weDJ77C+u2K19HkU9ywRPSeOUhY3Amjv3LZR1ZHD0k4pJ0aYsd
	 6pyXgSJTD/M3XSwKqjdoFhszJc58POPs//P8JdqULPVP2TRPrJ099fFHkcr9YnAXfKlu5
	 hU/Pn6UP1R59rLtj/9d0XGJXI3327qoSSZeE8wwR3ybPN/6BsDtSH0sOp/3dqga3bmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418978;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=f9mUOKIBmwwH/CNGCaFVoqEC8uoxFYGFzSa6o8OHDjc=;
	b=LWGuH2kV6iAacKHBBr0tP9S9TqoP+7Lggaw3pHRzei2NNUoBlTiIFxH9QcklZMozV9Hf
	 sT8jWMGe1xCHdixIkcUlBsFuiewvjglpzvUTawArfCMDUq21vLSeL8EhwwdKUORny0Vqb
	 xcOgdJun3kcHuEjjYI6/0RWuJVUJywkVQQ5M1Xk5EE6DuzFozmtTT0+Mr1oQhzbPCNv6E
	 iOA08y3lyu5QczMuZYGH2wq2hTQDYGuJly/Ehz8p824TASjhllzhKUbDCxGx5nBaoCO6O
	 r7Q/KNcPLPCP62RbbNa5FoBNDEk0k6cH797Ar1dXTDNAhThe5cOF+MYV+r+EZVb9FKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=EQdOdijX;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD2606B4D4;
	Wed, 11 Nov 2026 17:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48CD2606B4D4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=EQdOdijX
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABFEklL1457124;
	Wed, 11 Nov 2026 17:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f9mUOK
	IBmwwH/CNGCaFVoqEC8uoxFYGFzSa6o8OHDjc=; b=EQdOdijXrbaQRTGF2Ik6uB
	Hmy7XkjVPnGBMuI+JtpfR/RcnyCKokMeH+UPwGX7gQoVue41QK1nQCxqpb4cig6X
	k4c4XBWYLdxp4ADix4v7jBBZ6GHvWEKmP6VVsmd2Ll5tEjav9aE7GxqpDVUkNe6K
	k0NND0VIXiN3Y0Jo7XTXekOLFJ3wM4WJEBoIyP6ELb7iVX0R729pVvs8i4lNB9fY
	0LdB5XLfwcmBhD5gzEVG5LiX8FvldqBNROTbPKkfzcxyUmCaP//M/rsQ699HVMtV
	jzJ10txRiCXvJgRLlh4xC0iVUDyoFMU/qO2OVPOlNpunMo0R6uh7PYgi+pBB9nqA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsumv2n16-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 17:42:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABF50rV3451799;
	Wed, 11 Nov 2026 17:42:51 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hv3325fka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 17:42:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ABHg1E330540356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2026 17:42:01 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E61865805A;
	Wed, 11 Nov 2026 17:42:50 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68FE558051;
	Wed, 11 Nov 2026 17:42:50 +0000 (GMT)
Received: from [9.61.45.73] (unknown [9.61.45.73])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Nov 2026 17:42:50 +0000 (GMT)
Message-ID: <7d02a309-52e4-4b50-b27e-c6295fd25d8b@linux.ibm.com>
Date: Wed, 11 Nov 2026 11:42:49 -0600
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Paul Ely <paul.ely@broadcom.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: msmurthy@linux.ibm.com, mkp@kernel.org, Hannes Reinecke <hare@suse.de>
References: <CAEQnVQ=uT+zMiF_mPD6j2g6qrpUL1Eufw=QNabJFEOz_wwLVRg@mail.gmail.com>
Content-Language: en-US
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
In-Reply-To: <CAEQnVQ=uT+zMiF_mPD6j2g6qrpUL1Eufw=QNabJFEOz_wwLVRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA2OCBTYWx0ZWRfXzTPjPCIO1d5Q
 I6hgbWOg1NiOkvJx5YW1VhRFqEaCqILOkWw8FGVVt5UTvVtVPN45IS7yDYmLZpvDZ4gfews9moU
 BvJ8O1btBCxWDsDGBhQNs4YxdWGkgCk=
X-Authority-Analysis: v=2.4 cv=GISdgeNK c=1 sm=1 tr=0 ts=6af4a91c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=E_2tHj-O1oUf7s_NJO8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: aJLwOjoTNRAjU3ALlAbZ5n9qWZhpHMKl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA2OCBTYWx0ZWRfXy52qBdeG9Upn
 L9XEfEJhInopOP/axmIxUU4mc89ZSdMuimawdHqkSajVjArw06Un1oubV5tWNSkhDYHrMetWvGg
 s58fsMNLNvlcNWUIfwTgoqGFL/RSPHbSXWp+vwgwc9M+6CLrp6srptYByWwYFawFojrT2GTbeDb
 wnZfpZBjQaJKL5tZVK8FhKwC6La0iDhyU2I3/cr3ZQt2CwJlVvUs2N7EUARUK990Ggxmi60T7MC
 wVqOJWFlhu2y2skRqLUFTNmFvOWoYO7kt596SUCgkxlGagH6m95ifAk0/I4DnGhoxUVLttrPm8I
 0ldvRLijC75BQ5E4XuHYSiPpD8RCTtBdhBxx4vZ5LJGJmDZ9UA8/q40qTbvd1igSqKhCO3DTp4X
 jyf+B2NzjmeMIlxzybuWAFwkWRo+dqtgRkpmcfGGpu4maVkK57zVea5PuSPluL/yRfosFo9OQgF
 iryiG7uj14jiWGy+HsQ==
X-Proofpoint-ORIG-GUID: aJLwOjoTNRAjU3ALlAbZ5n9qWZhpHMKl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_04,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110068

> Hello Kyle, the patch would not apply.  There is an extra space here
> in lpfc_els.c:

> lpfc_hbadisc.c also has a white-space issue as well.
> --ignore-whitespace allows the hunk.  I looked quickly but didn't see
> it.
> 
> The patch still looks good -
> 
> Paul

Thanks Paul. My mail client was very misconfigured... I caught both issues. v4 on it's way! 

Kyle
