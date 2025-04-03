Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3854424CEF4;
	Thu,  3 Apr 2025 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743692256; cv=fail; b=mbyTGcfilxGxJg1sbbmf/VHbwm2eBA1sbXSjTFoesqiN5ioCVJDN+JoBF/VuQ/mNvWvlVg1BSaOGT0r1Q8GGI/K/4aIMHnQynPCV+hhh7D3pSibJgtlChLvfg0WVyMMgp1dc05w8i3LNB0iKHQp9rBn3EdDBUT+ORLRGIf3jQ5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743692256; c=relaxed/simple;
	bh=qQJvT5U/lOcdIHZt7eBMd7UQJzQgCF6VlHbkdNaAqSc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XQYykT0UfC7gU9xOKwS+HpmRU4ab/a1Rfbx9q5cWXPBCFGOJU7d21iD436+s0ZBnZNeDV8c+SLZoDacvWiDqMvFM8hFAUvN4yjTt1JWoVvgPG4oAUBAwwVjkzhcQF83QyGzOdROAzB9NH0PYzwALibq+/nN7WrCV9cBOqpp9+/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=er142KOv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sM6NZ1CZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="er142KOv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sM6NZ1CZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHeIq032053;
	Thu, 3 Apr 2025 14:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=sgwkrHbyHodj6iHYR8
	WSUeLD7D9iHiAFbkA8XXr2m68=; b=er142KOvzSC5vx2h2yS8sdOgus34TigyzY
	GDhrXAqgPx1Oyncv5SmOdtVLfP+kazt4xYuH8Q4At23uSrw1f1EWqYyvpJVZ+2NU
	qpbAV84RFzamhB+GNBlYVHpV3JQXoYa5ngNnKt2HMuFOrfOEloEAkcKjeLSgvL2m
	PLkepI+z5GgUuuQaWiEYV9Ikfka4N1DXRu/gZ1GIRxSAaYH5VJbwrLKVkdo1TKwY
	vj2nZePhuWpNzJAUTZdMxSezwo00+seVcS9pSDUg43QaaQiW7nx5CIGDN4Tub32R
	A5m3emdiseD5Nx9Ex/SrriMMVb63oyKc/tC3kbyqCsseu6FVAhnw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0mwu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533DUl6M010718;
	Thu, 3 Apr 2025 14:55:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ajge0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KcQvc7M70U7Sap1Vv+OUvzAd9snuvIp5oeK6oq4yikzkEpf9eqb0ZSbGpWHdNAzjSEfGBCV6NlYMcE/sU8wU0aNGzpc4LcSOjhqg3+7Ft5tvHVI47jpWRDrnosRJDnLVyfm600VTeEFYzgIhfy+5Kywr8mQ0aRu4HMBwQNFELzEOd6idPy4tHx5cr3dF2HlZkaeQ5lenXpw9nPUBk+eb6AYy8aPRcGNChZQbC5OF+CUJdA++Jo9SJ8eFoeNXFK+bt3eP0V6LsXqPMGLvZe2IGb4+9oc56QKo9Y6LHrhZ7/khd+c5tW6NIn4QVI0BtCNoRAGF1mcls8zcumMWa9MVSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgwkrHbyHodj6iHYR8WSUeLD7D9iHiAFbkA8XXr2m68=;
 b=JHq5YTevPfuOde4iZXBPuSyoIjlJsEiUcQCsYah6AdreV3puxkkDJFkYyFv4gbHQNXHIQI+Scuh1OhkZbaxQ3y8OxiWVvVEqUDzlj2Ef4bSD8z+qaFRJ8sRPmpYdNKvbue/1tQDwPvs1Rqro+s6W4+8OIKLSmfZVqwSNkMZipuZ9b8BuE3TQy10iPxULBL1WNUoJHD6Eg4hTQXDkfMaqIkv8Cd32bBJyxcO9t+aA1GVDJNNBiBGZYA+GIXa0nD5UxPimrioyR/eF7qGdHSZk4zpae+nb81D9oLpgb3ddHErpLlUnIqhawONxuw/nrYQ+RZ2jPbWZ+xTw7S2NBeDC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgwkrHbyHodj6iHYR8WSUeLD7D9iHiAFbkA8XXr2m68=;
 b=sM6NZ1CZOnCthqgK+n+M0akgxPeasYUCieqrNadi3SiwQ1cUPDaVy2ej73r1Ueg0c0VHI7uWgm8L9GNyxUHuM06pK+mGtV4Ma9QVVnP4l2470MS5/1Q0Hr2PYHeo1WNQJSjRKLsAxJI1RAeTJ9VKPbYtgfWWX3ugwkWBW0sM6Ok=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7555.namprd10.prod.outlook.com (2603:10b6:806:378::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Thu, 3 Apr
 2025 14:55:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:55:20 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Ziqi Chen
 <quic_ziqichen@quicinc.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Al
 Viro <viro@zeniv.linux.org.uk>, Eric Biggers <ebiggers@google.com>,
        open
 list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v5 1/1] scsi: ufs: core: add device level exception support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <6278d7c125b2f0cf5056f4a647a4b9c1fdd24fc7.1743198325.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Fri, 28 Mar 2025 14:46:13 -0700")
Organization: Oracle Corporation
Message-ID: <yq14iz5uwfm.fsf@ca-mkp.ca.oracle.com>
References: <6278d7c125b2f0cf5056f4a647a4b9c1fdd24fc7.1743198325.git.quic_nguyenb@quicinc.com>
Date: Thu, 03 Apr 2025 10:55:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0015.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b047f2-957c-42f0-93eb-08dd72bf8df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YWOp54KM3WJDN9GBNKIHtLC0nGFMn/GDxA4+rN8VJaiwWI/nLBfJh+KBkoYQ?=
 =?us-ascii?Q?ZL42Kkvx+gPqxEwGMGmhaYpSc2HzH1kIcSCp5/FG2hb9bA16Qk88qUiU/AzL?=
 =?us-ascii?Q?8KL7pGzn99pTWbz/Qb4/bREmTIDpUUT6RvEp0nFu6UqHil94MVQYv30vHvKz?=
 =?us-ascii?Q?RwuiWde2dQEPTskfVeQLTnfoWn5Noe65ajf/y0VvPyhh+rPUKxSPoAT5cPGO?=
 =?us-ascii?Q?Z0TdyuIk80sMgMLhOsKBOVEoeuKRk3Mwdveelrl6J/13ZNIaYMGYgFYZh6n6?=
 =?us-ascii?Q?/8kWlHc9bxVG1Xct1aiaRWsuytsOm46/qsH3YvCYUZDz0nCqk9SZEzVYWwvl?=
 =?us-ascii?Q?YLhbVpH5dL/RHrKm7tpJUd5Dob+yRKpDRG2jHIK5r4f007/vr/1AkpvpjvZT?=
 =?us-ascii?Q?dsdpGyXo2JMMbLJJI3xwByNtBjiBI6D7fJImcG6ahWdYyBypCiYj6StqH//o?=
 =?us-ascii?Q?26S0UJtPPV0hgoWI66fSJeBEf78793gTKDFVqMLe5Ki1vkb7VgDGGo6oyXX+?=
 =?us-ascii?Q?AcfZZUy8A9gHnbtTiD54AINUepdmbGEmnMYcx+fYnbDEFhsyrLpiMHA6yoVU?=
 =?us-ascii?Q?RLw86/wGibWiMwNj0igt2JN3vHtGG4QRUDR8oqCmAvWxPqF6OvXsmrycw6V/?=
 =?us-ascii?Q?m6XrWVlABBYuoB3Mspa4XdAf/TrfnSvT0VLv5U+CzkP5DHlNHyxjlrTteJV9?=
 =?us-ascii?Q?V35lZYRn3CS9x+yaKBoXkfvZOLK3QYS8j7UekV+jnIR8WZgsaG5lPOZVmcH2?=
 =?us-ascii?Q?zDSWHeS5Jcu44hSIpZqC8rDBNaNXL5WqxMPnN2OGHwuezALhV0NBXou3FkK/?=
 =?us-ascii?Q?iCDASDuuNTAaCvPvo22M/7YQ3adaU1R8Cbsmb2TcTzjbhZcllH107onAeygt?=
 =?us-ascii?Q?nBbA6A6jmT2diwQ1KrLKY/lPY5Rb9lk1bJvrjYLCZsmj8VA6oGpA4NTxyE/q?=
 =?us-ascii?Q?7q0H4uCKEP08k81qMB0gSCg/zQ4P9cz8g9XY4U879v3afakgmJsI+fkl65aG?=
 =?us-ascii?Q?25rzE2bDVxjBJhPggyvnbK0kCva88N0YrjURuyZncLSRchgnrayl89z3nRma?=
 =?us-ascii?Q?m1v0ZIbO8mVq1HVdZC6QcuDzXoTgLxIeDVceCLWzVDKENIf64OT57i2FGGEM?=
 =?us-ascii?Q?BFdY6ifP9usK2w8W3whWonHlZSzpg+ovi+Evk2wDtP4szvGuLbhrTXfd23sS?=
 =?us-ascii?Q?3i1NyKP8cZBzUcanhq6yHdXVnQJu6qx6WTPFN+O5G5aDyqU0sWpD5WakttS4?=
 =?us-ascii?Q?Ko7FWm7TtHBa7XPqvbGkDH2co6WAQaAcBalLNLAc9EClUaT5VUaBD0QYba2T?=
 =?us-ascii?Q?Z2ZKxxNLYJg8N6ubwN37uVUVWDuSocRB5bpkTyb7V572GNDn/be/TRhx05XL?=
 =?us-ascii?Q?OKxcRo4h+IAbIC7BSZCqwd7ezmzz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k/3uAFlSv9FjGbiB6SJKgZ+HMSawVMg/fkhU4I0V0tvcmJkcz73G/NKGd9GL?=
 =?us-ascii?Q?R20271Bb/ceKvT4Ts3N8cSRJCE6qa8cjALYCd8LG8LtgN/t4LCEnKC5mU6Dt?=
 =?us-ascii?Q?MnSKR345fNOVa+DGW9hJJHxAWhRQH2aw4ullb4Zs022dFug4ylIRmVlChp9h?=
 =?us-ascii?Q?maYs+XvqWN6YovDRJIkZmXWj60R6+1Ss8LEAuWPyqZjzMZ8+EhMRWKHqKS/2?=
 =?us-ascii?Q?Y/QaxKXmnYnXAEOVd5xPcz9M73f2TImUBhVNfSEYjQ64b01vjSQVo3m1ucyC?=
 =?us-ascii?Q?mbhMtuYmm7iMRVCX+LgezZPs2bfNdrj8sOtdiIbeX4939ZWsPaXKj4ICv+Mc?=
 =?us-ascii?Q?G3nL6cMGvd0LpIYzkQveg5XJjVRyMdQ12CSnoCoApNVQ3X4Fmev1nAV4okWt?=
 =?us-ascii?Q?52eR+suIqGmiuCV9z10M9tFW5pmATUiMlhSExWX16GgxKH710ZBBXBguYJHf?=
 =?us-ascii?Q?U0byedOTU21SBcz0+KTPHAAebqzQbuV+vzmK6+fpaOKqnx+X6GYWH+58WzOy?=
 =?us-ascii?Q?R/AE4ZgX0IbOaXCQfGagd/dCk8bZF4w04G3KnQjgZVR0EadQUAPBXA7Cc4yA?=
 =?us-ascii?Q?qxKvLPydYdg5Ei1O9pfuscVzopacr21tcX5dfYk2DEyHfDR9pNdIDGvzrlDQ?=
 =?us-ascii?Q?R+cltskBtuD7AlDgyShIKCu5VqC4EouKwvVGSSmfryKN1THEafPF2erxDWMB?=
 =?us-ascii?Q?6lBPEFp+hWB1l/YTcqYLlHra7bnvw8tsqCj05XVDjCj21VnC+PoYQBx1gNlE?=
 =?us-ascii?Q?/xovlo0jtR2GOhFDMU6t4It221Tc+tsC3+c+c57K7rUGCb4XESMe0byKYat0?=
 =?us-ascii?Q?OPl7zuSy9v7WfhxA4L7jRCUX2oYbZAXbtt+l5aLoqNE7eE1/mCxMBQbCUzlI?=
 =?us-ascii?Q?VusYd9gQ2lBJw+3g7KLuJ1nfn/nYKOmYum4ITG7uJ/Od3b4G1ucqDwBDCUAJ?=
 =?us-ascii?Q?gUIlq3R4B4K5dOCagslsVaoC51AYS8oTS5oFoIQ2D0zyXc2QxIKy95Qjpd5Z?=
 =?us-ascii?Q?imvb3Ns46nAJo6xOEYblPNbHYWKeDGRQqegoHR5IH2ngwbqWPhT59pcLvIRG?=
 =?us-ascii?Q?F4sj3P2xtG4kEIXFtJErswKhT0tikDzU8rAqR4ChEUuu4Qj/mel1XM+GXvWo?=
 =?us-ascii?Q?W+32AI59lHvAfU1JWb5Y42Zm15K8xd0APBGHiu65+bbEQSf/mZxK4v9sEWMJ?=
 =?us-ascii?Q?+sBz3XUd9uC9jkzPRPA8vxDcGwXoB2TzpWT8a7CUFC0lgpboNJGYe0L6tKVM?=
 =?us-ascii?Q?TDNwu+mHosGFkVoK/qt17i+j1d0lA7Qcv1X0DK/0EjZNRmi5zSsg9iP3V89e?=
 =?us-ascii?Q?2/eD8lqf18iH1FsJSET4EIrQLRDSbEIQ9PtsEFTQSAWTBB/z86c8WBlPTWIF?=
 =?us-ascii?Q?6+d5iAAety9LxE8Hu5oi53NDUV0RjFIR65BDht4yok8D4kBWqEvyiMrPbN/T?=
 =?us-ascii?Q?F/X/BlT3fJQizZ1jxjg44zFYA6bjB49NwhzSHM3p+0hegbl2xKxqVyLEM1vh?=
 =?us-ascii?Q?JgFJtXtWUcXncgk1v6pDcPiLC7Acg/hqqk2ILnGW78AiQ/Pz246Iqp78JG6b?=
 =?us-ascii?Q?KWLI9t+ZZ1mUvVVEUs2Zusyp/G6mUfesCnKEW/gJnwKyCMNsWEYZPMg6bDtV?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LIbPUvapfsstnHyS6p0Uh9tdL50fTsENSIpwzRF/RaHkcoj+gyD/EtK8zuUFOku55tMThlB/TQvLCjSkJiy1KvJqz2+bZOLcxOcXHdmEudOhPfr73zs9z4n4eKrDqavWbty+ZMJpa8hd4XwRgW4Kk/tKt8seEwIdrU+6dkMFWtAXGkidc8IbuGSTRBIUlFSphmsc7r4VPr31KmBzdzeq0itHMS7wRFGPubdZNFe9kDGpMkZXp+MIp0CPMYSm41H2VrTOfhqa0gQZwnLbiCjI3YZb9zym1Kz8fl3nvR1ki9WFjduSR4lEZDlk1Nrwf4TJPEGDZsUpQ4dDpFlBqHZAPoEpgcUEk1VNucRhFjrEnhpiGsc/uc+9hPIT62bNR8P+t7HtdKJm6S8DGyNTAQeGJzBJFceqsc8cQBsywMpfObzSs6mjHa29W/2b9BgF6WxPeUvO/Vt0db7F+HFL6+mbg3nyTanOtMBCUH3PU0DBLxXTjrtFafz1qDgNWekZoSgPn/kq2vo/Hs/bKxK79fqIuqdqtOKC3UTzZZukXRxWR6E7UIm9j2Ud7WuQoPFxh2JscEDIiEsGIOhpUESoknUhIx5pGe8Xg5QLfukS6NJFrFU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b047f2-957c-42f0-93eb-08dd72bf8df8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:55:20.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enOPpd8U3AwL9Wjz37x4uxVMcvhWHw7KOBJYrAU34CGETSlPw2DpzYGu2WhLxPArZK4JGpvz9dzXWc7CTwnbzjWjkqQuFK74T1C8qOLV7sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030070
X-Proofpoint-ORIG-GUID: uImLyoGDk-QXNOsnJz5hjoP8-4XwrP1c
X-Proofpoint-GUID: uImLyoGDk-QXNOsnJz5hjoP8-4XwrP1c


Bao,

> The ufs device JEDEC specification version 4.1 adds support for the
> device level exception events. To support this new device level
> exception feature, expose two new sysfs nodes below to provide the
> user space access to the device level exception information.
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
