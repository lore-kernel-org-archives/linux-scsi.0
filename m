Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD3F3B1ECC;
	Fri, 21 Aug 2026 07:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787298143; cv=fail; b=KdfnFye2bOI7F9RX5V2xW5n54CXFrrQtR1KyqJRr5e8Z8pxhP0AQnmlGQ3/Bwh6gP24ewluxnlnrgOQeU7tFuOyi+5xU5v1BFTzd7CCjSY2E5Q+Vq81VkpGfuX0+ugEGIxlE3fw1VO5JqLDQ4ahiMGuk/S2o3FBbCFhFn/Oxy/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787298143; c=relaxed/simple;
	bh=gFC81Ncgu180ezoBktuLqtKBJrXfowQP+zmQSCaOoNQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SC0SCz6AweV72jzIQPJfegbAaLZZY14llADUdt4+7+DXm4SRnGRJ5naePGFZn6BdjsUQSkw7FX9QWJS/6h0Q7LvMa6US/3KTL6yQjchvkOJ37GQgCvImql+feL8VAIUfjI4pIlQG3JJzNa8F0xgu5bxY1+qqLy7Y/YiS27rmYDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PtTdETZS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HzzhZZxT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PtTdETZS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HzzhZZxT"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KMi3f1009745;
	Fri, 21 Aug 2026 07:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xIH1hGiDmwtRRgpaIIBM16PU+z5dxkdvG1FjF8NuYfI=; b=
	PtTdETZSJAb6E7YqPbUPnapE675KsUmmWk6Bk7BjYmNtSalO2TEscs/NSSL7xpGo
	Le6fnye+KQyRNs3xPGBcQ+nib7MHgj5yCVPtFN6shvWZFjjSVdxhYbvIpg2RNXMt
	GZfDmzLwT2+l9ns46FP3AvLDUn4BnhWY9QQcJE1KxwWvDtqRW9zh8VkAVGGEB2GA
	Zv2XbMNDlIICsBi3visLBXkA8mJqjtfC5Rm730mJ+QW2PB3UKq1WN7qsbmoQlI+A
	x8/DEQl/q03g2/Y6nn33izjf9ZxUb7mbTFkuX9hWVmcj1FbKJ0g78l/1dqqbugZF
	0aXh+xu6tJ1W/I7oGXYM8Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g4yddcmg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 07:41:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67L7Z8AU033351;
	Fri, 21 Aug 2026 07:41:53 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010059.outbound.protection.outlook.com [40.93.198.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejfvf1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 21 Aug 2026 07:41:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XjmW71ojcYGvD1k1y2Xv9kMdL6Wpt01A9RSf7LfYSxm6Cs0905wt1ZT+tY80jfa/zF/3z/Uc8vhasXbIP1FTf+DEYugxS5s1uxbIl6dERQdHQswUyfsO67Rngj2R/NP2hxbE5wdtsrvNj6jFkvKZCHbCyCk0NhsDibASEdAX+HLB0sZOZGwGzYj8emtX/lIEdlyeKOV8tX5O7TdelDtN6XiIC/VoUoqtkFqskXEoyhHIJDhDrtXLnBMrXwKgVWuqfEy3W2c+AVUS0C3YZRh7uT53HT92c0Fd60pte4WtlwRUiZLjlHb5UCxqIBd08Zy0mopZLyINw/a72tAo6yGZMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIH1hGiDmwtRRgpaIIBM16PU+z5dxkdvG1FjF8NuYfI=;
 b=CxX1l8edxKMfBn871ZVi4k0ZegX8E5Enr5vzte+HeyiPDh99+CcP2wGTVSyAFvLmXauLVovxj9+c4VPXrjyO1lZwRsV5sFlrDzKx0FwQwsE6VaAbDcdkQbyUBKPJ2OK1vVw/nFXY1iml4ixgxjmr+BoUhpyCflQnMVoBPA0Hw21Qo5BK9rHlTm2hs1J5BcpIRodZjABnqId6Jwb6Ax9eNwmAtrfPywbRXd+6TCZXYH1bJRFZSMRd0dytawjbKXtnyHbh3hdpWx+gplaO2UFmaWn1GJxTlGo9uEjC3agcZGHKW+mlbZmWbsV+4lgn5P+da5LM2m6Z3YrlqBFZQ5CGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIH1hGiDmwtRRgpaIIBM16PU+z5dxkdvG1FjF8NuYfI=;
 b=HzzhZZxT2ZaKBzTWx+PB/MUg4J5S6sHnyW3StoRIAuFB5Pm1B1pKWwPVNqaIr4ktT8b7clBwoXDb606vzCFGGrwTSchori2qopf/de0RlXZrw1qBdTkorvfQf2G5ptDZiZ1EPZOTdR7sB8/iYAKANK/uKQ//PZDODmODSAayOmw=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH4PR10MB8227.namprd10.prod.outlook.com (2603:10b6:610:1f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Fri, 21 Aug
 2026 07:41:51 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%6]) with mapi id 15.21.0339.007; Fri, 21 Aug 2026
 07:41:51 +0000
Message-ID: <d3289f5b-7b4c-44ce-99ba-c7ff0f59404d@oracle.com>
Date: Fri, 21 Aug 2026 08:41:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] common/scsi_debug: don't slow down I/O
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
        linux-scsi@vger.kernel.org
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260821051133.1817670-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0029.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH4PR10MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2d42a4-7ef3-4150-d75e-08deff57a0e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VnjS91fhDF1p5IyXYiNbBI+gdGyYzvkpQFT8YaFtMdxnY0XFfVWFf3JvFILonNHwV/Ny5n1la2E4Ucn0670muGePcyhBxnUchTeML3vLWkV0IyqpCfT/YE8LdK1oXhmkX9ZDRsE/p/MeEkeP+OZrruDi1qaC97niqdNVByoqXFQofEDcqfzhp2WysRDT/ywLCtMrplHdELzYtrcESpabTHvsebgbVJ4AhXI00n4/OigA6pMaqGmfGxT1Rs0cpZQDnaQ8HSiVfjRrf0g3otWq/HBCNkPovAvP7BneH2JGDHi6XzEbHWoFJP7mzeM8Bh6LVy1Tu6922nzV1VIlZLadux7yPv1HTs/vdKWIcLjw9n16xQWQvQNV3Yn0i6SZTw2bI89ioJCkkdbCS+t8J0qsh9jUoRP3AujB3YZB7Embi7IDAMKFwSMnbdokET2AntcFKzP2I7jQtAb6hbYLy9CEcKQ4quD7PeyRvqugQEoX6PIPZsfsCSeyNXRsUbOB93OWsSiMrdzdsV1BS/SSun0D+HpzmHbczhDOvGIjsN04TJFU3Ioac+CdpYDlVE241yyVP8UhXOE6LV8ueqlz0U1dCyeDJJbeHP0jPO24XkOWDeNvxv9gQEslEKwcb3EBq7x6bIseITvV+enScamXtrgfFJYfo3SEOxaD4kaZBFgB2Qg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUNiajIzT0M1cUxXMlRvOUpmYkk4Y25mbUxlUGFabG5oTkpZZHN1c1pVTWk1?=
 =?utf-8?B?d09vVmZWYjlta0RlQjBxcHloZ0RqZmU2anR3dkd6WTk3c09OSCtqdkpmekUz?=
 =?utf-8?B?WWROVWNnQUNCWXNpL2lBRU9aVE55MlZ2WkN0VnhyL3VmQjRSUWt5K1g4ZDRW?=
 =?utf-8?B?VUQ2MitBVlFQTGgrb0ZHbnVEYjV0bG9jUVRhb0I0QWFNN2hkUVRUcGpzSnhK?=
 =?utf-8?B?T2hEcWpqcVl4QVZZWXA1T29nOEhtSm5SeXlOWVJmMWRSNEFzQ2QyemwzaERu?=
 =?utf-8?B?MzNkOEZwdDZWc05lenk3VnZwWjQ5YnZFTGVvNmJ1cGpzOUc0MkpTK2srVS9k?=
 =?utf-8?B?WW1ISGVKR3Z1TmsrZmtJRlN6Y0FzcCtvNzU1WGEyYkJENURiMkllNFdEbm1y?=
 =?utf-8?B?Q1hHdnJlVGRYWngrRStRS0hobVVDVTJlSjE1R3Zmdmp0b0VxMFZSTnV4d1JJ?=
 =?utf-8?B?bVpZMXA1cDdCbS9HVHJaT0w0T0k3NVVISTRhS1lhZFVQak8rSjROVVRmSVFh?=
 =?utf-8?B?TkhLSUtyNTFsVUc0cFdKcW1TdEEzZHVUTDV2UkNZNGVWUDhjN0hYMFM4N1lY?=
 =?utf-8?B?cDZsYU1tSUU5c09sNnJCT00ybS9wcHZ1WlpZbDdFSVZKVUdxSWJzcXdWSEtl?=
 =?utf-8?B?RkR6bXBoYzlPMllFVVN0WWtTYXd5QTZTcFd5VE5nRGhGLzJaeFQ4TkdROU5r?=
 =?utf-8?B?dDFrTVZyRjFqT1RPUnhyWW5rdm5MeEtPVDg1WnRkeSt4aGlVcGJhY2ZOU3Uz?=
 =?utf-8?B?ZE92UmZGNmpFNUFsUmZaL2RnL3g0eVZLSjgzS0xsL29XZ04zVzc4TUswZnYx?=
 =?utf-8?B?anV2bUFpVzhXV1VCbHV1UURTOE9PQ1pQeFJSMnhOSHJWbGwvOVZsemtZZ2Iw?=
 =?utf-8?B?emQ2OGlmMGRlTVBjbWZXdEc1TEQvNXJZL3VRbG8xVmNpdWk5aFM3cGRaaUtE?=
 =?utf-8?B?Y3hxb0RJdHNJR3pMY1huRFRDS2lERjdldnY1blB3aDFERWRYY1o4V2o5ek5I?=
 =?utf-8?B?SGxGZlBONWtyZURXaGI3S0h5QjJROXIvMHE2ODVLY2hqY0xSUW84MTFRKzdp?=
 =?utf-8?B?ZXliRU0rdG1NTHpUd2NsY3Mzb2dXZThxUmJjYTNEL0RTVXRqeThmZW5QdlZP?=
 =?utf-8?B?N2dsRTBzWVNId2hQUTc1cUFTWWM4UmFLWmtvZEJXampUNVltSnhFUDJUT2g3?=
 =?utf-8?B?UFpycFRiRGpnUTcyTWZhNGtYMkEwQ3U5aWR4bS9Jdm4wRndjRjZMSzVJMTVS?=
 =?utf-8?B?bGRianlVeXhocXp0Z05UR2hwUkxNdHpNdFVGanVRNkt1V2htT0hUL3NORm9i?=
 =?utf-8?B?ZzhzenJzMmZhM0RDL0F1UmFObHpEYTkwdSswSkVZOGZrNXdOKzJqSEtIbWtS?=
 =?utf-8?B?VWwzZE5qS1hLbDUzaHM0RTRhaDl3UExNVnpCM0pReXd6L2xRb0ZlNjQ4ODll?=
 =?utf-8?B?dnVWVDlZTllnVDBOS2EwbEQycWxtTjNNZ1hUTDY2ZFJvUGlIVnhxalE3Ulph?=
 =?utf-8?B?RzV0ZXlVZU4vZ0pqa01xdzdLVDkzSnpaS3RPZXpWdDd0SEYwdGtWTW1wTkhS?=
 =?utf-8?B?a3poRm9WY3lTQ2lTaEs2WUVRa29xek13blhOMEVNZW1zSThBbjUxMkZwd2ZJ?=
 =?utf-8?B?c1pCWWt3bVJ1Y3JyZzNick00WWsyYitkbXM3aUVKeGFtQUpaYmVQNStZZmNS?=
 =?utf-8?B?WGYrYXFRVUoxOW9hWUU0dGxDZG16eHkzelZYRFlFVDBWazVyazVyTGFUclY3?=
 =?utf-8?B?R09tMzc4S0x3OHJNMXJDNEVHZTQxL1hTdW55UWZIMTF1ODV3MC93YVVUdEI2?=
 =?utf-8?B?VkFwYlRwN2RIcTBacFlCd29WMUNhenp1N3pJVDVoWFp2U3BiRStRWUd2TW56?=
 =?utf-8?B?blZrV24rZ0EvdkFudjFVYlQ5K1dXOEtGMG9SeDl1VmJyUjhkVTVSNjhza2Ey?=
 =?utf-8?B?VGI5ZURVeGJad2o3STZDcHpic3Z2M0FLOStIR1JqTysydk9HaUxGbmZITlQr?=
 =?utf-8?B?OXU4YktDTU9oQmNzdytNdXoyK0dlNC9weUJBOXFVMFU2SCt2eVluRnRITjdB?=
 =?utf-8?B?YkpTYjNIMGNudTRpSkJQT1R4QnBXaHJFUlNTYzI0WDVzZ3dSMG1ESklUdkE3?=
 =?utf-8?B?L1JzcDdTckNNQ2prTVRKZEoyemhLNXpuWnU0aDB2akNFdG9YaDV6SW9vbFlk?=
 =?utf-8?B?VDhodDlrUlQ1MERiMDJzU1JtU2hORy81VlQyN2RMQkxpY2RRNWtGNy81Z2FD?=
 =?utf-8?B?bVZ5MFlVU1h5TWJZKy93QUhRdUtiV2M4eXY2SnFNOHp1MENta3F5aFBBcDdP?=
 =?utf-8?B?TjJBTGlCbmQ3TGRSL2E1UXVLWFhPdHNQa1FnRThFWFljbGx0WUhBdz09?=
X-Exchange-RoutingPolicyChecked:
	UWcDisvZTVdAOiA8J4ColnQgud8Fy1GWr5hFtoflO1CFOfGQ6loeeZNvi3Zv7BXrWLlDSMeoyrEtbE/rlWfZBFnr7UcSV4ShLXYPeJzuJ+nmnD4jKIdx4jUh7MesttyZABFokYriUUEz5Z9QPlKw9yF++PSSrU2VC1Ayc+o6Q4SdtjyclW25Kon54OlwkyWEBngk4IX2F6+O112Qq8hsHJ11ZGe1cAZBYBD8lpbGM7fm+RAyzQ6M71+SPhA/wFqcnBQufAVUjubg7rLf6nO5Gn5hmO3DX0EQkfKDupeqEsOyTIoDZTdRuKUmEfLJFdkhjsNb564ef/raGYMFh72BkA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xlJi1tgciGmckUyHuUIxodABlZfAgEBXl2ywwFcjtBDusvSJTQMrr8qobK31/x/rxP1+wLaYCoxM7hmrQft9rARmDK0e7PIpc5nktQmzhoN915mnEbd4vM9sFwBv30zHSWbzBuy1IW5kkzfMYYi3DvdzQaxFudYeRUR7x0GB+48JW3tcsv25pDcGZnV0N4hg6i8xfreZlcFy8l7wl8CkUxzJUZ+uC4kJT4dt037PSVFtpIHksEA/C7+hi4YTS9sgHDEX7f+QqqY/Ipix6q5mYTiEMMzlPSQIogt1uIZa3H3uzcHxpk+LHrflQIupLWny1qUD+tg8d/4V0l/xlZj7IRriZNoEdDGApFdP0BaBGPOh1cr8PNhPxFmjhftW6GpetxznY022uZkMDslOB+As7hqdJBz5+Is8CoyoEg0KshgKK+euuZHD7KiXn6HIyTjyVMRyrPMLz8PdTJI03f390HqVtED5d8a9PvkZKVGlLGqdT92AKSvx2C2M2Z6tPTdVB1BxBxLBoz9IY5aTPo6bwtXGnVx29LvvQQmr/8ksRoZgUoqd33t0ye95nRbI55u0TprxVCoFi3e4uQlLpUAFKSmrmTyMVlgnR29dXP4eIec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2d42a4-7ef3-4150-d75e-08deff57a0e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 07:41:50.9498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7uGvGPp/yVFCd0RappPfTLRDaeiTnkXVtSajTNyewYg6IJWVVtyVgfnrbxCHTSgSsqRXRMkDr28eVYDa1AC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_02,2026-08-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608210054
X-Proofpoint-GUID: MJomJrimVjSQlf2G-uN73XNKNxgDT5tg
X-Proofpoint-ORIG-GUID: MJomJrimVjSQlf2G-uN73XNKNxgDT5tg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA1NCBTYWx0ZWRfX88gdI28+OeQj
 q830SgDftIk9GU9Qm1pgYcJftDLk+XG6WpL0GqifRiR4Nix/PijUw+cjsTJIIJ7uaHZ8Le6qGA8
 ZEFRFUguf+8QzF4Jh0QWrYMHhxOuG/CDWKIdiPZBRl+qbtN4qKH5
X-Authority-Analysis: v=2.4 cv=BdjoFLt2 c=1 sm=1 tr=0 ts=6a880142 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=1N4xedQP2VqXkcpY0fwA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA1NCBTYWx0ZWRfX+VkVSzqn5TW9
 LW9gvqI7YQSX6QvagS7y5cu6jl2AANpHWnyBGyKottlU9t0kT4SkvGT+LJhHLgaceUhO6z8Dy3F
 4IKZbxj6NDcGJVHWpFmsQo9zjwJ7J4SH9IBoXzsgDxbvTXstxD+pEYghZ+ZeMdUWhuZAea6qDIM
 zs9A/feq1jdpFEzwN8Unt2Lo5QgNS9LpSws6k3KzgHrbbTy41Np8R5GDoAx1z78cDU93t3iPk94
 H3RsYVauV8DC/FlHj7xYclVoQNuLKvlH8srCE0TsQA/DCFlxtPNnZ8GSoWIk5pq1lhEO3rxZr6O
 LvAUudZpNEedA8ePjNKTaRMSUnbrdvxrSMxXxdC2e9tqNq4pPPAHP7fwtzyXeJc4WFmwfQIItHS
 lDV09EVkdmqJMBQ3NBehhvxGzI/cjF7JRodwqkQW96kiHQLLBChs9IUvg80PbfTNT/2JGQVBPEP
 eevsUTSaVP1/Sg/5/RQ==

On 21/08/2026 06:11, Christoph Hellwig wrote:
> scsi_debug by defaults delays I/O 

Maybe we can just make delay=0 default for that driver. Or use ndelay > 0.

> and doesn't support multi-page I/O.
> Flipping these defaults speed up each test using scsi_debug by more than
> an order of magnitute on my test systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   common/scsi_debug | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index c3fe7be623fa..af51905dc4ba 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -59,9 +59,19 @@ _get_scsi_debug_dev()
>   		let physical=physical/2
>   		let phys_exp=phys_exp+1
>   	done
> -	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
> -	echo "scsi_debug options $opts" >> $seqres.full
> -	modprobe scsi_debug $opts
> +
> +	local opts=(
> +		"sector_size=$logical"
> +		"physblk_exp=$phys_exp"
> +		"lowest_aligned=$unaligned"
> +		"dev_size_mb=$size"
> +		"delay=0"
> +		"clustering=1"
> +	)
> +	opts+=("$@")
> +
> +	echo "scsi_debug options ${opts[*]}" >> $seqres.full
> +	modprobe scsi_debug "${opts[@]}"
>   	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
>   	$UDEV_SETTLE_PROG
>   	device=`grep -wl scsi_debug /sys/block/sd*/device/model | awk -F / '{print $4}'`

