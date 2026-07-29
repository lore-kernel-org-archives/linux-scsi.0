Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F8645D5ED;
	Wed, 29 Jul 2026 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325026; cv=fail; b=YO1A1T+oUxHw0RngW1hS90kQP7Td9vvzHaR3OmkcUq/rUYGPBLXcr8x/oZ79syBr5KOHNheduDeo+4/NmRbJ0tId+isQXzr+ZEUhpYGTLtbyJsb10kNKeZjzti5Ug9jNf13nGZ+x0jhXBfSkfKCpiINjDVSJj0z7fD4lCWh4244=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325026; c=relaxed/simple;
	bh=X6XBZkpeMzIQ9wuTWM9u0tq9j8EEPBzpxC2SlCyhDho=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qd3ebhC9P4lwpzJnYPDYKjuhuuldpSjJV64A3vMm6OHzxpD88kmUvMbalsJvoFrhj+BDjj2oM+aaqC76GwKqWeZgnzW0AvvptrfXmkTiNeuWPrL8Kx7u7FeXqaMfyWToEozl036SlLr70kphGS/52DXFT/eISwZWUrL82aUf0d8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PZvd1O1c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Rxud3qqK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZvd1O1c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Rxud3qqK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TARNFU1094296;
	Wed, 29 Jul 2026 11:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GsxA+7NjassBB9E3jjItRJS5AiKMUrg694b151H4Pro=; b=
	PZvd1O1ce7Mf7uxo1SUYyDZZNFIi/XeTpedecl/eB0j7IvpClxm0qArb/YmoZKb0
	J9PzxnSRR3af9nS3sdh+/ucu84TJ25+derBKDrp3uSGFfXIYKLUIftEPX5WLmX9y
	u3OtVxFpJd+GRWmpbDTEMsCr4oxxJXkjNube+NGuReWxIzEwhhA70wKyvt0IzFt3
	rM/wEtq9hdfSuVtBNr5px5c3vgKwbrslilwoA5j73V0HYG8PfqCCx5X2spSzvRhO
	8RjjAWNXA7NMmobYfsbwvNrMusp96DTCp2Y3B09Ryh8X2e2C198Gk1Z+dWPn8A5M
	cJAAtTdaxJmHWYGA7itW8A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5muv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 11:37:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TBZZv2021402;
	Wed, 29 Jul 2026 11:37:02 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dupe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 11:37:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDnWYO9d6/GulTtnvDExDKQFscv83PCd8SjckQnmD0q/uTWwBzXmQHrT0NEKs+EokmAkGitKdTiMzJNVhELIjjIVepgam1pMERRY+4jfTKyLgcMi1pVhNhIFuPkoRu8FWP3+A579IBoXnYQDHgbhEtR3RcdEBlYEP3mcDSHzN7zBXu1vOvwEFfW8JLoM21GqevbhsEgWX5AAY0Dg8vS0cPnRvyd6n9UkbABBqNUBY08AUOBcJx0FzKpRvO1QC4z0i5tMoYi2GfOc9Q230DHXtvDhN+y+jhjQurP7Ca3EW2osIwq6vqt9CrJdsxtJK/VtNtaIur3LrR4n68txPfjKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsxA+7NjassBB9E3jjItRJS5AiKMUrg694b151H4Pro=;
 b=Sn9hAo4vaOMvyCwxrzl+m2R+ByNbPZTuxezfOe2MZqV9FZoNbydE2hJIqJUUJltuNic+yGShhF0EEBLV+T0sBtvinMthq03H1cSxY2EWpn41OhhmegeYjUvq7DAEpbaOBg4qvIAAmZoeaK8PXu6RokPxadBn/HiN4gTQsn/JwBM01Z5mSVcgD+fC9wrxLgVCX7HCoFIenOGUENJYV8+W6tFQhaO6V2AOIY22Z9ShoCPxxR0T2vazzzUGcXOGKMFHDMHqUgScyK4rhxADacLuHr6kTJXq+gzU248cm+Ear7mL0/g2gasIGZrE53SKzCeUzs5aXZ4aQPTYJc6ybrLH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsxA+7NjassBB9E3jjItRJS5AiKMUrg694b151H4Pro=;
 b=Rxud3qqKCXsvc/NdQLW0uAC4+HDTil5G3YI9g7x9YpdzIBOO0B2ZyW3vVqH76n5c+sdcCp4U6sOLDdpzzPyHodBJFfLBNu03c47kJAUSGaHxqtIYl8vD7S9M8/e17kLQbLuwBWXieZLjQAz/YP6VLtX5ToHY9gS4lynCdZT0AHI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS7PR10MB5926.namprd10.prod.outlook.com (2603:10b6:8:86::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Wed, 29 Jul 2026 11:36:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 11:36:59 +0000
Message-ID: <82766d1f-62a7-4148-babd-93b72b15e830@oracle.com>
Date: Wed, 29 Jul 2026 12:36:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/27] libmultipath: Add basic gendisk support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-3-john.g.garry@oracle.com>
 <20260729112003.AD36B1F00A3D@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729112003.AD36B1F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS7PR10MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: 23fbe37f-f6a2-4666-b49b-08deed65b3a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d2hALO7HO8spJAQ6VvBL5ZtbprL0Y0q21xpAEW9MvXlnur0j8wAeL5cdyzDsLDtLljD+sZs1Hjd8RwX7AjkhEdO1J2vrFZZM2jtjGocy8vSB4H8bHdLRU0jKbibOm+JcjI6T0jiyj0E3UlX90reeIacTZ0fsZRBmHJH2NUjvADrywg3GOUuHfCRUaiyaEVGJDlMiUvHQPpqTL9cvWgVymDMednYhzAEB7Sa54p5xvCPrY+pB1Ucv4bFmo0dVZG1DOHbyBW0OqBQxV4azf2CsQBguIJTXRVv03DLIhtrhVUnotiIUUpD9fkxnazOnoY65FpH7XCwizxXMTMnt6inSbnGDdJKjScSXOhKGA4+83mMCCJND2TQAv4ujOfr9NPY1MjSBvPxMIIT4JW/G0BRaganUjh/ZnFDKl8O2lWX4lm2LHJpG5NaspEGq7gD1WWtFD0HlegHXQC5d6n8aLpKntzkbVu1sZkAQN93ax8BaX7r2N0anqk3iHnzAaRLmG2zmXNbePq5LEtZPmJnUOp7Y8k3fpw4pJc0dKOA6cuAiPByYKqU0PUafisq0uWx7/8I/y5WvjsQ3hLWAfZ23G1B1+5aF2tL3uZcfQBcs2901M2yRSJgqplJrBuaZN2xRw60RlnVhf3WEcL7vOud1kZpNW1MKIN4GocHdicXYGjTRRPc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1Y0ZGUrMGtNSFZTbnVPOVRDWlgvQXE0eXc3bTR1cDN6Q1RUYmxrSXgxSW9M?=
 =?utf-8?B?NEpvTTN1SmJLZkdyZ2RRWHJkeGJGSDFldzFSZi9CQVdIRVZxT3F1RW5Pb1hL?=
 =?utf-8?B?K3Vqci9MUmVSS0hXM2hPb2xZaFBuQmNhOGMxa2ovN2x5ZUZlUU8xSXF3cHZT?=
 =?utf-8?B?S01KUmpJVVpBZFB2NDZhRmZTNU81NUh0Tmk3cC8xQ3EyTjh1VnJvbnJDT2dK?=
 =?utf-8?B?bUh0R2JyQVByUENXdjNZRGQvdmxJZFN6R0xScW8veHQ5K2xjQ0h2cmFqU2pY?=
 =?utf-8?B?MC9Bb2d4cmNqVktPY0xqdG1WOHBLcjkyUFFPSUthRHUxZUs0QTNHelFKWXN1?=
 =?utf-8?B?bXpuUlFVcXhTbFdqSm54cUs1bS9Tc1dqNk9aR29CV0JuWXJ0UEluUWQ0NHUz?=
 =?utf-8?B?YWdxK0Y2OTBUTWk3ejFTc0pqREs0dVdPOENFc0tRZlYwQW5Xa01VZk1wNzE3?=
 =?utf-8?B?b3Fqd3pIa3RlUTM5aVJTc3VlSG9palZzeWV0WldFSEZLS0JucGJGSlBTMTZF?=
 =?utf-8?B?dGcxNTdGY0NyV1RhMnRxeXVPTndMNm56NVZ3d3FDSUc1aVF1SDFmbmlTckZQ?=
 =?utf-8?B?eUxoZ21vOUZEUVRNZHNkU1l0UldVWUp1cXdRUTBaenJXSGp2TXJIdlc0SUFM?=
 =?utf-8?B?UE83dWVLcXl6RCtVMGFsUUIycGpmSUVNWVlFaTNpZTM2dk1jY3lZMHA2MjE1?=
 =?utf-8?B?VXI3TGFUa2laOVpFKy8yODIxdGw2cy84SE9LM2U3QlBDQXVtR0VKV3I2YkxO?=
 =?utf-8?B?LzBTNitiZzdPZlBUUW1IcFhpQzh0bml2SFc1c0RQZXNmZlh5SUZNWUsrd1lj?=
 =?utf-8?B?bEJJYm1yNjdNbW8vYW0yZ0Y2a1l6WkErdkxvVFhuQmFCL2pQY2hWVXpUNDlR?=
 =?utf-8?B?c1BWOXhKcFdHaHZQTU96elVTa0NnY0kwVW5xa3M3U28ranRNT3Y0WVZ4SFpT?=
 =?utf-8?B?UE9qRDZvdFlXbWtXSkdZV3MyRE1IK3cyS1IraEVxdWYydzdsYXFEZmttOUlw?=
 =?utf-8?B?VE9zSWdjZENwL3RGcVpRN1RDZmVJSWR2aHErZ2V0Z25nZjgyL3VYWUh0RktC?=
 =?utf-8?B?T1JnNDRCWnBQZ2lrN0swSnI3N2VEUHlkbkRMYXU4UE4vZG9oUU9ucjNUV1NV?=
 =?utf-8?B?WnIvZUZWZlZGaXFicDhCZzNnekc2Z2dKVjk3bTA5cXlQTlFoTVFWV3QwUDZu?=
 =?utf-8?B?Y2RSd1ptNXdweUhJZHNlRGlsZHpQZmF5K1VMeEV0TVBRdkx2KzdWRmdUdlZN?=
 =?utf-8?B?TGVFdXMvQ1FSS2d0MldrZUJGZWRWbXlBd29QTmNoei9TdlRmc05zWm5iNGFy?=
 =?utf-8?B?VXl2WFJDNlhNeG9tR2pXbVJPZUF2WEtvVXFGZCs2ZDBpN29UbGZRRFJIcHBE?=
 =?utf-8?B?TkFHS201NWJrWXNUWFlIYUJ4c0Ivd2tLaGxEVVhUVFVsZUx5a3NZRUZGd2pD?=
 =?utf-8?B?eXd6WDNBYThtSHJYM1ZKQVppZGxiZnNpTHZQc1Fua2dvK1oyNVArOXB5anl1?=
 =?utf-8?B?Rjk5VWtsSlQyWWxuMFo1ODhwdGdaOFJVV1dHMWtrbnVsVzBNMmh4Y092L0U3?=
 =?utf-8?B?Q21Nb1FWY0tBSTJaN0xXV0VQdE00YUVSOW5vcmhycUROMm5iU1E2ZTV0amdV?=
 =?utf-8?B?WjBvMVVRMkUvTHJGOG5DNmF3YS90TEhIY2Q1eVZoUk0veHlJc0MvWlJLYmJy?=
 =?utf-8?B?OUx6K0VrakViKzBkRDg5WXJ1eHIrSnhJR3JEeTd0SGE1MWt3OWpQQXdvUnps?=
 =?utf-8?B?SVRUVXd5WFlNOEppVGg5YTNDYldaNVU1TEUybkEzY2tidDNHcXNWRmZWbDlL?=
 =?utf-8?B?U0RQZVk5eWlKRGhNVVhwMHJiRldwcThvM1NDdjRFNVIwcFhzWUt4bWR4cVhJ?=
 =?utf-8?B?VDlmWDAvL25zNE1xanZzV1lkVy9xRjFCOG94SFhhbjZHTDNCd2VqYTFRS2tX?=
 =?utf-8?B?VGN2L0J4dGlXVTFXZ1c3K1RkRzBRT0VOWnpmaEwwVkMwbGZqZGd6cnNvM1lE?=
 =?utf-8?B?SkV2K21yYmpGWkhzSG1IbTdma09Eajdaa2xGemxZTkJlUkR0RUdCaW11Qm1L?=
 =?utf-8?B?cHI2Y3JvbmxJd01HbzF1b0FLVksyUEJGK1ZlbTI2dmxQMVFwa3ZXM2RsWVpM?=
 =?utf-8?B?WkpidnVaTjJqakJHQ25uUDZ6aWRieHJkUDZXczk4eng5OGc3U2JvNzdrNzI4?=
 =?utf-8?B?RFAyeHZYME1tUzdXeG1RRTc2bTkrS3B1MFV3eWNiZVFqNUJEUW5FVXNwVG9r?=
 =?utf-8?B?VUNVY0xOZnEzR0QxNDJvS1RVQ0tWT01YM2p0YnhoUnlzV2R3TkZUU01rZXAz?=
 =?utf-8?B?ZFJBeHpnblBQQ3JXMEVWQk1PUm9ibDZiTC9DQ0kxV2Y0MEgwaTMwY1NjNzFq?=
 =?utf-8?Q?D8LCLfkatFCdTGtA=3D?=
X-Exchange-RoutingPolicyChecked:
	sqP7vgJpwfz+aisCzBjpXtLGkkc9JtQv2nlAGPdxt6eGaTWvc15oyJxALhBR2rU1UF/HmQQGdJ192uffzJ+Ao0ypvBMfGZ03DGU/7p950FT/X6iSeMlhaUEQ1P1CK+HDQOdCxqZtz7V5AradiZlmzK2ZCVAYtIkdbFa3rm2Vp1ypk3gKYkZa9mwyWQfYWZ2oYJn2LhKQpdTdyfN+XwuA5WvAiULiwqgMTPbALVdL86N6mVdC8aPE3M94f4BA6cUlnSuXT0OrRYwQqqQ4WBI+BV9zg/IX+VVlDaWCmKYxJ56NpIbutj2KeYIp39JFMKpYQLdgL6SmRQUH0TJeaYp3BA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3dCBEBczFi9Y851N5LkSm8gnBikPzHin4FA8p+fGYGujqXHaijAuUfzKvXpYtjg62E0hzGCKknkhERNhTZiNtPla1FjZ4X1+YnAr5JlS65U8vsBN5IA4rgNPItleriK4sGx42MHRRI/vc9689hcgxnRDpgJG0VnqX5i9SLppv858bl9TgV3cRU4iJo5n86/mxgmPgNaNX6ywQKF8AfkL0HpUQz1oI1H4WG/mlvhnb62DRjGDIj2XPzxhL8mj8En2+I12FO9eZgeNNMeSYvgys8TI9A9uhZ0mVpOQgVHEKrh5dzR6nm+cuK5TUjIJZaZ2+WTkMRAMeb+X38oSA+di9UJT7EzoSvZsSzXJMyXfcnHPxRL329FeXplhu5yQwkR3GdRRB0AjmsATTnVBZWevDKK9Lx8OJEfSvyO0sDtwQJQhzXuiLWCexC584w9sOXnycm/+gAnYptq7Hx/HP+noJ11P5LMrq1B3ZrdPKLHooKxsJN14knmoZMb09ToX4jaRcrCWObf/r6W36iYOw+yGBp3Espvz2RgVy6hFNVtfJ6zZ1ewz/yOdD/Sz3q8QcyKW0pxPt/dXb9CCt70mgAn8ptupA9ZENKlRcumG6RAxhIs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fbe37f-f6a2-4666-b49b-08deed65b3a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:36:59.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ym3Nle2jsXY6Sft0vu5uygcfnvfavjcKSYxagqQHB4A23gapNT6NjU5ZgTZMN0jr0ytZF29JM3Yr8M+a12exyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5926
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290096
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA5NSBTYWx0ZWRfX/R5q0GFeZs/i
 +KNNH4HPWPBmoM5jlJemvEeMLD/vPvF9cYsvyBYaXeNeR3/J7CSseDWt95RbEBf45sgR/QfrWPV
 azbKGQoXwYf/MPphcbVySg/j4o9c8oN4Eil8Gh3vfAcZFAffU1bY
X-Proofpoint-ORIG-GUID: 3VRhqx5O0-0S8MtS3GLfSakXPvToifty
X-Proofpoint-GUID: 3VRhqx5O0-0S8MtS3GLfSakXPvToifty
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69e5df b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=rUtx12hfPqk8FqyfC6sA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA5NSBTYWx0ZWRfX9cSEpfxs5xb7
 aObyi+4UfdToipZ26SzF/Mem2ISO6UQnmn+50WzXQ5Q4HceiEqCkAwlGML8IC2kosa5eSsl+ybJ
 JQAZ8bwvMfI2fuRGxf4m4wExVqGXPYy7KkK65+GFHW+BYjDjdjoCVzLWGlxxVSoKxB40bCrNvFe
 jcl8dGG+F1IBBYwC0uMQloWihcnxHeFlh7SdM/rvpumnircEScaUOgWkse9kO8eRMgfo5cEqaoZ
 ZauMWn3dCZs8MbFUTMC8SeEPkJvAxIczzHORcndtKfrwR0dibak+ieE17C0RoQoid1OcCwQXkvC
 kAlE5LCemH/w7OGV0bkHSdEtdRC2gApcA7ClRI6Aegj569bjVq17/f+91Pdse3qQdlZuaZWw8hq
 z6Aa8N+PUWSohs3kMGrfRpibBEkEZtWG/QG2HnHeMWI0om4ObCcvWvFrbOs+7uyxIipCGPh0EHY
 1SiKMR25uS7TfQfVEokqJBZf68g30eDF/oQoVyP8=

On 29/07/2026 12:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The block_device_operations struct `mpath_ops` lacks the mandatory `submit_bio` callback, causing `device_add_disk()` to unconditionally fail and preventing the multipath disk from functioning.
> - [High] Re-using `gendisk` after `device_add_disk()` failure violates the driver model and causes kobject corruption.
> - [High] `mpath_head_uninit()` synchronously blocks on open file descriptors, causing device removal to hang indefinitely if userspace holds the device open.
> --
> 
> --- Patch [2]: [PATCH v6 02/27] libmultipath: Add basic gendisk support ---
> commit 0995e161443bbd8d5024681ae6aeaebc37bafd47
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add basic gendisk support
> 
> This commit adds support to allocate and free a multipath gendisk.
> It introduces struct mpath_head_template as a method for drivers to
> provide custom multipath functionality.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> [ ... ]
>> @@ -36,6 +36,107 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
> [ ... ]
>> +const struct block_device_operations mpath_ops = {
>> +	.owner          = THIS_MODULE,
> 
> [Severity: High]
> Does setting the owner to THIS_MODULE (libmultipath) rather than the caller
> module (such as nvme_core) introduce a regression where the caller module can
> be unloaded while the disk is held open by userspace? If the caller's module
> exit calls mpath_head_uninit(), could it hang indefinitely in an
> uninterruptible wait on the refcount, permanently deadlocking module_mutex?

the caller module should call mpath_head_uninit(), which ensures all 
references are dropped

> 
>> +	.open		= mpath_bdev_open,
>> +	.release	= mpath_bdev_release,
>> +};
> 
> [Severity: High]
> Is this regression missing a submit_bio callback in mpath_ops? For bio-based
> queues, the block layer's __add_disk() mandates that disk->fops->submit_bio
> is present. If it is absent, device_add_disk() unconditionally aborts and
> returns -EINVAL, which prevents the multipath block device from registering.

it's added later

> 
> [ ... ]
>> +void mpath_device_set_live(struct mpath_device *mpath_device)
>> +{
> [ ... ]
>> +	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>> +		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
>> +		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
>> +				mpath_head->disk_groups);
>> +		if (ret) {
>> +			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
>> +			return;
>> +		}
> 
> [Severity: High]
> If device_add_disk() fails, clearing the live flag without freeing the
> disk leaves the object intact. When this function is called again for another
> path, won't it retry device_add_disk() on the exact same gendisk object?
> Because the driver model forbids calling device_add() more than once on the
> same device object and requires dropping the device upon failure, could this
> regression result in kobject BUGs or memory corruption?

This is same as NVMe, so I won't change it now

> 

