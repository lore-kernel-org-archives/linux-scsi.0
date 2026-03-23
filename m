Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774763AC00;
	Mon, 23 Mar 2026 11:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774267193; cv=fail; b=SegZZj08qsrVUIdCVw6FO5u5isTs3enoh2wR844HjKnM6oWXhW8wCSlGfmZhtDlEjciVqVDJOXz6RlU3pOB+QSGfoir4KWbouDwJPinUQxzQSS2sYKuUso1XbXZYYTHk7a81Tk/qxB3mOt1P5fD8dLn5auk5jT8U1vtjdKZ7zL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774267193; c=relaxed/simple;
	bh=KHFOG8avcp1yF8JRyhuz4CU7+lnI57cXaSnL2tnSk/U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CGcE+Qsj3bRHkdQVIjCI8ygrkmhTnYLqeLWmRXNgBeckvZiU6hQ4QuBKpgAS6PLccm6vGlpoD+8J5VkCYFDpJZgqEAsLKG+7HnY9/d9gK2ahEVJ5MoqGbS+HQ9KraGFp7E10d5sNjsyA6YrsqgMUBmGs4GzKOW/68oPJMe9HCds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eYK0Xdvw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UNYNkIPK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eYK0Xdvw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UNYNkIPK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N1Sxqp411577;
	Mon, 23 Mar 2026 11:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YtSXgVYhdwpLrLm8I2X047nIgDZXiG0RLApxAaRT+Fc=; b=
	eYK0Xdvw1/gunjyXmHhZtp+P6LmBsShioN2nATttsaJfje25m1qK5Gb4qY2R6s0J
	kp+7oXDsThSVA2UuraX10C9RWbaVi6mOdPTn/Q2ExirSxKZUdCs8F9BVCGEirakn
	OXS2vE5U03Zt0BYZcCOqYkBH3faHttLJfPze2gqOT8gZv0tt/RA2iiGPOvXe7Vtj
	dF7Q6QJ+s0ZjxQYwDToHNi7j/8Sp5jQ+kvedstrwNMk1Kn+trZUBX02MXe4p1tLE
	RKSjxiBA12QFasQmLIiKGleciKUGFPSHSSoSr1TtALYBfs67RQ6Qmmg9zNuXNGOf
	ywiUdxUSxZ3FNSnyEA+qRg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kvnj1bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 11:59:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBCNIN038940;
	Mon, 23 Mar 2026 11:59:33 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8exrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 11:59:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XH0bFJzn6X1YFvZh8dfLn2fPP88sqBcdhXk1DASg4UZEhOQUni6kHZ6Cgmy1atadLAp3jpMTVAIqEcQeD5THIv/zwn3ucGFcRedAV68Yt/Yu48i5K7JBvWZsQHGkuBZ1Kaui6A3UVSdLiDKLjtTm4jkzS11vtbM1mPGsCjTeXptzPbaM8svlxbfN2PdS85CYz8QlwBRY3aUVPS84zt9gDxRlJm3GvjiW8gn6PUxOEZnFUNDxtT3oDJOrMkcbiC1RWhz//j4XzStj1sWoIOyr7h42MvW38XdKo9wkQVx05az67QBGtWYLw2Qu01KDzO+2MlHI1Nv9T5jh2BO0nvYfBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtSXgVYhdwpLrLm8I2X047nIgDZXiG0RLApxAaRT+Fc=;
 b=laUQJQLcJ5U/XEYuJEPH+cWAfqdiKV+56fXHR2uuDJzQVRPdz3neTpP3Ez4dPNBfsqphi5hOV18bjhXRySgDIWFlZHOZOkKLuB1sV7jhUHVZtxPo250Uu9lXoVX+ZuxLfoNtK+5JiYg3eArnofPYGnsycJQJevWoLgaEN7U8uRmKi/GlWPOuaQm6S4CuAwUlBsWR5aR19RAmquE1cdhHta/RcoRK/zXuB7Q4owDvHujvsl+swh/vkv0qS2fRZ6lvCpLKbdQeP8UWQqbk4u4dNaw2fi2GkJo25bhZ3MYvtuJCp98+etdZAPiZRXWJFDAR+U9yo0tW+KVdwt0CR+W1Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtSXgVYhdwpLrLm8I2X047nIgDZXiG0RLApxAaRT+Fc=;
 b=UNYNkIPK7j0VH3YNN7aP9KPvmrzi2GoDJenq0uBUlcygczCIBgjTRgS6+xJe3FbhAV/1Pftw5ykUzmP/jiIyWr+KSQn5FNSXHDpDL66iWzEKopHFRyQ3jaJ0q8kkbnOWjbKKQhY/bRTzlR00A8SFNSZHe7Jny7rBVXANSAmvHmU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MW6PR10MB7592.namprd10.prod.outlook.com
 (2603:10b6:303:242::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 11:59:30 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 11:59:30 +0000
Message-ID: <cdb891d6-3f5f-4bcc-8d91-fb46dbd1fe55@oracle.com>
Date: Mon, 23 Mar 2026 11:59:22 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] scsi: scsi_dh_alua: Switch to use core support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-13-john.g.garry@oracle.com>
 <acCbsAISEJC2VfwO@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acCbsAISEJC2VfwO@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0088.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MW6PR10MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: d51a1131-ddde-41ee-28fa-08de88d3a3e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nghQfpJDf62CMSvebag4Fyu1KRoxtTTl93H9m6N+q5XzpodNgdK/94IbpvHuzoHbyq0qELBlspGA9WtPJoQnnsqwgyTlA1QtH6gM4mxdw4AfdZ2SbWG1f2fQs3ToCdxHF1/0bYksUExvEUaPBfDHeTmwvtxr7a0ItRdaqfCxjr4wuUcID+JRF/oVgv9hqkhjRzMocmMv0wIh2ynaYD29tD0tv/MRgyYu5QV3ivej/6fuXxW55JIc0Gl9bdAvXSJVZjsEp1cRg1vZKEFxdAWilBANSPclM1sF7jFBACTJqxvZZaBiqu20lZ6GP/rBagpNgghSmc0wSe3AqI66VtW4EgWfoAblQz6VV6QiRbSEp30rxjO/wL8/w7uz2HSZ8RX0HYih4oTSmVwTsAyXgdSF4m7m/OB1i0n5zvLAGK6DK9Tkm/8GgNfNnVvA7KE3v/pm8v9it5AfaBLwwdLVyLQorBfieHrQLCtHeW+EWvYsCPoM0S6zTHCEF/J0IEHKR597zHCw3rCb74l2i2aBE68rSkHa2oCjJFOuWih+7fb/27Ly/YavuAxBZ7OxUsYXZCMuz0Ark7u+PHFwvYFpbcbHkBDaEzKexg+oJuXd8pY0zlUYOZiMGeCMhNkQuUHLSUkjqO4pS2Cwl9whaCPJlKdbY2aCNioT7lPrxw+vN1IhcQAKoF0Rb0jPkHXmKlZDkQRXcVXlZoX9CH37yUw+nizXtWlmm1mg8wafCkOvjLY1F5g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXpXLzBEV2pqenJJeVdBVWVPZjZpK0o4bzdpVVE0c3hrOFp5Q0V2bjBGTWlp?=
 =?utf-8?B?SElPS2ZuMkE0WnZpL3lXV3dVZnFMKzhqL2JjUWMrQmY1MmlFOVdVaWxnV21E?=
 =?utf-8?B?NWdYbVV6OFN3UUVmNGZWQitHNGFaRDhPZzhick1rVXpOeDlrbGxDZWZuemxt?=
 =?utf-8?B?MnRWR1IvUEhlVnZDeUh5cW93WlZSNnpNb2JPZjdmM1ErMzRrMmV6MTRSdDht?=
 =?utf-8?B?Njk0ZFFsb3dxTEhwMWZFT1B2SERWVXJ4OXplbmlTeVpMaU9kOWdPK05HY1lK?=
 =?utf-8?B?WSs5RTEzSjJNVHlRRE9NMitIT01ORVR5bytlSmdEVUtrOEEySlY4WnM5RDlW?=
 =?utf-8?B?eUZlZFVhNXNhRlJmckU4SVM2UGpYc0pBeWpjbjhYeEJrK0oybGFTTWZybURm?=
 =?utf-8?B?Y0VqdG9EWXlpRnF4U0NtNHBybjMrbUd2dnl6ekdtS2lQa1BoWE1tTVNIckg1?=
 =?utf-8?B?eHhPdmlMSTNyMGEvaTVaK1Bya0VBTkJ6WDdIc04vLzdVT0lIcnZja2ZacEsv?=
 =?utf-8?B?Mk42T09pc2h0bUw1R0NiOFBIZzh3dnJaTEJ3V1p5UGdZeWtkMzNzcFA3MVhl?=
 =?utf-8?B?c1pNVVpXZWxjcXBrK1lLY1V4U015L1B3QVdBSmFSV0IrUCtHWi9jc0lGRWwy?=
 =?utf-8?B?bEl0M2drakFWVmh6azJSS216ejY1UkVTVXhOdEJFdG1vekR1a29kekdjVy90?=
 =?utf-8?B?WElkdDM4YzdHSG03S251ak5IOEorUTRsOXNUYktQUW5EWDhQeFAzbitQOGpn?=
 =?utf-8?B?Q0o1bkhjK2FnRUVYZnBJd0xFMVFrK0hhd0paYXZYSXFYMVNtYUVtUDF0SlNX?=
 =?utf-8?B?UkdnbkhjTGxZbHVPNEI3cW5BenAxRmlWZXBKRStpaW14MWRwSjhLY0JKeWV5?=
 =?utf-8?B?cEZFN2RKRGdTVGpURlRFRTY4d2d4eTYwanpkeU5GTXFXQ0xPemJtYlBnK1By?=
 =?utf-8?B?U3d0UUQvWVRvTXh3R2wzTE9qaHNWUWhtdmZwZGViTzlSSG10UTZ4WTNsS1RU?=
 =?utf-8?B?SjFZTzF6OEJmUlVGMnZuK013QnZqVW1TaFl6ZFJrbHB4M2VuTlFLdGVGcnN1?=
 =?utf-8?B?eHdwRE81dEtEWlhMZDQyM3ZWdHVDa2JNRVh4Mndvcnk2QTZJbG9MOGNZWStL?=
 =?utf-8?B?QmRqNGxwWFBYZWtrd0RTbmNnRkgrWUlKMTVqK09aZEM3aUlGMkgrcjd1NTB1?=
 =?utf-8?B?RVBZMC9INnNYMW1vK1VSVlNHQk93Q3ptcGxjVFViNXFsaXlRS3cyTVJKNXlS?=
 =?utf-8?B?RUNFQWN2aDFCNUZ0TDhhRGM1Rk1ZMHVxa0g4T1pZMCtEVlBIUUxQbURTK0tY?=
 =?utf-8?B?c1o1bnA5V3g0YndCSDN5TTcxc3FrTlBwYmY5MkVUR2ZTdU5RZVhGV2JPb0l5?=
 =?utf-8?B?Q2JnSEtNY0tIeEJTYUZzVmc3aUVXMzVrenIyTWxJZHU5Z21LajQ1a1h2d2py?=
 =?utf-8?B?NXVVR1JaMythSXFnaHo5NkVSSUY1bEpvaWR2KzVPaTNwUFFMRlZ3WWdIU3hp?=
 =?utf-8?B?T0VoRzVENW9YdkJ4NmEwYWdPRFg4Vkg5ZjMxNVl4K2lTOTZvbC9GZ0l4OE91?=
 =?utf-8?B?TjZiVncrQU8yeEdvT016cjhncHFISW1uLytOZisybUtWVW9ubFNEV011TTNG?=
 =?utf-8?B?WGdBTjdmdGFoMkhiWmJmcXNGY2I1K2VvRG1WeTM4emZXZTJzNmlJTkJIZ1FP?=
 =?utf-8?B?eE5FM21vRGM2QTlIUXdFbXBMYW56NkRNODduTkJ3QVNxcnZrVWFZVVovd2Y5?=
 =?utf-8?B?WkV3OFZLQlJKTml1SjdKM0lVQTN5NUNyL1k2MFdIU2ZObmJLTzdtcnQzTFBv?=
 =?utf-8?B?cmdZMnlCaUJCQkZLYmtGRkh4bHozYlQyM3FVZlo3eDVQVHdXTExtUGhZazdW?=
 =?utf-8?B?cXhOeEZMUVFIcTBtU1FLV3NnYkVxQUJxYXRaa0RqZUhrUFpTYVRGQktIaGEz?=
 =?utf-8?B?d1hwSnhzcVFtQUZBamd5bjRPOGtNVU1EK2kxUy9lKzFBb2hwUWNHZTdsNW55?=
 =?utf-8?B?WDNUNUlUL2pmZjhMQXdkTTljRHBieUNiWDk4Z1Z5ZCtBMDFJSkMzVDl0S2x3?=
 =?utf-8?B?ckdQOWZkL3BDVjQ3MmQ5V3huWnd0WGdhQmlDdW5NUC9mellrUHZKWTdjR1Zy?=
 =?utf-8?B?cDZROWlHRm1YOGpvSGd0WC9LUVROTEx1ZHNYdDdyT2dkQU1BUGc4VkUxWUV0?=
 =?utf-8?B?QzJWamR4ekg5eUc3bGlvZkxlV2dPbDVERGROZlQxMGlXTU16dDBta2U2ZkQv?=
 =?utf-8?B?dlB0Q1B6SGdUMkdwQ2JrZ3hRZlZDaSttbEpvNng4RHZoZW1aRDlFc2ZBRzhP?=
 =?utf-8?B?Vk9KN0JyOVZ6TzEvZHY2ZmhpY3AzcHpMQ3ZrYzVFbjhQeFVBOW0rQT09?=
X-Exchange-RoutingPolicyChecked:
	L2L1XnKaSYdfxuS4FnnUhb9TN5yYHTGZ9Nd5sa27vVV7dSzwa5Pz9IkRkV24/Nnh0TvaSRo2VUTHqSH7F4r1TbyiKP5m80XiFrwgIqSzie2DJaA8Jp3o//t6SKmhgKsjRtrDGAGmjApj8NZXG32ux9ulRZUGUX+GDeDTaW7fP+xKCb4eKoI2AoBzSbuJAFd3/eMoKbhEGbu6KYykKy8cL4jmaBbfWzyQtFptEXPofbHgbi5tAAXMbZav+otKI/teuTS2H361tyeHJWwq6jHTOOmdBGGr1Yvm9najc5c1fwAW30/8TVKj9JROAszUBxhJ4YsO4bglQLCPVpNEt4y2kw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t3xcDVRU1OrKDbh5KwNHE0piapM1QX2GaUvkvmiImOeqaH1IxS4yfgZ5soeVjnhAguiSa7r18a3CB6GspBsxGuTpYcM8Tsj3FxH/BiqgAi5Nz7bFF37sAlmswQ7LkWDnhNPDT6ZCKtcbGym7t2nC2CV6nPavknpOiCsrOHjrXP29GvOySHlCOykB37bLLBebADjKggGFNfX9b5tXwv2SC7RAYaakXEYSvK6M3O3rBf81a17L59stCR2gGjis7LCP71mHvgQYq1DsX4d1aghPFCsj718s0t1BKsSlJVAxQonW708jURm10w6FTbqX9aYhCXaxpSDP03o46n7JKid4lSwTp97PJvfpHBVmoyBtn9WDG9VXbF5/nHhjVjrkOMbPAPscLsKtKcr5P+6yleJ4ga1xfT1KaWZD7kzgCaSHH6IviP0cBrnJwU4Lx1j9g0UWoL9q9Vw3OTCe23plZbV7iQe3qM9oly5HmoQIKRH50EdGVz/YC0xOqUE+7n8v8SjplITz7OoiM1M+oAOMBzJunvWQwJ+c2vs+Hw/HaxEmmMUS8Wps7Q9Q7pccAWDUGjPLb9qj/mh2WEUCHncTj50IsHA7vWjOxYlygrwpPChdt5A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51a1131-ddde-41ee-28fa-08de88d3a3e2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 11:59:30.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2vPkN2B1dw7OjLmN/jLjFlm9/xnNixirg0x6f4vDzZUgAvIec4x4D1OpVxbnEp0UbSU6O7XqIycecXGQFtinA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA5MyBTYWx0ZWRfX0YtQT7fmVDno
 3dt/Dz55ChL5ROZqdrJ5XCPElCrt3aQMSmbyIyfdBINPv+E23IA8xjihCEGSHOOk0ZjX3Y3PNnq
 Y8BnEtChoSOa/mfSysnextVxLAPSbuf6D5fOKDIUPvjgObV7ZzoJqqRMY1Ish2nO34Ia3Ln8wru
 elQrhxd4IcC/lIUPlJJDQporRrBR/03WVYEy0vzknMJ5J3WN2nj9QrEPjxAhT4rY6jAm6560x+7
 DVU53ktiqU0lvJNU9IgbmdQ50WtmrMzzj8BQjthcGcmzkAQJ80HTqs1KCjkP19YKEe3O8XSMVX9
 YekCj+U+AXaqySfoPpzPT3/NCOXAoDNnaknj0ehr2ViebIMsZqswjSWaFMfaUSueCvfUFtOqxdV
 qonaCAnjvXEerGfJ92ohCLML+u+ZTYHvEdNTvX1hDndPsFEtUZHl48BsDeUVcZxWD+hDhLeO9q8
 52lX8SpjODuG1Hi/GTcnzH2tga+16t30DtP9abo0=
X-Proofpoint-GUID: tLtV08hGFbwDnLgLbGXo2Ci7bpYeqtTI
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69c12b27 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=2znJukxa2pHsbButfqsA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13824
X-Proofpoint-ORIG-GUID: tLtV08hGFbwDnLgLbGXo2Ci7bpYeqtTI

On 23/03/2026 01:47, Benjamin Marzinski wrote:
>>   static void alua_rtpg_work(struct work_struct *work)
>>   {
>>   	struct alua_dh_data *h =
>> @@ -670,56 +179,41 @@ static void alua_rtpg_work(struct work_struct *work)
>>   	int err = SCSI_DH_OK;
>>   	struct alua_queue_data *qdata, *tmp;
>>   	unsigned long flags;
>> +	int ret;
>>   
>>   	spin_lock_irqsave(&h->lock, flags);
>>   	h->flags |= ALUA_PG_RUNNING;
>>   	if (h->flags & ALUA_PG_RUN_RTPG) {
>> -		int state = h->state;
>>   
>>   		h->flags &= ~ALUA_PG_RUN_RTPG;
>>   		spin_unlock_irqrestore(&h->lock, flags);
>> -		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
>> -			if (alua_tur(sdev) == SCSI_DH_RETRY) {
>> -				spin_lock_irqsave(&h->lock, flags);
>> -				h->flags &= ~ALUA_PG_RUNNING;
>> -				h->flags |= ALUA_PG_RUN_RTPG;
>> -				if (!h->interval)
>> -					h->interval = ALUA_RTPG_RETRY_DELAY;
>> -				spin_unlock_irqrestore(&h->lock, flags);
>> -				queue_delayed_work(kaluad_wq, &h->rtpg_work,
>> -						   h->interval * HZ);
>> -				return;
>> -			}
>> -			/* Send RTPG on failure or if TUR indicates SUCCESS */
>> -		}
>> -		err = alua_rtpg(sdev);
>> -		spin_lock_irqsave(&h->lock, flags);
>> -
>> -		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
>> +		ret = scsi_alua_rtpg_run(sdev);
>> +		if (ret == -EAGAIN) {
> This no longer handles the case where you want to trigger a new rtpg as
> soon as the running one finishes. I think it should be checking
> (ret == -EAGAIN || h->flags & ALUA_PG_RUN_RTPG)
> with a spinlock held.
> 

Yeah, this is all tricky to handle, as the code in scsi_dh_alua.c was 
handling the error codes with the state machine, and I want to move the 
error handling into the core driver.

As for your specific point, I think that ALUA_PG_RUN_RTPG can only now 
be set from outside this work handler, and that should also trigger the 
work (so the check on ALUA_PG_RUN_RTPG was not really required). But, I 
think that I can just have as before (with the h->flags & 
ALUA_PG_RUN_RTPG check)

>> +			spin_lock_irqsave(&h->lock, flags);
>>   			h->flags &= ~ALUA_PG_RUNNING;
>> -			if (err == SCSI_DH_IMM_RETRY)
>> -				h->interval = 0;
>> -			else if (!h->interval && !(h->flags & ALUA_PG_RUN_RTPG))
>> -				h->interval = ALUA_RTPG_RETRY_DELAY;
>>   			h->flags |= ALUA_PG_RUN_RTPG;
>>   			spin_unlock_irqrestore(&h->lock, flags);
>> -			goto queue_rtpg;
>> +			queue_delayed_work(kaluad_wq, &h->rtpg_work,
>> +							   sdev->alua->interval * HZ);
>> +			return;
>>   		}
>> -		if (err != SCSI_DH_OK)
>> -			h->flags &= ~ALUA_PG_RUN_STPG;
>> +		if (err != 0)
>> +				h->flags &= ~ALUA_PG_RUN_STPG;
>>   	}
>> +	spin_lock_irqsave(&h->lock, flags);
> If h->flags & ALUA_PG_RUN_RTPG is false above, h->lock will already be
> locked.
> 

Right, that is a bug

>>   	if (h->flags & ALUA_PG_RUN_STPG) {
>>   		h->flags &= ~ALUA_PG_RUN_STPG;
>>   		spin_unlock_irqrestore(&h->lock, flags);
>> -		err = alua_stpg(sdev);
>> -		spin_lock_irqsave(&h->lock, flags);
>> -		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
>> +		ret = scsi_alua_stpg_run(sdev, h->flags & ALUA_OPTIMIZE_STPG);
>> +		if (err == -EAGAIN || h->flags & ALUA_PG_RUN_RTPG) {
> To avoid a race with resetting ALUA_PG_RUN_RTPG, this check needs to be
> done with the spinlock held.

Yes,

Thanks,
John

