Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240861F4C87;
	Wed, 23 Jul 2025 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753287727; cv=fail; b=Goz+9ZaANMu13yowDsNZRrASkbL4p2sqty7Vx7Xsj3todDhMfHHEIVtNhm/JZBaLRj7St+voxBioOuFQ+Nw1kcTn2/orVjvvJnvWurj9YNxHqcirvL359gqKbBhSIJlFN2ZuM6HyUokiQvH0ExE4utJ/OBQDT62ZAiPwl2NUt3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753287727; c=relaxed/simple;
	bh=t8X9YF+sBy0YlWr/QJIfD1wvevAHonqGkcUeL5/l5MY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VWnlOBGXPU8nx5W34fmjULLeY0K4itxGBfoOKs1JA4AhHoZlgToF4eXIZSXUmVFPLAz0QJnS7CZMLh8hPTEP3/4YoCALBapd7mMezE1TxwSIRD1tXmeRkO0yfvakNBnMZiB7TBXaiCch9o/DGNwwdPP/ijGFEFIgCF1pbFwAo60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g98XazTT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wmr6AWdc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g98XazTT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wmr6AWdc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NG09VF023835;
	Wed, 23 Jul 2025 16:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PB4fDp85q+cNAOA5bO6VYKI+HPDjVwIoaVfM9ecR7zk=; b=
	g98XazTTwAQdcEz6rgNf58C7nmfoDhTbtoKE0kxwLwJg82+HiCrzOnTGbmYrkq9W
	LzWygElQNgVIiDh8x+k8Wy8KJhSdp3gMP8OXFpln47lSWXUdMfzksiHAnv9gIqUz
	UpgQJ6Rul05zdi9cfbXHTBY/e7WNwh+Vc4HF0KDfEV82gYQobrwhVO+RPD3M9rgk
	fHYcCqWePh1blDZHxf13AE0KoD8c7lwyjnkJkert4OIhyl8y5Fza4g9zFRFK+WGf
	U3+Dok9y0gQZGdvZnGuiKEnvW27OQajV29wWvS2Bv6mefUiui/dRGzgB5wMI2mpz
	I+7749cf/WuVwAwRYoPzHw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2fw3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 16:22:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NF8Q9j037678;
	Wed, 23 Jul 2025 16:22:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tau4se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 16:22:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ED7Mn53m+0nRu3yW9zLyVFjBNBzdhKB0CWe632co6E2/102auSH21PJacH7WpyoZOPqC7nh79ZWjuzx1JdJUkov29Q3ysT7ALlWo91tbaN5AaLMA0j74biQpo8wD5MqnHJih45Dw9X886wFP+ObEdA3ZMPLKXEpHdfHz2t+ae5NIox06eI2dSv6G9CmbMcOHwl1X3ijXGWQtXJb1iyj3/SVb7jHk1cKvTC0CZ4QFGoglqiBSHxldcC6sDmg95j4CABHa2nJ/m3nTpxcfEA0FXwRe6kK4GKlKqsv7ywd1c0tf+aXBceYVsqffzn1g3W9VIjMV/ZcivNN604cA8nPvdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB4fDp85q+cNAOA5bO6VYKI+HPDjVwIoaVfM9ecR7zk=;
 b=lKc3MvhX+gJ4PQRxzH8u+6eVS/ZmCFzuJ0iigEu4W0LhIS1G8+4EOei0eK37SRVEaKv1vLhJyzoF45xsk6gI5uiMF1Ur4ajM6VJkE6oFei8D6aTJSIzQplrlpOH9Llir8aFkOiuOxCWjCe9wxtuHe5RzOItLVcX0C7tBQqZ5Y8l++BbgMElKKpdbCWSBF8gcgC9yM7HVI1+Z+0XolfjDE8BUF4sWgH6yQo51i4HpZ+jbE+nMe6D7f89bntuxdlKziQ3LIE3qxgtPDFWVgvxrU4Je0iUAkIY0uEgBaJv2XDBqdYucO4Mqg44nYxXcLV2mwrJWQaFeTz68C0Kodz6c2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB4fDp85q+cNAOA5bO6VYKI+HPDjVwIoaVfM9ecR7zk=;
 b=wmr6AWdclxIgL+v2dPc/TefRdz/GYlSmI6blw/xao5idKzdWNfIpZ5JASdkSNN+9Rf6DrrewNaFBM833YFTF+pX+8++NPA1LE4ur8INVNN0D2l0WRydADw8imB7KIactfZfN2Jgg6p/cmElobsj3AZLIlj+9QZ4BsCVl7dTNsEo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH3PR10MB8213.namprd10.prod.outlook.com (2603:10b6:610:1f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 16:22:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 16:22:01 +0000
Message-ID: <f78e4c94-ddc4-48dd-8d4b-182566e9234e@oracle.com>
Date: Wed, 23 Jul 2025 17:21:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: michael.christie@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
 <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
 <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
 <481bcab0-7bc0-40f1-9384-7d3c20ccc22c@oracle.com>
 <f6efa59c-680f-43a4-b477-0a3791f06f2e@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f6efa59c-680f-43a4-b477-0a3791f06f2e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH3PR10MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 103c7f05-6891-4bb7-37b7-08ddca050da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1ptY1J0SVo3NE9aN2FvbGRYaXJjT3Y1QndMNlNKc1BLR1dIVnptaW11Lzhp?=
 =?utf-8?B?akJvYlpjYTg0MXpKM0FxMzBBbFNxWTdIbnhKOS83UGZEQy9GQWlVNFVENnM0?=
 =?utf-8?B?SC9MVzZsR1pTbzRPZ2xiMytzQW5oN2dUWk1SWG41eTFaTXZ0dUJON0RlR2V2?=
 =?utf-8?B?SDZiM09XMGJRa2dtM1RnTnVtVlVDZnArNUJZY0xzWFU2dFVvMDRVTUt6eWZP?=
 =?utf-8?B?N2tNQm5sMFZDNW4xdWhxQi9IT2k0aEQ5ZmxSYXNPNWNGalhXZ2RoWlczLzNR?=
 =?utf-8?B?VDhkaTFwa2Z0T0xacHJvTXJES1pKV0lpbENYc05CSkMzV0ZPM3VJckpnVEpj?=
 =?utf-8?B?QmMxYXFabEM5RjVwNDQvdDd5NGVLdDUyVnlDUVcySTlrMXJGN294eXZrSlBh?=
 =?utf-8?B?WFhCNWxyN1ViQjlSeEY0a1A0ckJHZld0UHlRV2tKbUtyeWI3aWpZOW9DTFJN?=
 =?utf-8?B?Q3AvT1FUVEJEb3Rkb2ozSXJaQWJiNFdxakFhelhlRmZmREJ2bWdyN2p2SUJx?=
 =?utf-8?B?WXRyRUhJZVhveXdTcGNsNEJPWlUwSHhOSGVBeTh4Snhpd25BOThrVzBua2hs?=
 =?utf-8?B?TTFJa2kvc2FaaDBzcGpTRkxhajR4NWNCOEt4K2JHcUhRa09xYmE1N0dIcmxH?=
 =?utf-8?B?WXpQYWxoVEg2WVB5V1Zmb0k2WGdyVkRoNGxhU3QyWHNkVGJjNFNGZ3JmaDlt?=
 =?utf-8?B?V0h3TXNlU0poODkzWExMYlg4OU0xb1QveWhJSlMwaS9Od0ltMnluNTY4cVBz?=
 =?utf-8?B?QVpEdUFwR3oxdERBQURpZUlqYjQvS2lTTTZUQVdxOUZjZzJIMnpxbmJ1ejhj?=
 =?utf-8?B?NENBNGNpT2dpYUNINnFGdm0vZ3JMMG1Hejg1Mmc5S3dMUGJEOUM2MnNhUGR5?=
 =?utf-8?B?ZFZhbCtTYy9Bb3JxTy9WQjNIYnJidE02WmxrTkd1SDFSVUxwZjRjKzRjdVlw?=
 =?utf-8?B?dGF0dlVuWUVTZTd5MXdIeHBaYXo2K3JmM2xhRUdJZXpPczhOQVVGYWt1VC9o?=
 =?utf-8?B?cVcwTTg5UkkvQ3BPWWpDZnM0UG5Lb3VmNEtVUWxkQjBqUHFVOGhIZHlrTlFU?=
 =?utf-8?B?MzNuR21SM0d4VUdUMUx4RjZqSlcwRkRTRFZYVHp5RkxIbDhudS9zaWtwSko4?=
 =?utf-8?B?TmJPa3ZqWjJjcjI0SWl6T2VPN3RIcGZidWxpRERYdzRoc0o0UXJwcGVQN3lz?=
 =?utf-8?B?K041UE1pTk45SlNnM0pxeGRSNGdOeUpaZjZ0bzBFdTZMZHFySXZuempIK2NO?=
 =?utf-8?B?RDluaDFOS2pCU1lENWV6b3dyZVdBQXFFaFBkcTZCUkNVRFpaTkFmVHpSNXd1?=
 =?utf-8?B?eGx2b25VRGlCZ2MvNzNLMDZXM1FYUDlYaC9oQ3BlSmlEdm5xaXRUTnA2bjRt?=
 =?utf-8?B?a1ZpYU9pNjBmQk9kQmlXWUc3YzFIMi9JRzlUVGJYZmUreUJKdGozK2xCQWpF?=
 =?utf-8?B?NWdUZFIyQnFmK05wVXpsQWNLRFRwdHM0eXhTWWV3ZDI2bGRnYVdYTHZJL3p2?=
 =?utf-8?B?dzQ5c1dDMmtGTEdaVXo3bFVlL3UvdldJb1lIMjUxRmZuTEFTcGFjU3p4dEZF?=
 =?utf-8?B?S0NCcytTVVhzK24xR1JDaEFMUnFEVGhZWTlaL3pQZ05zWnR5UVVLTWJhUUYy?=
 =?utf-8?B?SU0xd20rZFkrSUJLYlRTaEkza0h4SDJFaTcrN3hzTS9mSTlIZmRaN21xQWgr?=
 =?utf-8?B?SzNkdE15RHgzdFljbEloZFJOTy9MM09BQ1VLQ3ZSaG5kR1ZqMDd4SzlnaXdu?=
 =?utf-8?B?TCtVRTdzS1hUMlZPM0pTYkxONGdWc2U2YTlrS3gzOGM4SUFrSFpwd1Mrc1k4?=
 =?utf-8?B?VURkVkphME8raDVUdjBBb2FoQmRTMS8xS0doMFUvd0dKdXduSFBJYkZtNGhz?=
 =?utf-8?B?amx3SDI5aCtMR3NzejJycFVPM1doZ0pRVzdWYWpJRlo2Y3pVTGJBRTNBZ1FT?=
 =?utf-8?Q?q6DvaYYDGJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXF1MVhHYkZjOGpJN1UrajBhSjllS2FTVkxGTlkyRCtvZUg4NGV4bEt3Yjl3?=
 =?utf-8?B?bDFHejhvRXdlMTlNTU80cFFjM1graE1qZU9IUElLS0I4cWZPTnNXMGpreGhu?=
 =?utf-8?B?eU9PRzJuenE0V1J0SHk2R2NReE1lL3dad0NPdmljYUhyam1zbkFBci8rMHZy?=
 =?utf-8?B?VkU1aUVDLzRvVnRjSjZpaGJmK2NUTWcrb1JveFdQeW9EQm9xeUhuRlJ3QTdu?=
 =?utf-8?B?em80U3A3Mjl5WWVESG4rclRJeE81TzhJbjZsUzZyUkFIbWlDems4dU50cFFu?=
 =?utf-8?B?U0F1Ly9nTnlVUkc1TGZTeWF4MTJ6UXh0dWI4WmE3SVg0MUJidWdZbzltSHpX?=
 =?utf-8?B?NGtWMlJyUVJ6WEZBd2ZCRzIxd2dXeERRdGUzeTUxZ3FROXE1bGcyYzNNbVV0?=
 =?utf-8?B?amNJZ1VNQTJ5dzZHNDZLRWdYYXBjWWlFWUx2Mnd4dUZDa01nRThMVm8xNUhG?=
 =?utf-8?B?N0MzZ2NweGpuYUVMK0c5NDdSRENnY0xMU2lzUTZtNFRkTGdIc2dzZW5qU0R4?=
 =?utf-8?B?dE1uQXB1S3RyM2FweWtPQzk2cVQ4U3dJeFl3YnFOTnk0N3Z0VkV6cU9ydWNh?=
 =?utf-8?B?cUlHUnlKb0gremYwdFpYR1pHMDNuQjJIS0xVQmVQMHROenBHY3A3U2Z4T3lF?=
 =?utf-8?B?SllkZFBtRmpiK3pmY0xrT09ZN2hGSEVjTlF4WVZLbUNUL0ZoNVM5bGNRc2dy?=
 =?utf-8?B?U3JKOU9tV1kxSkRDWnIxb2xQNDJ4d09rZ0ZxbnNXUzRDNCtMTjg3MXVuSDJv?=
 =?utf-8?B?d1VKSWRVVmdJYmFYME41VnJvSXIxMGdXMWRPcE0reEVWZ2wwT09XVWhja3cx?=
 =?utf-8?B?ZGRDT0IraE9XMWlBQlBRemh2ZkRPYnJZMTBGb2ZERW1WSDVEVmVGTGdDOWdQ?=
 =?utf-8?B?QUxxTEFXVXhpTEx4L21oclU4UWVzRWREcXJKRndjRk82RVJUbzNxTENEcWM2?=
 =?utf-8?B?M0JYb2w0dUdQMWFlbWFpRnFwUHZWNm1XS09aaHE3NXpjVGtXWkpPQ3hSS2Rk?=
 =?utf-8?B?Y0FaWmFBOXNueDZHdForbzZTc1Vpa2lOSDcxRmZ3d0l6Rk01emtoYmpRdm8w?=
 =?utf-8?B?cW5qSHMwRXJ0ejZnTzgwVEROOHJlc0hSeFVsY01TRmRObUVPN2hNdWc3aFU5?=
 =?utf-8?B?blZIa3dUUXc3VlZTTTRqNDYybnpZZzRvRyt4Ym1SVkowempVYTFtNy82QTQ4?=
 =?utf-8?B?MDFWOXJycFVmS0VVU3hVUWxjcFJmdDg0L3JtcTBCWW4vN0VBbkpqN2ZUMThL?=
 =?utf-8?B?cm9GY1ZwN0RWOVBxcDliWC9VaEZ5OXFNUlhFK3NUcUdCUUNaZjBnUllmSmlT?=
 =?utf-8?B?OTU1WXhGLzNVS3kxSHZ3TWt3WDJGRGIwTFdDVVdsM1lTbjkxdzRvd21sbzdD?=
 =?utf-8?B?L1R2d3F0R1J4aHE4MUN0ZDhwaWIyNlVYVnl5ZW42VjlnTS91UGpTK1k4ZXVV?=
 =?utf-8?B?VjJxMXljN2s0bmVHaFZXS3dpdDQ3cStScEFsQWxOcDJwN2JuQXJuZkdFempE?=
 =?utf-8?B?S0grSk43M2VBVC9HWGExejJ0VEZLT0RxZW5LcWd2WlVIUU1qQnRmL1ZPSE0w?=
 =?utf-8?B?Rm9za2lQWmk2SzdEb2VTTm9qYWxVQVo5SERkWHIzb0JtN1M1WHpka0pxSHJt?=
 =?utf-8?B?dmY2TmVZZUlUV0RPc0wwOUFhMk1GTkhMajVWcTJhRmJJM21JR3NPaEs4M1NB?=
 =?utf-8?B?bVNGeTk4MzBpUzd2WkhjejZzR200aUlxd050bFE5QUtwQlphVGowdUhsZVRJ?=
 =?utf-8?B?cFcrQ2tlZitBYVo1WTl2N0ZSVmFzMm5YM3RGQ3M4aVdFbEd4dncrSWJEdUNW?=
 =?utf-8?B?Tkd1bVBlS2czRGJiQUQ4cFpkMG01dUVFRTJjMno0elVrL2pkZDliNTZad3Rw?=
 =?utf-8?B?eTYySmZybFNPWTdzd1NueFc5QUV0aVo2alJlSnNadzZWWVE1VHBtaTN0d0lP?=
 =?utf-8?B?WkRIWVI2MEt5bXhzL1RkNm8ybHhNR1ZTVytMN2h1V0tjRXI5Z2tlSllncit6?=
 =?utf-8?B?Um5lbzJJYktwY2FFZVkrdmNHNHo1UjNhREhBdEpUaFF5UmswZjdhV2pzSXZ0?=
 =?utf-8?B?VHlyakVBbHNJTmFaTWovRk1HQTh3MUFCZzlQdHpYNVd4a0xIWVZCcnd2S3lY?=
 =?utf-8?Q?YyBmlyLJ7eBOpme5tR3WKjUJi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wt1MshsfQ7GZNfcIMqrlPKtv9FOtpuveTIT08yoTzxjCbWFBe24PD6VTWf1DTwXyxdEGVY8qxuynsaLmzTRnWb1NxZ5aiGroc9c6aY9k+QPVZRgbbchecu/XcRvqBIsntU4ke7vFMMToi7lp3hBVQvAaiGMbA13NmQ6GOxudQpUvOEIBF1kC1ThDts2x3Uq4pObXZauaU8DRrz7Ux6wIORMO1AvRhjFOERV11TDJ7XUnvV+OgBMjhspt1iWHSk+vcDUw75MQBM1EHPhHl66D1EcVR5ajdi8/JknTYhHyGBk4N45XJIGQxa35F166UPhdAsot8n6Y9KjejPdSh1L3V+vBLADHQgecn7TdNwjMWEBZDYcGhHlnRkLEyWxSJlP2fmcPjIbr+VDl88tIpgytmomxxGs+5ahJJM2Ust56cG9Z9eoMq5rcbS1B+ucjcONAq0MGjZQHz90C9iLgtMPyYOmpjdyLkVbT2zG+b7tmaIniFaP9c3mQkOzpNiDoQJz0xW8NNWMD7WDGd2lmG+3XwyYLC7Ud2xlnl2xtiLqiFGO9rMOWY0WTWVFzcTIDbgg0QXu3FvpyU3LIzQiotEyHtPM2++m2sVbHTNwuw5vk0PI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103c7f05-6891-4bb7-37b7-08ddca050da0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 16:22:01.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tg0I/eUJe74iwc7+Z0t2CSwiDR3FwEcmJelVGPYL2yndKdEd2T01X1Rzg9GQrXRBzIkb6gQl8Vxskh3Gr7qofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB8213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230141
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=68810c2b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=qIUsGerRfGVWvPxWTkYA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12062
X-Proofpoint-GUID: NG9iyDPlOv6Mpy3gD0MFqQe-tvoZYiX9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDE0MSBTYWx0ZWRfX+StUkRHddLtV
 fwp/Tn3Y8rDWOcgS60ExL+dWTz+sCGv8j/X1ziPi2bO9PkstY2vt8XtEoMqezdUvm4ti4ET+YJ+
 vU9khmdC1Cj7LIQrJTPaBzd+KoRyDAZQpELFvoeL0ymYWnWK+or38PW4YnxWKMCebTWmbtSXaeu
 VSdoRZj98rJEuWJaAQ2NfZnteKUfphVHmbkYEiWUd0V9PF5SNP6f9J4LdbdLRuhwao+IwLK4xKF
 9BX6Kq5H3v12BmdjHuSLdHnnprA1l8rMhMlHPSD3hzWZ8mluHvjp5u/4ZJ7hFjdtXI6aMuFa6S5
 sCFGkGR3vZfC+7p3TBCcmI+6iVjrLyfOXqcTSMPtcwjGxOQrWrM9YgPh3fNPgUmPaA4b25I8qrI
 OSzvHOMDrLGW3zQHW7mbaCU4sGQC68A4NMA24fyW7noAkJAmH7ADngrIRhhwttNx5ulWl6E+
X-Proofpoint-ORIG-GUID: NG9iyDPlOv6Mpy3gD0MFqQe-tvoZYiX9

On 23/07/2025 16:48, michael.christie@oracle.com wrote:
>>>> What if you are not using a physical block device like using LIO's
>>>> ramdisk mode
>>>> to perform testing?
>>> But would this non-physical device still need to support atomics? I
>>> would assume so.
>> It depends. For just a testing mode not necessarily. It can be relaxed
>> so you can test different scenarios like you want to test when atomics
>> are not supported correctly. For real support yes.
>>
>> But just to be clear for either case, there won't always be a
>> request_queue/block_device. For example, rd and tcmu don't use
>> target_configure_write_atomic_from_bdev, so the atomic values can be
>> whatever they want to support.

If that is acceptable, then I am curious why only make alignment 
configurable (and not the other params)? From below, it seems that you 
have some special device to support.

> I think I misunderstood the last comment.
> 
> I'm trying to make sure I can support a broken device for testing so I
> tried to make as flexible as possible.
> 
> With the code as is though I think your concern in the last comment is
> that a user could set some valid settings, use rd/tcmu, and think they
> were safe when they are not. If so, then I agree that can happen.
> 
> Or are you saying even for broken device simulation that we will never
> need to set values like alignment above?

I suppose that we can set alignment for broken devices, yes.

I'll make a couple of points about scsi alignment as it is a bit 
special. Firstly the alignment should be compatible with the atomic 
write unit min. atomic write unit min comes from the granularity/pbs. So 
the granularity/pbs needs to be compatible with alignment.

A further point is that if a partition is not aligned on the atomic 
write unit min boundary, then atomic writes are disabled for that bdev 
partition.


