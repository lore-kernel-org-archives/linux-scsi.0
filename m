Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60061E495;
	Wed,  7 Aug 2024 08:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723020500; cv=fail; b=DlwCDEf4e47hHlgTQFsegmlcngZUwMqFyPDhA6rTkc46e4nrZG2xIMx5TyFu3VGJSl7ZVBbdOEJ+Iolks4CNABns6EocpiFygAVKFHeO0XOwCoUm8iL3NH+2+Lv8sOGNBKQ2YpcEatWgMgFDrzAx//bz8D35RVmLGunJnu+Aqxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723020500; c=relaxed/simple;
	bh=Snj6updHu0aryz+/corC87j63Izy0LL7Mzs9K/OQWQc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dBROGaSFm4jBNrUbJVH3uuuNoGEKg1bhSUo+lNce3cjpsxl/oGraL8UcqRr3yO2pa86HBSGBNj05fmbA1McGqleRC4Q0mxq/udX2RXRtK+AZHe3AnD5W1ANAcY7Q8u4YRehXho+XIvQwiTyv+tHwLfLN/JG3grcs6Frr+3vsmgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WJ8UWW9W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZErXw7n5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJ8UWW9W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZErXw7n5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4776BT0g014269;
	Wed, 7 Aug 2024 08:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=yNtE28OL3dd10LMq+nX/6Ri0yMhZHv/xIPlDf2TnpNo=; b=
	WJ8UWW9W5slmUVudoMQyi0afKZd7KHKAnspAkQtTKGwiHdoFwptxKZgZB7IZjPze
	16fmC6+SMyaUW4oLS8guyheg4KzntsScAb+QKafpXdTD7N0EPhsZIY4Rdh43srRJ
	vFGhW2wZABjDkRqhbQv24r/4MMNSuVhC2QyMwPLFlNHw8tzTCHbRB/Iw48zSM1JI
	zSklxYfC3lXOpZ2zz+xPLrsDAKuxvkkRYNPVOwVb4XWBneZzDcZFj4SQNr9Gl5w4
	fvrDKQd2VGTY32Nfe3Ntd/hy9MYZ7gzezewQE5lguRNyFwtJa6XxJUpl7xzSttZt
	gRIHmlDDkB16Q/vcTm1sHQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sd3uq2tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Aug 2024 08:48:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4776qmAI027317;
	Wed, 7 Aug 2024 08:48:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0g1f40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Aug 2024 08:48:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3EsIa+ZH6iYtlCB3AHVcWTdOchZdzitiZU3YizgHu3zyRaoB7lbWNPf8TW4PnZ1QWtSAmWJFi72qmHmtHfWcB6Zvo4ouz+TQPs+CThzm9gABREyaWvAIS5TGzvTrEC+RzaRCV9A7d0gT/fRkDJgkoBK+kPk1taKv5CkKflZMWwmn+ihI+D/DSI3aA+WV2arn/jOslqrbU4fQT7cCGKkmYgi9O7e0mqjEehmFTbigyWNlkeyWPExUjeWICKHdj0JAQ/Gm0G6NrhF0UpVQVVmiC0Y5/bT1SRpLnJYSzvfJnmzexAtnDms5wuzaz8CDZie3OUZI7POz89zI9ftcf/qcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNtE28OL3dd10LMq+nX/6Ri0yMhZHv/xIPlDf2TnpNo=;
 b=X0u2YoVHEZft6h6Nh/Pb9KsQFGGpkg3yrelWACR0eZcSge0nKFnJTrjmjZtvC/xRrZRM9LgJKXuqcAOaxCdsOiCattobVyhyeR0NJ9vuMs99AlCwvvrzKecnvrLVZHco/2xNTxJAtfjI3GAgNeiwRDQEx/POeBTeKI9GbG/KwREnaRmbQa4gVmo1MzvlLUgnyUXV1+2R3Ju4nwsI/q7zpHQx6k/2+EKkTL5w5YQiUpnZgRBFpnm0clOAdaLvyqOu703tPifH/yp8cCL4RWN2yrg/ArzlLTUixtYfyJOAuclR4BIJ4eA5n5iRIVDyw6YCc31/wmNgElluvzhMPXYJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNtE28OL3dd10LMq+nX/6Ri0yMhZHv/xIPlDf2TnpNo=;
 b=ZErXw7n5KJjCnbhpnVSpug6cvg+BT3z2QckXGPN4wEhdl9BLXM1eZQNkRgwRoILKRF2TIbCRpEtTITl7fWfLGWAHuXJ+QettXbKXoafCv5bOMzqrVeZoYssrCY0M+nUTDypaDa4vVB8a1WMbSW2MXHWiWJjLpcp6P7YeX99fSXU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4624.namprd10.prod.outlook.com (2603:10b6:a03:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 7 Aug
 2024 08:48:00 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 08:47:59 +0000
Message-ID: <9c475f0e-d550-4ff7-9d6c-94dfc300908a@oracle.com>
Date: Wed, 7 Aug 2024 09:47:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix the return value of scsi_logical_block_count
To: Chaotian Jing <chaotian.jing@mediatek.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com
References: <20240806072714.29756-1-chaotian.jing@mediatek.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240806072714.29756-1-chaotian.jing@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0394.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4624:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee0a6e4-2461-4012-2ed6-08dcb6bda405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0dRN0ZxbmtxYUdNdU5uNENyOWljb3FrKzh0V3pmNzRwWFlBS3ZPV3RYNm9C?=
 =?utf-8?B?WTM1OWFHSTNYOG1adW9kLzdkRkhDTGFCY0ZXVW9vV2ExVWIzcnJWQmx1ZUtm?=
 =?utf-8?B?RTRMWmlvUytKbEl1MkxxU2hMZEJ3aWFhMGV6NWJrb3ppMVk3Z3c4VUlVMWRV?=
 =?utf-8?B?N1owaVc2RkljckhBU25iVnVzVEJxMFNVaW40L2Z6LzJuT3pvM1hZVy9Zaklk?=
 =?utf-8?B?RlY0Um9GT0ZCNG1CaHMrWEpIeVF2VzRPQ0VwaC9HNnhrWW95RFE1SWJtczZr?=
 =?utf-8?B?NUZVbE1teHhmeTR0RXJ1bEhQS2NzdHV1dnp5dUtqMXM1aXI2Z0JhU1VYYWhp?=
 =?utf-8?B?RjU2c0ZNOStlZ3RFL3FHeXZZN1ZzYU9QRFNJajc5QlVPWGVrTHkwZnZXY3R2?=
 =?utf-8?B?TExDd0MzYVJRRENFcUFvd0tzckxaQWdPRHA3elFIZloxMHRPa09CSWdNTjlL?=
 =?utf-8?B?QmM5ckpLOE1mYnNZSEsydENxaEFiNmUrNEMvUzlzSXNUdUc1eVVMenFOL1lQ?=
 =?utf-8?B?dDJMUGdzQTloM2N5MWl4aXZtaTZTRnNBSlFjZC9uOU1KaVNJM0tFeWsvbklD?=
 =?utf-8?B?MFZZanh0VWE0eEhJcUlZMStTU1NaTlZycXUxNTJiOTR6L01uU0pxRVZnNGN6?=
 =?utf-8?B?bEFlejVwTmFXd2RyVWJoZ0JBbmlyTXJtaGFzSGpSWG94M2huanJ3UlRzdDRH?=
 =?utf-8?B?UGlkTTJnY3hrc3BtMFRiQXRBZFZDYUROblU1dDVkaHlQYThva29wSDJsdXZ2?=
 =?utf-8?B?Y01QdkxzSEpUdXhzTjBmYWxPNXNDS1FqWi94NFhvRXhzRTlwSVQ0YWk4ZGhJ?=
 =?utf-8?B?N1E4MFQ1ZmM3bjU5QTluT2QrQUMzMDdWVVJ6MnQrZlRkNmFrcWl3ZnByY1Jq?=
 =?utf-8?B?bTJXdG8yV1poZEZub1VaN3FQTFBXd2xOYnhibVdUaWdYMGtUcnErWDNYVEdm?=
 =?utf-8?B?aGhYSnNtaXp5RHc3NWxjdDJRcDlML0RkMWZwbHkxYmRFOWF3UUVxYUY1TEUx?=
 =?utf-8?B?dmxlZEREbEtuVWtTWlBEcGNubmpBdzg5SHFZWGhVV1pCYy9XQUFxemdSVlRI?=
 =?utf-8?B?dStuY2FhVWxybGtGRTRMSHMrYlgxc2JmNCt6V1Nlb2p4cWs1NE13SnhaVWZS?=
 =?utf-8?B?VzVqSDhUYWVOMHZ6QjNXOGZuVVF4eEhkZ1BCa2VqbWJQdmF6NitCc0FCdmZE?=
 =?utf-8?B?WkpWTy9tNTlINGMyRlJKVFZiZVBqZEZMaWZkaUQ3Z1B2YjFRM1B3Z05rN3lw?=
 =?utf-8?B?Szllamx1eU1mMTlTWkYwS0hVYTFjdkNPU1YwLzJiYitRd2E4VXFtY2V1aUxX?=
 =?utf-8?B?Tm56N1JzZlA4YVNYREgyOEplaTd2dFB6Y3krZTl2dmFxTlV0K3FsL0pmcWxp?=
 =?utf-8?B?dG90czJraUEycXZHNVZ0cW9OMmxjdDN4VHlJMlh5YlV3T2RhWjFTN3NUVEh2?=
 =?utf-8?B?aXhSRFZOOS9TcFhFNFI3ajVreFpjMXpFR085VythcE9wUHNHejRhUXRSK0cv?=
 =?utf-8?B?eUV4Mko2RTZpUVlVamRwSzdkMVlYY0xCeGV0bXVQQ3ErN0JQQ1AvMEhScUVC?=
 =?utf-8?B?eTBRM3RaSVBxbWh5dXdzTzVzL2lhSEtkc3J3VjJnMmtzUVVrVEJsV2xQNVph?=
 =?utf-8?B?WGJmSVkyS2FYMkNOZXRnRUJJeTVVWWowd3RQN1ltRm16ZEdvN2ljS0RNdzV4?=
 =?utf-8?B?YXA0eGxrRUNPeDI5bVFyTEVwK3Nocm9oU09BUHRCUjZiaXAvaW9YUk9WejEr?=
 =?utf-8?B?OUI2M2Q5OGorbno5NkhreFkvNmp3MnFlWDhvbEdOY3FDSllReGtqR1NtUG1R?=
 =?utf-8?B?OXhtanRJclBLTG04cUxFdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEx5SFJlWEh2OTNjRU9HNVFyNGxlR3E1Ky81TFhhdHRabnU3TjFtZHlBV3lo?=
 =?utf-8?B?VE5wT1Bxc2tIYzB4UTdDaDdiR0pNODlmUUhrS2w1Vzg4SDBZQXl2K01XSXZE?=
 =?utf-8?B?K2ZxR0hzbDMyQlRaOGRkd3E0ZXZ2SWtXdWExQ3pYbHBoYTN4V2ZwTjJYZThi?=
 =?utf-8?B?RS9icjdGdWlCRG9TUEpJTUNIbEgwN2N4QVdEU1lhMkx2UStKQ0JvckhudThM?=
 =?utf-8?B?aWtmR01Ec0dEb2JZa2M5RUNWUGV1WVk5UnBMQ2pmZ0UrakpsTStLd3RQa2ZD?=
 =?utf-8?B?NTBPMWpUdTJ4dkl6UDBTVmF5Zy8yVkJpVE1jTEFBb3d4cEpYRDMwc1lUVCs0?=
 =?utf-8?B?MlU3UmRTaHE0a0ZCQXU4ZnkxN05RSGp3a0ZBb0dSL1pUb3VLZ2RVcEFzVkoz?=
 =?utf-8?B?UXVMM1V0eUZhTFB5OG9CMjFTeDlCTlljcGJ6M2dxWVp3dkNDVHVtbVdsUlRp?=
 =?utf-8?B?VUFpYW9HSzg1NTE1WkZBNVY3MnYvN0twZnF0cktzMHhUN1NNc05jdkNrOVlO?=
 =?utf-8?B?dXNhRVJ4S2x3Z3ZSaGU4SFA5YTg3cjRUV2ZzbGJYblU5TWNES3U4aVZMK3l1?=
 =?utf-8?B?WC8rTnFtNHZ3SStaSUtKZE92VzdHOEM0dFQvUWVQZlExTnFQUUl1QThZSUVo?=
 =?utf-8?B?L0hpRmNrNnE2cjliVEdNRCtkUng0OE8vNTdYMVdHVVZxYjlnN296QkZPT2ZV?=
 =?utf-8?B?cFNTRTIyRVAyOVNrZ3JqUGF3c1VURmtVdGswV3FkM01paXdIWHo2L0Zjbk4w?=
 =?utf-8?B?TmVVVXJtTlBNWWtmZzMxQkxseCtlOVRWUHM5Q1Q4YS9QZkRmcXJmaG16aTBy?=
 =?utf-8?B?dmFDd203SVNHVlNTb2wxN0dwSDdSb1VpT3o4UHVIbFlvb0Q0bTRUZGJPRjdi?=
 =?utf-8?B?SkF2Rkg2N01zNDZockd3R0Z5b3pENVYrc1JDMXMvN0tadDRvc2tMc3V3MXVZ?=
 =?utf-8?B?U1RNWW55TlR0SDQ3V29ic1pEWEFva0p6THdqd0UxdEZtVlBUUHEyU2kyRnlI?=
 =?utf-8?B?WEEzaTNNK1VxR1VNRkJVampYbGhLTmZPTG5ndEpJRWUxaG1hSDAwekdnNWV2?=
 =?utf-8?B?ei9iY29kbWVtcG1aSHpiTHVrSFRGMitGRko4bjhqOXpKMXBET2Y2ZkhzL0l0?=
 =?utf-8?B?cXREam1USHkzZ280NEFzZFlFVFVHZnMzUWwyV2RqVGZhQ0NsNmpiL1Q2MVRv?=
 =?utf-8?B?NzR2ZG9VTGowcUlCN2RDYTdDY0Npa2ZFMU9TazBLdC90bTd6WHMycjVka01M?=
 =?utf-8?B?RFhqQ20wMlROQVNnSDg3UGxoNTRmc1BOOU9oTERhaGh2NGFLTVlBZ2dSTko4?=
 =?utf-8?B?TnhHNGRXdE1kdHl3dlpIbXNsRjJ3Z1FYd2FiLzhORkdXZ21oSjlrdWNLWEtY?=
 =?utf-8?B?dllXZHl1L3U3OTRRK1F0VE9YRks2Z2lxclFlaHIzRXRQcHhlalRDdzdLeVJM?=
 =?utf-8?B?c2tOa2laUHJFRFZObndvWmJTSU9CUUpBN0dsTkJIRTlHdzJmMWVKQ0t2Y0RW?=
 =?utf-8?B?VEpFZzAyYVVrVmJRd2hzSVlQaHFFeHI5KzZxVW9kSk9CT3hoa3U0VzJrTStj?=
 =?utf-8?B?UjR1TWN0NXRkTDA5SU1VUXNGK1FFSHFEQlp4TzFEMEZtZ3YyQUtmbXg5Ykla?=
 =?utf-8?B?Ymx2OHV4Yk1pSzZVMU1zMFhtdkM4VVVYaVBBdEVTZ1VEZGFpRHBkbEM4RGp2?=
 =?utf-8?B?ZHNQdVdjRm9IRGYvNGZqU0VTSXprRzM3bEMwNGovODNIa0dldTdtWlpaelNq?=
 =?utf-8?B?VXFKWmRadzFiOGJMendYSlo4V2xhUkJSTzFyUHZIRGQ1TFRTQWJpRDhLb2Y4?=
 =?utf-8?B?dUpNeElQd1VpL3ZmM1NBMW5BOWVLSjhnUXlBSXNCbGRnc1RKUkwwL0d4OUVj?=
 =?utf-8?B?aTNLdVEvbmhRUER5RmJMMGxxM1ZIcmZVT0lpcmZWR2ozVVVXQzc2Umxkc3ZV?=
 =?utf-8?B?dWNSTkUvL1hsNUhPRjZ3cjViR1lxNk9lM1d0ckxuTFBhVGtVam96TGN3MWpV?=
 =?utf-8?B?dUdIQjFyaU1Pc0F0TnVrUkJyN1pZZWI3L2MzRWRHN0c4alZZM3laUXc3dE1o?=
 =?utf-8?B?S2ZHOVBDWDAyQTNuV0M3LzdWK2ZrbmNqNFYyVHgzbklzVzZYRTBjNlBXR3FL?=
 =?utf-8?Q?4UhKN0+W0hO0StbcRoByOj19A?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y0H2tnAv6uQtb9XSbP7w+eKIl5RqwWRU98dR9lKPfP/X79pVfPnbSEEweUtkXwkpVo/rv0IBQkaGHYjgms1oGZokLNHChgh/BJ3TlFkLAg45/RIqpIeMsEJW6xCyyONenjtSMYF7Jln3u1/S+caeKj6RomBBMC1YNHRVQtvD+Xr44iiPA35bLdP5hEX7rkm4EhF3Wv+cWv3HMfLm2UE6vjm/8PgQ4ouVmGOOTmhbcf8Cf7mdvYRc4dgwPDDab+b23LFTUesrQ4+GBaPGRVDOkbLX8t5sZyqfc72llMit9z9dYxzcHeH3P7vJPAb+gPyg90dt4ilP+8ZC37R9sDhFgNSrpks8V0BmRuykoEzAB/L1bkLlu8O/bNp1bOSlBP0MwQ2SbwJ3Vdgy6jrw6uWyxC5wMzwx3z2Dx291227Itd5nL6op7MnFdJxT+EhWcgQdrZxDmZhhTVO9Aq5/5wjIcN49u6zs9odkoBlHduNlRdRVvrLp5pp54A8l4mDKDmM54UaJo2PUpxouSgE38sd0GWQPqfSE07kAJZRhyxBCncw/as+80da+jHq8kUmD6Xrj7dTJG1qJxf9SbCgyP5h3tzg1Kn7YowqUHwG0TbySxb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee0a6e4-2461-4012-2ed6-08dcb6bda405
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 08:47:59.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKttB1hMKjCMnKm5AVNpqQuZBme0i5nSt1PT6/1hqm6aLzZsSNl18xowszBctYQdGPoDWvOpt1rIJ0OtsrI1yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_05,2024-08-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408070060
X-Proofpoint-ORIG-GUID: 5_1cj99jZ1J5DIsTVdkLCRxIH1nJYqBa
X-Proofpoint-GUID: 5_1cj99jZ1J5DIsTVdkLCRxIH1nJYqBa

On 06/08/2024 08:26, Chaotian Jing wrote:
> scsi_logical_block_count() should return the block count of scsi device,

scsi command, not scsi device

> but the original code has a wrong implement.
> 
> Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
> ---
>   include/scsi/scsi_cmnd.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 45c40d200154..f0be0caa295a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -236,7 +236,7 @@ static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)

I find it questionable why we have this in the core code, since it's 
only used in error handling logs for one driver. And obviously no one 
was paying attention to it.

>   {
>   	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
>   
> -	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
> +	return blk_rq_sectors(scsi_cmd_to_rq(scmd)) >> shift;

blk_rq_sectors() converts from bytes to linux sectors, and then we shift 
it by diff in linux sectors and LBS.

To me, if this were used in fastpath - which it isn't - the following 
seems better:

return blk_rq_bytes(scsi_cmd_to_rq(scmd)) / scmd->device->sector_size;

>   }
>   
>   /*

