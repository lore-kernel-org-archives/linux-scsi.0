Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483066;
	b=IibAnU92Y+LVtBatxQC+sxMnLmTBJ5Ml816ZQhRGNhL44w6MsTxRGIv2RAgKi/dKNXnV
	 GHmOAqYwCe6el1Kq/2EPPR4n8vrDyqLSjTsXo3u2yRXl33NQwdT+pgJVYSAu4wosYwJ/b
	 o8WsKe/SekJaZRFyg4bPHnVZYi0QlA1eyT8tsfWz9gCxjScJzMLJXJ715DGferGD2QUG3
	 JOETayGfM7Cgposu+C6+KKG3B/k16u5jhJ/kXhCgYhRO1bJSH+cVWyyj3JaVJizAgUExt
	 kTxVGMNxio3BTOqI35AeWf1ojBGFqNNHRnRb8R/DyOsk6cJn879eVL2SvD/Md+gJT6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483066;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
	b=pjBLb7a6AMPsIKHb0LcmEJzOgb8i7ioQ+wBC94HIzI/PtW7KEqGtQMTGqGItQLQY1TE+
	 ek9ELASQztMTvE8ajzr0CUXeu0faycS5Y++xguxlLxbmPBSJ/0Aen6CdHHAgeBLQhQmcF
	 Aos5GsU/YyyfyuFizip5KxwgRyCuLKDGdukFufwdfvukAwXBKH/SscX9eodr3TPx7F6Yn
	 JUO4m3fP6q8H24T4/rukO/6vk3jtbPVBVUoE0DwI+8lFaC63Xaf1tuxjArumC2KIWnuFH
	 P6KsPnjGbT2v+emERPo5W9QruArOFMKb0eE2TD2UasZB9IX3wpD36a6lLOVjCNg2HIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=noy8g8YV;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IHaDqmdR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC2B606A8A1
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EC2B606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=noy8g8YV;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IHaDqmdR
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7oWxI2818579
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=; b=noy8g8YVf9J5rPmJ
	UwPBDCfjMPKR0RmF3O1R4xqqK4215RtxouUI53FnNoC9ggbOyZ5yfKNhSw5DT2vj
	pJ93GKcm5Y9lx/YDIYENjiInMGcgL3vT42v2b06iyMnGxn7bJMzvHKpfRCXCmAZG
	vCvwppkw666OrlXoRusHBZhvx5z6UP9TxyMed4h1lO5cPZWrwWQ4D0iJfhYo9d1x
	Mr9Apx1eNK2WCkcr0PwgIcd9V2J57kweSJIiPXIyezzIyYW6tnFvB0rSgp1PBssm
	xD2VZGHTH/CIpA2JeqyCllSSay5jVvY8YyxeUoEpX5C2CgGb74roTmgdwvZJ8CtA
	+nBKxA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw9e18sg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:31:04 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b7cc3f8a4aso3281917b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 03:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794483064; x=1795087864; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
        b=IHaDqmdRB6t49l+r1ABPC0H/gRzWI0foqbJXdf3Oi3OOXaWCt2T/zlXktJC4NgHzpB
         WZH9o36gAAP67sG4sjCZKN5Iw9eaEgNuFocH6wKP0uEM3RCyM8W6j4bOhCjIu5kqQla8
         aPMMBnsP1KanCG2p8st8tYxnynQWmMu5vrUTmXf1rUBcHUqQk/dv1jLUB0WyC5Vu0cxq
         +6AycmpDTvbctcQNlp8nc4uYKSzOQuSBtjyiSdEXkm+NF5SkOFwGWbOUtdaLj37Bm1sR
         owPaLn/N8ZTBBLgFJeLPXPd7rY7tDvv8EleuhMyI0l8wqkO9GMg879ope2z8Y3IBg8yE
         nxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483064; x=1795087864;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
        b=sJA3elZxb1KS7dMoUHGtnF4mbKV6ui2BG0teaDS/ffebLXPAIH2hn9Gl6emdDt1gDm
         PcmRUxSFtZ66Y30GN4nvS4+sM8AKT9Cloz3yJI2wtTXBIfSJnylFChSUkpc/kez9TaoG
         AhNiW02gcnWLHMXakb0KSeAxtJGGU2eg1ZduFe0U16qhu9LY52TPdvhPfSYq+P4joFft
         Q/O7dX76tiM9otMf9DchzPIKVNttatn71pl9dcYy0eUxyo8iPp3kSHcPfp1l+wFq95Ed
         6dmsjVKNONn4wGZRHUp9KMxh+GP6OZtv8UIlOJhwnIm7pCj49ZovQ4EMWDNo8UGOqN9v
         utSw==
X-Forwarded-Encrypted: i=1; AL+hErEMLhWqrBx8mrD2/MucFkvqPgqFx4Oace8xiu+WzUcs1wF7JcppMCgnLSFsR2cvqkEEovTBMKHJAqRc@vger.kernel.org
X-Gm-Message-State: APuU4Z8XTbBOkHjVoKVZaM20HnT1s9+SJgZIgbp/S6faGVu04Pqt5hpr
	1vTOw8bryj+D9M4/6qx4QDVqNVKGdgzQjwSo01D36R13sdumefWlrGhiJuDK10B8H9e85Zke9em
	GMTjcxr4ZNaLK9Nos11qIv2jJjp/vFuac0yltvdA57Cbss5HVArqQLH2ue81CEpiy
X-Gm-Gg: AYBFou0J6d7p9BfYY5K0gDqiykhZSqsj+llY+9BLuVff8G9po90/BfPteMfqzr42XB1
	Yk++N3byoZUo+4yefbeKKPT6ddl7ptXEnCLgBQqvccMyFnQi0pATpNrWZ6ww5Zv2X09rtJQ9jE9
	UJ6OymMiGBII9hrULQ3gSgMSiXVAkaKhh6/25pprO6e2ZtHziGheSajK9u5BiYSEHdf8RbPBHxA
	SMtl07Mi2bMk9C8hgaeCgEwOAyB56leQLez1JTY2J4HPD9eQwqxSeVPaOXNTdOSBA+vLlWUTP8+
	eI6LRNFkVnOoBFM7at5xZ4Y1mCxDD9MWkDIaxUyCl1qS59wsTRFd2ekgvzF0TRP6HsrA8Ry7VGE
	VS2mjJ5oDtGlZR+o5W6TIW6g/UHfkVMLLiqIeIevU8iXG1S1xosEnsDmjI7/FZ5/y//cRB0riGG
	J0j94=
X-Received: by 2002:aa7:930c:0:b0:88d:4b30:1c11 with SMTP id d2e1a72fcca58-8bc19dcf4eamr4997939b3a.6.1794483063968;
        Thu, 12 Nov 2026 03:31:03 -0800 (PST)
X-Received: by 2002:aa7:930c:0:b0:88d:4b30:1c11 with SMTP id d2e1a72fcca58-8bc19dcf4eamr4997900b3a.6.1794483063458;
        Thu, 12 Nov 2026 03:31:03 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e110sm3264720b3a.36.2026.11.12.03.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 03:31:02 -0800 (PST)
Message-ID: <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 17:00:56 +0530
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
Subject: Re: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
 <20261024182904.GD2553@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261024182904.GD2553@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA0NSBTYWx0ZWRfXyQ+nLddvKGr8
 j2LJJJIU2356Mij90Ps6jh2yQIzFjWBLHgLTNZMNs50CYi5Jl8iLAAacUax/Or3LqSPHHBMgJ3R
 5yIVOu4kvVCKCYlEKbeW+GJPxrDr5/1j3UHrz3xv/PEzJJFa3GR2IjLxesrhxOsO8bzMe2Chv5z
 VzkdCab0Agdwv8hEcv5FcNPmUeCZ1dxQJqtUu1K98atOp7DaCPPk23S+y+BAgNYTpSQp34Px0qQ
 v7ncL+9JTrmzx50v0FLl6CClIPHcHfAb9AxQfXT6YEJTwux/mAG9DSC9UDXwWIalfPq4L+mPF5U
 LtUvpBq70Ru8AQd56g/hz9ZMJdHq32dgHCubDg5wtD6sowjPB85JTSg0vxDVSEAvSFtelKRkRfm
 iz/RPF7WqXgFSi8JBxZJe/+ugX/bjf5QhPGOz8rxekWyXttWPPZIKrS6HhD+T4x2AjG2ileEeIc
 O5qPzQWtzMsIW0saNTA==
X-Proofpoint-GUID: 0Gw8uFhKeC36KUSGnTeswrM7QBqhzV1i
X-Proofpoint-ORIG-GUID: 0Gw8uFhKeC36KUSGnTeswrM7QBqhzV1i
X-Authority-Analysis: v=2.4 cv=F6fC5ahN c=1 sm=1 tr=0 ts=6af5a378 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=fvpZdPw5ZEdYVRYleWAA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA0NSBTYWx0ZWRfX5VIuP6tGTReT
 VVcNJWjWWv7y+6AnIE55FffiE1oBQ7ORpWK1+PWRgkfOpIyqHS7Buj/w9HNHokXW6WYQLpt7AxG
 pN3lTIYfSuPgYuI2oMre+wqlK91YIqE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120045

On 24-10-2026 23:59, Eric Biggers wrote:
> On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
>> Remove ICE enable call from CQE path, since ICE is now enabled
>> during SDHCI crypto initialization only.

Sorry for delayed response as I was away on vacation for more than
2weeks and hence couldn't catchup on the thread!!

> 
> This change makes the low-power and "optimization" settings in
> QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
> correct?  Those settings never get lost at runtime?

Yes, the low-power and optimization settings are set once and are
retained over suspend/resume cycle.

-- 
Regards
Kuldeep

