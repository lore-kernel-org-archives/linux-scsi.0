Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44E314A604;
	Tue, 25 Jun 2024 11:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719314933; cv=fail; b=DnFzL1spf3e0zMVLfRb9desYfXvNnjortYDkPFjsPecDocOjWj9M4khCwmv14MOyaFhowcTSXCVWZQnHDaxaTrbzUWYoBWEklWEKdbtt7jEI7hJysSrV4pqOEeUYaBhs+UYYwMMJ+1r6oh1hdKrx+gUMLcT/+aREqE5LI17V4eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719314933; c=relaxed/simple;
	bh=EjYsnoknCTeMHO65BHl6ZHR/o3zAgITeoYu3Ywpv+eU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QGfONrdNEUmPGwhN6GAgiVUNUkFW2QMl6FCQqxiA/bWd30zlD0SJ/XYMRjfoLqVvCaf+Rx798i9WmcGn6+i8qmJokZgwi+IA3QpQDzk8jWj9mDiJ1HzH73a6TRXqxdA3hL+1VNcK2pUOSjMy5z43rR0aaNs/xEeTaRYCylEncQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mcw+jpi0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kSgZ0OXi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mcw+jpi0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kSgZ0OXi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P7tVvc011422;
	Tue, 25 Jun 2024 11:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=4zwDK3pAoPbdsvGX+bM9CfQMmtZBxIg6eU/jljc6mtU=; b=
	Mcw+jpi0ZRuE+Eq3karik5yAkctZma5AB0h5/18jpvVqyFyqcvC6/eycNUuvpqv7
	lraLpYgh8mdeL3RmlH8lXEiPl30jsfHvRN9vRLEHqf5nMzNqjJOD9DKP5SNI5ECA
	Aa4gnrTMMisMS+3A4tEyJSYeIk9KgmZYoQ2+3ejyTsV/9aylkvWCwzxXAcPRwZfu
	kVMd+PWMC78gfE/O45HRXWsPZedwCAJexeF1XJXfOeOoCTE/pEX26e9FAXP7xkhi
	djI6DEWeF2zRo6AP4LqDkkcRbbNJlLfD1GAywZcQpku6sWbpLyjMgdusvEe41TCG
	h4M1w7V3hz7anToVFqf6Iw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywq5t0e8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 11:26:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45P9eHWU001347;
	Tue, 25 Jun 2024 11:26:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn284j02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 11:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK01BG8xOuP+EmuVOw72EP8xlMk4t9oHh9RHGTh1KbXp2FHgUXiu+E7uuocs6Vh31ZbTMYfGeWJB8bVBjXIj4qw22D8Z4w8XJM+VoApNLQA16EGqJVRZ1ELfeuGNb/2IDIdj9JK97e64ksRXOQlOGG0Oe6znBS1Lb7/L+048Uw0IJ4sYiap8dOC2QLfXpgghmEkBspiNuuB3hZWNWlrbeLWgWDFHO1OL8ccbtyKu0vqr3ivznzpocTCIvqGE9tv2T1SssrSwAsxKy5mOcaGhxRadZccHoKbn30A7NgfLpGxPqR3o044MXL9E3VXLFKjQyIT8ZnOBNekvmqLrIht/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zwDK3pAoPbdsvGX+bM9CfQMmtZBxIg6eU/jljc6mtU=;
 b=I0CnTVP7jmflqFXpahocwlHYO7vbA3AraooJ3Cmu6xq3RFcdhNhNgJEfPrnCqJqua15kOqXgANSJH8vmOJNYrzAcMqx4DulfI0m+ODOxFU4TE7hweYWi09IrQsXXbbgR1/GSJcLG6SC1/3IzGjq5v2HGwRW4/9lWgU9/b4IJdpZBW1V6G3ZOQ8p8P4WhjvC8Y78SypIZDxPQNIkQDWrL4XlW1dTBgPB7+WVjyYTrRQENK48Dt1ZtY20YTI+bCrvbGmyGlBZrEr3Er5oJW8bPjs0L7+FSt9q5jlVB0usy79PecrTGGolRCwhFIqtqBJyEzHtp3ur2ITMfQgRwGNwvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zwDK3pAoPbdsvGX+bM9CfQMmtZBxIg6eU/jljc6mtU=;
 b=kSgZ0OXiebJWw4AKQrrO0Q17iXnSU3RwMl7bd7CCVXTfUt0os6g/MFlP0htbSwywGfbUUBOyEQL1K0JICLCRTawNZNrGSyRskDzvLr195hcn1GTNUHEFe+rnJLNaU1YlP/1Of9l7S4mx4h+1KAHqIFKcC4fQeohtRDv05P9lxlo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 11:26:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 11:26:09 +0000
Message-ID: <79a46bf8-0c97-46a0-bd71-32512600148f@oracle.com>
Date: Tue, 25 Jun 2024 12:26:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] block: conding style fixup for
 blk_queue_max_guaranteed_bio
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240625110603.50885-1-hch@lst.de>
 <20240625110603.50885-5-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625110603.50885-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0469.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3d3c2f-84ce-4d10-b733-08dc95099c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Q3VxQkk2YlpoeU1TMXFZTG9NSDdHdGZYclArVTczVnZOMWxqYjlaVlBOQVZT?=
 =?utf-8?B?Q0labVUwd3k3bmJhZEkveUkvRXR0MWpwZE1ReVRXb014ckJleXBCbHdVUUxV?=
 =?utf-8?B?K0hVRjJlSGZZU0FOV0xTSk1hYnV4TFRheXAzVitoMXNOcDBwbmh5TVpZV1E1?=
 =?utf-8?B?RDdzL1VBMWwycE14K0k2cFR2ekFOZXdleWd1cXg0RGVpOUU1S1R3VnphMmpy?=
 =?utf-8?B?SDBpZGo2Wkx4cE9POThiU1dEUnBOVTdINUNNQkRaZjRCNTMyenFDWlB3RUFQ?=
 =?utf-8?B?T2hYNmw5cDdkM0MwVGI2RGxkR3RRZnRVdGl0SU9yc2x3a1pnV1pMdStkVmc1?=
 =?utf-8?B?MUptZkJkczRLcEZyckNxMjl3NDBjcGFzVU10ck1tVUdRUzJiTks2aHZhTmN5?=
 =?utf-8?B?SWxlbDB3blNHVVR1SnRLRjQ4eGNzRmJWTk5wRHJRV1prZlkyT0JTZUZZZCtm?=
 =?utf-8?B?V1NXaHdQZ0xMeGVkQjdyMjcrNXYyRkhoS1NqK3dEdStjMWNFMmRkV0lNWXF3?=
 =?utf-8?B?Tm5ZL1lxSlJhYVRBbnhDMUkrWGJtY2RVK1g3cGQ4OU8xYTNQaStlWDFDUi9y?=
 =?utf-8?B?ajJFclVCdUNXaUFOUU1RLzFMdTgrTjBsRnpSSW1aaFBseTJVQ2wxZG5PY0Jr?=
 =?utf-8?B?MGtqYkJ1d3lzZHNaNktDN2RKTllZaGlRLzBuWDA2K3Y3MW5rTFVxTjJPVGJ2?=
 =?utf-8?B?aitIWXVsRlZHM2xpT3NPYnhQdVFqVHdWQmo4cEJXMGwvaStOR3NzWFEzdjdZ?=
 =?utf-8?B?NnNjT3VnYit0QStYV1VyZE1HQm15Y3NFV2dJK0x0MG5PZmVDdWdiM2xFTmRX?=
 =?utf-8?B?dUFBM1pTQWpIV2Z2SlUrSC9Za21TaVhuVXNiU3RLZUtEcnJsa1Y4QkNYSFUr?=
 =?utf-8?B?WHNRanFBWk9LeUorN2VRNlkyOTc0bW5FVlpldTB2QUhQVUJVVGFwajNXQmZF?=
 =?utf-8?B?YnVtenJZcTMvQ3ZkQnE0cHI1dzN3ZXRZSzRZSTdzWnJrNjVpQ0NFQmFDcXN5?=
 =?utf-8?B?N0JnVkR0bmFOcUo0ZnBUT0lRZzNtLzBRSHQrL2F5WnVyU2xucnJaN0NPMlJp?=
 =?utf-8?B?clc4eUlxSFZ2aCtJakxnUTh5UGU0cHhoNjhabmV4aXdGelBjaGt3NFJ2MzEv?=
 =?utf-8?B?bWxUTVFWMUZNZzIxUWZLc1pCSG5HT3pBRHVoRHpRT3N5RjNRQXoydVo3dHpU?=
 =?utf-8?B?RFk4NnpxN2F3Vi8zb2pqQXRUZjVtZFlNM3BjTnIvQTVaQ2tvUzFQWDhVZmpZ?=
 =?utf-8?B?c2p2NFNSQmd3N0lEYXZQdUZYdmw2dWo2bXZQZllteXM1MTJoV3FLbDBlOHVa?=
 =?utf-8?B?VDNXSWV2MUJqencrV2Q3QVRicWh1WUdEWFowSzZhbncrbFFoaDA5Skd3bm5Y?=
 =?utf-8?B?VW5tcEdYRlB0WVdwamlXU2NIR2o1SWJzbndEdHJPODZkWHNpRTBEd2p6c29q?=
 =?utf-8?B?emx2ZkxDWWx3UFhZUGdqT3NMMERJejdmQVRYdk1sMDBLRVR0cHh3LzFkNmhR?=
 =?utf-8?B?cDFJZ3RsN3R3Qm92ZzJNeUQxUUEvUzNmcDI2dHJCakNiYmhrc2I5NXhWblAy?=
 =?utf-8?B?akhBWHBsaVdrRkRNUVk1eXNTNGY4ODZ1bnAxUzhyeGEwdStyUXliMWdSUDhH?=
 =?utf-8?B?Ty9LSmNCaEhjazhTd1BUOU4yb0ZMVkdhMFVXano3WklyZkpKVkVWTUZuMkdE?=
 =?utf-8?B?OXdqWENBSisyR1lYU1VCOXF4OEl2Nm1PeFNzSkV0Ykg0U3FBVzgvR2JrK0xV?=
 =?utf-8?Q?G5KF5qaFHl1ZWLmpMP9/Lyex9zcYvZS9MopCKiT?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N2Noa3BFT012STI5MC9NcnJsbWZFc1NXS294MGZDUElBa1lpQnFDTzNPMnRs?=
 =?utf-8?B?M05Scysvc2VPYm1SU1N1a3h1aGlVWXdBVGV4dSszTGtFMTV2Smtic3dvWC8y?=
 =?utf-8?B?c0JoV0V6dXdsajVhZ3U3UC9HRGtFL2htVnFpTUdBTS9yak82eEhTcE9iZUUy?=
 =?utf-8?B?WVhZazA0Z1JISGY1R0FDNzdKeDRqMjNWekNwV0NoM21lR0s1STFReU5LcVJs?=
 =?utf-8?B?RWFuRzNUZ2I5bUovRitURXpaenBkZWl1eFZ4eXBnWDN5cnU0ZFJZbWlzTUg3?=
 =?utf-8?B?MENDZHlaaWdVOE16V3RlVFdxU0lpWEtydEdJYWZOYnUzNTQwKzNDM0FEc2Zw?=
 =?utf-8?B?TVRmcmQ2QlBma2k2VTlUb1QwaHovRlV6VmhCZEhTQXJuWmVQaTNLdm9MeFhO?=
 =?utf-8?B?K041QVczTjZCeTJObXozQVFRRXFCNndCMzV2Z1VBS0REcjl6cEI5bHRDa0py?=
 =?utf-8?B?S3RDanJNaXQrOUMxNmxmNnpEa1dlZW1pOGZTbXhxalVKSEdGaTJ2VTBBazdU?=
 =?utf-8?B?czEvNkJJd3ZLbFQ4SVdhSTFCUnpodGgyZGlrOVlUNkhaNlR0T2NWTXJ1RTNB?=
 =?utf-8?B?L1UreE5mRU4vaDVCdVgyUDR2TmdkTHNFQ1BneTNDaXdNMDlOa0RaM29ZMlF3?=
 =?utf-8?B?TXNmUGhnbisxMFpSNENZUVJ6aEF4KzFjM2QxdzY2NXJ6M25Nd1NsY1NlWWhM?=
 =?utf-8?B?RTBCVldWZWRDdk5qOGpkcE5KbXlOMGhiU2xWZEpvK1luYk9TWXp4RWdSOXhy?=
 =?utf-8?B?KzRxcmpEQmJ1WjFqRUNiQzBFam8xeGxuQlRRVHZmUFc4RE9hNStNb1h3azll?=
 =?utf-8?B?cmJrNzBNME9CaVVqMXpUeDd1a3ZmbVFqaUFIUmxQS0VMTTdOc3V1ajljSUJj?=
 =?utf-8?B?bWlieEJubGVKU3p5MUNycE9JbmIrSFl5RUZOTlZRWllvS0pNU01Da3VRUmFO?=
 =?utf-8?B?bUdwWnZ2NTVlazhJemxHMEpxVEE1WmtSK05va3p1bTJyeWN3QlFaVU5UNVN3?=
 =?utf-8?B?emFCdFFJcnh6TUppQ0FEM0NodWlxbVlOQmlNbWdLb1JoWmkrY2VFSmJkY1lo?=
 =?utf-8?B?VXhvMit1enJGUm8yc25Nd21SZitpd2JqZDJ0cmVXL1JzZit4dDRHNjFQU0VJ?=
 =?utf-8?B?N2dLS25XUnM5amNjSkVyczYrMWIzbHc3TGYwNWxrMCswTGNtVVliM0JEY3Fr?=
 =?utf-8?B?b0kvK0tVL2VMSENuSTJ2R0FjenZ2VFhSUjJkYXZlbjlZVHhMeUpOK0VVeENi?=
 =?utf-8?B?WWZrVzRNSnMrUExELzRLcy9lZzNVM1R4amZBcG9IdnhCaVpzVEQ2cFhmckxN?=
 =?utf-8?B?T3hQL0t0UkZHV3dOelhTNXllbFJzZDVwd2JBTmVwSk4veFo2d0t0WXVzN1dq?=
 =?utf-8?B?bWZsVC9yV2x1UFVBbld1dGtvMnFpQ0xmQmE2MTY1cjZueDMzTVVod2hqR25j?=
 =?utf-8?B?djN4MUZ4aG9taDBJZHpMTnZBNGlTN3hDV1g1b3hCMWxwWjRmcGNvWFZ4am8z?=
 =?utf-8?B?NzlsY0dvNGx2eHBzL0tkdlhnaE1DYjVibEZwdmp3R0pwWXJRcFIxZFJXMG1K?=
 =?utf-8?B?UFVyUC9LQWZKNng1eFgrUmlXWG1aeDdBZCtZTTVjNmZWM09RWi9JMGkvS3Vj?=
 =?utf-8?B?TUREeCtkSk42eXlIdmVXTm10Sy9BVkY4eW5YRHhibHp6dXE5VHN3dFc1L2R3?=
 =?utf-8?B?NHVTRmxoOUt0WVN3aTd1cmpzN1huZFZKL1FURmdPRXFwd002dnI2K3Bqdyth?=
 =?utf-8?B?WlJNRFRiQUtzd2NHaHJlMWdwaGlzczhJOHFsQlhKbjA0UXJ1c3JlYllCblcz?=
 =?utf-8?B?cG5DVC9VVUhLeDF3cVRHMjB6TWFsZG01Zk5pZ293NjQxVXN2T2cxMzUvQ1RQ?=
 =?utf-8?B?ellMYWlZc3U3d1Jza2t3QkYxLytNWG5vSWZiNkFrSkwrY3JSMU1mZGduMzlM?=
 =?utf-8?B?djU3TEQ1K3JJYUEvY2lhTGlreEtqaDVCbWVvM1pNRHhpelNGaFU0bUlPSGNP?=
 =?utf-8?B?a3htaXdzSmNkNk9DN296REVTNmlzODg5akQxYW83WFRLdzVpZHhPeEVDemo3?=
 =?utf-8?B?VjFqaCs2NExWODUxaERodVpzMjByTWoxZ2l2WU5WVldmQ2Jub2RtMEtCRDB3?=
 =?utf-8?B?R2hPcmV6b3draTJWckZ5eStkVllvSEtjQ0xsbG9hMEUwNENKTjVrb1NaUEcz?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sD1Wo+LWN4BqRZtqrzl1Bhcj7i/oSABEjsBC7k/IfIcvJdF0xC/i9wQu+fEsJsJ6sLo1w3Sm06Mo6SfVYedejQecEcL8rGoE86sw8tggkcmCP6R8U5Tl+71CJ27/+ggPYS+uLfOxFbZRSLQCw8+sdLxToAlLCWkuHO4sK/++aDcjOs8P4d6WSXqc7u9Js9Xafcjy2S7lhgpNUrctLyuJqsRptZwEnAV3MVrB+DayRYUC82p4wGQDytCZJ64SnBRDHqFTUuAtPYaiih+l7+MOg4mjWC6jM8mudnvgLMxBajO+RSKlyuhmsg/9h4MiEbtKvk8TmUOI0psr8l4/qUAefBqq/HI22emkvbG5jVPjJ9IlT8PhUCky1anHTwU3BK46Nvf9nPRSNVVE21LURYqfV+T5AA6McLYGC7WRjAP0UHozUFy6ai6E/XfxSSKzv36JFUeVbFAfHlbV5F5T93XrrklFLzHHn79A9nL6Hysvnc1JKB1gcs/p67kNDIU3iGsZR9y9GkFgA/ts8dy8K0ckE69S5IhtbPyUilArxDZuNju7cLgw9tXsSkTP3XA4jqIn/QURU5gD8fL6Kh+kZjCPsMSHJaOPWOt68ncdo7QQlQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3d3c2f-84ce-4d10-b733-08dc95099c48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 11:26:09.1402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Shpau6rkuXY2jwhxzoS5VXHS+pyhFtHsmgwe5ErydRvASmaX2w2RGg9+kUC8gSkf2YiAy5beafApE3eLrAsJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_06,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250084
X-Proofpoint-GUID: WExUTwj3uFAb2koBSuRpOggPamP08SZ0
X-Proofpoint-ORIG-GUID: WExUTwj3uFAb2koBSuRpOggPamP08SZ0

On 25/06/2024 12:05, Christoph Hellwig wrote:
> "static" never goes on a line of its own.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
