Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6964D38F98;
	Wed, 12 Jun 2024 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718216479; cv=none; b=C6qj8q13rFZuydsrontMq7tvb1stML2yY2wU3q8DxUjxKu9VxGZIJht31NqrO95UCNGLfmx8a/bZnr7YXjSncR9sR6s7eSBV7Qio4j5xIAYcnefdGd/DNVgy4MKk7qju0KrxEj9TuaghkvHLG0LqgiotZ6oCr4wRdx4evzBANCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718216479; c=relaxed/simple;
	bh=dmCdEyDaa9CWF6uzIZIdsw+wZv/+qhmk+UAaXOk/6JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DnBNTRiutF37pFhJ+U18F0u7kQllRSw1s02Kk2SKQI977r5AEVa43XBLCTALTZ2Kt0DXwawEP5Fau4hRmgxMP/xTf+/ZqFvJwx88HM9EkKhewgJDNLUgvSaC+Q9Lvj3lpc78x07Hyq+SRexlxa8Cym132WWvyicYUGS1t3vD2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=aSC5nsvt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="aSC5nsvt"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45CGOUB4004125;
	Wed, 12 Jun 2024 18:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1wkuKnY3v6ZgdO1n4RdvPiX2uiSoPI9pme0TEiEkQRM=; b=aSC5nsvt/O7yxQtq
	kOkzByEIYG40ylswCXDRfJrdwx9gMqIieQOjBSjqZjGroZMAKILomO74cD7Chf40
	z6GnH1VjXVyOPomecbpayDkm2wp67VhcT7zULOOJOj7g+u9bsRvcox2opjuHLUGv
	Cmt06YBlxn74mPfe/a4qPZpup4r/4QZGXZdrZPrseGsRHjYd0cOraHSmTi2SD99r
	VeeIxW5bUCID2kukNQaT2qDQTkcVeYrNshoTwWV78VCWX5B3n15aswPMXADz6f6l
	ygIdjHrCqSVijagXAlHsqyWT2Yv/1DTXlaoRV12yizqe1QCg/wQxBkpuh3XAwN5m
	MdktzQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ype914rq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 18:21:07 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45CIL58U014028
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 18:21:05 GMT
Received: from [10.48.243.20] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 12 Jun
 2024 11:21:05 -0700
Message-ID: <4300d6a0-66be-4a5d-8c3d-c43043106c4d@quicinc.com>
Date: Wed, 12 Jun 2024 11:21:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usb: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Alan Stern <stern@rowland.harvard.edu>
CC: Peter Chen <peter.chen@kernel.org>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>,
        <kernel-janitors@vger.kernel.org>
References: <20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com>
 <183a4d6a-30ad-4dce-b54d-3624aba36ac9@rowland.harvard.edu>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <183a4d6a-30ad-4dce-b54d-3624aba36ac9@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: sCkTRAscjI77nju_y2oFP-bhQIcrga1O
X-Proofpoint-ORIG-GUID: sCkTRAscjI77nju_y2oFP-bhQIcrga1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_09,2024-06-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406120130

On 6/12/2024 11:16 AM, Alan Stern wrote:
> On Tue, Jun 11, 2024 at 07:37:20PM -0700, Jeff Johnson wrote:
>> With ARCH=x86, make allmodconfig && make W=1 C=1 reports:
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/core/usbcore.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/mon/usbmon.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/class/usbtmc.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/storage/uas.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/chipidea/ci_hdrc_msm.o
>>
>> Add the missing invocations of the MODULE_DESCRIPTION() macro.
>>
>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>> ---
>> This is the remaining one-off fixes in usb.
>>
>> Corrections to these descriptions are welcomed. I'm not an expert in
>> this code so in most cases I've taken these descriptions directly from
>> code comments, Kconfig descriptions, or git logs.  History has shown
>> that in some cases these are originally wrong due to cut-n-paste
>> errors, and in other cases the drivers have evolved such that the
>> original information is no longer accurate.
>>
>> Let me know if any of these changes need to be segregated into
>> separate patches to go through different maintainer trees.
> 
>> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
>> index a0c432b14b20..65f9940bc7e8 100644
>> --- a/drivers/usb/core/usb.c
>> +++ b/drivers/usb/core/usb.c
>> @@ -1150,4 +1150,5 @@ static void __exit usb_exit(void)
>>  
>>  subsys_initcall(usb_init);
>>  module_exit(usb_exit);
>> +MODULE_DESCRIPTION("USB support library");
>>  MODULE_LICENSE("GPL");
> 
> I would change this to "USB core host-side support", or something more 
> along those lines.  It's not just a library because it does include 
> several drivers (such as the USB hub driver).  And it's host-side rather 
> than device-side -- that's a separate module.
> 
> Alan Stern

thanks, will reword in the next version

/jeff
