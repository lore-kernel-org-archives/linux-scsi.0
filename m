Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CB738E8CA;
	Wed, 10 Jun 2026 08:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781080875; cv=fail; b=jGeczCiU7emrpJ7MVKdREoBr3pmsxvktNLE/NNtN3DpEBPLQ0p7+2QB4rhbLUbVJ2VIVUZesAH8ds9Sc80jYXGJSS5Se4MArCKgfm614u+RbQZMExOMGKYrVOcbOYZ0shaMOiyKFRMjeosuBVCXp1NWVb2Pdg1XnNIqW0ssE03M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781080875; c=relaxed/simple;
	bh=AzNbDCzTBD8YHyrE6mlZGNEx6HUC3cv3UVrH9ARJvWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qe+H8m2pwK2Rc9tyaDlLaZOinaRyYdxqWdiUWJlLGQJJidNeRtbK33Gr+JQfhlzUZ08GIpKMQ/HV04tFL1Wfq8TFa7CqChR5Glhh7c7stcR+igWlsUoZR45svtuESlyC4J9INtSX3lcc1Qe+oy8lVDOLmnLPkaysBqLepvX+Vhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oXA8Yms3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NVQ6nOEC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oXA8Yms3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NVQ6nOEC"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A6MVew2826223;
	Wed, 10 Jun 2026 08:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wvHMLpguRPdNtRlp1TZV2ILXWNKSmk83q5NQjOD0ukw=; b=
	oXA8Yms33qCNI0QQ9n/j+id8itmmphVeKKG7AqOPI4JaaiisEPNO5s8AmecSGOvx
	fHjifV/+7sxUD7ApTccsUfnV6CkDHhUz6qj1QK2Ymf8GnEtEAP6y6GqEQmf4gN6H
	PuITq8TIfzBuhoiL4UWHn95Wsra6iWv5ebZb4dorq0koy/YJ/aWVE2Xl0av1nVj7
	9+LROqkOPPubC8WTCydXvkCY/lQUeq15nlKsM9J12sb+xkyLmG9mTDq/VtAHJtDY
	494gTgQqDavcEtkwmSPJLqgQ1MhOqRdE1adyZ92igxKJ1qL43itTnNWkgJ7ctEN6
	W5PCQu/X4j/l3DPJBlBblQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emc3rp44g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 08:40:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65A8c5FI009246;
	Wed, 10 Jun 2026 08:40:55 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eq4gy0a06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 08:40:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3qagZbHNV2klpYoU2bd+wgipIBcS/B2ZbZPQYZro3mSf3jV3v5ZDBknnaxjBlaqjpcDD1ZL/TUvoupYQ8+E+FL5HVWUZbRIXWljSHBDELhxq+K4FypAM5aVCglLb6dJ7Zg/DMnPp95fQnJq7X6OaHRyef2KkZXSngJ566SQfcTjMJBzCN2kfU1iUKlhL4SjQ5pjuMOWVxx8CYwps3eK8gCQ1Xrhq93IcTFB3sSWjOL6Y2obqaaiczePMffzMkqjG+XnpzeV1kxy/FH0P2fUc4xdPOtBydRO0IxN3/JT07CKfW0efyxUKDEe6HCLXqvk5IJGcfgo+Tuaq7IW9nW5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvHMLpguRPdNtRlp1TZV2ILXWNKSmk83q5NQjOD0ukw=;
 b=wODeu7EdgraYz3vLirwdz+evlg4FKSZyEUiWhd9qt87L6yJYyFN8W2k/ODZU+ZfTdVDtPzXP7J9NAOjH4oW1ZTS+mW1kOAdc8LCtehQZ2u1qyAIPvS1NzThh3riVf6c4DOABr4yu+V+7t8Y3XentLlVx8+DNIMFWZkcgM1bWrdERQ35ratN+NkGUEgDkQboKtUh7jWHxVk6nJEAKzp2W37LECMB5Ei5evRQushJ12yChsCbhFVAUxeOBm8o6DZYn5mQR8+8CKgesP2idoSNDrwg1up0soTb/Aibx8/aG935f83+ts3UtLqK5JQ6WhszrLKlONQm3PKUupHMHHeoHnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvHMLpguRPdNtRlp1TZV2ILXWNKSmk83q5NQjOD0ukw=;
 b=NVQ6nOEC+tKPAcnlFqvPwr0VN+k5YYxv/UVzjL/RKl7e3VRofrUXEw6/p1z+m/2RGt2UKZpguQp3ulW8qO9+kJl4N7MuWGv0zhqH8abQtW74eOfRjbDXiLWnWuOVC49KJEx9XWr70g3PPPAEuxYoUNYwhlicf9ZAC2imA+BAOYQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB4926.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.11; Wed, 10 Jun
 2026 08:40:52 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 08:40:52 +0000
Message-ID: <ed8449b9-e0b5-4ce5-bc03-b0fa5238ea19@oracle.com>
Date: Wed, 10 Jun 2026 09:40:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: target: fix iSCSI ISID use-after-free in
 REGISTER AND MOVE
To: Bryam Vargas <hexlabsecurity@proton.me>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260610042245.35473-1-hexlabsecurity@proton.me>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260610042245.35473-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0013.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: fec68930-49ac-4ad6-81f7-08dec6cbfaa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	54Ga/P77MjN2Q4+r7Dk22VXXNkl9wBdXo83eNlhTMDM4IFJORp3UmOTQ5KuQB/iZ5bdO5jgmA4mhcRywl4Q781eW8NFquBM99+Y8+yoPNPd1s6UuHMJVoQhhcOYvM4Ty4PU9WmY8t9TbO6xf9h4fylumOrRJ0O0ul+p1oy2LRhwcjOtZN2QvSDTL+dmonVZgUKMqAWc7/gja3/MXbTeH/K+0T+v2PV2jFzhag6tAWRXr/ic41gJUaB6Py+xMt+NSNGyrWnntYSB+6za2RUuW/+NLrtGSXKRZk2e/iCI+wGNdSISHWV8E3I3XIWZDMfJtY/DDI/9RqTYItvBArbcxVXq9Md1AxjaHdDSB3U1ZOgA+F0L4hEgYKaau1FmjFbrIQJgRviB19/hsu9Q0r+NCc7GRfquOJi3vSwwHRNjgXNRXK8IY7JMZGCZk1ctDDhGeSILMnpWJxMQGnM2PYnJOLg+4vFrLlS8P/gIBscdY6q7+hG3wt+QvyWLkZyTCORfMn6i/4NULRDQonL3Hk4YGWdHOIyTar2W7TSJYcKccJGZHZJm2+Y1De+KYlYTcgpwk9030H1J44s2siNTTlKiifQ3av+WvECTUAS5OrI01J9vPpWduco6YsTQA0jYp2BmtF+73ahRSMSO9stHbQKUih6iOynmhwxPC5cjYc7xWN1WRkuXvc+i4/Mdh4/9VVjlF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlZ1cmx0Q1ZoNmg0bFVSaCtRNlRNSUxwNlVEb05PNC9yMHRGUS94TmZ3TWVk?=
 =?utf-8?B?dnA4a3RKa056QWdQclFpMk85YXlyVjVKV3VHWStqR1p1bzBiR1RidlV2ZzVu?=
 =?utf-8?B?S05XcjI3ck9vODVHR1VpMzZIMi9idGNBdFIrano1NVNXMFAwaVl0dnBGdlJq?=
 =?utf-8?B?QXErd1hWUnp6NWg3ZmY2TnJKTEt6Y2tTdFcvcjZpUkxKUW56RmxJM01mMnN3?=
 =?utf-8?B?eUk2Q2NXSk0rRHhmK0owRUFWcFRFZW9wQ2k3NEQ1YVlmeVhYdHdsaXYwWGpn?=
 =?utf-8?B?MllyK3JJbldoV0grNk5mODRSYlhYdExWTFdId1JBUVJENXFDNE5SU2xaWVdU?=
 =?utf-8?B?bXprT1p0N2RkY0tPS0tBYkovVFRnS3cza0FubGQ2aFVaNGhCblExMDhsZlFz?=
 =?utf-8?B?TEMyS2NobUowVXZEdVdWMDdUMjFUTTM1NEJWd3I5RzZab0ZXQU94VThnMW5I?=
 =?utf-8?B?SDRML0lBbG9OY2JTcEZrK2lPMjdqdWhYZ2NNQVdkSE9Tb1hYS3NFeVlwTEVE?=
 =?utf-8?B?N3Q2MStvNHl6VkVybFpjeWlJMGNvb2crcjF6TVpWZUFEaHVMWFdkMGhKUkFs?=
 =?utf-8?B?U3F2T3FpMlFTQUR1bFIzYW4xaE91aWYwVm9ISGdpMk9qMWxIbk1VOWI2NG9z?=
 =?utf-8?B?dU1CbHJwSGRrTnpYczA2VmhBQzIyK1B4dWJ6cTg5Ti93NG9OMHlVQzRoSUU5?=
 =?utf-8?B?OVRvZ01ucXRUakhrUTBUVW9EWW5IbWVvazZOZzRCYXZBL3dueXdBMjFnNDNo?=
 =?utf-8?B?MHVNT2NtMkZCMVZBOGhvUEQ4VS83THRpN0kwUCt1SHdFQ2dCU29rT0V1TU9L?=
 =?utf-8?B?WDJWa25vdXFUc1hvNDFyWklTZ3FHaFh3RnBIQ0U3S1BKVkJPcjJVRUdjcnhE?=
 =?utf-8?B?WHBzN0krTytwYXhSNEF6L3J2c0lFajJoM28vTGpQUEJ5Yk4zOTVmcWN0NmNZ?=
 =?utf-8?B?RjRQcWVpbWp5QWswRmV4b2pxdlRMSkZEc3g3Z0IxcDBzYk5KVnJpR2Y5bjlD?=
 =?utf-8?B?NE5nbnlpYXQwQkZPOHBrY1dNYnR4aFFZM3ByeWhnNEJ1WE4xUStvTmIzdHcv?=
 =?utf-8?B?NG1VbENlS3hWbFR4bXpXa2Z6d3lqbGlxSlp0bUczQ211UmwwMkgxclUvY3hP?=
 =?utf-8?B?dkRCR0ZqRjIyYlQyaTFPZUt2THFScmlZZ0FXTkZjU1RhQW5odGJBNFNvd3NF?=
 =?utf-8?B?RW1leGNKYzFSYUYrNUQ1S1BETUFqOEl4dFd6TnQrWlRteUU4d254eTJvNWdB?=
 =?utf-8?B?bkVrVkZON2o0SEVMUWVvZWNvQVlmcVpyRjVGMEVWTEFSMXlVZlhpeFNxOS82?=
 =?utf-8?B?dUh3ZGpEY1dHeWdVRjIyemUvSndVSFdrajViYXNkYTdZaUkyS3BFTTgrMkhB?=
 =?utf-8?B?ZUMvMGV4aGZmOGt6cEp0enRmcTlBcjZHcFFHVDU2d0c1dWg1VVN4cWVqYzFw?=
 =?utf-8?B?SnZGU3cwbUtVdEloanZFV3FTWVRSSWxMaHVOeWlIOUxiK2VqN3k5bzRKSVpS?=
 =?utf-8?B?cktxZHRVR1NVQm43WmlyVS92cUNzVVd3T0E1dlZjckFYeEFGdUJKZWVyZXdD?=
 =?utf-8?B?WFFBM3BRZGQ2empScHZ3UEgwT1RRTG9lck5GQlhWcEVWS0ZONTI4SXQxWFkx?=
 =?utf-8?B?d0JTUVFITSt6MEc3eUdKM2FVUGY4YWQvYjVzVThuL204QTFZOTFDM2p1QzdV?=
 =?utf-8?B?N0Z2QkJkdTROVkxnMVd1ZEpqb1I2NTNSRE1UekhUbHhKempHWk82MFVoNEg1?=
 =?utf-8?B?QVh5NjJkcXg2YWExT0ZmNnNqbkZOTVdWNjlGbCtHWUNtdTMzbmZtOVhBUmhs?=
 =?utf-8?B?NUN4cS9aUVZ4TkRiNXBzaFQ3eXZZUURqWTd2cy9Jcy9DYmFYdVdhMWRldWdT?=
 =?utf-8?B?QXhhRUkrcE1Idk0zTVNmbk0rZUlOV0h5ZmY0YXJVZnpvWHNDTFdjalJFU1lt?=
 =?utf-8?B?SjVCWUJsRE1aMzh5L3BFb3ZwT3RZbVVnN2wvQlRQQUs0TDNhQVZyYUJpbzhX?=
 =?utf-8?B?OGFKYzZFUXFvdzNzbWg0ZitpdDhhZ3Qxd1F5U2pCZXBuaXZFT045NVpQVmxR?=
 =?utf-8?B?UnNRd3ZMN1Q5dUUwa0pRajkwZjhwNUVxZk1qOWtQZXowYzU4WWRpWWIxcnBs?=
 =?utf-8?B?MzZWdjI4L0d6NTVqanlvbDNWQ2JDSmpqR1Q4cTdzM0JuMTQ2T0lSTmZQMTZO?=
 =?utf-8?B?aEtsbFVCdVNQUHhYbk1vR0psMlZFN3FQaW9BdjVVZ0NUOGdkZmpsWTRuWUlu?=
 =?utf-8?B?N1hLUGkyS1k5c2VwZmJ4Nk84MGU2MGRMT3EvVzRqMkxVWE04SWYyYXNxSTRR?=
 =?utf-8?B?bXk1ODlhVlFrZVdtRWRBZ20zTE1DdmFBdWp1aUNCOFQyaXVFd05mUT09?=
X-Exchange-RoutingPolicyChecked:
	CpKs6Bj+hZI429whWrqVOWXcgDtQzZi+GVH74ep3Iu9lrT7VAe40mGeS6Kkdb7GlQ7eMlbldZgha1bU2/wMKHIife8X1/1BF9FpXZMlWH3n/uGUUuPPHPvhgFBHUly9d07alimMPy5dDfxpasUiruwGFJUvKtFKtNnE04jrnbBHG6LYjIQ0tiIIlxQTyco++l83pfZSV70T82auDmihiIXlE92NTp1Wt4LBeYJ/FZq1nJzFtY31YVpxU+QqFd+VHtef5rD1GPh6eWM5fg2J9MfDe/UqTAvTEi6AhiFBp2qkkZ316jOIXJJwOdOMNjJcCh6ClCl1hVkKxukxg3bv82w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fLcIvd3WxABVP3ly325Kd+x/UG/WAnYyMyiqnH1BHFffrHUwo/l6roNEEtMN2AHYF6QYaCwo8TQrEoTvrikdzUBYDyigoxV/R884HUNZBqisgENQeAY3yrwSejsARi+SB22Qx86Q58yXz6dcKMzlqD4VsRinMqQGsxsG1e/2m7M49NOXCGaSZSEenkdUb9kbI9cejFjVF+23o0+Rl59DOyDD/XtUBBV/dA3tkow00m6xfN+IAzQL/jIuGAUfUsUduNIfKsLPgcgcmifUISgdCwS9+/vVhztrQPIBdLE/MCuL1qH0A4XQ7YqFls7+B+CC9T0NMSApgsr9/ydROffmqbgMDrpAvKQZXqEAsgveyaoCK9fwvGBbHFwekVGG1Vyb0DqaMeir+eiqFL1ituTIYgkLQrN2nOCQk5Bzj5tGoq2u8OHRgvsXNPoCeAegaLB2Db6eTtIj0uxB96NUJdEoFSkESwNWA84N24Cjy8ug5RLCfuScuBGjBEh6Q3ErYhdfScL2dZwbVTySq8SM59zLksb/mlnoazkFptZ13QC/kQQVdUa6dvCKiwDNgyST1Wi6skcJ/tiCbtf83Hv59hcSTqg4FGIcJsK/K1IzefyLBpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec68930-49ac-4ad6-81f7-08dec6cbfaa1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 08:40:52.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDvOgle4LHQJAJ4bezKrHMBIifB3THCjstbUaoGPEHN0Uio88I7wzWNp+J/QMoajU/QhsSCmbBQdtU4IkD/OfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4926
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606100081
X-Proofpoint-ORIG-GUID: SUUN7EtENSO901GH75SkQO0O0BfXpnoP
X-Authority-Analysis: v=2.4 cv=crirVV4i c=1 sm=1 tr=0 ts=6a292317 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=jAkmhrGUUGZMZoV1I7gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: SUUN7EtENSO901GH75SkQO0O0BfXpnoP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA4MSBTYWx0ZWRfX1TUIqL7Yxc4F
 RY7nGCxpd+QQ0e28br4XhoWsSt3Kaox02Cm1lXyZYZ9/Y9XXt+Mg3wJC3Fp7SUm2rdE6/bBgvUy
 0yRLkfSlrsiBZtGqAK2ilZyXkx+GgiwMXyFW3LutDw9LE5f81R1y72I4WaegL1P0gDsNOx5Nuwp
 8RhjJVGcQ/PLZ6VYtrirfrg1RonkevkW5EHbJmFw3RVkOvj39M5lOMp+p6lbQYoLmDGbqWWJm5f
 jdxvmeecdEUp2Jp4bbQBkpke0egf9CK2SuXUZ415GI6EsLJTKTo+Kua9UqdaVlQuIrMhbTTw7Ho
 7DQguzgdYhWjk70EZMbonWHJLeU7XxPIK4N9LhMr2JHLBzhkCn88jqr+LBprLmC9qX1tbNBdmmc
 /n2bL3+CmdYWbA18K3JRdz2mQ6QJYUMWymDl3Nnb+yjcpIUfqYkE72r7GX/j1Vs2thTy81QalpZ
 KzjanG4wFnRZSN2Y+2Q==

On 10/06/2026 05:22, Bryam Vargas wrote:
> core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
> parameter list with transport_kmap_data_sg() and parses the destination
> TransportID with target_parse_pr_out_transport_id(). For an iSCSI
> TransportID (FORMAT CODE 01b), iscsi_parse_pr_out_transport_id() returns
> the ISID in iport_ptr as a raw pointer into that mapped buffer.
> 
> The function then unmaps the buffer with transport_kunmap_data_sg() before
> dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
> core_scsi3_alloc_registration(). When the parameter list spans more than
> one page (PARAMETER LIST LENGTH > 4096), transport_kmap_data_sg() uses
> vmap() and transport_kunmap_data_sg() does vunmap(), so the kernel virtual
> address backing iport_ptr is torn down and every subsequent dereference is
> a use-after-free read of the unmapped region.
> 
> Keep the parameter list mapped until iport_ptr is no longer needed: drop
> the early transport_kunmap_data_sg() and unmap once on the success path,
> right before returning. The error paths already unmap through the existing
> "if (buf) transport_kunmap_data_sg(cmd)" at the out: label, which now runs
> on every post-map error exit because buf is no longer cleared early. Only
> reads of the mapping happen while spinlocks are held; the map and unmap
> calls remain outside any lock. The sibling caller
> core_scsi3_decode_spec_i_port() already uses the buffer before unmapping it
> and is left unchanged.
> 
> Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
> Cc:stable@vger.kernel.org
> Signed-off-by: Bryam Vargas<hexlabsecurity@proton.me>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>
