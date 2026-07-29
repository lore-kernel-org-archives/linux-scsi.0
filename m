Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5133A7F40;
	Wed, 29 Jul 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344202; cv=fail; b=ij3P1YbDN5RYeuwEuy7W8HCYD1lMe4uUL9cJ5wlmZjHdZwC2EJCfft+80EwWwX3rqu3+qM99VdeLadyfVIMDpUTA+yfvEOEx1GOyZ4PXYIEFMzq8P76MZrH/nPwNJ1LChpXh8xAimc4OnT4NR5ksr7rDt0VXTZ7FECVn2hLi5RM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344202; c=relaxed/simple;
	bh=1ii6FIO86ZRNemTtqCnUCDXdi7NjoLf0n4jaiuow7jM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rK1QuW0WdYqsU7Uw1ARIIDyahVHhBiEDtDXFRDqyuouZeTmii9ARP9kL9n57Dt0fWdQZiEgCa5rhKwLrzgR/XaqAN2kaxLpPjT2tKRVaykPf79ZleUvhJTdFEEHE8G0QulJsEEaHyxaJt/wLORtRHoDYpnUuqO5cuSLpVB9c7rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EYIMkrTX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iGl9nWl4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EYIMkrTX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iGl9nWl4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDU88S3007535;
	Wed, 29 Jul 2026 16:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NjqEKoLcO5ftq6XHYiv9v4oXBz9YtsGXVv+9MbgZtOk=; b=
	EYIMkrTXGoRUUrrIANim668hdvpNZB9jdgUNj2P6/i+bJgzaHUMYWDXXCJQN7rDR
	77uFDAsk+88g/TD6yuEMZBsNxyNoIPhrMzttEW1SVEs4kfOlBkMHB+qRkLTGye3t
	fLGdcjLwaxkwHMbrOp0I4cHv8iojFrJpMu1za+pqyZsFWie/n0cvWkHRI0oXOwTU
	tU0XhiqiLG2W/0XxXTRhnhQiOGbCWj0+ak267d53FEGGAgpxkQmVcR+IEd25g8pr
	+Rc3y3FVd4pddSlb/KXaWi59waUWrvWtTFryv3uNV6DrfQK8zzQivRVvMOG/sfQd
	jkjojDcGkSCXAvHOhYxQIA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym68su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 16:56:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TGjdvQ032707;
	Wed, 29 Jul 2026 16:56:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012043.outbound.protection.outlook.com [40.107.209.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6r6mwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 16:56:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARD5xcSlNnfmsj3yAqbE3BFnb+uxoPIIAijjC/8BJ7CIcmq+b4XtF5I1OqWhhbFu2HeAD6Il0vFK03E629Eqcn8KzGzjKgZ2CzLqr/L1+DUtRQ4JlS9u52Jv/OG16T3YD29OxyY+ezx6Fvp0+uKn4zJ5zY20dGX+9QY197Ox+Y98aLbeJrpgMaCueR0SErW5gpeXDEwSb5LKOnXqLCo0mpFrVabv2eeYkW+wpWvF63BFEg8ww3Ja440t6eWZkc2KpPjPT1wBqlasVwlsjDoiIqclj4Hf5XiB1Pu3uvtvsNA2Kh/sHbaT6uurxfQB4H32mvHYw3knXGcr9LzXNFNM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjqEKoLcO5ftq6XHYiv9v4oXBz9YtsGXVv+9MbgZtOk=;
 b=OWtl808s34O54gGb/C/y6mRYmKHJdjzPn/A5sfllzTxnBWdFTDA4Xzlg7mPD342/LccDFf+q1jXV/MIUQoAxoBARxk9WoEmpgBaup5BktZzeBW+Mrnsr97izI+FaF64ovdSjt5/dMSP4GvpLxcHKru7Yt+3eloAxWoV22aKxvBjUSe0aWvBgZVZPZXNvx4r5EPP+fjBpM4KNTXw5ndbSXyzT6j3lM5SgmpnJFotZ7WSP6DcZgDsfNW+gIJvQI86xgAZh99QRHwFYCYAT2CdysL6w2QlDAxbQPAUNZFuRHq7/lZ1XAI4eZ/Xgko/ykO0xsv0YypvCZn6F/Z0zMA3Ucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjqEKoLcO5ftq6XHYiv9v4oXBz9YtsGXVv+9MbgZtOk=;
 b=iGl9nWl4+reBRm0d8jocsw1pP+LwdlPfhhRGbinqh24GgLZi/BOTKvZzWwmlYnPCOioNdDqRW6AcAzjs1PCGpOJ5tEPDHrlueIzU8S/EFEv2WEoKGqYs9VGYcRaiXdF6w02hUoVbDGop5mx2smL0xRjrcX0INV9gUFlbfIMxwZg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 16:56:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 16:56:28 +0000
Message-ID: <070c41bd-5531-4f4a-a00f-1c2f5135e369@oracle.com>
Date: Wed, 29 Jul 2026 17:56:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/27] scsi-multipath: add delayed disk removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-22-john.g.garry@oracle.com>
 <20260729162659.7D77F1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729162659.7D77F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0011.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: bfc5dc04-ff35-4887-655e-08deed925547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|56012099006|5023799004|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	8M2nYzio/KpwASvHmrcyKG3Pfje0P6Q71K3gLuVwaU5cDd6MkvZ9q7slrZiUTAqX/3rQkitIylrmjdKLYs2ENZ0rZ3Ln+8dQGdgsEU8uoaSbVAABl6z/SzTmgmXDzRak9BB9oKEhYSzXbfccE5mGdQCmya+SVqjWSOJ0zrU3uYL3snU9zl1U6fax8GLMulevkfECdlHRCKRbY9N0lRyNSI7cJr4wDE1mioLSFoF0/p4zsVOsogYibuw6GuS0ZlDoJeHvqVCcnEM8rlsneXILzGAWp4Sp0D8bRQibys8OiVEDCBFFqHb9htX94LsEyyVXXg3McCN4R5d16kdwH8lZCEn5hejyubrLSstT5iAL5Iv8VtRdi/WyMG3jnbc7D2rbA/vW34dLUr3400oDvID48qOxa3jkVzFkrNgWbjJuybPGBPQ+dtzQEV9sgwTV9yHDVFtzsMPqso3Rw1n6YcskPJJAeqPnUxa/NhF2jMkqTN2CU5DnRK85WT0stLW/7D5ifoRTICkzUpNacaiNPQmY6paRySXGdEudaSjV+QuoSsjBq4FhxU6eoHzGjXhTwEtfpZPwN7bbu4uX+VmTgOHkO/A7Wj/rEMUwFMW4ZnymA1bubc4z0xiW37Ubtc3J0Cts/aHJj41GhhNCgj40bx+lMfbULEXdri0mEU10TIlG8kM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?am1MaXhCQm1RbFF2N1BWQ3hIbUVvRkowTVRBSWI1b2Y3azdQRGMyWlY4VzI4?=
 =?utf-8?B?WXlqSUpZbWx4aEZ6ZEZZOGt2TGR3UDhCbkFJMVl5ZS9nWTh1dis1OXJCanRS?=
 =?utf-8?B?TDNtTlFEWnN3SUJTOFJHTnJUS0dJN0gvdk1CNXR2MlJta2haay9tZnozUzQ5?=
 =?utf-8?B?RnhNQ0htcDV5TkQwREdwVVp3SmgrMXRDSkFiQytnOWNSVkFpR3loZ2hadEla?=
 =?utf-8?B?TUhHNXNoM1FTVHZGWTdpWFFCR05zWS93b2xjRnM5RmlGTkoyaWlQZ2xGbjRG?=
 =?utf-8?B?L1BHZ2E2VFhvNk1lUjBXV3VtRElrZnZhQ1ZUeDJCVXJQMXpMbkg3dXBGRHpk?=
 =?utf-8?B?MzNRUnBrQWFJL3JMT2VXQnZ4eFMwK2RzUW1iRTZLbVk3SEpZOXI4WjU5QTJC?=
 =?utf-8?B?L1BmK2Y1YnJQNW84TGFzdTNuQ0tBaFAxbjh4eUFBbTM2R3ZBV1J3U2haL1B0?=
 =?utf-8?B?bDJUZndLZVJVOUtjdnpJdmdiZ0x4eUVqSk15VzY1STh0Vi9rRHFZMlgyUnVz?=
 =?utf-8?B?N3lDVDQ4Z1poQ0hQNm11a3lrYzZpWVRtRExoblo3ZWRhSkVSbWI4bWxGc0F3?=
 =?utf-8?B?N2FGRHNJeU8wUnA4eGh1YlY0MW9KZ0ZiS1kwWnp4U01hcVY3UzVUU0RFYmNG?=
 =?utf-8?B?ZE9qM3IvU0tZc0h5Ri9DSERTOVpOZXhJbUxadnJ1SkdYeEhGWHk3SGMyT1FI?=
 =?utf-8?B?UFJUUmwvMDJjNXZDUlJ0OGVsV2lORGc5MCtPOFVvQUhKQnN1YTVybG1EZ0d2?=
 =?utf-8?B?a3NuWGd1TVVReUwremV4N2lkaTlUeXF1bjNGckhhN0pTQ041VWpoTFphVkpw?=
 =?utf-8?B?bmFHQnFzNC9iVmZZSjVFQjMyb01JSmFoeVFFN3VRQkdic014aHVvVnA5dWhD?=
 =?utf-8?B?L3QrOHJSMktUN1NOU0JzS3BCa2pTdFBzcGFmRmpCbXhKOHhZdEhwUjl0Z0xu?=
 =?utf-8?B?S2dXdGtqR2t2aXR4bU43dFpWZ2FySXJwb3BPM1hnYkJGZ1pBM2NabGsrNmJC?=
 =?utf-8?B?UmVFTHdGcWpYbXRaa3QvR0wwL3VFd2dOTUpuQ0hrbzc4alBwQ0svenphWmEw?=
 =?utf-8?B?bWRtOVpBRFlMbEViK1BkY2xzemx4dU5GelczMm1yMUZSd1o5RVRqemxCMWlF?=
 =?utf-8?B?QmltUWVLbko0QW55VVplZXF4cFpvalZzdU1SV0QvMXBQbUVRR09zWXNTMWNl?=
 =?utf-8?B?Vkx5TFh5V3dDZFpxNi9hREM0d2U2NmgveGc0MUZvV2hLL3FUUG00OFVtVXJO?=
 =?utf-8?B?bkVZRHJ0N2F5TS91TVNMSTNsQ1lyWHZDV2kwY3dXQlYyajBuNysxWVN5YktX?=
 =?utf-8?B?cFE4VFZRV1ZtUlROcXR3cnVXQytEdnErMFdOWWpJVkVRbTdKMzJYY2lXQXZv?=
 =?utf-8?B?bk1JUDJGam4zbGNlQ0xZTG45NGVTWGNQVUM3RzU2bERDd2xpckNtNGxPZ01R?=
 =?utf-8?B?eFJaeG5iQ2Q3aitJUGJRQitEcVhVSWFOYndrak93UWord2tqanFON1ArL2cw?=
 =?utf-8?B?MEw0bCtWK21zYTR0dFJLM1A3SlQ5R2MzbDhJd1F3d0gxK0IyY0pUSXFQRnRE?=
 =?utf-8?B?azNVcW51VFBqaWtpaGdDRHNaYnUzV0I2aStHWWNhdGc0MEh4dEVVNlJIYlFw?=
 =?utf-8?B?WmNnT0V3aHJCaHh1c1FVZjgraXR2VEdvZGdQZDBUTXlJT1NtRGNKK2IzSGVz?=
 =?utf-8?B?NjBoQW4yTHJhcktTMVNWNmdsRHdyYllhTWVsbXZIRDJ6UElVdzZDSzRIR08x?=
 =?utf-8?B?ZTI4MWxZVmZRdnQ2citrMG41N1M2ek5EcGprUlpSZW9iTEVLUGNUMVhkMUpB?=
 =?utf-8?B?Rnl3WkRSYlZ0cGgxZzBsTytJMjByVHlRc1lZKy9ndlBFcDNNTk02Nnk1YWth?=
 =?utf-8?B?K2U3WHQ3VnVsODBmMHFKQ2kwWkpBaVBFUDhqUkVpbVRqdTNneXhucC9mVGcy?=
 =?utf-8?B?UHd2ZHpBWit1RVZBSEhxL0ZMQzFoNzJidk54WTlpSFVwVWwvWVoyZ0xGZmRo?=
 =?utf-8?B?QTRrYmt2UE8rS3N4b1Avd0JyT1lLNDRobHdXdVZTUzRVNUZpSGFUQ2NQMU03?=
 =?utf-8?B?Rm1OZnBpaWtnUUF5QUM2RUFKNjNrYzBLR2Z6dGwrYzV6aGpKNndXVUdEb054?=
 =?utf-8?B?TzltWnU1ZFZIQVRaT2oveStQaE9OaFNUUSsvS0thdjNiZ1Z6cE52Nml0TEJV?=
 =?utf-8?B?dkF5cmltRWxRdVFGOVk3emdRdmx0MHU4TCtoWjJNaWh1VExSNnE3YWxvQnR1?=
 =?utf-8?B?QXp4MWVFVy9nclk3b3dXdlhCNnJxemliaXNlTlphRFFSL2FCL3ZtbG5CcHRL?=
 =?utf-8?B?ZU1uK1hKb3VzaTJyaVdHd3hlQm1YaXNWUG9MZmE2UEJBcHA4YjJPQXBWOGZl?=
 =?utf-8?Q?FRBOromN9TbG1V0Y=3D?=
X-Exchange-RoutingPolicyChecked:
	MoSH+vGiyWU9maIhCf1/dziqB6QoP6ccbgEZx1CqDl+j8XYHYCjk2EjbkThO7CBS1yL1GKub6fliNAxcP6zJ9tCl8jutktWuq0Q2jq/Yrdngh1svAfdUjnMFMhQWSB+h3GHTG2ZYAhzzr9nKrpLDpM2A6suowyHwsZOSvn6y1mIzWkSsGI2yaHHvy0+vZwHnX0QET4KI/Ar22FEXsDjWmaJ2yzRj4nVk2TMun9WUdd4v7C+aYH23y6k+GGoAH93vfWLFCbKQKadWTQ4E28vsxuCW19ryNLW7btsTPHlpi9hGa9wN0xICXtYn+TVDrfFX7IXMGW7izsXUA5b3CyLbog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WYdK7Ma/IjQJo3BYNbdmwdgw9TOd1Re74Dv5PjpWScbI1R3v3jrkaSKhUizzyIrec3vK8t2uVNHX9F+rAJIaWDjlBFaPMpb5AWaVmZpYiuwq8UboV/WxX5bOcQ3+6zSx33aWC5rppn/wPGW7ygv8GzDTgE6+qbpMgXtpMdAzlcZD5r+GuGQr5k5IBOJq/OyqIH6yMvt5ZEmc4vvomviQNgUmYrIBB6SE0LKJgQuOcS+07GFg/TyEE6mncdZ393lGBsUDWzrl5KC/IM0bWlY3rXjWIUEAm1UEXKUZzL+BUUNl0c+1CpJxuQ6Ptj3qT/8GcoWtdixfTpAcwzB+ulEAPKZEijhiTYLGI97hsLzroq8teti1bOPe31CtY+iPulm3W1WvktgpR/oSP4e6V4i7dg/6rAefQshtF2EQ8MiQvOc98iJdmpoi6CeP4PTuMLe3UqoKSRuSx2JtG2TB9qZW4xJ5BVA/zvsajwoKi1PACTUPgZAJnZ7FsCwTeLzNCPC8ZyOoFtRqeIJvi/KFzu1IpDloIb6t6p0jNoJmV8j2Jac2ffIPeZAyHw0Y3vyeGACljpD/RmD6QLuv7h0HP0sfJBvCcStbWNI4oQL66gWcaVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc5dc04-ff35-4887-655e-08deed925547
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 16:56:28.7787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYErXLkoYZ1VdAzo4P/p9vr3xYPIKQ51OAoaXKoFW3fZg2AW/M2W4BWOXCHC+n87INrsWeJjihmYec0ANKA/3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290132
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfXxLh7047CEsC9
 1qqVrDKXScYLNwRo5/kJ8H5GNNPaqd5mfP3qpfbZDpBqKwAyBRErcqd97po3Pnq3teDyhPHa8l9
 yZsqhm97EvaOSPEydxit8bUsyj1jfzIk1tj89wQDZfmU+wh2odHc
X-Proofpoint-ORIG-GUID: L-wbxqoXXvM-TlZ-lBaI6hj_JZUnp1Zk
X-Proofpoint-GUID: L-wbxqoXXvM-TlZ-lBaI6hj_JZUnp1Zk
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6a30c4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QixiqmOvm6HCq19NiswA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfX/rf/2oANYrVi
 IeY2CVxtcOUsXx6bgrN3/sxyJkpOrd2Ce9HxRAnvqXB6T3Hg0eN9nVD4y13C3ketvzJBVGgiMQt
 wBO0kjVMkhfyVlnhewXukR1VVoxlidGJ8B+4ZZ6lc84tBRRQZUMOIXc77tu05lG5FH5M8WcJwDa
 WsyvOQqbeL1yj0KCiPoxjNyHTUyGmzLzcNZGjPudHwjVURzG++JPJ2BLokPkJ3qj6SsDQOHB9bs
 RZyt9BvAwU4kvVD9l7hbLCieIkWCtP/V0BKuYxmMrWlwGuYRzcHAFU090ImrX68tCmC+vcRSy/Q
 DlPRUxIj8zdeNEOag0nOpYoSTZoBluzHthFS/O3iKGDRYRtTb8XDKv40LxN/h7mPVpLa3ErAb0W
 jEtiRYutbZODQb2lZFczeOUD7Woob1JJHimUx5k5nHgycDJm4uSQbfEEB5S6G+NBlniQmVAoUBF
 lZL4e+t8ShfSITsrk7o6AviEBs2R77q8KyaOe9h0=

On 29/07/2026 17:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The unchecked return value of `scsi_mpath_get_head()` in `scsi_mpath_remove_head_work()` can lead to a Use-After-Free (UAF) and double-free.
> --
> 
> --- Patch [21]: [PATCH v6 21/27] scsi-multipath: add delayed disk removal support ---
> commit 10f5e133107a91a4b4df48e21559fe51a6b82a5e
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: add delayed disk removal support
> 
> This commit adds core code support for delayed disk removal, introducing a
> worker function that iterates over the scsi_bus_type to invoke a newly
> added mpath_remove_head callback. It also attempts to manage reference
> counting for scsi_mpath_head during this removal process.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 0adc5adb4b234..a42e20d33e422 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -367,7 +367,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
>> +
>> +	/*
>> +	 * scsi_mpath_remove_head_drv() could drop the final reference to
>> +	 * scsi_mpath_head, meaning that we pass a free'd pointer further
>> +	 * drivers - take a reference so that won't happen.
>> +	 */
>> +	scsi_mpath_get_head(scsi_mpath_head);
>> +	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
>> +		scsi_mpath_remove_head_drv);
>> +	scsi_mpath_put_head(scsi_mpath_head);
>> +}
> 
> [Severity: High]
> Can ignoring the return value of scsi_mpath_get_head() cause a use-after-free
> regression?

It should not fail as we already must have a reference

> 
> Looking at scsi_mpath_get_head(), it uses kref_get_unless_zero() which can
> fail and return -ENXIO. If the reference count drops to zero concurrently
> just before scsi_mpath_get_head() is called, the acquisition will fail.
> 
> By proceeding unconditionally when it fails, bus_for_each_drv() could
> operate on an already freed scsi_mpath_head pointer.
> 
> Furthermore, scsi_mpath_put_head() would then invoke kref_put() on an
> object that had a zero reference count, causing a double-free regression.
> 
> Should this code check the return value of scsi_mpath_get_head() and exit
> early if the reference could not be acquired?
> 

