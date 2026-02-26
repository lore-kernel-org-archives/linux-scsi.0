Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16150276;
	Thu, 26 Feb 2026 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772096708; cv=fail; b=Vmo7X8XT2rPgFSZmaMyUorCPVcgIkeRh7xsSkDavHSs0+E4Ly7ThtkUsR2koLwPPMnv2rJmqZ3JXqCv4VeKFWIy9wnGYbYLVXrnwyrIAeMMR/FEdZVepkzUGxYw8ayax5lq0S4I8g9b5VGof5Z9ZQtJ+o+bWN8D9rsiPcZ5g80U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772096708; c=relaxed/simple;
	bh=4mnOYOsy1zkoEi+hKPwFwE8TqV9DglBbvR+ThtvIfow=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SBY2J+kAhZ0JyWxGcX08O7xuAaWqEGcV2dyY5BWj3zReO2DowIXaELzoC2s2o79ccAfP7uwJVvOSNkGb9SacXrM4YpKRiiUikSEFSp4gOK8g/RIp8lJ8DFZe5n1Vn5D/Yb2XFid9RDR9poVq/veTAmaro7/FssHmzHIvd74NRAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PGNmgVdv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NfV75wgW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PGNmgVdv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NfV75wgW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q6Vjtq3623735;
	Thu, 26 Feb 2026 09:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gG+5iaKagvozjpn86ngwMsKK9igC6azMqrZbUpEAPiI=; b=
	PGNmgVdvhsopPyTOQcDgLIbeR+wmTGs1t1v6Y2+AopQEJ4aHllPbHiFlVHUUgPbY
	KmWBFMyeyw2wAFIuoDzyERu6p81NvWDp0SBin0JOoB3yPsXKM5coOux1C68/wegS
	8OG5qJtOgTvtZKynXFIYpZcTGDnAIDID+XYoOwH4xPnuy2gCsFNekebei9ptxMW9
	haP3DbcHi2vWGvpYXVnua3UJB3C6n6FigHKi+WqeKDVr4/6Gb1pPWDnh6aquv+Mv
	AArMYcDNwyQk5sDEF0zl1OJmT41yVosXGel4sxKolhtTuN9MTROulgplLwq6oGCl
	j+jKnfpN/WQI8F9d0FTzVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjh0185yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 09:04:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q916Iw015713;
	Thu, 26 Feb 2026 09:04:36 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35cf1cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 09:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eXDj8aSD4t2Xk0NKZv/RwsW7XGeCktHc4pcLc7JzcdwrUKNUPGQZvbPGvN4JgTYzNlVc0plNTrtQ/TXACGteDQEIZdPcREOe46/NBHlTvqadbhjqU2wq1S6VVO/vl4JfnYIPo87WYghgddU6d+NJsKkqgxlEsgmTaCVXS9ivS/RPYiGShqV5FgkLoeeqPsLVDa0+Yfyj1HbamiBPuYE3uaDrzl5YzGp2IO5l4kTtaFw28j9zldjYjlDcd3zAJzKzKmMsYK3jSefvpEWJmVPvLYX7T1aCM7U24PY0q/FAXtC0+zNICmTPKTQWOOL4B1D0yFS4mElGfPaPvP31V3hqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gG+5iaKagvozjpn86ngwMsKK9igC6azMqrZbUpEAPiI=;
 b=B9R/Ffm9w5lWRpEa4ggZNWhb+pqWByZ6WBR1wbHPdHsJCQPFP98nULiW4sl04s/V4Wlw5KMhw3OYD57PrkRpb45GvRsiQH02RrhWLHr1fMjyHVQy2ZyqDMQtThAuRga9VDanvSvGNBrFsAc+cuZ4bJtWjs1lQCnhP8aewCPYgJdiCYI0ivAZX7GDLKvw98NMPypt76+h69/doWqHyLG1nx2jVJhF6i0yUMt01pBZAmIaA5jXW9lNxnnEECG70nSsicxXkdIpyLKpP+m6ozQR30yo3hCZ1WFf8cRLZzZU6b3jjZikycT4NYZ9AHbY5FsDZZI81xB0nrYk5FUipM9AmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gG+5iaKagvozjpn86ngwMsKK9igC6azMqrZbUpEAPiI=;
 b=NfV75wgWzmo1JkPGEHcyKWrAAjX92fMpcVYzlFEIYfqYQ9KbC4szWtVRsi7Y2+u6U5TRMTwZi1uorBJbN+7jOrrZPwr2X2hGI2OSiGZ1n3tHRYyhGsPX8RIQCIfmisP+CvBnyHJlJWTug2iJRmT6IvBZ8e48Vn9XCFfdbuLfaic=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB6959.namprd10.prod.outlook.com
 (2603:10b6:510:28f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 09:04:32 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 09:04:32 +0000
Message-ID: <3c60deb8-91bb-4db5-82bc-54d24fe063d6@oracle.com>
Date: Thu, 26 Feb 2026 09:04:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-3-john.g.garry@oracle.com>
 <aZ-s-JNWBOA1xqVG@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aZ-s-JNWBOA1xqVG@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0223.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b54e13d-977a-45ba-8105-08de75160e5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	hGp8nZRCIwF1pVRY8+hHu50iaHgAPvnMfy8fh0QNlZ/R5Pg8BD29RdMOmnjwQufhCY9pC7QesTrdzY94dla4w+dgrbZxEvkhdrb24WuG61lbdtuNhMmIZDlb57PtJOCrZF1epccANLr54xzAdPc+Wq3EtxOltrkxht9No1z02/aTbl0Wd3FRSVRw0U0CK01xkiJQie7nvbIp01xphaS1ZT5V8ObB7/o9MuNKqfwCiEFVgFdIcSfKo6gSXr8cfNPWw61gSzFkf7EWvsVcd4BQZwefpvyINFGKpbzUD40P9yfvKs7Qdg+8CWO7a529a1P0NFVAUGRqOzxrDUpZ5eb1wOOVTo4rF3ystvZRRvESMHCwOV6Jz/kT7gehEwKAupNDLQP4O1JdY86fLpghQ8f77rH9gc1Lz7y9Pk4GXwfoht5YdHV93i0hNvURCR1DShKvTqo4wzd+I1Foc+q7KF5z9QWU3H8L1WFafDfnfw/QpTdgmWfg6TRd/9xAJA508ESN/UoTHxHUNNgY+YbR1d6TqjT5feTuJinRQhb+CXUERtMGH+KgP6PzqFnahkJ/R1cVLMSfIZMelT63bNkcWBaaxbRBQ7vziD5NbJZ+SPieO+qQeKZ5WbVMR9Wyq7rrqz7ahPemxCDuWe6bmUkIaNEeuxnILHdiS3bwNBwrE5dnZ7Gpo2+5omVOGgvqDpLlF4HbeyWbCcTTeOzYfhog7k675JSEaw0lfQxo8jMh7g92Uz4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0llRjFzWjlXRDJCc0VMZ0JiY3VIZ0JWV1R1cTdhUmZvb0dodmtnMlViNERw?=
 =?utf-8?B?YlJYcjlCZEFkcXdQM1luMXdGUUlqdWZXR29IN0Z4MlhHRTdwU04xU09QY29K?=
 =?utf-8?B?dnJoRFZoY0tQT0c4dDdFNU1oYzBabXdmMlNXVEN3ZHJkTURyWVBuUzdrb0xL?=
 =?utf-8?B?ZzJNdGNjSFF1Y2E5QktGeExrQnRyYUk3d3VJYW9GY1BjYlQrWDRUMSsxRFB6?=
 =?utf-8?B?eENZeFZPQzA2MHNQRlMybHhzOTBmWTQwVXdIZHN2RzFObTJLQzl4YnNGQWQ2?=
 =?utf-8?B?bkpnREVIQjlxQzRsb2w4N3VUU0djVjVRbzhKMlQzdzlQSG5yZVFTSGNiNHpU?=
 =?utf-8?B?R0JFcS8wMDdpK2REdUpaRkx2aUtlOC9jR1kxUDRIVllNbEtKbWRoRkFkeDdM?=
 =?utf-8?B?dDdxcWZ6R0dPNGtNSGRnSkhvaEdLR3MzVVpCZ25rOUd5b3VWWjhaVCtnRW5y?=
 =?utf-8?B?K3hUaWlta0hYTFZaSk9XVC9IaGNBYzBvV0s3T21wZDRGa0xCdEs5dnBjdmQ5?=
 =?utf-8?B?Ymo0WkxVbDRSR1orYmF5WDFnZkp2ZXlNTkI3SXhnbGV2TTNzSTRFbFNKNW9S?=
 =?utf-8?B?c2JPdkpmQ0hDMEEzUjRyUDBLNStDMzFXUHBLcDhodmJ3citGQ3NORE1sNVR2?=
 =?utf-8?B?Q0FOQ2FzL0dtbExuaGRmSk9KZnArN3M5OXpORmxmZDVDamFxSFNyUWpadmhx?=
 =?utf-8?B?WDUySVd2djZXMjRjN0Q3cS9xRlV0ZGNyMW5pTEhnSzZMbzlscDBHZDBVZ3d0?=
 =?utf-8?B?dzk1b1lYOW9GbzBzbnZGUkY4aTQ4bklSVlVsdTYrSFZhaTdtcUFxQXNnWW1T?=
 =?utf-8?B?dC9WcTk5OTJRTVVmM2RzV0hQSHVRZUZSaUNrKzVlM0ZsNjhIVnRXekt0SE1Z?=
 =?utf-8?B?U2tvdWtNcWduRzVGajMyVlBLRWRnSm5zQm9aRkcxaGZZa2Z3ZVNzay9YUTJQ?=
 =?utf-8?B?clhES2NaclJvWFRENEZ6YmZWK0FaYnJxSDQycXdscHpyY0hDUjJTZTV3bGFz?=
 =?utf-8?B?dUxkZTh4TDNrc3RmM2JvbmlWRFRXQWFLTlhlNnI3T2NNSWhoZWNhZ1FyMSs0?=
 =?utf-8?B?WnRKQVc5bEQ0M0EyeVJrKzZMd1lScU4rTUZORmVKUk1WTFRFbkdZRVhEU25s?=
 =?utf-8?B?endWK1N4OWZmTm5LbldZQXF2d1ZqNzNNVXFWYkowT1I4QnhuTEdlZWFvcHJt?=
 =?utf-8?B?V09xdXI3Vk9Cb0daV2dpN1hSQXNjTFBYQXFJWjdQQXlBZmJDZ3l4L3c2ZHhy?=
 =?utf-8?B?dkhMcko0NnRwL3dJTHpaV3RTMmgyV2hvR2lkeWo5QVE1VjhYc2k1Y0JyTmRF?=
 =?utf-8?B?c3dqUzc0ckcwTDVXOVh1eVlTMG9DcytYSkxoQkdtVVh2bEppbG1nOWpzaEpP?=
 =?utf-8?B?K1BFanMxdVA3bzF1eFBneGJ4T253ZTlZSlUvOFpqVWxHOE9kRldBOVRDY1Fz?=
 =?utf-8?B?bEFuR3kzTlB6YjV3RkMzcHlPV1NsNDA3SS9LRitYaWZZUHpwTjRzN2NINnlE?=
 =?utf-8?B?UmQvQXdYMUdsbHpVbE1xbzloRjhoMWIrT0Rhdi91aDF3cmdaN08ydTYrVnMr?=
 =?utf-8?B?T09EWmh3ZS9mNmc1NEw4aXFvQjVOQkxlR2tJejV1bjdqaTVuSjJSSVAxV29L?=
 =?utf-8?B?dHBwS0x2RVNkRkNtUnJKS0w3ZStLeVNBd1Nua2dITlNSTndkbzd6Kzhxbm1s?=
 =?utf-8?B?UUYrUVYxTDhIU09uUEZkRjVQS2tGcVROOEo1U3U2VUlZeXZ1MWV3bGJEQjNv?=
 =?utf-8?B?Q0dHZTE5LytQQk0yZ1ZtaGdkWkxBNlZoMGlhMzZhN0hzWlR5TkRmTFIvTjZR?=
 =?utf-8?B?RUJQN05zVDdKaS9MVEFsbDQwY0pHd3huM3p5NDZ3b2tzb3NvYU5Qa0QyeldB?=
 =?utf-8?B?Y0NxVlUyMjVpWFNEa3dPSGF6em1uU2ExS0tzT3JRd1Y1bFdXS3NyMHdOM3o5?=
 =?utf-8?B?MVE3NGVBbUdLdzhsN29oY1BoZGFCdWVmTHk1cGNtTEdNYkFVNUJFS2hDUzRv?=
 =?utf-8?B?T1VaMGVwQU9sV0NVK2k5UDBNazN0dzcyd0F4dUhlcmRiYVRuWmJuVm5pUGF1?=
 =?utf-8?B?T2x4MUVKaXU3UjBjRm1VSDlYdlR3V205ZFMyRm94ME1sak5oRjJXYzlla3hS?=
 =?utf-8?B?S0l3Q2NMa3Rnd3VpRStZaUx3bjQ3UDNJbUVOMG5qc1JYUmdKb3ZuMkN0ZThl?=
 =?utf-8?B?bDNINUt6V0lXWGxZMGxqRVBrSkhiTkE0NUFQUlFSa2RaMEFmanczTlkvMjFS?=
 =?utf-8?B?MEN1Qy9zNGhCMkdFc0poVU00cFpEUnF5MTVieEZCbW0zL3I4TUpyaGlBR2V0?=
 =?utf-8?B?ZDV6TkJZeUxCNUdxN3R4RlU3czJGZ2FNQkhJRFpFaVkvMkM4TmVlTHQxWk1Q?=
 =?utf-8?Q?C5KrxJwIIMS1opS8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IeyqNBdrDuZDRTIyM5k7Dezd55elwvroO3tYzK5kE5txdmrRhzgqKvOKrGLOvz6sZSqsVtAFojC87UXl3x4ioTpXwj+y0ul3I5FTj2jKDUU67BObuvspWh/g+/K9DGM+D3zLaG5S0kJTUJ9K4srEyfExFuqficUA8zQm2g6pA6uMfYKhr3zac+YTq7qd0yJ+Z3Xe6JtfImEYq3wOF5ED52e8AtT2A7ZIqKYrVDs7kru8XawKTqQOsKtB588pt4oC1UwmhFy/qiAp9sValP2EG8AX9GJWhYzKFD41gpgrhN/DEIK7BUVgD0+yEHPjDoDGkkxgNfFPtvyY/s9PiLDhSNwVO6ug58AnJsfjhJBjWnCpolL8yZQcymGmMZGGIE4v8WiSILLs/50q8VDEI/8bu7XZ+jAjfZKiD+muJWGcJp634QLDr66cwXVA7C6iq9PxvsowApv4StEq94uTIOYSdygtQZmwJzp339jWsAZ54sRpwr8xyqDZHRrl6ahQ+aid+mOCQjCllskE7wwNK8KBc0baNGPS3t4xnka25nXPcpHt8j8P+WtcE28vMHED6SJhMZ9kXcOy7mBRzTfxLKEXDtUBQRZX+QJjcRvcU8f+NUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b54e13d-977a-45ba-8105-08de75160e5f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:04:32.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOsETQbsLMIYghQCCM91iUkd3ngO6tfBEu+Z4+p40E9ER2rQBpuYWB4ZUwjJFVg4VX1dxK3a4tpR5xUmkN2VGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260081
X-Proofpoint-ORIG-GUID: dOSPwjyjXnhQKVT9DnJ9KEdUeZzkrc4q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA4MSBTYWx0ZWRfX3EnpKJvOnIGQ
 UWWt+Prd45umORSAg/WksRjgs0Pa5MRSsqSA1HUlCUsxoE+k83HpuDGW9SknGyo8uk31ilsQC/s
 OSmC7rE6n8ZWTl4rUvdxgk6qhAwuBC9qRNv08mfspv8lwgN1RoTnm4lf5przLS4TldQJJxO7tGv
 xxtO1bnqyNNVnfpx7W/TA+49mydJyCTMQvX+pUDuOx8LtaMQ94TpBN9FCtnmkN8oBuniKiozq8i
 kfY0HNEINg1QC45szoCBYaT50ijVvjYUbB4vATWMamDpZ45OtmXO3+K60qO38xVAcTXawvmjTZb
 YhigQGwPc9WfnIg2b+4fhyLBCsYngLSjc7hxo5yg3AahCdUB533SK22YBeB6s46Wuop06D/IYH+
 dE73+AGMusKaejLSSozkZ/QDzUPoccLvul9NU/dF72TZ2wKGHluJwefMRBcx1upKwO9vpHC96zZ
 BQAxl4wp7d0/SO7F1OA==
X-Proofpoint-GUID: dOSPwjyjXnhQKVT9DnJ9KEdUeZzkrc4q
X-Authority-Analysis: v=2.4 cv=D+xK6/Rj c=1 sm=1 tr=0 ts=69a00ca4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=HSF5nhWpIdoevg0J88cA:9 a=QEXdDO2ut3YA:10

On 26/02/2026 02:16, Benjamin Marzinski wrote:
>> struct mpath_head_template is introduced as a method for drivers to
>> provide custom multipath functionality.
>>
>> Signed-off-by: John Garry<john.g.garry@oracle.com>
>> ---
>> +
>> +void mpath_device_set_live(struct mpath_disk *mpath_disk,
>> +			struct mpath_device *mpath_device)
>> +{
>> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> You're dereferencing mpath_disk here, before the check if it's NULL.
> 
> -Ben
> 
>> +	int ret;
>> +
>> +	if (!mpath_disk)

Yeah, this NULL check is not needed.

Thanks!
