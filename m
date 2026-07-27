Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EABF3B7B7F;
	Mon, 27 Jul 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785167117; cv=fail; b=YHf4aurSfLcMRxLMuDF7ANGgZxltn36cv5OmUuDH3Cgw/VKYrp75J6IcRwVCinKrf+KrtRxrmYl9cCkmClGxHw+H1KSipo7wlU0d4KfDxxbz0PfWem4WdndrVE8mmTHKvtxdnKrEvUehVsxVpHuz287X0796peZ5uasBS9jUsAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785167117; c=relaxed/simple;
	bh=UMo3BRvpr2VNsxduLvgrQmcQvk4+Dq/4mb8xAY9oZUQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J8CAqj+vws/vBAQAvmJK/xxdVYmuGEuJUo0Pp7o7dyQRHVvxi2DA+EEFG81yTTXoxF6YBqySjBz1ZQ/KFFTDdVo3xzF8e4q9FtsT+WRSTNNs1cKs1p7NbgVUtj5aroDnMeOax16KSvdGzdrH8/aRhojbpVGomQ+BYwwR6JPEsqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hXGKbBwH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GGSsYY+9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hXGKbBwH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GGSsYY+9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFXWES2378124;
	Mon, 27 Jul 2026 15:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YNvbkfhTTtaLd7BSVlAhL1+CGPPSBToGQb2B5kRAhPA=; b=
	hXGKbBwHbNLGHofpNKHpP4zld5uaJZ9VA2bv34d4Hojm3XPlio9CTaW/8A0DUTgL
	eXqGS/rEBux7YiVhfawIa3CERpiD5G3na48WWlfpFuMipi4oFJUFy5vNhDFIMszN
	Rt1IoD6F3R7tLkpYCkN2iYJNuw738xXOukDFXuiL/gbC1nMhVnEtI5jMbNFaoHt6
	Txp/23eF8EsgeXlDEnWNFVfTaIJZL8mbZCLQSsBW0vHxxw0yZEJCZAYZlCHMmyAa
	v9O3Iyl66ulOYj9YwOEx8ao0nwrtwGqQHhD8Dcqnz1aLQjC68gEynIpbQM0ytoUt
	1ivkzdsrfWCfa8KuNKuwiA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1da2r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:45:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFjERD027741;
	Mon, 27 Jul 2026 15:45:14 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011053.outbound.protection.outlook.com [52.101.52.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh889mw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:45:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vg/EOTdjygWYs2QVcroA05TgFjVWINUbpnHIAPq94bQhgmXYQwWaMx9Dv7/uXZbRN+x97D15fM0RTdmwoVn5l3SWo5DvkNmaCOsM3ZEgrHKaU7N9UWA5XR9efnXwlsp7ooMSgkIJe7kmJSi5AM//910DgQ8CPr9/0P1RHGU93V94964hl5ZDQq+6/II0hoZZloeazhz4i+P7NlxblmNCEwo7tRwdeKrdCv11aUisTMz3qKSAZQAB5U3r5NcV1N6i2JgF+b43MI191M9TKtIeaDU+zcGjofaThKULwxPHIn8EnfXToauZvxG8f6L6XiCV0/C985rl251z+LCtsWbDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNvbkfhTTtaLd7BSVlAhL1+CGPPSBToGQb2B5kRAhPA=;
 b=kG3KyTeazsQiowF4daC1W2n0Z0sYANVXb1KHeoFqQiitCQsn8TIeo9un2OOP62WxsvDHACGkxnnE662nCKV2KLxkLShql2q2aTfwspyXN6eJf1qHsLtj8Ip2gY5ySz+kSq69HjJK4EYyG3VHf4jWMxhyi+cfY9cZdJ1buxR+Y4SApoNTm3oyUnTrpOUs8LTa9qVxs4/f8QOCi0NcM3vvtEOZcpG2OK4JsX+Y8U4fz0553oFKODab8d9TrOCxk9wzk7mOrg55hCNb7uYbdcEbKKn9Tn8vjEbAMXfAsJqiSP2YEjf4Y89VZYBrTBRs/T/z3K4mfyPPSHW51A+9okMt8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNvbkfhTTtaLd7BSVlAhL1+CGPPSBToGQb2B5kRAhPA=;
 b=GGSsYY+9Y6IklKOxean04AgP2bgFFf80ttTK3wqRtdumi+xYb0FH6CAcfUVIhzpfaLKztS+MpIhogEkeX0rKpQflFswXBHXrDm5ZkW7NmNgkGeJkZmcW3PKt0/G3GhbP8XaSIKFaJxr8QSInD9nzh+9vfKAFHx1OLJ3VZPgHAQo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:44:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:44:28 +0000
Message-ID: <5920f26e-26ff-4825-902f-a2836e9402a0@oracle.com>
Date: Mon, 27 Jul 2026 16:44:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/27] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-17-john.g.garry@oracle.com>
 <20260727151430.9A09E1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727151430.9A09E1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0432.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 547af088-ec28-4271-02a0-08deebf5f19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZemMsjUCQkZAvDXcmW58oKe6StKVPmt9+zizNYcRskZPXpPmUskk5I1qGe6VaKU5b4KBCCBC7h5fWnBeMB/333gO2LQj4vqJASxV+1xJ0ghFCekpdOFp+doWoYisODdO6Fhfvc+TSQ3xF8H/aO3et90rBKZgNQ8JpYfjvBqg7EC/fihFErgRaCfGgqLBVwYI+6IFUbG9ctFEUFKBybRd08ruXNOOZTwx/WOGHd6t/HxrqipoW/XQYfzjDEMXBiXcT1A06rQc31pPJAzC0JVWRcwD4oqeBD/y6dhHyWaXx9J+zX2gcB5P+peTkejiCsprvF46RyBfzoApYOarzjJ8kB+MsxEwTbVgbwSjAsC9ZS65HTf3gw18Bolw7q0s9iFpR1KW4e9Aw3m/9hXhMsPCQVRIMR7LSV1hM3uZ/XkKsVLVDh7iLRyxG8EfVz8nqOAgL3NS1zSUjuuwVDdsh5/pG2JOVV5bk4VegDDj1ijzViTND5EyYCci9FiAewoX8SDQFRqzuwIq48h4OeatmMQP/zgFIZW5LziDLdDpgPslL5bGMVDP3LuFcwbDy4eWuXR+wbNkDvUdn+rzG3U2PW918TpX5ljgWuQDjoQzLf6XWgoJq8szLPcWn9UkTQ1yZqNniLB2u+R2DRM/PMsg60LxNw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW5kaXd0K0lEdGZRYnJCNzlxcnlCVHI1ejREb3B1KzIvaTlNS1psdHZYS3Fq?=
 =?utf-8?B?ZnZnSjJDODB0NlRKblZCWnRySGwyaiszbHFyODl2bnNOaENpNGlEeHBtWlFS?=
 =?utf-8?B?bjhUMjdneVZ4K0NvdkhDbExzVDEvcVZLaVZrQUR0cGhjN1BNK3R6Y21Ea2Fn?=
 =?utf-8?B?RGpWV0kwWFAyam5SbXB4ckFUWFIwU3hOeDgxdE9HanVOTVl4QVVWSkNCMXZN?=
 =?utf-8?B?SExvTEdxZ2tYZ3RjQVdSaXhrTnh0Z1I2cG5wVVRDb2dObVhxcjV4NWc5aTV2?=
 =?utf-8?B?WXpONjUzUDdmandjQzh1dUE4Q1ZkVDBJV1ZLcFZac21xUmw1cEJqWk8ySEg3?=
 =?utf-8?B?K3VCc2lCdTlmQlZ1WlVWcFNZYThvTGJyVGozT2J0ejNOTUd6ejEwd09kVW9E?=
 =?utf-8?B?dm5rakhHd2NqTWRuQ1pmUHBDbDVseHFrQXZxanFxQmhtanVGZDVxV3FwRldL?=
 =?utf-8?B?cDZnWHZQOXB1allJYTNHaVNjdFVkdVQ0ZEl6alZWcnRkK2RYeVZVdzZVWUVi?=
 =?utf-8?B?K1YyVmNFbmhteVJJZVYrUEhQS2hqRVpPMWkyTDBDQytLdFZpN3c4eERxZmJ0?=
 =?utf-8?B?SklBSFRIZC9RWWdIbUhkM2dDL0F1eUtqZE5vRVhnNWlHbTRVNnR2UDRUQTNa?=
 =?utf-8?B?UGo4bllWNWxxK2FxVElPUHI3dVFJS1EyY1R1TnZaRWYxWlVXNWNoeEN5bU9o?=
 =?utf-8?B?aVFxZHZPMXZBaUdZaG03Wm5mZWdLK1ptSmszTmJFVjAxN3BwbmgybnJvTWpo?=
 =?utf-8?B?NnRuNjBUczJ6ZWlhNHlFSW5kTTU4UTZtaiswcXZaejU3dGwxMHZycy9BZmVO?=
 =?utf-8?B?UjdoYnZSNXhNVFhBWEtCTVpwMmpyT0YyZWJqQWYyaHJjSklSM1d2ZmxFcFY2?=
 =?utf-8?B?UE4raGpTRDRHajdKUTl1aFJuQTc0OEgyTnozem5yUU9QaUliR29hVEtKd1c0?=
 =?utf-8?B?akRQdHdYTlFwSlhpLzZsY1JCVi85MVorY1c4dTJHMWh3UzNsa1EyT05taDBX?=
 =?utf-8?B?aW40dDVsOSt4L0toMzVxWXU5ZXVCc2dNQ3Rad29zWWp1bDhWMTM5bUdkS1BG?=
 =?utf-8?B?V3B4ZFhuTmhMT0lWNnFQVVN5S0h6cFM4TjZ3N1ljMjc3a3VsdUVYc3JvQjhi?=
 =?utf-8?B?RUdyVjNRNkl3ZzEzUzQ0OG5wdWFDbEdPcFFsUkdwc3lTdlFoWWNJRFp2UWRa?=
 =?utf-8?B?c0RIM2xnczFDWTV5TU5ncnB2THBOMnZwWnRHQWYyYzZsUkQ3MXJZb0FCTmNW?=
 =?utf-8?B?OHltb0dEZTlNdk84c2hPaDJhclp2RDhrMm1uR1JBVnhXL3ZiZHFMaDNvNVBw?=
 =?utf-8?B?U1dnVjNFY2huOXZNa1F0RVoxVmdrK3k0UVF3aVVSWmlITE5ZQ0habVduUXlm?=
 =?utf-8?B?Q2Z2YmtiVThxQWNpQzlBWTkwK3I2NEQveTJlT0hKZU5CU2p0RHIvdE1sVWVS?=
 =?utf-8?B?bmpYaGV5RWRqdmhab2JqWURFR0tOSDk4cHdrZlpZSmNpUzdtZEw0bkx5QWNo?=
 =?utf-8?B?OW1aazZYN0t5WmtpVlZpejRURUNmelRpNyt5TElQNlU2cTNtQlo3aUQzR21P?=
 =?utf-8?B?QlhuVUhjMktaVXVBaWxwR1Awa2VGdGhTc2wrL2xuMVJwWkhGUytqWVhLSnJq?=
 =?utf-8?B?ZTVqVmpoWmpMdk1JL1VpZWZHZ1FNc3EwOXd5M3ZwTDQrL0hXREhsdndZWms3?=
 =?utf-8?B?ZlE4eHFzejcycVNGZVpsZXJ5Rk9aTFM1aGlwd0hJcnAzYktzRkJmbUl3c3Ny?=
 =?utf-8?B?K0J4TWNpaHdDdEF5Q3lHTmhJV21DNEV1c0VsUHRLZHc4cFFkQ3hyTVJnNjRa?=
 =?utf-8?B?cFp5MjlibkJHeVlXZVo3c2c3T1ZDUjdqc3E0L1ZvWWo5OENLN0NkQWNKU0V4?=
 =?utf-8?B?dGRSQW14Mnpwbjh6YnMwRW5OdEt6ZCsrWWREZGhtd3dDZ0NSa0RpckFESUU2?=
 =?utf-8?B?enRDb0VldWRxWGx3akVsTEN6U2xpSm9QeVc1Z1JoQUpEY0ZkK1drZjJxRXNG?=
 =?utf-8?B?N1l2SjZjYnBPcGJMRWgxUmY1aFI1dFVVczQ5NFRyRlh3QnBjWk4xQ2tXS2Vv?=
 =?utf-8?B?dmFYUUV0NEJtOGtyVUwveDNsdFdldWxNWWtEUEFBemRmOEozcDZhSkZiNXRy?=
 =?utf-8?B?emVKUkRjaU96VXp5ZVJ0a1B0ZFRaOENxWDYwdlNhVDY5dkVZL2N1OVFmMWVN?=
 =?utf-8?B?SjArOHJqU3h4aVVwU1lXdmxYLzRvMmwrWTczMHo4NUpmN0dGd3lZZUsweWlT?=
 =?utf-8?B?aXhac24zZU8xSk52MDVTRkJSdmltMm1pUnU3Q0IzSlVFM3hiN1lOWmVwZXlF?=
 =?utf-8?B?N1hOZHhBSUhTOTdtRFNaSEsrSWtHSkNmK2szbHBYS1gvNFNJbG90SGVob0FF?=
 =?utf-8?Q?dFYfoRnS89DPuEdU=3D?=
X-Exchange-RoutingPolicyChecked:
	aKBLzWsmKqM2uiu9a98V7ELtwvaHhjziAEkMoGrYixPm2t8k0Qk2x7YHtI1TACzW8Tc8TIhlsiPBDPe7NYJgpJvekel2NCw+cex2ygg144ZNuDMUGjnvh5PP1iX3K67vmALYeOdHjyaqaIOUfbwESUU2JnXDDD8vN3OGYISvBSuJNqn+A+MU0Y8Vy49vRjw1+SLPDqUsnzzVYcmQSVfQl5BiA/sAJVkrgHmrwFicfdHxBV2eTPsZtG2G1w+GLUxxig4Dgev3bO0hfYPVJk7EGhw8AKKXuFkCJ5gSm5ZOx7tTFXu2g2Y02ahJ5V2qy6rySkfO9wJLBJcQWB5JUpIpJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zuqtKcMkvSYeV8wcnk6emLKhOQOqk/36pxCRn8KOUCzpEzWlMq15AQ2jE+yn8sbmlHDw7i7WjvE80UIfbzyUyA8rOZ7xl+ICWOvIxg2wis2XFdFUJ8jgyh+nSNPqRctVaS9L1fHo9Mw5J1IAEiBIpKPqKJeeNEdAHKvyW9//m4xPm1B1LYExsP/B6YTzeWAAfO/5NTQyFnc7lpH/xYJTov16kNLf97tEGcyfAW7PtL7KrC8sXhqKJJg3uv9K/LnZUlHmlxrAxhlhFl4DKU6hZkUlk7kSSGd2fcoXV5CyX3wPX5b/e/barS//wnUFLK79EExdz/be+mMfWwghYyM8UfpDcnhDPKqIGg7U0BAq8YMOL/16boJ3HMI4HvfA8xxvMq9aj9wHRHV1wwKF1A0NbUW1/E7xWcexqseicWQ7l+zrxjusNc9NbRhZT3iUTjK10o3em4foxJ65crUxuIZECmovantuW2o5kStFZg6InuGPytz3TWjqQR9GgZgIo1JG3POtuPDR5A5/4lT4YhODomN6FZhTcjhPrfY4At4ydRxsMESXX3BGJlIFfqJWCehTx2LSRJw3yboO/gshIrlGsPIYq8m1JzsTqZ2penQuZ68=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547af088-ec28-4271-02a0-08deebf5f19a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:44:28.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luWk1csQrYFPFLiILmQWzDmNPrmEFCkjwYdxUUa1WR5mVTG5JrqCQQfuccLdpW6ibrBbIHEIyp+jrJsWtdWS6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270148
X-Proofpoint-GUID: EFuuwqo_vvM2PyJyK_yhE0CyAhDgQVqt
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a677d0b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=dxJyO9zlfY_sU9gSqSoA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfXy+8cPnqztDYr
 DPQ+744gUHkKl7+srAzGM0SQhGsL8B6hSA1lgZbZKRnTtrmn1JkL0CXGio4c6J+YOJSj1gMeXDA
 tYX5guTbt5ulmQV1q+WluGJ0j8ly/nPUBqWDAdGU89Z4wAqdbJSu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfX38EhR8KcK4QB
 xxBJgZcEAz98RylW4jxs/EiABVtxIsQyGjeltxYg8wBr/spZmACD1l+Z88RH6+3wAe1C7FnhW7v
 /mLVmz1zCb10/PuE1ZvjcQDrLROyY5iMq+fr5Og1xwdU3wuxhKFw92ygkpzcLfA6LGzdEMUnrMY
 H+oU4SOYeEePoLzDvqpB7CbTyAjdjiYq/dfrNm5fvJo4yw9g3+yKTDVtsc835q/S6TC4jFLVG6n
 kOitgUVZ0Vk8dmIQRjgzJfE4VHnKoRni7DhWdDX8ir0wzJZNPjwgImYQQW1dxgSqekTtQiUpwof
 KVNzpf02kqe3IgtAsuIyPpVHOCs7HP1K26AO6mdXpQJDB/6alTO1OUux84uW7H5sI6D3Lwf0JXC
 Jr7KRMVH/bUJQXt/K2T4q7XQajatfOV3ezVkB3MSIgFZ2pJMDNtwdbNPDOdT4r/o6CAOYXgWN//
 ij3Y7ZAVI7a4Bowm4Tg==
X-Proofpoint-ORIG-GUID: EFuuwqo_vvM2PyJyK_yhE0CyAhDgQVqt

On 27/07/2026 16:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition in `scsi_device_block()` due to lockless access to `sdev->scsi_mpath_dev` leads to NULL pointer dereferences and Use-After-Free vulnerabilities during device initialization, teardown, and initialization failure.
> --
> 
> --- Patch [16]: [PATCH v5 16/27] scsi-multipath: clear path when device is blocked ---
> commit 029c1109c722c76acac1333821c2190171087cb6
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clear path when device is blocked
> 
> Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
> blocked.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index daeb3693fe559..a1ec11050090c 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> 
> [ ... ]
> 
>> @@ -3008,6 +3009,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>>   		scsi_stop_queue(sdev);
>>   
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((err == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Since sdev->scsi_mpath_dev is read locklessly after dropping state_mutex,
> can this race with device teardown or initialization failures?
> 
> If a concurrent teardown or error path calls scsi_multipath_sdev_uninit()
> and frees sdev->scsi_mpath_dev, could this result in a use-after-free when
> evaluating or passing the pointer to scsi_mpath_dev_clear_path()?

scsi_multipath_sdev_uninit is called late in the sdev teardown - at this 
point scsi_device_block() should not be called

> 
>>   	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>>   		  __func__, dev_name(&sdev->sdev_gendev), state);
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 5999c59bf7297..801d95652fc6b 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -231,6 +231,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
> 
> [Severity: High]
> Could scsi_mpath_dev->scsi_mpath_head be NULL here?
> 
> Looking at scsi_multipath_sdev_init(), sdev->scsi_mpath_dev is published
> globally before the inner scsi_mpath_head structure is fully initialized:
> 
> scsi_multipath_sdev_init() {
>      ...
>      scsi_mpath_dev->sdev = sdev;
>      sdev->scsi_mpath_dev = scsi_mpath_dev;
>      ...
> }
> 
> If a concurrent scsi_device_block() call sees the non-NULL wrapper, would
> this dereference a NULL scsi_mpath_head?

why would we see scsi_device_block() called for a device before we even 
call scsi_sysfs_add_sdev()?

> 
>> +
>> +       if (mpath_clear_current_path(mpath_device))
>> +               mpath_synchronize(mpath_head);
>> +}
> 

