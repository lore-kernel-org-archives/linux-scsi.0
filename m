Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483796;
	b=kv09wcEcd1nn5goktuCDN8f1QBtXMxEvMEDrrHci1FpPgAlj/7YnK6uQ1jOegt7Vsa9d
	 7VwSKJ6KXgvErl3g0r61oXcM0R4T2g0906+NiUYRN+mVK/o+2twPoWt72fYggceotMQSY
	 Z4GAD9hIoeeb2B36s2Rm3e/11Yc8JvmAJdcfJYThynDbTAVhcEHTcSj0um/ZfrXxTE83Z
	 yJZIOJ1rO4+PrwxJ+eDqnkn0k6NPec3oOLxAbnmDQbXDFqihFiaa1XM3k11cTRNZQMo3v
	 qcg+POxtb53oxyWtqTDs+TYnengs0CBoZKH38v1v3g/sadPI0R+11VPbv8lAy2JYY1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483796;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
	b=kkNwGSE94obTQkmtd+Ltk0FAjbLY/DPSKGicbvFFmssKxg3G5y544njTdjXpikQUcc+s
	 bZvAJuHBySusCULzIS1LcjJUb0MEC1KvLuvey182zRPTdwlBOzEuhRYWmmRmqYmxrunvb
	 v9oJ/MpR90SaRxATMJLdLNNZ+zmPP+y7EZS3eohDNy6mkhDmzb4MWOU78cArvFvNJIcc4
	 tlhmAEgHXnswHjCI+ETDxPG8N6pSS9Mp06tBMvmpGktVrhNuMbQNFvPhLNa8tbla16Cek
	 PjP8UPAI/JOKK0kh8rjFBKTadgEMlCyyVuboVwG5UpkwkZL4V+Gz1bjRRE905a0c+EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jMyJkN6c;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dlNsDC7e;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41226606A330
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41226606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jMyJkN6c;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dlNsDC7e
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC9JtuF2514118
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=; b=jMyJkN6cn3Pey+t6
	4FJSf4pRce+aHImgnkYtusCwP5HDljsirOVP2QTdMrAV6kBAr7289H+ZHBoKdeOw
	9IWJZJJX/jOgqMN0zxnghXIn7ThYL2KLzrumuYKMLIPhEPlVW2HDS8u/Ao9M7zj9
	zrNIOGksuyAkbXeMV3mRZK9RS8YQEcRsnb59S9hhkZBhOoyaCHqJps38hV7qG/J3
	Xe0tX2YXi7UH3Cq9zjlNgVKQMzG+DERrpC6OVP6dqGgR6AaNYZ6S4DQuO2Z7Nnq1
	eKTroqerpmhAOp2aF3PGjbHQPNv4WxucwcLMG1jZyIt/5SI/oJ/pHcvdMri8hA3T
	4qeRqQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvwm1ud1t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 11:43:15 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso3776031a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 03:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794483795; x=1795088595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
        b=dlNsDC7efncryoB6kjy/7n+VYE/nkSwEwEj1uVqyFzjCB5/N7xOeOS2SOsotpnsmDs
         /zBKWzphEipaPiGEnIWVzkPXo+k6TR+iTJTXyct9EynZ954r/O5tKIkYlLXOlckIhDip
         mTihcpmqA/j8CmzG6aFa3IxqmQW+P6hwwURZKdpt+fRvg4ullNRNV5dmkq1TwSrX58oS
         qEm2sDrdgYS5pD0l3sLul99Lgp0i/jLys5hcOtpu8saC4qtWbaW7ozwhAI3dtPfRWQA6
         YlktiKdzCiFpAyygV0I/FDVdYtuq/+7XoV9MppP69D80tNZyf069PhumW3fwG6SmZD0u
         wK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483795; x=1795088595;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
        b=G8BopEnb6JGNNMQ1yypZQvSihzm3XQ1xd8lclG7QwwXuRTt3tzWHKXAIWAIiaKgTL+
         zgqipu+5sMblEQFri6e3W8JTLVUf7eJjEbk0tyMjES9iuUgnKIhjAylVbleg30CSBboO
         GfknpVNY7lQMNdojktqY36xNNs1QZ39Dn+aYgkmBqOFElDQ2aa3845ndqeAWii6vj8L7
         g3mSy9PJ+tJR2FIzu67HozNZT3lBDplOvvgumYr3PxEo6D5i48lp6G/N1k1i+U/mBN9H
         Pf9vSwKxGEqKs+QUB2JUHDNQWxoskvoQ3cQOwiPjuKvtEQFW4QGrYmLOeTWE54d1rbEz
         gmuw==
X-Forwarded-Encrypted: i=1; AL+hErH6mWAfxOVNLzvR4sbz9643FMTsVo01LDI8ZWjy2eyVNzuoYsTvo0uAnu/2tc/7DJ/8sYw3yCw9Z6RV@vger.kernel.org
X-Gm-Message-State: APuU4Z/Nyeab1p3Y16LajJv2y/hypwd/QdxToht1kZeXMY9pX+xK5hC3
	xmygk/YnE63fI2E6KIQ8ZLG1ZTC85drSoHqPf/HlcVPy0WHMcRhndWSQqO6TmG2lGS6ADqXT/aZ
	7AxTUeJuy1OlEhWyjzGTOg4ZBDG/Xv5YLFeGDRFPNUCs4b6Ex66QldW8CTEuHMfy1
X-Gm-Gg: AYBFou0sMWFUaqtnNMRZ1NBzPcVlZtPAxJV5gu0Ov4fhdOGqoQFF6QjNGzl1GNmZRhA
	xM7h22CtgzHJXnmBzhEkXijiDMnLKXLcX/mSccnsQI8pI6f20+7qF2OMVPdmSOZ0bBO6HyZh+xg
	Oxwf8yT8iEM0+/7i+s8+wVOUXeIjCWNhjo6iYiVrpODNHFgx95K7n5AsxtK/waFEQ5o/g9UvYEF
	AOYML64dbR39lsyb5G/qNW1JR0nenP1WUhlUlUgYYMPy4O+p8HHRUXEGwrUsVhbGZdqXF57tgYr
	58X63XcXnrNbXIEfH8zEKEgclhHrjvEMxymRuIDyAsLgE4GoDEa/GQ5c4aOsY53Q8Mf8u31vgbo
	e2kr2rnmqB05hLQjlXIMMVSvuWCBSO0m6BmiDU0A0MQWYh6R+u8DjbSC9/Q8qtELAQnpuPdSyAw
	yZoxg=
X-Received: by 2002:a17:90b:3c06:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3b182df2f25mr4726544a91.1.1794483794719;
        Thu, 12 Nov 2026 03:43:14 -0800 (PST)
X-Received: by 2002:a17:90b:3c06:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3b182df2f25mr4726519a91.1.1794483794297;
        Thu, 12 Nov 2026 03:43:14 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c8b2cdsm4350657a91.16.2026.11.12.03.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 03:43:13 -0800 (PST)
Message-ID: <d60b437e-b1df-4a9d-be3a-a53c2a369f84@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 17:13:07 +0530
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
Subject: Re: [PATCH 0/3] ICE: Enable runtime PM support
To: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KsnYSmWN c=1 sm=1 tr=0 ts=6af5a653 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=wrTd7Yo2M8a-6LQTD2sA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: -zZ-rujG2i2-m3MPvqTcoJLNbyaSdoqy
X-Proofpoint-ORIG-GUID: -zZ-rujG2i2-m3MPvqTcoJLNbyaSdoqy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA0NiBTYWx0ZWRfX1T0i1oaMA2KD
 4ejE9VDIxYoNeHk9BBprlGf+Nru3EyAm2BcFTKHmJwcRntXcc0qaWRBXUVwyJ/hpLkoQpgW+XC4
 zewwxYeGxrIjIORK1hOum4SFnF6ub7zpZiCQUQLWvBE2PyW7XsDZcuQOanrR7++1mnYgEpcdg7s
 GsC3aZBxqcwJnGRuVggQuwLhcBLez39/l8kf+JY8jc2JfHTjlluLmY/aCY7ZYlXIW6DWKgaTZlc
 xRkbntj+2i4lEvOQ+StEIdn0i5Cq422ObEqtL8tOgomxn235aTIY0z3wLnqQdVLMmt/cxNQ3C/G
 o/PD5GfPGinOMIzk7VKbgaUN6dAboj55EihjYYbf0fxHjNYlH573b7SD9PNg5jA1lLGcqlRp19R
 +gLpYutfra+CflRgMQIcwbvkLRhNAveA3hl0q8pbthHbjKbCvPbzbJhy+a/xWmXIW5SVubp6AOu
 OP6MQcOacvqyqrPqHzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA0NiBTYWx0ZWRfX839g7Yo/uWEW
 Sf4pORu5YI6mnJYyR4eJl2UzhTAjke9r4ZAZOTmqvl9OWE+KYIPZ0w20+Wpwy+Epq/mmMXeuyRk
 dvptDAGbi0SbSuz5+sKg6AwoKznUtb0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120046

>> Merge strategy:
>> Patch 1/3 and 2/3 are storage driver fixes and should be available
>> before patch 3/3 lands otherwise will result in bootup crash.
> 
> Then it's perhaps better to send patch1 and patch2 first to get them
> landed as fixes and for stable kernels, then when that is done, please
> resubmit patch3 separately.

Sure, storage fixes are currently not tagged to stable versions in
current series. Let me add tag in v2 and drop patch 3/3 from this series
currently.

-- 
Regards
Kuldeep

