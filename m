Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BC73D091B;
	Mon, 18 May 2026 07:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779089400; cv=fail; b=QTnEkoxObcwXgKO38znljmJrGF2DsBQSN6I9PTeosUFQYwDXQppKLZ4vPscRRt8KhR2acX0yb/UtGZeBCBk2r4PvQ3levuagC0bt3/qbYiM7+18w9NQw1/sGZrncQdTbLNzDtbZKrTkxjiiC+cR0IcDdh+BdwK4QNGKAdUpAQzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779089400; c=relaxed/simple;
	bh=lDmPGHLEwDc2HRipeE2N6cgF4g1Vcj+W9RWj0IYOVJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I7KknmfO82ut41G19/9VARpzR6fznTgWdvPEgWfQwhbwGRgQ7zeX8QQXDOWnNPTFoRI8hHSxjPBKQKoa9u4ekfpBQkbEvmlxvsk7M4Ek5Nu0GilQ9OjUWYdgOGMg0PdBT8Ou44hD1TRIYsV28NudPETRhgyWwcVxPK/ZIQWLSsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A6xto2bO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J9tMDgFq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A6xto2bO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J9tMDgFq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I0nDU6540876;
	Mon, 18 May 2026 07:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9xARAQKWZsvTslAbx6dhUNdEIUuJ7fKONmocGwcgiYM=; b=
	A6xto2bO8L0xTd7FFPvjwdNRe8hiYShQuc5I0Qd+c/q38tjPQXAorv1jtWZPxwHs
	rqn7EDvTI7fpgS8MoWJ4FTW278aKHrXOMQkCREfHyHQZ+l6+w8Eb5GBiBkc/UGuX
	+yGYl3uRbUeJA3iIcIR9uM7goEx1ZDtl+vXyzBj4H4/ChyAn06Cn4VJdRpIV95cs
	m4GcVKYz0TtF6o0i8ZLnQ+JF8LbvZvrzsZXo/1TaQpInxg/4unnnw0vVt1uGVQXm
	p6wiU5uyFl5J0yNTu9aWza3HIRh/B5/mqp+fFOXm9jsKOcGzBiS8Bm7YQk3JWVc8
	QPb5z3xvq3+L34hBT9sAqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6gyx1r9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 May 2026 07:29:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64I7TiqX024851;
	Mon, 18 May 2026 07:29:49 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f192ws3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 May 2026 07:29:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SbbsuuHJHSHCG1gP2BQoDS/Xa5ytq28HFgJeASk8BZ6RUlwa3F6wJkZKgQtjxvSGq3lYs95ER6y1CU2eMC6dSGVVavEjsmKrPR0jRwwy1pRxbnQAWsBYx+dWfLG7PwBQc55EoEdTFmOvPsCTcoptyE+07b58PuQ+PY0kWxIJukXWs65YO4TRtRHHvhzjTjxAPym5REcCYWqt/FCo1C5Sczg/q9igQEtwmJSftH4wW3i3wIjDKgv+ezokEjx7SjIi97w4mnCEScdix33oAfPu2WTw+hh91Dv+Q4q3ZAKVG3IDDj/duieelTLExszVensjs+8ZdTXBZUmGl/jd/QTGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xARAQKWZsvTslAbx6dhUNdEIUuJ7fKONmocGwcgiYM=;
 b=g/9cQI6FNitAOtqQjPdXR4N6rRyQYljU335Eh9R0H3QJKsuoHS0brrIL7kHIQo19t5/MxrRShpQNGZimHzAUlEf7MaBxdDJe7XN7p3ECRyZvQU3B1F9wgbQoh6AU7oztEcPT15U2WeXTO3WD1xPq3XuqoeyLde/U8Zf/Q4ACrhawlkS8YucAmfSaqTWICm9pVWdcRhUwHNxqwFSVaYztQ2NFbMUIuUunrXzQ/z7wWJmxbWK2Ray1L+NjLTVPBZhIX+IaeNL3wGEkeqqsqD5Z+KPOBaQBV16jbRZizStqLtpx6ODG/EfBCm6zuXuyZSExbWv47DNAnsuYFyplT1yuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xARAQKWZsvTslAbx6dhUNdEIUuJ7fKONmocGwcgiYM=;
 b=J9tMDgFqxyPTeVd/cjlSAaTeRwbb8zBA22F0bOpxofb/zbB2ZcxQTkANYRbjJdxoAFTkgCkzTwi59WQV0K2uM0J1zFg6wW70WdeVCD7b6RTG0xoU6D3UhN3/YYY+bQrIsd9RGfL3K18IFzbVt+cnx3UY046BwEnDf3vrAJHOFos=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BL4PR10MB8232.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Mon, 18 May
 2026 07:29:32 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 07:29:32 +0000
Message-ID: <d6ef25af-0b1e-4ad2-b62e-78dd01eaa29c@oracle.com>
Date: Mon, 18 May 2026 08:29:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] scsi: scsi_ioctl: use strnlen in
 scsi_ioctl_get_pci
To: Thorsten Blum <thorsten.blum@linux.dev>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260517171546.2304-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260517171546.2304-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0465.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BL4PR10MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: 909adb56-8364-41e5-6ac6-08deb4af3423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	y77U09ygN65o4y+sL2g2VtQMGaqtAv/D8bEYFbwjzIUlYngFU5ELT0r4hItKSyhsXHqAebDMUpdFoCWQ2jlUoRjT9ry7D4m1cHWVY7ISqQiW47EKKbHeBon/T4qpfWoQ1BVi/2y6rffzY4NlbiLjExIbIEojqQuWo/tyakKR3kjboLhEMLPXhfdUiBGkNPH8nf4N0HKj/6nSyOFuGQrN947Ew5V5qVr+1tx3VpnCMAaSY4V6S5IpnHGlGUwvdv1nA0CReIggaNYChF2cKj9U1urCxIxWogYSW8mXvcG1JvIzzV+2PsinhL02zMBsxCON0uIWPU+LbDaH34M6qimRqtDqfXv4LOwS8W7LnbtAemI6QXEr9zxJqWEcLAOO49XU9p8jvHwbtl7fSIcTTs//nDN5vQhg0QFfSCpAa2rIzXg7zPUGWLysQTsewALTZIgqSUPZmUzmfV+pKCsCmpKqTtMXAz1Q/y9WNPAz2osz3XwL1orPhqnNob7m68N4tRPjXnZHUIZA9HtQpX4zF4G4A+gzgNAYPN1qlQNDP+ZZs4xOLutKf9nA/IK0YCWcQliFayn/F1jBCGMZVmNwehnqk8fyHaYmqUwRzWvnBNtXHHoeWoGkHfzwn/u4DhBna54T2e+eCKTPEc18ORhAPViAdpAc3X36QMw4c/MkdLWx+/uQq/H6ondUFnG5O898ctRp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDl0VjJFUEk4OTc5b0tWMWtjckE4WHpUK0h4U3BINkhQVjl0cVZxVVg5WHQz?=
 =?utf-8?B?cHdsRnZiR3hsbEZkYWFpaEZaQnpZYnE3Mjk2ZFJ0dGxLVXYxTDVBUXMzaThW?=
 =?utf-8?B?VWs2bGhkWjBYekQ5b1hydkUxNUd3cWFLeWphM1NiMzNkNlJjU1E5aFdOL0N5?=
 =?utf-8?B?aENIbW1TdVErUFJjWE5LVjZPYzVoaXFjeXV1emhVeE8vVWl2UVlQQTArYnBh?=
 =?utf-8?B?amxsaGd3WWtXc0U0VnU1MXc2azRuNm94WFhsNG90VzFQRy94UTc0ancxVGF1?=
 =?utf-8?B?VTBCQXY5RHdPdm56VG5LMXd6bEFVZzRQZS8yRVFLdWZ5U3M4cmNSRXczZGtn?=
 =?utf-8?B?NTA4QU9McXBKRzJGVDR6TnpYSG1wRS80VUdidzY5dWVYbGhkbVBsbytEa01P?=
 =?utf-8?B?YitpWWVjRVYxVThYd203RXIyaVRsT29kUzJLSSs3VHNOQXQ0VSs5L0lxdGNU?=
 =?utf-8?B?YkdmaTBxR1pQZkxoS1k3YVdnYjFtSUZyOEVnSEVFdlN6TnV3bTlOODJBZytS?=
 =?utf-8?B?Ynl6VVhvRW1MeWx0ZjQ4MlNRSFZIMUdPZTVSKzV2RWZLSThJT01UZUJra2Js?=
 =?utf-8?B?S0krS2I0OGlVVjFhZDdGcWlsVjZjNWcvQTBDd1djMVF2MGg3US9rWUZ6enpw?=
 =?utf-8?B?M3R0QXg2QWhrU1FRTU9SOURidDI2bG13K3h5U1dNYWptK3NVbjV2RDZHU0JL?=
 =?utf-8?B?V2xYQjdYbzZHM0V0cmtDYS9iQUdNWXpQMEd6YkJ3SitEVGJwcktTQmExOXlN?=
 =?utf-8?B?L3VQUXpyaWJiZHVPN3RiTHpOQkhxdDY1b1JkSXRyYmxHcm9Jbm8rMHEwa1ZM?=
 =?utf-8?B?L0I3a3NUanQ4dkhaays3dUxoMnQzQXRQdXlCRXViY1RmN1pHYXNGUmRzaTAv?=
 =?utf-8?B?UENabFZ2clNRUHRXTlA1TDJXYnRJbXFYM0VmVmd4dExCVSttaTY3ZUtrMU9P?=
 =?utf-8?B?VFYxV1U3YWxXSjVxTU5KMUgwRDJPalF2aHFhWkdiZGh0QUJ4SmdwcE9wVzJn?=
 =?utf-8?B?WnR2dWREWlVaQWpTb25jU3lURGpwUzBreVpBbDdldkxnNTJLNlM1SEpIZHMw?=
 =?utf-8?B?eDBTcHd3Qm1mc1UzWWlNM2hBc3RDR1ZldHlWZmZuVHlDUnZaR2VnYUNuUkg0?=
 =?utf-8?B?WnBqeUpsaVB0Vis2bXJ6c0RhcDM1TFV2WXAyb2tXMXRSS3ovei9WbHpGa3Fs?=
 =?utf-8?B?cXE0RlBITFhyUFJMSVN5eWgzNUtHdzYxdEdjOU9aV0ROd3pEQmE1SjEvOUlK?=
 =?utf-8?B?TFRlcmZCUGpzeXVMRjYxOVF2WTYvVDVHT1ZtNExiVkNZVHF6Y3NOWjJLZXd3?=
 =?utf-8?B?MHJVL0pWWitiNCtVVUFqN1JEd3J0Yys5c1p2bzJVTTZUaDFqK3ZPTkdEcHl0?=
 =?utf-8?B?aG5IbVlPYnpoQWx2OFJ0RlFHM01WUjBzY0h3Y2F2RWlIWlovSU9YQnl2Zkdk?=
 =?utf-8?B?a1VzWkR4cVBFQmFQeFZlT3JYemRlVGs2ckpqWmdkeFI3Y0hZNG1Id3NrSHhH?=
 =?utf-8?B?Kzh1eGI3cUtWNCtybUtqY0cxK3ZkRzVZQ280ZllmdURLTkZuQ0xDWXg0c3VX?=
 =?utf-8?B?a3BvMFN3d1BzNkdqN0RmOXE2cTNhQUVvU2hadGJ0MWgrcTg4Y1prRS9rV1ZS?=
 =?utf-8?B?KzYzcE1iODlZSjJ2VUtjSkdId3BsRCsyQkM0MFdKVzJLTzB4MW9hUGtWbGZ6?=
 =?utf-8?B?WHpoVFF2K0dFZG9YanVDK1BPNTFrNmp5Nmsrbm5rWk5raUsrazJ2Z3VqVnNy?=
 =?utf-8?B?QXBCcTJCSlZ4bkVTTVhrbklmZ2g4T2Q3N1ZoS3g5QkpTQ3U3bVdGa1JCLzlm?=
 =?utf-8?B?bUkza1FMVnp6VHlmRHQvYzZBVHhNem1FcXRwR2tjcFBIb1ZTVFUrd1h4Mmoy?=
 =?utf-8?B?TWs1TW9GdVNES2RXd3NNZTJlYTFOM2NuYlNGbFVWdW5xMlQ4ZzBESTZ5NDhG?=
 =?utf-8?B?bFFHR1QzS3BtelFQQ2NQMVhMZ3YzTjBvTk9NZFNsM2xBR3RodERNOFRDOE1r?=
 =?utf-8?B?SjBLdHNXQzF5NWJ0MXNRejlFU3FmYXJMTHAyU005TGx1dUFQUW4xTHdPdTNs?=
 =?utf-8?B?N2VKSkMyQUdZdGFkK3dkK0tXSmZlRTdzbzRqMEtaeDM3Vyt0ZTJES1FLYnJQ?=
 =?utf-8?B?Y1M0RTUrcjNSQ2FNaFlCdHVlSEE4L01qaGMvTlQ1dmRxaGFSaHg0azBMN05L?=
 =?utf-8?B?UDlFcm4xbFVBbVBvZU5tQ2tvYzRPZldhTnBMc251TWM0TTZZZ0h5dUNLRkFt?=
 =?utf-8?B?RGl3cFFTL291UEFsNjhCdDhyS2tjRE9uaXBLTGE0Z2dQZmo2L3N3d0FQd1ZC?=
 =?utf-8?B?aVA1RlRoWTVLZUxKejZvYng3KzUwbytTSHZ4QzFZdUh1d1VFTlhaZz09?=
X-Exchange-RoutingPolicyChecked:
	J6Y8C7uFPek4g1BC6iTrIqZv4SZf+0u3jyUzIGHRhdBDZLvttCKfZpmktvQdOXy0XO+o2aTV3yC2io94wPxXbr/HodntD35tLF63uWdfzV1mK8ashoARM2QlcBEravyITm5EftwiL6acEPs3Jq4wJd2FHVUs+xn58o8NrLug7LCdMGYb9LLklKD0Qpn9tx0pR1/i43SFyJ1EwAZ55cJn2lIlkFmGt+CscGkPv6NAS+klt5weGP3vW+IinXopChFtg3stMm127Ct+LsEVLUPeA+sgTyTGs37RxCY2Wi3qxBRvc/0A1aAjm87hm9b25R5Q8YwqGwqlUlgw94iLiP7yLA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cg3EtKVH3hzpJRRO2XUtdmy0iLuyfSCD11jR5a+gd4dR0CWpx5v/F3rp6gXvssrdUGM6SYLwMAsIJgqSf5OPEYQ4Xpp3+nxyrR7SiGm15a1d1bUVUXTp+OGiOnaYN4zyLCndyfRv061swTa1unc/494Ucs2J9Oo64XwXIUjEB1Zclimm3b+3xz+gQo7rtLrJObaI94Hm4amjfDjp6myeuxV2KuUPpauNzIB/WP6lrFfPTNunCBRW5iI/W/JrXcIuLQipeks8S2W5DjpRUNFo5/D8ZZoJL83MW1JLrOjfADCDGZD7oBZRMfv3IRVUe9Tv5wIE51atTy38HAL9Ksp4s8DBMq0tecAHs6SuRpgyuo8uBluoxA3wsdMV67FmY/IlQpPn9+P1ZdYH3zcTuypEEvOLXVdtAhH+TaC2LPBw1AvrrXiI50WrMvCrtFVydj8N2NJYaGQ59rg9nGwYeRkOMZauPJ1xzRmBthDBG/u+krPmFM+h75MuuMt9zxxKVe2vov6tqnL6hAA23BAHchDUFoboFhbomlXisf+mQNeFFV10Dv798fe7+SVCh7jTu93nIWhkpRfzgOUqMiKPiP7wkT8S3FEJSTsRdZdVBpn+raI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909adb56-8364-41e5-6ac6-08deb4af3423
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 07:29:32.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvViU+B2xVpIFiMsv61tKTvUW5cmzug140iQUn/DE242YSPjINeuQ5LlDW2aX1f0WTh5TqJGjyEOlo68LX31Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR10MB8232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_01,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605180071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDA3MCBTYWx0ZWRfX4bk7NS7fDuFH
 RG7ngpJULEXypAL/sivCy0in8Mo3Mc9/fG0d7BTCk/kvfEX2YJoFMUnApfDfeinzANx4dNwU3in
 0k9lHXjSJaa9Sj2PhEoGTOJed0+A3s1kwUjBOoJFkOLFZL1aleV/9czGKT+oGibFrKzRdAgfNbM
 4IY6FHJ3i4agOFbLIja3XdRKubTcRIGBZ+VKPdigpZXxR7bfTviimnFDxvcfD+cLeg1JRTPJ6RM
 cow+YFt1xWwNdiHLanmpdnYXOyQuyl/I6HcngDZb52vENiDdwBBjKki29TP6s1g/ayuAoMWOyLU
 L2XAHxpQtma3Yij1feb9XiwME0SVn9hPjSbhbjFXjLesyOAhpnFPe599meU7YJoD3pGKOVih9Mh
 QU4GSJ5yGE9s1IL+kFkUCKGq1OenRVzG0ouQH7iv9kywkETLpNOKL6BqMsG9mmFkkyjLNL4b3vE
 XlfqRypwckaJWM3HDGQ==
X-Authority-Analysis: v=2.4 cv=Ls2iDHdc c=1 sm=1 tr=0 ts=6a0abfed cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=sxgLF5d6oun42dgUXC8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: pGnBZm2Y1tjV_wHqqw0igl6AS5OJzYM7
X-Proofpoint-GUID: pGnBZm2Y1tjV_wHqqw0igl6AS5OJzYM7

On 17/05/2026 18:15, Thorsten Blum wrote:
> Use strnlen() to limit string scanning to 20 characters.
> 
> Reformat the code and use tabs instead of spaces while at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_ioctl.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 0ddc95bafc71..d98c2f19b1e9 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -176,10 +176,11 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
>   
>   	name = dev_name(dev);
>   
> -	/* compatibility with old ioctl which only returned
> -	 * 20 characters */
> -        return copy_to_user(arg, name, min(strlen(name), (size_t)20))
> -		? -EFAULT: 0;
> +	/* compatibility with old ioctl which only returned 20 characters */
> +	if (copy_to_user(arg, name, strnlen(name, 20)))
> +		return -EFAULT;
> +
> +	return 0;
>   }
>   
>   static int sg_get_version(int __user *p)
> 

