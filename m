Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7603A204C36;
	Mon, 24 Feb 2025 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426301; cv=none; b=n3HGAeK+TptDJzmcgbNqrQOmgZptk049h6NC2gA/gjtOC1KLnh6ydjRNtNvJsGhAXc7I5fgSnkkSe2gy7mzyW4F85atckmGDP5TpPk2m4FTcLYvvjaSIEZj7Av3JSLy/2JQ9fEw1cywb3mXubt1Wd/IqJ2FGZv5SGfhsGIKsMjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426301; c=relaxed/simple;
	bh=AVfkUYV5Qm9qZJ1OQXo/3nV+XoUDQKT/JDdQo1ORKFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WnWQNC3Ms7JefFduNXfNbbtCsmk0xbuAbME6PYJFFtTKE+6p61ecraR7VjtMgiK5mrQADBf3PBZzDvpP40suaaYZ4sZ6+Ee2VJvezQY656hyV85Hn+90H92vz4CNrhXcl3+z+zLz3dN8q9mm2p1GP5xjD+mT6zmtif3alA/4A0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=St+xxX3g; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="St+xxX3g"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OJ33Dl007034;
	Mon, 24 Feb 2025 19:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XmGm3gIjCtkwFcRBZhZCS5r0en9i8i+2Ux48qCrsVsY=; b=St+xxX3gvNGX6mTe
	ZX43qzyd6m5PQP6KPDkqsFaF6SIrniOLTLFmDJVFZpAEdvblC6olhXkmkB+cwXkj
	PbCeSWeubc0X5Kx4LbgeYUwOymQfOWOeqWCkFckUVBYBS3P4YF5IhZLORa2F1Xdd
	6JgUNFORLbWKTdobFHdUKL7L/npINgc6y2oyNaYdLwsNZAiHk6EIJlo2UPIp/1yV
	ZQICSjSsYo2S0lD66GTT3eAk2hvyEcIi+S4zl8vfDd56UCBOdbRDfZESqOsGwfAM
	uCeWxpapo/XBCsIduw5GtGnbuyr/OPbwTtOJAgNu1q9ce5dj3slLZ19mz10oOA3+
	Rs38Tg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44y3xnekn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:44:28 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 51OJiRcK017068
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:44:27 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 24 Feb
 2025 11:44:26 -0800
Message-ID: <afffd4d2-0dd7-d81c-bc10-6b4195050495@quicinc.com>
Date: Mon, 24 Feb 2025 11:44:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Content-Language: en-US
To: Avri Altman <Avri.Altman@sandisk.com>,
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
        Keoseong Park
	<keosung.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Al Viro
	<viro@zeniv.linux.org.uk>,
        Gwendal Grignou <gwendal@chromium.org>,
        "Andrew
 Halaney" <ahalaney@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
 <PH7PR16MB6196948621D2B89F13B4A12BE5C12@PH7PR16MB6196.namprd16.prod.outlook.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <PH7PR16MB6196948621D2B89F13B4A12BE5C12@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: u0mUMsdx6BKI1KgHarMLND5zM_OwGVCA
X-Proofpoint-GUID: u0mUMsdx6BKI1KgHarMLND5zM_OwGVCA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_09,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502240127

On 2/22/2025 10:50 PM, Avri Altman wrote:
>> +static void ufshcd_device_lvl_exception_event_handler(struct ufs_hba
>> +*hba) {
>> +	u64 *exception_id;
>> +	int err;
>> +
>> +	hba->dev_lvl_exception_count++;
>> +	exception_id = &hba->dev_lvl_exception_id;
>> +	err = ufshcd_read_device_lvl_exception_id(hba, exception_id);
> Why is it important to read qDeviceLevelExceptionID immediately?
> Why can't it be added as part of the standard attributes sysfs ABI,
> To be available for read once the exception occurred.

We can do that Avri.

Thanks, Bao
