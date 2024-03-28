Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927657C08C;
	Thu, 28 Mar 2024 10:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620662; cv=fail; b=ckEMPBcjQARHcTr321mQlyhtbGntEnpoeYBIvdLTm7IxH+iGaYo66RK1okwBYrYhM2std251NzOrxPY9WOqpnndWKktki55tnE0LuF+C+cXAbOZn76sDMFN6+6fNAw0MOPfacUjHtEEtHlY3K3dSwuwjQ2njPWM1G+lbLrl/Ix0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620662; c=relaxed/simple;
	bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RxSeErEf1dUXRUGW+MoFlfH+WxbzJJrA08n09jPlRkG+y9pCJZXsnCy4jIlW3xtS57DCH8nboG/FIgXSNb6umQORCIUPfdfwk6jGBXaug0LLMS7YUVw9LV0mAx/msk90AoS1o7cKf11mJ4gpOnQMYJL6r9mwm9B+wIe0ISHFSDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ut2E+P5N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pTdl7b0X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ut2E+P5N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pTdl7b0X"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42S8x2Nv025134;
	Thu, 28 Mar 2024 10:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=Ut2E+P5N7wCTOFVHSMIHpsy1m1UrGPeemWZDp50TlP9S5Qs3QkDW7BXOjXjv+C5ds1f1
 +mhQJndWarC7ttRlOecSH/234vG3gn7oVNB0h1lMqx9ZGuR2ScyD6nBmSGoTh3wBYWNZ
 lwZxlbl8y+JBzgMyHqyj8LYY73w9OsM0QI9RsDa7Tp3PPNt4VccUXGdeh94kf1bC0PKV
 N2YMBlU0ALy94c+TDY6Sr0qVOfuK26r3ucYOg/SXWrFrYXxBp3qyuB5raLaytD6Dz79k
 aF+SLMa4MpZ6M+pZOYD7EYmZQzg1lIqN03eYOkVSu4ABitHEgkD4C4M47KK/9XT2oaO6 ng== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x4cxy2sqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 10:10:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42S954pX018161;
	Thu, 28 Mar 2024 10:10:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nha060f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 10:10:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhR/867BLffOHu2a4+4IRVc6kQiOG9KMlt0IiqgKe2PJynm4pDrPy3jTZCa9g8M9dz+w1KfLsVyMx4IRhbMskT8V8Zxh03B1f6pIQKFyT0NZJF+1BHtKMT/M9yCntcXyouYGTCg+LBquxyviRSqU3dISbtpK1LrSr+kkyHZe8a3Axk1XaUgBsusnkEDPrk6bVTqU1uJil9CUzVFrheCvaYqzL7BNDTondbWTzx0f2aZoNI7PmB6RdJ/9CcUB00416lobvpOVS0gZMJKLNQ4DcqwsrR/CBT2uPosrqiZNRlXO3nd2BbIOwXTPwWAiDIOPbHGSPOsj9u1IQ0Gbd6yD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=eWc3cvTaYw+U28XZUA4BfEgdxK6izl72ZD/aF7ILXKI07uMGn39gbDvrhcV7HIGP1H8CNcgu7Axzr6FTPKO7kKLgDRdd7qiGSKT/YJrDR+pFYavzvWiWio5BqL0/iOxdD0f/t+A/dxNHj4AihdivuN96ponrXozpyBR28cfHdavnqMPW2FIupxilXXNgRQ7WImPkGqeEkTr8Bisvtx6DQp1F3ZfbBpKrIVeVwc2yi8tTpme9avPOqwQqQ+PePDYINIRVMJ1SLrzknkAV2c5UocivJ91rUgKBv42mtWpniExzm5b4xFfpfjHFf6O+LSNBtO19B6Rluz0vQTWJsmwmWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=pTdl7b0XD7VdV6SceMHHOUp8tA+ZLUSE90VP6TMa/NXsyrDLX+i95LStjtTilbcZQ2QbJL7aDv9qHdSlNZhnfviPY5VhURIuyk9BT3Bnf/5AFUEut78ZeayUc1UGmXKLnZDVM1K/K7N9/2DxlsU/q5rEVkzWVgr2l8fX48NMhpk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7105.namprd10.prod.outlook.com (2603:10b6:510:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 10:10:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 10:10:03 +0000
Message-ID: <72f03a03-bc15-44b0-a394-1bb80c884323@oracle.com>
Date: Thu, 28 Mar 2024 10:09:56 +0000
User-Agent: Mozilla Thunderbird
Subject: Re : [PATCH 23/23] block: remove now unused queue limits helpers
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
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-24-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-24-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0036.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: f0cdbb02-589a-4343-a943-08dc4f0f3c57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	x7YE5gWF/nxH+HDoPDEl0ZfZCWweZFuJcJkOW1TGvq2ZgwJPnVXLZBYOGVL+ozUnHcZev+VyDp9atByFsbjKwYEiWxfWX1XRrz0QB+yogJ2jIi2jA7Q3V1L3BHUgckFvxeLSkwpitdXae7spVUlchPLbSvQgb+oKg28AyyIIb0PtvLmO21nl/8umLRGV9TVB5CZiV6lPm4pLLUOHnZv3gVUsH74vJblATuFudsfYmgNI3NNGhTU+MtwQPWU/QTSn2nCq64dGd8yGzkxMRjKUixom9cRCF2xwSLH9egB1UxmS9zq+EmoMQpFQ1D6A1/gPq7UD5ui9IYArbkrkKAEKlAmbv3Vczz8UkGiwRiAfVhTH2Tn6H55521MqqZz3EfNLdMFz0zMMJdYiFMbEHb7PsHH+skLaOQ5DRtFmuBnuDqvIHLXDhgPwfj6Nz9cOGLwbpGgjZ63qvx1U4qrMDMvMREnd5vSP/o1vqNx8eSN0eNAtYNnUCrEEHKMjBxBfGy5yb3pcack/DBXufmN2B/4jZI44ez+I1M/vcqXpjn0eK8sN9Wvcz6iDX1aANYk8IWnWxyWTnTOP5TatYA22pGRTiB0AI+thei3nqMJGJCVMK4eWr1JCoOwSx78krRLHPYhjYYoQH8thlDqTGbOxML3UxCRDMUgeEIVsirzjqEae+5g=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L2NLallTeTBZZ0hIWXpvWWFsWUg1ZEh1UWt5bkU3R0hqWGhXNXhTTENpb2R1?=
 =?utf-8?B?NmRENkhZemZyVWZpeisreHNKV3JNQ1hBV3o2U0RQWXNqbTF5c0dYMzFGcVFm?=
 =?utf-8?B?U0hnMTIvS0k5RDQ1UVJxOGtQelI3WWJpYzU3NzNqKzRyWVFiajVzc05hUklL?=
 =?utf-8?B?Yk40V0kwdkJORU5MWTgva2lrNk5wRUFCNk9WMXUzRHFPVDR0VVViNlVrM2Rr?=
 =?utf-8?B?T3YzWDZPRXZueWpNbEltYVQ3OVZXYm1rTG4xRlcya095aGhyU1FCMFdxZSsx?=
 =?utf-8?B?RDJQN09ldlFTbGhvUC8xY1pCRDNER0tLUXFTQUR5U1V5NXR1MjdXNUpiWGI0?=
 =?utf-8?B?RDlVSWNnUk9TcmtCK2J1U2VFYnZCSjcrcDZiM3M2VWN4cjNSTG96aXRPdEJr?=
 =?utf-8?B?ODF4NnUrNnh1cVFVNG9oaS9PeS9naFA5SGg5dkhIQ2dtZHBlTXBUU2pvVm5h?=
 =?utf-8?B?S1ZFbnpOMndYVWFYSXMzNlZsVmpicXhqNDU2VEZ3U0RzaUsxdGtZeTBiYmha?=
 =?utf-8?B?cFJnWTJtWkJoUzNJRU53Y25CUzY2WkZyTEUvSFVQYWQ0SklwaUM1d1ZVSEdY?=
 =?utf-8?B?ZHFYanRnUnhlVlZ6UVhPRm93QlpXZmprQ2FqT2ZDVGV0OUVDdmU1VjJPdTFp?=
 =?utf-8?B?TUJKcW13NDhqM2FrZ3oyZUtmR2tUZzQ5bE1IWDdmRFhDTVR6dkI0Q3hiU2hq?=
 =?utf-8?B?eHlVTUs2YTBYeVJYTUc1Z1kvMWJKT3dhTGR2R2dTY1V5SDlUMithUTdNbTFS?=
 =?utf-8?B?MDViMmhPOXMzbDlZV04wRm1qT0RpV3p2QW5xYXpuTmJkRnJ0b210bEduVmk3?=
 =?utf-8?B?Y0pBM2pSek9jZU50SnY0WExRYVdQbVd4bzUrYnNmbnJsNkdmcE9WYUsrMUIx?=
 =?utf-8?B?V3ZFQUtKZWMwZ3N0eDlRWDh2emVnakNvUG1mbnhuMkVkWTFwdThwM2hiQyts?=
 =?utf-8?B?OGtTbzNZWE01VXkrNzFsT1dTSGpDc2VVRk56VWFSZUxON0F2MHVOcUpXcGNM?=
 =?utf-8?B?eEtsbHoxcndHZHUvMU9LZ1piUTZzMXRUTmtPUE9rU2svZlRzbE9kUER5TExv?=
 =?utf-8?B?RW9nVWpCVnRhb0o4cTd1dmtyYmdBUlJ2STU5QUZETHQyMU1EUFZGWVNrU3Fu?=
 =?utf-8?B?Um90Ri94eVFBdDA0TWpHZ0ZpckFXM001blNFZmFkcEtYWEJYTHV3eDc2Z0dV?=
 =?utf-8?B?T0UzUnphZUNJYzMxZEdqTkw2QVluWGtBckxEcTh0WWxWWHZ6Qi9NZ2htRnZW?=
 =?utf-8?B?ak9rUThkWkRXL0l4cFdpMnFkNW5aZlIyVXFnbW9pT2JVK0hRbzdOeVBoQUVS?=
 =?utf-8?B?bHAvOGRHV0Jhc002YmswWnl6MTVNTEY0dVh3TW9GK0ZTdnljZ3NLQUpjZjFJ?=
 =?utf-8?B?QWlsZHFZOXN0bU5DSTIzSDNSOUYvb1RLaEk0WExnV2NvTTBRMGZuekhyaW9D?=
 =?utf-8?B?OTMwcWFVcXJJajNGOU9GeFlJYXhHc01HNHd1YkJYVENRMlZFM05acUQycjdN?=
 =?utf-8?B?TW5hRXo3MmlkYlpyUmQyMFFkZ0JkWXlTVkMzbzVYMWZGNmFMSmZtKzQrc1FO?=
 =?utf-8?B?M21CcXJpMjFhZ1BWbGpsSHNVTG51UlE2WXU0YkpINE1lSVIwQ1c1Z1dGY28r?=
 =?utf-8?B?M3MvRVErUzk1ZUgwZ1krdHZtZHprV1lmSitwRGppT0lNM1BrSTNRNmRFaG1D?=
 =?utf-8?B?U0RpOU45UjFPM1BWeG5NY2VaRW81ZGh0MWtzUWE3ZElpTHJyaTdUOW5nTmRV?=
 =?utf-8?B?NU51aC9EbGw2Q3BUZTZpQTk2clR3eUs3aytkMDBvRWZHMHErVm45SE9CSFdm?=
 =?utf-8?B?RDloTWxiL2pkd01ENHJwT0JKdDZSUS9iaXBaUGlyQkQ1WWZSbUtQN2Evem5M?=
 =?utf-8?B?SUg2ZVQ4YzhISjhaaEJMZkpNZnNMdkZjRVNnRUZJQjNJdnFBQnJiYi9YZlJq?=
 =?utf-8?B?NWx0eDN2UGp2d29WRGJHZHdvdk1RakRCZURJMjlDdTZtOWZJSDBlSUxPc3Fx?=
 =?utf-8?B?OXdRNS9vck5lVWh2U2lDdUx6VGl2YWlMbmg2SFYrREEwVkM5L3BBUVBsQllz?=
 =?utf-8?B?N1VIODR1dWJXSWx3Yi9HT0xYRlZmd2dJMThBM2Z3Y3MwQnJ1OWlGQWZ1dkdS?=
 =?utf-8?B?VW1jb3phS0lRTzJFTzZNbWkrdmxBZU9CRzR3OXcxbjZLTThOMkJKREZRRWhl?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jPtexSpjTn4+mYwciDM2WioVycpbOxpFcHQi7D/ke+QoexWFYbO3+3P1ZiJLWeDwur8UDPY3t1oA73dD20PRWeQcu9guznO89F5x3ZEWEKRa5uYjlyFiEkD764iN2ps9KD2HmlsZGDKuCcoMm9tjkJ3boQ/rwScQvEN9ZGPxsLtDsHmbmNCO0nfb935oZq6c6rrZJiTL4SxQVasNhCAOvBINvKA4xVxYZpKW+fiP4gIk2o2CYhEWHPEdxoIHfH2Ltw5s/nQNE9MBs6s9CQxWPI/1++QWjFJjcRqQRsnvm6KbXWuCbKvQYrku5sR7Q8JjAMWDQRT1wBsGzmnCxTexbfbS1+U8VlHo0/uaiXmh6woNcWPUc5sOHiu3rEhWbQ8KQlY5Nd2P4/6L8hzEKaI+kN6PHVVRBLuxjI4/LBXoI5sjLu30KcID8ldPKt7AV3D7pL0QigIRhciS1AdrGAHWW7+V206rYuqmMACL9yrBo8mmkIKh140vL0ylQzvC/BG4fwLXEtrs20NxBhjioQ+OQYPZytgdGYu946AcZjjeECy2VHBUB+cF5y/x1BZpKKCe0vDm5RpzRS5ZajuSr3rkU2Z5Rcs4gyxW5g8RB/mg8rE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0cdbb02-589a-4343-a943-08dc4f0f3c57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 10:10:03.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VzZAMp4XOdpvAk4y7npueQzAvlCurIopq2EUEbDZueuBeGf1dU8TfMmIvPv1am+ym2+xNxhGOa4pAF8kfyjxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_10,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403280068
X-Proofpoint-ORIG-GUID: H12af_13klj4_BH02sb3Yu4cpyUBC73T
X-Proofpoint-GUID: H12af_13klj4_BH02sb3Yu4cpyUBC73T

Reviewed-by: John Garry <john.g.garry@oracle.com>
