Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571839;
	b=cthgj+VttQDMNWK1y9VM0cTtGCT3+GHbFfDTc8cjLb/Tg19HHx3+B7I9MxCqjuNyOe9V
	 Z/UhITaCIQxKiCipsMelwfcqouTmDcucgjsMs+XubdEPZLgNMOZ2NhPm88C5Y8FgEg0se
	 uye7UpGGVes9OiSv6djkqEIBJZKtPAy/jK40qZbT1DhpqUNDRfD8G1q0uWdPQTfTf+YLd
	 SGcOjdFufoupah++GHUuMr3TTHTWh1S4UYoMAQKgudxtiZOw991foi2hrQg2KSZ3BjJJR
	 q91qItSSk5fF4c4qSnG4hrgEQjUfS78469vsoVCWa0I2QcIDg2QVFbCu/EUFEsYwFXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571839;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=4hEbvuDKTvq5Xc54WAfLx4GkA5m8TdMCxYJefmo5WTU=;
	b=ldsg4bYmjFRWXPxc3/FXUEHFTGumYDxcb6cCzkCAcFFHXttjTswAu44eYFobI2lshTFO
	 vU+5CKY56P2ZeVgnfc9dLuvtkGnGwhLUi/9LzJcoPcL2qZgvv7Gs9m0yKK4CTsU9G0ndH
	 bzphQ/EmsJLx28wN5iZF7rGIqAWZF13uYSFE0tUCwwurLDKnS3U7XR5BdP2wewLglxEFK
	 YzLgnrqfSExU6jUiLcJWx1LbITHTvZN63qIIDD/NP7TC/6QDNy0bpf2A0XvFKMEUhopRO
	 c/s7NakWbVu7x2Esh20CM0PKsPsP5q0pnGSzKaD5YG1V6B2ZmdTT6snnc4nDOUUaiyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ObBtv92B;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f6pDA0Mv;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8839606A333
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8839606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ObBtv92B;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f6pDA0Mv
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADC1CT42085586
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4hEbvuDKTvq5Xc54WAfLx4GkA5m8TdMCxYJefmo5WTU=; b=ObBtv92BXUpOERJ+
	2WgyEdl4lbkD7pOLZH5GrGlE+98lvcAtyZbrkhFvxZIDGjJzZVfGGQmQjOzKKPqb
	9K3j6lvWgfinVvqZG47jlC4w4AXyt/jPlZVU3WapMHA5Sy+vPNw8jOIillPbbq6L
	wKuOh5azgiMcnunj/Z40CesmKcHwMvZhU5R0KC1cbbj3u36fdS1l5b/z7PXJ2iY+
	zLZIH7q5h76zuRurP7DnTiUTYFek03tFCNYM1cnBI3UTlIm+56yJ1kG7RpaJMMys
	1+TvvsDds1L1WqJ+1M8yRZjaLK3jgQVzjL33ANFBF7C2BLbiqj6+tEyCd7ssXpN/
	08SwdA==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hww5r94s2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:10:37 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-99beacb773fso9441241.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 04:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794571837; x=1795176637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4hEbvuDKTvq5Xc54WAfLx4GkA5m8TdMCxYJefmo5WTU=;
        b=f6pDA0Mv7h+NLAPznkf87t003GPnTWnW5SUmYSmwtxWRlRRfczwL8c/e8IbzG1YI7f
         SqZZA8wNyCF2PfC2s8jL7HpezttHGn5ybk4tX9d5MCaZ0H7TmKCHlN0YxITUsWER4QcG
         vjRSh/bTrCFKG3WnTZqMs0pJGF/AImMEePS2244H9pXkCeVyjPrhZ9xPHtb7fsphDQws
         S3WCvIaoL46kCLUkD7v/Lf2hvkWPwYFqiFIaspgc2cfiyYHIJZadQ6nQoFaWiaSdekCL
         4SSzKQCJsH7q8PqndvB0oP+5344iJJYuNtJUEtvOhVyZBX5+iXNrpJUXGZweBD6JvOEJ
         V0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794571837; x=1795176637;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4hEbvuDKTvq5Xc54WAfLx4GkA5m8TdMCxYJefmo5WTU=;
        b=EWFlKKwa/BkyZqfzQm/rj+dFy4+G0uvaZn5L1hN2s7BJHB9yca7aJwdROayU3KR6R2
         I4x1tIRPgKIFkQiS3ST7P2PlWhRpQlX1yEa3wJGC8CNc/RkndUFyIAjOY9anULP9oo38
         fEOMElFNT56n6Y0O/OVi1+KzyTEl8bHDveyzllqGB97iemGPEy5gg1tKQ0uWU8TSUo9J
         81tf4Fd0YvZTukG0iuxTKUnseu9Ux5LzuL//O0+SIKWuKVMLYrA8iFgnPjjtI17mDpXO
         4L7p+07bAUsCkillLBiXFzQT/hbWe7H0gX8ou7FqIRdwSxHdeOPtgWCKyBRYsQ2Ipp/7
         0NxA==
X-Forwarded-Encrypted: i=1; AL+hErG9Td6VMspITKwLqdppA/NSgJbC3Xmz31gb4pPdP+5ZTW1+FjqaBth0rJGEQIKzKmhvVRfoz7xp2yYb@vger.kernel.org
X-Gm-Message-State: APuU4Z8ucTYHTeZu1gAvf8W1nRlawySNmo9fU3l9BPIwXYq85PU82ffV
	o3QZ5GWsmrTbVcewQzj1C1YvjaMwWt5m3ccbpla1JnRiKfJFPt8vqatdHK2832/ABKRfevXZfyb
	E1W+XWyt9FHAC+ANXoQjQZ91UoqYrSp85wTkXgafMnDjXv6E0IUVj+RmMo0naMuVc
X-Gm-Gg: AYBFou2fUPkJOF+iz9dXXoFaRIHXsFA6ryfddOU+PKiGZQKDicU8pXfyS0XeLMnrzIP
	Z5iBEcv/3e+CbrTomD09T3RjZ0VhZnYPrqWw2BPFMvt5DfGErYp9v0DPSX7QDJUEjZt85HZzzKU
	ECB1hCoQsNcS3uCdnH2+e5jWIJjnvtv47MihLpghPUtuj+2EDqNgJBCtLVGoIuiB0k0x+kXv2Sy
	E85sNzQRoZ5VcbFeAgcH1XHJZ1dhqW9Lr9sayrDbFh9kfDyElSg+kxtARZT6F0sidFfxXmcnH+R
	tP5q7SABJuZ4//r8uj5l4gUf5M5oN6Vd1uJev33Dpw+PLWlPkB50tdNLNrI0UxSoy5GCn5MBri/
	hNfCkGqdctmDAUgSMwAEy0ODWS3N3eviq74k8Aeo+TWU2NwVEWvu7I5a4+feGp8t4oNYbAt0=
X-Received: by 2002:a05:6102:61d6:20b0:7cc:32ce:4c41 with SMTP id ada2fe7eead31-7d64d6c510emr550075137.2.1794571836851;
        Fri, 13 Nov 2026 04:10:36 -0800 (PST)
X-Received: by 2002:a05:6102:61d6:20b0:7cc:32ce:4c41 with SMTP id ada2fe7eead31-7d64d6c510emr550065137.2.1794571836420;
        Fri, 13 Nov 2026 04:10:36 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23ddf82sm870968a12.26.2026.11.13.04.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 04:10:34 -0800 (PST)
Message-ID: <0cac5090-a135-4a6c-8221-846b34ed5513@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 13:10:29 +0100
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
Subject: Re: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Lee Jones <lee@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mfd@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-16-289114ab8197@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109-halliday-dts-v1-16-289114ab8197@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfX9wTB0bHZJgFj
 HDUo71lZaGSP+p1dAobTx+gAbTP7q9HOHrTZTbPPD7D3PyYxsIsU2c0N/ezbWgD0ax/uDr8QqXM
 gA3rasCn3sGbQdwwMobKzZi1rHoWV+Zd3F1vV2jqWBQqg+X6ImizldFrHl1l6LDmfBqhsANwNJc
 1nJQA04DSxYNddb7qQdQW/nYTBTMRa20sgJjQn74TrPbHhgCg+mZjokP4IclSOVk0jlGNSTVxJd
 AtHtaRor9nOttVrSV9trZnJmWAgNKq7a1G/xo0Z3Prl1uPoztZmJbGcGi2WaLO1FmtUXUG8+oSO
 A9+MSMrH9Ogt2x0EHBgT22GK9VdiVVPCbm+XZpATCIeCkCK9KkOLvHIYLhX9GbrwxwALPcxc0no
 ET8QKXoFnHZZf3E77XyTQcOpaTS+MeYQV+zaSA6Lx1VQy1SIfohRutQF9IDMrqaCL7mOuDeQuCh
 j1+9Rmx1vaggyGWOfSA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfX1pNQ1Yp0ak4l
 f1JlKtf05A4YKhFyMZt1DRCoe2Z2YNTx534g+dMfBAXwCDs9ryPYiS84ILekod2lQ2UCdFRIKNM
 AeNaVSi4huZVKPvxYdow85KnD3oaPlk=
X-Proofpoint-ORIG-GUID: b0K7ljl9XxW62aLNaD7QdIeDywEul7Zj
X-Authority-Analysis: v=2.4 cv=Vqq2kO2n c=1 sm=1 tr=0 ts=6af6fe3d cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=pGLkceISAAAA:8 a=U5E2jiqv92kUeAjINO8A:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-GUID: b0K7ljl9XxW62aLNaD7QdIeDywEul7Zj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_04,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130048

On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
> Add the device tree for the Qualcomm Halliday SoC
> (SXR2250P / Snapdragon XR2+ Gen 2).
> 
> It describes the CPUs with their idle states, cpufreq and OPP tables,
> the GIC and the PDC, the timers, SCM, SMEM, RPMh with its clocks, power
> domains and interconnects, TLMM, GCC, SPMI, the apps SMMU, USB, UFS
> with ICE, TSENS with the thermal zones and the PMU.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---

[...]

> +		idle-states {
> +			entry-method = "psci";
> +
> +			gold_cpu_sleep_0: cpu-sleep-0-0 {
> +				compatible = "arm,idle-state";
> +				idle-state-name = "gold-power-collapse";
> +				entry-latency-us = <400>;
> +				exit-latency-us = <1400>;
> +				min-residency-us = <2207>;
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x40000003>;

Please add the other idle states (D4 and E3) from the downstream
devicetree and match the order of properties (psci-suspend param)
to glymur.dtsi

[...]


> +		usb_1: usb@a600000 {
> +			compatible = "qcom,halliday-dwc3", "qcom,snps-dwc3";
> +			reg = <0 0x0a600000 0 0xfc100>;

Please use '0x0' for zeroes in reg values

[...]


> +		spmi_bus: spmi@c400000 {
> +			compatible = "qcom,spmi-pmic-arb";
> +			reg = <0 0x0c400000 0 0x3000>,
> +			      <0 0x0c500000 0 0x400000>,
> +			      <0 0x0c440000 0 0x80000>,
> +			      <0 0x0c4c0000 0 0x20000>,
> +			      <0 0x0c42d000 0 0x4000>;
> +			reg-names = "core", "chnls", "obsrvr", "intr", "cnfg";

Let's break up such long lists into one-a-line

Otherwise lgtm, very nice!

Konrad
