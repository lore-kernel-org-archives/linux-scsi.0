Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0835931280C;
	Mon,  2 Mar 2026 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450390; cv=fail; b=KXBulHCaYZpqAJE2S3ci8XVdMFnBvLRTK2Rt9YojIY7EnDgdc+WPHwGrOP1qrDqdNouDWhVRUK4C/dwvUClDN3/93Fr5l1rlLe1yMtZx9jRX80ZXbUOu171++wEuCfch90KOf5LsfXmHN4KhSpehZf+PAYgm7d2zbs2P/vPlMxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450390; c=relaxed/simple;
	bh=nAzyoODuMphHTTnqO4tX0iZsdEjtvT0l73SZVaN2i/A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z339qULPOiWotH1jhX2JPB9BW0W4gJO4bRgRif9SfVvgh5Sii2u86TQhaRnZiWQVOCIrQCQLAilt+/hjBrHdlC7Us/h6gNpzSmn+NpsNj9Kj2vtl9YKbNZKfsSS/R4cdZQbiX9P0SMijspcVxzAr4EJiyrGktRulGfYTJpmFFyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SYUCeHuM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZsmYnDDy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SYUCeHuM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZsmYnDDy"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622AVXYH1425937;
	Mon, 2 Mar 2026 11:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sQtzb0xz49fQWwqznDYcOgRwpUpl5sVDWGFfMS/qO6M=; b=
	SYUCeHuMs3dQPtrQdRaP+MBT3NsowSQLL730LBtBUJQIcysuylNMGql5AP3bHOni
	HB6RH4YJjrWootfOmG0bgs0L0JNkr0hiKxPw4tLIsMT2PYZqNBrKkMIrMIx8kj3c
	9NMEpkZoCtpH9qf1oFWqQ0Ql6uyqUBk6QbRKr5OeVMXw6DRkbUOagevVzNF0O4tO
	MortQYol9GpaTQqnDaaoH6S0QBj9L7vyaS7m1qkCGSfW4cMx0/mtr/g2cLY9pWLL
	NTGgFGQLJscEzaLWNfoVsw3l5plA5nsrup4/3VekliKjzWXxow7jP3ytfyRKTIc0
	HexJRsrMHjsLz8wCsLOZvA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8ve81w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:19:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6229NQA2023063;
	Mon, 2 Mar 2026 11:19:21 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd3f07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xv71oBbR3gYCCWs7Tc4uu+lDH8hHBp8SbFuvzwsHD8BKUTO7EVLf+HzpO3425Q3hvxW7hUMaZhXFMbtp208iMhMTq4c9+8hBFTV0E2+ngEmB6ve2IPC4cLmgAqaxiVjtxdg9vxwv3aHejPfGucgCOiaMwbAS2R0FFjqyJ7BOzST5IT/AXwwcn4sEnGBX3xHnNDJqjI9jNK9RrNgXDbUfjH8/fO+6gKXm0+8TTqWWTGQC+3D1AUIe4PI/bQBCCNeNXYVOqYAnpAma/OpN7xKXTij4GEHVFOUlVNku0EipAgFXJ1JVl9HjOs2FF83DpQvqyQnC4yNceBJI+yEo/xyuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQtzb0xz49fQWwqznDYcOgRwpUpl5sVDWGFfMS/qO6M=;
 b=iebV4Bfu02wmbHvnwuhDTm6kTEarfhtlUg++IXrNgx0FS048WJp+V1vaGlAJ0Dw/kr469bi3AyAoAkyg3MhXFStqyS6Bw0HQBwRcr4kZk1o6XB6N7slYFDkCD2TF8OUANT/5G8FC4nMq8yk1Y1cL6Tp1WOotGHjUKcX5g6Hf2z0we9dUZKV7MiFyLJGQqxYpTg76mm60tNMYXnwIUCk+AYHuAaZbx/tHRJhYwAYF3R+cm6GWlqPw4eZ67o5uSoAuaMKNcrNEUuRdGqypkfFx6FZzBW+bdvqD3urlPNCzKdlitPm5NYnWofgT/KBhzYf89itNA6Z5/2rYeRjk3LCOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQtzb0xz49fQWwqznDYcOgRwpUpl5sVDWGFfMS/qO6M=;
 b=ZsmYnDDy1emXPbHAw243cY5CwDfzijNgZXVAX942lJ1kAZbRncYecX6YJmFxCOiW8QlHU7PACyA9i99HjZI4dNiVvaKhNBWIT8wOGtQDMDfBXuOGcLLKk2gjpjvZ5KkzP4JWI1fMvosJPsAp3FbiUc3mhqAPk/IfBr482y6YE20=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB6797.namprd10.prod.outlook.com
 (2603:10b6:8:13d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 11:19:16 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 11:19:16 +0000
Message-ID: <2bdfda2a-07c3-4875-9d50-aafd56f5a35b@oracle.com>
Date: Mon, 2 Mar 2026 11:19:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] libmultipath: Add support for block device IOCTL
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-12-john.g.garry@oracle.com>
 <aaH18HKCMdjuUhUh@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaH18HKCMdjuUhUh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: f22fe312-9be9-41cf-e20b-08de784d8a93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	w0hYLAe/jnmWdFIGGibyGqITaDOQmEQ+k9G3dSnYjbm9gHh5PuRgo7hbxyT5Eu6qLM0eSMmukO1NE9EDnySf5CHc8zxAXJk6yWs9RZFLFVvf5CuOVc9F7GK1eFq/WkwPG7JqAXNLA3rjL26U3dcywamzWqTZ+tMgrZ1OYriL3FSskHeLUZPeosxqLz4+yzdVUzRWd9MnAhBdprkr9TcNOxwxl6zx57q6iq1d4DuEuYFAkEGhdf2jAFSvw/emqfsppbYTQnomKneln1fI1FPKQUGRc2na4s4Q6BbgnNqRUvSKddYezUlvzn5944KnktZvPIzyri+U3jyV9/yOqU8QCo+bFWLg9ui4iSvtye8DiYz29Ch+3ZFY2RBHdSS4HP9NXRbkVatLEiaVEmWotUt3SmAwzgmY2O2Dw5XAm8SOJmIMyyU/SHXQRkFUJzStzaQgEoFtiwnIaaBdR6o7fcssMc7IXqMh8dFa7R0YTFntxixolu5iUMCMdk7SiUrm7l3e23J/IJTuEKLSxtDb8yIen8d/I6OUnWMHquslIY+RQQJh0GzxaFpX2WVTyjRhdlH2hqnGYt4mbKmH3kPQ2cr4CGMrczushPyeuuLZzLkJyvBguSKrdMzgnYNprq/RKG8hVwroE+3xZZj+kKfYqB/8OPiqAsiBEPCzqruiuQXfyDc2UcPfFFXL8ACrufQFeZHlvTrqPEge4duMI8nErOF+L7Grf1pxhjn2dsV9VGgrzTk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0VwejRxa1JTVkQ0ckMzNDVJVk5XVThGb3dTeEJuWXJaWkc5dklURHQ1OG85?=
 =?utf-8?B?Y25GV29OUk5VUm9IREg2NVByZXhZVTNoWUVHMGhuMm4vZm9NdnhvK1FyZGdI?=
 =?utf-8?B?UUNXVlFDUzA5QXUyWlBKdjQxSGFSQmkrR1czYUJ3dlluWjNSVzB5THl0WmMv?=
 =?utf-8?B?VDVwNW9tcmhlMkpzYitBTTBXaTBwNG5GenQ0d29EcDZxRm81UHFWQWtaMGFJ?=
 =?utf-8?B?UzdiSmozV2NYcTFUa0s5eGVDTTZjaFZuTjZjeDUvT2pyZjB5cXQrVE9IWHRU?=
 =?utf-8?B?cVdBaEJlcERnRVpGZThXQ3dFdmk1Ulo3R0hyeG1UM3JNcnNLK1JFbEpDc0xj?=
 =?utf-8?B?eTcrUGM3N2RGaFJzZmNVdXFzT2pwdWV0VHprV3lFTDJVRUZJQUFzN2k1TExE?=
 =?utf-8?B?UFphbHpsYmMvQ3hVd0FYQWgwMVQzY09qTG9QdFNEcFdCTG9hMlJObVUyNitG?=
 =?utf-8?B?bW9naHdaQzR3eGFPVkh0MWwzT1lKamRHUUxOWnF5S0k5SjhLeVBPdnpvMW9O?=
 =?utf-8?B?MkpWWUR5cjk5N0loZVRoWW1NZXlreE45eDkveVNmem4yRGR6YjBTNTQzcC9Q?=
 =?utf-8?B?aWh6Z2NTWml2Sk5IUi9CdFkza3VReElwTzc4ejRoN1pQYy9acVd4QUlpYnQ1?=
 =?utf-8?B?b3BrcFZWWFhXQnF0bzR0UjFJZXg1MktlakpnVnBIMStJa3FrcjVhOXVrT0lC?=
 =?utf-8?B?ZkpkbTJXTXhuNTBJc1p2SmJrUUxqYlZRaHdsM0pFeUMzOXlTRGNVVVJlMktW?=
 =?utf-8?B?bSswaDFUV01LUHZDeTVTb3I1bG5vcFFYeFhGL1FrWUR2Sml5eCtWK1c0UURI?=
 =?utf-8?B?bkMrTG95WjNTNXdaQjhwdDVXc3BOcFlsWVZCY09icG8wMk9wRGhWbnlKMU5T?=
 =?utf-8?B?Z0hDdXNYQkVqbHlLZ0VpL0ZpVXJTWXJhOU9ncCtGSHd1SWZTbmo0dXZBcGpZ?=
 =?utf-8?B?ekVjWEovVHpjMXBnWnhuUlFkQVpuY1Z0OTZKV21oNm12MFkyTVNUVXVWTXRN?=
 =?utf-8?B?c3VuRVRYbWFoQXUwVmN4RkoyNjJpN2F2b0I5Y3VHQU56S1JxMDBiZU1lSXZD?=
 =?utf-8?B?ZmREZ1ZaQnBxZkloOGFNNnNVcWppZ3R2U0pGNjNSTDdheXA5RC9xZVIrOGtI?=
 =?utf-8?B?Sit4VGNFWmlpRjFGbG1lbDlTakQ5TDFLRkoyRllobDBSZlFCWjRyejR4TDFZ?=
 =?utf-8?B?U2xlc2QxUUU2NXBRRXd5UG9tTWpTa3RvVEtjc08za0cwcFZoSy84bkI4YlJ1?=
 =?utf-8?B?aE5zdklUNGU2K2dPQTlYbWJZVGwvWEdSSFhTSUVNdlJ5YXlBQ0NqZ1Y2Z0hP?=
 =?utf-8?B?bDUyMFdkd2p0NXNraVdkMVJxdzUyalZnR0pqWXMrbFRabzlkakdtdHJGczBF?=
 =?utf-8?B?N1daOWx2NlNIRzhBaGNWWGtMT0I5bXBzTWFnWSt6WjdRU0FWZGMyYm9MNmtY?=
 =?utf-8?B?OGllS0hNOGZwMlJRTDNGZEJMM3lMZHhOTG51NDFpMGlJcGlDTlFsb1ZLVGM0?=
 =?utf-8?B?c215N0R5TlpncWwxK2wzM0IvNEEvdXhFVnAwMEQrdEM0Y3lHRTl2bUZIcHJy?=
 =?utf-8?B?R25VNktZTm9PTTkveG5kSG5RTThYb0ZUaFJ2cUt5bHdoS2RZUmpybDI5VXpO?=
 =?utf-8?B?VGdZK09QRmp1aEs3NkJRN2MrcXZUVlU4VjlJNWhzWnFvelVoRHM3NWYvVFhP?=
 =?utf-8?B?MmhKbjJJYVFEWEFZd0RwZmlzRUYzY3gxalBycTY5Wi9WMXFwakYxWmxoT292?=
 =?utf-8?B?c2NQWERXWGNWQjF0dFA4S01Ta1k3VHArd3NZeXlCemdVaG1JTG5zVzNUVUln?=
 =?utf-8?B?cjNnYXR1RU9FUWdOZFhEWmYxVUs1Z0JzRlZ3WFoyT2liYmdhb1AxT2xCYXh6?=
 =?utf-8?B?MG0ra2JJRWJ5NFpub05jeGxDVWloSnNHai9udmtrcnZtSFNEL1FuaFVxVmV3?=
 =?utf-8?B?UWJNWTVKR3ZNYlNTVmFRcHphWnlWQmlkL0h4THNhQjVWNHF4WVhvK2hlbHNP?=
 =?utf-8?B?cVdOL0k4NXBhT0VVOUdhOWpXSUdoaGZNZ3ZRQXNjWitvQjBrbjZYU0hHUnFE?=
 =?utf-8?B?UStOTmlBNm5qelNydnVQc2pORGx6c1ZVY05GTkszTnJqS0pDbjUxWEFMQ21i?=
 =?utf-8?B?eVFFdzlYckhTUWROK1NZL0tVL1lOaDRGSDNON0YwVHNjcWVEUmlCaTRLeGhS?=
 =?utf-8?B?eVduY2FzTHZ4aWNYMVR3OEZuSFp6UkxxNHpDWVlycjF2MXlCblYrR1JmQlFJ?=
 =?utf-8?B?RXExUU5nSHhaSzJFb2gvdFdSUkF2VjZGWVUzRTVxZnZrcG9ac3NRMTgxcHk5?=
 =?utf-8?B?cm1TdnNpQzNKTUpHODlTYitHSnZaOW5HQ01XcHpKQWhoK25JcnZvRTZhUk1H?=
 =?utf-8?Q?nRc1G8wko+8SCiws=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uI//YUosYiWs+9dj/mwAKztLSgnOgqiCmx9sTArALsB87gO23q/spNcw4hvgjbRQBliIobnPk4yFwgiN1SaHmbu9l0jOcouSQCiYbDNHHBt/+/1LrTGVGtgYBpTdtO5ILzlsZb9ty90qT8XLgAirDDyOdGC27t0opiznlRInaUvwxVESXhsnh8kZjg2yIoOm/bU4bvdNQHSUyNTjEsT8EbV0SrSyBDB16NJhk2j0UXEd/B4gx9Z4PROwanlyzFJxAwBhAc75m9aVvQogiJ7KSthSyiKmQVGLfhgrGSgaEUGvGwPNhnhwMw81DNpV+4rYpyqQyOHdPn2X31EpYxYZ+ZhrtQqlhNJVKa6cKeMDecJJ+5nLXU4ymewLp3XULzFr1UhHCaj4sv79Q9erYjSJBfHIUgAFI4ituQOfCnLYdYjLZNXfzZ11r28d5uZbw6iiN/JqBcPJBJlB9OW7ZjZIo1pZwUcZqHiOxzdTp5LO7MTtuOaL8LYlvo9wyy5dQUQyr1Bw4UfLvXR3MjffYCkkSwgg4cmbgcIna89ytrit5Z5GUI/uDH1IuRRk61A0U8cj7Ip0hSt+dLQxfdd0qoYGqIB+XV5E7PTy8lDTZoRmBQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22fe312-9be9-41cf-e20b-08de784d8a93
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:19:16.7051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqB69FFLcup8JQ4G2AqKNsKD2YZU5FTTcrE9vUB6lFk+Z4ixDS0hQZW9KPojdhy6fCykNJeYuFrNM0bbHboOvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX9oC6my2CCr/P
 jUQ1Ii9zpyocJUWM3Hp9aU/O8i1QA2ir8n1dHCVfIeFL88HsQhlt17+MvQ0vdrzb4Kis/tEjuYN
 1cl72yZm0HREkSCUQWsR0sJqyIGSoP+Xmj2Rsr9eGF44LxRfBEqE9fYpXufO/wtg5Fzw4l8waBr
 SlW1zlXLQGSv7FDFyDOIYJxVeESCzNK9qOnIAPzIiYe6Uoctc4KajdugDOtYG43L7TThIemIa+l
 9dGOtrMLjCdV2SP/awdVzKbKbgCBur+dbVB3kdHn3QsMFoWz56o8JBjbvaIrDOeGKSSEvMMdL1d
 Wg7D9jMTBoV/O8O0P4+Frwrgnc5tM7UCFF4FJ2Wp3A2XPAHuqNCNh6Et0Z+HgICQmJgR9KTJwS4
 OcgnQQwqiePAA6JlmnDs6OWZRtO/LMpcG/Tkn030rlZf1zar1/Q4qLxoakZAUODJKocNEXTfxGW
 zsPB9WZEv5znG5LzUaYDRIi5VUB3VpBoqdySuDrQ=
X-Authority-Analysis: v=2.4 cv=B+20EetM c=1 sm=1 tr=0 ts=69a5723a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=TIgWdhF0bLA0GjPTJWkA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-GUID: cfthxjM0LJrj6f-svKH-CYNEWnyDeC6F
X-Proofpoint-ORIG-GUID: cfthxjM0LJrj6f-svKH-CYNEWnyDeC6F

On 27/02/2026 19:52, Benjamin Marzinski wrote:
>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>> index 3846ea8cfd319..40dda6a914c5f 100644
>> --- a/include/linux/multipath.h
>> +++ b/include/linux/multipath.h
>> @@ -72,6 +72,9 @@ struct mpath_head_template {
>>   	bool (*is_disabled)(struct mpath_device *);
>>   	bool (*is_optimized)(struct mpath_device *);
>>   	enum mpath_access_state (*get_access_state)(struct mpath_device *);
>> +	int (*bdev_ioctl)(struct block_device *bdev, struct mpath_device *,
>> +			blk_mode_t mode, unsigned int cmd, unsigned long arg,
>> +			int srcu_idx);
> I don't know that this API is going to work out. SCSI persistent
> reservations need access to all the mpath_devices, not just one, and
> they are commonly handled via SG_IO ioctls. Unless you want to disallow
> SCSI persistent reservations via SG_IO,

I want to make the multipathed /dev/sdX behave same as non-multipathed, 
so should then support it.

> you need to be able to detect
> them, and handle them using the persistent reservation code with the
> mpath_head.

Understood, I am going to check this PR handling further.

thanks!
