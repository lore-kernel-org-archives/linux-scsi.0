Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9B2F2E;
	Fri,  3 Oct 2025 21:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759526854; cv=none; b=pFLO6M6mKPdgNe1/Ic5u9+tfMF149R+Znz6BdDvPlLjT6mSgi3JmbvcciDh73QOR5bElpahX01volYzDTwoAE6YFPjVtr2iILN2SXq9NisojP3kg66l80OtytDqLEB1wrFjFSdZQ3xBvX36GRUmqCawNQmyPs0y4+OLe5pa/Sf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759526854; c=relaxed/simple;
	bh=VLnkmN6JFmI6+tiDjZKaXVpRipRGTczCdk+ruSgpQ74=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kM9thqofo7cEOsLyXAzywDfJPbMjYUD+VUf5yZn+KPisjvjziUz2SL8usLu72p+cu9SKOtlXSoMjsGpI38B3N3FW8mPDntipBCfJ9WiRQp4DPvusVqwD0CU0t+JYcmUVomy3yCeoShXBOzGklH/WQhCrUmqNFRS3QBYQPMd7Hxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=UphS3f/o; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="UphS3f/o"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 593Bfb2q008310;
	Fri, 3 Oct 2025 21:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B8XWXIESYsTb6csuCZa0Jan02W4zo6zBFp+BjWGvXpA=; b=UphS3f/o7X1rozNx
	g41z+ysgk96LiKcE6ZCt0WuskqJOC17jTv04hqKLsAnpdGQDS5inJiIPkObJ4tL3
	2NL1GgHjxaUyRvORecW29YIfz70xITDG9VBd1K/9r2URj5TYA5l9N+iR4QZbXYWP
	S/Tly1FRxGInHCY+jk5mCFsCv9ypSi4WxfD0Y18HXwQY1CHerhuCjJ9pazvHZULn
	Z2iMVkt6CZk73H3uWK02GfBfmgMddpduSKnrT4tEysbsuni42ZT1sonQg0iValh7
	wa4fXs4yWWfPBuRwVtdKCLvONOsZqPl5n6M9vnqD+6IPZCKE0hWzJsCCo+Np9crr
	H+7MGA==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e8pdur81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Oct 2025 21:27:19 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 593LRIPd021826
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Oct 2025 21:27:18 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.24; Fri, 3 Oct
 2025 14:27:18 -0700
Message-ID: <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
Date: Fri, 3 Oct 2025 14:27:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "bvanassche@acm.org"
	<bvanassche@acm.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: oFVrC0TX6rmYSq5KkFQ4hr9EJbKGDp_S
X-Authority-Analysis: v=2.4 cv=MYZhep/f c=1 sm=1 tr=0 ts=68e03fb7 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=V2e3EmDR6jIx8YkXF9kA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: oFVrC0TX6rmYSq5KkFQ4hr9EJbKGDp_S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAzNiBTYWx0ZWRfX43VPCsF1WtTB
 oOo+VFhRni3gsQuEZWtvjXc9gC3pKW2K0SRJ4hRrOSmoQMFHQV6CqktrhCnpmPF6aVpSaLWuwO+
 5B5gZb77JAC7nZ4Pm9ZMAbPCHWQPxPFZdZKnyMIMQ3WYldrGANJS8VtBYbmeeW9qIxEWsUFtRLB
 Z4M/2wR4DuVXye9tu0rL2M6sjDJTtgl1mR+TQOgSpo4By1Plrltb6IAyC3iXeX6ThRdYUa/aSS3
 4Lbe8mLQtdpK0Zo8EQ21PUftcBsyaDX7EM/D1nUG/1L1no1+HChGHV3psHlN4K16VhZ0BoInOxG
 Qh6qS7fcLZbfULOiSCBRTdEOevjhS3KYXh9aVzDZTUVPj2JM1mQsjC32a8IsDl3i+Rf5lbFEEuP
 eP+JJCvM92b5ZQHqadg5jXH9wPpFhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_07,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270036

On 10/2/2025 8:11 PM, Peter Wang (王信友) wrote:
> On Thu, 2025-10-02 at 12:00 -0700, Bao D. Nguyen wrote:
>>
>> Hi Peter,
>> I have discussed with the major ufs vendors (Samsung, Kioxia, Micron,
>> and SK Hynix) via emails. They are all in agreement that 2ms is good.
>> I
>> did check the current device's datasheets and 1ms is what their
>> specifications require. I admit that I may have missed some very old
>> ufs
>> device's datasheets. However, I take the words of the ufs vendor's
>> engineering teams and the current device's datasheets that the 2ms is
>> good for their devices and try to improve the potentially
>> conservative
>> 5ms delay parameter.
>>
>> Thanks, Bao
>>
>>
>>
> 
> Hi Bao,
> 
> Yes, I am concerned that legacy UFS devices may encounter errors
> when upgrading the kernel if the delay is not sufficient.
> 
> Furthermore, the vendor claims that 2ms is sufficient. Is this
> based on a typical scenario? or should we be concerned about
> the worst-case scenario? I am also worried that the worst-case
> delay may not be enough.

With the current or recent offerings of ufs devices in the market, the 
requirement is 1ms. For example, the Kioxia datasheet says "Vcc shall be 
kept less than 0.3V for at least 1ms before it goes beyond 0.3V again". 
Similarly other vendors have this 1ms requirement. So I believe this 
indicates the worst case scenario.
I understand there may be very old devices that are upgrading the kernel 
only. In that case I don't know the specifics for these old ufs parts as 
mentioned.

Thanks, Bao

> 
> Thanks
> Peter
> 

