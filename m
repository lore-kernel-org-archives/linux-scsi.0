Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C68183CA6;
	Tue, 25 Mar 2025 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742941000; cv=none; b=fSV3/l8asxVGV7iwCFPZKWPD54jEzFR1HuH2KAlJftJc70RfhSpcZpyzth89Rv9d8Ud2wJDsm6K2b4Eh0eW+hXtJwAJ61updjYh0pSVpJWe4qcY+0PigZ5PEc5kYRXsxJHrO5flQkOsAJOqk4L6h+7uVDFhQMdhY/gKZLC6KjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742941000; c=relaxed/simple;
	bh=ukbMYLaHnFNbzuxM/IwrERqYhxEtV6X2WUEaBtLFe88=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BMfylrTOtA2Pu+o8Zob4YP33noRnM98kUMtBAwjAqFyC2YaZ9OnDn5hzzVI8Kjb7L1sotT6FW0/+00emkPksOvb0evVp3Pmy7RCnHVoHgWP15ptF/pJZsS0oT9aE61rURpudYH3pcJEBXuF68Okz1qbyiju0Oo2W3nnVYL77/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=HfynHWSX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="HfynHWSX"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52PGaVxL029366;
	Tue, 25 Mar 2025 22:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IqkDku0FBWy439knwpj1QAw3htxh/zATuam0xlC2a9Y=; b=HfynHWSXtuodTWVN
	xIma+SE8dmmmF3ql6VflRpSr4IqtIamNWpkUPQ+tOnhzjIsibRkDYj2UfOf5dbdO
	G27HDtHzz9F7TJs5Gpz6dWpv8iDfRGLlis5Kws5sYkmy5BK2zbq5s1A4YPv2EeA8
	mppt7B8TXMzmx1hJk69k2FJrvI6YYhXNZIF7n+5NInINs87H6Qp9o+ZlqYt33MIs
	k3hCJWN4To+hRY80vHsu5OiVNgJRuWAoV56HWG70AnZb7qc8BJQWWRWk0VBsvozq
	oFsGFaKh9RMFkxCg8AlngWO2KUR/OJG1bQTq3AuVlNr4kart+zedDk4sy72f3qtL
	p6Wgag==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45kjjf387p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Mar 2025 22:15:56 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52PMFuYK025311
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Mar 2025 22:15:56 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 25 Mar
 2025 15:15:55 -0700
Message-ID: <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
Date: Tue, 25 Mar 2025 15:15:47 -0700
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
To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
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
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: mv-66VCUBBs-n4qkdNHUeFgF5sj03LhE
X-Authority-Analysis: v=2.4 cv=Hol2G1TS c=1 sm=1 tr=0 ts=67e32b1c cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=88o2ww302YIQ5eeAPVQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mv-66VCUBBs-n4qkdNHUeFgF5sj03LhE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_10,2025-03-25_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503250148

On 3/25/2025 9:33 AM, Arthur Simchaev wrote:
> Hi Bao
> 
> I think adding "struct utp_upiu_query_response_v4_0" is redundant and not correct for flags upiu response .
> You can use "struct utp_upiu_query_v4_0"
> 
Hi Arthur,
This is not a flags attribute. This is for a Query Read 64-bit Attribute 
data. In the existing code, we do not have a read 64-bit attribute, so 
adding this new code would also allow future re-use.

The new "struct utp_upiu_query_response_v4_0" would improve readability 
because it is formatted exactly as how the jedec standard defines for 
Attribute Read. We won't need to use type cast to get the 64-bit value.
There would be no issue with efficiency because the same machine code 
would be generated.

The existing "struct utp_upiu_query_v4_0" probably has a bug in it. It 
does not use the  __attribute__((__packed__)) attribute. The compiler is 
free to add padding in this structure, resulting in the read attribute 
value being incorrect. I plan to provide a separate patch to fix this issue.

Thanks, Bao
