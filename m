Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF643191D8;
	Wed, 18 Feb 2026 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771403039; cv=fail; b=l69WIc+4d9XP+1fXIQPCD1sOAgd+DqJ4Ec3qYSVJq19fEDCyT3klB+PHecTmE4jK7V0pC4RW2YcOoN67zhaqQ5UQBZMR3HbkvS0UvBv6TW5ykb20zsT42Fv8fOXrZSkURYsjBk7gDETiYO+VWr1xvQAbk5XeDj3uNyIq+wZQICQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771403039; c=relaxed/simple;
	bh=CaoCr6X54bajLZHH+cw4m+koU0eMz40Cp2NHca8fW2c=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PTIeZi1VCYU5mGLJKmTRA+pBmqlKUAe/+LSXMLItduVN8YZX7zBh5aIFfVgalVFaKS2d3Xjmu+6sWgQA2Y0rPAk0ntk7xVx2AKBZh6tAi23W3QhhE1QplEzldTZO43LHN5xzGpeQKlY6Oo8+KwthcX9IY8cwNdgrXCNaCBDZZPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZwSeVncT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QYThugh1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZwSeVncT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QYThugh1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61I5LP5k1535448;
	Wed, 18 Feb 2026 08:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A9EUuycQzux6LMYInZ+fNgVyUo4Fk/YVictpKuZiMd8=; b=
	ZwSeVncTsivgHVmCqUhZjB64hDsmgQJNUWCbkE0hdTW78Mx9LfH49pasIecb16n/
	eVt6A1knUOp5qMHCRoQUTsXE14vmFpnDGa3AWLkIyIjmAvaULnYDfHc1PgAzOGXf
	JZkwmu5H4I/S3MW53I/xo4HwqJFnqPq4xHswMHmhJsPyfrK4ZBJPv39bUsgN4Thl
	v996t2TZQPSyPlQwYSELwJ4NWwSj42vPG0dsUqdK64ytIaco5B6GUT1sl1y4p/eT
	ob7ykZzXY9+ERNZdRqjx4x/v/hY06S0ZlMrLo4qjYMsSeSThguHcA0pfC6RjDa1I
	Xw/RRODy5ktjh/G5PN8eEQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj3t53sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 08:23:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I80GUv037164;
	Wed, 18 Feb 2026 08:23:47 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb28ay0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 08:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgTbAKSUNSNZEn7n/f+98VxxpyQOg4URwRBcD9kw0Rj5CjG9u65FhYndMN27QDQ7elsT7m1Cfqvg5eJwxvDSCF/sCFngZRP2MPJDT6nhjr9WYoibbctXgiNrw+eRXOc5ofPsfqlPmic+L+WK9iexuqYNb6/Va46Dq0PoFIV2+UD6WrtiAaGD5ENJ0A9XPG1rN6e3y4W1k3EFYlWmcjHJKY0BFsLutU9XtHXizx0ThV/eBm2tCRdX5zv/3rWDYKPyR33oStVDsz/wGnr5/Z4Jgagq2g5WJkYKt7CWh/voJnrs5a8iesGvYKN3cNuZ7z4W9sREYJ3YNT0Ipw+qHDeXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9EUuycQzux6LMYInZ+fNgVyUo4Fk/YVictpKuZiMd8=;
 b=JBy4d6roTYrAlxjDjOFbqw9bkvw/grrhZRbcUcMWhbQxMWpoIKsPGEfwt+ggJmG5NS7awRLbiD5azyJ9jhoKdLnqc+rqBTO4uy1Lep1hSbrChnLpupJYIt+nJCKg96DOOisdfXTZHG62H0xmJfAX7ORJ4o0eydg29JNwB/MZcvte74OQAbfNB84fG2gXFcZEJbTXmik+YrAYnX40Tjo/wtqvISdv1s4bHMmA8QphIQFDMt32LZWlbVRYIaj0c+xf4QpCI4xLDUGpldEUT4TnttGGOOn3hLCOkLgdz2VW4KvnOg+1anMh6PpmWZBDDqY7zl+1ja18cO3LrulXjhjVPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9EUuycQzux6LMYInZ+fNgVyUo4Fk/YVictpKuZiMd8=;
 b=QYThugh1inx2xxmaTn/EjHQLSF/hgFo1SIejeiD2WOsHGqHNo7hTKgpUzlaQmlOIGk9ya+bdKldgzpicV3gk11wGgSV4cB8llEpp3jDPou7FYoLNaf5zv7UrtlNvAIaKDU8dMw/HESbWpF8DyLmDQPLnwP5bbSGa3btXnXYgZ8c=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4532.namprd10.prod.outlook.com
 (2603:10b6:303:6d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 08:23:44 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%5]) with mapi id 15.20.9611.012; Wed, 18 Feb 2026
 08:23:44 +0000
Message-ID: <79c34a56-4182-40ed-84bc-420185e6c593@oracle.com>
Date: Wed, 18 Feb 2026 08:23:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Bart Van Assche <bvanassche@acm.org>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4532:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c491faa-6844-4a1d-1bc9-08de6ec70809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUJteWFycUkzSnN2WWJPOFBFcG5palMzampnTmhOeTFNRTNicWhSSDhIcFpH?=
 =?utf-8?B?OWxrNzR5MkhXazRLMUZTTXg1b0V2WDV0d0UvUyt6MWV1cGFHOEs1SkpwSlJQ?=
 =?utf-8?B?cVdTcCtaR3p5aEhhR2lkVnQ0UUwzZVVCTmEwZzNYaFNIdVRUZjJOb090MTVS?=
 =?utf-8?B?c09FRDNDUDNkcU9VYkFla0dRanRHZ3M4N0pHVnlmMS9HZXZlVTJrZWgwNTlv?=
 =?utf-8?B?UThvWlFNamdybEZlVklCT2dNRUs4SXhOM1pOa1pSbTVYR0JMV1UxK2sxM3lX?=
 =?utf-8?B?MnZZYjZXekdoSHArMjl2UXd6OXBNY2VTdDIwamwzbUNNRFdVOWxwMDdtcTN6?=
 =?utf-8?B?c2p2OXc3UEp1RklITWRWbXYrdXpVeGJvMENFWDhqd2VVbFlJaUIvN1hmNytX?=
 =?utf-8?B?YU1SUTEweGJveUs5YWVpOWV0NXpzR3BBTGc4WUhLMHc5UWRia1lnZHA3c2Vi?=
 =?utf-8?B?RXdiRFVtc1Y1aFZSY0JHTkVYN2pVQm5iOUNFWEtXRWtORkM1MGE2VmZpMUVh?=
 =?utf-8?B?OVV3cGgwVjJDZ1h2OXVqUURkZ2xqWDd3Mit0WmltVzUrVy9mNC80MkxMMVFW?=
 =?utf-8?B?RUdpcHY0Zlc3SDVqZEF1RGJuSnE1RlpqTTVoaVEzeEdpaGE4NWxjL3ZDeU9n?=
 =?utf-8?B?Zk44NGRMd1pFT0djNjhCRHltUFpFNFBuVSszVkZ6UGtNVHZ5S2RWRllXcERJ?=
 =?utf-8?B?OHRMMU9NMGxKeElaTmI4cC9wdjJyRURaMCtSVEQyVW5zZUZoWm9QQ2tlVDZC?=
 =?utf-8?B?UVduUlJkUnU0cGliSnJhM0lrOGFOK0s0aEQxVVVhemhITjhKRFNPdVJZNjNp?=
 =?utf-8?B?dFp0bGN6dXRVYUw0SWQrSmdyK2g5MjFraEVXNzc1MFJzNkZTMnN1OTlIZm1n?=
 =?utf-8?B?U0ZtVmpacG1iQno5TUJEQ3l6MXpwR2t1a2lEUENsdk8vUERYa2FTWEk1ZWhK?=
 =?utf-8?B?cjJWZXhBQmd4Zi9yTFdoK2kwVTR5dS9XZE1BSmR6V1o2VjMvYTRoeW5mbjNh?=
 =?utf-8?B?SWZqaXJnQWZUcWpWM1NMT3J4T1c3RHlTS29TVlFkOUV4TndKZEVJSzJDMHRu?=
 =?utf-8?B?Q1BsRzVQMnJ6SXpFOE56RkhtVzlaM2kvRDlvaVlGUkc2bURwNkdabllERzNC?=
 =?utf-8?B?REhNc1ptbXJmZm5jWFJGTmRjeXByS1VhSW1NVTJJZlJSd2F5YnIwWUVzZVpq?=
 =?utf-8?B?dnY2U0RpMFZPejlCeGJKWUdRSkRrUTQvVm9zMzJ2WmtJd1dJay9hVGR6VUNV?=
 =?utf-8?B?VUtQZThRSTNCUWZSR0d1Z0orT1VXRE10K1dIbSs3MHEvd1JEMlp2ODlhbi9q?=
 =?utf-8?B?TlhuSkkvTkdwWTBpZGNtUHZkRVdLMWNEcDJPRE9TVm9yTVQyNmhDeWNSd0lw?=
 =?utf-8?B?Y1FBMlNpMG1NSkIzUFRUK2FXZnJHTG9vS2E2R2V3Q1lKcTRCaHo3MkJHNUlh?=
 =?utf-8?B?VlErY0hzQm4zeHArRWgyaWV2M1ZFUXp2dW9rcDlHVk0yNjJYN09lK1JwWHh2?=
 =?utf-8?B?RmdLMEhDdmFxUkEreVUyREd2cCtMSWtuNnFXekhkSWZoSkpkV2EwSGNwbzha?=
 =?utf-8?B?U0VKcWI5NHk0OXZRa2hGSnBqV0NpWFNHMEMzYTJCOWYyUHNVQUF1d0Erb0NE?=
 =?utf-8?B?amFlNmU2Ymx0Z0VzN01FTzBMemdIemFzb3BMWERGRUh1RUM5MzlBV0xBVHFQ?=
 =?utf-8?B?WUIxRjFYNDIyb3l5TGNxd0NoREJrYWRUVDRsbmdyN28yQk5Ed3d2MnR4ZmRK?=
 =?utf-8?B?YWVkbVYxY1g5aTk4RnYwK2pwVmJaelBpY3RraUYrMnA0MlQ0VW0wL0R5Rk1j?=
 =?utf-8?B?N0ZieVBpeGxLQktHaDVlQURmZHJoUGhmM1hPQ2FYbUFka3hoL3I1Q2J6YTIx?=
 =?utf-8?B?ZkR3QWlBUk5idDJJOTcwL1lQU3RiM3pJcFh0MDl5SnJYbm1xVm50czFjdzFH?=
 =?utf-8?B?UUdRdTJzVTRrMXRrbkNRTnpnNDR2Nk1EUVdtVFJVai9laEttWXRKSTB4aTZB?=
 =?utf-8?B?ekxsUXF4QmJjeExHTUo3cFVRTkNKbXZrVkhoOENoaG4yQ044SnN6VkFuSUFH?=
 =?utf-8?B?dlNIZzU2bE1hMVAwWUZJL0Y0TnBrME5kWDNaL1MxRkVYbVNNUVBwamZmSnlK?=
 =?utf-8?Q?57IQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ald2cTZheURzZjFjWFFXWGJwN2gyaFJoWWJuRWpUNTA4dUJiRjF4WHNYN29Y?=
 =?utf-8?B?bDlVdlc4ZGxtb2ZWSWplcVRpUTR4UGFPMFoxUHQ3WG1ZaGYyU0tEa0VMbE9v?=
 =?utf-8?B?UndnanVWelJwa1lORDVMNDZRWHlaWm5QS1F2SldxajYxdWJHanNJRjZOZXI1?=
 =?utf-8?B?S0xIN3Rwa1VIanNxWW9aNHRXa1FjVkJwYUdKVlh4S2pTRFdadEUyNWZ1amtv?=
 =?utf-8?B?Ti9PVk1DUytkTkpjRURXUTlDWXVHNWZJU2RxY0VKcG9MMmdmbnVtdUM3QTM1?=
 =?utf-8?B?endGWEhQVXoxbVozbXV4OGNtZjFPL1VXNmlDOGg1dzVTNTBDSHF0a3A4UTdR?=
 =?utf-8?B?SWtNWUo5a1UxY0E5SmJWRWZVSFNxYU04ak8zcWN1R0l2bDBSWVcyT2JGdXgv?=
 =?utf-8?B?d3FvN3RWNGF6YWhMVE1iZlFvRmNWakNTeVlhYWVJYWtPSTMyckFIMWxCcWxp?=
 =?utf-8?B?WDBCY0h6YTRtaFgyRURsckIwUHVnN0dKN0c3Q2V0MWl5Q3Ric0svNkl5YXhJ?=
 =?utf-8?B?WDB0bzZ0amxpOTNZQytIVTNGTjZGSDVTSVVRQzg3ejROclRSamoxc3RIWGM5?=
 =?utf-8?B?Qm1wbnBLbjJxRFpPMGI2SWV5U2ZPL1dlN3VhcG1NUFI3YUxFaUZUMjVGbHd0?=
 =?utf-8?B?djI1dmF0dXhmSndKeUJQbXRLNUZNUWZITTJiN1NLOTY0R05GUm1lTVJsdlpk?=
 =?utf-8?B?bDRTRS9kdTUwM3FwT3hIVEdRQ094d09rSFdSZWRJeHBFTlZxYnI3MFpIdUVG?=
 =?utf-8?B?M01yWS9BUnFxd2FIVThJdjJ4c0Zvemt4YkJYQ2VvbURiSnpudTJhVVRvOTBQ?=
 =?utf-8?B?KzFwZG0yWWlSb3J3ZW51NFdGYjBhb3hvb0NGOUpyUjhoQzd0c3JXSVcvTEVa?=
 =?utf-8?B?cHZIQWw1K3VJNzYzMCtPOFZkbzY4RUhTalFRWmg4L0ZsWkR2MzFwR0QxWGIv?=
 =?utf-8?B?dEpNdm82ZWlhaDA0L3lZbk1zR2ljc1FSY2MwUXJKN0UrTWtkK3QvVlh6dXdl?=
 =?utf-8?B?dTNoejhsYjhhNzU4VVhDZGxKVjh1VkdvczhUNExQR1hjMWd1aWhmaFpmcnVN?=
 =?utf-8?B?K0Y5WjhYWUR0SkxVUktHV0hqNGx6QWdRemcwM2I5ZGJWZ3pjbTU1SW0xRVBF?=
 =?utf-8?B?K1Q3cmd4U0JhczRvRExic2xmeEZ2cXBzYytFWWVzYVYrSHVYRzY4MkxrQUh5?=
 =?utf-8?B?U1VVdG1rTjNPdHdtUFhqdXUrSmtPLzRyYnRvTW5tTjRmRFFQOTNpeHU0MnUw?=
 =?utf-8?B?QmF0REd3dVlCYVFyV2Y2emk3cnhTRnJHNkJSRk0xbm5QVG5JY3dTakpqL25G?=
 =?utf-8?B?SktHUS8zbWJtZjBXbUpHdVVuUUZmMnEzcGYyVlYxWURidmw3NWlzUDd1eUFC?=
 =?utf-8?B?aDZJT3EyWFU0YTFBendVakhXOUIzcWVoT3FIcStDK2RDd2hYS0ZRTzNGUzRz?=
 =?utf-8?B?RUxaZEtHSW0vdlRxQ3c3aFNxZUxjTnpUK0N4RktKSC9USlFCR2VvTi83M2pD?=
 =?utf-8?B?SHBNaUN1aHRZQkphbEo5T25jRVdpVkdRcWdTN0cyTTFneU0vWlZlcDY5VS9o?=
 =?utf-8?B?N1JPbDlQU1FHeDBJaGdPTzFRSEFvNGRFaHR1clBEWkw3Rmh1cXd2dmlZb0Fm?=
 =?utf-8?B?UktrUTM0aGpRcjZvNUJaTXNnMjVIbjltQ05zdmdUWWtnSDBjQzFXSk9OQVdQ?=
 =?utf-8?B?LzVoaXBsVlZxQnNvbkUzc25MRmNWM2ZyM2tocEhsT0JkdFA3S2RjaUF6cURu?=
 =?utf-8?B?STdFNjJQbXMvMGRNWE4wZW5lK2VPM2FVTnpudk5zYTRHcXlENXNHbDZaQno1?=
 =?utf-8?B?bWJPLytsWEdpL1JONTJRbDhnek01VmxGdEY4S2R1YVdKMWpETmNJR0dHWUpk?=
 =?utf-8?B?U3NlcHBzMEdmQU55M25KT2xncTBMSTMvWVhxN1M0UmpPMXNlTGx0Z0htbXEr?=
 =?utf-8?B?VGVaWVduR2VQTTBiS3hRemZwYmpNdDk5aUJWUFBSaFQ0ZVBJZ2Q5ZzcxUUtr?=
 =?utf-8?B?SERwbVB5eFhSMGo2NjZzN3lHRWRiTXV3b2cycnRBN08rOUoydjFlL1BlWmcz?=
 =?utf-8?B?YnRTV2I0c3VtZ2FtVWFUUG1aeGZwV2IxckdZc0s4MjBRbGhjTTRydlFiQWdu?=
 =?utf-8?B?aExoa0R3RkdSNzZpV3NiK05NYkc5dXM4YXl1amppMlBtcjhMQ0ZpWXNCK0Rx?=
 =?utf-8?B?Rzd0eEZnQVlxbnRCeXB1T0RQR1BNalF4WVlsWUpPOXp6bUtSc043MnBTU0w0?=
 =?utf-8?B?YUVFRUp6RExIVkdCU1IzSWRBeDQ3YWNBeGpLRnhwMTkrOTQ2VkN1cG5BR01k?=
 =?utf-8?B?VnJnLzVaNllEcFFISzZSVjhrVTJmSTRPdEE5ZUl0TlhBWDQvcUg5UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DPoe8obDOLbaw6WpZrGADdT1LplIH/JP6HUFfrD36WcoCyAzLhLAOOPrGLV4WrlUBRSZL+JNoAbs3z2MGidFJiwIQ2jO/JXS/YiaAUXDvaySr2ippAfxy4CbE2cSQShUZjba1Ug1gNPFN8YaldEIxWWmqMSdtw7r4HuQFz5YzVNWr0UT94yFdyVF2XESmq4UBXllewXLkjeJGpQ4QvI6y777fxxrKjneouAR6xwIo4d0ybpDzXNIN/TuVv6k7yyy1KlDrQOZCJPSlfLI6q5BVknoQ3cvBXxpt7v5cAjtC2ZLxOzlgmMbklC+ZUYjLKXqpqQSd9+vL2ejptDHEdlhksg70gLesSSuy772zJLxG50owCPogD8i5EzH5zikvkhbc5pQtpzB4JO1AIAE+BsCtTFbKD3+I2FopDB0S7cnmZifpO7SMhJbBoeiPrW7KYOhjVvO5evPJhyz44KrS+v29s80Xw/WHtQJlNMNIIUilF9f5/nDDictEK1B4EWYCHyo0a4ARm++xrGSBG32wGD5Le2ppVwmpN9dJB6YW3FKVJKZqmZaFXMuBZKipqsrMsvkSgktLpvb+vy2BKFeJO2ucHwFAAQFoiPfGA8uZS7vTPU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c491faa-6844-4a1d-1bc9-08de6ec70809
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:23:44.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00vArPVo7wNmzckluJfH2oYQibwF1PQvulaDwh/lEV+KHf6pN9YeVIWVHlU58jwb6/8fKfRS9ryO78ZZW5uCeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDA3MyBTYWx0ZWRfX2y4EpFZ4kfcS
 reYAPYHPSTZTg91wv+b6NjLAzbgbPSM4UcQIRpTfyGZR4LwBR9j1G41wUwEPeT2cWD3Y84Eas+C
 JxeYm9Hibij6TfgNBXIKd5pQlw1y9sfHa3Vjfi8qC2+ZlUvTunF+4E4EsBEWgT6W3AAZfbEk+um
 +QKdRZBdwE0FVyb9P+KY8iGCykZoPxEZwliAaRNNVQmZXpXOPQ+baUfRBiCytHWJ70+eoe6Bwzz
 pCBWkED8SXoKxagIl7VJfCXCf5jS3JvyESEkZvSaUwMvLa7PV8MbCc7mg6w2I5hpLxZcYueaQPu
 GQjo4GMyjUYpQ+qqtXu5dWfxWxD+ATnYCJcmxdXg0VTf9Unvq0tC2zlQntU7l+BrtVSBGa+a+eY
 Gbv7QEL0d3N+zX+aCwTfI/zbHSZ4jS9DAY4JTNeKbBzbcMe5OBZmkJixpYTTvN6+FLgA4kwfYj8
 G0tTqt/evoUuIYQwqtHSpcxHLOc/STnsPgl3BU0Q=
X-Proofpoint-ORIG-GUID: TJikv4eFbzqg0pC-cHxy80mhbUjVFJ9g
X-Authority-Analysis: v=2.4 cv=b/S/I9Gx c=1 sm=1 tr=0 ts=69957713 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=d3iZZ_kny0dZnE7O9PwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12253
X-Proofpoint-GUID: TJikv4eFbzqg0pC-cHxy80mhbUjVFJ9g

On 17/02/2026 19:33, Bart Van Assche wrote:
> On 2/13/26 6:19 AM, John Garry wrote:
>> At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
>> Let's discuss this topic at LSFMM.
>>
>> The idea for this is that SCSI could natively support multipath, like 
>> how NVMe host driver does today. It is intended as an alternative to 
>> dm- multipath support.
>>
>> I have been working on the implementation and I plan to post patches 
>> in the next cycle. I am looking at a 3-stage approach:
>> a. create a driver-agnostic multipath library, very heavily based on 
>> NVMe host multipath support.
>> The library would support features such as path management, path 
>> selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
>> management etc.
>> b. switch NVMe over to use this library
>> c. add native SCSI multipath support based on this common library
> 
> A minor comment: maybe "in-kernel" makes more clear what this proposal
> is about than "native"?

dm-multipath is also in-kernel. It just requires userspace for 
config/control.

The key difference is that "native" scsi multipathing provides a scsi 
disk which supports multipathing.
