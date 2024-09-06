Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BB158A30
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725666713; cv=none; b=l+uah9RiRnaFzYpFXDOFg24HoUQukr3XN52gRZWwfgSnepdggs7fXsQ7Jve2FCpVqnBaJVDIUb33LgSARTeVtVI/K2fuA/L6v5D3PH3EdHen+HDrFXMsn1bvBeOdgD3KolmxDN/ynXq5+oH7JcadYH27HdQqb4vNGKOSt8eVj7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725666713; c=relaxed/simple;
	bh=C16cCYbzotPYf03INHwFuX8Rvo2QMTGzAhvltRh8dFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=symwn/Xm4qcDyGctubf7JYN9ik8q2vYCbcivAeXNLCngKjQpIYJIWfKbxqdN/ritC8GUCrPDe+JFx1eKOdhYv5jA7zrNMe3Hk0yjmdLNRv8FAPA37rgilUEOGU/zyoQdiwSM7+Sve0kBIMqY6/W3e1YY3p3omqvpQDtMWkOeiUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=b5q/YzQ9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="b5q/YzQ9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486LdVk2019634;
	Fri, 6 Sep 2024 23:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EEVoc/RGY9qCU3C5tebswdN1vCaM0dPweRhr9aUeToM=; b=b5q/YzQ9eZ858F6J
	nr9GysjSyrtophyfb4UZT3dB6LiUVVsOSCzD1llR3xWi3E3tAU43IuOsvrgySJJJ
	fHs2TTVkNpTgUSmU5lrIKdOtgcciEalFO+BMUpXv1rNXurLmBtZknZcSvWciSyn4
	QxhKO4SgVvmy3c0sZYMMjXnNzOOKOYwFD9AkV00FVhhZbWPqa8Ih6br5v+oBE9bJ
	UEfVrdCyXjJ+uwVNru3LaT3nrH+CK2rFa9/7PWa72dkl2mZsm7+nyl8rs46LI/ub
	ZRUGjCkR2zcDQOJTTeOodIoELgK2218JOm/32qwm+ucYU05HKSLngETcZfjwtNeH
	hhtprQ==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41fhwu3my8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Sep 2024 23:51:41 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 486Npe05007803
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 6 Sep 2024 23:51:40 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 6 Sep 2024
 16:51:40 -0700
Message-ID: <700a50db-7278-71c0-a1fb-5320a0fd9dd3@quicinc.com>
Date: Fri, 6 Sep 2024 16:51:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 01/10] scsi: ufs: core: Introduce
 ufshcd_add_scsi_host()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>,
        Bean Huo
	<beanhuo@micron.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Andrew Halaney <ahalaney@redhat.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-2-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: M4SSdNoGtR3D96Phhd9AECLkJ13i6Stc
X-Proofpoint-GUID: M4SSdNoGtR3D96Phhd9AECLkJ13i6Stc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_08,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=651 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409060177

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Move the code for adding a SCSI host and also the code for managing
> TMF tags from ufshcd_init() into a new function called
> ufshcd_add_scsi_host(). This patch prepares for combining the two
> scsi_add_host() calls into a single call. No functionality has been
> changed.
> 

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>

Thanks, Bao
