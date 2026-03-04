Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165D53AEF56;
	Wed,  4 Mar 2026 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772635168; cv=fail; b=NUShrXJZhVrQXsPEaw4itU3F59OiXECa5MMAkP50gKHasKcvzWiHdPZ958VGvdM9Uf+gdTzRR5a43ZCb3fbCZT4MR0CA3mwu0S/DStJKnnqUxLKQ0WAoszTwxpIrG9AwtnVVOqDjcqXhw34/u/uES91sSDMim9MXb+0AQoa1+cE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772635168; c=relaxed/simple;
	bh=20b54UVJjaOuvr1++7hj/H223FYQNUxeMOnSttm2rxo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B0/h+DJ65OHoLkzVGw409Fr/Zt8CJHZypVpIzv2BjrnKyvgJPfMRBwXjygwvvBMadeabVPe34egUyLOX5pABU3sZRrWa5Zgr30PYS3rgHu5jeQXeivqCutwQQBQlQWT15oYQ9td2YTjUB905h3BLf8iVpM4cw/qcAGLW7fkXkCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hQ3Tk/WD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jEUSnEZY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hQ3Tk/WD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jEUSnEZY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624EMQ8U043109;
	Wed, 4 Mar 2026 14:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eVmbSmsLOsNnzB5O95uEys0WC+4RMarmswPRvdynDTA=; b=
	hQ3Tk/WD7XifkRWyy0QidW8OvUNUOWNq+kD51jfW+Jb//qE9dHmzCN8V55or22xZ
	8/fpbSiy5b75ErAVWPPl9c+fNX1VMrOT0nj4fXquMmud4tCngoRk4n01TbW1YPjj
	0wbha2cXL9ERPMnDCr5hJ069gBlZGIIozyCvAxMGA9X3dPRApZSCiJYGkAq/Np1x
	zkmFv+rg7XWn7oUwkITYJskaNMp1pr2mRU64QU1NGB+sukHn+Vnj4msBLR2+JEZN
	KkL4YqWJ1YdQ/a2Rjt7gJY/aKdszNsUg7kWnD3SiYb3Rjsk6K18Hv6ITCndWWrCL
	zVXOw4vbhDSdfkeKEosgAQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cppep00vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 14:39:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624EUJ13029955;
	Wed, 4 Mar 2026 14:39:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbuwjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 14:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QrZXZLJfFfQyb5AMu+b1jxOtGeE4X+JaVg9vPfGD5piVG3Qen3iR1rXkRKlpUHKcNgD0ark7yAkSXQ6FWLPz942zwd0np7laZrBrwCmSwkDZRcp3DMx/nrK0xINMzCcRTk3tV4Sz4br0KRGx0Il61v4GeEdAPurX5oO/2AWVEPKWlp8gvVgar3KWvlBaMfPG/ghF1xxQa8YK+FtsogP8AFhurxlAlvkIXgFivAEVTz0jjear1G3YpTjNZblWmxvLW8xqd5lEBhiagDsioa5pC/Rs3t9JvLl5pXT+Xh4j5qdP3l7D3QXDe3O1gIyLK7H00f+D90Ih2/EVc7rH6BnH6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVmbSmsLOsNnzB5O95uEys0WC+4RMarmswPRvdynDTA=;
 b=FNDjM0oY3bF76Iwg8xsUq5go9jqFO7+PwoggKhOiMw145MI5KS50DLLb2Exv2QBn4j+SJoMtxhQ+Qkckl1RH1UIAdqDZU676twJJkLH6/7cj86yX1G19viRjgydI4Bm+9pJk0AmEQuQ0W+bFFBXETYyadGFRzmqO4OKPx2I5Y3Iy6Vk4R0GgcNP+nA5wG8h/5yd6k/ibs3mP6pSRQ433rHxCkQPmbBXVFklBcxJ0x2psEffuv1lUZnEqN/YvqA5W/F8Qcz0qTXex5FOdBXoGkLnVVAWw05JRysXPPdOdsW7DllMJzEUzKUJ8NlUrQ4896OhDR6c00rwElGjqLE3bUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVmbSmsLOsNnzB5O95uEys0WC+4RMarmswPRvdynDTA=;
 b=jEUSnEZYJnXOZaMpvEaxCWgZT8JP+4PpPi/V3auzV/D0JgEE5r65iVUiw/+LiUFCJz16wv/zJiDHdXqLem2Yu3P+mxTDGyKS3LEzHXIye1rVh9aztRzMJt+ZS7McqQ+BxBTOMf1+Uwf+Rq8Hgu5R7Fba0FHfiOQLbjYLkjiku4g=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA3PR10MB8395.namprd10.prod.outlook.com
 (2603:10b6:208:57f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 14:38:58 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 14:38:58 +0000
Message-ID: <ad42d716-80a7-4cf1-857a-b5cfe102493e@oracle.com>
Date: Wed, 4 Mar 2026 14:38:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <93696b95-7c01-4988-8fe2-baf427469f4f@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <93696b95-7c01-4988-8fe2-baf427469f4f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DUZPR01CA0181.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA3PR10MB8395:EE_
X-MS-Office365-Filtering-Correlation-Id: 042bc054-32d0-472a-b00f-08de79fbc503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	+pLAbOsioUHZ89aGeCAYCnER1GcSAgDTk36yWTG4Ry3kn8zcqrjtLPP5hPcQH+oM1ky9n+c7UJXZs9FrbJkLiN2CsvkBVzafEStXPaGogaKzcnDf9W/NAiaEgpk5Baow5mw18cbAcwZAexSVHXY9YdQlf4BIr+zJEgC9M8aLOXetZX2EBBOj/z/Z/1ieA8P/euciwOqlKT9A2/lRaliIFdN98sjmH8VRDE7BP50bXJcEw4sn1iO16+GaS5iwUlTXAXcZOse7sFC4Y7w/XTEE/PVKP9kSeTf96IWiInm3nFJTI15MfdhSNsJFBd8b2cCH6xdl8KNW9DTW4P+PRHPL3hrDXDmvzTBlu5wd9UvrC7pVbyHAoTOwTb1O/Y8PovhIDJ3sCbt00rJ1R04oRPunPZWcMBnGdzmIi6ApJ1nxjn0r9GgMbt0JHbX0ufurUMSngTP6FppvrC3Zh6sp9cw8KStxXc8/FejVV7kW8+rGscs8dhmWXywhKMCyCcRPd+BUOSs/58NzfRfMEyej0fs5uq73AwWiSVMIALOl5ZZHP1+yeq2mNfINfBBpoDKTq/oBMQ31ioDZbq34d5dgqHe894T3m6WhHPLmzpE1Xa8R8XXxWbirHPid0997CyWGP0EkwARBHnNcamBhY+fLKrvCPWSDi64p5KJWBZqyVYo/JRt+JXH+XN1GlAD0Q5h0OFLwafrQE7fUmftbWZZsvSF9HsuYaXDpDp2ZctIidzn4eSw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTdEMzF4UHFqekVQY3lPREZXajd3ZVYzY29xV0xiWGpVcDBxVnJzUXZWUnBi?=
 =?utf-8?B?YnVxRzRBUmxQam14UWFpTmUwUzJiZ1lJUEhpd2ZVUkwydzVlbGJRR1NUNHZF?=
 =?utf-8?B?OFdUaGhIUnU3UHgwT253OVBUd1l4YXNPbTRxcE1JR2hIYzlYNVVoN0taVnZB?=
 =?utf-8?B?MkhTVHV2SFdaM0E3UE1Lb3FacVdHTzhvMUh2ZWpTUnNvVVNoN29sa2huS3dz?=
 =?utf-8?B?Q281SURzMEJ5bXVwUFNCYVJWT3lMaDFNWkVZZkpJQjFFT3lTdVNjYnRFcHYr?=
 =?utf-8?B?bjczc0E1NUdOeWhqMkVyTWd3M0MybzF3NVQzdDk0b3k4MnpXUlRTSlR2UWtn?=
 =?utf-8?B?SnRqK09SNUpZU0l6NVF3cVljUThHb3ZQeksyTlhRQ0VXQUxkdm50WEQyVCs5?=
 =?utf-8?B?QnNOQjh5b1ROdXFtOEVZRXQrN0xWSElBbW00NjBpbjZEenpjc05lc2Q5QUll?=
 =?utf-8?B?N1BKbTBqdFhLZ290S1lMZUdxa2phcXM5UTc1YURXMHFKemFmd0JMZWd5RWcw?=
 =?utf-8?B?K3hVeUFNaDNEYW9PeHJOcklROVUyNzF1S2ZHRGVIdW9ydzhzVXp2Y0VWd1RS?=
 =?utf-8?B?eUVPMjRWMTR3ZE8zWVVqK1JXeXJqZUd2WjR0TG9qRHBkdktHT0x1d3ZmRXd0?=
 =?utf-8?B?ZnJjbGJiUHFVMFJNNm5ObDlSUWhwWnBROWcwU2tzU05WZGlUNUlMcEVXL0dH?=
 =?utf-8?B?OWp3S1YxalRqaWNxVThlWnp5NWN5Q3JCYVJ4VVpoQjlDSTRVZ0ltSncvUmhn?=
 =?utf-8?B?ODVwR3RWaUdoYzZEQ21PcnNHMzJQanA1R1hkSkFUU3JrQkZiSDR0bFhJbFpn?=
 =?utf-8?B?dVFUdTA4aGhnd1ZUUVlHZG9obWl0Mms4ZGVmLzduZEVSdS9iTEVhb3ZxcUEz?=
 =?utf-8?B?NjFveG1PTmo0ZkZrbUJqbFUxUlZYTEdwdjJ4SnhEKzBUVWw5NTVnODVQZjZI?=
 =?utf-8?B?aGNKSDlkSHgwWlpCd1NzY3kwT01WdlFnN3BPaWE4azBMSzBmeFgxam9UaFk5?=
 =?utf-8?B?OHAwYjhEZXN2cmd1YXhuQWI4ZVh4YnZKYmtKbmtpKzJXUjF2K0FzSW5EakE1?=
 =?utf-8?B?RTA3T2dxblVtbXlRN1lLZGNvWGVncFNydVFjNVRaOG1EdHZXYVNJZ254SDlu?=
 =?utf-8?B?QmZkNjhyMkZwckw5MXljbWEwZWR3eEJnS1BWTnlISFFlUGpiSDFESWNubFJG?=
 =?utf-8?B?N1BDM1l4dFhzZkpRS2g5cTVWWnhCUVRaczJNdmtucmszNC9oOW5JbU5jODdI?=
 =?utf-8?B?a1lLcFpLbmNKMEpwbmc4TEY1V3NNU0dKVkVxL2JwNXBnWlFMOUIvSGZNK0Fx?=
 =?utf-8?B?cDk4OFgweFY5L0lPNE5FYWl3SUEzSWRnWGVYNytkOUY1b3ZkMHMyK0xEQXJ0?=
 =?utf-8?B?TURSeGo4TkxHTTRsbzhOQmhDWnloRXVBS0xCK1pYQlNGTnBsVG9uUHBMR3Vi?=
 =?utf-8?B?Y0ZHejNMYksrTmw5Rk9XamxrMWY1cjAweE5qeGtzZlVvMEtXek5OM0hRL1lo?=
 =?utf-8?B?UktrK3FZZ25GTnkyS0QrbDdaS3l2cnU0VzZsbnpHTzBSeko2ckE2SzBLdVVq?=
 =?utf-8?B?a0pQckFFeURxUk1zNFQxeVRmOE1xbXNPdk9zVHdlT2VmVnBMa3ZVQll0TzlP?=
 =?utf-8?B?cUQyVXFCNWpnUDZuZTh4akFEKzNnYW9VcHhVYmJodlI4b1pwVUZmV2pnWUJp?=
 =?utf-8?B?V3dhYWx0WFNLLzRaV0RSR1liU1gzc3RxZEo3Z1ZCcjNnMEtZa1ZhanRsVEdt?=
 =?utf-8?B?YnBNU0czVThDRXM0YnFwdWNSS1ZmRnk0L1B0SmpxZGZTWGZhSFlZQkN6S01o?=
 =?utf-8?B?Y2xyRjJiZGdoNVRSamZZb212R1hvU21jMy94RjlkMzBsazhadU4wRW1jZ0hO?=
 =?utf-8?B?MVd5WmF1QUYwMyttRm1NZ0pEeS9Yby94Q29aTVZha01kWGlpdjRaV0RUTjhW?=
 =?utf-8?B?QUNxK0k5VnVqYmZMWDRHMzU4eUxBZ0JsYlNIaEZYOGxsZUtJN3dvbnVIeE4x?=
 =?utf-8?B?OE1pQ3lHM0U4MDlsNFRsZHlYSERidnFhVVlpMjgvdWlGWWZuby96VFc5M2NN?=
 =?utf-8?B?VTRtbHN6VEpxY3YwNG41ZFFQa05FdEduNGd3aGpYR1NNYWREdzRTV1drcmRz?=
 =?utf-8?B?M3dvbU5YRzhValpwdkR0eExlaWVOZWJXVitMY21CSll1Q3k1aUFoWkowNnc4?=
 =?utf-8?B?MzJ1V0ZrdHFRVEkydDF4K2tMSE41Q21KLzl5eENRYmQ2eG82RkZ4VDc5UEpY?=
 =?utf-8?B?L2FSdEZZcDV1Tlc4NGJSMW14LzhHcGkvV05wQlFZNjl3aCtXTFVwSDNhOHJV?=
 =?utf-8?B?cDFXZVFrdGJjMHU4ZVVBK1FMdWlOV3pqeGJoSHJoYTAwV0VkODlmdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	raH5dpXqMuyzTVcRY3aMT69zI/7t43lSiN1k1nJpoMc404qNHcZAIsPo2Qw6R54k6bIOyn3mCsZne1moI6AHljfiKFt4goOm4cu9LQ6x5z7ChqqyYEdH3aZnYyTPBdnkVzCX+rqka1AcBtuEMt/x76h6yzAn9mVAYu8Hz4qLmN6SZZUWpAMlrOQp8FeZ33tvkdrhcZkeaXPNaIfaluQ6SE1PcXb4lCLFpZbR6LUq6TGB5slqVuOraJ1gR2vvLZosaprF1CCvvXOr6x9y3xrMp72vIkczc7OffgxOFZmH3F5Vf0VIdeH8OBsrvp42id5Jy27y+12LqVmbPHh5OCfVSV1FfNrB7kZXpZU0PMJnHOdfoQEljeKmeV9yf2ojmQ3zUVCiUhU7KdMp8TJQMNzcHKYnOdgR1KTPEm8ccm7ZjJrBBrF9d6rTlqG+2YFuMX+LwQf5o14e84vJqRfi0EXgFU8QYckk37xFYuWWGcujfkgVudDAILVBacHjc5l6BBqPukAakUorhjzHh/cdI5cDB5fzETVXdHQFPOlz4H33e5M88R+8t8j1VAfLddQFITRF7v/2+Gn/lRo5Pvo3FYt711JZFV/yJRdSmbI0qg+u8E4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 042bc054-32d0-472a-b00f-08de79fbc503
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 14:38:58.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvsJCA8sUlQZq7HTkmpu6VL5bMqN833qsZ2laIiiZBwlVXhOQ8W1AxPnnVFYNRQxnv8vqF3Zib/K2uOikPmy7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603040118
X-Authority-Analysis: v=2.4 cv=fvTRpV4f c=1 sm=1 tr=0 ts=69a84406 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=LlNk8V2oR7MhWMaCBtMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OmdWbXVxPfsGaTOy-BfR0gYCKgUifGyu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDExOCBTYWx0ZWRfXwyvKGakn9+g8
 tAGhqFIOKMMN09kh72JcHowC9EOorPOTu+TbUZHObdGfD/0SeqywvNNIVUNZkVm2M8c60AMq4ju
 gQREdSbZVLl4uWXxmE/VkxfZIHpCSH1kG7AlfAUc13zmG8j0ZjzcReuvCZ8rUPZFL38wRi4Moa7
 xOSkflvp2r5ftN/qWJaZjPixhxEXDaxoMwjWsW0vM47EIB8OqCCl82UcNNiAMI1JBX9UO0l6viD
 S/UsJVYRdypHUQtcqf1GaOG1xpvYEaeR9fq311fbmBIYmBS/CRCmkkCnQ8rzttWnNBZDC+Vz9ML
 v1SNQAuXVIAp5UMAynPq+dj2NzA2DzeTurnSnySv+yLxp8w13Oi2v/jmonrs32LAlje0kxSfp1i
 VM2MS5jzvrWVKc3kPvXEoryANjJ1otHUqv1YWSDVkJr54bSPX1SL0U2W0SB3B7vKgH3L50ZU84B
 B+vxZxcp3CV2iRPUQDg==
X-Proofpoint-ORIG-GUID: OmdWbXVxPfsGaTOy-BfR0gYCKgUifGyu

On 04/03/2026 13:10, Nilay Shroff wrote:
> On 2/25/26 9:02 PM, John Garry wrote:
>> +static struct mpath_device *__mpath_find_path(struct mpath_head 
>> *mpath_head,
>> +            enum mpath_iopolicy_e iopolicy, int node)
>> +{
>> +    int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
>> +    struct mpath_device *mpath_dev_found, *mpath_dev_fallback,
>> +            *mpath_device;
>> +
> 
> I think we should initialize mpath_dev_found and mpath_dev_fallback to
> NULL. Otherwise this may lead upto adding a junk mpath_device pointer
> in ->current_path[node] when mpath_head->dev_list is empty. This may
> particularly manifests when a controller is being shutdown and
> concurrently I/O is forwarded to the same controller.

Right, I see that we were doing the equivalent in __nvme_find_path(). 
Will fix.

Thanks for the notice.

