Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ACB2F3B;
	Sun,  3 Nov 2024 01:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730597777; cv=fail; b=ds1q4uXmWVHxVDYYlSEzRS/ArUywBPdRZQsKewAKvaBQH8uVGasJhuIdDjldjQIEsUBdnmYVELY8t3iNQif7guswKpGolIdY2yogtyv6QO2Sf+CUUWrORjNnTicBqDj1lsoiPgvsGxgCeYdBir2HDUSNVWG/w2k01+mdy8SmY5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730597777; c=relaxed/simple;
	bh=M28HpiJ1J7eDG0BODX5LXkA8p4j6LFEVrdSfygCrBRw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RecJxf+sXwmHpk9vNr90xTq/YaD/ieL43+MKvjIlve54SqGjjkDQJ9jWcZIgormNQpvcOzamq1Dgakf8wHctQ3+ls+Pg8KsvL467nZ2stq8cr6EY8p/6k/w+3QRvMIQVDV3ftrz0QJD2bsZbByo5hiCHaBdxzGrqixL7hQjRUeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kgwSof6V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OHcofF/L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kgwSof6V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OHcofF/L"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A30q12J013166;
	Sun, 3 Nov 2024 01:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=WKIh0P7Wk4GzYpq66s
	e517Vwe8PTdU1rYR5bY9m4DDM=; b=kgwSof6V+y1v2xKwSzY+WRKeysusM2iJiS
	OAEAUov6keJBKTQCARSx8j+5pPY2PfqSotPrWQ8AsqbM2Oi24cn84haE6B/Izhak
	gSkJYrEAmlqkN/UNjXIie/SUUMpUEQb+yVfpC+AatpahFCQ3Kna6szFOZ7mYKds1
	8jpAk3YkImXnyg+CnbcYf4XgejffPd16O5uuBbRanQqmkDwd4JKUCgvixZ/A+szi
	pqzSIrhF2mwGuJ+I0M0Vp8XiOJvvf7ZifAO9eGV0pYQQM4hAYHOhg/kbo/tAnAj5
	femHxCS2V8Xd6Iqcq1U0CufZC36PoUBakU+VL2gfFsLO2pU9tQrg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4brpsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 01:35:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A31UJQE008427;
	Sun, 3 Nov 2024 01:35:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah4jc6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 01:35:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tqPsD3kVkzSQr0Vghi6OYXHTgrdGpZ4w8BjexW853wf8z8T+q5p984aM63PlGBc8gCaQYd1dAIqJkSF95CMBrJrl/02HwsyqRZ3NadEgyA7hCX27d8jotge89/cVb5maFhB8jpE+4h7tAAvBidc6MXKThpTydlRD88+EWbee7TIE7aqRmSd4mwY5n9GlBmvBYtPXRwAOUy1UpWxfODkgXNrph9sdVYAZ/WRP8YyolPljXIDu1nXBZKy9GvLp1TchMfmebePi6jIC7nJlndtlBQ/r6KpaMEewxm/hZxXk83cMNuwEuVwy68Ik3YM49I6hyPevHSgjKurRz9XArZ3Jpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKIh0P7Wk4GzYpq66se517Vwe8PTdU1rYR5bY9m4DDM=;
 b=CbmbOCfh2LReYuuZk6M/MySKhsg8PEU8kXvWvkx8ysrkhtrNt2oPC0WV0J7a4lxitiU/+5wuUzU2XPzmr/kLNok0tbvTCucQDbjiHAKKbdyOt2915AxOEtcyaFB3JfLXBi06qMVWZNFHX6swUFLCuHkCBlBaHDxPrwASWZ91aC2YqeZ6VUXB44vPCkopKK5Xy3K7O48PxQvocnFVONkMU7Y4V4FG97p4WHoR+6Qs2Lc1IIhAHuHl5fQ1hdxrW17jaD9Jxm+0hHuTgQBxG5N5iMIEa6BZsiS5zdgQJWb0jXOtkjrteG39kIMRM0kTegElDYFVexSI2FauSo1f6WNzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKIh0P7Wk4GzYpq66se517Vwe8PTdU1rYR5bY9m4DDM=;
 b=OHcofF/LnkLaD2XgKSykPwbNb6VK/0em7bJx8QWzngEPIgSMSQ3RWOQIUNcLi9s5qFNB7swFzW0wBCO4PfK5mYtdldu5cRUraRXT+0oMaN3RugdIMR+0rhDJlmllcRi3JnCPrTuIxJA7vr+2nqq7yDettb2qWcvESmE7wv4/ig4=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by MN2PR10MB4288.namprd10.prod.outlook.com (2603:10b6:208:1dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 01:35:32 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 01:35:32 +0000
To: Peter Griffin <peter.griffin@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, avri.altman@wdc.com, bvanassche@acm.org,
        krzk@kernel.org, tudor.ambarus@linaro.org, ebiggers@kernel.org,
        andre.draszik@linaro.org, kernel-team@android.com,
        willmcvicker@google.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/14] UFS cleanups and enhancements to ufs-exynos
 for gs101
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241031150033.3440894-1-peter.griffin@linaro.org> (Peter
	Griffin's message of "Thu, 31 Oct 2024 15:00:19 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wmhl6rp8.fsf@ca-mkp.ca.oracle.com>
References: <20241031150033.3440894-1-peter.griffin@linaro.org>
Date: Sat, 02 Nov 2024 21:35:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|MN2PR10MB4288:EE_
X-MS-Office365-Filtering-Correlation-Id: 402ca391-e5f5-40ae-a16a-08dcfba7ceb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5SeNDM4/p3/bPjxfVtZhENzPOvF3AG7QxNjzcGpjx91wnlUDgapVarJtqrpt?=
 =?us-ascii?Q?zihRa3dxg7Dti2pu/uvSABK+dBT+zZ+rvv9d6TqyOt4QuUYbQbXzWLOrLqtp?=
 =?us-ascii?Q?IVyoBLgCHgJT6lzt4TsNfFp9UaicU5z/D6j6k2xE+q69pFREVdokVqxkFjVG?=
 =?us-ascii?Q?FcvlgozHIlDP3nBgmJNpSmLET7Tv94GJPlhI09Zk+cKUH2xwDPCbJUkbAlSK?=
 =?us-ascii?Q?Y7i1ARTkBviIAoFmzRCryiCmGahx5lqMOOby9rJXqZzFu3K5imgMx+Ex//wy?=
 =?us-ascii?Q?rsFD8vH2Tet3cxeF/2iyD2vvE67visEBi20vhNsmS0MGNhZ6sDybl7w0rH5v?=
 =?us-ascii?Q?7EwExpnXV2RHvnD892sBPpoQ4xDgitDHF1kHmugwWCmaQHuAIpdHcI8IoDUX?=
 =?us-ascii?Q?yhpD3ypcvmQwOXLDUUpt1ZwDeijFqvzflr1iTCs656y3CdckwelOUosHLp5j?=
 =?us-ascii?Q?+ecKTAuvI2t3zJaf3QFs8QJ36Yz5BM28/skiK2X49OHouaAUUenAvVIvZpqV?=
 =?us-ascii?Q?FBp6Z3rsU6QcLf0cXMicSODff0D5dIhFQ+j59kOpGVpkZfYZg4XZTVWiXkBb?=
 =?us-ascii?Q?E3S76wcdhmh++NuJZ3aKSsMykNKVoEd4ejUgb3TUj0p9TgwdKUWxRua+4OAY?=
 =?us-ascii?Q?kLU0l1f92KPVYw4e81+NNsLdz9p+XqO7kSpwk665pdgAqgMtHQ3N/NO4Ji/Y?=
 =?us-ascii?Q?mVcdxhnEDnVwJrrfTOwm6XDBYvmx5/yg5TQ+t7Wc0+lvWoMBphcYDA1w1axn?=
 =?us-ascii?Q?w3YVxVwFAinWQdURfVI7pa+sOY7OMpFV+uJ6IrZiW9Ebd8rvVvS8w4bvkvJs?=
 =?us-ascii?Q?w5xIFIMqkv+SLqdWXVXp3I+adZTo+6eN1m4C8fjNKjL2QculeYdFO7WzhhB2?=
 =?us-ascii?Q?WR4QbtVY+9TCuf/NKH7+scvfifHexk5JomcA8NnQqM09Ne7GEY6m+NX7/dA2?=
 =?us-ascii?Q?DlbkSFE9s26DHfOe2Ah5ZGJeF2G2XKI4el3M9e6VeA7FkJMP+LEdnvZ7Binj?=
 =?us-ascii?Q?2l9oPMDrqLZAmHSCMewlIgY/waVsN8GVPlR+0r5QkjvScA386cdN8dB6m7Vn?=
 =?us-ascii?Q?IlbhVlHvum0mdWtK0ladeBRhBBKq4BFKY6FjaFPRIIIrR2vznai/QZ0B6Ac2?=
 =?us-ascii?Q?/KuQgK2a3gfEifJWAau6yhvp8AzD4x3FYOG1AwxfsU4y55EzzoKh2qY90hlt?=
 =?us-ascii?Q?5fLUUq6Wtnc5OT9e9e+5IQ4wKE/Fru8BwMkLfHHGMof1xo/ePbciSjG8z+0I?=
 =?us-ascii?Q?OrA8cnmi73gDHYHezTpHlMGXKHoIMKR3X8drFVaZyCfuKRWVgvw+nNw0nUSh?=
 =?us-ascii?Q?/jnpVWmC0xY48BjDop/rvR5j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O9bfavUb48xLVaO9VInjhBmN0Kq2tONxQv+/AKMz+RTvnHShFLyV0dZXR5Ky?=
 =?us-ascii?Q?/S3Q3CVoOV2rykn0BLrv9FZEwCbsSMaajaDoU9Bl5jHv81bitE/8B50dMZ3T?=
 =?us-ascii?Q?WyVZsh1awRAyuXTnLYGlpEaGMFCjeR8Fq5ToWiorGu1B7mi/iog/3pewbtnO?=
 =?us-ascii?Q?lbsPKHrnLAFOoEmqfSIWH9MW0HCpnrGHvB9fTO0mvnMRsROX+IqZwzqPOgaj?=
 =?us-ascii?Q?fZPe4PaQsOYEHOzlSGwZpd/DIn5MZcFhgFcGwF7q9VKH0Sv2ySQi54FThV18?=
 =?us-ascii?Q?7/KJlI78icoGZwX7GDMVvRdV5/1PgOucIAki3Rj7vLOgajnbborFaOgiT9my?=
 =?us-ascii?Q?GLvf5K8GkQTrCIhAn1zhaWk4LGuHQQobUb6ByhJqCBmjTkN/RoKBBNlDSIM+?=
 =?us-ascii?Q?+JpY7dsZBgjQDm8mXNwz+DD/R8nCeOk6lVtZR/M22/1dBfzeGRtRMkEKX6jb?=
 =?us-ascii?Q?wM5kXG1xiiB2ZNPGd3rb4QhILHMlgy/vtI2SrrCgw0orNYx9Tjg98AgVxv2P?=
 =?us-ascii?Q?+fSFCt59FsNbc3ZFcyAevQw59iNJz+yslisVIQ/div38CZRYVdBU0hwN26ig?=
 =?us-ascii?Q?1kKUA4q0XB7YpC8+NMXUDDUu8GCpc/N8OLshKjD0AvzWZ8hU5ejvYOJ3Yfj0?=
 =?us-ascii?Q?vOsFxpos3shNpta5omLBio+zJLG27Zgk9AKZ7968eDa/iYVEYVxlbKlUXsHp?=
 =?us-ascii?Q?lUujqbU0KnYmI0R4BHtgZjGhFDhnaBv1DxjJGde+pkpZK5EiDfrvT5LAJvU9?=
 =?us-ascii?Q?W1lKAkhcoCQ/xaRNgprx5sSWOy9uZyZ7KyqUL28dY4N4DwzcQU3xrqnjJfgq?=
 =?us-ascii?Q?Wf+PE9DZ8ZcVysEvicjy1c7+OKZe2UqHvPbfxc2ys2lJ9lBQ40o3Pmux0/79?=
 =?us-ascii?Q?NaWTMUXN3haVvMV7/EDDgBr4VRZI+WfOTKY/T52d7Lin4KdFNRwCT3bN3V6y?=
 =?us-ascii?Q?pU3GDozNAwaXhjCpr+aPHOA2tddAG8iz+Zlgu+4ucnWHHnVAh3gppx+zDiE0?=
 =?us-ascii?Q?xnvyVLxMlx25AQFxDjsmEYJ/wM1Wnwd10Ed50WEEACF/t+2fDUAVFLpKF7D8?=
 =?us-ascii?Q?M8rs0/3l+QsB5Lkanp4Jz1ybGuJMZqI4l3EWKYQLjNLc1Y39OHA8Y8KNCFKa?=
 =?us-ascii?Q?G/LaoQzh4Dt+b1PXcQa26b2Y/v9oNaOxsU2RwCeUmzJyuVFXYGKYwRrdVFwV?=
 =?us-ascii?Q?ekEeTPDszD/oFBgldhqyWtPL/NguwIUHORz/Tr58ICa4iXmBmW2NFrZg6KFs?=
 =?us-ascii?Q?6SpsQT3A/u01PGT8hBVEWl9uM7CNiR+3+eZa9T27ms/krK5gSdxW+vS6hWqZ?=
 =?us-ascii?Q?8R5W2gGvjnVW9QG1kN7OTclUMxozhQKpp85+C2QlWZ+Ou2CwoV9mJvV8TTYO?=
 =?us-ascii?Q?y1DffQknrhJnB4++rXKaj2NqxUtkhIIOFlL2QIyjZLvev9chUQKBW/GvdlhZ?=
 =?us-ascii?Q?6QHA9MOk1e0bkYSzgqS/MGMzcW1F8hSQXA3X6Sd0rrVyoXJUjtPKCdsRF8Kl?=
 =?us-ascii?Q?ls5ykIKW/u9xH9ZGvLF82L1rXSKZT9L+/gLdNq3Z/FrEJ8eMvqCZ2XAAz0Yh?=
 =?us-ascii?Q?0kTryMcFuIYMYUw9XAkFuF2oqlnI997K/70WHZvUWvH1ZOUDNzibwg/uwtIS?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8jvsJwEQH1zNWiE8yP+6YIBfasKkNWYpIagVk3Lsu+KLzcbknpJIgumoHauFjsJ4sZ+lK8ctdWtjVwDQR3fN6FsNKjECvXqjei5YWYZuF1ui4gjBjQK3XuxrqNFgr4XuxyKT75wM5SfKj4zDEc8f5Fzap+huKGMdj7wPEsrsxUAldWSKpNjqBpjrDrBmLajTUemXK1B5Lx14xDSrXjZ/S4EoCwzKyBo04apyLE59BB9hcwXJ2VD0kYaybQkKy54J+bcFLMe3HDxO7osXZL9Dd2h0okZ8lOvjP9l9Y17rH5fesyvBxasHmnUkUw0Hi+ztBQ0FwCYkcxpwpP3T5K4LikhSjdsqa9HRBdyUuGB/dGGl2VNbIdQEugDq0D/9TCu2woE21t7sA+1DNSTXSl6F67fqZUF4hJdC2RlrPzAljiDrV1sj0tAWsOB2wuZEYMPu/+2PdpPFF9OvnT6EaLNViAejfuCcR855+q/EO+Y/5mDyJVJJlBSPoHeo598J/ixQ/DH0qfu6tVU3UvN6VMERlBSxRBOPm9lV5HzDSJte3lkUlEDIJ3D5UfC7/+0S5nSMsixH0/GXCTJfZqKBpjktstSNLtH080IeLYjkejt9oI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402ca391-e5f5-40ae-a16a-08dcfba7ceb3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 01:35:32.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJ5XrLhiJCmXsfi/a1fahlhbebBU4R12sOj+Gw1tuVFI/d1z5FXOilGWvo/e7/MyNLQ4qp+4/QwQ9N/1k3BcBYcY4hqquRaUtJu6caCdJiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_24,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=705 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411030012
X-Proofpoint-ORIG-GUID: cQV9Quqh63-U4luDuaaXln6Okgi5viCD
X-Proofpoint-GUID: cQV9Quqh63-U4luDuaaXln6Okgi5viCD


Peter,

> This series provides a few cleanups, bug fixes and feature
> enhancements for the ufs-exynos driver, particularly for gs101 SoC.

Patches 1 and 2 were missing your SoB tags. I took the liberty of adding
these instead of having you resubmit. Please acknowledge that these two
patches should have your SoB.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
