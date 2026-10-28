Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793184907;
	b=2IvcyGzdkrwXi1whNlRcC50ak13F7DLAmrbpephuktiz1Yg8RXhM7kieEptY0cRmIjCY
	 qP9PdvE+XDv7EUbQvA9gZ4WIa4/TJMNiMRtMmoFIYmYbYSS2uT6KnvHbIxBQU3S+drUDw
	 m146/6VnMCYbC6N8ZVXkKd4bGtFLULXAzstBO0bJksHmQc4dfn/lnHEQ23jZDut/aiLZ+
	 SN0RwReS+RxeI30zxjCh2xMums8YccJ1uHVxPL1pkqOBBUhUij+JVmL/rxpLZVAdDOmHc
	 gxuC8kBlLJUwCjCnigR+PohOy1czTxVis37WlZq8w08TIUkvRCVPAEDSmFxUG+Cw2Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793184907;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=oRSwszkW8iD3xY0tmKtYtFhq8IKTNKbbXaSkFyhF4NI=;
	b=4GHxr1HI4YqQ/petqGABYnPuyEG8NrIGvabMSEf5OoKtU65G2zaMKEhu9W5XOijOTtEZ
	 CwX2zBuolUHEOUA8BjzrexKh6vyzN26ARkxS7T5E38XT2Pe8SUVGPVGkDHBTfHSlpCV89
	 An3AJMTwDbBQwL0+2FHWdCY42s0S30vawpyyFbeWA+RYCfQZsikpsw9zqyKReJNpperva
	 9d1m8dhA6Ay1Y0U24xBkWtpssI/DMIrmFUOnBcoW6GVyQwpfikLeTl56g4JzX33ln1W6U
	 epePy4jrkVE8cwb6SUwLsGqajpe9xMGrophtxu8mt2mH2xiF3uSQRqdGK1dLa8mcryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LkHpxOTO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="ZTe6TtH/";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8492606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 10:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8492606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LkHpxOTO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZTe6TtH/
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69S8KKHW3264775
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 10:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oRSwszkW8iD3xY0tmKtYtFhq8IKTNKbbXaSkFyhF4NI=; b=LkHpxOTOYlUHfJx4
	m2pWz2moAC8FSgKdhWL8dLH9HZH063WrDP2GJVcoYj9j+G2e3MiWdtAKzZ3jANtN
	nrPq3kHzAO+v18Y8pSVPJwxR19WGifUpF6k9ODQpKeUX6qDZnWsX8wkKag3purRG
	fR0smHR7DNQJvnVx5Iz0k+jjkLABZewOxaRG6YxuDdOliubxiidVvi9gojGoAZ0F
	95OgeDRQsyv2V1gH0cnBp40QUNe9FtKosmIb4m5eZkxSa33jbYBE4RZIqw/VEVLf
	JpmqGfMJz4vYAY4NZpDk2jXHorQtKHOF5FEDD2UI3IyAazoR0dl5xBim0awNxSPu
	uMBaRg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjy713t7y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 10:55:05 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3662e7a9299so3519711eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 03:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793184905; x=1793789705; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRSwszkW8iD3xY0tmKtYtFhq8IKTNKbbXaSkFyhF4NI=;
        b=ZTe6TtH/HBt8PFk/jhdzrLVkWXp4wjcchQPiYAKG4FyUdSxjjnzCuXLZux6+7ynlIS
         RGcTqxaGryTrN6MAB1jMv2I8obntPLvkWvJvk0TT3ZNa5nxcMQdqXiF5DiQeoayH8mJb
         3H80x6yhEJrp9dDYN46kZmlLhUrhQvW6UJ8cuNdMdgWZuScQ2ne/SoErYulP8pNhdmml
         14pX8J0XdZHRdg8ZqtouTXOSXEVLyBFl9IP5p953WDLNn9jisD1QmMCdOSTjK/76rYLI
         /jFwpeDtHdU/xN+r74WWxZOOZQGPK5A0JV/m8ITxIGwdM6uHCaBY5Wr+6l35rZIpY+TM
         1mMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793184905; x=1793789705;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oRSwszkW8iD3xY0tmKtYtFhq8IKTNKbbXaSkFyhF4NI=;
        b=fYzAmmD55yrjLv+1tp26/Qhpz8xhzBK3wqcngZ1aGNZ2UJxZGwoul7ePl4D/AV6rnX
         BR1YX4fC79QbfhkLvbCchQfj0FKoW6WRf+qk92E+A1oSoD1tcfJ/UkNK4nyH2goqTf52
         BOg0Lmx/Jbk6KPGWC+IXssTlmIjKVo8nBZVLm/tAfP3/mxDfdtHvl0LtfjJhVoSgmRM/
         xRQ0ONrQbm9l+AIeQdlRJVSYb/Mdw461N/8+4W2txerze4r/SR6+9v8NTVURMK5aLLIn
         bqW8hFO4BVEwWqSZ8PYiiHNE9NsiMh2WUhTMWhx8ihg1cF8UzB162Mxxra7ZUThK6BGF
         CNQw==
X-Forwarded-Encrypted: i=1; AKwUvBwq9aQUhOzdDg5u6qd5zD+jeNPpAgXbuJyKDVmQuzWv/kv81y804DgmfuHrnE0uWC/Rhr+sQmGQc1Vl@vger.kernel.org
X-Gm-Message-State: AFq9FYL0efnM/uYI/iu3JIkLbefkTRHTAiq5y1ZT9qmcYjHNsa3ZUrty
	JlSHHhOx9N53MBC+KuSWMHdz1c+2DalAi8+pVH4CV2dszw2XKDKHck5EL4u2EEpCGwAT5lPvYCT
	8M+2lZ65rsdCNwiFix6NDPsux0Ne3XRJexTWouSCcEVoGQVtJUNxnVK9Uw1zjQrrs
X-Gm-Gg: AYBFou2sGUknIuu57lrnjRP67QZYagS0FzguAn8hYxACAw14wVPI9PaLzuUNh56hTVt
	kOjIDpcILSykGZ3MzMmXyuaLkf5xDAo643eS2nN2mX1Tihf5SnOta2O4vJxMeWrtqdM4p0oJwG+
	j30kN5SuLxTiu+ZP+uj+8Y8HTZjXpZokDbXITse7LC5xZIneDgkDCZsZU+sE9dmPZb61pL5Dals
	e7E383EmSNDG8/5wIzrhBqu4gq66ohjMp72m0tOCtD4lQkol5HAXTamhOxbYQEntxAIUfQwkEv2
	Ci+5QRFQ7MQUTpzprzWxbYC8ti9lpzjshNTohtzO0Pl0RaHVZXbdFMLT+ejlqNMiaRbLjVjPg/D
	07cBrkZdEMd05VsBe4EytZtgiYcvZIOrX6urkbQk0MCmcdPj8shOfOlJP4bd/JQp+WOULGQEUgy
	s4oFo4nUpPlgimX9g=
X-Received: by 2002:a05:7300:f894:b0:368:4c93:544e with SMTP id 5a478bee46e88-36a202bc3f0mr3393213eec.1.1793184904740;
        Wed, 28 Oct 2026 03:55:04 -0700 (PDT)
X-Received: by 2002:a05:7300:f894:b0:368:4c93:544e with SMTP id 5a478bee46e88-36a202bc3f0mr3393162eec.1.1793184904020;
        Wed, 28 Oct 2026 03:55:04 -0700 (PDT)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238dc80dsm6335086eec.9.2026.10.28.03.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 03:55:03 -0700 (PDT)
Message-ID: <1dad9241-45c0-4405-8d8a-2437125cf8da@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 16:24:54 +0530
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
Subject: Re: [PATCH v4 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
 <20261009-glymur_ufs_qcb_enablement-v4-3-9a6ce83195b7@oss.qualcomm.com>
 <feb43c1a-9f1b-4181-b663-eab9e55e4831@oss.qualcomm.com>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <feb43c1a-9f1b-4181-b663-eab9e55e4831@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0MyBTYWx0ZWRfXzNYSwwkWOsEh
 QE3GMqoC46vmy2dyT/VzgZO5Kfq2PoIrh9egynBtPH2YCNuF4LamK5zs7SoAjYHSYtbANRVdfPL
 aHgzVuFC+j6da2LtnnCXpfOB5YGe48cgRk9xmLmDs5d//SQ9N+yQmeGd+E6+2baPkLIig7eIjQ7
 mRqkAhYe7cQYDfJupAaKN3AeAJK0rmiTabv+I5Dvn3npRM5CMKZkLAG/mtM5lQtkIUmKnlw4mMk
 8RqqszlprFoGqbcph68Jb/TkFevVIrLRMb16zYhpNW+ejeP+hGI/vwdqZeuL4PweKTfxrOjXFaN
 ESQzc7UnqtZ1rrza/xUth4u++t7/pOdmgAg+oHHup5hf5EtFR4lzQhY7IZZyQcJubIjzU/TRLBy
 BMtZ9COnNN1CUUm1TRcDMKfptYyeFbD+puFowrYzdccleDpGpXWKPkxa/KZuwWk843CO24XZW3C
 3svri7zVVfZy2oyx+bA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0MyBTYWx0ZWRfX2RYvGndFPKB3
 rOOxSRIb5POCMiHhQC/lUYMDKGAiV3KMJ7fjhVIwThKR6/VfZyHQSWpJLvn9TvZEx3IwAGkcuxv
 bOcyQWgk3ZKY+XWPbJtzzPnF/zqmuBM=
X-Authority-Analysis: v=2.4 cv=JspkP84C c=1 sm=1 tr=0 ts=6ae1d489 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=VHdet6GdWXRFFbjuATMA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: Rym8OJ91bWEwbrgAf9SB8hLW5Ze99zxh
X-Proofpoint-ORIG-GUID: Rym8OJ91bWEwbrgAf9SB8hLW5Ze99zxh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280043



On 10/23/2026 5:25 PM, Konrad Dybcio wrote:
> On 10/9/26 12:35 PM, Pradeep P V K wrote:
>> Add UFS PHY and UFS host controller nodes for Glymur SoC.
>>
>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
> 
> [...]
> 
>> +				opp-201500000 {
>> +					opp-hz = /bits/ 64 <201500000>,
>> +						 /bits/ 64 <0>,
>> +						 /bits/ 64 <0>,
>> +						 /bits/ 64 <201500000>,
>> +						 /bits/ 64 <0>,
>> +						 /bits/ 64 <0>,
>> +						 /bits/ 64 <0>,
>> +						 /bits/ 64 <0>;
>> +					required-opps = <&rpmhpd_opp_svs_l1>;
>> +				};
> 
> ^ this should be svs, not svs_l1
> 
sure, i will update in my next series.> Konrad

