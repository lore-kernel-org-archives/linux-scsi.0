Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216429;
	b=Z0aMIW0EeTyrigfU1V9CrdOCsgEYT1/caxWSv8hUaq9kLgvW2pW0yFq8Vf75WxCLfdDr
	 Lj+KdVa6L84pxqRY1Cr0oM5HMhd0jL+/Xaz7imFd3F3Ox1J38hAI1bJrsfIKs2TcBm9MD
	 IbtYl1BpIb4qj3rLQZFvfsBw7yoiZlAE65enk91Dhtzu6AtEkbNzt9VZ4P6ykv7InbLvr
	 mGDN0C8TxwY5bg8co6o3epqf0wnwyQxEjTZ26IdbIgKjitgxH6d4ynQjsJFj9Cn/7DNBt
	 HMESXG/90gUeslKU40tqJtSmZxkKxkxbMJhayqQkMyaTVdRhAVIVVynrb14R1Sny5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216429;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
	b=37atqbibSxB+RUtzx5hEAW/sy0qgf7EsOJuIQR300Vr3oX0lToWGEHGDgFro412gWXQW
	 RITTzu63VamtKze4487l4qjzsyRSPcR4s6fLlYfvmYV2qrY4zeg2qNcQ2ranPrJjqoDVY
	 N1G3OjYLoGqn8JyJXwOAEO++l7Gl9zEroKPypaYN931ziYp+ljGT8Q7SLtrLV7AkEyOI0
	 3TnyYxKqQbT+tlykVj45R3O6bHQdBESzi8xU91dsEVYpdU4gfhb/4sjD6jnKujjTvtRGS
	 Z0HwfHGZ82ayKFDEKtOJXDJBLTMQXjKBoJ5da8vOc+/6PsxMo0Zm2TV0uZ1XfZDFzNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gKMQwUUU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aS+CbvMl;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A695606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 09:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A695606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gKMQwUUU;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aS+CbvMl
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A969vaq3580920
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2026 09:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=k98AldNnLDpToTE1usQ6ljOv
	dKlSyqcs1qtKA1cJ9KA=; b=gKMQwUUUEeo+I3aMqxy/wLQMDWMf3z2dG+pM9i+I
	V9+diFjLR/XeoZNRr3PTTXwE+xloGrPDuuhtRIEePQt3y5Tq92n6Z4K6PWB1wqYa
	NG/ieTLs4M0FJisJp79ntwFPFDLyfBsasZ8wYqZvsS8pdl6K+yYBLCApF/vf/lmt
	vluuc4pV2/bi0p1Fb1/AnqRXtODTQ5/TTZSLoPGNAaq1vIIf5Ue8syUDRdqXggZN
	SkCqZ/9YDkZxPyGmbrAAnRGS7Jq87wm1yrn5OQUS7NeLEoSe8CfFGN0KA5tXpTI3
	N5YDl3DxaQFfBXRDWnPlLZ8cVn2sI00GydtCUfFATo1dPA==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsv735kj8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 09:27:08 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-99063f4065eso254634241.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 01:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794216428; x=1794821228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
        b=aS+CbvMlvbFzd0c0FE71ZGbrUiKGQg1bDxDPdeYpFFlE09m0vSOVQ6VTdxJ6dvVdHd
         PLt40791iu19ixjtx/1KALJg3yi1yK+2TGPMmp4yVg7AXvG5OCkIZaoHDJZKf1w5AgaN
         wA5pcUXPIexCRKSgeafNw28R1PurxkWeG/sGNAdp/W/PUmf/HbCH8AbmbJCC7tLIiRoo
         TTD5XXo9HCPMXHm7JXJ2bOUqKd/6FymIS+qyaVU+PMVHLRRc8v1Zp6H6pmwa/ZN9XvdE
         fLZZ2I9GLcRDDFMYJvOq/aVBJsRSFyx37D52POl7Lwvy5TrIbRtH3Nn7GJqGUIpFA7NV
         9yEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216428; x=1794821228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
        b=ipYrd0ODbU6b8YcByaEeDqmPsjNsmGCOuvCLsjFaaWEEsFjeXD0fVgFboqRC3Triws
         veOIUwwmZ6x24LvbN/yocbLh1y0CKbtVtyhxgOtNTt/boeqXPcN/8HxsigBHZqt31eLt
         s9IYGwXmCpnyX4Etu6YT4iB7NvDyFBENo6wyFqvYx9ucWhUmNasG4Aih8CNqfNN04eYP
         3vx/K1Hk7ZihPc1U1hLzqnwjHjA6bjGoJYc4a3EmK/O5DfhRJNy/vr+Q+ZM/lT3+gnrH
         P+0X5yvfHk4wr5iP6ywKRoa7fSM6ARGYRJtzLKK7cZV9Ulw87D3TV5cS/rENwwGuGQuN
         DdCA==
X-Forwarded-Encrypted: i=1; AL+hErELBbUVqezUsYcjbVvObAKPlGR1SkpAVS+c5y7Ca/poqZ5NpE6wD8e+9+7fA/V/OyV47UJrs4QSyQ5+@vger.kernel.org
X-Gm-Message-State: APuU4Z8PGbGxvqksW3inPa9zfk1hVMmoUZr3op1GtpW90DHkPTyuqH3g
	296dydB1CaFo0rDD0/7QFIoqPW5/uIPP4Xt/O9Vlhtpdzv+pYAKarncJCH+7PrHy7VpGfoQpn8/
	3OIZztaJHcWXsgYI1Y5muJcYCvjYVcCaA9+pJYKLkCn9q9S0bvhiQC0JWj9+LJWAS
X-Gm-Gg: AYBFou3TzG4mtFRV1HKw55Xtv8/PTekJCabBdBNGWIP/Sumaqi9dO2MAWWNWX7MkwwG
	m2Fp6Zr/a0ffNdkBJYPUqV/mwvYC4xu3Eq0aajkDsVgn2u75I3QdEcPhvTa+JP+6ZzNAJ3jnnBm
	Y5NLxwWjP/bkSWlle+WAjw83MeSqFctY/669DO6sWoOJDuW2NSp79ZjFo98TjWJgo6/XDu00uJ7
	uMhOjUbhEO2XBqgnPhqtnlraKiTuduzxDM5uwsjDnRTnOHANlnq1SpzPeRyImbX3/BAzCq89yv1
	fDCvrTzsB7spSiVlAzgncEJrpD7h0o5/QV4+8+2sGwNzyJAqDR2lY36YTvi4OIwLLhL+pbc1fLp
	NjP3ntfk0KR8NerJC1lLJnok9TeGiqovSmZ5LQuH/wLsVpLLGKWr/WQjcFpRM3yY=
X-Received: by 2002:a67:e702:0:b0:7d2:cdd6:6c8 with SMTP id ada2fe7eead31-7d2db13142fmr682427137.21.1794216427369;
        Mon, 09 Nov 2026 01:27:07 -0800 (PST)
X-Received: by 2002:a67:e702:0:b0:7d2:cdd6:6c8 with SMTP id ada2fe7eead31-7d2db13142fmr682404137.21.1794216426710;
        Mon, 09 Nov 2026 01:27:06 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597371cc4sm8477370f8f.36.2026.11.09.01.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:27:05 -0800 (PST)
Date: Mon, 9 Nov 2026 11:27:03 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
Message-ID: <s5rb27nhurw7arvnem4yec3z65oscezjvlj7flmywcjfqjgyou@25v7efso7zf2>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
 <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
 <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDAzNyBTYWx0ZWRfXzWT8dFr/tJfg
 UUQdt5+1bbixB9auCwmlXQSj3AhqNBKC8eZTukbjmEIvLm1aEQ2W2lJnDzYosi+KSJKgJlSgvtR
 gcInrnrC/lXKe1SSS8z6fPClKfAJalw8OylEnQFF6TtF/gm7X9idjfWDlQoPGSxuOYU6QSfEFoo
 ewESPtolCAvrvXVOVhOO0mZ7GWYwi1FVjHBoG+xAQbTeFTlEhW59Pl14Tld4elvtobrTp6if2mX
 2wlYsYf7WS+IaVIoChu7zJScI7GnCEn+EBTm4h0Vp50gnmvZwXfUvTJaNGPzZXy0LLcpzR/qyG8
 7m+Wwh1oMykzLTN4AnBdWBfzEeeuaT63JV3fjxL68hCtrNFaTUxatgZIgjyaRw94g6EfHPkbFDq
 S3xOwKipm+H+1QmNkdSlKzUyfGbD4M0oUrHu59VCvKZK+73BkZysSy+KDblMIFnlTdD+o8eb6U9
 8OdD17vWnaGaiWtC+Mg==
X-Proofpoint-ORIG-GUID: XooFXAJjMTLpo5-2CzKREXSAGlUPamEA
X-Authority-Analysis: v=2.4 cv=bcb+w+PB c=1 sm=1 tr=0 ts=6af191ec cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=n44UkhTd5bL0-s0LC_0A:9 a=CjuIK1q_8ugA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDAzNyBTYWx0ZWRfX/h3cqMX63+/o
 dkymv8e1qaUFCnEJdG0+e5uDoNUaW5sSUEQLfOTrgzFDhTttds11YKAV5k0oEnYNa7gXFgA2RJi
 y54CjylNlAj/xhK8JhbQ/3uuTB6VYFo=
X-Proofpoint-GUID: XooFXAJjMTLpo5-2CzKREXSAGlUPamEA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_03,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090037

On 26-11-05 18:51:44, Andrew Gigena wrote:
> I understand, I'll keep that in mind for future patches. Should I
> release patch v3 removing the "Tested-By" now, or wait for other
> reviews?

OK, now you are top-posting.

Please read through this:

https://docs.kernel.org/process/submitting-patches.html#use-trimmed-interleaved-replies-in-email-discussions

You can send v3 now.
