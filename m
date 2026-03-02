Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E73350D4F;
	Mon,  2 Mar 2026 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772451595; cv=fail; b=beqWo7TFjW0lvgqGme/w3hgN8MDSYm2Y7rQwGdMDNCkQHyd7WouXsEwDMUEWRHuC5kR5K53Q+Z2hanhpOFbrPEwQxnRESM0HLdk1nJJX79fPFp9u22YwqPvnY8I0BcHtdwuVD2FDpV8bfLFA2S26luCrRnljMrSpB5IdxOJNOhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772451595; c=relaxed/simple;
	bh=NrC0cGg4Jhju0z7LFjt+3g1xdtYSs14Mr0Gg6yWU3bk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L/trcXuuRvx5TQbKM2o4DcuPLtfP+3efjvOUvj9+kAkED4sNkPhARua3cr+wChKhcHjjF82+qSecQJU2pzfhTDlRXdOzrxqtT7460LySjkYRvnmd04h2/ScA1n242J/rmzq6icn0wb1uwUqXLTggm4s7sRwFhMzGCsLosmOfEwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G7KFNJ2e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z3MBqnSn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G7KFNJ2e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z3MBqnSn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622BGXPh2067173;
	Mon, 2 Mar 2026 11:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HDl4OG0H44dAeedi0UNS9XsMs7FUuYrc3SoEAXLCv/Q=; b=
	G7KFNJ2e6Moo34kI6gcRIT7Jy1vyi1qUNrWj1TwmH6c7TetjlKB0Mp5sQWWad5yO
	P7XxK2dIT1KndRh0ZfOzjgwYQLxJPBc9G2sGrgLd48ce1ZW7RmccUQ+4lbpr8fUF
	LSDk0wF46J+XQtyUKU9zt8iZcAqZiG55KkVC0HGq3CnHku9Ez3Rmp3nDetfcDpoR
	arWEAYeUMphSPXU5mbuGi9M0HVukidWpZ8VDcF7WSwmuauIV+9+t71CYlKFJkmYT
	6mmFgauH8LrW5GYxdJrNnpaXYy9JWynpsRgnxs1CR25FSyXpPojHAjxNCTAnO877
	5L04G9lojzJ5rJEHrFOibw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9hhg0yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:39:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622BdRdJ036974;
	Mon, 2 Mar 2026 11:39:38 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8jb3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=toLvgDNmIpsQGnvAKekKYY3r1CgCOmB6gkfcYviTqASZVdEZA12GMZrvsUbU3gyg+UJXyFTn1eGPwwT3eDKhxDpuihnSHzRPeimuiw7DDrsUdQU0XLRyNiF7KPKkCXa7ARR54cGpceq3IgEFNxHivGwSMIH8qxD2RGZYj1fS0EEopp9uJhszoLz9EFu4Q+aCG1SUjo54lPClRKCQIhUVO4kZfhhVfKqAHxo/wIAt17rCuEtMbKJ1xmouvCbmcKTOKRx6I5I69r6+HooahY8VgtAv5VvTpxF5Fr0H2GOVa+5AuttEtb/Swf24cCeDySAu/lo5/n/zFTBAXPbolwFbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDl4OG0H44dAeedi0UNS9XsMs7FUuYrc3SoEAXLCv/Q=;
 b=Zkb0oo4HeZaHoWgpwjepaFQ9I17FCHdZkg1AXSst+XoUQfVUzE9SXt+J4DHHEYOc4dN/Rmmrif0nq1E0YmATGa5BzkH0FjrDmfisUFaVrbIUSuM/DrRLOj8mBMAMxFAPNzsz2GZHduvMpObzqoWxD4BiYbJ8q/UCV4wB64ve055xVOXd1F/hCC7AZviHNysHA59jPe6N4Fyt/F2oKoMsIFaLQ0o9+Qg6AyB/gwDoxanPk1N7k27TggMPd7fHD3Hq/U2cXLb8qjSCKzRo7cPuJz7Z2qYPRPwN8KHa9bq8Tp5mDuTUBsGqILqkXhSVtErDt9oswPJCXKVwCSa9tzobqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDl4OG0H44dAeedi0UNS9XsMs7FUuYrc3SoEAXLCv/Q=;
 b=Z3MBqnSngnhk++Zlc8ukDXxYg+QDxxJDFnawFr4HI342uB8GYjCtRVeOLNn4m3gZT5js351aGzf1jkwgv38voLB5SEjR2rNl5l5OdT4/iyWWjmCiX5mY+XXIQlg44ATJqnu85eBXLyPkk8THVrlTeQPrhdKz+6Yors4P0O7TuqY=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SN7PR10MB6979.namprd10.prod.outlook.com
 (2603:10b6:806:328::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Mon, 2 Mar
 2026 11:39:34 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 11:39:33 +0000
Message-ID: <784abca8-9dc1-4fca-b72f-62d55b4cc3f1@oracle.com>
Date: Mon, 2 Mar 2026 11:39:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <aaT0Taxs6WgX6m-j@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaT0Taxs6WgX6m-j@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0387.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SN7PR10MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: af9356f5-e270-4d56-578d-08de78505ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	AQfaNvJ9gSrr6zYM/NkAFC9KBGyEv/rRpG9oWe/K7orz8pm80quRHFf3pmSSMfIBocRhK08MKIn4mgIPOHI7s22DRCBLAbfaMBXvtN7+Hue4qUsvpW2wLvYz9kazPI4CKhtK+YeSbxGINqBT4Gz/YPN22hwvQiF4JJQEbB5ZlgX2iSaAA5NThTuDWfVA4WSEW4Tms9UvgX0KtNubGXTqWC+sMweC+0vn9mkUcKLNRcX3MHYZ24YUjsLUir6wYto0MBTo/oYVJibhwH6cjIQPKYDKSGFBJqAm7RdKUb/guaRGytoQ/8KFgtx9bJiW03Mxf11VWd8UUnrwOw8JzqjbHZyZaVYSuqhkW/VeAsStfekeiS9Vo+4U0NOk9IACZS0JOkXK7j+QyKcB6SiNay14YTX6phu/r+ydYN9qVw+y3xyKqIc0FmH4UMGO0jEjP+qNdG7ctBgZI5RMEJ9+d1Wtpzy0TGGi/tIctvcQX6qRv65/n8ax02euq8fs6Jqx42HomRP7vouMrH7IG0aT4o3U59AK78hhLg5eRf3Vz18PQJHD5iY3W6IudEMACV8W80MvNoc/FcR+TWR4IUei8Iy9mVD0o0Sg7eC+vGwV7VnwFI4dH98zA/Bxl31AOcEPqEef2jz6X1BehhjnDC2w8lTwUpLHeLkTDSA+1zHk8h0XPfwooihAYm+G3eJtkFKjnNQE5yfrAe61RmNr79cbkMbKzvS16r6MosBnDY4mAqfU0Cw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUZxcWlHYnBmL2dkQytxeldaUGdzVFlydExxSkVuL09ya0FFU1piNHBHUGZH?=
 =?utf-8?B?WjcvSW9XL2VieExmbG5jbXlmZGN4andWTEZsQzlNZnFtQ3FLaXQvN3Q4bnRm?=
 =?utf-8?B?ZTJYVHJ0dk0wTWRiaENrRmtWaGRTUnFKN09vb0dVc3N0WHkxaFAyalF6OWNH?=
 =?utf-8?B?WEVGVWxqY1dEd3dQMEFGR1o2MXIzZ0d2NzZoSit2MERiazZ4YkZvTW5lWHdW?=
 =?utf-8?B?N1BuNGs3RUI2U2d4NzhZVG9uWGJUYlM0enJaTTZQMldqam56MVN3Q2lqenpl?=
 =?utf-8?B?Mm0vTEROM0RQOUNXRFNNV0s1ZDN5cEFnYUVmRjd6SWpLdEh0U3gzelJRajA2?=
 =?utf-8?B?NmhheWh3U053VlJJcW9vTjJobU9WL3Q3bzRPSEttakRFa1lkSDdjZ2VnUEla?=
 =?utf-8?B?eTRURWs1RDR4NVhVNVNjcjRGVlpjUjFPL295ZGw5ZGhhbUpCZS9jOEdwM1ph?=
 =?utf-8?B?WmJjSEdaWHc4S2daZDdkRXdkMXYxOG8va2FEeG5sazVEck42ZGpZTXlrazJX?=
 =?utf-8?B?YW1oUU5yNHBjWWRjTExkTjMxWWxtQmIyVEZxZkZnRHZ5RzJhd3lDWEROQ2t0?=
 =?utf-8?B?ckxlUHk1OGErbkI2S3l5Zm1QUk9vN29Ka3lHQ1dQaDErUHgvRjlZWGVFQ3Bv?=
 =?utf-8?B?K2hDcXh4ZGNrK21IMjNGTkRKOXJEYXJtMDVINjlCNFBsdS96K05Eb01LSERL?=
 =?utf-8?B?R29YYnJIdHVpbzN5d3phaXgya2NWMTQrZEljeU9iOGtBWGRvLzNYNjdRbWlV?=
 =?utf-8?B?S0dVSE9ZZGZrTTVPc3dmTmd1K1VRUzVRVDQyQjVsZGVFelJOVmE4YU1nY3U2?=
 =?utf-8?B?SjZlNFJTZ2haSzFVVzE0NXFBMlEzcHZBWnVFSXYvZDZpTUFULzd1R2hEa1l1?=
 =?utf-8?B?NUIzZWxmR1ppQXFDM3ZQblZWUGxkWGlXeGZPTGZIL2xFVHp0Y1VDRjhUclJz?=
 =?utf-8?B?ZUw4RDQydTNtbzIyYXlQc1RQZ2FJQ241aXNyMnpUUVphWFl6Z2xRWDQ5bmVY?=
 =?utf-8?B?OGJnNm9pNHh1L0EzeUx4WTNyUDBnUDFHY25EYzc4NkVDUVZjZmJ0dDFJV09E?=
 =?utf-8?B?MkpGU2tKWlB3U3g1allIaVFDc1djOE03OGNNVk54ektpRWI5aVJBU0R1MldV?=
 =?utf-8?B?TFY0Y0hDeGRIZ2hXT3dISXlFdUFrVkE2ZmxYdzZMa2o0Uk8rT3JiUm9aM2F1?=
 =?utf-8?B?NDNqVDVuaU4zcDBnTytuSzFZMzBMUHZMSkpWdXVKcXh0SkRsQllxbUJEUzky?=
 =?utf-8?B?QjcwcmxWQnJyd1dhejdUZ3hkb3R6SG9GV1NVMll1Zmp3ejFZcjZJZXRORUJH?=
 =?utf-8?B?alFZbkhWTG1uODBMYUFMVTh4d0ZzVEZkcHpmbExYUDY2ZEhhb1NMS1FFaEo1?=
 =?utf-8?B?OERlNnFseXc1TUF5VmxvSFRGZDVNa3lHUWM5M1VjRW1CeG1vWTFUOXpjR3ZD?=
 =?utf-8?B?SGF5cDBFdFgxUlBxeDI4T1pOeDRXMEdyaHFCVHlzZEhSRHViankvbm14bSsv?=
 =?utf-8?B?c2RieTI3THJiUndxN29JTDJ5akQ4Nmt4dnVOYlFKNGc0eXY3NjJwMmUvZzFD?=
 =?utf-8?B?QmFwUVlXRkJnWmlZZXJSVW1kV1JVWWxFSE5GV2hFdkdWNXVZQWVOTW1aZjgx?=
 =?utf-8?B?ZCtaQXVHc3FSTFdmWjgwK3VyYUdQa0ZlYy9YVlZWMzZWK2tPUzV1bEgySnJ6?=
 =?utf-8?B?RktxZkJ4cWZvTGtSNE10aURBNmhDNThiMTVKQUZTWTl0a0RaOEZwb1g1SUd3?=
 =?utf-8?B?cFFQSVV6L3ZDVVV3cjYzQ3FpYnlEdWtOUTd0ZUdZOFlpYUFHd0pRRjJXRDFz?=
 =?utf-8?B?R2Fqdk12Q0xCVzlKQmxMc2hUeS9rNUFMcjJ4bmlxamV3U2Z0Z0czQVB6bk52?=
 =?utf-8?B?Zk85K0xMTnY0cDNETitYL1VIMElRZHpVdXlSK1M4bE5XRzBvY3ZBTVVlVWFN?=
 =?utf-8?B?NDN1QjlZaUZXM2NZNURlcCtabWQzZ0Q2MFhmZmU5NllBc2FnejZLOWkvQmNY?=
 =?utf-8?B?SWZrNVFpK3UraXFuL2ZhRzBsazhWRy9mQnk0b0p4UzdMZnpwS0RRV2xaTDJN?=
 =?utf-8?B?VFhsTUJIK1c2blFldTZUakY5OUV3R3NXcUZKT01kY0lZV1lkNnpmbFlPS3Jm?=
 =?utf-8?B?WWd0S1lvM01rdWxzMUMwajhWOUg5MFJ3MC92R05ZTDJBdS9DaGc2dmFvbzVC?=
 =?utf-8?B?TDF3RDNORDh1Uk5IMVREQ09hZmZLb3hmTklESEhJTkNEWTJHV0J1UEtqQkNv?=
 =?utf-8?B?MjFSSDlYWEtlU1VxRXNZMXp5MTlmeDcyN05ZSnRaN1pZT3MvNXZQMjdlS1hq?=
 =?utf-8?B?T1BOU3h5NUl0UUFhS3VHZTJuWjc2OHlwYnloalFWOW91YnhEU08rUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cg9SVFWvh4ungRbcuapSODEGOSuhJlFM6uYB6CR6tDNkoiqB0JDwEnO9WW7yuyPXtKtlMPlw7trYTZM5yRTXgE7G3QHcvABP+VQMWNB4jWlV63yGBwIgrQH3ustU257pxabr5Z8vxHlvTTXcPiqvHZiymgXmOHPwatzvBZTIL5TZX46bznTcaWgeEknOKF4TJ+U26ZkIdQh0wMWw/Yq2asV7hWoLgPOcwrbEVCFY19qGQdTXAWBB4BtekpKXDI/FnDcqKlfuTkt+lix9APWQ2cLqu2IN/eynZXvjKBrvubB4I86DxP0E5YX/QTJg+b9PjUCm4/1bkAzMIjln7JgZ7Cun9tpF3zU56zEUDG+aAAWW8h/GZxawnXYHzmYknVeQWvmrdd0Be27uA49mC0e35TVZ0g4nCG8WIVj9O0AHo+PkU5qlC6ZvMMF5rkMYiMzKXvDzd3/4Y7/gspeH42al4NoD+0piBAoMpoqVMGiDWuD+HibmBgmgCzYiOdDXFQgPmOMRGwFd8urr0HwD0YuShQOY4nOagePVl07XMiez4f2txq9hT/F5LHXujmzfJc1HLD3fXkOYD1nKUnkuSxNn13NyryAUSqhqMLHuDTUT1TI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9356f5-e270-4d56-578d-08de78505ff0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:39:33.8262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGiFjlX+s4U4V7W28U3COMJU09R/9HVN50xJEUl4wCbyzs6Ur47IbmYciDTbOxJYm3/v5PBOhQSzGx4bMG7r5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6979
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5NyBTYWx0ZWRfXwgt4lZSvKeDH
 2+nexXCcBmGl0VL9YTMtUtzsKVrRId6LRKszWAFNevMkcKjJjeFpBsOZTEySsFjUwKdheucxr8r
 cG9NQYQQKxFNqAUHtUVFiIEdcG8TP5KDSweEgIke76LExu0EsLIbZfzm/zAHb3wFTAtKz/Cyx+u
 9aE8xXZF98warjtmSI/YNmJD0m4vQHoExANfChbQo0y/FK4CmIw9XWLkqaaSuJnMdldH9RFomUz
 MX8on0wxSLNE/V82l/2o7/Zg8cDM86A/r7BXZCMZCD50utt13rXklpaPoiIdCYZUH5pb1Rppw5n
 fqFm0je/bS2Z7dFq9moLiGF41WzXrtVkwvJ+SCzcLNON/DG3p2qPuyM7gtzXCvX8a6+K63lQbBO
 zbPVwQCrVNPdDIHw2xrwEAnO9a/dJK2Mt41SByeducZxYD63opCpSZi/ZTsOtiuYPtxAfm525/5
 YC4OGjcTOqWnWQkCUqg==
X-Proofpoint-ORIG-GUID: DZSHII7aaRN_9EiNyx3ioXeCKCeHv2D6
X-Proofpoint-GUID: DZSHII7aaRN_9EiNyx3ioXeCKCeHv2D6
X-Authority-Analysis: v=2.4 cv=C53kCAP+ c=1 sm=1 tr=0 ts=69a576fa cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=qLrEDaHoPasjhwb34-IA:9
 a=QEXdDO2ut3YA:10

On 02/03/2026 02:22, Benjamin Marzinski wrote:
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 19d0884479a24..cfab7ad1e3c2c 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
>>   
>>   	  If unsure say N.
>>   
>> +config SCSI_MULTIPATH
>> +	bool "SCSI multipath support"
> At least until this supports ALUA, it should probably be marked
> EXPERIMENTAL, just so people trying it out aren't surprised if it
> doesn't multipath their device in the way they expect.

I think that ALUA support will be mainline acceptance criteria, and I am 
looking to add it now.

BTW, Hannes suggested to not use the DH ALUA support, so that means to 
separate out the core ALUA support from the DH stuff. So you have any 
opinion on that approach?

Thanks!
