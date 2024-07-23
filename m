Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC7B13D504;
	Tue, 23 Jul 2024 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721762889; cv=none; b=VSCc/Y0x5HagAc2gg1avPMZR3qCNwkCAycrELTN3x/F9ZPG0sL5VIxgJ4VooS5ARu/6Lhd+sm7s2HzvmTD8KpEsg8ObP+pIPKr9Gd+7cLxs/pEW0KiRrVB7I/Z9Iira6o5ox4xDmu0Br85kkiP068XthNrSzuj0HY9Z9edFyys8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721762889; c=relaxed/simple;
	bh=5+w+AZysCTrZdlIqx8wfi/ZXl62h8xJye72WKXHrhCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fJJPOQl/RryD3DA1d7h+QeCds4CqcGMgnxGCpk1AOcvwAOkzbTg64Y+ftGZu74zP2ULGRWTH7B6yuKCYZ2oHUb8LlhC6qu4Uqe32ijQ3h6bJsHSXZ/jwHRiSg993wOpkyZrM9Z3GaE+izlF33yCO0l1FP/5T4tMSECkk1UecvIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=QhAVCj9p; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="QhAVCj9p"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46NHljtH028604;
	Tue, 23 Jul 2024 19:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	itMZ07g6+yYdInryZ6zDSaHasQO4XVp3UEUSFcvpIcs=; b=QhAVCj9pcj9C1/P4
	+ylqVtue3bU2DYTLANpkK2rsTmJ2Hz/3bAwMuqKWZcIWIMj3ZIwyDIEkZUCbeyhJ
	bun2H6vRK3ZePlcw9cW6MF3ebj2wY7CZ+mCnBgnSEsiwYV5fL+YxpyHN1xZNNswI
	ukmsep/HS3IRYuDXRlqNcJ00nKqDSVkiaUU7ZkUqileOv5+ud8m6IQTLE79keVrp
	6JDBWk6glw81tGEN+c0fu2G5d4mt9Mee8GpC2nAYS/uVO1+GB5e1vwUaHgVCyaOn
	P1I92YK4paLYmGs9b/Q9rrbjsaQyh13TzQKt0WjqnNdusoeI5wyXAVWqUDmGhER4
	KVtmtA==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40g5m7048q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jul 2024 19:27:52 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46NJRpNR002333
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jul 2024 19:27:51 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 23 Jul
 2024 12:27:51 -0700
Message-ID: <00630839-6212-314f-f031-0b2b76c37150@quicinc.com>
Date: Tue, 23 Jul 2024 12:27:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org"
	<bvanassche@acm.org>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>
References: <cover.1721261491.git.quic_nguyenb@quicinc.com>
 <44dc4790b53e2f8aa92568a9e13785e3bedd617d.1721261491.git.quic_nguyenb@quicinc.com>
 <5370a13d48d42d952442040f71301acf30f9a5ff.camel@mediatek.com>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <5370a13d48d42d952442040f71301acf30f9a5ff.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: jDKtVnCVt0h8rrLmVHXHU_37pLktm03B
X-Proofpoint-ORIG-GUID: jDKtVnCVt0h8rrLmVHXHU_37pLktm03B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-23_10,2024-07-23_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407230135

> 
> Could be just use this line instead?
> 	return
> param_set_uint_minmax(val, kp, UIC_CMD_TIMEOUT_DEFAULT,
> 		
> 		     UIC_CMD_TIMEOUT_MAX);
> 
> It should be more simple.
Thank you Peter. Yes it would be cleaner. I will update the patch.

Thanks, Bao
