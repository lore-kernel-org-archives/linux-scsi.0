Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814F3E276E;
	Tue, 24 Mar 2026 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349863; cv=fail; b=bNhwGMuQQSaDABPHFhdTPbSJttJGvE7yfJHIPAb0qoGmx3OS/BRdCA0EG4XW1GZx5xGJfe+8ChT5bQPkXZz+SELJD7xReZ/jS2WqhtByTeD9JtK7KptwQtsu5QOx9qUkmvYzk0Ea6VJos0NNR+r8CAoD/6SrAenltHaDWcIeTQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349863; c=relaxed/simple;
	bh=TgU/NlC7R7VRpO0GH647tb+QMrhyv5aHngMJQO3BIcw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VeZ5ELVKmJiUMw+PLuy/vUySxHCjItr4R9Twcc5mmu+N8CewnkHq/5HzkL9DDDuJybCsoXLpcaKAi8tCl1T4Jl9QQFd8LpGXmaFvx29YMRj5ii+dt+gKfbutLKyj/UaEi2BaYekrXP1nSyGiJN0VOy9LB8M1kLDSObBxdoKHI/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0GEU849; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pSraAISo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0GEU849";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pSraAISo"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NKuFdw3280110;
	Tue, 24 Mar 2026 10:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=72IZDBn2fHu7l/kkgIpvhM47Q40GDldhIZcIjnEmef4=; b=
	m0GEU849nUDXsf2W4dNcNisH08YDbDznh1X95szmFhIw2kN8HQfT7U9lzYy+3/67
	o49FXw+AaNwgjA72CRzkQy3oq8kMdhftN7Y4Z97wS4LrinwE7IKbdfffiC5JyOWK
	uewte/eFXjHPXzQouQ24HPfSnT47bDhAsLI6Kz+SWYMooOTzTGVprjynfE3xbS5A
	iVozFFqVsoE8xK0Y7fl7yr5mvosyWKoTGt166XzUIAzilkZPfeJT1tUEdUptBlIA
	e+oMg3ZCvo8Uu7Le8HhIlaYjlQm3onMONf72ieUqVmEj17Dja7Wd3+X+rs0BbPEI
	rhS4XITvfIQ9ZVVeEjUNfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1khf3y42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 10:57:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62OAinEj012293;
	Tue, 24 Mar 2026 10:57:29 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsft54r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 10:57:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dxhZN5hKnaY2DhkapJiMzXvY9olk9CnhDmgxYfymcEsbLjdteImbfWljyatw8z0ZLIcyccckgmvuooLg7ja5XI70SEYxTHSPupLMbkakt9JY1MCGwoYOElFqoVLea43BwbjEUzdlgg/aiq4BoxGxrQsfbeKYforNNCpbTtZ8aQmqf1F9cqMgCS5/xUpHBqCq09ZkBcDo/vMjHV+G9KDK4wvf+VKguKUcpGZHlYLhpw+OyEBbHFgtVt8g6vSySIydT7P5cC29IXuOv6F+OR7sqJBVvVO6VuDO4YFOjE59pz//GlrT95B6c/PV+yWunT7UNvMjJIfaVJeMVfETI2DUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72IZDBn2fHu7l/kkgIpvhM47Q40GDldhIZcIjnEmef4=;
 b=wPyPR5a3RkyKl/FrTk7BMWqR7y2Y4P+NuLf31hm/k4s4453kHJg2uLKzh7qfkGRPqGjrs7yJMltJ4BHR6fpnCpfwTrifra64+iyfzNTmGwWsvdWwo3hgvrxbSNV0r3m1Na57BUbGewtM3yElt+osp1gJAvtbFT78k0s3VUvsFajAPBu7geAQ9J7jrUq+du4lVp3XZzVA4ubpGzndCgCV7OGxqHG04JrDXCfcVByT5jlkLh9o7E7xSCQR6hWUzQjCop0/edcO/x19CTH/7oElXZgEJVBMMPfP0iJchprG3AvBa2tYJbpdjlUzEDU6FADzIGVlSw3w8CkB7ThZ2lq38w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72IZDBn2fHu7l/kkgIpvhM47Q40GDldhIZcIjnEmef4=;
 b=pSraAISo6Znl5Hps0sa8zfBWHWJD26U74WEo7qRzJOs1/t3cJ/am62livBizt4ivN7qWT+RfXR0daH7k958sSZmwTxdeIGIgEcZxp6fri8f7Y0zhGxVS5zNj4rF7MBtc+klfFWGv9dILTF3SPHT6N2dsKp5EgZECA3EEy/IsmWU=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by IA4PR10MB8730.namprd10.prod.outlook.com
 (2603:10b6:208:562::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 10:57:24 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%7]) with mapi id 15.20.9723.030; Tue, 24 Mar 2026
 10:57:24 +0000
Message-ID: <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
Date: Tue, 24 Mar 2026 10:57:20 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acGYbD6X55eA-ynl@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::9) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|IA4PR10MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: be2845c9-3204-4100-4d0d-08de8994217d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0ixIW0g0BbsyBxrPnUh6PoFANsdYrb9bCBKbeP6VKVTOQ86JBwRVEDPGw0g2uJ5ua+Ov+xLJukVoM0NhWTi1UmuhUgmpgKgWcDhGSk4/fA4B3TzHKiCR+X6MBlbKK818h3rgRdL706AK6CurKyYcZuNwMUhQ/ra2239wJiZYtzySRjOeg3vk1HBAoYmuGeNVj9F8MkDZ7q83uBLBgF4j66TgsXM5EGqXSXFksYoi9DJSszgbLLNnihbVSujnGJbbbaFonXl25eLa1HCXk+t5+NIgt04+QMrlDNyZbLHRcMBNoi9NmDHotRT27LmMEis6keNmpix2gHcI+Et4JQtk9W++M1d/pHIdEjQ0YMgkN+LuUFl4uNGgeiGwrbs7rUczNePZA9AwKxmFGWSlKajIFgBq8+/S0ckB2fX7yB2bjcuaS5xwZQTB8NiXwGP/ekRSWAalYYnTGAjbfFGcM4Onv5P1Qiir0H5vhmEBf0Y0VmBXbNi8If0WFtLXcYTYLs7p7EhjB0CZHA5N8Nv6K2mcF0RRmz0szlHpCOausevgJPv6LhxmuCz8JiwAzmn0vGlPj707RsoCRwI8/z/+mNNwIIwpBvd2+0zDVL0JKni9xGpHdvJs0QO1NoiW6L/B853PPpT0vsohQDdnUIGgLmj1RisXrkI5AIS9urxk5IrMAosiyZrJ0h4G+dtqPQiYXoLvQ8Q9MNYlK8A+9jysR7dIgQjHriQy60pkGQrxjMsslog=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFNCMUVDSEkvY2Z4ald0cldMSjFOVm9VVlUwMTBXTGJGUWUxNzJtR2FQd0lL?=
 =?utf-8?B?SzA3WUVsTkZVQ2xrYlNickNWbUducHlFNFFtb2x5QzhZNGxIYWd3dlAzUWxq?=
 =?utf-8?B?a05rL0NCelo3Mld3LzBEMm1KUWhIQVRvdHY0QXJuTXhjNTJyOU00OXNISnlH?=
 =?utf-8?B?S1B1eWVwRzQ4VmFoTkZmYTNOOFRUKy84OGhicGk3VVY2OVdTKyt1U3lERXhF?=
 =?utf-8?B?VXZRNEt3amgzWEE3czFFK3duamZRTkFZdkxBdHJ2UVlBMGZqaThkQlVHSHBE?=
 =?utf-8?B?MTkrenNjOTIzS1poSm40b3dmcnUzU2RFTlBWMFlGMi90bnp6UEZGNjhwNStX?=
 =?utf-8?B?alhBVTIrN1FQcFl5d2RxdCtuZzAxNFMxeXREMUx4WEUxSjFYYTVRSFI2VVNW?=
 =?utf-8?B?eEl3dXVmMU05Um54S1hZNmNXVzUyVVNVZDJ2R29ZU3VEVXNuVXpBN2JCc1dM?=
 =?utf-8?B?c1NFajRPVDNNUEJlS3ZEeFFta0RyVlRLN2RWMldkem5USmRrMVk3V2ZZVHNm?=
 =?utf-8?B?bHZZejVXdmJQWXJhcjU1Q0xjVEN3OGFwUUhtWkJjRFRSUU9FajY3YVlucTN5?=
 =?utf-8?B?T2huQUZUd2k0bWJQSjhzUWFuRjNJKytxMGMrNUI3ZklyRXFEOUMxcEQ3dXRo?=
 =?utf-8?B?anJvNGJIQW4zS0UwbkE5NXBGWVh3MENvQXFpZS80blNkS1orRlRhSGZoeURQ?=
 =?utf-8?B?ZjFzdkJkR1BjREV0WGI5VnM1T3ZZZU12cGszQ3FUOCsvemd6ekRpR0ZCWjlF?=
 =?utf-8?B?NFhkNFhkUUp0alVyQ1pwMkRDUnN4b3BVeU5vUFBpZHRkdDhNZU8waG9mN3Jn?=
 =?utf-8?B?N3dGWkdxOXJ6WGowYzRXY1dVaFhucjkzUXFJZHdkQ2I5TklNbmUyZXJXRHBR?=
 =?utf-8?B?RkdIMkxWR1Z0aVN6aGpDT1R1dDFEUGFhbWozNFZwWExZQlpoSjdOVFYzbDFh?=
 =?utf-8?B?WWdKNFFVbFlQM3ZPLzlYeS90cWFyRDVRL1BTbmRCNFhBbWFxZ0ZKZFhPTUFj?=
 =?utf-8?B?RnNxWG9IanozeTBSaW5jRGRMbHQ0TjdtTnUvVTZxL3NWSHl1Rm1qQTYvL0F4?=
 =?utf-8?B?VzgrRFE0WkllOWJpcmdiOWR6Mmc0OWZoa2ZxZmZVdUR1WmhVbWVMWUV0aS9o?=
 =?utf-8?B?L2c5R2RIbFI4NjRIWVBXREQ1N2d1THZoWXgrYkhOY0RNazA2cDF5YnViUlM4?=
 =?utf-8?B?N1V0MUVxcmRIN1EyYnlHSWxBV2FpOGx0UVY0MFVqMFJwNEl0TFZ1cjBPOE1K?=
 =?utf-8?B?T3RrZWVRYTN3dmRMQjFIR3pYaHlQb214STIvdTZqR0ttMmpJOUlsNFVSYStS?=
 =?utf-8?B?c1NDV0M2SHBtQlRTZHJoUXprTzRsQnZPclA0RWdRNTF6OWFHcDh2YnovMFVN?=
 =?utf-8?B?bElrNlpKY3JhY3E1bHpPOXdZanhEYmhiRDlrN0RZM2lqRSs0YnZQR3k3VFl1?=
 =?utf-8?B?dlhpL1RZWm40Y1VqdENTR1dqanFhVnI2Q1MwbFUxeWVBUzIxaUJhbC80aHpX?=
 =?utf-8?B?dFpUbnl0OW0rMkk1ZWxuSnVINGpLQlpWbDIwYlNTVUFWU2JGckZKdUthRFdo?=
 =?utf-8?B?Y2tNb2FGZ0RTZnFhM04yc0Z1WktqZzV1YjdxanRoZExpZXZEb2dNcXZuRDRM?=
 =?utf-8?B?ZHRvL2cxK0dhWkNTZ0F6MmZTUHVkVDV3NTY4TTlZRFdHQ1ZadnhUcFJHcVFn?=
 =?utf-8?B?T0M4cFFoNENLbGRsb05rcXFqWHlObVp3TDdsQXhhZ2NxR3BJQjFtZkxCbi85?=
 =?utf-8?B?cm8zZWQvNGxNNXh6ZDFmeFg4bmxXcC8xUW9pU0toOTdmTzVwa3FRbVU0R0Jl?=
 =?utf-8?B?RlVSTU9KeXJrc2lubkxqYjZBaXdjUUpIZENXTlRHQXQ4T2tLYmJ3NVpSd1h0?=
 =?utf-8?B?M3cvMm9ZQlhEVEMwZlRjc1NPU1ppUzNveWVFYW16eUNyd29XNjVIUzlwaEs0?=
 =?utf-8?B?dG1RamdIT0U1Z3g0d3NLTjFURm5LeEpzVFoxbXNkNnRUcUw0UzNKaVVhQlBx?=
 =?utf-8?B?c0JxY0xySUxQZUdMQldhNE4xLzdQNGRQUW9wK3ZIek5jR3pWSXprQTJ5RnMr?=
 =?utf-8?B?NHdnbldrTXJYcHN5YmQwWmVhSTBSRzVyNGxvYkErM1dLbHF6NmdjTk1ZdDRL?=
 =?utf-8?B?T3VqNy9PaFU3V3p2U2VWTU14bG5qYStlRWlXZGlDRXRaWE0zTzJlUzhyL1cy?=
 =?utf-8?B?Y2dHSzRYQjJSa3pwQXY5UElveUhWaG5YK0VxSm5qQ0MxVG9WRXRSVTBTVEZB?=
 =?utf-8?B?SXlVV0JleUhkajFaTDh2WmJ4ZVo4L1hIUUpsZGFySHpXZ1ovdFY2Y3RpaE43?=
 =?utf-8?B?VzdBRmRrdDdETnQ5QXlYczduamgyOW1EaXRKWGdLYUIrZGJYaEl5RHNtMEJh?=
 =?utf-8?Q?JpkVPJDN41ATbs34=3D?=
X-Exchange-RoutingPolicyChecked:
	WeZuNmIssLX5LVojmomG2jiFtuaugzL8g+oqPKWIFjqIrLRUssGzJkE53z6le2sq86MvlokZPd6oDmDZrUBbu/Hy7KtggoNzjpCyp0f7TUmepVlIHENE4s5h+qNAnAqPPATvxGvZA7E2hwfF2r1G8+0hqM/J/KzYuwx0huL3K1orLnNqG6u1lERSF1m0t3xSl+SoOjr35lIHVjcEkbhLyeYyu1QqUqIn5uPks7KJKtTASN6L3Iv364sGgPmYX95H++yLf2Gnp1pDUX3bQGv4TS0pnQp5FgSbYSkehTgWDqp9i0jAID8kMpD0L2uJ785C/8aWU4nSrtixM4SZ1V2BTw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0zPWyeCrSBDOYwOzlBCxKSp4Dxm245c7hgqdJVCe/6es5MICe1CiU99pay43JsyTThaM1IIAqNHZkAWZYTTLBBFfcVQG2b3pc7bTXF7qIkOzF48lqJ7MaMT50dzT89F5RRsM416Hy3g1xdpXu8TNjA63UXoQU4YlX8DN7X2G4cmIpl+OJITg3sFjEB6K0tuCO61PJR1VJK3L7Pg1M1m2waXLxKVNLemBehYdw+3aKCSr9RsnBvpSRN/0kcxMO0kyvgGubPLTE1T6/a9KR5gSfmwLhvT+CZ6ASaMvekIiDWHSg49xV3lGoBP+E7ZAD4D/wRmRqSvq16LBm8EdIIjNo3pTYBnwWaToJK1nZY6lwbPguOGXPHIrN4ZcN8LbPHm2Oeg7ii8ictwtZiUeORgDsUx6EWjINZTLM4I2elmmkgovbt6AHcga7F+fC6GHIKaARkiqyG7qhRC/JnXqfhgUnXexabVRKHSSfQxzWpPBw8B13Tj6oHLwDo9Wlrf9TtGTRuI663J6dD4WQ1UlrkJiWyfBujus8pI+TcvCMLLUjS3CH8B9FWai5M00575jujui5Upw49yKPKW2tJi+eTaU0TFn6yvVveP/Fvl1bFiNbMM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2845c9-3204-4100-4d0d-08de8994217d
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 10:57:24.4858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPdHNxsn1Ro+iGxkjnbUT8yOzU4OJShtT6BrZwn/9BEr4VrXXAsD/sAd2Gt3NAroyvCMRvpSBvEOJYwsk6BUMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NyBTYWx0ZWRfXxVElWzjRj8Np
 x0uzZ0HGAYAmXPr+lc18vH9Gla83NuORqCKr0e5I7XlFJxS4EZ5ooCPXr89MI/h/C90w0TaJTEs
 3OCLJgJOE1lp1m7EWX663bHIOZailNjqYM+jU9qjAFaS9s6T6afkhMAPi6t0DL3agCQF8NvpODb
 fNHdVpIb51VQaOhbFwY9Z6xAWBRc+dMV7rRJ+fZUkMA/V/1zkMKC2lo6Dgis6eG1smR9dRf7LB7
 260BFLyRaGzS2U5go5vDNBrnJXo1DcczD8V2Lwdfnd1+Nk9ioMBE3qCNI/E7mW58BNLahkbaFJL
 LDn73H3tyFGkWp9cAvMvDiVuokSqLG51bU9vwerX2EZVUaSiQmk1kO3i/aSZCiMEtN1bkP7+fUx
 ElUr5c/959dv8I3Ea5F51dYde02S5WmtsmC0vZBcYXP4KxAuMTcPU37sAgf1etlG+x/hs4ah2gR
 XSOvO89tmwKnIaplYZSFVf8cAdN6oOXBzYHIDGcE=
X-Authority-Analysis: v=2.4 cv=AIvfpCdw c=1 sm=1 tr=0 ts=69c26e1a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=cqrd0BU6P2-rTFjP8YAA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: qlgRc_JYepvFMYe7_cD6JlzwrpAjAkM1
X-Proofpoint-GUID: qlgRc_JYepvFMYe7_cD6JlzwrpAjAkM1

On 23/03/2026 19:45, Benjamin Marzinski wrote:
>>> I don't
>>> think the Native SCSI multipath code would need to actively interface
>>> with the device handler code to support IMPLICIT ALUA. IIUC, looking at
>>> sdev->access_state should be enough to pick the correct path.
>> We also have the functionality from alua_check_sense() to consider.
> But the multipath code won't call that directly. Right now, the scsi
> device handler will, at least for every scsi device except ones using
> the Native Multipath code. My point is that this would just work, except
> that the Native Multipath code goes out of its way to break it, by
> disabling device handlers, and I don't really see the point of disabling
> something that every other scsi device, multipathed or not, has enabled.
> It's not like leaving it enabled makes it any harder to move the
> implicit ALUA support from the device handler to the generic scsi code,
> if that's the goal, since the Native Multipath code doesn't care who is
> issuing those rtpgs and updating the state.
> 
> I guess this is more of a question for Hannes. Is the goal to turn off
> automatic device handler attachment in general, and go back to making
> dm-multipath attach device handlers to the scsi devices it is using?

I'm not answering for Hannes, but I don't think that is the goal.

> If
> not, then I don't see any reason to have the Native Multipath code
> disable it. 

It was just disabled it as we now had another method in the scsi core 
code to get ALUA info.

My plan would be - based on this series - to not attach DH just when 
using native SCSI multipath for a device.

> If it allowed device handlers to get attached, these two
> developement efforts (native scsi multipath and refactoring the alua
> support) could go on in parallel.
> 
> Or am I missing something here?

It just seems to be about this DH stuff is that there is bad history 
there and no more users are wanted.

But now I am getting bogged down in this ALUA support because of that, 
which I feared would happen.

Thanks,
John

