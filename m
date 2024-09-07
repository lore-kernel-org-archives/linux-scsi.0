Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2BA15CD58
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725741395; cv=none; b=nGxEvI08jRRm59COWR6nNbNNdoqNMKpw/rJplW5dnc1eqx0XKjm0H7WetL8Q7CN1MGpRFF579klobEvJ1uWFavMP+t0S45qeX3xBaOeiitzxE251UbSV/UonlOUpcbOW50DQVtHorMt3qIqAYDBVJP9IcZ2iaiA4bSjK0UaC6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725741395; c=relaxed/simple;
	bh=G4LkbAgzEPnx+H/aHd3TGLyxfRaMv1AJCQ+/+FhHDJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=brPbwzveQqnrJnvYtcCqITUqUt8jlcKN6Paco66AUyLW6iq7rrJPx+Yj0T8APX/+EUTyUhR6BCOGPewy7y13xDO6N7j6FRWQy4deFY51WfUn/e0HaLN3nBuMeMjoKL2LPwM7oN1kNJju2d3sqdCNrWmVh4vLSPavTDBs63mH7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fSOSL5tA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fSOSL5tA"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 487JsbT8020048;
	Sat, 7 Sep 2024 20:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OUP/DcQYxYMI4k/q+sohqEu11fFpArn7yOSpC4hOo+8=; b=fSOSL5tADuiKg7na
	vW1yfcTCmpKTVv3flDXQ3MY9az0liGiiqMBFdWfyPBUEmxvRzF3K1dL5BxJpQmm3
	5Z8Hji0etwkpmRmKzLyhygv4cCZl1jYgYTgTDUw9xl3Wp0zmu9QmscdFvoJq4AWx
	I/cEdllY9kylsvoo9R0/6v2c+xwg8EBtn0pLVdr11QoIhDqo44wVNxp8s/N+M9uB
	UVbQUg3naEzytAfpdxGAgbONwvv9noY+FmtxDMcZurQv3i6Zyi9T7Nb2O6AvP0PC
	o1KOEwFyAd9wVoYskDp+I5sFIbEywHdXb6LStdqnJDXD99AyZGPXEywmZQG07Ctp
	EMwB6w==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gf758y6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 20:36:05 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487Ka48x023733
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 20:36:04 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 13:36:04 -0700
Message-ID: <74761507-637b-2b86-7063-3a73f8a59bca@quicinc.com>
Date: Sat, 7 Sep 2024 13:36:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 09/10] scsi: ufs: core: Move code out of an
 if-statement
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean
 Huo <beanhuo@micron.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-10-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-10-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: t4OVh5kkeksDr_AeH81P3L51ZQBxV3VP
X-Proofpoint-GUID: t4OVh5kkeksDr_AeH81P3L51ZQBxV3VP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 mlxlogscore=673 bulkscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409070170

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> The previous patch in this series introduced identical code in both
> branches of an if-statement. Move that code outside the if-statement.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>


