Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2804E13C3DF;
	Mon, 25 Mar 2024 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711359014; cv=fail; b=SPeVRuxSHeUy6aAJ4BcJs+Lfq/MeW5fKj3L+16c/wq8MmyWqFc+K+ZfF220mE/fB7lZSfnGGXmI/Dc9rIYHgH2AqkjeRtE6p49XEdQGtjCYOKku1MAoN+VdzsZQu3Lr1B4Jc04Zjfk8q1Ab7NGTRaUbNHcWJcDqHPN5T+T12dWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711359014; c=relaxed/simple;
	bh=lw5VqAdbwZr8RRkykZfjgCI2WEUwopmHMhvdDqa1Frc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MIKO3lfiEH35j+2wLnfDwlXrdnxMCnMGCcbejSo7+T2QKaDyYoAFmi0JpPt1pt+yigoqNIi4bkVs02tuhLQQasKqhs35IgLNtYpAvfDpZeeCK6juAML9r44cCOFw3auNE/xFHL3abVwL+CIBl/Vz8QUC1+POONOj9k1Liv6xK+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QplFjFgW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YItzt9jB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QplFjFgW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YItzt9jB"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42P8qXP5027657;
	Mon, 25 Mar 2024 09:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Hx/C1Zegb0+T9phhOwLELzKCTyIZF2k+thwCFtbRIrc=;
 b=QplFjFgWF8bDvLnap9+leT+6nI8vYoCe9vuKjNxCvYERqcCH+NTSURMG6mLw14Kyef8X
 hGFVuS6fw5ZMzTmKeC24qWEgr23ojian34RhCkGctJxq265qXBwgojgfkGLX5D9coboi
 tULfJOPHcki+clJr5yhaKSJz9HgTGJj8UO8BLQnRCkpuSVBYR/yWreRncm81JSwsn7ls
 w0AcZYotVjJQ8qQH1kVwPUaKXF1Np/M1vI3/dld70IavZfnrhPfEVmn0rgpAARSBkVO9
 KuHHgSzdUrD6j++TR+oI7fsgikYWBDFmLbLCkBmk6HuCE0D9zD9hbxISLMOGoqrCb+VT 4w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dta0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 09:28:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42P9OsbQ033151;
	Mon, 25 Mar 2024 09:28:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhbg88m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 09:28:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb6NpU+hkeRCmUwnehJffJIwOhFX1Q1JlSPYVn/KhsG2x2yKAajlF9MeCACCR9f0xYNlztIyVyhgdIEjja78auWKMf/8rkQuhdL8strM+pfR2Mdy73WM1VNkwVGCjgF9zkBEHqkSig+SNhZsYWmneVwG9vZ1yLZht8/XAROaEX0aLiXc7wxOmDUQATQxwnJcS8lKnW4Vbm8lclt1C4wsO+N/zxlzpg4kDREOZsNqy/j9wGAdJI5ca6a1XmehCyKeYIqLAF3+/AqjcXi5LF2hwGpttTTLMS7NfdNoc8Rx0kNBGrdo4yHXWuRq3gYhAVx6h2zI9uCFqZCAKJjr9qzOnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hx/C1Zegb0+T9phhOwLELzKCTyIZF2k+thwCFtbRIrc=;
 b=dis16m1ugufIJ0dthl82MbvlpeuVWEm9FNeG0p4XkUnD3x0e06/Fcbil92bWsIsM8PuUCCO3TLPI3+9n+VanRQ5c9jSap024JRZ0f+Ie5SxtR/yaU7/CcTg4Ka1kVp5y0CS6/Yd22IjczdZh2sGV1qO/Q9HQKe+lFWbgn1p1y/dnlGob9vNcGnpSDbVCcnKPBG2jNv1+9Bzo5ZGfwAF6oJ26o1pr7Bc2A4+MxUXP5eI6fukdskriA0zXiZNispqsuRQjcCgPGslvuZxv6pH9GO54NLO75nLf+JjOLxGw2ncq3f+cLTBQppZiVuK9IQuGOVANSJuxKG27gr1/JTKxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hx/C1Zegb0+T9phhOwLELzKCTyIZF2k+thwCFtbRIrc=;
 b=YItzt9jBwuLzhA3MToO8V7FMgSHhK/pPA/V7LX8W4g3Pb9qJ+1mthN8EUqNlaswz0cqgQuoqvQWb+17qrCm/DQiarFHmp85rz6OKnO0j7LKrXn1ccKES23nHluays48xGne4M1oQwpmk8nsP1jjQUX35hTfkF2+Ru/Ioal6sEmA=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Mon, 25 Mar
 2024 09:28:52 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3dc4:7751:97e:42a1]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3dc4:7751:97e:42a1%6]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 09:28:52 +0000
Message-ID: <515ae87e-745c-42b8-8e1d-2697bf343c01@oracle.com>
Date: Mon, 25 Mar 2024 09:28:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: don't reject too large max_user_setors in
 blk_validate_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Yan
 <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0086.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: 223a0081-2c75-4889-fc0c-08dc4cadf4dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zwxvBmdkfk1UdpwMA1/eh37HecbyQLLBkC4F934imKAXfUQblJ0Kd5o4oI7UQ0ALHpnxSaCCcWyiL6zr85TvvYgbSNpPz3hV1jng+51Y/nIfTfYIiO1bvE55G606bMpWJdXtNtv/yRCqZaQRyGquM9hFlpBVi9vsLocoskRusZTzfZicXTr7LL30d4G9Uwm/wpMGc4BdD9sVqXUg8U50hgH5cKZegRZh1rHI1o0tOxuuf/9AOyfD+3Tkz4GkjfJ6CCuzo1uZYkb2wzl1s+ZvIbl+RJdOnczAaASx6Gg7Di/RrdPNNMGhMFd3oaVuqQtHpgN3WTlytr2ROy0gOpFZtjjo1gbQVnFzdF3mLzVNz7nEaN1V1JVB+GMC79DoJjr1lbrxuouffrGUGT0VN+Fq4+8N95Xvh0y3wadmghxDlcs2qjFUsKxhm8b91qIKDO5ucTQAfMZyCIp10pzzyUVkCf4SVklJiKhMj39z/uiW6ViE55CrBG/bNXOguAky2zu/StPtjU4r9M5U9+X7BKyPlWSV3bSp8ujcsl02omwVczd9XPrhBmH5qWUb0dWagHB5orTuohidCruWR98YYgzd3+E31VKNhAYN4veVqNIzRf18MeCZKlmhBtnG4NJCd+SjJtS9lDqEzt9C8xXai7e3wgj4uX9+06Ihx6cgRgu0brE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SFRHOExVbXZjNWRLTzgwZ2NvQUdKdkRKMmhGcU52VnlOSmpVOGlYaCtQWnpB?=
 =?utf-8?B?b2srR1dVWWttdGgxa2FYNEkwMkFtL2RUb0lEdzFFaWJjRzBUSjZaK21QZS9S?=
 =?utf-8?B?UzB4TWhtU3V2RDh0TTJMai9ra3krQ2tzYkM3U0FGYUFkQkNWS2s1VXRoT2VS?=
 =?utf-8?B?aTA4NFdWczV1L0NpQTlrakNDRmtoY2wrcXRZZzRGcS9IOXFRc3FSa01DbkZy?=
 =?utf-8?B?d2dEUXI0ZzYwbzREUE5wRW94WTZnaHh6dXQ4N1ZVdzcraThjNnFxNmd3b3J2?=
 =?utf-8?B?aW9abldtVk40MGVlNmtrY1pxQ2dMSVJtaXNIWmg2c1BZZVRZWVBUdE0yTzll?=
 =?utf-8?B?Mlo4MnA5MHVxTXJFNFhKbjNqZFJVR0ZJcVc3S2NHZ2M2TGJHWEtBb09scFZ6?=
 =?utf-8?B?eXp3WFFHR3FudlJtNTk3MUlBN3BDc2VoUVh4MUNKNWdzTzI1VjkvM1Zxdkov?=
 =?utf-8?B?a0pyWUFML2IwaHJVdGNxU0NZMkRlanNoQzZPTzl3dXRydnV5aXRIVFkxOE9h?=
 =?utf-8?B?NXNqTzlvZ25oakpHK253K1MvK2Z1VzRpSk9NZm92czlzVHQ3UC9QbUJOeWtp?=
 =?utf-8?B?Uml5c1p4bG1YNVJJc2dZV2FuQU5hVUFXaVdkYVMzNWs1STVKYk5TdUxPNE56?=
 =?utf-8?B?Znlrc3JrTDc2RXgxQWVrNDJNeFRlL2pUb0MvVDkxWVpNRHFUaStQZE9STWhE?=
 =?utf-8?B?QzBNR3dLQml3NHd5TE5tNWQrRldNd2NUcHdZbXlUWHE2WWdRU2UvaFBxMGtN?=
 =?utf-8?B?LzhwTGxXZE5Xais3T3U4Z3VLT1ZNeUtlMlNDMFFpZy9KUExPTzJOT2lPT1Rz?=
 =?utf-8?B?OVlpSVJjQ1hCV3B5NlF2WGFFM0xoV3pJVW15VEdvRjN0RlRTMVZpSllCK21y?=
 =?utf-8?B?Q3NIWUZCZEErcE5nblVsQW9aZ3p1V1puRWN5ZDBxUEdzZTRlU2N5TjRvSXFw?=
 =?utf-8?B?WjlpeU9wSDR1bGhlMzJNR09xWEowcW5KaitMdmp6aEI3bFNTc3c4dlU2Yzhn?=
 =?utf-8?B?Mlg4ZjN0WFVRUlpkSlBNeXJQQUtLOEVoaGp1aVVpb2RoQkFIZ2lXSEVzUE9h?=
 =?utf-8?B?TlNDMHQ5d0VBYktqQWJCcUNnaW93NjVjQm0vOTZlSzZMTWJZYjhYdUdEaGNX?=
 =?utf-8?B?UXN4cllIT1I1WUxwVUR6TmRrd2lPcTRaNFdJQ3d6UUxSN0M2TzNqZ3h4SjRy?=
 =?utf-8?B?R2lsdEltcXM1UXdwOG9SZWtJVlVyVGhHSmszNHNLZXBXdVk4NFpRQnVtbmRO?=
 =?utf-8?B?Y21hSEtjVW9nN1cyL1QrdWt2SXptS212d3V2YmNKRFluQ3ZDRE9nbjhtNGc5?=
 =?utf-8?B?ZGs4S3c3bUJYTXVkdURlWEY5UnprOFZiUHNxRlk0TDZDZ0RBYk9JTnIvZjZU?=
 =?utf-8?B?SVpYRVJ5US96Y0ZZcGNWdEVBVEpYNU1KQkVLS1gyU2dHYmQ5clRIU3RiQ3pQ?=
 =?utf-8?B?VG15U1lyQkUrU3dyNmhZQUZyZlhqSFV5N3FTZEd2TDhncllkL1J2K1dxUys3?=
 =?utf-8?B?MExLQnBONFUxT0dyZkFmRkI5QlhwRUVkL3lzN25UUS9TeG14N1JkNngveHY1?=
 =?utf-8?B?T3hYWE5FT3lUbnAra3F1QzRTQWZZRGFlVlpHNlNiWTNlaXBFak9xYitZdmUz?=
 =?utf-8?B?ZG1JbnJ6R1UxaXNMM1ZSdXdtM2U5dCtRaTM1NkNVbTNNRUNCQmZ6cUNqajE1?=
 =?utf-8?B?ZWNPa3JFSFJpa2NjWlh4UWhFZzRIdkUyclhmWG01SkgvWXBLS1paWDRzbURj?=
 =?utf-8?B?bHA2dENQSmtUQ1ZoMVhDNWYrT2p4NXFwWGo3YXZMMGJXekNHWFFTb2pGczc5?=
 =?utf-8?B?MVhVd0h1MFEzeG83N0wwWWprc3lkbkxJVTVlUVAwbllkWTJxTVlESXVvR3Rw?=
 =?utf-8?B?N1hlaGJUQXR4NG9xSnF0NlFJdFU5WWtVanRzZFBOV1QwRUZYVG4zU2JhMW1S?=
 =?utf-8?B?ZnJ2WWJmUjdDdFpxZ05WN3B2MGdhYVBoVldUNjRwdlRUTEphbVJreGFZVXg0?=
 =?utf-8?B?d3NqNkE2eWZRUVQ1MmdjSEtaS3lndHdLMEtYNjJvZ21JYUVBUVBEWExKeHBL?=
 =?utf-8?B?Ky8wQkNCRGZFL0wwZWVobjlnS2tvZDY5QjRON3FVQlBkaXVsVkxtdmtBODZN?=
 =?utf-8?Q?51AHUqdw6ZdrlG7YGRL98+2np?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	v8WUGr4rnc5QNx00megueM8IqedRgqD6nqMfnhSfSzIQvmHc/mehvnpVWjBD/+jlrKfppdOVuFFS4+9Fi3j4xNQJ2Mrd0WbYt6DONBLMlOR43rBL3UCQgvaWI02OSUor0+qWFqi2maX+nk8TWj/CWAAZtcojumHiJMcHdJoUUy7buM3yHM9Y/LQhiThpcOK376jmAikSQZHJisPYqTL1bMfTnJg/jPwGccyf4fbmnrhFgYT+zVLtcvU9FfoLOQOUlx+CKxkuVSBhK52JVMPOxdmzFOIq8Ue6mpxO8uwMRXPnUSBLxQch2VReo9t4iRz9aEeuX1TTiaRicqQrmCQ4f08n71iucw8OIpnRYpus4xcOU6N8oxnjHJVi4S3414y1v3oTL0eOu9mQ4w30wuvm5bJrl09sRRsVMMKJ7Mmm3g02H1OkiyMbAeheATHOUh5b144QKU0bJtlNdhyAGHfwlwDtxOktXSAkWeInUsiPS1+jD+q8qfxBZ70Te1LUJEoC1Dzz3DYwNHrRA+cQTh7x1OXXqXVdg5gDqTZpedgYSmNoeBT57OIQSGTpC1lelKaME4nOQ8fk5SyS38UWjeW00kv0XpqhfMpHRZajPGg+Xz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223a0081-2c75-4889-fc0c-08dc4cadf4dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 09:28:51.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNEIrXQBvjjCJMEoF1+YXMRgZ9Fd2FeNWpYWxqgAHT6rqkRxvNFqnI2rqTMEf4lFIijmcNb2UFWq+UoO/O5MLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403250051
X-Proofpoint-ORIG-GUID: fILqErsKxVwLgKOgV2tarigl7JlrnW98
X-Proofpoint-GUID: fILqErsKxVwLgKOgV2tarigl7JlrnW98

On 24/03/2024 23:54, Christoph Hellwig wrote:

/s/max_user_setors/max_user_sectors/

> We already cap down the actual max_sectors to the max of the hardware
> and user limit, so don't reject the configuration.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   block/blk-settings.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 3c7d8d638ab59d..cdbaef159c4bc3 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -146,8 +146,7 @@ static int blk_validate_limits(struct queue_limits *lim)
>   	max_hw_sectors = min_not_zero(lim->max_hw_sectors,
>   				lim->max_dev_sectors);
>   	if (lim->max_user_sectors) {
> -		if (lim->max_user_sectors > max_hw_sectors ||
> -		    lim->max_user_sectors < PAGE_SIZE / SECTOR_SIZE)
> +		if (lim->max_user_sectors < PAGE_SIZE / SECTOR_SIZE)
>   			return -EINVAL;
>   		lim->max_sectors = min(max_hw_sectors, lim->max_user_sectors);
>   	} else {

