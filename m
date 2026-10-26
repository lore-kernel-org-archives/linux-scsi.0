Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027526;
	b=zA9sQNEuU99NQNP0Kbu8IT8gq0hjPOgmFimIQb4WIzhXNO/Lfe9K3NNODB9WCyKncOln
	 NPdu0PMFZiguSKHmn493hR9IAqYcFwLt828w2g/AYrUad4oiyVCOxst5cKHNdQ1HrIHu9
	 U2b3LIfu/UcAafboQFrRtRAeEhAH6lsEBvSueGp8qXbvchXjxOJXSZAW5dfxcM/Ciiail
	 nteG3cGoYxly2tuFJTXllTq75iKtDIkBgqS3Sm+gS2VmqjOdhGkydhFApxml5WBDkZReq
	 u7OVaJbcZptOxiXNfqHrxrro//tv0+eUAgH7Iq98d7p6P4YKgBuWyHwrxE9ZvBOs8WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027526;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Siz2D5vkVqZu7iFgwk2tA7kIq5v4uUSOUjK1Fa1sAkk=;
	b=vs+SKkZET1sywv+SKDolmy2wcxP9xYSOqybr20Cgec/B+I2Bo0AwAj4aJy6aBpQ79wi7
	 iPqwOzZK6fKnIcTvKX1hijYJ83cBiVUM8sRJzBFl/s46X36v0aq7n8EHTeHsadO4rs1Tz
	 cHHXdbbBtc8UNQoj7Agot67ei7T7bv50of3zPmSkhChzxSqJmfzqeOnbRJBiGEGk5NWLs
	 00bNq08Ff1/JChQMtaPfHQQ96L5M5I2VDR4O56MSKjTvTDiiM+PwDet0k6MVWza7VljR+
	 /NT1zux4W2n8Hfs6o6G81C9d7kZtRHU/nYfwk1ulHAWJghNDTT+NjEYSS3J4QYuASsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mefbt2FT;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BeQel0Di;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C11606A326
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8C11606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mefbt2FT;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BeQel0Di
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QEw9aq3584509
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Siz2D5vkVqZu7iFgwk2tA7kIq5v4uUSOUjK1Fa1sAkk=; b=mefbt2FTJ+upAxLN
	veJjYdu1o+tJ9DEyyULCLvgjWnzeQ4HqySarcMoTaumrnuDxegpMu2/HiaO7vVoa
	hlD0/EDATR46YBTmcUzKQiWp/SjWY0wrBfpTF54+iYvLd0HK674EvvT4FTf4CH+/
	llKx/zkg+2rA3+mMU4wjaSuaGoT1bsE80Hdo09NYnZXoA1d9f4RpyblIrE4qfczP
	ntows3NPP5GEidW7B8k4AcQJXkUjuwS+QKI8Jblg797qaefN5K8syAqBo5UB+ARj
	a9ytIOEYtPDLlP5Mz3kMUDvlsi+JFjYNH0L2581wkkQhnrxnbgz/uileMB6/A3v8
	SXwQUQ==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhvddarxg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:12:04 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-988bf286521so98313241.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 08:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793027524; x=1793632324; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Siz2D5vkVqZu7iFgwk2tA7kIq5v4uUSOUjK1Fa1sAkk=;
        b=BeQel0Di6yLoDXltTsS8fdXhHZHmjNg+0zOlfIBacjXcMdS1RBVmQp8aSh4ATXrjzN
         k3FSnEw33Bt8tr0mwx9BRatHAtVtgMy/vXcDCoKlGB20TRyrfs9Cgk9Op8v2G7CunQnD
         LeM4yN9KQxD/LjqdH9FH4nmj3lJiC+VwnGFIKknJxUuMO9ustAnclJiEG2FSThUuFFxw
         haYdhrfxf5EIx04exMSjs/yGtb2Jp/jPrQ3YdbPfaRT0n+q6177tZ+ftl+3Y7q7vMcSb
         c4Ij5pulfVk/EB0I5UDQolpAhLTSjAuh1CEevARb+uOS+KaGfXfEeT6N3HsDp1qpr9Q7
         FhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793027524; x=1793632324;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Siz2D5vkVqZu7iFgwk2tA7kIq5v4uUSOUjK1Fa1sAkk=;
        b=14byn1TPBqQUxpClbWG+2p1NrxQ4H5GXx4KLwwpzkuFI/Yo8J6+f+jQebmdGkxI2ND
         88h68nKjv67+tEZtTFHWhdYpk3x04DIE2X00pivVgIJN3OwIP5uNM/SwQ/okiPecogkf
         HMqrhZmSJ73YqM0NhnUKPOoD9ZR5WxTs5SJTyHCHCoVPJTNPze4hSjBfRleM8SGRyHE9
         XJp5p6FlFHzXhqMDfa+tFcVi04Y3UqSLbZ0CEqYJE+nJZPrdXkc3y9Iu6/r2QrmTuwxM
         bjnCfzY9SBnX2atqsjDJ7bOzKqo7PHb44s1YMgY+OH8mzx1zgPU/KC9/oRXEG7RCdetO
         jBcA==
X-Forwarded-Encrypted: i=1; AKwUvByCRbDSHyUMhqj3eL3MdQ8WFozbfx04VxD08NpW5DUZk7OyGxLzHJCX2XaD3NUOK4SLnZA5bPISpDVP@vger.kernel.org
X-Gm-Message-State: AFq9FYJ2rntmqJZTVyaXFq55EOrJeEVst6PPmBBzW9CBuoQEnOBXXNwz
	MNDWPgpdFxS/fg4F1eYKumeMi8R4A5iO3EpBHcTgUav1tTCn9XmC+Dn4+p6OCCK87wkPkzS0rnc
	Si/EziW5CWBSkHvncJr22Z92i1pp4XtBUCuf3UutwC2yJE2aA8UiWtZkE/Ll+TCFs
X-Gm-Gg: AYBFou34J80fe4vk9T1C50MKn1Y3hrowoTdWtFYhm/+BHFrd8/fDefz98CZVc7kn7kc
	uGx7X6r4VUQ/AP5E/MddpBEMb79tHIIIinhnBjSfUinzo80yLZn28rWlPxnm+lAsYMrrlVf+FvT
	Km6Jn8OPkULPlGPAkYxWBsILKjcXE81VEpONIKTCCAyMWs7ScbVgaKr7wWJWFk8vYAvahH4c20P
	SAMJbrlkTfOHO8LSNmercvmZf6eVuJJ7UHKYohvLWxSRXEe+uF6YnOacqoW29zGkLQjFIG4uJrY
	H2m8vp6QEOuoItb5COOtxt806oBVhOreuKMwdMHvgKc/wraVa7o2E3SqN5CPZZfc+2G4lkPHIDh
	gvVZwguCGydFFoyGUYzynWw==
X-Received: by 2002:a05:6122:106e:b0:5e6:6546:84c7 with SMTP id 71dfb90a1353d-5ec230f8433mr2339075e0c.2.1793027523917;
        Mon, 26 Oct 2026 08:12:03 -0700 (PDT)
X-Received: by 2002:a05:6122:106e:b0:5e6:6546:84c7 with SMTP id 71dfb90a1353d-5ec230f8433mr2338960e0c.2.1793027522944;
        Mon, 26 Oct 2026 08:12:02 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd66c6dbsm327506866b.59.2026.10.26.08.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 08:12:01 -0700 (PDT)
Message-ID: <436398ee-4bae-42ae-9137-1a4d7d0582da@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 16:11:59 +0100
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
Subject: Re: [PATCH v12 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-6-09271f583dc6@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-6-09271f583dc6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 1aiRaEAd2A3GDWGwTnY_wUdVSNIjaRW6
X-Proofpoint-GUID: 1aiRaEAd2A3GDWGwTnY_wUdVSNIjaRW6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA2MCBTYWx0ZWRfX79yXEtd/aUOL
 5jCFK1a9ULGwrum1rqwGadI1feHYAlu9wMsEeSTjUemT3CUsqGzBhjfJ0P+uDMstcJkIkuFFEMp
 eIMMpaMcHUlfG1xwFXht98mwB9I5sDMGP1cL/J8BZFB96gzJkH9H3ijdRqwciiQEA4sR48xNceO
 ZHyvql6fzq/HFZ735+S1S4F9bW1KcIr2ZYSKmuKRZfquuM3cDGwIXH/GbpJlHxZ8ochTMrdiMbm
 b0d9Y0baXtMHHFPBGrq6MEs95gzuzlFUY8p6jfomf56eu6XozFHqn8eFeY2PA9GYwElttoHYzsq
 emtkK07XGS/R8lgKWtd0GA5OQGGx2vz6Q5JcIlluT9yvLLQWu3VKAs00AZEgmxkFZSx1C7y2aVm
 94L88zOHL5rGV4DXhx0bOvd6yQXns1r8RIc51tLCuCDSvuUMU3orwqLAesIQMlMocxyjKZjlsXt
 7BcmVbvCuDUs2nK8tMQ==
X-Authority-Analysis: v=2.4 cv=N8+8hG9B c=1 sm=1 tr=0 ts=6adf6dc4 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=xhZcOr--89cURCpmMK0A:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA2MCBTYWx0ZWRfX0R4CujgA4bW1
 qJwT7IxM4rHtyEX9DM6lz8idSsgJKBMU9G3ToScJVy1dyi2scOxuUhGxZ3sTZI39I3teo3vvR6q
 LIKiEeZCjANs/y6nwTLknSXCa1YsTrI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260060

On 8/23/26 9:47 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS device nodes for LeMans platform.
> 
> Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
