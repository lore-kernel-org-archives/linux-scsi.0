Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22457581D;
	Tue, 14 May 2024 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715691266; cv=fail; b=BUhFB6lE5forWJ4ykSN/0zjcPe/+pCqLLvw7CfwDnzygneKeeO9lvCiLXjvzTXfuDwuJE7hF4gd5gXTDhIh2DNpMM5odKplQvqslF7jvAymoLA6QYBjf6epdaoROnTOsbdalUHpxNz+vdNpOwppv8+MPf09njPQ+lwo/wNzE6iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715691266; c=relaxed/simple;
	bh=wi/TtpyaZUfJKZuUMHRslsn5CPw2p8OpaA2kRl7JfPM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TzX6h2KdalI2Us73JZXLDuHLaxMsXJ8P/JZXhBu9YpYZ0Mn9VTmRp865OeFe//VSdR3WFI37gSRjeAf2a45mKlODbs0jGqAkER8BiddDhkEglkRfdMP6qxeSoDVpszfVzQ3fKDKB5n3aDEuTYMbBMlq0CZ7b9RjKSOYmnTzu7ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A8jD5Bz8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VRJ/NxIf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A8jD5Bz8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VRJ/NxIf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ECfu52014469;
	Tue, 14 May 2024 12:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=2U/JMg/hHKtCFCv96onVYNqYzvZJrF4WNcopyfuM66Q=;
 b=A8jD5Bz8UzW0C7SidldLv0EOcSi4Lu6xkVkkxAEu2TwqyNR0LD2DV+15Dg7TJbYERQxX
 XeE5SuxBl7pGAK+gqlxgOixUflThBUVqA+YCKiGP3lIeFKa/q9jL+C4Wi5y+keeWXIBk
 Q9eUxT1Ic+BNUgKrYTaGYAaB/pYwiyseDXraSRozFUsKo1rYbRMERfWJV2/PXyfhJ3xE
 qD9tbjXlw1DvVvv+KTyieS6Hv4Q/S/O+/Mi3h3cIyg0yhNIovyQEK7nv1KnBU43zekwS
 PXD3DHAYFS1NZtT8/cAtXQ+ldgXF6jUooRI/SUyczr5Jr+SF5pOozoum+A5XAecbZxDp eQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3twys6pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 12:54:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44EBEwO0017476;
	Tue, 14 May 2024 12:54:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y475hse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 12:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe7WnNmh+XEK8Ue6kwr2fYnjGiB3zgwocCuvr79PQHSsixKnZgjh0NxcRhbv828tWc6x0+cobJT6C/5Le9QtKGYaMMUfpm6LzZUqcrSXBq5zDVvzuM7d0ToXxXqf1aeOJZahVy6PgJ98IJNA2rdKLQRmsVSZnYoIMIDudIqMmtNT6Jsp/BgNI3NtrnzhMgONXy1hpts65PgOS0oGNgiXE/cOies/qLY9RvGup06GkNOFXXpcXvxTINHlwA7F4V5gIDCLAyb8RehsLFSl+d/SltV1Wzr9V/u0IQJrcYtV7g13iIIfXiHG1PTkMUu7L9syFE7y/nziNHhQ4cYpqgOezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2U/JMg/hHKtCFCv96onVYNqYzvZJrF4WNcopyfuM66Q=;
 b=F6vXoAZvQObTfYywcwe5VsuBej+jNi/9tjYQzqtFXsk5OxTNigb4b3HmEPSSRQ1CQ7/S62THjxwQWmYbXI3tjEge9drra8mWtD/WupaXYmn4oFypeE5vlW83OgmavxKBNu8TrGsOQ5pOGEzcQC9xilFm8zPodstLKN59OgZvd3gApiM9gOj4ygK0jep9tR97xASGBTsN0kka3vhae98PmIZO8KZp3p0ZUXnzyQ1fmtoCD5EW8KOZoqicbuqh2pp9Kz8OJixLw6mW2rGXDIwg2ijk3PkcOjSY1A9MEvqBbafMbP/aGx+hXvOTzlJdjggK65noJrkHAoXzE3Sfd6djUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U/JMg/hHKtCFCv96onVYNqYzvZJrF4WNcopyfuM66Q=;
 b=VRJ/NxIfW//Ya/tcLKenOs0E6DUQOQy2R0ktmy0oPsRmlEhYvDlO9stYrIXUUGwNiD1HySQrM41/s+hK9udf1Jo09VWvTyyb36BlE2J/v2vmOWqP+8xftT10fqYzAub6E5ffae/W3X+HHuGsSvpuBUzZBvg2b/qJ6C34/dnbbZE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5862.namprd10.prod.outlook.com (2603:10b6:303:18f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Tue, 14 May
 2024 12:54:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 12:54:03 +0000
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, regressions@leemhuis.info,
        regressions@lists.linux.dev
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <c4e8e0b5-fc32-4e26-8c0e-27a996769903@googlemail.com> (Peter
	Schneider's message of "Tue, 14 May 2024 09:07:55 +0200")
Organization: Oracle Corporation
Message-ID: <yq14jb0twk6.fsf@ca-mkp.ca.oracle.com>
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
	<yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
	<c4e8e0b5-fc32-4e26-8c0e-27a996769903@googlemail.com>
Date: Tue, 14 May 2024 08:54:01 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c962ab5-f02e-4b4a-3d06-08dc7414eeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?DuI0LgBUs/3t+3BR1mPfEYSzjqeUxRXUnACvBmXpiK0XBW/tYwvQoIsvXMpp?=
 =?us-ascii?Q?oFhYa0ANoiI0qzHzUi3qaSRlOhbAH641c4ZbyQfanZdct3r7qpb78R9UeI0N?=
 =?us-ascii?Q?L9B8RrjJPjseqfS/Fh1/bgx+Os7+JLEgnIuRyxxH9IUjdzOVKi6JFIxF9Yo3?=
 =?us-ascii?Q?GgqWt9RoVMZj3ApLuaNVtePmSzx8NaeXZj79SBwQidnXdzX175rXBn7DOa8a?=
 =?us-ascii?Q?KRiHZxSYqwxsjEOWjxKGQl/X9gPZ8N95eK/dNmo/7N8eas2tLBJIgIdUWMg2?=
 =?us-ascii?Q?jyB3x2zpx0v5TaM/HBlhMj93jqt1Ohe/2H/+yD95vEq8Yo6ijSAimRopMBns?=
 =?us-ascii?Q?/uru6da3WW9LwDxm27O9oWFLbHh85NYKcez7JY2I/Ono4OfRhVAIQkeg99q0?=
 =?us-ascii?Q?9MHvDjl4+s3CIzV6cnv9zLGZsGRpZ93pKTgzuTrvKJ7lTJnP/UDVkrV+7kmQ?=
 =?us-ascii?Q?HnmCoJtBE1KeAIHXm0rDhyj02Rd0asYDvWEQ310RlfPt4/2ReOVL2dMyzcgI?=
 =?us-ascii?Q?nUvBPSCAZKIKhN9OL8sDbACz36Bj3Q8r1WpOyovTnCB+IOz8OIR55KEwrTvw?=
 =?us-ascii?Q?u1N5Gd4yYQp+WEa2ey5guJlPWWw8tFwTAsnrsWV2+YoU4woiR2Knm9pZ4Iju?=
 =?us-ascii?Q?q4As/tIOp5nRFxU6/TerDfKBwBDO6cfWVuItpVnQBHb8txIkszKfkcSTlUhK?=
 =?us-ascii?Q?2xDDAEeFJ/yfxJl6RyeVXqPsx3Emek7Yc/L74QoWVPRrCVVa0MYA15v7PxS+?=
 =?us-ascii?Q?dzbnwqcsahQovwG/zONmOr45STBufbYJ8Ojdz144Pt/A8hNe+Jkdd+cxPwEV?=
 =?us-ascii?Q?u+36xMbU6cm+O2W5LYmtxysGoiLfABXUXRxIuETqxtkQUXnNhD63yGONJtAd?=
 =?us-ascii?Q?9DpOV3S31ADv8WP0hE9MFQPLwdsoOXrLAe9mUT1VWgoMII0P2xjCF1uta5Eu?=
 =?us-ascii?Q?KpeAXN1PQXtrqMqEKXLXFe2C40gjRihvef5Fzz5X8KRr0VQQAvUVsRCUS6Vg?=
 =?us-ascii?Q?cPBZV2WkOqOynVgYKBjH9grBI/g8LTlbCKPKOZga2/9DW5yOwkASInvTw7X1?=
 =?us-ascii?Q?uG43mkCdu105fuBAvG9f+GK9sGyTzwiwyHZn0k6e9ZgwKvacBc4iHiO4FdqZ?=
 =?us-ascii?Q?CIN3pTcGLM+TbVr7a8c8QkNz7A9nyxKQyugyBDhlsuz0xyAP3y0zijn1sn+B?=
 =?us-ascii?Q?40fRGhu+YFmug2dAtaF92p59UtFQ2rRKomfSvm+/7KxM7DGFWBq6l26eZYSI?=
 =?us-ascii?Q?RoTtyBT7jtH5drLZBRYVZGkH7ycGMH4oQGELWgJLLw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NlGNpxdCgo7TZQ38G2gvUqh4HCU8eczY1ETGnc/+SSZ8j75w2ssheGNJksqC?=
 =?us-ascii?Q?CuS0rtcW9LL+0qEhHmqTH1gwvZ4Pcn5O5ICDtqMAvd0HuRQ3ZRFLK8L6yZe0?=
 =?us-ascii?Q?Rhh+nG64kcKNiH9ZjZoVkTP+K5xoJz5sAaAITzVVZeLnAS9dLqKEsNMcz5OO?=
 =?us-ascii?Q?kDykjVWE6fXqgP1nakLZUDqN6exLl1RtHJvlv4Lk4xj40eS3OQtnWyRdEtH7?=
 =?us-ascii?Q?cxGXbaOitWqFn5DjbqIfkDe2/lfGi3lqS0I2U3CbV1j5WQAjvn79mXi4GK1m?=
 =?us-ascii?Q?qs7BBuPMmQ4lYE7gcfcNycPQA7o2Ie++7ynY+6uUaf2piJb6AUiyU1oNlNEb?=
 =?us-ascii?Q?6/jlGa/DBMG4bq4wKBNXzn+60uGpFiFMrVV/mzAHIESYat+Vvon54ZQAk+2d?=
 =?us-ascii?Q?Zvr2KZjXK0rUH8UUH9dGQjgXl43cIPSV9RsMCO5OKzKk0ydPmLproG4mvQO1?=
 =?us-ascii?Q?6fVVp9mralr8DKlLwkWo7a9FOf568BJMZFToqfanudhx3PobAz1cS+k6W0Eq?=
 =?us-ascii?Q?gio6nnFMt6SKQLoQMxA9AEjZjSy3TOm2bEgS0x6V9O5b6cv/mxQukTbOsnbG?=
 =?us-ascii?Q?lJhufqMQ/xITqr3pfnC39GLouvOpWnGzokI2ADcJqneN+WFC7t4Va5hxoXCN?=
 =?us-ascii?Q?UspsrZbPAiTqUVE52yXUwV8OemJ4/BNm9iVY2FWW4aJS4Ljj0MGklMXOzen6?=
 =?us-ascii?Q?2pYJxSZR9iAqoL9iEVtqkk5ax/92v024lkS0yDczog64rl+igHsAk7s+OX17?=
 =?us-ascii?Q?rtqXfizS+NHnnKmZJ9zNyRgSedqRPGASRdL9cqZUwa4wH4HtNm0s51Fw9K5/?=
 =?us-ascii?Q?+E52piPPMum0EKfd1UiVmgWU4gKs7UBFHW0ylA8imjT8QnudhAqEc0E/m6GD?=
 =?us-ascii?Q?aFp8MhqKwsUonr1rbvGlhPsz8u1DKw0k3QVIpo00kC20DLe8SeKhbyv/Y+fj?=
 =?us-ascii?Q?fTncPS2Uzxpq8dTbIIkDUZEoSsm9Df/vGjOqUVDwolyb0Sh/puNmkwIOF5Sb?=
 =?us-ascii?Q?tA8zpozc8VPkkIhHtmhR3kCqW4PaVFN8+kFzToXjOWUHMICti3z9Fmcgp7gQ?=
 =?us-ascii?Q?fEOVNAhssqB10cbbj1VyxR/TupCDwQl1ta5sNOQHnREmw5JtEGcephi4ajFi?=
 =?us-ascii?Q?SDF9CFENMfEPWQMhM2dYbfBsROBerHrpEY78qX5RIpAJ20LquhCDmMofUu99?=
 =?us-ascii?Q?s6nKEXCHtSzjT+y5PgO61Um7rsYReJj5J9CBLzj0StUGyo/KeP1YQipzLzZs?=
 =?us-ascii?Q?D9m+Gm/IcukZZd4JybcNM4TjCgbcZCwkInURdyeCvw01mDquUf3WroWNRxvD?=
 =?us-ascii?Q?j89MTPi13Q2O8MnzDfw9I55qcoJAGKGLn2Dk1W232Kd9K+b/MrLD2B9+rofb?=
 =?us-ascii?Q?/P+oZ+k28ag+++fEyGTGKg/p9R2xvikA6JRKfvaMlECFwYHPNuNvW57m040H?=
 =?us-ascii?Q?IKlNy0QD444GKodDjC50ZJsolhkC9IIvjI23a8/EYIoU34xG0vf50q06znzf?=
 =?us-ascii?Q?l/2kku831ro1HYe5dtB2am4ElNLls0utHxoUwksK6ysgin6I3SeHTZYUOM0p?=
 =?us-ascii?Q?mVJVQ29xG1ETlXVaxMg+Cr1IdaPfBjALuRHZQLrzijDiTcckeSSH/hXQSkZZ?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lpDOd0vKj2PYqARzVaqaHJSYJNdF8L5umSnDp5gl8duuVYhGRkthRc0rLq70cFGbx/j74k9MPO1Dt0x2MHQBBNehof8i4BWwRysN/nv+FolpbEm99DRxToSWzYEN/xhpcXayxtopGVKBTIhSHmifuwEDSc1+v3GfwbUZNy2E+uSNVadwkBLQ4aCGGCNeIiPY+vzH9V8PZKRuMc/PwQaUyTr7UIB9uzOcWyTZC07AGIh2N27gtybopga39dCzT7xnp7jwvckea+QyZYnAENnahsZ2rLdUPVkX7r7btvwDajG62VAWgmZLIWphdYBOxdcLzUu4bLj1mMOxCz/YtUzYr82WfUw1XwGKmvwdgQzZNAilMRrkBd9WyC2I+vEAjqcGygWs6N4MC6AcDjxeu0Kvu326PnD6irte6CoDFB8S8pL4CChaP5kbXDlmtJMM5HVlXHxmoB0BFlIdnxpu1PGwfD0Bl2qNE4700QlpzlEopwkePrjEh2SFuoIZAfSbGFlyeb1QfboZ0QZfWwqtvF3yVLTcI00zQ3Hf9MvtiR/SNdvK6vu090jgcQuFrbTSugQochsZgnEEtQQsP6JlDd5RNI9KE3jgy/FOE29SMXHcx8o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c962ab5-f02e-4b4a-3d06-08dc7414eeba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 12:54:03.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5t6Y2Xg7C0k3a+8IVuTrKYk1yUKJ7Yfmt3lsAMHIzMSDl6jAvgmBrKMBxi8zKYPy2FOBNNFyMlLn8x2vx6l6D493AG/n8QSbzrJHQvsGmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_06,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=789 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140092
X-Proofpoint-GUID: 18yZQzJ5wJZgbZyu8-4xor9TZP_3891C
X-Proofpoint-ORIG-GUID: 18yZQzJ5wJZgbZyu8-4xor9TZP_3891C


Peter,

> Did you have any chance to look into this in more depth? Do you need
> more information from me to tackle this issue? I'm not a kernel
> developer, just a user, but I guess with proper instruction I would be
> able to compile and test patches.

I am afraid I haven't had a time to look further into this yet due to
travel. The annual LSF/MM/BPF conference is taking place this week. I
will get back to you as soon as possible.

Before I make any recommendations wrt. firmware updates I would like to
understand why a change intended to make scanning more resilient against
device implementation errors has had the opposite effect. Especially
since the change in question reverts to how Linux has scanned for
devices for decades.

-- 
Martin K. Petersen	Oracle Linux Engineering
