Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BECC13A276;
	Thu, 27 Jun 2024 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719491209; cv=fail; b=erebxbkP5bwWdzYBvEo5zkeAO/Op42lpwnT9T2pU+94tqBTVBxcB7GIdGt0FnLk8L8+anTM11wUQ/JRjmRPmTEr672Gl+zBsALE2ykT1gqOqfDOKxdQwr8nnUWuGi+XkQxpAnnP/0yDZ9d6DGANw4foBhLUiivuQ3PVL5ImzhPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719491209; c=relaxed/simple;
	bh=TNgJ+MJwVFLMHYOrTcMdLkHS/9dSiTVuD7KvPUnUKXM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m6usVtaw6TksXyxA/vU5xV95M4ciZDDgrQ3xaATEJUomniSeR0Kux88ZSY5BEZA1rkOdkXpHsPSUEEOyxVkJFihqxRwYl/IF3sgerD8t8yNtDcr5opiqKGI95fLGQohd7geLPN7eVELt1eo6YEc6COhP+M+ZcsuqIBC8lyW4y/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gD2QtLo2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HVMnbsFw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gD2QtLo2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HVMnbsFw"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R7tXRx013538;
	Thu, 27 Jun 2024 12:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=VCZH3zmtBaeShP7juUDSrBK7DqAFljoPamq7QmugMsg=; b=
	gD2QtLo2+aSPnXpmzmqu3367ODW+xdie2av8hHgC37IG7onpIouUisIgkzLFh72a
	jKpzDxZ0tOLQ0T8UxX6Aujxp+Xf55Nx4vsOgOCaDP7i1Cz/cy5wC2otwJx24xT50
	RojDp5NWqOU1xU0hHOpOtHWXq0e7cofbmok22vDlsXUs5X3mCNJ85yYojADetgZf
	gVOVvf1Uy/IpviQ52HeTzCU1xEZVSUm3BYHYvY6ZeNr4cD/LUCYcKleYgWy9rVvC
	Unx57sH/zko4Vqz9g+ZDhsEY1zgpP3QupBuQvP03VoGL3APUQcWQZRFxQ7qxtdG9
	UCflNSYrBwFGSsSX/haq/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpg9dk0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 12:26:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45RCOsV0037038;
	Thu, 27 Jun 2024 12:26:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2awe9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 12:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfEhRuvtkce4eosGkd3rurYIhuDDVIyYfBiRY532vqIXFOunPkys05LjHXM1eej+HGzjRJtAXMVj9TvjPlOPkURBGMixAuoPK8/ptQPDQIn9xa9jp+/OxzrZT2rACxRBtPNooGXugJXkCMDRxGWL7VB5y1iS472o7Ljnk7QZQLERG5aIoTAI9NYyJvVvqwTbp9CrFHiPcmNqIKB00NpXjGs1Mwqmkx27uLtWZJwP1cGUCpVt31dgn7gIcSk3P6EFXw6SiiOX8gnsabBPTT6N7bW3tx1TrhhI0y3Tz3A7CrqTO2mYWMevM0Oohc2qTZ2wLie+fgkjslRsskWdfCfzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCZH3zmtBaeShP7juUDSrBK7DqAFljoPamq7QmugMsg=;
 b=ieY5ejvWQ1tSH9MJudwqApBODGfpA3gI1GJuZNwZUlCTtRrZo5z4+tIoCRYLHLvucj03ShwmTwriFWJXss3UZj1pd0RHoBzH/Fv7feUr7od6faREgMxxs6yjCSW5Y+LqQiMbM4OjP/tGc3B+ZEoM604NxL75Y5hB5yZ4doZb1uFnSkL8cmdPGJ+RBcysZCTVsibBPUxBhgOoSJkxABXO7Gt1Aa3r9iKJEzWze7jRTZJKBGJ0d7D0jGIijA1l/zR7pALR4Ng8OoymF1xdlI0iwuQw0qeEfY2IXDrRDAsVTs4uNZlFYeIQTKHPay/9XZDm5dVHECqUpARddDLIDNi5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCZH3zmtBaeShP7juUDSrBK7DqAFljoPamq7QmugMsg=;
 b=HVMnbsFwTAZV5VDODD8xoASOqt7SP3NjNKrUuEuhfoGy3ZmzxuDTXetQWpT33nOHR6P3G9OgYH60O0zjorn8TAMJ73MIVEBaVMgee/ARWjgt31HjyUspSiW1vyYWRZGu1cRSzCZqRxABYmZuEu1z5eZwZX2b0b1bV7rPGw4Jquk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.33; Thu, 27 Jun
 2024 12:26:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 12:26:09 +0000
Message-ID: <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>
Date: Thu, 27 Jun 2024 13:26:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] ata,libsas: Assign the unique id used for
 printing earlier
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Colin Ian King <colin.i.king@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0541.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d7f3001-278d-4d73-5742-08dc96a452d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dHd4U01LWWprL3VldGZERnJKd1B0UFZvZDFxODI4SUJ2TEJ2TkN6bWZZU1k3?=
 =?utf-8?B?VGgxTEJGZmtUMWhNWXJxOEQyUnlBcnNyajVqNFJIajk3cjMrakRCUlI2RGFx?=
 =?utf-8?B?NmxyLzdYR2V4R3JEbGlGM3pyVlVsMUFReGEyVTVCN1B3eXRiMGNLVTZCQ29W?=
 =?utf-8?B?aCtpaWF6QW9BbktGMGNrN1YrZmhIckJPVGk0cEJkWDdWRmZvRTBJRWhZUzBw?=
 =?utf-8?B?eTl6eVFFd3A4SXFvNE5DdHhPM3VTdHhvVURUQTg1WHdGK3Zqc2pWQ2J4ME1C?=
 =?utf-8?B?eTFwRWx4T2xaK1I5WUhpWUJNMXNvMFJZMGZWbkc1d0E2eG1GRjR0ZFRselEx?=
 =?utf-8?B?UUFQT280d3Y0NVExV1JVc3FSbTFTV3RqQ2lYRkcrdGlVZjZjRXVsQW9ZdkN4?=
 =?utf-8?B?dy9WNkg3a29ETTBNSS9IU3YwVTgwc0NscXpJMU8wTHozWEkzOERxdlUzUlAz?=
 =?utf-8?B?alR0dlJkSUdNWVlEUEw3cjF1dDRjMExPNkpBWUpsSGxsYXFUejZnL1Zya3Vi?=
 =?utf-8?B?OVVJT1ZMUjk3ckpwL25xaVhpUHBUcHZkRVZrcVh5YUU2aXlkMWVvYWZXMUgz?=
 =?utf-8?B?b043SXprNVllbVpGR1ZaZktvaE95K21zdklkUGgxWUE2ekZGbmxiNXlLS09U?=
 =?utf-8?B?THdjK016VkJEZzhEYkduRXBYUEdJOVJzeURTcVVYaWgvcEN5dTdEL2J4eU1x?=
 =?utf-8?B?UEtydUdadFNaSWYyMytsd2hQQVV2ZHdxaGZLdEhRbEZaMTF4a2JieGJxWjJj?=
 =?utf-8?B?eUdSa1NFTDZFYmNuZ2wwZG12Y1ROdEhJcHVhVnk4amxGcjRoQnhrMStZZHhW?=
 =?utf-8?B?SDIxaEdtamIyR0tkVVowM3hJdWVzR2R3bDJMTk9NRjBXNmlLU1g3bDhWMHFK?=
 =?utf-8?B?Y0hzQmlJdFJNZW9SZG1XL3pWSWdEd1JDSFRGUURieEluM0RrbGV3T2E1ajU2?=
 =?utf-8?B?eXJaaUcyQ3lxUWhqbmwwRFlqK0VMdXg2aHllaWlYUThJTXNwOVlvNGFlL281?=
 =?utf-8?B?SUJZc1puTnB0T2ROSS9CbHgyeHlXWE52Ulg5WUZvKzUrTGdha0ZKcU0yU2pz?=
 =?utf-8?B?VDhqZ2xFSU5lOWFBMDYwZHBHZldWcXFxSXF1cG1kajd1OGhuSkQ4RFRvRmNY?=
 =?utf-8?B?K29FdmYvYTEvZUN5MVZYZUh5WDBiNFh3SDVNU2hUUk10cC8zVGZBd1RmbGdB?=
 =?utf-8?B?dnNrUW1TZEl4R3N0blRPb2pGbG5JSUFCOEE4bHIzeDN0YTdBZGRnNTh1N3h2?=
 =?utf-8?B?ckp0NE9Idnh3ck85alpIbzd6UTdCNFJnRjVkN0U0RENKT2huTWFFM3hONVhP?=
 =?utf-8?B?MGJuLzBrNGMyeCtRZnM0akFoNEpKUVY3NnZ3c296bFQ3TE92dnBoMTF2T1Jw?=
 =?utf-8?B?YVFyYmY2OThLK2NLZGZQUVlnakl5R1hreEZJeHV0a3dzQ0xHSmJnZ3N6Zitw?=
 =?utf-8?B?dUhWQ3BGdzI4bXJ3aFJ3SWZBdjFETUMxSVROa2Fqb09jYW1EL3RGYzhpUXlz?=
 =?utf-8?B?LzFNZGtqSjZ5MXBBdTFCWEw3TUx2TGlSa3RpS0g0ZGtaWUJDb0tBVE9zL3ZX?=
 =?utf-8?B?QW9tdTE2dVByelBWWGRaOFB3bUcwbjZvQjhXQjNBbitlbkdCNy9XWWFmTEpa?=
 =?utf-8?B?cFBCYXZrMHVaSGgvS2Y4YVV3SURPNklUbkNIekxyK0l2WW5IQkVkMG5OS1BD?=
 =?utf-8?B?NVYrZGgxc0NjU215a1M0Mi9nM2h5WkJubUJkTGlyaklqQkJSbkNoc3NBT3hi?=
 =?utf-8?B?MzdMNDdod1MxTWtyRW5XRG9mTkpwODNmQTQ3MXQzc2Q3c2MwUWlIdzBLVm91?=
 =?utf-8?B?VDVuRE5MV1FCajdTOVBROCtQVEU4M0ZFbGwwYUdzMjcvbU1ORlg3bEtDWWJz?=
 =?utf-8?Q?oJRLUi6bUhIp0?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aGFzWGxOc2pCalNjb2EwRmZNanVmNklVV1prWGR2ZTRrTEVxcWdSTTlZR3oz?=
 =?utf-8?B?UVZIYVZvMm1NTHAvQVh4amNOa2swL202UGlZamh2VVQyV1V1aVlzOFNYQWxK?=
 =?utf-8?B?bVd6TDNFY3E5S2hSRXVja20zU3FsSW9kVkdONXF6NmtyT2xvYTg0YmRranVY?=
 =?utf-8?B?M203bm1yeE0xTkx2ZlZwV2F1NVYxRTY3T1dxYzV2V3M4ZnlnZThTeWg5eTBH?=
 =?utf-8?B?dmttdmFRRG4vVHNISUZsaGpEaDBPT2lKZEFkSXdCM3IrQnF3ekNrVCswVTcx?=
 =?utf-8?B?enBZbnc2eHlhbmxVb2pPYTUvdjF4dTRiQm9RbXhtQkd4MStaU0xRQklCYkJO?=
 =?utf-8?B?czJ3MXlDMVNuZnpwSzIwV3VLVWdTYkFCRjR3a3kwUEltcnV0elZhci9hNzh3?=
 =?utf-8?B?aGdOcTJQSU1wTHpMSThoMnJhOEs3OHdsNVBSQzIvVDVxZzVtL0xsaW95V1BD?=
 =?utf-8?B?YmluVDRXZ2hxcEVRTTc1SGFOdGJaWU9VYW9oS21ERm9oNjExVWM2MjFLWWNQ?=
 =?utf-8?B?cmgwcHZkKy8vZm9nMDdseG1uWUdremxhVDAzTXpXYjRhMGkxcmQ1amlib1c4?=
 =?utf-8?B?dUxNQUd6blZKYTVlNzFQdklBbDRrZ1BPRjAwczRMeENlN0RUbmJMQ3dDekdz?=
 =?utf-8?B?enppVFFNMUhqajZXeGN6RjR4aUVRVnAyTDdxeWNvNWpGcjBZdTQrY1UzUEx3?=
 =?utf-8?B?Y05rZjdmY0xic1BEUmhkZDlBdUdvOFovSUlRbjVyUWJDWVhNcEdJUDZPVWo1?=
 =?utf-8?B?NnQxYWVKWi8yU29kRkpJNU10RC9aNmpDejRNN2s5NWx4eXRrMUdjaHJsL2ty?=
 =?utf-8?B?bU1IR2dnZlpZZ1ZEMytIdHNVRGxabTFrZkxSVVh1alZUd0dtamp4cWtkMkZw?=
 =?utf-8?B?NXVLamJSb2FweXQydkUyTndlMnAyWFBaT2hMaXJ5dmtJb2tiZ1NLVEM5U2I0?=
 =?utf-8?B?d2NqdjlITEswSWJjNGNNUGMxNUM5MUJlRW4xM0dKaVQ1US9XNzBLQW5CSzJu?=
 =?utf-8?B?aXN5QTgrOUlOY0RqV25jYmVlZVVpWGxxSmVydkJRZS9hKzRsY0JWcncyQ3J1?=
 =?utf-8?B?OVdveGdlUjBVeHZyc1EyVnQzejQ0TGx6N2hDL2VBazl4Qm8yK3g3MDI1dXMr?=
 =?utf-8?B?MTlpMEppcHYybmxqSVZwWmdEeG9GL2pBTWMzN3lGSXBEMktNaXJ4MVdOaXh5?=
 =?utf-8?B?dUFObFRPdkd0MTU3NXg2eGQrdjVadGljZzBXQVQxMzdQbEI1aEVOelkwSnlN?=
 =?utf-8?B?aHc5V3B2S1ZKUUlGQURSdkVRK1Vna2ZmT0JSWVduWlBjQ2prcG54RDNUN0hr?=
 =?utf-8?B?c0xKUnJzQk9TaXRjeG1RRHQxaGR6M3pjTVA3eTRRVys4ZkliOVhzYktMMkl5?=
 =?utf-8?B?RG1wV0t2cUdGSktYQmJCcTd0SXE0dUtZMlN0c2ZaeGg1UmhURnhWL1NzL2Za?=
 =?utf-8?B?REVWdlZBOXZwRGJMajZ2Qm41T0gyWk1FYnJPWVhWUGdxQldNNkg3TkJ0dEN4?=
 =?utf-8?B?TEpLTXNqVG5mb1RCaU1JYm1udFpOaHJYbThleEkwQUhZRDlUU1R3ZThnWTFm?=
 =?utf-8?B?bVNyM21mcGkzVm9Rd1lvelZWeHFpL2ZoWUJJaFBzdTJyc0t5THNPYVpvRk42?=
 =?utf-8?B?TWdnTktwYW9GcWwwUFR4SWxCZkdRTnR5a2hKVGhBY3VDSHFuUkJQY01Hbzgx?=
 =?utf-8?B?ZjRGOTUrTmZoZ1dOdFpJMWN6L0N0R2lHd0hoS21sYTA4UXR3YWJBZUFoYmhT?=
 =?utf-8?B?UzBjL0tYU0s4YnZoWGp0cWlRSWlsU2ttdDhSVzN6cFljbkdsNGFUclhibHRJ?=
 =?utf-8?B?c1VFRndoOFRGUnhQT1dRQjg0d2s2eG1CdEJZSzBoclVPc0NvZU0yeG5FVGdm?=
 =?utf-8?B?TVFudkYrWkFqYjhMSkFwc29US25PTHpKRmFpanFDWGl0OXVvZ1lkWW1SNVJi?=
 =?utf-8?B?d1B4Unh2YU0zR1FBV1FIMXB0ZXJxOCtqWkxCUHN2bnc0ZUNpbXRWaDR5Vzly?=
 =?utf-8?B?SUZlQkR2bjN4dlc3TUdROTZzdE94dktNU29sbFowY1Y0Nnk5YVNFZGc2V29k?=
 =?utf-8?B?M1Fkc0xERU9MUzNPcTBPNDFteThJQXFIbTBvZUVoSTVvNnVuMU9WUGtrQnFO?=
 =?utf-8?B?b2JvbzExK1BpcnZVRkFvU2laR29FcWM3SnF0Zm9Fb2E4QzVEUnFKUVk3ZFRL?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PgtzbF34cNaXeUQ362TrbK18fkJG/t0//sJw4UIMF5Rs4NxDR6z6jmyolw+O2YYvxLOGKmIYWI3gPXDMoA9prWJMD212b3VJmUv+g345vWT6cNM48HkGURIVExgeW59a8ehaeBZKGnWeJZMjtgqM66lajEL5peEjrPIOQnZg/5yfr1C9JMSTOV5su5t2tsBAdZogH9+He+lDCmxTsytm2UZDRXCYQfVL9EI9Ww1Z5QoDFeZjmarf5iyDtZ85W3WO3H3ZIDo3RLauJPkN1gjRW/tLBXVxETrKuHHwwWoFqMJphSJ5C+NbGJ9VkW7GTAUMXJzYYYwFdsWZjcKBiZBab/UIx9g6yEuigGLVzGoSHmXyGrUkrv0RveYHvkbIppyvRc/6J7C161kEKZYd50ur/XaVTzNBnP4ScAFfJ+Sk3rxYJSbmMwd4czRkkZSeJFlkz9mnbJDV7jnmYLokpjMpdd/mglLYjdweuYfPT6oLkizb48YI6fLIfIti2IvyQtp/B7xjwZn/tv2KQOZQPycB/YxWlqOltVhuFSZYAozLmFHEjG8rfLV7QO+5Medw+ICW7odj634AGUjl6MQ58F79+n9s/X+d/J3zw3oEvG+/MGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7f3001-278d-4d73-5742-08dc96a452d8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 12:26:09.0593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etVnpLUXjSCvRrTia+nHHrthgCw7SzhYpz/K3m6I/xq0wxtGBOcg30GuWGMJYEqXtcBGpfl8/ujGMn8BgVjHXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_06,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406270094
X-Proofpoint-ORIG-GUID: 6DsiBfwRa6sxK8im7AvAgMJWB2l3ew54
X-Proofpoint-GUID: 6DsiBfwRa6sxK8im7AvAgMJWB2l3ew54

On 26/06/2024 19:00, Niklas Cassel wrote:
> Hello all,
> 
> This patch series was orginally meant to simply assign a unique id used
> for printing earlier (ap->print_id), but has since grown to also include
> cleanups related to ata_port_alloc() (since ap->print_id is now assigned
> in ata_port_alloc()).
> 

There's no real problem statement wrt print_id, telling how and why 
things are like they are, how it is a problem, and how it is improved in 
this series.

> Patch 1-3 fixes incorrect cleanups in the error paths.
> Patch 4,12 removes a useless libata wrappers only used for libsas.
> Patch 5 introduces a ata_port_free(), in order to avoid duplicated code.
> Patch 6 removes a unused function declaration in include/linux/libata.h.
> Patch 7 remove support for decreasing the number of ports, as it is never
>          used by any libata driver (including libsas and ipr).
> Patch 8 removes a superfluous assignment in ata_sas_port_alloc().
> Patch 9 removes the unnecessary local_port_no struct member in ata_port.
> Patch 10 performs the ata_port print_id assignment earlier, so that the
>           ata_port_* print functions can be used even before the ata_host
> 	 has been registered.
> Patch 11 changes the print_id assignment to use an ida_alloc(), such that
>           we will reuse IDs that are no longer in use, rather than keep
> 	 increasing the print_id forever.
> Patch 13 adds a debug print in case the port is marked as external, this
>           code runs before the ata_host has been registered, so it depends
> 	 on patch 10.

