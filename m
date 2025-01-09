Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D781173;
	Thu,  9 Jan 2025 00:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736381625; cv=none; b=Yf8Xh0a8JGpbSFnyIracch5dtJWJyi9Krd8RycgPVELjoqRpkejc2fqGymQUfufrayhdZeeCUH6xwKvkH8xs34as4g2icVeTXKnaWpuPyk0ScHd7LF3cMrGhjeysWAPdFMfQM0oz4u08XC8DO/R0mgpeIdoUb2c8JwEfOr78JV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736381625; c=relaxed/simple;
	bh=7n4t+rW21tfjqIN7VvmPWbWkKXll8eWJB3I2ucSlwrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FDl8JZtk5jVjxaWWVCQ49T/7kP91PvrXM6ZIJJ8/XnxHCQSMB6HAVLDN66m8Iq7/WkOAE3dBBA0Qv1Je3hFQkq+cfRr/I6Zd9+HWqxTiXjoy32kYX/7Bz/K5MKE5bf6LFm+nn1QywLU5YbrsmD0TqsfmzdAA5CJmPxI/1G/Wqpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=UaFsIZg1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="UaFsIZg1"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508JsPUl012130;
	Thu, 9 Jan 2025 00:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	narx3mcDxtrhoff1gY2u+e5V+OHITcFAPLx/UzMruio=; b=UaFsIZg15DdrbHqw
	JoPFh9mtJDNx5EnsH5deoJkhHos5bfFjyCm+No4dIFxjQm4CWgiyFkQUtbnrtRNN
	uaAD8zK4/MjVEnwawIx69KM25o4cIqQRvRkJF9aXbbjJHTwsGVXEypGMi0hJMQSO
	RNXvGQxca9gCQv/p7lSfM6g+0/NwWXt03FyOcpH5wLu8Vm9O8Q2g/VrLHaOQ9Rqj
	WRsmboKrI3lpbITgmFNS6K8OOLE0CTBjAcVBNNcJacqnBa3Q8Mj2pDXXq9dr2/kV
	X2hNX5MXm3GvG9UaSsB8rCR/LFyIRNSb4eMCftZj4CEm3kunrc11inPGCfF00x6h
	32BIBA==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 441yxbrfxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 00:13:11 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5090DAsI019238
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Jan 2025 00:13:10 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 8 Jan 2025
 16:13:10 -0800
Message-ID: <ac0e465c-3595-96df-9be8-c067b823a13c@quicinc.com>
Date: Wed, 8 Jan 2025 16:12:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
To: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        Bean Huo
	<beanhuo@micron.com>, Daejun Park <daejun7.park@samsung.com>,
        Guenter Roeck
	<linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>
References: <5df3cb168d367719ae5c378029a90f6337d00e79.1736380252.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <5df3cb168d367719ae5c378029a90f6337d00e79.1736380252.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 0AhXJn3ZFm_8Gu09fQToOfzGsQtyqUC7
X-Proofpoint-ORIG-GUID: 0AhXJn3ZFm_8Gu09fQToOfzGsQtyqUC7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=932 spamscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080198

On 1/8/2025 3:55 PM, Bao D. Nguyen wrote:
> According to the UFS Device Specification, the bUFSFeaturesSupport
I will correct the bUFSFeaturesSupport to dExtendedUFSFeaturesSupport in 
the next revision.

Thanks, Bao
