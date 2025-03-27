Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B762EEA9;
	Thu, 27 Mar 2025 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743111945; cv=none; b=EuiXy35PaH8bFy9coWva7qNa9WpTAQGBaY1XBaKFv/VlRWhBszVQsbRWt+ap8UWdukeSai1rAPsJV/bmLzFopxduOXN1dxCelACVe5QkiKqu4SwK5oJB7pFT8ng6tZrOWKNbek/PSu6of4DPzQXDdHZvhD/6XWkM/Oami6fp8gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743111945; c=relaxed/simple;
	bh=wt/bKye6ykh5HMh8CV7ujLnDR75xCH9uZa9b0I+dfYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hc0f1Tne5OY+aWQ4C4Tjr4dwC0NCzmPGY/K9LVeRrPQXrHteSkr1Awxnyes8Fy71WMBgbYO7AQ/qRjt8/BNfawXIy0A/4iaQl9/fbXq7GlomZU8hiRyS3wnLXU/DxwiNVPmsiyMS0wnl+PguQq35ds7qT5sQh9rhVphNMXbvtwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Qgw/8Fey; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Qgw/8Fey"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52RFOsjC005967;
	Thu, 27 Mar 2025 21:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zvANn6MKGnI/R3dATeqeGh0E6qIlFeBO/SDqOqZXNB4=; b=Qgw/8FeyzSmI1wlB
	NfZnvKcBcpSNZt7B94o8k/ebxojfA/8usORWpJsGNHzNzeM05YvqRUdCY7Kp2ARz
	g3fc0X28lGyHiUt4Yh0AuPYfjg8wJS+JTjwsS8/9lOAAVj3ah1MOqbKn9aQ0xXYf
	JcmqcrUN+LNykHIbvC7sHloXfD2NAMZjyy724owaUuVTc71Bmz8nOvaM1Pow2Vi+
	a6osk9abCncVB2QbmfN7bdF/lZU+k3du3um/I9gBiEhNVXwS7nofdz67m+Jy+loM
	+kWaO+IgkFOWEo+lIyjtB4TefMz6Of8q9nQcFmLOhTx60gfG7f9QjvDcmsYq115r
	Ns/Xhw==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45m7nf6pfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Mar 2025 21:45:11 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52RLjA95029897
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Mar 2025 21:45:10 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Mar
 2025 14:45:10 -0700
Message-ID: <4cb20c80-9bb0-e147-e3c0-467f4c8828ba@quicinc.com>
Date: Thu, 27 Mar 2025 14:45:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        Arthur Simchaev
	<Arthur.Simchaev@sandisk.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
        "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
	<matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Ziqi Chen
	<quic_ziqichen@quicinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Gwendal
 Grignou" <gwendal@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        open
 list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
 <0a68d437-5d6a-42aa-ae4e-6f5d89cfcaf3@acm.org>
 <ad246ef4-7429-63bb-0279-90738736f6e3@quicinc.com>
 <3d7b543c-1165-42e0-8471-25b04c7572ac@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <3d7b543c-1165-42e0-8471-25b04c7572ac@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: nCKyFslt_4G4_-qPtbD5MfnbT8RKH2fg
X-Proofpoint-GUID: nCKyFslt_4G4_-qPtbD5MfnbT8RKH2fg
X-Authority-Analysis: v=2.4 cv=IMMCChvG c=1 sm=1 tr=0 ts=67e5c6e7 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=St5hpErUO6hIVgotEGUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_04,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503270146

On 3/27/2025 4:36 AM, Bart Van Assche wrote:
> On 3/26/25 7:47 PM, Bao D. Nguyen wrote:
>> On 3/26/2025 3:49 AM, Bart Van Assche wrote:
>>> On 3/25/25 6:15 PM, Bao D. Nguyen wrote:
>>>> The existing "struct utp_upiu_query_v4_0" probably has a bug in it. 
>>>> It does not use the  __attribute__((__packed__)) attribute. The 
>>>> compiler is free to add padding in this structure, resulting in the 
>>>> read attribute value being incorrect. I plan to provide a separate 
>>>> patch to fix this issue.
>>>
>>> Adding __attribute__((__packed__)) or __packed to data structures that
>>> don't need it is not an improvement but is a change that makes
>>> processing slower on architectures that do not support unaligned
>>> accesses. Instead of adding __packed to data structures in their
>>> entirety, only add it to those members that need it and check the
>>> structure size as follows:
>>>
>>> static_assert(sizeof(...) == ...);
>>>
>> Thank you for the info on this, Bart.
>> IMO, this response upiu data should be __packed because the data 
>> coming from the hardware follows a strict format as defined by the 
>> spec. If we support __pack each individual field which data may be 
>> read by the driver (the attribute read commands) and check the 
>> validity of their sizes, it may add some complexity?
> 
> Hi Bao,
> 
> As explained in my previous email, adding __packed to data structures in
> their entirety is a bad practice. Please don't do this.
> 
> Regarding your question: I have not yet seen any data structure that
> represents an on-the-wire data format where every single data member
> has to be annotated with __packed. Only data members that are not
> aligned to a natural boundary need this annotation. Examples are
> available in this header file: include/scsi/srp.h.
> 

Thanks Bart. How about we change the current utp_upiu_query_v4_0 to

struct utp_upiu_query_v4_0 {
         __u8 opcode;
         __u8 idn;
         __u8 index;
         __u8 selector;
         __u8 cmd_specifics[8];
         /* private: */
         __be32 reserved;
};

Depending on the opcode/transaction, the cmd_specifics[] can be type 
casted to access the LENGTH, FLAG_VALUE, VALUE[0:63] fields of the QUERY 
UPIU. The __u8 array[8] would also prevent the compiler padding to the data.

Thanks, Bao


