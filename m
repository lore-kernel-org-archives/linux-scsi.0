Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794812234;
	b=EY5Mjay8CPIWDwgVDSrpApgL+0fowHoY091DVG+ZE8aW+UwkkfsaBddnnWlACKZ6sxT4
	 CQh8uw/WKZn1Cs24Xd2TmcvXthy8SyBEuLL9nkUF1elPmiyqeYEzp8AtU4V9bWsbMqkxz
	 XrH6BJqtiHkdoNuomVieCI/qF3YWuh5S1nTrkqPaJbvuI8Mp+f1upKXKQ/RtKLKKAafYD
	 0VJj0mqtlyWnGy513dOwn0Q1EJR8nrARTSvB0ZN6RNcxWm7fBtrpNxzF+QKc2yifuu1Yg
	 KSYkfXdu3Fs2jvjqqQNtLFpbzq4QQxww25k7+myGi2XQ+0G0kVdr3sZTXaD4zippPvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812234;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:From:Subject:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
	b=gqYjivn0y4AexOu3wmlcG8bb61Yoo4of//Svb98E4hyX/hoqhB+Z/1SazsFmwCWYJfjq
	 QNFl2V9Ssu4YB953ITXy8pc3kwSK7cZsoQMzw0ibM23A44yYtzo3Dn9TOSnVpC9anjTfa
	 MX1RtHdtX8AqnL7K1Yo/NlmfWqb9L3QkEO0vA/832nAC9puujzV8g0RuEpT6Dm6WsjWGF
	 OfZ7GaRorH2uH3Urls5qvKswGR1Xrysuci3MEw+8YSaZafjZhqf8VeTLNsU10Kv1nj3pW
	 WIy+/E8z/62GpOLbpTl8OgLYp4BDJM6gl0hKHsDzic/4FkW2pz1ePmf+r82CNe1dMIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLCw5W7Q;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDG8ylHP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA1606A330
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 06:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DAA1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLCw5W7Q;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDG8ylHP
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG5Lo0W323064
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 06:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=; b=FLCw5W7Q7NkeVCGU
	yuUOnerr82EOmNUhiSOX2nGjnVGRAMsexFpHYCIfr3Ha51qinHKBh8x323+XYXve
	L9f67DnSziCuEMlxEr34fazeYbkYBDMGw9F4qZooZatHME8M02cujI/l4Wvt+hHM
	KD7wzIusA3EAA6SAAaQoMBDlWpxp4Xnf1nmTxGtagzqsvuniB4fb57OCA3fE1LN/
	HgpLtkLNQZBsO95/Fqedn6PPuyi2nfNUOcbg+Vem5TdgG3HJxaLB8b33/bHwisCg
	j1v6fIC6QPjQTiUQrx/pBdPjV3J+kRNcmXAY2s/873c+QJZZBMv9dwCNLF8UjlO5
	L6NKfQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hxhnx5aq7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 06:57:12 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-89fb6a45c48so3681995b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 22:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794812231; x=1795417031; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
        b=BDG8ylHP85zP3NraEzlVsFnSt/VhVC2pTmVrULFYefJUmRT4S2rHMjovPPgJ2XuY4F
         JJKlfhpDp+906ZcAbOQm7U/TS6CqfRjMyAUxsyMXdhc7F//V5tWP/GIOT9laFoQt42r+
         jPAwusWs1aG5w8Fc3L+yaQSI/wHl9pDG7Mfzt4CO7VrAZbA3+p7F3fcTl/OUgRlpUt3U
         /+XeownhoeAaFfvBY1nRVUJRYxC1Vv83oRnNNQNSzGZCTWV+xFSYqsght28QmfgwmGxe
         dEVgnyluBOUwYJJJbOrxmc1YbOdPyz0mVyLyD6/jupwTCwMaYm8By8nQf8ZAmNeCJom+
         tWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794812231; x=1795417031;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
        b=FZDUA7QobQTJJcvcK0FEjudP+xw1S3XdL9HU1S41kGzOy/UqYIDK5CxTOUfvAJ4mZi
         Pto/7ZUqVeQaf38sqcDR9+JMYsvhi1AVdnM2B2KKsbg4pPH4kRqDoGS7T3UsA8mRHx9t
         SJ/GPwj5thCljJLTemTPGCXcEX8Zb141QhfkfR74d748dfpDa4o72phhayxR3Rp8/py2
         Liro9e/Nb91JzR6GL3NassT5xKK+vHmGe3BCJQdNwnyM8BdNRT9SH9n8cD1t/9vUMfxX
         W6Ax2faV2g0ZUZvhvg/swG5xED7L4spFdQBDwibStleJT/01mphVyW1OLJcWFsbDCub2
         dX2A==
X-Forwarded-Encrypted: i=1; AL+hErGGjDcbp2yyShnu2ApoalJyptExWSiYnM/vM067hkLyJzMkX0/2OT44jEl/VUxMIp/JDUkdwNdjzaUY@vger.kernel.org
X-Gm-Message-State: APuU4Z/dnPPv5FJdoWL00ZeQzMuhlGYt0rM03D6CtIDBngDmwMuojjLo
	5GosnNG0dMxVFrmrpmYC57CD7YRX+a0zQgx9AKPKFb4VAZBnQybBNJCgQRze43/tgBU8rnOUzWw
	q14sdIfJFiLO+tqND6hB7k1gBxBf3yAQVgo6b+kLDNDta2ro+3qetGSjINgC6KEWG
X-Gm-Gg: AYBFou3vE0uM63OQdKyQpC02q++fkVW04Fd61CgU/4TmOupcE5r+x/UnSvN0+5XFpmc
	uxEKwozj3mIR6pT5RzuArIcRsb2ByjaNLbRb24c0xvEi6WALrSppCcHfljuP+ywcnbC8OHoIeXi
	YpeJ9jZXV+T7MTWGUjJQCzDUM9ydh8apdw2ENlH05eixiLBWTAtBt6yXpXv5JWWSdmSVjQaqLd4
	Q7k1xSfCOwAqGZQIxHjK+uyS/7ULmXpfSAx1237ZmMqLLCiaBWsZvDcvDqwLueC7nOR9R+xaif9
	zemXjTE7Opx7VWg6iYYEn1TgG1RecpORPI8BLUBohPQlJeIqVaJP2BwgBox5GZBmZgOq//Tk7Vx
	wQMFx53YmtlICoVZDE0EFeyHoNj3EM+ihyuVCLrjJcSF1dFxMZ2jhdVtcrFWDRxIYZb2KrjxtUN
	hP3DCH
X-Received: by 2002:a05:6a21:3405:b0:3e2:b15d:56a8 with SMTP id adf61e73a8af0-3f7a95f156cmr9720582637.50.1794812231411;
        Sun, 15 Nov 2026 22:57:11 -0800 (PST)
X-Received: by 2002:a05:6a21:3405:b0:3e2:b15d:56a8 with SMTP id adf61e73a8af0-3f7a95f156cmr9720565637.50.1794812230960;
        Sun, 15 Nov 2026 22:57:10 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18c09fesm3754506a12.26.2026.11.15.22.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2026 22:57:10 -0800 (PST)
Message-ID: <304e72a9-2def-40c0-9314-0b7413e45e17@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 12:27:03 +0530
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
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
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
 <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>
 <20261113035858.GD1742@sol>
Content-Language: en-US
In-Reply-To: <20261113035858.GD1742@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDAyNyBTYWx0ZWRfXzOVuyO1SG1MJ
 qaibVVqBTBBMvQPH2WlbhBs3VRV+MKGYAzych74IWCkieTn/isLOtBj0NyQX2clLCslzp9JFfhT
 uwZJrMTsz6g7/kxWRf50IlcCKxClf5H8vtYvqlmUOs9P3VRf+fJdQmSlhs18M1fFlwX35pVsKYa
 QqrA+8jZWTXvdfvd4yDMx7sCXsa+0FAZBGCmac2vh419QHzWx8ILNzwkYNq0IdemBUVsN7m+SOK
 n9ohiiU560cAshfBS4V5xdz1EfVBefm4YbfqzaVjVNhiLKOuTxYX3HAsD6YYp19ZVD6RVeTPCcV
 ED8vqyp/TBR0u80EPqSdAi8Bc8PThiY2Qvh+s34kyoQGL4GixWY3haUE7bYTdAy+Uu0ZhwT1mhc
 upuhCIj99DmikMao67j7GVSaOHQFnaMcWIJKUrUjNRpVmKhfYQy0tc/elzhYdt/9buukGgUw9bW
 RtPURS37DPKXxRMsf+A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDAyNyBTYWx0ZWRfX+1Ph3J4rrRkf
 7Qj7QeYWn8OGfOgZ3bgKae/Ap42nV8dz2O4KnWIGK0ehEZpBoTcZsemp8ikK2DWpHgcv8WX97MJ
 JFARyDhiB8jKmnSWaMWZ2PePs3Qe/TI=
X-Proofpoint-ORIG-GUID: mblCRDpJRk1vRFtZ3S8XeHYguI0dZbfE
X-Proofpoint-GUID: mblCRDpJRk1vRFtZ3S8XeHYguI0dZbfE
X-Authority-Analysis: v=2.4 cv=Jr5kP84C c=1 sm=1 tr=0 ts=6afaa948 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=AalTVwZ0bjgfRv4LwVwA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_02,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160027

On 13-11-2026 09:28, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 05:00:56PM +0530, Kuldeep Singh wrote:
>> On 24-10-2026 23:59, Eric Biggers wrote:
>>> On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
>>>> Remove ICE enable call from CQE path, since ICE is now enabled
>>>> during SDHCI crypto initialization only.
>>
>> Sorry for delayed response as I was away on vacation for more than
>> 2weeks and hence couldn't catchup on the thread!!
>>
>>>
>>> This change makes the low-power and "optimization" settings in
>>> QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
>>> correct?  Those settings never get lost at runtime?
>>
>> Yes, the low-power and optimization settings are set once and are
>> retained over suspend/resume cycle.
> 
> What about hibernation?  We recently went through this for keyslot
> reprogramming, and it was established that keyslots need to be
> reprogrammed after a hibernation image is restored.  See the commit
> https://git.kernel.org/linus/8b190e9c0b36aac5
> Doesn't the same apply to qcom_ice_enable()?  If so, this commit breaks
> ICE upon restoring a hibernation image.

Ok, I didn't verify hibernation with this change.
Let me verify and get back with results.

-- 
Regards
Kuldeep

