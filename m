Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC731716A;
	Tue, 16 Jun 2026 01:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781572139; cv=fail; b=bhDM6EWXWXwlXbnQzc7fAFvhbJC30ZnmtsSrK0Iqoqj7NQEbPV34qDUX2QLOK0ACKj1ur8ZjwTyF7AxVOABw8qsIrRR9rmBKGEPQQBIhid8teEwAbcgoqVz3Bx8uA/kq81cGm2DViMdvrq89yyzIujgUUfjHYvAvbpGXg5ckVBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781572139; c=relaxed/simple;
	bh=Vb830793yHDSQZdeFwMxU8nMspvwvflFOK13s9lKF1Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=b+sAagZzChSHGU9OxpyFB2zj4DBBEiZxhpHNjc1HFmHO0Zkyz7IKOlAYCnnwI8JUpwE4IvA2UmrdHyK1x4cq9zL/Syb7rjwFycqVePkvhR/9AP6avPqTbBShtYnkKyiirp8JriXLEq3hrLnOO34lB2a/rBaIP6QcjbW95E8S2Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oKE4d9OD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tgHfhd3X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oKE4d9OD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tgHfhd3X"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FKrtxd1304550;
	Tue, 16 Jun 2026 01:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=71QRkjLmme73CtY5CD
	DIrBAu4mFzTlu1dqKLN2qYNUQ=; b=oKE4d9ODDq+FowczlGVSIRqsbl/zabHQq+
	7ZvO8ydiBx6xBSw0+4Se1qnJJGw/WdF8GcbHqrtHTx77VGNloEeR3VBWohIP6w+6
	kGOT8+A6b7nO6pA90hwZOhe23anfYRwzN/K9ZJpW7PuW8T4t9iUrAmGB2DzT/DvZ
	CeGQ8GpuSCsPbOTxUUv/CJXcrVyWlGBWkA3uiWhS+U5WERv2hU2ssQo495oK28WK
	95hAwbbYxjAAl31QNpg92fMHST87PlEeO3jVbCFgk+L+IzESUuUxgvZjM35gCWGt
	0tPXic0XGJ8MbSALTetQd5t+3ft++OdefbXWh+GRg4GqHYgYkG9w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1hxkgkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 01:08:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G13f2a033665;
	Tue, 16 Jun 2026 01:08:49 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpmaw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 01:08:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3hG4UjMxuo3v/NEoLZlMOEFiTCWKSQxbct9o55eJIYy3QyuXIX7xjwUkZedrSXICyu/z6doKbYMLH0HZEO5MBsO0FZyLnAu76QKCBqduGP3NX11F4pjFBVnuFIx00frygwpKFJk//+wPTR2vWuZpps8baZdQC7GbiOAjcQ2NYAB4aO9Vkqy0S9XrdcZjajiUE5wL6iFvPrijRLM+PudqMF2zuDB9ZXuAk8tZgoRCVkIki/0GZO7/5NZHxg/diT/PYWA9iGji00B3ABZ+DXh4MXyKdSnoDPoPEG1znxXpcrwRsvaDzQNaZi8UvGbvEc956eNx0lqkAM+B4uvwXdQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71QRkjLmme73CtY5CDDIrBAu4mFzTlu1dqKLN2qYNUQ=;
 b=iXAhpKgLhREKfYRUeacxkQJl3hvRrOJuTlw0F+nB+Kbibkryenz1wqT3IX6wQG6T3IO52NhizJaKiZnjttkn8W6AEi592HWNkt6RSBCgBoMU8i404/O8/X2MzUU4KNgumvWqvKQj32r26cJWlJLFuhF+frRVN3Zye83INzt6ZqN2YrTvxe4zlidSRgPybS7moasMKAh+2tjJZ7t3so87JOW7IoG3iBZDtDOgcJUHprdrHMDxOwGZuRhsKTOJwLB8cGCwAL6sP9OsR9bF9Trms1VwcPFEua2PhwMda1lQO4AXmhzQdawr/V6jbgFBvyNdkm063I48HsqOmgbX5yqvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71QRkjLmme73CtY5CDDIrBAu4mFzTlu1dqKLN2qYNUQ=;
 b=tgHfhd3X4B/Ftz9hUK8IvODwUF6zTXL7aq6vdc1fpolImgTJ2G3Ilrb/Bze4SFk4nxgVGdtqi6Xl5NebEnBuO3WCGEwSTM5SaCODZXtnYgExzXxIUET2JZLIMKDmwyIK49rr1uBmHZpDgwlUBwzg9ZsrxxMD5LIFg9OeExOIszU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7497.namprd10.prod.outlook.com (2603:10b6:610:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 01:08:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 01:08:45 +0000
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <cassel@kernel.org>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 6/6] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN
 ATAPI device quirk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260608213443.2296614-7-philpem@philpem.me.uk> (Phil
	Pemberton's message of "Mon, 8 Jun 2026 22:34:43 +0100")
Organization: Oracle
Message-ID: <yq1jyrzwav0.fsf@ca-mkp.ca.oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
	<20260608213443.2296614-7-philpem@philpem.me.uk>
Date: Mon, 15 Jun 2026 21:08:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af0e2ff-5de4-4c8c-05b1-08decb43d04e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|4143699003|3023799007|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5cOJA2d7yv/8ZnHgOQ9ymr6tcHTEKG2cqxPe+xq0d2ql0oSP+wfHPvEJoBHH4rR0O3hpkHqyj02Ly/TBteQUotwZyYwshvS4nV0A53q+p5BHrGXES2thnql4qk5yvuaIdB1IyGOcUMcJ7R3QgAVo+aMcLHVGfuWty6ROQDcEGdSM8W1M5oNAlpdM5inLwyeuqccTecquwj3DG1kJ5cbE/wiQup7Tw11KzrPIYDGY5rMKGOL0BJOyW+43LG6hUl435MqUMaF4jj78pPAsvtYqI4xb2p8F8pPhRDYU/uWEuwtgjEo0OjRDOxncJhkzFCGioPPX11Ez6MRBpl1GaJj6gcC3l+UJ2sxGZrD6Qc8NTIONLeHk4bDnA1d7bfz6RrNmifAAXhWqIOIffir7xMRi9aUBK4mrYS99cEPl7kanJMuy2qsMxrc3hfNspjpCSqBvNKFscI2JAQXGnk8457nzWNW9cxGVdwdb5TuNE0MUXRt3xYMMtjZT6aqB6s2WL9ryOauLy3t1SAme/65MlJcI4TLNUBrvtOvcwN65VknfqdWKN7iv50MAgZhazDkvFdsTHa96t+jmKSsOg8pv8fbpfsWYM5eSOR3od3i26jt5EoAnl7KHZYIUEDn4zZgKn1atfQLkdhXAexmHc43sGG0TYFmZoak37RG/jhW/ChlDKDtjEFLqjbKr3Qg/qB/oCnV1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(4143699003)(3023799007)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AwiBdzls3BzbqmsF11XDR9vxPD+3r9tHmCrsZOGbU4mPE0VholJYJMVbCRtK?=
 =?us-ascii?Q?EGgxj/Nj87/7CSLi5lb3Y8o7CtmV6DbsPztPjxC0TXFOf1fH5mqixm8D4mzC?=
 =?us-ascii?Q?kOYB3BRy/7H0JhJ1ZXGWqUxhqkIopNDPoGVxV+aCkV3rKTQPZ7Oo7bNa4Dwo?=
 =?us-ascii?Q?MXtjwuX6UpIWwHNzfl+bCm6Nl1Z8T4XBc5Jq1hrpcl2qiSUGmQVIjpQ/z5cL?=
 =?us-ascii?Q?4ncTenZAODIWbQ/4FVRZFbBp6+48AbqF1s3UyhiNLr5ihzwmaJisQTpmtWYp?=
 =?us-ascii?Q?N3yoGv3Syuox71m/eF6qTdTl3i2oHKsQYCEUBShv21+rmhioI+9yhEMJn4cV?=
 =?us-ascii?Q?zu6Rym2cc9jIGJc4R+iZxC+b637cfThZH6c76R8AaypAaa77ee34nKPdi2dX?=
 =?us-ascii?Q?n0C/DE0IUKbmT6yJx0L0gJVj7xGfiUNRFdB4+OsRF93rfbvzIxb/uiB+FmqC?=
 =?us-ascii?Q?aq29NvyWiewn68nD2AwGkSd8POIZdOMbDcreQpRsHNTuuTMXROBKkVPwrgvk?=
 =?us-ascii?Q?jTfnq7CprInbdHLPc06bTPP3LZF1G6GkjgSphbDdx+y6Uwg55yWbMUjlKi3R?=
 =?us-ascii?Q?HCjPYfTveT5HJoI1D4vvWr+5fe1ogvQ0xqfkDsLg9JGVW+X/V6/shtTn06RQ?=
 =?us-ascii?Q?wtu2kmIH/GFaoA69HENMGUUJA9vHXCF2RgZkGIaGqy1aCWiCXWHxIdsuRapI?=
 =?us-ascii?Q?q21BGNGXZXrZLXhhntmVlg9939Nnrk5Y8TIz4SWCgMtZHjdlMsqQsTqBrIMd?=
 =?us-ascii?Q?fcacSmeTFoC1b7EnbwyW+C6hq6zK+GToOjp9kepIgM6o9kBmliFpRJsJ0PMs?=
 =?us-ascii?Q?IrfYP7qCCx9H5b9s0jloCSc5LFEv89fOP50qSoKo0P7bs0LRtl5aLumtIzM5?=
 =?us-ascii?Q?9a3XCrNMRSbGFjBDRm1mhZo/B4bUsms7qFQWyZ4if8P8xKztRdoENB8VKZbN?=
 =?us-ascii?Q?RCLFfg/Vtv9FK17LZO07db6NxCp7AeYstun++Rd7yAEamI3lhjoV2wS+r94n?=
 =?us-ascii?Q?pFHyw/Ja7XiWtcPiiP+4j353EIp6Ht+IgS6x2qVNzQ490OkacK+Ye3HY8CPj?=
 =?us-ascii?Q?oIHk88ZHS7LaKg8DJLXm+JjtbNJDlldMDWaYWp690rkka+Mbmw3w3KdX4fG4?=
 =?us-ascii?Q?fDv5ipH09rWxUvwSKa7i1cZ3Tjra/z9NVpUvIHoiB77ICAXktLp9jlXpYpbD?=
 =?us-ascii?Q?sZCDZdgHkCtjdvTKkdLVcnEquuR5RtQ8G+uwdjRykLv9fWo3kZbRaBeKQccZ?=
 =?us-ascii?Q?jF5NLyYQDe7mwS8QGzmbTz/8M5ocOWj5sfgJ+sF7sFq0gLDmutQbGZ+pw53z?=
 =?us-ascii?Q?DVGjs0ai7ybYk0bvMSEH67cd6ykLv/YvKjXibpZoXd8DKyuEC/DdRhNr5cY5?=
 =?us-ascii?Q?cjIks5nGPQ9seBZl/30Wv7yb5Qpt8QNp4QmCtcq+DDU4LEZrGG25sp8MRP8O?=
 =?us-ascii?Q?GbPPRMLHCeqfp0sPyIQlwjJCwv74iuHCG6oxq5dqwSUw4pT+blK9PfO8Um7b?=
 =?us-ascii?Q?CZdfxWPoW4lA48C6XS/ZuqiEjgs3Psw1q6g65+rTZoIMi+EgECH4PoOJPEPo?=
 =?us-ascii?Q?qhflQ3MMc6MvR5h+9Zc8hVZDCIoVpo6WrjS0/lzdYfBiQoIFDVgnPeOCr8av?=
 =?us-ascii?Q?N3X+yxF3yThYe/dKzewxwltvB5YpXxx2bGWamEb5ux9Y6DKUGf57DL3E03yv?=
 =?us-ascii?Q?APzZD2Ln+bm4odMPA3LKGZAGzmq2+ZghFBaJXYAzrqOtKnE+jFlVYkOmD+Kn?=
 =?us-ascii?Q?e7Un5RtXd0PzyoFEdwOnriKrTpZRmWg=3D?=
X-Exchange-RoutingPolicyChecked:
	ioLs2BaiKw4oV2S4/ZI8+QRPr24fIu57YRwzmH38DfWgRQJukj0BjiARFHXoIKF0TWJfBYYPi53z/sh8VKTfEBbS5+CWVTjmDp7CJGI9oEmyrn2nOzDfcyFX5N5IsRSCXkDsyEWSVwfUoZL5xljE15GG/Mxt6KQTMUQe0ARQM90cVT92NbGc225RqzEezDqUcGguFxCNfw8nZp99fKbtyVmigrpimKtvvXJpX5brPh+iy19dNxwrV4NdNRzcHM616+IYewL6Od2lSpGIjHKaEfUzpDFOlPIaupQZ1PfxY8mpNbvHEv559u/7fogVV5ndPDftKGFIR4RCIB02Q0xB6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gjGjAT089VJz3BX+EHWAyhiu0RNrSaSpE2a/h+w7OEa5EEGf4L/qbnWh+KIV//4iCwspUfQ5X2cQzI9cVF/XFrlgUgXcA8VvFuyoeTw6+IYLes38NWDcovZgJjccSOQK2wIEsREYbFBtsxf4fyAfkQ0L8ZiKnJLzXMvLzEf2VP8S95BTc/5k8C2lsXXvwPt7TDTvWj57C1VZIbv78V/iGfg4ezdrRpfYE24FrG0ViF7PjVue5SoyZeCAjIAmsSo32s94/q7hNfuDfak6D430cqQlLcu0CHVQ6yGwCOGh038YRgftRJRhg7cNfrT883lxxzX4UDuybLqRQAdBMUaPToVB5xwvJ0Qg3Ax04NnrxFqWnPAfMAfxhZQUtAqx4xzLVHpmHkPb5c6w5g/EoX1WfmmkP5yLKHpGf07fRvtJRibD0X1so9rOQ1pTSGsUvAIWaKzyizM5jVL/dRJ85LlltaQquoEEEb19wlV/uZwj2Fu79rgzBNfzy6VStA4sHrBnhWUT7hDG3alkO3JMjbHlzypNeU18y2j5J3UxcWqPc2x7u3LWlJxbE3S3GI+UiHX3CUalpNybC3oYf+CxuLpnnurTu7ShrBaQzELRsJfdXUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af0e2ff-5de4-4c8c-05b1-08decb43d04e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 01:08:45.2831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8AuxoMdNPNnnCoKbPJJu29f7jmXQW8u3qpOzJupu5iNfQfmt+5SmnqagJ2w1lvu046XpYd9wZnGdhKtGkRthSjzyas7joqjX1LbsqDtEVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=861 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160007
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAwOCBTYWx0ZWRfX8Ykpuec9xO/C
 xjn6znNsZPSa8/Kdv6PtRqt9qbIPAK4iYABh6Wq3Om+gUZm4AdyGkkybr+si+BnFJ6+VdlRM1gi
 PDUr/2fjLGBzs1h44v5JmYBwiiyqIhFcu729zE/fI+3Zfqf7P2qu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAwOCBTYWx0ZWRfX1HOtEkF+XJgf
 kK9C3MI2dUe8P5cdZU3Pu1uWZHs51a3LIsqCe9bM3/pwTYtvWsVm4WVI0wNE2LyRWvp1qpd9Vyw
 LtmNvmOfpOb7mzsHhsLULqoXoICInPX4tCwFF6TC5DdXnHPq9g0Jwl7cM3xTBOJgcwu34EFkz+x
 idPSDw63XTNf9ficSErpODHjDgV3i9LGDBULaPWkLHtVfrmaNJHv2LG3ueMJ774MwnTC4GWG12e
 sdmI07h/KspmAOdGfDuruu+zWikX9tfNCd9FuGrRLBtqy88SGq0CL9g5OIdoKFxk/WEROZb8Y0j
 3H2+Ub/5eSl0c9XKtbTho0wELCSvwj80heCQPyudJohCIV2A1tEIKEZxjX+x3Zm9Npf3OkJ1TPm
 tlDdqsKbHVBUbmIWqIGzkO2Yn6l7tU+EZlqr/7CMpfzc55JeJ/9dpjqUmxKVUsagSamL/qcFbvp
 deLHoay39+pdBFtjNC8XI0njzgSR7VNe6nzzbYSQ=
X-Authority-Analysis: v=2.4 cv=I6pVgtgg c=1 sm=1 tr=0 ts=6a30a222 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=i6ijFvhpLoClao7pM9UA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: s_JtM7VTXQOjFOm9Lz7fFUmSgeZYTk2K
X-Proofpoint-ORIG-GUID: s_JtM7VTXQOjFOm9Lz7fFUmSgeZYTk2K


Phil,

> The COMPAQ PD-1 (OEM Panasonic/Matsushita LF-1195C) is a PD/CD combo
> drive that exposes two ATAPI LUNs: LUN 0 is a CD-ROM (TYPE_ROM),
> LUN 1 is a 650 MB PD (TYPE_DISK).
>
> Add it to the SCSI device list with:
>   - BLIST_FORCELUN: tells the SCSI layer to scan past LUN 0
>   - BLIST_SINGLELUN: serialises commands across the two LUNs, since
>     the drive has a single transport and cannot handle concurrent
>     operations on both
>   - BLIST_NO_LUN_1F: the drive returns PQ=0/PDT=0x1f for unpopulated
>     LUNs instead of PQ=3; this flag tells scsi_probe_and_add_lun()
>     to silently skip them
>
> The INQUIRY strings as reported by the device are:
>   Vendor:  "COMPAQ  " (T10 format, space-padded)
>   Product: "PD-1"

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
