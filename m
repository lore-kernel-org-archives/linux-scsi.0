Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227C383;
	Thu, 11 Jul 2024 00:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720658560; cv=fail; b=HxaEBvcFPuRy3TO8fP716IVn+e98ods1IAwvQFaLy4sFiG015XSO/Z4ITY+5BXdADec/VNBRk12IodGK4Szn2pOaE7QWRi8kbf6+IZaEkjEWGgThJQgyi+3m457MIpprGNozBqdfMOKa35dqdEM6n9buv2K4CZ6j5A5xlesbHuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720658560; c=relaxed/simple;
	bh=rhtt82WX3UOzDTBq0GG7sHPqgZu1ZFZKaBksZ5dWAb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qkZq/rlafMQGbzpi/u+iG5qGXIPuhaY9nKX3IDyo2wSxZ1xEEesO6UjBYQcnQ3o5X4JeHq6PZPnMTNA8RgAZ0Ft8iSZa2p/P+OKqK2vhKdoM73efKjOFrWp0H1bgd2BOq9mMJnpUoyw3rqbn2zqSBH8JCgTFBaXF6jcXejm8icI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q0cpsnGr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cM73MFjZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q0cpsnGr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cM73MFjZ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFxXaH017491;
	Thu, 11 Jul 2024 00:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=X0nQpgn3BiC/84VpsDxWx8rv2HYOnjKy13bOunWMNgY=; b=
	Q0cpsnGr+f72XQ7ikD2LlFNU0oeJf65R1sslhVwne6aEfSE9+kogquag76YKcduG
	V0Z2y/QuSfQoRxbe7Cu1suIym6SKl/SIFXuIdqjFNx8xR3KFuWg5X5Juon0tG6xe
	uRrGZ7WuRTRYctZEG+XXOpYeb6pxrDmOCRziMKIxNXkoYXMG8autqqoI/+QvGW0g
	4icYhHNN+qwkyK++zaOPCGREDlTr2hmSXIAasDpvz+0om0ht9muLEMDy0bCCJU2n
	ITkB0kBAqf+eaPFmP+G8dY5K4VHBvRzRqUwv71IsdxTuq+DZDFhmjXYsazv3vmbq
	ZBHrlkhF5/Uz0qD3F50V8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybrka6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 00:42:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AMFord010924;
	Thu, 11 Jul 2024 00:42:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv52yjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 00:42:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td1pjnKis35ZSUVPHqMvfO5g255OOxJE24rM1Jd+i5ylv/GYmbkpNSSVV7Fu0ZZkRO2YxDMMSlsMYwbH7RmOce0Z1YV6EMBYDKyqyV2w3CimtxhAGYfLNwt+RZB+I/HUDaKFAf2WyrHIJ0mk7SvaOJesmM+r93T4G8Ug+HAy5kqQYjC1b4a9CTrigs3N7d/Gg1N8deaqaRoytnz/a1dnmYPTmHLzeI9+qDYRl5XGIE8cAWVL4cv4AHliOgDPQz9lKxbBlrzEoOGRNut8wNDcBBi83OSJlJP7g+ee5TDW1hFwkt42rwAIFlOWFeicI+ytKSmxQX4Em7W9H9kJ5M0eJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0nQpgn3BiC/84VpsDxWx8rv2HYOnjKy13bOunWMNgY=;
 b=cYv13brZxHceDAs3mIq7xBe/ExZj08gOslIBSy625T/vKUlc5dCcVye99CcZIhnE/qrWGAr8tq9hPqGUD2CFAiqFIhmqie7idBDmgyatMkKyBA9knqfefW5r3DScWVl1W4cvMpCoK1jeY/Vikc/iLm9DjHNxlJ7CLhmxzb4fi26WHTp6w56IoTw9hTntkN6Agu6n5MlhjfRpyUO0B38P9GOD56y1zKkltwnQnGD/NeSH4m0YwWD+Hwy/PdW78LvfAapuEw1WThRYbloY3iQOMuZnp0t+FFiShstDD7+7IOPquaMi3Y4Mi6dtpGtcPhfFyp7vGVLjPPkbMtHLou5YbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0nQpgn3BiC/84VpsDxWx8rv2HYOnjKy13bOunWMNgY=;
 b=cM73MFjZeBU4q920CV+Hu485n2QV0+sw1aXP9koKFe8XnMkqN51lXd1cfjBYmFjgxq/OM9fKT5OwbfnzPV/bKCv/QxHs8MhcaOyF/ncc2h14d460c3kx2LPqC/gZ7/RBKHH+1vh6sMRlFlOyCXTJGlZw7HERSzMNmJCkLQ/dtu0=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SJ0PR10MB5664.namprd10.prod.outlook.com (2603:10b6:a03:3e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Thu, 11 Jul
 2024 00:42:27 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 00:42:27 +0000
Message-ID: <72a37e4f-29fc-4859-9f4f-d40adf2e67a9@oracle.com>
Date: Wed, 10 Jul 2024 17:42:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: Convert comma to semicolon
To: Chen Ni <nichen@iscas.ac.cn>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240710032423.2003805-1-nichen@iscas.ac.cn>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710032423.2003805-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|SJ0PR10MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec7eec2-d1f9-4aa2-dd78-08dca1425647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?czBNVGFGZUZFek1hZHNhR2laeEEwWmFLaTlsNlB0ZVdDN3lRTHNnbmdHdnJp?=
 =?utf-8?B?VVNoYXFUZm1LOW9Xano0SDA3czFUWDNTOEhkcU0wcEtEVDg0V1FpNXkwaDBr?=
 =?utf-8?B?M2taNVJaNnZmYjBQcWFkT2JKNUY4Nkx6WjBXR2VndCtJRnBCaFhET2Z6akQ4?=
 =?utf-8?B?dEJXeUo3cUNSbUZZbnlwNzljWkNBMmdSRkxyRUV0QXBIM3dhdWlPMkNXSDhr?=
 =?utf-8?B?QVF6TGZadHdDOW8yRStmK255alFJYkI0ZjhjclhqdnlMUFlhQ2hWaUl4T1Zw?=
 =?utf-8?B?TFlVWThTYlE1cTBPcWJMTE1EQlVEdnpZb0o1WjNIa1lkb0txR0MxRGp4ZTdC?=
 =?utf-8?B?Tm44WGU5TjJ4OG5mcExaL0ZIc1Nlc29ISVNtdjhGNTdlMVFrYi82VVZZaU5t?=
 =?utf-8?B?OWs1Z0lnMUNubVdlRmNkL1AvclNnSGFNbFI2WWp0dFVYNy9zOTFMdUdrOGRu?=
 =?utf-8?B?UmxFTjM1QUFtT1J2STFSU2VtbUNXQktoYVFad0g5bnh3cFR1WnRYVzIreGls?=
 =?utf-8?B?THRzcE8rZ1hhc0NxSkFobGhQSjNYOTNuT0VXeG5INGxmRmVSSzBCbEgrLzZK?=
 =?utf-8?B?SnhJanhjUEVkazh0UEhzZ1FHQ0o5YVV0UFZ5bHRESVZIYmhFTEkxYW55dFgx?=
 =?utf-8?B?ODhHbEdNT1FDOXU2QjJBTXdxYTc2ZHVMMGpDc2RocmtCemtuWmRTaFlhVHFl?=
 =?utf-8?B?TE5KV1FCSTdEUWhycEhTdVR3UXgrM20xT1Vib201eEtaNjlOUm9iVnp6STdD?=
 =?utf-8?B?UmtOTUtUY3huTXU0c0xqUmRJWG94Sm84THhXY25JR3dxS0ZyVHZrVHFLcWZs?=
 =?utf-8?B?QUlRZHZJcWx1ckFzOElCMndoOWxkb1VURk9ORkxGRHhHVlphRGlRend4MHFU?=
 =?utf-8?B?UUF5R1J1bGVvdUYwS0JlQlZBVVdzODlDdXpjZUlzbUVFM0dQYWFuRHB3aXY2?=
 =?utf-8?B?UnVxVEdFQWRHRlg4SkVyVGZUeFo5Rm9oRS81dW5lNkkzYUZNZ2hzQ1hjTDNZ?=
 =?utf-8?B?WEt3RUJ0Z2Z5M2l3Y2Rib0szanRRV2FRbjJBUzZRaEk4M1pkUEwzbE95QVJU?=
 =?utf-8?B?UG43NXEzeE9hWjdRS2RFZWs1SU5Jb1VmUWQxT0d4cTY1SlhtY0NpaGlaSzhT?=
 =?utf-8?B?bjhOQnRzZDFhVGhTL2VoMnRxQVA0ejRxQVBpR2wzZzd2cEdmeUlIOWU0NmJW?=
 =?utf-8?B?dDBNcWVETTkvLzlkRmtZd1UvYkRjMVcxL0lUOHhiT1pRUVFKbWQ4RmhTbHB2?=
 =?utf-8?B?Sm5LVDVweVR2ZmdLSDR5QStpaVdTUzNFdUd5Y0E5SUR1SWpyeUlUd05UbWlw?=
 =?utf-8?B?UEhnR1FqeUNlZ2dtbTJkSXV3aUwxV2E0a2JTMVVwMm40c2x0NmZIaTVzNFlH?=
 =?utf-8?B?RlFpbVlBZmJ0N2pHNldxd25UbXpwcWg1M0txM3dMZzM2b2tnc1llSDBHM0pk?=
 =?utf-8?B?Tm9QRWFUcjg5Y2FYLzNOQVZWRmViOGZzZFgvWDRTQVlXUmFXVFBUa0MrWFVr?=
 =?utf-8?B?RjBWRGV2YlFjMjNyWjdsRGlldzdiZFcxa3d6Zm9ScEN3RTF6WnVtbGFwclgr?=
 =?utf-8?B?N3gxMUlPd2wrMitjQUZIVllzdTBnNWpTREd2akZxZkJWeERnM2xaZnlsNVlv?=
 =?utf-8?B?SHRoTTR2MlVXZ3VyUktUVkZjVExkb0RiM3QraWt3Z1pyeEc2VW9za2l6M09r?=
 =?utf-8?B?UWtjaXl2cXRGME9nMStWTkxHZk5VWUM3SmdLV3ZXV2JXaVI0d1lpd0xwZUht?=
 =?utf-8?B?d21VWkkvQTJSRDhET0FudVVVeFArTHRNQ0xES1QrcXR5ZXlWeTJSREJZbjB4?=
 =?utf-8?B?KzBxVml6a3VRb3ZlSzZGZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OUQwbldnY1M1Z29vUlEyQkNwdGFkc3lYd3JjcU5ZMVJCTkxuakRkUnk3L0d6?=
 =?utf-8?B?eUF2V0UvdEdwdzBDdG5xVnV3bHdqT2xzV2ZkQmJTWnE0NENHd2o1YVh2YlJR?=
 =?utf-8?B?TkpOdnBBUFdWdnUxZXlSWllIRWV3SmZ3b3hVU2ZYd3J2VU5wYmZSdXdnbUlt?=
 =?utf-8?B?ak5XRk9xcEcyNURQVlZtU2NhYmFjdzN1YkZTOGtLZ2ppVDdWZENVY1VNNWdW?=
 =?utf-8?B?TEx1V0ZBOThDNW9iYlNWbWhiRmNjeVNOR3pmNkxOeS9BT0ZnaTI5aDJRMjRF?=
 =?utf-8?B?ZnpwMEVZbHhmTkZ5TFBHUjdhYmVsMnZ4c3RHaHY4R2xpSTcveWlXRTVPZDZs?=
 =?utf-8?B?ZWxVMCtIMERMd0ZMRmk0VDkzdXhwM05pTXdrZ0s5cGhBZ1ZqQ29BZHMwYVVk?=
 =?utf-8?B?anJneitVQ2IzZjYyQ1l6TzNuQVBjNjU5bmZYYlB4emVLd3I1cEp0cnhFcjZ3?=
 =?utf-8?B?K2Q4ODN3NThsU2R4ak1PWlRDOWRpcmVLTXE4SmFveVRLUXB1enlFQy9mZUpS?=
 =?utf-8?B?WGVlSXYxcW1scUQ3N1p2ZTg2RFFoa0d6QjlDd0gvTlpDdWdLN0h4Wk5XUmZE?=
 =?utf-8?B?cFMzM0JVbnFCU1IxZ3lVZDNaNWxnWE1qZ2NYandIYVd4OEdnZUtEeDFjU2h6?=
 =?utf-8?B?ZmxVVjJmVjN3OGkrQ1QwY01FL2JqTVBhZXVldlVJbXNSc1Zsc3A1dkpZMTk2?=
 =?utf-8?B?dzNnejZ4aStna0JHZEw2RTRqdzBsM2wrZ21zL3FwM1ZvRm5iYllJWXJqS0xJ?=
 =?utf-8?B?NVRkeE1ickt4ZCt2OGRHUXRmTnpTaDhUcXdHdE9JdFB6RXVkT0xhd0xDMlA3?=
 =?utf-8?B?QU1hSitRZDJtTTBHQW02a2ROa1JLaEJudkQzZ1VTbHhpTjUwSUhMV1lWNEVj?=
 =?utf-8?B?SVQ2dS80eC8zTFVxaEpxbjhpcWZreEh2Z2NhMXZUU0FsQ1Z2eEhJV290TEhx?=
 =?utf-8?B?amxUM3lrUjl5eHhrU3JzUWZST0NaWERSTXltVjhOZnREWFB5QVNCei9jSlRY?=
 =?utf-8?B?T1FjSTV4NFJBK0tnT0ZGNUxjZUMzbENlZm9najB4TWxiMlFwQk9ka0dqY1dj?=
 =?utf-8?B?VlJjalhIb1FuV2JVYWppZHRJdUVTYVZET0xUYVlrNTZpc1ZJWER6OUVrSEZO?=
 =?utf-8?B?WEp5dWpJeEhXaHZyVGFSbHB2UURDeUlsL3AvSzFSbW9vWk1PNm9tRWg1Slp2?=
 =?utf-8?B?SlVWeTJLRWpZbmdDTnNQT0JBMFE0b2NNTEhEV01hUUJhSHVXSVV0VzlWbHh5?=
 =?utf-8?B?cFoxWE1xdDM1blovM3V2RncrNXRJeWowSDdqd3IzazJzaWo0eitSMkpDak5X?=
 =?utf-8?B?VytnUFFwWDkyYmZwQ2N3RU1zWHgzYmYxNXRzd3hSQXpJQmI1TVlUQnVPRlEr?=
 =?utf-8?B?Q0g3YjFWMmNpSTVHeHkvejF0UXgrbytsbHowK0sxWHhlWVVzeU85bDhlMHJl?=
 =?utf-8?B?QktJbVhoWWFKdDNkOWJoRXNrTHdvQ1U5QkVueUdJWk9VZjZrZUxoUGhiTHBM?=
 =?utf-8?B?VGNDRCtrd3FjdTRhVndXdTVXYVF2elJlUEdBdjlxTGJrdlVkSU9wcHJaZnlP?=
 =?utf-8?B?dE1wRkpnWHpLOGMxUTlhMytUbWR2ZTN3U0tPNWw0RlpZNUZRbnJSR20rSmx6?=
 =?utf-8?B?ODVxNi8zOEorN2ZRTk5zU1pEWUVua3NaWWF3S2E2a2dSeDJXTWRadzVPSmZl?=
 =?utf-8?B?cEdXYjVMb2xDaTRpTG5iQ0RDaEREK1JlQTk5MWdWRVBGRnRVS09LQzFzSlVR?=
 =?utf-8?B?WFl1Y1F1MTlwN0U0TDhLL2dnSVd2d2wraFhGcGIxSDkxaFoyNDNFY0ljMFFQ?=
 =?utf-8?B?MWphcWVnT0ZQa0hiUVpLSFlyZCtNeHF0T1U5UkpBYTdOcjV6MmV2YUg3ZFFD?=
 =?utf-8?B?WithakozOE1iSW5vNWRNY3pEYkx2YlZ5TW4wbU5KRFhGSGxzRzZoVEpDaEhV?=
 =?utf-8?B?U0tJcFBVNVlSR0plMDYxSXpXSjk4dFZ6QjlVSU9SYlEzZElNVmUwTFZVNXBp?=
 =?utf-8?B?UEhrQlovcHBGSStxZGpTTUxQN0ZkZi82WVhKVHBVK0lWVkJjVlBKMUg0ZThW?=
 =?utf-8?B?azcwd3pTSExCYXpCbXJXZ3RoaWs3c1d0UDBVMWdSNFhDMzUwaE9yeUlXUDJr?=
 =?utf-8?B?alZIa2gwT1dUY2QrVmk0aUlsenBudHJhSjBLQ1I5L1JhOWovci9vN3NCRHhR?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rKBlf22kcwrkkODY9+whAVll2joImItYVuqFVptBpu4qIp2D/Jy6T99EkR7GXmJYhw8M4OPXY3HRIKqP6K5N0TBs4CxvwRwcLBxNFclnppzcSRHrsOsuffIN/HGqUbqXu8Dqk0UqCm1d5AKMchwoWcVtvq2VEQdxJ/koKJ/ueXU37ySB3sIt/Fic3mTI+5Z2n8E13M2w0d4c7DFkJfPW8rW7gbeHIulxFq9WoKnoxOQIEagfQXaHwDWnnmlXDOhm1MPC9UgNgaQIxJftTG0O1n//+vJLJaqsDVtoCWV6lVQUhypJSGA+ccPmPg0etlU5Rc1ecFpMlMzizlp1VmseCo6tgnLQ8zRLT4ZkB1tIjKNLBMF6pbVG3G4myTmdeZvYJpaKRoY28ihjNFloyXf0OkIkCjajhpqn+Qbk90XjrYDjUkt6RRDctBVidmyoRLMkEp6K07bp/rPv86kV+bmgwa2PMNDSMCfGr+zx2CibMvb158n0ZmCnyrZ+l5x0pO5JrbLxn+dgeD4rZPRxE3qb4NLR/oYuh4G8CBq/t1TGsaH+mgzUxzK1o5PAIMPxZ6zrM/pILbDLxJkSW/79112PPlncZN3TbBEKSfvNmvwaG0Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec7eec2-d1f9-4aa2-dd78-08dca1425647
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 00:42:26.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RA4bW6vtsk3a/kQH+0O1wBAUb+6m/QJSySLSTN/CVdl1BBCVf1w4KQrADBRSTogH+6lD72WFsKY1fcnbara/7MTUmQhm53sw93+RO/c/2C4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_19,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110002
X-Proofpoint-GUID: lzzCQMUo0LDiAfNnCtcNCYopOYqywYtW
X-Proofpoint-ORIG-GUID: lzzCQMUo0LDiAfNnCtcNCYopOYqywYtW



On 7/9/24 20:24, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 8377624d76c9..e2ca9a14b643 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -423,7 +423,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
>   	sp->type = SRB_LOGOUT_CMD;
>   	sp->name = "logout";
>   	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> -			      qla2x00_async_logout_sp_done),
> +			      qla2x00_async_logout_sp_done);
>   
>   	ql_dbg(ql_dbg_disc, vha, 0x2070,
>   	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC explicit %d.\n",

Needs following fixes tag

Fixes: d4523bd6fd5d3 ("scsi: qla2xxx: Refactor asynchronous command 
initialization")

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
