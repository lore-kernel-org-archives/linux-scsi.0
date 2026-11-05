Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869012;
	b=rORbVmx7JfKkcJaMmIki7XVb/oPtMHZM+6sA9TVtfvxMts//4Wg+suYAyTPyN0hNYAvB
	 HxTaBjjcwZ7NNqRC4Dnz0JUspXkjt1yILabXyPXfpRGbvRg1J544zsjjgL6pKVmQIzrJO
	 TytxvhoI2r5kjO6v+2jIzhhMtiW0Wl9PHHSPFpEjlvdO8k7WWGA+XCE2KaRo0fFrApgvT
	 iMuRreWbKf2FA3hiU+gEH6nKthHXVpc9pQTzlX96TwrFQGteVe9btSI7H3Ia5SArF8m45
	 PJjl9N6vHGmb5wwggjSwj9ZmpZ4Oi/DFbYHVfDwFNfgHdweboOHSo8LjFNnIwo69+MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869012;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
	b=3wnqT2Hhi84MtRcWAtpcYVnyLAmfEAQhEuvg8tD5M5qijRYMqYDiOLz9VSMR5SaPXiZ6
	 HP7nuftG/LLU1HzgrMKgbQSLEjsymsqRlkHXWR6ss3O0sW4h/iHi02aWLxpi9QFaEozox
	 WnZp4dUgqSOukni6eZBD/rVEL7vlt+yUyN34hkXFnpDYkD0fdhddheqj4I/dJkPjxrCJb
	 YhUMCTDVpdRzRQawsJnOvLG20taJk/Ssxp8A1TUGBcBn+UAFwDrI2ppc4Rpn6mESXB/xF
	 ycVAM8CQqA9Z4oegAuSqeUG7X8mY9WJB8A2XLi2S04UI4n0q0Id/tVm/3aN7vRnx8NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jj4jpRyU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TjIkJ5Ag;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4986606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4986606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jj4jpRyU;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TjIkJ5Ag
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A56Uatt3624872
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2026 08:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=FB1C5WDv2k0g4VMhoAfgN9Y8
	5xhLplp0at8UMrU44m4=; b=jj4jpRyUuJ2OeSTNxPibUFA/SC0e81ThCh4vngr7
	KVcr0qIwm++o/H86jrwL67Vl/VdAojkju1WbO+ucBsy2uDDMz6tITOZ2Nh+ylE77
	qY/eSZRSv3Rp/gGe5TkAJcfiZmTyINYEYKEHTkNQHQBdIBKj0XfZLbjjp9gJOf6r
	XstmM5Fu10D5b2vKO3wZUcsbwumOdyHlKHjuS/UFe1aHdCfJ8O3swxIqkUIWmzE8
	Bpow4jsCBqMNLIjwQxKK6DGffIe0JF9MMaFzOPMbfAAceQjp+qCyEukvCE9h1KST
	aWILXma1Ln1zMFZtBajr45rH3GE6FelUJnBWVXJK4lhfVg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hr6br445g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 08:56:50 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f6f4fe531so302660785a.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 00:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793869010; x=1794473810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
        b=TjIkJ5AgEe3MW3K9GASPJKsvRdkY2SwhOswYkdpAFjgrzxXbRMsmjeiw2zPJvxJWai
         Lr5s9ggZ1USbr918AjaoRSWCTz/FWVjBOXHLwwfaeTyarZdQdt14x3FjcFEvxpYEw1Ea
         +k0HmM4LeeC5AhK2BBc9jM0PWx0vTOSl2KN/Qf0RImJyoggyzp8PvH4+8IvZF/ivOOnj
         cweAv2HMpSgdp6NepmFzXDzwa3UUqz8bkHaDjH2WLCRMtJrBlv5C6wu6+5SrE+IXeHBx
         fEoMP0WS5S5TfgoocXn6egCsc9goUpcI2i2JJRVSaWNN3NFmqP1r1RSAXoMwYUM4H3lk
         QeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869010; x=1794473810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
        b=nHxE9UxewatbQN3avRiLCgczMW0qYZRLy3IAo3gpsj7q/Pm0CyF1NUhSu2syWXiXIp
         9uho9dwvY3Qw+Ask5M89uqDFuJ5lpEcMothFEdt+7q3Q68Z+oj9HRjhXP4NGoYXxht1O
         WsCtth7AUVrARqHslcvVl542GPzWBFKdXltRSZrwFpKIzqZNl1NmyVohwz0YGOWV/m7R
         MfUAhaVF+6hUaXa8rz1gLisrOlT/Hg2ObYYGkfSGDDRNjQVPjdmjOlEtiDtNS8AUwl0m
         STfcU5MBoqQ2ifiGnp/5BzirkdFn0eiCi0tD4d+p3XdnUGzz8AgfFTFR8tQf+RNN75Jr
         YXtQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5N4UjXrGuL0BUvosIDQZ/57CbFA7W6gDArw/ellLYS2zbaM+ecukKMDynJEAzuiO94Je81nKDWVTq@vger.kernel.org
X-Gm-Message-State: APuU4Z+Tp32P751x/DqzYTzivv0lkRHXkM+9fMfRppXZt9KgaQ3EK1Yu
	uhTI7jtz8FeFwfacipTfJs9Rhl4ip0fHXvwxjbbuR7Im3peJ+boPJeJ/97t6rUa5MAJDWrj+nmf
	rf6BKIEicIHiLR2k/tR8SRixao5kxQ6eb0xrLw7bPGyqgpnJIqBHzYefh0KGXDJwF
X-Gm-Gg: AYBFou3g5NF++EzxNqp7gR3N5jchUeHKWPNLIZHbVdKp+dPtnz3c7zoq0WuPikhoofV
	lDmpmWRLhl+yTZKJoMRyZ1TIfVYWR4VjXoLdiSlXWMtWoQYVq2PpYZ8GgcuKYoA/j2THYyVnIFJ
	RMCERQ0gC+562ILA/zYZoj3n14rQVzCjMb93qIwJenQyiRs+wv+RKKra/xSUPQeLsa2muoFCN0b
	hAJqoP51bW+t9PUNZ1GYCq2mCcwCq+NpBM/j3tl/tPuqPV3P+Pij1BQdnBlU/ap9sMuBinHdwXC
	50qgrvEN86bsDHf0DHEQpttccnZtrThr2D4HS6xWCfixapIRj4VeUa/sWsSEkdmFJJW06Z2IwUr
	mGai/mxSC4Ji0rY5XjeC5R8pWCbKSDdkzZrt7EUrmJx1sdRVmkN7/ohfBzhiN+J0=
X-Received: by 2002:a05:620a:6483:b0:93e:c12c:4408 with SMTP id af79cd13be357-944217cd92fmr2720753185a.68.1793869009912;
        Thu, 05 Nov 2026 00:56:49 -0800 (PST)
X-Received: by 2002:a05:620a:6483:b0:93e:c12c:4408 with SMTP id af79cd13be357-944217cd92fmr2720751385a.68.1793869009420;
        Thu, 05 Nov 2026 00:56:49 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm58629445e9.8.2026.11.05.00.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 00:56:48 -0800 (PST)
Date: Thu, 5 Nov 2026 10:56:47 +0200
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
Message-ID: <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
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
In-Reply-To: <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAzNSBTYWx0ZWRfXyKf3bxZTsylh
 w/fo5kJzxWjxLTG/tUoDR5U/qels69n4oKp82eCS6KNEHne8MO4sXf1Dn5NefpHFAnTIPr/MrXk
 Cfnwvj9GMOwo/UETQ1jYP4N6RcK5Fecmq99nkqo3+M6YwzBQ8lrI7wcqbee2ZJcCX4r0Ducetyt
 H6f3ac+PbN1YuFLS2XyjdejxXcKaJRM/Maf2n3GwolMlWr3wTIdPxRQyDFJeTH1Av+8dSVV3XTZ
 tmmRh9gq/5AxZk581syWZnRR6N2kHeaWi0JZEzn4wOn0F3MFK8wfdHNajunIrEgAegazI19LbB2
 f2aojnWmNHgTCkhEH1SXh7qSNMR47ordLKIW/+oyjxa8dwTpjGUFCMGJOF7rHnTIlIBf5JTNzrF
 q6XUUz7LNaLkfwt38AxOuK8SzG8FMqUbvN/RH6X+ZObdLd6TDcmubEL0oD5SeOm8EVHzHziu0fZ
 HSkkZhNf8KuMDQt9xwg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAzNSBTYWx0ZWRfX3UIBCPmYUqKv
 OCFoBsKnN3KNf0PjMtTKDH1NaTys1ZPdhdtPIFT4Pl4UAtys4JyAQ2/1sGauqJcSKd0DccXSLV5
 olt67r3yJD0v9aDCvl/yNcS2zi4sdNo=
X-Proofpoint-GUID: Zh8F0nb4rK4qpM6KPc5RThtkFbObGJ2Q
X-Proofpoint-ORIG-GUID: Zh8F0nb4rK4qpM6KPc5RThtkFbObGJ2Q
X-Authority-Analysis: v=2.4 cv=futJ914f c=1 sm=1 tr=0 ts=6aec44d3 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Bg7KoihMCtH8JNtkfXEA:9 a=CjuIK1q_8ugA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050035

On 26-11-04 18:38:13, Andrew Gigena wrote:
> Convert SM8150 UFS to use a standalone ICE node.
> 
> Move the ICE register region and clock from the UFS controller node
> into a dedicated ICE node. Reference the new node from the UFS
> controller using the qcom,ice property.
> 
> This brings the SM8150 device tree in line with the standalone ICE
> representation used on newer Qualcomm platforms.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> Tested-by: Andrew Gigena <mail@andrewgigena.dev>

Tested-by tag should come from someone else, other than the author.

Authors are expected to test their patches by default.
