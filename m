Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476526;
	b=j00I41h3dEhUMeVd5qfp/1NPg48RZpm9lLPtQjKEEW8MGpOiD1WRbHJEvLrPJWqVJBxh
	 W1JwzNYdPJf3U06dAwR3LORUAkYqtejfMKKmbuQrzGa94WG0CziFCQUIZUZCUftdL+FJu
	 BrHs/BZZwEqkXVHElZl+qxlsUH7cAXg095lK4qvzWqsLhhXOQKt5KKL91Oiw1b1jC18kx
	 PQXElzGbWCRaLmzWx1kpjjEuLSqWTo6eJWfxoJjUeqZuoPo9oa0Pmh36VR5WAGpydfrE1
	 SP8ScYl+p0zQF5MvjpDRvbL9pNwxry0DvaPq4UpJlUIrlBsyfgCbtLwivFu5ZW+eOIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476526;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
	b=xIb0sXkZtiD7WvRMxKs+BX9QKseiIIWJVHs+z79of2J4Ynv5RGdPNepRo2FI/XH8X/tA
	 iCYojXU0/2JHa7KKt8I1L3TOL8dqJEGDuKTIF/PVussq0XKdf8yE5fOJ7QQ71hbi0/OrL
	 +YZ6kP6sL3KTxdthWfe1fM6igYXRthjpUeuX0DzNLwxKrew5MCCsnmY9FLKE6FE/uWQX1
	 omcrun9uy+9KJFv1452sWVE7Zd7zxhT+lI6kwK6WtRmyMVtr4F7tGr4O/Io8mqX044Iwy
	 Qx7vNPcgXqyQgx58cvqz7H6XWokjKdiC0V/WjSv3409/ekPZOSyjUEUIc4EU/z2BDFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx3v5crM;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YxIEq3pd;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627CB606A882
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 09:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 627CB606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx3v5crM;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YxIEq3pd
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC90vWk2514210
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 09:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=; b=Hx3v5crMD7fZ0tUG
	H6Yd2G2fptq2eQL8VifPCei8qqWNoh0xfSTI/5rrcIHF+pmmO8Gm6QAoXLWqvTWc
	gJPJzgLTZYlxF/I47Kv8pMbEVgT0etivLOdubn2SSAfIjgk79Bc95Smjf8YfvITn
	Tg29Ef41AcWVR5Y1n0WRx+HddvmPLmw8gPfo4W0cwHDBIoq5jBPBtSuYK0OFrG+1
	UN1bc892SzAqaS4VEAGB35jkrGO0SnyeBuFeGtLRTJViOdqAua31gpAXp5sXcdfY
	y0DoXhbULxMHMvtsnS5PseH920Aa4XLSafrcqOVS1dc4YeBGmJNpt94waLmisrHP
	ifPutQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvwm1tyw4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 09:42:05 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed2803f863so41052155ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 01:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794476525; x=1795081325; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
        b=YxIEq3pdRHgG8bAw0t6tglYuUfoEF0ToXp5xLVargiTNmk8xkRnhj2UXn6IEhNAW8H
         G+YZF9rixywlDrecDXJahoOWC2uh4wYxNgo5i8bo1Y8N73mi3G3P35XTKBcl75V6e6RX
         waeDd8x1znWWfSgOQYzswY9jG9Y3SdUpjEzJapT9uEwPd8FUjJr63arSpG52TWBN4KxU
         LkSUSZ0UEOohqyXMACp158szDPGEjbFbOR3ob2ZLy7s532Nfdk/NhEaSfLPKhYBNMAz7
         cABvV/OF5HVb3ttyijh2Zi1pkrcTquHsEIb2dMzovXMJD30TTyzyF4un31tUxGCsJiqQ
         8jDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794476525; x=1795081325;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
        b=MUljauatA2YYInh8VI3UXWI0VBu61wWpN/DAjRGDI0mxgJiHO1f8HxAFgCraP82Bag
         OtL19sLzylWybhYvgVzVAWmoo4vFlC7yfph533cxAQzMfAlIq4y3I+C1OkivGnVci4+c
         KzOSDGyMAXDymUAMM1WFpwqB1RcHkIR3KMsh7sLL7c7sbb5RohEFb9no+mHhnVb7PHCu
         zC+zAA2jzT/mTZRA2IX72ySmafE2XaIJrKqCGnopxMiNBcghZTleIl00tveXqzReTy29
         mVWqlk4szzB5tV0HVqArNTz+IK3D2m31p1ZLZNcGVKZrn4nMtjU1Vmr0gJ/onTTGP2kp
         hGnQ==
X-Forwarded-Encrypted: i=1; AL+hErGHKo861MN8+xgRaXFQdLiGxbIuhSy809VQMF8esHp0QIfSs1Ec8z1p8+JEbLuEZljXtsCs09wbLIHm@vger.kernel.org
X-Gm-Message-State: APuU4Z9eLBKCPdfLQ1I+SPtQL/w0nOk4OgRgclv5nrBxzVAw3mjomuHg
	haelmJzrhOtkYmkoufncgtBRgY8HhAVwYWF1pRv+x2WtfNcDZCAUSEq2wNZI7GdJ4rooWAKNvcL
	3YBil3VH0DfQnE2kJ0FAZYRyCWwatnbKiq2bVbF3lqdophiGDxiwn6vubCxFyV7Eq
X-Gm-Gg: AYBFou2jqBYCMwTKCu/d8fUh+Zr3bNG7Hv9H7QSTkgdVcpZNugzTcbliaje3UUhyQrb
	NoymA07HgU2EIip3enosUbmdYCTGXoiwV317at5y//sfA7I71LgYdXCM44+2HDp3VENoSiLdDMN
	XO3GXJMJzAnjLyIRYs/x4EGBpVQsS1a/cNK1tSCZvr3MeIys40I3Sh6uL88ZH2CSwLnMvgDqURe
	fBbSMnkYp8fidUOjL8upaAxDVW3pIsyla1BPT8zTrDhiXCycZUhwx7MpavCU7hYiW0ORVJwo8vE
	z7Q3ais/CxnQUR5u3zQNaVDR+d0kmrZkMoPxe7kimEhrNpggnqaYmFxyAEVIpbGsVM63ev1Oj88
	uT/VGjDgxvkm7CwCrkd7mQA3AZs/P0tdxZHSLeh37Hq1B2r7n0oVOeTdM3/WGcmqva8EMVJDgWJ
	D6LFI=
X-Received: by 2002:a17:902:f683:b0:2e8:93b5:c555 with SMTP id d9443c01a7336-2edd7aeae6dmr51892345ad.61.1794476524750;
        Thu, 12 Nov 2026 01:42:04 -0800 (PST)
X-Received: by 2002:a17:902:f683:b0:2e8:93b5:c555 with SMTP id d9443c01a7336-2edd7aeae6dmr51892065ad.61.1794476524241;
        Thu, 12 Nov 2026 01:42:04 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7eafbsm30813505ad.36.2026.11.12.01.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 01:42:03 -0800 (PST)
Message-ID: <c8ec7abb-cd6d-4f27-83b4-bd76a459958f@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 15:11:58 +0530
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
Subject: Re: [PATCH 3/3] soc: qcom: ice: Add runtime PM support
To: Eric Biggers <ebiggers@kernel.org>, sashiko-reviews@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-3-f7a84086c651@oss.qualcomm.com>
 <sashiko-outbox-181342@kernel.org> <20261024183424.GE2553@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261024183424.GE2553@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KsnYSmWN c=1 sm=1 tr=0 ts=6af589ed cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=FQAUsAXO1x4B5DPK-TgA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 43gNVNQ8h-GTF_f2CBD1c1m60b8K-wzS
X-Proofpoint-ORIG-GUID: 43gNVNQ8h-GTF_f2CBD1c1m60b8K-wzS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzOCBTYWx0ZWRfXwOMCfPiXw+8K
 7IfRP8Aq6y8Wz74PZI+TgbESio7ZjR/G770AHOAP/IpEcDbdsVbFU1UIoq5jGIu79bZsvw0L2qy
 IyX/A8Kzl9qggX6BHpJ7Isg92Fh/MhOSet6LQ9VXUhczmQEY0IgF7bJjm7JkuoJzPDCIEN1qdG1
 dOH+vz2bTF0h2stbNKs+In5l5lZn+GAB8afgOfqJLnWWtaCuccxgCDNMRAFAR/zKave+J2PY3va
 snv70xWUMaMO1CG8SHg0TywmXKxEwNn5WhKljnFRzRYl6cJdWihHpY7CRhY5evzdEPya60xpxEI
 tz39QtLuiSLyziO1N1/X3ylaYZO2zLlGpMuJDNE3PUx/mq/kq4gSss1xpvb0kFvOnuT9C3UzJrq
 BTa3rX2BnHj8uyEfrlom4K2pKbk7nhu1Vy0KQL5qT9aaHhbwFjsPnNCmEikfEgdHti2JYzqFMiF
 D/oeCUUbyvANALmraEA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzOCBTYWx0ZWRfXysBIm2ShkJ66
 40kOIn2gXmrIIqH7D4meMRLf66jx2XVYc0022X1SMtCMKuWDo8FJuaHItqDO/3/jhlcuVvaUm6D
 JHTKhyWDw7dxR1mIRlzc1GZQ+nqw26E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120038

On 25-10-2026 00:04, Eric Biggers wrote:
> On Thu, Oct 22, 2026 at 10:34:40AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>> - [High] soc: qcom: ice: unclocked MMIO access in qcom_ice_enable() when !CONFIG_PM
>> - [High] soc: qcom: ice: unbalanced runtime PM refcount in qcom_ice_enable()
>> - [High] soc: qcom: ice: clock and runtime PM leak on probe failure or unbind
>> - [High] soc: qcom: ice: broken pm_runtime return handling in qcom_ice_suspend()
>> - [High] soc: qcom: ice: skipped HWKM re-init and unclocked restore across system PM
> 
> I'll review this more carefully once these issues have been addressed.

Sure Eric, sashiko pointed valid issues in current code.
I'll fix in next rev and then please feel free to review.

-- 
Regards
Kuldeep

